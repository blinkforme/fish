package
{
    import control.WxC;

    import engine.tool.StartParam;
    import engine.ui.component.RewriteManager;
    import engine.workers.WorkerManager;

    import laya.display.Text;
    import laya.events.MouseManager;
    import laya.media.SoundManager;
    import laya.net.ResourceVersion;
    import laya.net.URL;
    import laya.utils.Handler;
    import laya.utils.Stat;
    import laya.utils.Utils;

    import manager.ApiManager;
    import manager.GameConst;
    import manager.GameInit;
    import manager.GameTools;
    import manager.ScreenAdaptManager;
    import manager.UiManager;

    import ui.abbey.LoadPageUI;
    import ui.abbey.WxLoadPageUI;
    import manager.WebSocketManager;
    import engine.analysis.BuriedManager;
    import engine.analysis.BuriedTypes;


    public class Main
    {
        public function onVisibleChange(e){
            WebSocketManager.instance.close()
            WorkerManager.instance.finishWorker();
        }
        public function Main()
        {
            console.info(Laya.Browser.window.location.href)
            RewriteManager.rewriteFunc();
            console.log("WxC.isInMiniGame():" + WxC.isInMiniGame())
            console.log("ENV.channelType:" + ENV.channelType)
            StartParam.instance.setConfig(ENV.config);
            StartParam.instance.parseHtmlParamString();
            
            if (WxC.isInMiniGame())
            {
                WxC.wx_on_window_resize();
                WxC.wx_onHide();
                WxC.wx_onShow();
                WxC.wx_get_system_info();
                WxC.wx_start_accelerometer();
                WxC.wx_on_accelerometer_change();
                WxC.wx_on_window_error();
                //                WxC.wx_netWork();
                WxC.wx_screen_state();
                WxC.wx_show_share_menu();
                WxC.instance.initAdVideo();
            }
            //根据IDE设置初始化引擎
            Laya.init(GameConfig.width, GameConfig.height, Laya["WebGL"]);
            ScreenAdaptManager.instance.init();
            Laya.stage.scaleMode = GameConfig.scaleMode;
            Laya.stage.screenMode = GameConfig.screenMode;
            Laya.stage.alignV = GameConfig.alignV;
            Laya.stage.alignH = GameConfig.alignH;
            //兼容微信不支持加载scene后缀场景
            URL.exportSceneToJson = GameConfig.exportSceneToJson;
            UiManager.init();
            //打开调试面板（IDE设置调试模式，或者url地址增加debug=true参数，均可打开调试面板）
            if (GameConfig.debug || Utils.getQueryString("debug") == "true") Laya.enableDebugPanel();
            if (GameConfig.physicsDebug && Laya["PhysicsDebugDraw"]) Laya["PhysicsDebugDraw"].enable();
            if (GameConfig.stat) Stat.show();
            Laya.alertGlobalError = true;

            GameInit.instance.init();
            MouseManager.multiTouchEnabled = true;

            initENV()
            if (ENV.showDebugPanel)
            {
                if (0 === GameConst.server_mode)
                {
                    Stat.show();
                    //                DebugPanel.init();
                    //DebugTool.init(true, true, true, true);
                }
            }

            Laya.alertGlobalError = ENV.isAlertGlobalError;
            SoundManager.setMusicVolume(GameConst.default_bgm_music);
            SoundManager.setSoundVolume(GameConst.default_sound);

            if (!WxC.isInMiniGame())
            {
                SoundManager.useAudioMusic = false;
                initFont();
            }
            if (WxC.isInMiniGame())
            {
                LoadPageUI.uiView = WxLoadPageUI.uiView;
                onVersionLoaded();
            } else if (StartParam.instance.getParam("platform") && StartParam.instance.getParam("platform") == GameConst.platform_yyly)
            {
                onVersionLoaded();
            } else if (StartParam.instance.getParam("platform") && StartParam.instance.getParam("platform") == GameConst.platform_cocos)
            {
                URL.basePath = ENV.MiniGameRemoteUrlBase;
                onVersionLoaded();
            }
            else
            {
                //激活资源版本控制，版本文件由发布功能生成
                console.log("h5version", StartParam.instance.getParam("version"))
                ResourceVersion.enable(StartParam.instance.getParam("version")+"?t=" +  new Date().getTime() + "" , Handler.create(this, onVersionLoaded), ResourceVersion.FILENAME_VERSION);

            }
            Laya.stage.on("liulanqiguanbi",this,this.onVisibleChange)
        }

        private function onVersionLoaded():void
        {
            WorkerManager.instance.init();
            BuriedManager.instance.addBuriedData(BuriedTypes.open_web)
            BuriedManager.instance.sync()
            UiManager.instance.loadView("Load");
        }

        private function initENV():void
        {
            var api:String = GameTools.getUrlParamValue("api_domain");
            if (api)
            {
                ApiManager.instance.API_URL = api;
            } else
            {
                ApiManager.instance.API_URL = ENV.API_DOMAIN;
                ApiManager.instance.API_PORT = "";
            }
            trace("----ApiManager.instance.API_URL--",ApiManager.instance.API_URL)

            if (WxC.isInMiniGame())
            {
                if (StartParam.instance.getParam("env") == ENV.PROD_ENV)
                {
                    URL.basePath = ENV.MiniGameRemoteUrlBase;
                }
                else
                {
                    console.log("微信小游戏env，需要为PROD_ENV")
                }
            }
        }

        public function initFont():void
        {

            var fonts:Array = getFontArr()
            stupidLoadTTF(fonts)

            Text.defaultFont = fonts[0]

        }

        public function getFontArr():Array
        {
            return ["font_zh_fzcy"]
        }

        public function stupidLoadTTF(arr:Array):void
        {
            for (var i = 0; i < arr.length; i++)
            {
                var font:String = arr[i];
                var text:Text = new Text();
                text.fontSize = 10;
                text.color = "#FF00FF";
                text.text = "1";
                text.font = font
                text.pos(-1000, -600);
                Laya.stage.addChild(text);
            }
        }
    }
}