package control
{
    import control.WxShareC;

    import laya.display.Animation;

    import laya.net.Loader;

    import laya.utils.Handler;

    import manager.AnimalManger;

    import manager.ApiManager;
    import manager.ConfigManager;
    import manager.GameEvent;
    import manager.GameEventDispatch;

    import model.LoginInfoM;

    /**
     * ...
     * @author
     * 接口文档：http://183.131.147.91:8890/web/#/19
     */
    public class WxShareC
    {
        private static var _instance:WxShareC;

        public function WxShareC()
        {

        }

        // 接口地址
        public static var wxLogin:String = '/minilogin'; // 记录微信用户登陆信息
        public static var wxGroup:String = '/collect/share'; // 记录转发用户和微信群的对应关系
        public static var wxNewUser:String = ''; // 记录转发用户和邀请用户对应关系
        public static var wxUser:String = '/collect/invite'; // 记录转发用户和助阵用户对应关系
        public static var wxDecryptData:String = '/decrypt'; // 解密数据
        public static var miniProgramArr:Array = []//跳转小游戏列表
        public static var indexMiniProgram:Number = 0
        public static var loadResSuccess = false

        public function getMiniProgram()
        {
//            loadRes()
            if (WxC.isInMiniGame())
            {
                ApiManager.instance.get_game_jump_list(Handler.create(this, function (res)
                {
                    if (res.code == "success")
                    {
                        miniProgramArr = res.data
                        loadRes()
                    }
                }), null)

            }
        }

        private var _adAnis:Array = []


        public function adAni():Animation
        {
            return _adAnis[indexMiniProgram];
        }

        public function initAni():void
        {
            if (miniProgramArr.length > 0)
            {
                for (var i = 0; i < miniProgramArr.length; i++)
                {
                    var adAni:Animation = AnimalManger.instance.load(WxShareC.miniProgramArr[i].img)
                    adAni.visible = true
                    adAni.play(0, true)
                    adAni.name = "ad_btn"
                    _adAnis.push(adAni)
                }
            }

        }

        private function loadRes():void
        {
            if (miniProgramArr.length > 0)
            {
                var arr:Array = new Array();
                for (var i = 0; i < miniProgramArr.length; i++)
                {

                    arr.push({url: "res/atlas/ani/" + miniProgramArr[i].img + ".atlas", type: Loader.ATLAS});
                }

                Laya.loader.load(arr, Handler.create(this, function (isSuccess:Boolean)
                {
                    if (isSuccess)
                    {
                        loadResSuccess = true
                        initAni()
                        GameEventDispatch.instance.event(GameEvent.LoadMiniAdRes)
                    }
                }), Handler.create(this, function (res)
                {

                }, null, false));

            }
        }

        public static function getCurMiniPro():Object
        {
            if (miniProgramArr && miniProgramArr.length > 0)
            {
                return miniProgramArr[indexMiniProgram]
            }
        }

        public static function updataIndexMiniPro()
        {
            indexMiniProgram++;
            if (indexMiniProgram >= miniProgramArr.length)
            {
                indexMiniProgram = 0
            }
        }

        public static function navigateToMiniProgram()
        {
            if (isInMiniGame())
            {
                var obj:Object = getCurMiniPro()
                if (obj)
                {
                    var params:Object = new Object();
                    params.appId = obj.appid;
                    params.path = ''
                    params.envVersion = obj.envVersion
                    params.extraData = {
                        from_game: obj.from_game
                    }
                    params.success = toMiniProgram_success;
                    __JS__("wx").navigateToMiniProgram(params);
                }
            }
        }

        // 获取跳转小游戏参数
        public static function getFromMiniProgramInfo():String
        {
            if (isInMiniGame())
            {
                var res:Object = __JS__("wx").getLaunchOptionsSync()
                if (!res)
                {
                    return ""
                }
                var referrerInfo:Object = res.referrerInfo;
                if (!referrerInfo)
                {
                    return ""
                }
                var extraData:Object = referrerInfo.extraData
                if (!extraData)
                {
                    return ""
                }
                var from_game:String = extraData["from_game"]
                if (from_game)
                {
                    return from_game
                }
            }

            return "";
        }

        public static function toMiniProgram_success(res):void
        {
            trace("toMiniProgram_success", res)
        }


        // 客户端调用接口
        public static function wxShare(type = 1, eventType = 1, query = ''):void
        {
            // type 1：主动转发，2：被动转发
            var shareInfo:Object = initShareInfo(eventType);
            shareInfo.query = query;
            if (type === 1)
            {
                updateShareMenu(shareInfo, type);
            } else if (type === 2)
            {
                showShareMenu(shareInfo, type);
            }
        }

        // 初始化分享内容
        public static function initShareInfo(eventType):Object
        {
            var shareInfoList:Object = ConfigManager.items('cfg_share');
            if (shareInfoList.length === 0)
            {
                return {
                    title: '',
                    imageUrl: '',
                    imageUrlId: '',
                    success: shareSuccess
                };
            }
            var shareTypeList:Array = [];
            var shareData:Object;
            for (var i:int = 0; i < shareInfoList.length; i++)
            {
                if (shareInfoList[i].event_type === eventType)
                {
                    shareTypeList.push(shareInfoList[i]);
                }
            }
            var randomNum:int = Math.floor(Math.random() * shareTypeList.length);
            shareData = shareTypeList[randomNum];
            var shareInfo:Object = {
                title: shareData.title,
                imageUrl: shareData.image,
                imageUrlId: shareData.imageUrlId,
                success: shareSuccess
            };
            return shareInfo;
        }

        // 是否微信小游戏
        public static function isInMiniGame():Boolean
        {
            var wx = __JS__("window.wx")
            if (wx)
            {
                return true
            } else
            {
                return false
            }
        }

        // 显示被动分享按钮
        public static function showShareMenu(shareInfo, type = 1, withShareTicket = true):void
        {
            if (isInMiniGame())
            {
                __JS__("wx").showShareMenu({
                    withShareTicket: withShareTicket,
                    success: function ()
                    {
                        updateShareMenu(shareInfo, type, withShareTicket);
                    }
                });
            }
        }

        // 设置微信分享参数
        public static function updateShareMenu(shareInfo, type = 1, withShareTicket = true):void
        {
            // type 1：主动转发，2：被动转发
            /**
             * 如果设置 withShareTicket 为 true ，会有以下效果
             * 1.选择联系人的时候只能选择一个目标，不能多选
             * 2.消息被转发出去之后，在会话窗口中无法被长按二次转发
             * 3.消息转发的目标如果是一个群聊，则会在转发成功的时候获得一个 shareTicket
             * 4.每次用户从这个消息卡片进入的时候，也会获得一个 shareTicket，通过调用 wx.getShareInfo() 接口传入 shareTicket 可以获取群相关信息(shareTicket通过wx.getLaunchOptionsSync()获取)
             */
            /**
             * type = 3时，传入 isUpdatableMessage: true，以及 templateInfo、activityId 参数
             * templateInfo{
			* parameterList: [{
			* name: '', // 参数名，name 的合法值：member_count/room_limit/path/version_type为合法值
			* (member_count // target_state = 0 时必填，文字内容模板中 member_count 的值)
			* (room_limit // target_state = 0 时必填，文字内容模板中 room_limit 的值)
			* (path // target_state = 1 时必填，点击「进入」启动小程序时使用的路径。
			对于小游戏，没有页面的概念，可以用于传递查询字符串（query），如 "?foo=bar")
			* (version_type // target_state = 1 时必填，点击「进入」启动小程序时使用的版本。
			有效参数值为：develop（开发版），trial（体验版），release（正式版）)
			* value: '', // 参数值
			* }]
			* }
             *
             * 动态消息发出去之后，可以通过 setUpdatableMsg 修改消息内容
             */
            __JS__("wx").updateShareMenu({
                withShareTicket: withShareTicket, // 是否使用带shareTicket的转发
                // isUpdatableMessage: isUpdatableMessage, // 是否是动态消息
                // activityId: activityId, // 动态消息的 activityId。通过 createActivityId 接口获取
                // templateInfo: templateInfo, // 动态消息的模板信息
                success: function (res)
                {
                    // 接口调用成功的回调函数
                    if (type === 1)
                    {
                        shareAppMessage(shareInfo);
                    } else if (type === 2)
                    {
                        onShareAppMessage(shareInfo);
                    }
                },
                fail: function (err)
                {
                    // 接口调用失败的回调函数
                    console.log(err);
                },
                complete: function (obj)
                {
                    // 接口调用结束的回调函数（调用成功/失败都会执行）
                }
            })
        }

        // 主动转发
        public static function shareAppMessage(shareInfo):void
        {
            /**
             * shareInfo {
			* title: title, // 转发标题，不传则默认使用当前小游戏的昵称
			* imageUrl: imageUrl, // 转发显示图片的链接，可以是网络图片路径或本地图片文件路径或相对代码包根目录的图片文件路径。显示图片长宽比是 5:4
			* query: query, // 查询字符串，从这条转发消息进入后，可通过 wx.getLaunchOptionsSync() 或 wx.onShow() 获取启动参数中的 query。必须是 key1=val1&key2=val2 的格式。
			* imageUrlId: imageUrlId // 审核通过的图片 ID (图片编号和图片地址必须一起使用，缺一不可)
			* success: function (res) {}, // 分享成功回调函数
			* fail: function (err) {}, // 分享失败回调函数
			* complete: function () {} // 接口调用结束的回调函数（调用成功/失败都会执行）
			* }
             */
            __JS__("wx").shareAppMessage({
                title: shareInfo.title,
                imageUrl: shareInfo.imageUrl,
                query: shareInfo.query,
                imageUrlId: shareInfo.imageUrlId,
                success: shareInfo.success,
                fail: function (err)
                {
                    // 转发失败回调
                    console.log(err);
                }
            })
        }

        // 被动转发
        public static function onShareAppMessage(shareInfo):void
        {
            /**
             * shareInfo {
			* title: title, // 转发标题，不传则默认使用当前小游戏的昵称
			* imageUrl: imageUrl, // 转发显示图片的链接，可以是网络图片路径或本地图片文件路径或相对代码包根目录的图片文件路径。显示图片长宽比是 5:4
			* query: query, // 查询字符串，从这条转发消息进入后，可通过 wx.getLaunchOptionsSync() 或 wx.onShow() 获取启动参数中的 query。必须是 key1=val1&key2=val2 的格式。
			* imageUrlId: imageUrlId // 审核通过的图片 ID (图片编号和图片地址必须一起使用，缺一不可)
			* success: function (res) {}, // 分享成功回调函数
			* fail: function (err) {}, // 分享失败回调函数
			* complete: function () {} // 接口调用结束的回调函数（调用成功/失败都会执行）
			* }
             */

            __JS__("wx").onShareAppMessage(function ()
            {
                // 用户点击了“转发”按钮
                return {
                    title: shareInfo.title,
                    imageUrl: shareInfo.imageUrl,
                    query: shareInfo.query,
                    imageUrlId: shareInfo.imageUrlId,
                    success: shareInfo.success,
                    fail: function (err)
                    {
                        // 转发失败回调
                        console.log(err);
                    }
                };
            })
        }

        // 分享成功回调
        public static function shareSuccess(res):void
        {
            console.log('分享成功回调');
            if (res.shareTicket)
            {
                // 获取转发详情
            }
        }

        // 获取转发携带参数
        public static function getLaunchOptionsSync():Object
        {
            /**
             * 返回信息
             * {
			*   scene: number, // 启动小游戏的场景值
			*   query: {}, // 启动小游戏的query参数
			*   shareTicket: '', // shareTicket,当转发参数withShareTicket为true时该参数有值
			*   referrerInfo: {}, // 来源信息。从另一个小程序、公众号或 App 进入小程序时返回。否则返回 {}
			* }
             */
            var launchOptions:Object = __JS__("wx").getLaunchOptionsSync();
            // 记录当前用户和转发用户对应信息
            var uid:int = LoginInfoM.instance.uid; // 当前登陆用户uid
            if (launchOptions.shareTicket)
            {
                // 转发到群
                getShareInfo(launchOptions.shareTicket, uid);
            } else if (launchOptions.query.uid)
            {
                // 转发到个人
                shareToUser(uid, launchOptions.query.uid);
            }

            return launchOptions;
        }

        // 通过shareTicket获取转发到群详情
        public static function getShareInfo(shareTicket, uid):void
        {
            __JS__("wx").getShareInfo({
                shareTicket: shareTicket,
                success: function (res)
                {
                    var encryptedData:String = res.encryptedData; // 加密数据，需解密
                    var iv:String = res.iv; // 加密算法的初始向量
                    decryptData(uid, encryptedData, iv);
                }
            });
        }

        // 获取解密数据
        public static function decryptData(uid, encryptedData, iv):void
        {
            __JS__("wx").request({
                method: "POST",
                url: 'https://' + ENV.FAKE_API_DOMAIN + wxDecryptData,
                data: {
                    game_id: ENV.game_key(),
                    uid: uid,
                    encryptedData: encryptedData,
                    iv: iv
                },
                success: function (res)
                {
                    // 解密成功
                    var decryptData:Object = JSON.parse(res.data.data);
                    // 记录转发信息
                    shareToGroup(decryptData.openGId);
                }
            })
        }

        // 记录转发用户和当前登陆用户对应关系
        public static function shareToUser(uid, inviteUid):void
        {
            __JS__("wx").request({
                method: "POST",
                url: 'https://' + ENV.FAKE_API_DOMAIN + wxUser,
                data: {
                    game_id: ENV.game_key(),
                    u_uid: uid,
                    invite_u_uid: inviteUid
                },
                success: function (res)
                {
                    // 记录成功
                }
            })
        }

        // 记录转发用户和微信群对应关系
        public static function shareToGroup(openGId):void
        {
            console.log('openGId:' + openGId);
            __JS__("wx").request({
                method: "POST",
                url: 'https://' + ENV.FAKE_API_DOMAIN + wxGroup,
                data: {
                    game_id: ENV.game_key(),
                    u_uid: LoginInfoM.instance.uid,
                    group_info: openGId
                },
                success: function (res)
                {
                    // 记录成功
                }
            })
        }

        // 对用户托管数据进行写数据操作，允许同时写多组KV数据
        public static function setUserData(KVDataList):void
        {
            /**
             * KVDataList数据格式
             * 1.每个openid所标识的微信用户在每个游戏上托管的数据不能超过128个key-value对
             * 2.上报的key-value列表当中每一项的key+value长度都不能超过1K(1024)字节
             * 3.上报的key-value列表当中每一个key长度都不能超过128字节
             * [{
			 *   "wxgame": {
			 *	   "score": xxx, // Int32
			 *	   "update_time": xxx // Int64
			 *	 }, // wxgame格式固定，用于把游戏的排行榜显示于小游戏中心，其他同级字段可自定义
			 *   "key2": "value2"
			 * }]
             */
            __JS__("wx").setUserCloudStorage({
                KVDataList: KVDataList,
                success: function (res)
                {
                    console.log(res.data);
                }
            })
        }

        // 获取玩该小游戏的好友的用户数据
        public static function getFriendData(keyList):void
        {
            /**
             * keyList: ['key1', 'key2']
             */
            __JS__('wx').getFriendCloudStorage({
                keyList: keyList,
                success: function (res)
                {
                    console.log(res);
                    // const data = res.data;
                },
                fail: function (err)
                {
                    console.log(err);
                }
            })
        }

        // 在某个群中也玩该小游戏的成员的用户数据
        public static function getGroupData(shareTicket, keyList):void
        {
            __JS__("wx").getGroupCloudStorage({
                shareTicket: shareTicket, // 群分享对应的shareTicket
                keyList: keyList, // 要拉取的key列表
                success: function (res)
                {
                    console.log(res.data.KVDataList);
                }
            })
        }

        public static function get instance():WxShareC
        {
            return _instance || (_instance = new WxShareC())
        }
    }

}