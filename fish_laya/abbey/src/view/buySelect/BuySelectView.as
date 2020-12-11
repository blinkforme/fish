package view.buySelect
{


    import conf.cfg_commodity;

    import control.ShopC;

    import laya.events.Event;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;

    import ui.abbey.BuySelectPageUI;

    public class BuySelectView extends BuySelectPageUI implements ResVo
    {

        private var _startX:Number = 0;
        private var _startY:Number = 0;
        private var _config:cfg_commodity;
        private var _pmList:Array;
        private var _boxid;

        public function BuySelectView()
        {
            super();
        }

        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;
            _startX = this.x;
            _startY = this.y;
            _config = parm.buyGoodsCfg;
            _pmList = parm.pmList
            _boxid = parm.boxid
            closeBtn.on(Event.CLICK, this, clickClose);
            alipay.on(Event.CLICK, this, clickPay,[1]);
            weChatPay.on(Event.CLICK, this, clickPay,[2]);
            screenResize();
        }

        private function clickPay(payType:int):void
        {
            if (payType  == 1)
            {
                ShopC.instance.callBuy(_config,_boxid,2)
            }else if (payType == 2){
                ShopC.instance.callBuy(_config,_boxid,55)
            }
        }

        private function screenResize():void
        {
            bmask.width = Laya.stage.width * 2;
            bmask.height = Laya.stage.height * 2;
            this.size(Laya.stage.width, Laya.stage.height);
        }


        private function clickClose():void
        {
            UiManager.instance.closePanel("BuySelect", false);
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
