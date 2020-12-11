package view.rule
{
    import model.ActivityM;

    import conf.cfg_goods;

    import laya.events.Event;

    import manager.GameConst;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;

    import model.FightM;

    import ui.abbey.ruleUI;

    public class RuleView extends ruleUI implements ResVo
    {
        private var _startX:Number = 0;
        private var _startY:Number = 0;

        public function RuleView()
        {
            super();
        }

        public function StartGames(parm:Object = null):void
        {
            activityBox.visible = false;
            nomalBox.visible = false;
            _startX = this.x;
            _startY = this.y;
            if (ActivityM.instance.isShowSinceRebate)
            {
                activityBox.visible = true
                var awardArr:Array = ActivityM.instance._getCommonActivityConfig(GameConst.activity_common_since)["award"] as Array;
                awardImg.skin = cfg_goods.instance(awardArr[0]).icon;
                award.text = awardArr[1] + "";
            } else
            {
                nomalBox.visible = true;
            }
            screenResize();
        }

        private function screenResize():void
        {
            this.size(Laya.stage.width, Laya.stage.height);
        }

        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            bmask.on(Event.CLICK, this, clickPanel);
        }

        private function clickPanel():void
        {
            UiManager.instance.closePanel("Rule", false);
        }

        public function unRegister():void
        {
            this.x = _startX;
            this.y = _startY;
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            this.off(Event.CLICK, this, clickPanel);
        }
    }
}
