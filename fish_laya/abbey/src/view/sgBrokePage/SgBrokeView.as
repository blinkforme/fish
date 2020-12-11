package view.sgBrokePage
{
    import control.HeartbeatC;
    import control.SmallGameHeartbeatC;
    import control.WxC;

    import laya.events.Event;

    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;
    import manager.WebSocketSmallGameManager;

    import ui.abbey.SgBrokePageUI;

    public class SgBrokeView extends SgBrokePageUI implements ResVo
    {
        private var reconnectCount:int = 0;
        private var autoReconnectMaxCount:int = 3;
        private var autoConnectInterval:Number = 5; //自动重连间隔
        private var autoLeftTime:Number = 0;
        private var showComsEnable:Boolean = false;
        private var showConfirmBtn:Boolean = true;
        private var _startX:Number = 0;
        private var _startY:Number = 0;

        public function SgBrokeView()
        {
            super();
        }

        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;
            _startX = this.x;
            _startY = this.y;
            confirmBtn.on(Event.CLICK, this, clickConfirm);
            showComsEnable = true;
            showConfirmBtn = true;

            if (SmallGameHeartbeatC.instance.reconnectType == GameConst.reconnect_type_other_device_login)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTip, 4);
                specialBroke("账号在其他设备登录,请重新连接");
                if (WxC.isInMiniGame())
                    confirmBtn.visible = false;

            }
            else if (SmallGameHeartbeatC.instance.reconnectType == GameConst.reconnect_type_kick)
            {
                specialBroke("账号被踢出");
                if (WxC.isInMiniGame())
                    confirmBtn.visible = false;
            }
            else if (SmallGameHeartbeatC.instance.reconnectType == GameConst.reconnect_type_server_error)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTip, 5);
                specialBroke("服务器异常");
            }
            else if (HeartbeatC.instance.reconnectType == GameConst.reconnect_admin_kick)
            {
                showConfirmBtn = false;
                specialBroke(HeartbeatC.instance.reconnectContent);
            }
            else if (SmallGameHeartbeatC.instance.reconnectType == GameConst.reconnect_type_user_check_error)
            {
                specialBroke("用户校验失败");
                if (WxC.isInMiniGame())
                if (WxC.isInMiniGame())
                    confirmBtn.visible = false;

            }
            else if (SmallGameHeartbeatC.instance.reconnectType == GameConst.reconnect_type_network_error)
            {
                specialBroke("网络状态异常");

            }
            else
            {
                clickConfirm();
            }
            Laya.timer.frameLoop(1, this, autoTimeTick);
            screenResize();
            bmask.on(Event.CLICK, this, maskClick);

        }

        private function clickquit():void
        {
            WxC.exitGame();

        }

        private function maskClick():void
        {


        }

        private function screenResize():void
        {
            var contentWidth:int = 600;//组件范围width
            var contentHeight:int = 400;//组件范围height
            var contentStartX:int = 340;//组件左边距
            var contentStartY:int = 160;//组件上边距
            var posXOff:Number = (Laya.stage.width - contentWidth) / 2;
            var posYOff:Number = (Laya.stage.height - contentHeight) / 2;
            this.pos(_startX + posXOff - contentStartX, _startY + posYOff - contentStartY);
            this.size(Laya.stage.width, Laya.stage.height);
        }

        private function specialBroke(tip:String):void
        {
            showComsEnable = false;
            confirmBtn.visible = showConfirmBtn;
            reconnectCount = autoReconnectMaxCount;
            mainContent.text = tip;
        }

        private function autoTimeTick():void
        {
            autoLeftTime -= Laya.timer.delta / 1000;
            if (autoLeftTime <= 0 && WebSocketSmallGameManager.instance.isSocketNull())
            {
                if (reconnectCount < autoReconnectMaxCount)
                {
                    clickConfirm();
                }
                else
                {
                    showComs();
                }
            }
        }

        private function startReconnect():void
        {
            reconnectCount += 1;
            WebSocketSmallGameManager.instance.reconnect();
        }

        private function receiveHandshake():void
        {
            UiManager.instance.closePanel("SgBrokePage", true);
        }

        private function clickConfirm():void
        {
            showComsEnable = true;
            autoLeftTime = autoConnectInterval;
            //			closeBtn.visible = false;
            confirmBtn.visible = false;
            //			cancelBtn.visible = false;
            if (reconnectCount >= 3)
            {
                mainContent.text = "重连中...";
            }
            else
            {
                mainContent.text = "第" + (reconnectCount + 1) + "次自动重连中...";
            }

            startReconnect();
        }

        private function showOtherDeviceLogin():void
        {

        }

        private function showComs():void
        {
            if (!showComsEnable)
            {
                return;
            }

            //关闭小游戏
            UiManager.instance.closePanel("SgBrokePage", true);
        }


        private function wsClose():void
        {
            if (autoLeftTime <= 0)
            {
                if (reconnectCount < autoReconnectMaxCount)
                {
                    if (WebSocketSmallGameManager.instance.isSocketNull())
                    {
                        clickConfirm();
                    }
                }
                else
                {
                    showComs();
                }
            }
        }

        private function wsError():void
        {
            if (autoLeftTime <= 0)
            {
                if (reconnectCount < autoReconnectMaxCount)
                {
                    if (WebSocketSmallGameManager.instance.isSocketNull())
                    {
                        clickConfirm();
                    }
                }
                else
                {
                    showComs();
                }
            }
        }


        public function register():void
        {
            GameEventDispatch.instance.once(GameEvent.ReceiveSGHandshake, this, receiveHandshake);
            GameEventDispatch.instance.on(GameEvent.SGWsClose, this, wsClose);
            GameEventDispatch.instance.on(GameEvent.SGWsError, this, wsError);
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);

        }

        public function unRegister():void
        {
            this.x = _startX;
            this.y = _startY;
            reconnectCount = 0;
            Laya.timer.clear(this, autoTimeTick);
            GameEventDispatch.instance.off(GameEvent.ReceiveSGHandshake, this, receiveHandshake);
            GameEventDispatch.instance.off(GameEvent.SGWsClose, this, wsClose);
            GameEventDispatch.instance.off(GameEvent.SGWsError, this, wsError);
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
        }
    }
}
