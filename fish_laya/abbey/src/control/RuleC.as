package control
{
    import model.RuleM;

    import emurs.ShowType;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.UiManager;

    public class RuleC
    {
        private static var _instance:RuleC;

        public function RuleC()
        {
            GameEventDispatch.instance.on(GameEvent.GetGoldPoolAward, this, getGoldPoolAward);
        }

        private function getGoldPoolAward(data:*):void
        {
            RuleM.instance.coinCount = data.value;
            RuleM.instance.goodsId = 1;
            RuleM.instance.activityID = data.reward_item_ids;
            RuleM.instance.activityNum = data.reward_item_nums;
            !ENV.isShowDied() && UiManager.instance.loadView("Prize", null, ShowType.SMALL_TO_BIG);


        }

        public static function get instance():RuleC
        {
            return _instance || (_instance = new RuleC());
        }
    }
}
