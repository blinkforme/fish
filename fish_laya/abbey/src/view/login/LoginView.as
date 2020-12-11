package view.login
{


    import control.WxC;

    import engine.analysis.BuriedManager;
    import engine.analysis.BuriedTypes;

    import engine.tool.StartParam;

    import laya.utils.Browser;

    import laya.utils.Log;

    import manager.GameTools;

    import model.LoginInfoM;
    import model.RoleInfoM;
    import model.SmallM;

    import laya.events.Event;

    import manager.ApiManager;
    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;
    import manager.WebSocketManager;

    import proto.S2c_handshake;

    import ui.abbey.LoginUI;

    public class LoginView extends LoginUI implements ResVo
    {
        private var onLogin:OnLogin;


        public function LoginView()
        {
            super();
        }

        public function StartGames(parm:Object = null):void
        {
            if (StartParam.instance.getParam("player"))
            {
                onLoginFuction();
            } else
            {
                btn_login.on(Event.CLICK, this, onLoginFuction);
            }
        }

        private function onLoginFuction():void
        {
            UIConfig.closeDialogOnSide = ENV.closeDialogOnSide;

            if (StartParam.instance.getParam("player"))
            {
                var name:String = StartParam.instance.getParam("player")
                LoginInfoM.instance.name = StartParam.instance.getParam("player")
            } else
            {
                var name:String = this.name_input.text;
                LoginInfoM.instance.name = name;
            }

            var params:String = 'third_part_token=' + name + '&third_part_id=test&provider_id=1&user_ip=1.1.1.1&game_key=2d65b80bdb3f91cf30715258017d8343'

            GameEventDispatch.instance.once(GameEvent.ReceiveHandshake, this, receiveHandshake);

            ApiManager.instance.login(params, this.loginRequest);


        }

        private function loginRequest(result):void
        {
            if (result.status)
            {
                var data:Object = result.data;

                if (data.user_status == GameConst.user_status_ban)
                {
                    UiManager.instance.loadView("UserBan");
                    return;
                }


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
                            provider_id: data.provider_id,
                            is_display_public_no_subscribe: data.is_display_public_no_subscribe,
                            ctime: parseInt(data.ctime),
                            is_open_store: data.is_open_store,
                            is_open_bank: data.is_open_bank,
                            platform: data.platform,
                            game_status: data['game_status'],
                            r_p_a: data['r_p_a']
                        })


                var url:String = "wss://" + data.server_domain + "/" + data.server_name + "?access=" + data.access_token;
//                var url:String = "ws://" + "183.131.147.69:9560" + "/" + data.server_name + "?access=" + data.access_token;
                var smurl:String = "wss://" + data.mini_server_domain + "/" + data.mini_server_name + "?access=" + data.access_token;

                var local_url1:String = "ws://jjhgame.com:9100/local_server/?access=" + data.access_token;

                if (data.user_status == GameConst.user_status_ban)
                {
                    UiManager.instance.loadView("UserBan");
                    return;
                }
                if (StartParam.instance.getParam("env") == ENV.TEST_ENV)
                {
                    WebSocketManager.instance.connect(ENV.TEST_ENV_WS_URL + "?access=" + data.access_token);
                } else if (StartParam.instance.getParam("env") == ENV.STAGE_ENV)
                {
                    WebSocketManager.instance.connect(url);
                } else if (StartParam.instance.getParam("env") == ENV.PROD_ENV)
                {
                    RoleInfoM.instance.setTimeStamp(1528953500473);
                    WebSocketManager.instance.connect(ENV.PROD_ENV_URL);
                }
                BuriedManager.instance.addBuriedData(BuriedTypes.login_success);
            } else
            {
                if ("no_server" == result.code)
                {
                    console.log("没有可用的服务器")
                } else
                {
                    console.log("服务器出错")
                }
            }
        }

        private function getGet(name:String):*
        {
            if (!WxC.isInMiniGame())
            {
                var url:String = __JS__('window.document.location.href.toString()');
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
            return {};
        }


        private function start():void
        {
        }

        private function closePage():void
        {
            UiManager.instance.closePanel("Login", true);
        }

        private function receiveHandshake(data:*):void
        {
            var handshake:S2c_handshake = data as S2c_handshake;
        }

        public function register():void
        {
            GameEventDispatch.instance.once(GameEvent.EnterFightPage, this, closePage);
            GameEventDispatch.instance.once(GameEvent.ExitLoginView, this, exitLoginView);
        }

        private function exitLoginView():void
        {
            UiManager.instance.closePanel("Login", true);
        }

        public function unRegister():void
        {
            GameEventDispatch.instance.off(GameEvent.EnterFightPage, this, closePage);
            GameEventDispatch.instance.off(GameEvent.ExitLoginView, this, exitLoginView);
        }
    }
}
