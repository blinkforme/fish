package view.resetLogin
{
    import control.WxC;

    import laya.events.Event;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;

    import ui.abbey.ResetLoginUI;

    public class ResetPage extends ResetLoginUI implements ResVo
    {
        public function ResetPage()
        {
            super();
        }

        public function StartGames(parm:Object = null):void
        {
            closeBtn.on(Event.CLICK, this, clickClose);
            screenResize();

        }

        private function clickClose():void
        {
            WxC.exitGame();

        }

        public function register():void
        {

            //Laya.timer.once(1500, this, startReset);
            GameEventDispatch.instance.on(GameEvent.CloseReset, this, closePage);
            GameEventDispatch.instance.on(GameEvent.WxReset, this, wxReset);
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
        }

        private function wxReset():void
        {
            GameEventDispatch.instance.event(GameEvent.WxResetLogin);

        }

        private function closePage():void
        {
            UiManager.instance.closePanel("ResetLogin", false);

        }

        private function startReset():void
        {
            GameEventDispatch.instance.event(GameEvent.WxResetLogin);

        }

        public function unRegister():void
        {
            Laya.timer.clear(this, startReset);
            GameEventDispatch.instance.off(GameEvent.CloseReset, this, closePage);
            GameEventDispatch.instance.off(GameEvent.WxReset, this, wxReset);
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);

        }

        private function screenResize():void
        {
            this.size(Laya.stage.width, Laya.stage.height);

        }
    }
}
