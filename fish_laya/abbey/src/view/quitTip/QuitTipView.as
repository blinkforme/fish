package view.quitTip
{
    import control.WxC;

    import model.QuitM;

    import laya.events.Event;
    import laya.ui.Label;

    import manager.GameConst;
    import manager.GameTools;
    import manager.WebSocketManager;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;

    import struct.QuitTipInfo;

    import ui.abbey.QuitTpUI;

    public class QuitTipView extends QuitTpUI implements ResVo
    {
        private var _count:int;
        private var _confirmTxt:Label;
        private var _cancleTxt:Label;
        private var _startX:Number = 0;
        private var _startY:Number = 0;

        public function QuitTipView()
        {
            super();
        }

        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;
            _startX = this.x;
            _startY = this.y;
            confirmBtn.on(Event.CLICK, this, confirm);
            cancelBtn.on(Event.CLICK, this, clickCancel);

            closeBtn.on(Event.CLICK, this, clickClose);

            cBtn.on(Event.CLICK, this, clickB);

            var info:QuitTipInfo = QuitM.instance.getTipInfo();
            if (info.autoCloseTime > 0)
            {
                Laya.timer.loop(1000, this, loopTick);
            }

            init();
            bmask.on(Event.CLICK, this, clickMask);
            screenResize();
        }

        private function clickQuit():void
        {
            UiManager.instance.closePanel("QuitTip", false);
            var info:QuitTipInfo = QuitM.instance.getTipInfo();
            if (info.quitMsg)
            {
                GameEventDispatch.instance.event(info.quitMsg, info.quitArgs);
            }

        }

        private function clickMask():void
        {


        }

        private function init():void
        {
            var info:QuitTipInfo = QuitM.instance.getTipInfo();
            btnState(info.state);
            //			mainContent.text = info.content;

            mainContent.autoSize = false;
            mainContent.style.align = "center";
            mainContent.style.fontSize = 22;
            mainContent.style.color = "#136673";
            mainContent.style.bold = true;
            mainContent.innerHTML = info.content;
            mainContent.style.font = "Microsoft YaHei"
            mainContent.style.width = 491;
            _count = info.autoCloseTime;
            timeContent.visible = info.isHaveTime;
            if (info.isHaveTime == false)
            {
                Laya.timer.clear(this, loopTick);
            }

            if (info.autoCloseTime > 0)
            {
                timeContent.text = "(" + _count + "秒以后自动关闭)";
            } else
            {
                timeContent.text = "";
            }

        }

        private function clickB():void
        {
            //clickCancel();
            confirm();
            if (rankCheckBox.selected == true)
            {
                WebSocketManager.instance.send(42004, null);
            }
        }

        private function btnState(state:int):void
        {
            var info:QuitTipInfo = QuitM.instance.getTipInfo();
            if (info.leftTxt)
            {
                GameTools.clipTxt(clipCancel, info.leftTxt, info.leftTxtColor)
            }

            if (info.rightTxt)
            {
                GameTools.clipTxt(clipConfirm, info.rightTxt, info.rightTxtColor)
            }
            if (info.middleTxt)
            {
                GameTools.clipTxt(clipMIddle, info.middleTxt, info.middileTxtColor)
            }
            switch (state)
            {
                case 0:
                {
                    //左确定，右取消
                    subscibeBox.visible = false;
                    cBtn.visible = false;
                    confirmBtn.visible = true;
                    cancelBtn.visible = true;
                    cancelBtn.x = 346;
                    cancelBtn.y = 360;
                    confirmBtn.x = 106;
                    confirmBtn.y = 360;
                    rankCheckBox.visible = false
                    break;
                }
                case 1:
                {
                    //右确定，左取消
                    cBtn.visible = false;
                    subscibeBox.visible = false;
                    confirmBtn.visible = true;
                    cancelBtn.visible = true;
                    rankCheckBox.visible = false
                    confirmBtn.x = 346;
                    confirmBtn.y = 360;
                    cancelBtn.x = 106;
                    cancelBtn.y = 360;
                    break;
                }
                case 2:
                {
                    //中间确定
                    confirmBtn.visible = false;
                    subscibeBox.visible = false;
                    cancelBtn.visible = false;
                    cBtn.visible = true;
                    rankCheckBox.visible = false
                    break;
                }
                case 3:
                {
                    confirmBtn.visible = false;
                    subscibeBox.visible = false;
                    cancelBtn.visible = false;
                    cBtn.visible = false;
                    rankCheckBox.visible = false
                    break;
                }
                case 4:
                {
                    //中间确定
                    confirmBtn.visible = false;
                    subscibeBox.visible = false;
                    cancelBtn.visible = false;
                    cBtn.visible = true;
                    rankCheckBox.visible = true;
                    break;
                }
                case 5:
                {
                    //中间确定
                    confirmBtn.visible = false;
                    cancelBtn.visible = false;
                    cBtn.visible = true;
                    subscibeBox.visible = true;
                    rankCheckBox.visible = false;
                    break;
                }
                default:
                {
                    break;
                }
            }

        }

        private function loopTick():void
        {
            _count = _count - 1;
            updateCount(_count);
        }

        private function screenResize():void
        {
            bmask.width = Laya.stage.width * 2;
            bmask.height = Laya.stage.height * 2;
            this.size(Laya.stage.width, Laya.stage.height);
        }

        private function updateCount(count:int):void
        {
            if (count == 0)
            {
                clickCancel();
            }
            timeContent.text = "(" + count + "秒以后自动关闭)"

        }

        private function clickClose():void
        {
            UiManager.instance.closePanel("QuitTip", false);
            var info:QuitTipInfo = QuitM.instance.getTipInfo();
            if (info.commonMsg)
            {
                GameEventDispatch.instance.event(info.commonMsg, info.commonArgs);
            }
            if (info.closeCallback)
            {
                info.closeCallback.run()
            }
        }

        private function clickCancel():void
        {
            //

            UiManager.instance.closePanel("QuitTip", false);
            var info:QuitTipInfo = QuitM.instance.getTipInfo();
            if (info.cancelEvent)
            {
                GameEventDispatch.instance.event(info.cancelEvent, info.cancelEventArgs);
            }
            if (info.commonMsg)
            {
                GameEventDispatch.instance.event(info.commonMsg, info.commonArgs);
            }
            if (info.cancelMsg)
            {
                GameEventDispatch.instance.event(info.cancelMsg, info.cancelArgs);
            }
            if (info.cancelCallback)
            {
                info.cancelCallback.run()
            }
        }

        private function confirm():void
        {
            //
            UiManager.instance.closePanel("QuitTip", false);
            var info:QuitTipInfo = QuitM.instance.getTipInfo();
            if (info.confirmEvent)
            {
                GameEventDispatch.instance.event(info.confirmEvent, info.confirmEventArgs);
            }
            if (info.confirmMsg)
            {
                GameEventDispatch.instance.event(info.confirmMsg, info.conFirmArgs);
            }
            if (info.commonMsg)
            {
                GameEventDispatch.instance.event(info.commonMsg, info.commonArgs);
            }
            if (info.confirmCallback)
            {
                info.confirmCallback.run()
            }
        }

        public function register():void
        {

            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            if (ENV.isShowBannerAndAD())
            {
                if (WxC.isInMiniGame() && WxC.compareVersion(WxC.wxSDKVersion, GameConst.wxSDKVersion) >= 0)
                {
                    tip_box.y = 0
                    WxC.instance.showBannerAD()
                } else
                {
                    tip_box.y = 60
                }
            } else
            {
                tip_box.y = 60
            }
        }

        public function unRegister():void
        {

            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            Laya.timer.clear(this, loopTick);
            if (ENV.isShowBannerAndAD())
            {
                if (WxC.isInMiniGame())
                {

                    WxC.instance.hideBannerAD()
                }
            }
        }
    }
}
