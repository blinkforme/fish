package control
{
    import model.LoginInfoM;
    import model.SettleM;
    import model.SmallM;

    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.UiManager;
    import manager.WebSocketManager;
    import manager.WebSocketSmallGameManager;

    public class SmallGameHeartbeatC
    {
        private var unreceiveTime:Number;//多长时间未接收到心跳包
        private var unreceiveMaxTime:Number;//多长时间未接收到心跳包算断线
        private var unsendTime:Number;//多长时间未发送心跳包
        private var sendTime:Number; //心跳包发送间隔
        private var handshake:Boolean;//接收到心跳包
        private var maxReconnectCount:int = 3;//最大重连次数
        private var reconnectCount:int; //当前重连次数
        private var reconnectInterval:Number; //重连间隔
        public var reconnectType:int = 0; //断线类型
        public var reconnectContent:String = "";
        private var _reconnectLock:Boolean = false;
        private static var _instance:SmallGameHeartbeatC;

        public function SmallGameHeartbeatC()
        {
            unreceiveTime = 0;
            unsendTime = 0;
            unreceiveMaxTime = 15;
            sendTime = 3;
            handshake = false;
            GameEventDispatch.instance.on(String(27000), this, receiveHandshake);
            GameEventDispatch.instance.on(String(27010), this, accountReplace);
            GameEventDispatch.instance.on(String(27014), this, server_error);
            GameEventDispatch.instance.on(String(27016), this, user_check_error);
            GameEventDispatch.instance.on(String(27017), this, network_error);
            GameEventDispatch.instance.on(String(27021), this, kicked);
            GameEventDispatch.instance.on(String(27020), this, receiveHeartbeat);

            GameEventDispatch.instance.on(GameEvent.SGWsClose, this, wsClose);
            GameEventDispatch.instance.on(GameEvent.SGWsError, this, wsError);
            //			GameEventDispatch.instance.on(GameEvent.SmallGameForceExit, this, smallGameExit);
            Laya.timer.loop(1000, this, timeTick);
        }

        //被踢下线
        private function kicked(data:Object):void
        {
            reconnectType = GameConst.reconnect_admin_kick;
            handshake = false;
            reconnectContent = data["reason"];
            WebSocketSmallGameManager.instance.close();
        }

        //网络异常
        private function network_error():void
        {
            reconnectType = GameConst.reconnect_type_network_error;
            handshake = false;
            WebSocketSmallGameManager.instance.close();
        }

        //用户验证失败
        private function user_check_error():void
        {
            reconnectType = GameConst.reconnect_type_user_check_error;
            handshake = false;
            WebSocketSmallGameManager.instance.close();
        }

        //服务器异常
        private function server_error():void
        {
            reconnectType = GameConst.reconnect_type_server_error;
            handshake = false;
            WebSocketSmallGameManager.instance.close();
        }

        //账号顶替
        private function accountReplace():void
        {
            reconnectType = GameConst.reconnect_type_other_device_login;
            handshake = false;
            WebSocketSmallGameManager.instance.close();
        }

        private function handleSocketClose():void
        {
            SmallM.instance.isReceive = false;
            handshake = false;
            unsendTime = 0;
            reconnectInterval = 0;
            reconnectCount = 0;
            var reqData:Object = new Object();
            reqData.in_small_game = false;
            GameEventDispatch.instance.event(GameEvent.SmallGameUiExist, reqData);
            if (reqData.in_small_game && !_reconnectLock)
            {
                UiManager.instance.loadView("SgBrokePage");
            }
        }

        private function wsClose():void
        {
            handleSocketClose();

        }

        private function wsError():void
        {
            handleSocketClose();
        }

        private function timeTick():void
        {

            if (WebSocketSmallGameManager.instance.isConnect())
            {
                unreceiveTime += 1;
                unsendTime += 1;
                if (unreceiveTime > unreceiveMaxTime)
                {
                    WebSocketSmallGameManager.instance.close();
                    unsendTime = 0;
                }
                if (unsendTime > sendTime)
                {
                    unsendTime = 0;
                    WebSocketSmallGameManager.instance.send(27019, null);
                }
            }
        }

        private function receiveHeartbeat():void
        {
            unreceiveTime = 0;
        }

        private function receiveHandshake(data:*):void
        {
            SmallM.instance.isReceive = true;
            unreceiveTime = 0;
            unsendTime = 0;
            reconnectInterval = 0;
            reconnectCount = 0;
            reconnectType = 0;
            GameEventDispatch.instance.event(GameEvent.ReceiveSGHandshake, data);
            if (GameConst.in_fight_sg != data.in_fight)
            {
                UiManager.instance.closePanel("SmallGame", false);
                SettleM.instance.clearData();

                //如果主界面都不存在，则直接进入捕鱼房间中

                if (!LoginInfoM.instance.mainPageShow)
                {
                    WebSocketSmallGameManager.instance.close();
                    WebSocketManager.instance.send(12024, null);
                }

            }
        }


        public static function get instance():SmallGameHeartbeatC
        {
            return _instance || (_instance = new SmallGameHeartbeatC());
        }
    }
}
