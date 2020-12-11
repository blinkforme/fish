package
{
    import control.WxC;

    import engine.analysis.BuriedGameId;

    import engine.tool.StartParam;

    import manager.GameConst;

    import model.ExchangeM;

    import model.LoginInfoM;

    import model.RoleInfoM;

    public class ENV_SAMPLE
    {

        public static function get API_DOMAIN()
        {
            if (StartParam.instance.getParam("env") == TEST_ENV)
            {
                return "https://api-h5.qzygxt.com";//TEST
            } else if (StartParam.instance.getParam("env") == STAGE_ENV)
            {
                return "https://api-h5.qzygxt.com";//stage://qqdt:183.146.209.142:8870";
            } else if (StartParam.instance.getParam("env") == PROD_ENV)
            {
                if (WxC.isInMiniGame())
                {
                    return "https://by-api.jjhgame.com"; //prod
                } else
                {
                    return "https://fish-ddz.qzygxt.com"; //prod
                }
            }
        }

        public static var config = {

            /**
             * 设置一个参数，可控制游戏内部功能模块或参数数值
             * require:   true:不可被默认值代替   false:可被默认值代替
             * default:   设置默认值，如果链接未携带参数则可用默认值代替
             * name:   参数名称
             * reg:   参数所要求的正则格式，若不匹配则用默认值代替
             */

            //游戏连接地址  stage / test / prod
            env: {"require": false, "default": "prod", "name": "env"},

            //设置一个默认号登录游戏 如果默认值为空则需要输入框输入登录
            player: {"require": false, "default": "", "name": "player"},
            //  是否开启调试
            is_debug: {"require": false, "default": 0, "name": "is_debug"},
            //进游戏是否静音  1- 正常  2- 静音
            stopAllSound: {"require": false, "default": 1, "name": "stopAllSound"},
            //银行开关
            is_open_bank: {"require": false, "default": 0, "name": "is_open_bank"},
            //是否打开比赛场
            openMatchScene: {"require": false, "default": false, "name": "openMatchScene"},
            //金币变动比例
            exchange_rate: {"require": false, "default": 100, "name": "exchange_rate", "reg": /[\d]$/},
            //游戏状态位操作:1:主界面使用骨骼 2:炮使用骨骼 4:鱼场使用俯视视角
            game_status: {"require": false, "default": 3, "name": "game_status"},
            //网页标题
            htmlTitle: {"require": false, "default": "QQ Fish", "name": "htmlTitle"},
            //渠道：关注公众号，0不显示，1显示
            is_display_public_no_subscribe: {"require": false, "default": 0, "name": "is_display_public_no_subscribe"},
            //客服电话
            provider_tel: {"require": false, "default": 0, "name": "provider_tel"},
            //用户是否已读隐私协议 1已读 0未读
            r_p_a: {"require": false, "default": 0, "name": "r_p_a"},


            access_token: {"require": false, "default": "", "name": "access_token"},
            jjhid: {"require": false, "default": "", "name": "jjhid"},
            uid: {"require": false, "default": "", "name": "uid"},
            platform: {"require": false, "default": "", "name": "platform"},
            is_new: {"require": false, "default": "", "name": "is_new"},
            ctime: {"require": false, "default": "", "name": "ctime"},
            server_name: {"require": false, "default": "", "name": "server_name"},
            provider_id: {"require": false, "default": -1, "name": "provider_id"},
            user_status: {"require": false, "default": "", "name": "user_status"},
            api_domain: {"require": false, "default": "gpk.qzygxt.com", "name": "api_domain"},
            api_domain_protocal: {"require": false, "default": "https", "name": "api_domain_protocal"},
            server_domain: {"require": false, "default": "", "name": "server_domain"},
            server_domain_protocal: {"require": false, "default": "wss", "name": "server_domain_protocal"},
            mini_server_name: {"require": false, "default": "", "name": "server_domain_protocal"},
            mini_server_domain: {"require": false, "default": "", "name": "mini_server_domain"},
            version: {"require": false, "default": "version.json", "name": "version"},
            config_version: {"require": false, "default": "config.json", "name": "config_version"},
            second_config_version: {"require": false, "default": "second_config.json", "name": "second_config_version"}
        }


        /*---------------------埋点---------------------------*/

        public static const buriedWxMiniGameId:Number = 10;

        public static function get buriedGameId()
        {
            if (StartParam.instance.getParam("env") == "prod" &&
                    StartParam.instance.getParam("server_name").indexOf("stage_server_ddz") >= 0)
            {//stage_server_ddz   prod_ddz
                return BuriedGameId.buriedDdzGameId;
            }
            if (StartParam.instance.getParam("env") == "prod" &&
                    StartParam.instance.getParam("server_name").indexOf("prod") >= 0)
            {
                return BuriedGameId.buriedH5GameId;
            }
            return BuriedGameId.buriedTestGameId;
        }

        /*---------------------订阅消息---------------------------*/

        //判断环境
        //当env等于TEST_ENV时，使用TEST_ENV_WS_URL连接游戏服务器

        public static const TEST_ENV:String = "test";
        public static const STAGE_ENV:String = "stage";
        public static const PROD_ENV:String = "prod";

        //TEST服务器地址
        public static const TEST_ENV_WS_URL:String = "ws://192.168.89.11:9500/local_server";//带防沉迷的服务器地址
        //        public static const TEST_ENV_WS_URL:String = "ws://183.131.147.69:9550/local_server/";//带防沉迷的服务器地址

        //提审服连接
        public static const PROD_ENV_URL:String = "wss//h5wss.jjhgame.com/prod_server?access=6d9aad02f2e9d44154cca44f8f410ff2";

        //提审服加载外公告API_URL
        public static const MINI_API_URL:String = "https://tby-api.jjhgame.com";


        //游戏坛子分享URL
        public static const ljby_imageUrl:String = "https://cdn-byh5.jjhgame.com/wxminiby/appljbyshare.jpg";

        //游戏分享URL
        public static const imageUrl:String = "https://cdn-byh5.jjhgame.com/wxminiby/appshare.png";

        // 模式窗口点击边缘，是否关闭窗口
        public static const closeDialogOnSide:Boolean = false;
        //是否显示性能面板
        public static const showDebugPanel = false;

        public static const buriedUrl:String = "https://collector.12h5.com";

        //---------------功能开关-------------------------
        //是否打开快速注册功能
        public static function get openQuickRegister()
        {
            if (WxC.isInMiniGame() || ExchangeM.instance._platform == GameConst.platform_wx)
            {
                return false
            } else
            {
                return true
            }
        }

        public static var switch_arr = {
            notice:{"state": false},        //公告
            bank:{"state": false},          //银行
            band:{"state": false},          //绑定
            certification:{"state": false},  //公众号
            shop:{"state":true},              //商店
            exchange:{"state":false},           //兑换
            useTicket:{"state":false},        //福利
            redPack:{"state":false}             //红包
        };

        //渠道开关
        public static function branchSwitch(paramName:String):Boolean
        {
            return switch_arr[paramName].state
        }

        //是否是登录框登录
        public static var isLoginView:Boolean = false;

        //渠道
        public static function get channelType()
        {
            if (WxC.isInMiniGame())
            {
                return GameConst.public_no_id_jjh
            } else
            {
                return GameConst.public_no_id_jjhh5
            }
        }

        //是否打开转盘界面
        public static function get openSharePage():Boolean
        {
            return false;
        }

        //是否显示哀悼日内容
        public static function isShowDied():Boolean
        {
            return StartParam.instance.getParam("game_status") & GameConst.show_died;
        }


        //是否显示banner 同时控制视频广告
        public static function isShowBannerAndAD():Boolean
        {
            if (WxC.isInMiniGame())
            {
                return StartParam.instance.getParam("game_status") & GameConst.show_banner;
            } else
            {
                if (isLoginView)
                {
                    return true
                } else
                {
                    return false
                }
            }
        }

        //是否需要强制实名认证
        public static function isNeedCertification():Boolean
        {
            if (StartParam.instance.getParam("env") == ENV.PROD_ENV)
            {
                return false;
            } else
            {
                if (isLoginView)
                {
                    return true
                } else
                {
                    return false
                }
            }
        }

        //-------------------微信小游戏-------------------

        public static const game_version:String = "vjjh_20102901";

        //是否捕获全局错误并弹出提示
        public static const isAlertGlobalError = false;

        //微信小游戏【线上】API地址
        public static const MiniGameAPIDomain:String = "https://by-api.jjhgame.com"

        //微信小游戏资源加载路径
        public static const MiniGameRemoteUrlBase:String = "https://cdn-byh5.jjhgame.com/byh5client_stage_3d/";
        //小游戏分享图片路径
        public static const MiniGameShraeUrl:String = "https://cdn-byh5.jjhgame.com/wxminiby/appljbyshare.jpg";
    }

}
