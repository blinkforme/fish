package view.prize
{
    import model.ActivityM;
    import model.RuleM;

    import conf.cfg_goods;

    import laya.display.Text;

    import laya.events.Event;
    import laya.ui.Box;
    import laya.ui.Image;
    import laya.utils.Handler;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;

    import ui.abbey.prizeUI;

    public class PrizeView extends prizeUI implements ResVo
    {
        private var _imgUrl:String;
        private var _count:Number;
        private var goodsId:Number;
        private var _startX:Number = 0;
        private var _startY:Number = 0;

        public function PrizeView()
        {
            super();
        }

        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;
            _startX = this.x;
            _startY = this.y;
            activityBox.visible = false;
            prizeBox.visible = false;
            if (ActivityM.instance.isShowSinceRebate)
            {
                activityBox.visible = true;
                activityBox.array = RuleM.instance.activityID;
                activityBox.repeatX = RuleM.instance.activityID.length;
            } else
            {
                prizeBox.visible = true;
                _imgUrl = RuleM.instance.imageUrl;
                goodsId = RuleM.instance.goodsId;
                _count = RuleM.instance.coinCount;
            }
            priziIcon.skin = _imgUrl;
            coinCount.text = _count + "";
            bmask.on(Event.CLICK, this, clickMask);
            receiveBtn.on(Event.CLICK, this, clickReceive);
            activityBox.renderHandler = new Handler(this, onActivityRender)
            GameEventDispatch.instance.event(GameEvent.UpdateProfile, null);
            GameEventDispatch.instance.event(GameEvent.PlayerCoinChange, null);
            screenResize();
        }

        private function onActivityRender(cell:Box, index:int):void
        {
            var cofig = cell.dataSource;
            var img:Image = cell.getChildByName("activityIcon") as Image;
            var Num:Text = cell.getChildByName("activityNum") as Text;
            img.skin = cfg_goods.instance("" + cofig).icon;
            Num.text = RuleM.instance.activityNum[index] + "";
        }

        private function clickMask():void
        {


        }

        private function clickReceive():void
        {
            if (ActivityM.instance.isShowSinceRebate)
            {
                GameEventDispatch.instance.event(GameEvent.RewardTip, [RuleM.instance.activityID, RuleM.instance.activityNum]);
            } else
            {
                GameEventDispatch.instance.event(GameEvent.RewardTip, [[goodsId], [_count]]);
            }

            UiManager.instance.closePanel("Prize", false);

        }

        private function screenResize():void
        {
            var contentWidth:int = 700;//组件范围width
            var contentHeight:int = 450;//组件范围height
            var contentStartX:int = 290;//组件左边距
            var contentStartY:int = 155;//组件上边距
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
            this.x = _startX
            this.y = _startY;
            RuleM.instance.coinCount = 0;
            _count = 0;
            GameEventDispatch.instance.event(GameEvent.UpdateProfile, null);
            GameEventDispatch.instance.event(GameEvent.FightCoinUpdate, null);
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
        }
    }
}
