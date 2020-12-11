package view.wxInfo
{
    import control.WxC;

    import laya.events.Event;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;

    import ui.abbey.WxInfoPageUI;

    public class WxInfoPage extends WxInfoPageUI implements ResVo
    {
        private var _startX:Number = 0;
        private var _startY:Number = 0;

        public function WxInfoPage()
        {

        }

        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;
            bmask.on(Event.CLICK, this, null);
            WxC.instance.createUserInfoButton("WxInfo");
            screenResize();
        }


        private function screenResize():void
        {
            var contentWidth:int = 400;//组件范围widthGameEventDispatch.instance.off(GameEvent.ScreenResize,this,screenResize);
            var contentHeight:int = 291;//组件范围height
            var contentStartX:int = 200;//组件左边距
            var contentStartY:int = 100;//组件上边距
            var posXOff:Number = (Laya.stage.width - contentWidth) / 2;
            var posYOff:Number = (Laya.stage.height - contentHeight) / 2;
            this.pos(_startX + posXOff - contentStartX, _startY + posYOff - contentStartY);

        }


        public function unRegister():void
        {
            this.x = _startX;
            this.y = _startY;
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
        }


        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
        }
    }

}
