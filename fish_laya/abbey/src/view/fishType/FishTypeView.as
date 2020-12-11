package view.fishType
{
    import control.WxC;

    import model.FishTypeM;

    import laya.events.Event;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;

    import ui.abbey.FishTypeUI;

    public class FishTypeView extends FishTypeUI implements ResVo
    {
        private var _startX:Number = 0;
        private var _startY:Number = 0;

        public function FishTypeView()
        {
            super();
        }

        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;
            _startX = this.x;
            _startY = this.y;
            //fishlist.array = FishTypeM.instance.infoList;
            smallFishlist.vScrollBarSkin = "";
            bigFishList.vScrollBarSkin = "";

            smallFishlist.array = FishTypeM.instance.showSmallFish;
            bigFishList.array = FishTypeM.instance.showBigFish;
            closeBtn.on(Event.CLICK, this, clickClose);
            //this.on(Event.CLICK,this,click);
            screenResize();
            bmask.on(Event.CLICK, this, clickMask);


        }

        private function clickMask():void
        {


        }

        private function click():void
        {


        }

        private function screenResize():void
        {
            var contentWidth:int = 840;//组件范围width
            var contentHeight:int = 515;//组件范围height
            var contentStartX:int = 220;//组件左边距
            var contentStartY:int = 102;//组件上边距
            var posXOff:Number = (Laya.stage.width - contentWidth) / 2;
            var posYOff:Number = (Laya.stage.height - contentHeight) / 2;
            this.pos(_startX + posXOff - contentStartX, _startY + posYOff - contentStartY);
            this.size(Laya.stage.width, Laya.stage.height);

            closeBtn.left = contentStartX - posXOff;
            closeBtn.top = contentStartY - posYOff;
        }

        private function clickClose():void
        {
            UiManager.instance.closePanel("FishType", false);


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
