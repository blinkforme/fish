package control
{
    import model.FightM;
    import model.LoginInfoM;
    import model.RoleInfoM;
    import model.RuleM;
    import model.SmallM;

    import fight.FightManager;

    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.UiManager;
    import manager.WebSocketManager;
    import manager.WebSocketSmallGameManager;

    import proto.C2s_30002;
    import proto.S2c_handshake;
    import proto.S2c_playercreate;

    public class LoginInfoC
    {
        private static var _instance:LoginInfoC;
        private var _firstEnterLogin:Boolean = false;

        public function LoginInfoC()
        {
            GameEventDispatch.instance.on(String(10000), this, handshaker);
            GameEventDispatch.instance.on(String(10002), this, roleCreateRet);
        }


        private function roleCreateRet(data:*):void
        {
            var protoData:S2c_playercreate = data as S2c_playercreate;
            if (protoData.code === GameConst.playercreate_ok)
            {
                WebSocketManager.instance.send(10003, null);
                WebSocketManager.instance.send(12024, null);
            }
        }

        private function handshaker(data:*):void
        {
            var handshake:S2c_handshake = data as S2c_handshake;
            FightManager.instance;
            LoginInfoM.instance.code = handshake.code;
            LoginInfoM.instance.uid = handshake.uid;
            LoginInfoM.instance.setShopRate(handshake.shop_rate);
            GameEventDispatch.instance.event(GameEvent.ReceiveHandshake, data);

            //if(handshake.code == GameConst.handshake_ok)
            {
                var goldPoolAwardMsg:C2s_30002 = new C2s_30002();

                RuleM.instance.setTime(handshake.time);

                FightM.instance.setGoldPoolTotalValue(handshake.gold_pool_value);

                goldPoolAwardMsg.value = handshake.gold_pool_value;
                RoleInfoM.instance.setAwardValue(handshake.gold_pool_value);

                //WebSocketManager.instance.send(10003, null);


                WebSocketManager.instance.send(22002, null);
                WebSocketManager.instance.send(20000, null);
                WebSocketManager.instance.send(33012, {});

                if (GameConst.in_fight_normal == handshake.in_fight)
                {
                    if (_firstEnterLogin && (0 == handshake.enter_main))
                    {
                        //首次快速进入
                        WebSocketManager.instance.send(12024, null);
                    }
                    else
                    {
                        GameEventDispatch.instance.event(GameEvent.ExitLoginView, null);
                        //断线重连时未在房间中，进入主界面
                        GameEventDispatch.instance.event(GameEvent.FightStop);
                        HourseC.instance.loopNotice();
                        UiManager.instance.loadView("MainPage");
                    }
                }

                if (handshake.gold_pool_value > 0)
                {
                    WebSocketManager.instance.send(30002, goldPoolAwardMsg);
                }
                _firstEnterLogin = false;
            }
            if (WxC.isInMiniGame())
            {
                ShopC.instance.sendSyncMiniBalance()
            }
        }

        public static function get instance():LoginInfoC
        {
            return _instance || (_instance = new LoginInfoC());
        }
    }
}
