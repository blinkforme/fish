package control
{
    import model.ActivityM;
    import model.RuleM;

    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.UiManager;
    import manager.WebSocketManager;
    import manager.WebSocketSmallGameManager;

    public class HeartbeatC
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
        private static var _instance:HeartbeatC;

        public function HeartbeatC()
        {
            unreceiveTime = 0;
            unsendTime = 0;
            unreceiveMaxTime = 15;
            sendTime = 3;
            handshake = false;
            GameEventDispatch.instance.on(String(10000), this, receiveHandshake);
            GameEventDispatch.instance.on(String(11002), this, receiveHeartbeat);
            GameEventDispatch.instance.on(String(10010), this, accountReplace);
            GameEventDispatch.instance.on(String(10014), this, server_error);
            GameEventDispatch.instance.on(String(10016), this, user_check_error);
            GameEventDispatch.instance.on(String(10017), this, network_error);
            GameEventDispatch.instance.on(String(10018), this, kicked);
            GameEventDispatch.instance.on(GameEvent.WsClose, this, wsClose);
            GameEventDispatch.instance.on(GameEvent.WsError, this, wsError);
            Laya.timer.loop(1000, this, timeTick);
        }

        //被踢下线
        private function kicked(data:Object):void
        {
            reconnectType = GameConst.reconnect_admin_kick;
            handshake = false;
            reconnectContent = data["reason"];
            WebSocketManager.instance.closeNoEvent();
            UiManager.instance.loadView("BrokePage",{cause:data["reason"]});
        }

        //网络异常
        private function network_error():void
        {
            reconnectType = GameConst.reconnect_type_network_error;
            handshake = false;
            WebSocketManager.instance.close();
        }

        //用户验证是吧
        private function user_check_error():void
        {
            reconnectType = GameConst.reconnect_type_user_check_error;
            handshake = false;
            WebSocketManager.instance.close();
        }

        //服务器异常
        private function server_error():void
        {
            //GameEventDispatch.instance.event(GameEvent.MsgTip, 5);
            reconnectType = GameConst.reconnect_type_server_error;
            handshake = false;
            WebSocketManager.instance.close();
        }

        //账号顶替
        private function accountReplace():void
        {
            //GameEventDispatch.instance.event(GameEvent.MsgTip, 4);
            reconnectType = GameConst.reconnect_type_other_device_login;
            handshake = false;
            WebSocketManager.instance.close();
        }

        private function handleSocketClose():void
        {
            handshake = false;
            unsendTime = 0;
            reconnectInterval = 0;
            reconnectCount = 0;
            GameEventDispatch.instance.event(GameEvent.SystemReset);

            //if(!reqData.in_small_room)
            {
                UiManager.instance.loadView("BrokePage");
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
            if (WebSocketManager.instance.isConnect())
            {
                unreceiveTime += 1;
                unsendTime += 1;
                if (unreceiveTime > unreceiveMaxTime)
                {
                    WebSocketManager.instance.close();
                    unsendTime = 0;
                }
                if (unsendTime > sendTime)
                {
                    unsendTime = 0;
                    WebSocketManager.instance.send(11001, null);
                }
            }
            ActivityM.instance.countDownLoop();
        }

        private function receiveHeartbeat(data:*):void
        {
            RuleM.instance.setTime(data.time);
            unreceiveTime = 0;
        }

        private function receiveHandshake(data:*):void
        {
            unreceiveTime = 0;
            unsendTime = 0;
            reconnectInterval = 0;
            reconnectCount = 0;
            reconnectType = 0;
            handshake = true;
        }

        public function isHandshakeReceive():Boolean
        {
            return handshake;
        }


        public static function get instance():HeartbeatC
        {
            return _instance || (_instance = new HeartbeatC());
        }

    }
}
