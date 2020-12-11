package view.userBan
{
    import control.WxC;

    import engine.tool.StartParam;

    import laya.events.Event;
    import laya.utils.Browser;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;

    import ui.abbey.UserBanUI;

    public class UserBanView extends UserBanUI implements ResVo
    {
        private var _startX:Number = 0;
        private var _startY:Number = 0;

        public function UserBanView()
        {

        }

        public function StartGames(parm:Object = null):void
        {
            box.x = Laya.stage.width / 2;
            box.y = Laya.stage.height / 2;
            _startX = this.x;
            _startY = this.y;
            telLable.text = StartParam.instance.getParam("provider_tel") + ""
            exitBtn.on(Event.CLICK, this, exitGame);
        }

        private function exitGame():void
        {
            if (WxC.isInMiniGame())
            {
                WxC.exitGame();
            }
            else
            {
                Browser.window.top.postMessage("close", "*");
            }
        }

        private function screenResize():void
        {
            this.size(Laya.stage.width, Laya.stage.height);
        }

        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
        }

        public function unRegister():void
        {
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
        }
    }
}