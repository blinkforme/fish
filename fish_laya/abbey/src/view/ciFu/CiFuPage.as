package view.ciFu
{
    import laya.events.Event;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;

    import ui.abbey.CiFuPageUI;

    public class CiFuPage extends CiFuPageUI implements ResVo
    {

        private var _startX:Number = 0;
        private var _startY:Number = 0;

        public function CiFuPage()
        {
            super();
        }

        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;
            _startX = this.x;
            _startY = this.y;
            lableNum.text = parm['num'];
            confirmBtn.on(Event.CLICK, this, clickConfirm);
            screenResize();
            bmask.on(Event.CLICK, this, clickConfirm);
        }

        private function clickConfirm():void
        {
            UiManager.instance.closePanel("CiFu", true);
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

        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
        }

        public function unRegister():void
        {
            this.x = _startX;
            this.y = _startY;
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
        }
    }
}
