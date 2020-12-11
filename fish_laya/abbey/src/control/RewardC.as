package control
{

    import model.RewardM;

    import emurs.ShowType;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.UiManager;

    public class RewardC
    {
        private static var _instance:RewardC;
        private var isCLose:Boolean = false;

        public function RewardC()
        {
            GameEventDispatch.instance.on(String(15005), this, updateRecord);
            GameEventDispatch.instance.on(GameEvent.RewardFish, this, rewardTip);
            GameEventDispatch.instance.on(GameEvent.SystemReset, this, closePanel);

            //收藏小程序奖励
            GameEventDispatch.instance.on(String(39002), this, isCollectReward);
            GameEventDispatch.instance.on(String(39004), this, isCollectReturn)

        }

        private function updateRecord(data:*):void
        {
            if (data != null)
            {
                RewardM.instance.currentList = data.list;
                GameEventDispatch.instance.event(GameEvent.RefreshLotteryRecord);
            }
        }

        private function closePanel():void
        {

            if (isCLose)
            {
                //trace("我也过来了啊");
                UiManager.instance.closePanel("RewardPage", true);
            }

        }

        private function rewardTip(data:*):void
        {
            //trace("进入抽奖");
            isCLose = true;
            RewardM.instance.setInfo();
            UiManager.instance.loadView("RewardPage", null, ShowType.SMALL_TO_BIG);

        }

        private function isCollectReward(data:*):void
        {
            RewardM.instance._isCollect = data["is_receive"];
            RewardM.instance._isFristCollect = data["is_collect"]
            GameEventDispatch.instance.event(GameEvent.isCollect);
        }

        public static function get instance():RewardC
        {
            return _instance || (_instance = new RewardC());
        }

        private function isCollectReturn(data:*):void
        {
            if (data.code == 1)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "今天已经领取过")
            }
        }
    }
}
