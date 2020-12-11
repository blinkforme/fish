package view.bossShare
{
    import control.WxC;
    
    import laya.events.Event;
    import laya.resource.HTMLCanvas;
    import laya.resource.Texture;
    
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;
    
    import ui.abbey.BossShareUI;

    public class BossSharePage extends BossShareUI implements ResVo
    {
        private var _htmlC:HTMLCanvas;

        public function BossSharePage()
        {
            _htmlC = null;
        }

        public function StartGames(parm:Object = null):void
        {
            screenResize();
            cancelBtn.on(Event.CLICK, this, ClickCancelBtn);
            confirmBtn.on(Event.CLICK, this, ClickConfirmBtn);
            screenCapture();
        }

        private function ClickConfirmBtn():void
        {
            WxC.wxShare(_htmlC);
	    ClickCancelBtn();//wx:注销页面
        }

        private function ClickCancelBtn():void
        {
            UiManager.instance.closePanel("BossShare", false);
        }


        private function screenCapture():void
        {
            if (null == _htmlC)
            {
                this.visible = false;
                _htmlC = Laya.stage.drawToCanvas(Laya.stage.width, Laya.stage.height, 0, 0);
				WxC.wxSaveShareFile(_htmlC);
//                var _texture:Texture = new Texture(_htmlC);
//                shareImg.graphics.drawTexture(_texture, 0, 0, shareImg.width, shareImg.height);
                
            }

        }

        private function screenResize():void
        {
            this.size(Laya.stage.width, Laya.stage.height);
        }

        private function screenShareComplete():void
        {
            UiManager.instance.closePanel("BossShare", false);
        }
		
		private function wxSaveShareFile(path:String):void
		{
			shareImg.loadImage(path, 0, 0, shareImg.width, shareImg.height);
			this.visible = true;
		}
		
        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.on(GameEvent.ScreenShareComplete, this, screenShareComplete);
			GameEventDispatch.instance.on(GameEvent.WxSaveShareFile, this, wxSaveShareFile);
        }

        public function unRegister():void
        {
            _htmlC.destroy();
            _htmlC = null;
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.off(GameEvent.ScreenShareComplete, this, screenShareComplete);
			GameEventDispatch.instance.off(GameEvent.WxSaveShareFile, this, wxSaveShareFile);
        }

    }
}
