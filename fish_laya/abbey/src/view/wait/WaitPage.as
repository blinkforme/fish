package view.wait
{
    import laya.events.Event;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;

    import ui.abbey.WaitPageUI;

    public class WaitPage extends WaitPageUI implements ResVo
    {
        private var _startX:Number = 0;
        private var _startY:Number = 0;
        
        public function WaitPage()
        {
            super();
        }

        public function StartGames(parm:Object = null):void
        {

            this.visible = false;
            wait.play(0, true);
            this.hitTestPrior = false;
            bmask.on(Event.CLICK, this, clickPage)
            screenResize();
        }

        private function clickPage(event:Event):void
        {

            event.stopPropagation();

        }

        private function closeWait():void
        {
            Laya.timer.once(200, this, closeTimer);
            //this.hitTestPrior = false;
            //this.visible = false;

        }

        private function closeTimer():void
        {
            this.hitTestPrior = false;
            this.visible = false;
            Laya.timer.clear(this, startClose);

        }

        private function openWait():void
        {
            this.hitTestPrior = false;
            this.visible = true;
            Laya.timer.once(5000, this, startClose);


        }

        private function startClose():void
        {
            this.visible = false;

        }

        public function register():void
        {

            GameEventDispatch.instance.on(GameEvent.OpenWait, this, openWait);
            GameEventDispatch.instance.on(GameEvent.CloseWait, this, closeWait);
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.on(GameEvent.RightWait, this, rightClose);
			GameEventDispatch.instance.on(GameEvent.AppOrderCheckOk, this, rightClose);

        }

        private function rightClose():void
        {
            this.hitTestPrior = false;
            this.visible = false;
            Laya.timer.clear(this, startClose);
        }

        private function screenResize():void
        {
            var contentWidth:int = 1070;//组件范围width
            var contentHeight:int = 650;//组件范围height
            var contentStartX:int = 110;//组件左边距
            var contentStartY:int = 30;//组件上边距
            var posXOff:Number = (Laya.stage.width - contentWidth) / 2;
            var posYOff:Number = (Laya.stage.height - contentHeight) / 2;
            this.bmask.width = Laya.stage.width * 2;
            this.bmask.height = Laya.stage.height * 2;
            this.size(Laya.stage.width, Laya.stage.height);
            this.pos(_startX + posXOff - contentStartX, _startY + posYOff - contentStartY);
        }

        public function unRegister():void
        {
            GameEventDispatch.instance.off(GameEvent.OpenWait, this, openWait);
            GameEventDispatch.instance.off(GameEvent.CloseWait, this, closeWait);
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.off(GameEvent.RightWait, this, rightClose);
			GameEventDispatch.instance.off(GameEvent.AppOrderCheckOk, this, rightClose);
            wait.visible = false;

        }
    }
}
