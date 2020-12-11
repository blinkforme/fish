package control
{
    import manager.GameTools;

    import model.OnLineM;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.UiManager;

    import proto.S2c_22001;
    import proto.S2c_22003;
    import proto.S2c_22004;

    public class OnLineC
    {
        private static var _instance:OnLineC;

        public function OnLineC()
        {
            GameEventDispatch.instance.on(String(22001), this, get_online_award);
            GameEventDispatch.instance.on(String(22003), this, get_online_award_info);
            GameEventDispatch.instance.on(String(22004), this, sync_online_award_info);
            GameEventDispatch.instance.on(GameEvent.SystemReset, this, reset);
            Laya.timer.frameLoop(1, this, this.onLoop);


        }

        private function reset():void
        {
            UiManager.instance.closePanel("OnLineReward", true);

        }

        private function onLoop():void
        {
            //	OnLineM.instance.list;
            OnLineM.instance.timeTick(Laya.timer.delta / 1000);
        }

        public static function get instance():OnLineC
        {
            return _instance || (_instance = new OnLineC());
        }

        private function get_online_award(data:*):void
        {
            var protoData:S2c_22001 = data as S2c_22001;
            //protoData.id = OnLineM.instance.RewardIndex+1;
            if (protoData.code == 0)
            {
                OnLineM.instance.RewardIndex = protoData.id;
                OnLineM.instance.setLeftTime(protoData.lt);
                OnLineM.instance.setAwardId(protoData.id);
                GameEventDispatch.instance.event(GameEvent.OnlineAwardUpdate, protoData);
                GameEventDispatch.instance.event(GameEvent.RewardTip, [[1], [protoData.awardNum]]);
            }
            else if (4 == protoData.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTip, 42);
            }
            else
            {
                GameTools.dealCode(protoData.code)
            }
        }

        private function get_online_award_info(data:*):void
        {

            var protoData:S2c_22003 = data as S2c_22003;
            OnLineM.instance.setLeftTime(protoData.lt);
            OnLineM.instance.setAwardId(protoData.id);
            OnLineM.instance.RewardIndex = protoData.id;
            GameEventDispatch.instance.event(GameEvent.OnlineAwardUpdate);
        }

        private function sync_online_award_info(data:*):void
        {
            var protoData:S2c_22004 = data as S2c_22004;
            OnLineM.instance.RewardIndex = protoData.id;
            OnLineM.instance.setLeftTime(protoData.lt);
            OnLineM.instance.setAwardId(protoData.id);
            OnLineM.instance.RewardIndex = protoData.id;
            GameEventDispatch.instance.event(GameEvent.OnlineAwardUpdate);
        }

    }
}
