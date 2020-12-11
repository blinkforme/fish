package view.load
{
    import control.AiqiyiC;
    import control.CocosC;
    import control.WxC;
    import control.WxC;
    import control.WxShareC;
    import control.YylyC;

    import engine.analysis.BuriedManager;
    import engine.analysis.BuriedTypes;
    import engine.tool.StartParam;
    import engine.ui.component.RewriteManager;

    import fight.Bullet;
    import fight.BulletInfo;
    import fight.FightManager;
    import fight.Fish;

    import laya.ani.bone.Templet;
    import laya.display.Sprite;
    import laya.events.Event;
    import laya.maths.Rectangle;
    import laya.media.SoundManager;
    import laya.net.Loader;
    import laya.net.ResourceVersion;
    import laya.ui.Box;
    import laya.ui.HScrollBar;
    import laya.ui.Image;
    import laya.ui.ScrollBar;
    import laya.utils.Browser;
    import laya.utils.Handler;

    import manager.ApiManager;
    import manager.ConfigManager;
    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.GameTools;
    import manager.ResVo;
    import manager.SpineTemplet;
    import manager.UiManager;
    import manager.WebSocketManager;

    import model.LoadResM;
    import model.LoadTipM;
    import model.LoginInfoM;
    import model.LoginM;
    import model.RoleInfoM;
    import model.SmallM;
    import model.WxM;

    import struct.QuitTipInfo;

    import ui.abbey.LoadPageUI;

    import view.fish.GoodsFlyEffect;

    public class LoadPageView extends LoadPageUI implements ResVo
    {
        private var resArray:Array;  //需要加载资源
        private var _spineArray:Array; //需要加载的动画
        private var _state:Number; //加载的状态
        private var _mFactory:Templet;
        private var _spineNum:int = -1;
        private var _startLoadSpine:Boolean = false;
        private var _isFirstWait:Boolean = true;
        private var _firstLoadFishState:Boolean = true;

        public function LoadPageView()
        {
            LoginM.instance.resArr = LoadResM.instance.firstArr;
            LoginM.instance.loginState = GameConst.loadMainState;
            LoginM.instance.spineArr = LoadResM.instance.firstSpineArr;

            if (LoginInfoM.instance.fromAndroid())
            {
                var timeStamp:* = RoleInfoM.instance.getTimeStamp();
                __JS__("AndroidInterface.setTimeStamp(timeStamp)");
            }

            initInfo(null, false);
            super();
        }

        private var privacyBox:Box;
        private var privacyArr:Array;
        private var gameBox:Box;
        private var gameArr:Array;


        public function StartGames(parm:Object = null):void
        {
            if (!gameBox)
            {
                gameBox = new Box()
            }
            if (!privacyBox)
            {
                privacyBox = new Box();
            }
            linkPanel.visible = false;
            gamePanel.visible = false;
            linkBox.visible = false;
            closeWeb.visible = false;
            waitBox.visible = false;
            tipText.visible = false;
            progressBar.value = 0;
            progressBar.visible = false;
            sideobox.visible = false;
            loadTxt.visible = false;
            _spineNum = -1;
            _startLoadSpine = true;
            screenResize();
            loadLoginn();
            setGameVersionNum()
            console.log("loadpage StartGames")
        }

        private function setGameVersionNum():void
        {
            var versionStr:String = "本网络游戏适合6周岁以上用户使用；请您确定已如实进行实名注册；为了您的健康，请合理控制游戏时间。\n抵制不良游戏，拒绝盗版游戏。 注意自我保护，谨防受骗上当。 适度游戏益脑，沉迷游戏伤身。 合理安排时间，享受健康生活。";
            if (LoginInfoM.instance.fromQuick())
            {
                versionStr = versionStr + "\n著作权人：金华市亿博网络科技有限公司 软件著作权登记号：2018SR027711 游戏版号ISBN：978-7-7979-0542-8"
            }
            game_version.text = versionStr;
        }

        public function loadLoginn():void
        {
            resArray = LoginM.instance.resArr;
            _state = LoginM.instance.loginState;
            _spineArray = LoginM.instance.spineArr;

            if (WxC.isInMiniGame() && (!WxC.wxminiCode || WxC.wxminiCode.length <= 0))
            {
                tipText.text = "开始微信授权";
                WxC.wx_login();
            } else if (StartParam.instance.getParam("platform") && StartParam.instance.getParam("platform") == GameConst.platform_yyly)
            {
                tipText.text = "yy联运授权";
                YylyC.config();
            } else if (StartParam.instance.getParam("platform") && StartParam.instance.getParam("platform") == GameConst.platform_cocos)
            {
                CocosC.init()
            } else
            {
                loginState(_state);
            }
        }

        private function loadConfigCallBack(data:*):void
        {

            ConfigManager.init();
            WxShareC.instance.getMiniProgram()
            LoginM.instance.resArr = LoadResM.instance.firstArr;
            LoginM.instance.loginState = GameConst.loadMainState;
            LoginM.instance.spineArr = LoadResM.instance.firstSpineArr;
            resArray = LoginM.instance.resArr;
            _state = LoginM.instance.loginState;
            _spineArray = LoginM.instance.spineArr;
            confirm();
        }

        private function loadMainFest():void
        {
            Laya.loader.load([{
                url: ConfigManager.getConfigPath(),
                type: "json"
            }], Handler.create(this, loadConfigCallBack));
        }

        private function wxMiniLoginComplete():void
        {

            if (WxC.wxminiCode && WxC.wxminiCode.length > 0)
            {
                tipText.text = "微信授权成功";
                loginState(_state);
            } else
            {
                //微信授权失败
                tipText.text = "微信授权失败";
            }
        }

        private function yylyLoginComplete():void
        {
            loginState(_state);
        }

        private function cocosNativeLoginSuccess():void
        {
            console.log("cocosLoginComplete")
            loginState(_state);
        }


        private function refreshContent():void
        {
            loadTxt.text = LoadTipM.instance.showContent;

        }

        public function loginState(state:Number):void
        {

            switch (state)
            {
                case GameConst.loadMainState:
                {
                    startLoad();
                    break;
                }
                case GameConst.loadFishState:
                {
                    unStartLoad();
                    break;
                }
                default:
                {
                    break;
                }
            }
        }

        private function initInfo(data:*, isHaveVersion:Boolean = false):void
        {
            if (!data)
            {

            } else
            {
                if (isHaveVersion)
                {
                    StartParam.instance.parseParam({
                        version: data.version
                    });
                }
                WxM.instance.isShow = (data.is_open_share == 1);
                WxC.accessToken = data.access_token;


                StartParam.instance.parseParam(
                        {
                            mini_server_domain: data.mini_server_domain,
                            mini_server_name: data.mini_server_name,
                            server_domain: data.server_domain,
                            server_name: data.server_name,
                            access_token: data.access_token,
                            jjhid: data.jjhid,
                            uid: data['uid'],
                            user_status: data.user_status,
                            is_new: data.is_new,
                            is_open_bank: data.is_open_bank,
                            provider_id: data.provider_id,
                            is_display_public_no_subscribe: data.is_display_public_no_subscribe,
                            ctime: parseInt(data.ctime),
                            is_open_store: data.is_open_store,
                            platform: data.platform,
                            game_status: data['game_status'],
                            config_version: data["config_version"],
                            second_config_version: data["second_config_version"],
                            r_p_a: data["r_p_a"]
                        }
                )

                var token = StartParam.instance.getParam("access_token")

                if (WxC.isInMiniGame())
                {
                    ApiManager.instance.get_user_sub(token, Handler.create(this, function (res)
                    {
                        var data = res.data;
                        if (res.code == "success")
                        {
                            RoleInfoM.instance.subscribe_tpl = data.tpl;
                            trace("get_user_sub", res)
                        }
                    }), Handler.create(this, function (res)
                    {

                    }))
                }
            }
        }

        private function yylyLoginSuccess(result:*):void
        {
            if (result.status)
            {
                var data:Object = result.data;

                initInfo(data, true);

                tipText.text = "加载外公告";
                GameEventDispatch.instance.event(GameEvent.CloseReset);
                YylyC.is_new = data.is_new;
                YylyC.roleId = data.uid;
                YylyC.roleName = data.nickname;
                if (data.is_new == 1)
                {
                    YylyC.ReachCreateRoleScene();
                    YylyC.CreateRole(data.uid, data.nickname);
                }
                console.log("yy_version", StartParam.instance.getParam("version"))
                //激活资源版本控制，版本文件由发布功能生成
                ResourceVersion.enable(StartParam.instance.getParam("version"), Handler.create(this, this.getAnnounce), ResourceVersion.FILENAME_VERSION);
                BuriedManager.instance.addBuriedData(BuriedTypes.login_success)
            } else
            {
                if (YylyC.yylyLoginCount <= 0)
                {
                    YylyC.yylyLoginCount = 1;
                    loadLoginn();
                } else
                {
                    UiManager.instance.loadView("ResetLogin");
                }
                return;
            }
        }

        private function t360LoginSuccess(result:*):void
        {
            console.log("t360LoginSuccess")
            console.log(result)

            if (result.status)
            {
                var data:Object = result.data;

                initInfo(data, false);

                tipText.text = "加载外公告";
                GameEventDispatch.instance.event(GameEvent.CloseReset);
                if (data.is_new == 1)
                {
                }
                BuriedManager.instance.addBuriedData(BuriedTypes.login_success)
                ApiManager.instance.get_announce("outside", Handler.create(this, completeHandler), Handler.create(this, error), WxC.server_name);
            } else
            {

            }
        }

        //加载外公告
        private function wxminiLoginSuccess(result:*):void
        {
            if (result.status)
            {
                var data:Object = result.data;
                if (!data.version || data.version.length <= 0)
                {
                    if (StartParam.instance.getParam("env") == ENV.PROD_ENV && ApiManager.instance.API_URL != ENV.MINI_API_URL)
                    {
                        WxC.getLaunchADInfo();
                        var obj = WxC.getLaunchChannel();
                        var str = ""
                        if (obj)
                        {
                            for (var i in obj)
                            {
                                str += "&" + i + "=" + obj[i]
                            }
                        }

                        ApiManager.instance.API_URL = ENV.MINI_API_URL;
                        var params:String = "js_code=" + WxC.wxminiCode + "&nickname=" + WxC.wxminiName + "&avatar=" + WxC.wxminiAvatar + "&version=" + ENV.game_version + "&public_no_id=" + ENV.channelType + "&model=" + WxC.model +
                                "&channel=" + WxC.wxminiAD_channel + "&gdt_vid=" + WxC.wxminiAD_gdt_vid + "&aid=" + WxC.wxminiAD_aid + "&game_from="
                                + WxShareC.getFromMiniProgramInfo() + str;
                        ApiManager.instance.wxminiLogin(params, Handler.create(this, wxminiLoginSuccess), Handler.create(this, wxminiLoginFail));
                    } else
                    {
                        UiManager.instance.loadView("ResetLogin");
                    }
                    return;
                }

                initInfo(data, true);

                tipText.text = "加载外公告";
                GameEventDispatch.instance.event(GameEvent.CloseReset);
                console.log("wx_version", StartParam.instance.getParam("version"))
                //激活资源版本控制，版本文件由发布功能生成
                ResourceVersion.enable(StartParam.instance.getParam("version"), Handler.create(this, this.getAnnounce), ResourceVersion.FILENAME_VERSION);
                BuriedManager.instance.addBuriedData(BuriedTypes.login_success)
            } else
            {
                if (WxC.wxminiLoginCount <= 0)
                {
                    WxC.wxminiLoginCount = 1;
                    WxC.wxminiCode = "";
                    loadLoginn();
                } else
                {
                    UiManager.instance.loadView("ResetLogin");
                }
                return;
            }
        }

        private function getAnnounce():void
        {
            ApiManager.instance.get_announce("outside", Handler.create(this, completeHandler), Handler.create(this, error), WxC.server_name);
        }


        private function wxminiLoginFail():void
        {
            var params:String = "js_code=" + WxC.wxminiCode + "&nickname=" + WxC.wxminiName + "&avatar=" + WxC.wxminiAvatar +
                    "&ch=" + WxC.getLaunchChannel() + "&version=" + ENV.game_version + "&public_no_id=" + ENV.channelType;
            //ApiManager.instance.wxminiLogin(params, Handler.create(this, wxminiLoginSuccess), Handler.create(this, wxminiLoginFail));

        }

        private function yylyLoginFail():void
        {

        }

        private function t360LoginFail():void
        {

        }

        private function startReset():void
        {
            loadLoginn();
        }


        //提示服务器已满
        private function tipServer():void
        {
            var info:QuitTipInfo = new QuitTipInfo();
            info.state = GameConst.quit_state_left_cancel_right_confirm;
            info.content = "服务器已满是否重新连接";
            info.confirmMsg = GameEvent.WxResetLogin;
            info.autoCloseTime = 10;
            GameEventDispatch.instance.event(GameEvent.QuitTip, info);
        }


        private function startLoad():void
        {
            var params:String;
            var platform:* = getUrlParamValue("platform");
            var ch = JSON.stringify(WxC.getLaunchChannel())
            if (WxC.isInMiniGame())
            {
                tipText.text = "请求中心服务器分配游戏服务器";
                WxC.getLaunchADInfo()
                params = "js_code=" + WxC.wxminiCode + "&nickname=" + WxC.wxminiName + "&avatar=" + WxC.wxminiAvatar + "&version=" + ENV.game_version + "&public_no_id=" + ENV.channelType + "&model=" + WxC.model +
                        "&channel=" + WxC.wxminiAD_channel + "&gdt_vid=" + WxC.wxminiAD_gdt_vid + "&aid=" + WxC.wxminiAD_aid + "&game_from="
                        + WxShareC.getFromMiniProgramInfo();
                ApiManager.instance.wxminiLogin(params, Handler.create(this, wxminiLoginSuccess), Handler.create(this, wxminiLoginFail));
            } else if (platform && platform == GameConst.platform_yyly)
            {
                tipText.text = "yy联运授权";
                params = "sid=" + YylyC.yy_sid;
                ApiManager.instance.yylyLogin(params, Handler.create(this, yylyLoginSuccess), Handler.create(this, yylyLoginFail));
            } else if (platform && platform == GameConst.platform_360)
            {
                tipText.text = "360";
                params = "";
                BuriedManager.instance.addBuriedData(BuriedTypes.login_success);
                ApiManager.instance.get_announce("outside", Handler.create(this, completeHandler), Handler.create(this, error), WxC.server_name);

            } else if (platform && platform == GameConst.platform_cocos)
            {
                var param:String = "userId=" + CocosC.loginParam["userId"] + "&nickName=" + CocosC.loginParam["nickName"] + "&headUrl=" + CocosC.loginParam["headUrl"]
                        + "&version=" + ENV.game_version
                ApiManager.instance.cocosLogin(param, Handler.create(this, cocosApiLoginSuccess), Handler.create(this, cocosLoginFail))
            } else
            {
                tipText.text = "加载外公告";
                if (StartParam.instance.getParam("env") == "prod")
                {
                    BuriedManager.instance.addBuriedData(BuriedTypes.login_success);
                }
                ApiManager.instance.get_announce("outside", Handler.create(this, completeHandler), Handler.create(this, error), WxC.server_name);
            }
        }

        private function cocosApiLoginSuccess(result:*):void
        {
            console.log("cocosApiLoginSuccess")
            console.log(result.status)
            if (result.status)
            {
                var data:Object = result.data;

                initInfo(data, true);

                tipText.text = "加载外公告";
                GameEventDispatch.instance.event(GameEvent.CloseReset);
                //激活资源版本控制，版本文件由发布功能生成
                ResourceVersion.enable(StartParam.instance.getParam("version"), Handler.create(this, this.getAnnounce), ResourceVersion.FILENAME_VERSION);
                BuriedManager.instance.addBuriedData(BuriedTypes.login_success)
            } else
            {
                //                if (YylyC.yylyLoginCount <= 0)
                //                {
                //                    YylyC.yylyLoginCount = 1;
                //                    loadLoginn();
                //                } else
                //                {
                //                    UiManager.instance.loadView("ResetLogin");
                //                }
                //                return;
            }

        }


        public function cocosLoginFail():void
        {
            console.log("cocosLoginFail")

        }


        private function unStartLoad():void
        {

            progressBar.visible = true;
            sideobox.visible = false;
            loadTxt.visible = true;
            progressBar.value = 0;
            loadTxt.text = LoadTipM.instance.showContent;
            Laya.timer.loop(2000, this, refreshContent);
            Laya.loader.load(resArray, Handler.create(this, loadSpineFactory), Handler.create(this, onProgress, null, false));
            Laya.loader.on(Event.ERROR, this, onerror);
        }


        //请求失败
        private function error(msg:Object):void
        {
            loadMainFest();
        }

        private function confirm():void
        {
            progressBar.visible = true;
            progressBar.value = 0;
            sideobox.visible = false;
            loadTxt.visible = true;
            loadTxt.text = LoadTipM.instance.showContent;
            Laya.timer.loop(2000, this, refreshContent);
            Laya.loader.load(resArray, Handler.create(this, function (isSucess:Boolean)
            {
                if (isSucess)
                {
                    loadSpineFactory();
                } else
                {
                    confirm();
                }
            }), Handler.create(this, onProgress, null, false));
            Laya.loader.on(Event.ERROR, this, onerror);


        }

        private function showQuitBtn()
        {
            if (!quitBtn)
            {
                return false
            }

            if (WxC.isInMiniGame())
            {
                return true
            } else if (LoginInfoM.instance.fromAndroid())
            {
                return true
            } else
            {
                return false
            }
        }

        private function completeHandler(msg:Object):void
        {
            waitBox.visible = false;
            var m:Array = msg.data.notice
            AiqiyiC.instance.DataSendMessge();
            StartParam.instance.parseParam(
                    {
                        provider_tel: msg.data.tel
                    });
            if (m && m.length != 0 && ENV.branchSwitch("outSideNotice"))
            {
                sideobox.visible = true;
                var n:Object = m[0];
                var z:String = n.content;
                var type:int = n.btn_type;
                if (type == 0)
                {
                    confirmBtn.visible = false;
                    if (showQuitBtn())
                    {
                        quitBtn.visible = true;
                    }
                } else
                {
                    confirmBtn.visible = true;
                    if (showQuitBtn())
                    {
                        quitBtn.visible = false;
                    }
                }

                conTxt.text = "    " + z;
                var c:String = n.link
                contenturl.anchorX = 0.5;
                contenturl.anchorY = 0.5;
                contenturl.text = c;
                contenturl.on(Event.CLICK, this, click, [c]);
                confirmBtn.on(Event.CLICK, this, loadMainFest);
                sideobox.visible = true;
            } else
            {
                loadMainFest();
            }
            if (quitBtn)
            {
                quitBtn.on(Event.CLICK, this, clickQuit);
            }
            WxC.wxRequest();
        }

        private function clickQuit():void
        {
            GameEventDispatch.instance.event(GameEvent.ExitsGame);
        }

        private function click(data:String):void
        {
            //Laya.Browser.window.open(data);

        }

        //资源加载失败的回调方法
        private function onerror():void
        {


        }

        //资源加载过程中
        private function onProgress(pro:Number):void
        {
            progressBar.value = pro * 0.8;
        }

        private function screenResize():void
        {
            bg_img.width = 1280;
            bg_img.height = 720;
            if ((Laya.stage.height / Laya.stage.width) > (720 / 1280))
            {
                bg_img.height = Laya.stage.height;
            } else
            {
                bg_img.width = Laya.stage.width;
            }
            this.size(Laya.stage.width, Laya.stage.height);

            progressBar.x = Laya.stage.width / 2;
            //            if (GameTools.notch() ==)
            //            {
            //
            //            } else
            //            {
            //
            //            }
        }

        public function playBgMusic():void
        {
            var musicPath:String = ConfigManager.getConfValue("cfg_scene", 1, "backMusic") as String;
            SoundManager.playMusic(musicPath);
        }

        //private var _mFactory:Templet;
        //private var _spineNum:int = -1;

        //加载骨骼动画工厂
        private function loadSpineFactory():void
        {
            if (_startLoadSpine)
            {
                _startLoadSpine = false;
            }
            if (_spineArray.length > 0)
            {
                if (_spineNum < 0)
                {
                    _spineNum = _spineArray.length;
                }
                progressBar.value = 0.8 + 0.2 * (_spineNum - _spineArray.length) / _spineNum;
                var path:String = _spineArray[0];
                if (SpineTemplet.isPathCache(path))
                {
                    _spineArray.splice(0, 1);
                    loadSpineFactory();
                } else
                {
                    _mFactory = new Templet();
                    _mFactory.on(Event.COMPLETE, this, loadSpineComplete);
                    _mFactory.loadAni(path);
                }


            } else
            {
                progressBar.value = 1
                Laya.timer.frameOnce(3, this, showLinkBox);
            }
        }

        private function loadSpineComplete():void
        {
            var path:String = _spineArray[0];
            SpineTemplet.addFactoryCache(_mFactory, path);
            //			var sketleton:Skeleton = _mFactory.buildArmature(0);
            //			sketleton.showSkinByIndex(1);
            _spineArray.splice(0, 1);
            Laya.timer.frameOnce(1, this, loadSpineFactory);
            //			loadSpineFactory();
        }

        private function showLinkBox():void
        {
            if (_state == GameConst.loadMainState && StartParam.instance.getParam("r_p_a") == 0)
            {
                linkBox.visible = true;
                linkCheck.selected = false;
                linkLabel.on(Event.CLICK, this, openLinkWeb, [1]);
                gameLable.on(Event.CLICK, this, openLinkWeb, [2]);
                startGameBtn.on(Event.CLICK, this, onClickLinkCheckBox);
                tishiBtn.on(Event.CLICK, this, onTipBtn)
                if (WxC.isInMiniGame())
                {
                    closeWeb.pos(linkPanel.x + linkPanel.width + 10, linkPanel.y)
                }
                closeWeb.on(Event.CLICK, this, function ()
                {
                    if (!WxC.isInMiniGame())
                    {
                        if (getUrlParamValue("r_p_a") != null)
                        {
                            GameTools.replaceParam("r_p_a", 1);
                        }
                    }
                    isStartLoad = false;
                    groupBox.visible = true;
                    closeWeb.visible = false;
                    linkPanel.visible = false;
                    gamePanel.visible = false;
                    waitBox.visible = false;
                });
            } else
            {
                loadComplete();
            }
        }

        private var _type:Number = 0;

        private function completeHandle(res:*):void
        {
            if (res.code == "success")
            {
                LoginInfoM.instance.privacyArr = res.data[0];
                LoginInfoM.instance.gameArr = res.data[1];
                openLinkWeb(_type);
                waitBox.visible = false;
            }
        }

        private function errorHandle(res:*):void
        {
            if (res.indexOf("fail") >= 0)
            {
                waitBox.visible = false;
                groupBox.visible = true;
            }
        }

        private var isStartLoad:Boolean = false;

        private function privacyLazyLoadHandle(value:Number):void
        {
            if (!isStartLoad && value > (linkPanel.vScrollBar.max - 10) && privacyBox.numChildren < privacyArr.length)
            {
                isStartLoad = true;
                waitBox.visible = true;
                Laya.loader.load(privacyArr[privacyBox.numChildren], Handler.create(this, function (isSucess:Boolean)
                {
                    if (isSucess)
                    {
                        waitBox.visible = false;
                        addImageToBox(privacyBox.numChildren, privacyBox);
                    } else
                    {
                        GameEventDispatch.instance.event(GameEvent.MsgTipContent, "加载错误，请关闭后重新打开")
                    }
                }), null, Loader.IMAGE);
            }

        }

        private function gameLazyLoadHandle(value:Number):void
        {
            if (!isStartLoad && value > (gamePanel.vScrollBar.max - 10) && gameBox.numChildren < gameArr.length)
            {
                isStartLoad = true;
                waitBox.visible = true;
                Laya.loader.load(gameArr[gameBox.numChildren], Handler.create(this, function (isSucess:Boolean)
                {
                    if (isSucess)
                    {
                        waitBox.visible = false;
                        addImageToBox(gameBox.numChildren, gameBox);
                    } else
                    {
                        GameEventDispatch.instance.event(GameEvent.MsgTipContent, "加载错误，请关闭后重新打开")
                    }
                }), null, Loader.IMAGE);
            }

        }

        private function addImageToBox(index:Number, box:Box):void
        {
            var curHeight:Number = box.height;
            var sprite = new Sprite();
            if (box.name == "privacyBox")
            {
                sprite = sprite.loadImage(privacyArr[index])
            } else
            {
                sprite = sprite.loadImage(gameArr[index])
            }
            box.addChild(sprite);
            console.log("i", box.name, index, sprite.getBounds());
            sprite.width = sprite.getBounds().width;
            sprite.height = sprite.getBounds().height;
            sprite.y = curHeight;
            sprite.x = 0;
            box.height = curHeight + sprite.height;
            box.width = sprite.width;
            box.scale(box.parent.width / box.width, box.parent.width / box.width);
            isStartLoad = false;
        }

        private function openLinkWeb(type:Number):void
        {

            privacyBox.visible = false;
            gameBox.visible = false;
            groupBox.visible = false;
            _type = type;
            if (LoginInfoM.instance.privacyArr.length <= 0 && LoginInfoM.instance.gameArr.length <= 0)
            {
                waitBox.visible = true;
                ApiManager.instance.getPrivacyAgreement(new Handler(this, completeHandle), new Handler(this, errorHandle));
                return;
            }
            if (_type == 1)
            {
                if (!linkPanel.getChildByName("privacyBox"))
                {
                    privacyArr = LoginInfoM.instance.privacyArr;
                    privacyBox.name = "privacyBox";
                    linkPanel.addChild(privacyBox);
                    linkPanel.vScrollBarSkin = "";
                    linkPanel.vScrollBar.changeHandler = new Handler(this, privacyLazyLoadHandle)
                }
                linkPanel.scrollTo(0, 0);
                privacyBox.visible = true;
                linkPanel.visible = true;
            } else if (_type == 2)
            {
                if (!gamePanel.getChildByName("gameBox"))
                {
                    gameArr = LoginInfoM.instance.gameArr;
                    gameBox.name = "gameBox";
                    gamePanel.addChild(gameBox);
                    gamePanel.vScrollBarSkin = "";
                    gamePanel.vScrollBar.changeHandler = new Handler(this, gameLazyLoadHandle)
                }
                gamePanel.scrollTo(0, 0);
                gameBox.visible = true;
                gamePanel.visible = true;
            }
            closeWeb.visible = true;
        }


        private function privacyCompleteHandle(res:*):void
        {
            console.log("已读", res)
        }

        private function onClickLinkCheckBox():void
        {
            if (linkCheck.selected)
            {
                linkBox.visible = false;
                var token = StartParam.instance.getParam("access_token");
                ApiManager.instance.readPrivacyAgreement(token, Handler.create(this, privacyCompleteHandle));
                loadComplete();
            } else
            {
                tishiBox.visible = true;
            }
        }

        private function onTipBtn():void
        {
            tishiBox.visible = false;
        }

        private function firstLoadFishInit():void
        {
            if (!_firstLoadFishState) return;

            ConfigManager.initSecond();
            FightManager.instance.initSwimPath();
            _firstLoadFishState = false;
        }

        //资源加载完成
        private function loadComplete():void
        {
            playBgMusic();
            if (_state == GameConst.loadMainState)
            {
                var accessToken:String = StartParam.instance.getParam("access_token");//getUrlParamValue("access_token");
                var server_domain:String = StartParam.instance.getQueryString("server_domain");//getUrlParamValue("server_domain");
                var server_name:String = StartParam.instance.getQueryString("server_name");//getUrlParamValue("server_name");
                var mini_server_domain:String = StartParam.instance.getParam("mini_server_domain")//getUrlParamValue("mini_server_domain");
                var mini_server_name:String = StartParam.instance.getParam("mini_server_name");//getUrlParamValue("mini_server_name");
                var user_status:String = StartParam.instance.getParam("user_status");//getUrlParamValue("user_status");

                if (user_status == GameConst.user_status_ban)
                {
                    UiManager.instance.loadView("UserBan");
                    return;
                }

                GameTools.CalSqrtSheet();
                GameTools.CalSinCosSheet();
                GameTools.CalAcosSheet();
                if (accessToken && server_domain && server_name)
                {
                    var url:String = "wss://" + decodeURIComponent(server_domain) + "/" + server_name + "?access=" + accessToken;
                    //					var url: String = "ws://" + server + ":" + port + "/" + accessToken;
                    // var url:String = ENV.TEST_ENV_WS_URL + "?access=" + accessToken;
                    WebSocketManager.instance.connect(url);
                }else if (accessToken && server_domain)
                {
                    var url:String = "ws://" + decodeURIComponent(server_domain) + "/" + server_name + "?access=" + accessToken;
                    //					var url: String = "ws://" + server + ":" + port + "/" + accessToken;
                    // var url:String = ENV.TEST_ENV_WS_URL + "?access=" + accessToken;
                    WebSocketManager.instance.connect(url);
                }
                 else
                {
                    UiManager.instance.closePanel("Load", false);
                    UiManager.instance.loadView("Login");
                }
                //点击音效biobiobio
                UiManager.instance.loadView("Mask")

                // 后台加载资源
                Laya.loader.load(LoadResM.instance.backgroundResArr);
            } else if (_state == GameConst.loadFishState)
            {
                firstLoadFishInit();
                var fishArray:Array = ConfigManager.getConfValue("cfg_scene", LoginM.instance.sceneId, "fish_arr") as Array;
                var i:int = 0;
                var j:int = 0;
                for (i = 0; i < fishArray.length; i++)
                {
                    var fishId:int = fishArray[i];
                    if (!LoginM.instance.isFishIdPreload(fishId))
                    {

                        var preLoadNumber:int = ConfigManager.getConfValue("cfg_fish", fishId, "preLoadNum") as int;
                        for (j = 0; j < preLoadNumber; j++)
                        {
                            var tmpFish:Fish = Fish.create(fishId, FightManager.instance.getFishLayer(fishId), false);
                            tmpFish.destroy();
                        }
                        LoginM.instance.setFishIdPreload(fishId);
                    }
                }

                //预加载子弹
                if (!LoginM.instance.isBulletPreload())
                {
                    var bulletInfo:BulletInfo = new BulletInfo();
                    bulletInfo.startX = 250;
                    bulletInfo.startY = 100;
                    bulletInfo.endX = 250;
                    bulletInfo.endY = 250;
                    bulletInfo.showDelay = 0;
                    bulletInfo.uniId = 1;
                    bulletInfo.sr = 1;
                    bulletInfo.fuid = 0;
                    bulletInfo.index = 1;
                    bulletInfo.count = 1;
                    bulletInfo.agent = -100000;
                    bulletInfo.tick = 0;
                    for (i = 1; i <= 8; i++)
                    {
                        bulletInfo.sk = i;
                        for (j = 0; j < 100; j++)
                        {
                            var bullet:Bullet = Bullet.create(bulletInfo, FightManager.instance.getBulletLayer(), false);
                            bullet.destroy();
                        }
                    }
                    LoginM.instance.setBulletPreload();

                    //飘字
                    FightManager.instance.preLoadAwardEffect();
                    //飘特效
                    FightManager.instance.preLoadCatchShowEffect();
                    //飘道具
                    var goodsIds:Array = [1, 4, 21, 22, 24, 51, 60, 64];
                    for (i = 0; i < goodsIds.length; i++)
                    {
                        for (j = 0; j < 10; j++)
                        {
                            var effect:GoodsFlyEffect = GoodsFlyEffect.Create(goodsIds[i], 0, 0, 1, 1, 0, Laya.stage, true, null);
                            effect.destroy();
                        }

                    }


                }
                GameEventDispatch.instance.event(GameEvent.RestInRoom);
            }
        }

        private function getUrlParamValue(name:String):*
        {
            if (!WxC.isInMiniGame())
            {
                var url:String = __JS__("window.document.location.href.toString()");
                var u:* = url.split("?");
                if (u[1] is String)
                {
                    u = u[1].split("&");
                    var gets:Object = {};
                    for (var i:String in u)
                    {
                        var j:String = u[i].split("=");
                        gets[j[0]] = j[1];
                    }
                    return gets[name];
                }
            }
            return null
        }

        private function colsePage():void
        {
            UiManager.instance.closePanel("Load", false);
        }

        private function exitLoginView():void
        {
            UiManager.instance.closePanel("Load", false);
        }

        public function register():void
        {
            GameEventDispatch.instance.once(GameEvent.EnterFightPage, this, colsePage);
            GameEventDispatch.instance.once(GameEvent.ExitLoginView, this, exitLoginView);
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.on(GameEvent.WxMiniLoginComplete, this, wxMiniLoginComplete);
            GameEventDispatch.instance.on(GameEvent.WxResetLogin, this, resetLogin);
            GameEventDispatch.instance.on(GameEvent.YylyLoginComplete, this, yylyLoginComplete);
            GameEventDispatch.instance.on(GameEvent.CocosNativeLoginComplete, this, cocosNativeLoginSuccess);
        }

        private function resetLogin():void
        {
            startLoad();

        }


        public function unRegister():void
        {
            Laya.timer.clearAll(this);
            if (_isFirstWait)
            {
                _isFirstWait = false;
                UiManager.instance.loadView("Wait");
            }
            GameEventDispatch.instance.off(GameEvent.EnterFightPage, this, colsePage);
            GameEventDispatch.instance.off(GameEvent.ExitLoginView, this, exitLoginView);
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.off(GameEvent.WxMiniLoginComplete, this, wxMiniLoginComplete);
            GameEventDispatch.instance.off(GameEvent.WxResetLogin, this, resetLogin);
            GameEventDispatch.instance.off(GameEvent.YylyLoginComplete, this, yylyLoginComplete);
            GameEventDispatch.instance.off(GameEvent.CocosNativeLoginComplete, this, cocosNativeLoginSuccess);

        }
    }
}
