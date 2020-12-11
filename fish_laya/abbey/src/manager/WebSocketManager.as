package manager
{
    import model.RoleInfoM;

    import laya.events.Event;
    import laya.net.Socket;
    import laya.utils.Byte;

    import proto.ProtoObject;

    public class WebSocketManager
    {
        private static var _instance:WebSocketManager;
        private var socket:Socket;
        private var connetUrl:String;
        private var timeOut:Number;

        public function WebSocketManager()
        {
            socket = null;
            connetUrl = null;
            timeOut = 6;
            Laya.timer.loop(1000, this, connectTimeOutCheck);
        }

        private function connectTimeOutCheck():void
        {
            if (this.socket && !this.socket.connected)
            {
                if (timeOut > 0)
                {
                    timeOut -= 1;
                    if (timeOut <= 0)
                    {
                        close();
                    }
                }
            }
        }

        public static function get instance():WebSocketManager
        {

            return _instance || (_instance = new WebSocketManager());
        }

        private var _protoObject:ProtoObject = new ProtoObject();

        public function send(id:int, msg:*):void
        {
            if (this.socket && this.socket.connected)
            {
                var protoMsg:ProtoObject = _protoObject;
                protoMsg.id = id;
                protoMsg.a = msg;
                this.socket.send(JSON.stringify(protoMsg));
            }
        }

        public function close():void
        {
            if (this.socket)
            {

                this.socket.off(Event.OPEN, this, openHandler);
                this.socket.off(Event.MESSAGE, this, receiveHandler);
                this.socket.off(Event.CLOSE, this, closeHandler);
                this.socket.off(Event.ERROR, this, errorHandler);
                this.socket.close();
                this.socket = null;
                GameEventDispatch.instance.event(GameEvent.WsClose);
            }
        }

        public function closeNoEvent():void
        {
            if (this.socket)
            {
                this.socket.off(Event.OPEN, this, openHandler);
                this.socket.off(Event.MESSAGE, this, receiveHandler);
                this.socket.off(Event.CLOSE, this, closeHandler);
                this.socket.off(Event.ERROR, this, errorHandler);
                this.socket.close();
                this.socket = null;
            }
        }

        public function isConnect():Boolean
        {
            if (this.socket)
            {
                return this.socket.connected;
            }
            return false;
        }

        public function isSocketNull():Boolean
        {
            return this.socket == null;
        }

        public function connect(url:String, login:Number = 1):Socket
        {
            if (this.socket && url === this.connetUrl)
            {
                return this.socket;
            }
            connetUrl = url;
            this.socket = new Socket();
            timeOut = 6;
            this.socket.endian = Byte.BIG_ENDIAN;
            this.socket.connectByUrl(url + "&login=" + login + "&flag=" + RoleInfoM.instance.getTimeStamp());
            this.socket.on(Event.OPEN, this, openHandler);
            this.socket.on(Event.MESSAGE, this, receiveHandler);
            this.socket.on(Event.CLOSE, this, closeHandler);
            this.socket.on(Event.ERROR, this, errorHandler);
            return this.socket;
        }

        public function reconnect():Socket
        {
            if (!this.socket)
            {
                return connect(this.connetUrl, 0);// + "?flag=" + RoleInfoM.instance.getTimeStamp());
            }
            return null;
        }

        private function openHandler(event:Object = null):void
        {
            //正确建立连接；

        }

        public var msgDispatch:Boolean = true;

        private function receiveHandler(msg:Object = null):void
        {
            ///接收到数据触发函数

            var protoMsg:ProtoObject = JSON.parse(String(msg)) as ProtoObject;

            if (protoMsg)// && (msgDispatch || protoMsg.id == 11002))
            {
                GameEventDispatch.instance.event(String(protoMsg.id), protoMsg.a);
            }
            else
            {
            }
            //GameEventDispatch.instance.event(String(proto.)

        }

        private function closeHandler(e:Object = null):void
        {
            //关闭事件
            if (this.socket)
            {
                this.socket.off(Event.OPEN, this, openHandler);
                this.socket.off(Event.MESSAGE, this, receiveHandler);
                this.socket.off(Event.CLOSE, this, closeHandler);
                this.socket.off(Event.ERROR, this, errorHandler);
                this.socket = null;
                GameEventDispatch.instance.event(GameEvent.WsClose);
            }
        }

        private function errorHandler(e:Object = null):void
        {
            //连接出错
            if (this.socket)
            {
                this.socket.off(Event.OPEN, this, openHandler);
                this.socket.off(Event.MESSAGE, this, receiveHandler);
                this.socket.off(Event.CLOSE, this, closeHandler);
                this.socket.off(Event.ERROR, this, errorHandler);
                this.socket = null;
                GameEventDispatch.instance.event(GameEvent.WsError);
            }
        }
    }
}
