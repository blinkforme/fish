package view.publicAccount
{
    import control.WxC;

    import laya.events.Event;
    import laya.utils.Browser;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;

    import ui.abbey.PublicAccountPageUI;

    public class PublicAccountPage extends PublicAccountPageUI implements ResVo
    {

        private var _startX:Number = 0;
        private var _startY:Number = 0;

        public function PublicAccountPage()
        {
            super();
        }

        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;
            _startX = this.x;
            _startY = this.y;
            goToBtn.visible = false;
            WXBro.visible = false;
            noWXBro.visible = false
            bmask.on(Event.CLICK, this, null);
            quitBtn.on(Event.CLICK, this, clickConfirm);
            goToBtn.on(Event.CLICK, this, goToPublicAccount);
            initBox()
            screenResize();
        }

        private function initBox()
        {
            if (Browser.onWeiXin && !WxC.isInMiniGame())
            {
                goToBtn.visible = true;
                WXBro.visible = true;
            } else
            {
                noWXBro.visible = true;
            }
        }

        private function goToPublicAccount()
        {
            Browser.window.open("http://mp.weixin.qq.com/mp/getmasssendmsg?__biz=MzA4NjAyNjQ3NQ==#wechat_redirect");
        }

        private function clickConfirm():void
        {
            UiManager.instance.closePanel("PublicAccount", true);
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
            quitBtn.left = contentStartX - posXOff;
            quitBtn.top = contentStartY - posYOff;
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
