package view.redActivity
{
    import control.LoginC;
    import control.WxC;

    import emurs.ShowType;

    import laya.events.Event;
    import laya.utils.Browser;

    import manager.GameConst;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;

    import model.ExchangeM;

    import ui.abbey.RedActivityPageUI;

    public class RedActivityPage extends RedActivityPageUI implements ResVo
    {

        private var _startX:Number = 0;
        private var _startY:Number = 0;

        public function RedActivityPage()
        {
            super();
        }

        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;
            bmask.on(Event.CLICK, this, null)
            quitBtn.on(Event.CLICK, this, onQuitBtnClick);
            findIntegralBtn.on(Event.CLICK, this, onFindIntegralBtn);
            _startX = this.x;
            _startY = this.y;
            screenResize();
        }

        private function onFindIntegralBtn()
        {
           UiManager.instance.loadView("PublicAccount",null,ShowType.SMALL_TO_BIG)
        }

        private function onQuitBtnClick():void
        {
            UiManager.instance.closePanel("RedActivity", false)
        }

        private function screenResize():void
        {
            var contentWidth:int = 850;//组件范围widthGameEventDispatch.instance.off(GameEvent.ScreenResize,this,screenResize);
            var contentHeight:int = 660;//组件范围height
            var contentStartX:int = 215;//组件左边距
            var contentStartY:int = 30;//组件上边距
            var posXOff:Number = (Laya.stage.width - contentWidth) / 2;
            var posYOff:Number = (Laya.stage.height - contentHeight) / 2;
            this.pos(_startX + posXOff - contentStartX, _startY + posYOff - contentStartY);
            this.size(Laya.stage.width, Laya.stage.height);
            quitBtn.left = contentStartX - posXOff;
            quitBtn.top = contentStartY - posYOff;
        }

        public function unRegister():void
        {
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
        }

        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
        }
    }
}
