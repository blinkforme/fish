package view.mate
{
    import laya.events.Event;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;
    import manager.WebSocketManager;

    import ui.abbey.pipeiUI;

    public class MateView extends pipeiUI implements ResVo
    {
        private var _totalTime:Number;

        public function MateView()
        {
            super();
        }

        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;
            _totalTime = 0;
            screenResize();
            remainTime.text = "0秒......"
            bgMask.on(Event.CLICK, this, clickMask);
            startCount();
            closeBtn.on(Event.CLICK, this, onCloseClick);
        }

        private function onCloseClick():void
        {
            WebSocketManager.instance.send(12057, null);
            UiManager.instance.closePanel("Mate", false);
        }

        private function clickMask():void
        {


        }

        public function startCount():void
        {
            Laya.timer.loop(1000, this, addTime);
        }

        private function addTime():void
        {
            _totalTime = _totalTime + 1;
            remainTime.text = _totalTime + "秒......";

        }

        private function gamereset():void
        {
            UiManager.instance.closePanel("Mate", false);
        }

        private function exitFight():void
        {
            UiManager.instance.closePanel("Mate", false);
        }

        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.on(GameEvent.SystemReset, this, gamereset);
            GameEventDispatch.instance.on(GameEvent.FightStop, this, exitFight);
        }

        private function screenResize():void
        {

            this.size(Laya.stage.width, Laya.stage.height);
        }

        public function unRegister():void
        {
            Laya.timer.clear(this, addTime);
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.off(GameEvent.SystemReset, this, gamereset);
            GameEventDispatch.instance.off(GameEvent.FightStop, this, exitFight);
        }
    }
}
