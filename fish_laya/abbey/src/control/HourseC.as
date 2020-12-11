package control
{
    import conf.cfg_hId;
    import conf.cfg_hourse;

    import model.HorseM;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.UiManager;

    import model.LevelM;

    public class HourseC
    {
        private static var _instance:HourseC;

        public static function get instance():HourseC
        {
            return _instance || (_instance = new HourseC());
        }

        public function HourseC()
        {
            GameEventDispatch.instance.on(String(21000), this, syncHorseTip);
            GameEventDispatch.instance.on(String(21001), this, syncIsOpenNotice);
        }

        public function syncIsOpenNotice(data:*):void
        {
            if (data.code == 1)
            {
                HorseM.instance.isOpenNotice = true;
            } else
            {
                HorseM.instance.isOpenNotice = false;
            }
        }

        public function loopNotice():void
        {
            Laya.timer.once(HorseM.instance.noticeTime, this, showNotice);
            if (HorseM.instance.oneTimesNotice)
            {
                Laya.timer.once(HorseM.instance.oneTimes, this, loopRankHorseTips);
            }
        }

        private function loopRankHorseTips():void
        {
            if (LevelM.instance.rankDoubleReward)
            {
                HorseM.instance.oneTimesNotice = false;
                cfg_hId.instance(cfg_hourse.instance("7").txt1).txtContent = LevelM.instance.loopMsg();
                var data:Object = {
                    id: 7,
                    agent: true
                };
                HorseM.instance.addHorseTipItem(data);

                if (HorseM.instance.isIn == false)
                {
                    !ENV.isShowDied() && UiManager.instance.loadView("HorseTip");
                }
                HorseM.instance.setInfo();
                GameEventDispatch.instance.event(GameEvent.HorseTipUpdate);
            }
        }

        public function showNotice():void
        {
            if (HorseM.instance.isOpenNotice)
            {
                var data:Object = {
                    id: 6,
                    agent: true
                };
                HorseM.instance.addHorseTipItem(data);

                if (HorseM.instance.isIn == false)
                {
                    !ENV.isShowDied() && UiManager.instance.loadView("HorseTip");
                }
                HorseM.instance.setInfo();
                GameEventDispatch.instance.event(GameEvent.HorseTipUpdate);
            }
            loopNotice();
        }

        private function syncHorseTip(data:*):void
        {
            HorseM.instance.addHorseTipItem(data);

            if (HorseM.instance.isIn == false)
            {
                !ENV.isShowDied() && UiManager.instance.loadView("HorseTip");
            }
            HorseM.instance.setInfo();
            GameEventDispatch.instance.event(GameEvent.HorseTipUpdate);
        }


    }
}
