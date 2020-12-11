package control
{
    import manager.WebSocketManager;

    import model.ActivityM;
    import model.CertificationM;
    import model.LevelM;
    import model.LoginM;
    import model.RegiM;

    import emurs.ShowType;

    import manager.GameConst;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.UiManager;

    import struct.CertificationInfo;

    public class RegiC
    {
        private static var _instance:RegiC;
        private var on_off:Number = 0;

        public function RegiC()
        {
            GameEventDispatch.instance.on(GameEvent.SignInUpdate, this, signUpdate);
            GameEventDispatch.instance.on(GameEvent.Regic, this, startRegic);
        }

        private function startRegic():void
        {
            if (!LoginM.instance.isCompleteCertification && on_off == 0)
            {
                on_off += 1
            } else
            {
                if (RegiM.instance.isRegic)
                {
                    RegiM.instance.isToday = true;
                    if (RegiM.instance.isGet)
                    {
                        ActivityM.instance.loginNew = true;
                        UiManager.instance.loadView("Register", null, ShowType.SMALL_TO_BIG);
                    } else
                    {
                        if (LevelM.instance.isPopupRankPage == 1)
                        {
                            UiManager.instance.loadView("Rank", null, ShowType.SMALL_TO_BIG);
                        } else
                        {
                            if (ActivityM.instance.loginNew && ActivityM.instance.activityIsProceed(GameConst.activity_common))
                            {
                                if (!ActivityM.instance.loginShowActivityPannel)
                                {
                                    ActivityM.instance.loginNew = false;
                                    ActivityM.instance.loginShowActivityPannel = true;
                                    ENV.branchSwitch("useTicket") && UiManager.instance.loadView("UseTicket", null, ShowType.SMALL_TO_BIG);
                                }
                            }
                        }
                    }
                }
            }
        }

        private function signUpdate():void
        {
            RegiM.instance.isRegic = true;
            if (RegiM.instance.isToday)
            {
                if (RegiM.instance.isGet)
                {
                    UiManager.instance.loadView("Register", null, ShowType.SMALL_TO_BIG);
                }

            }

            //startSign();
        }

        public static function get instance():RegiC
        {
            return _instance || (_instance = new RegiC());
        }

        private function startSign():void
        {
            if (RegiM.instance.isGet)
            {
                UiManager.instance.loadView("Register", null, ShowType.SMALL_TO_BIG);
            }
        }
    }
}
