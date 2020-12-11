package control
{
    import manager.GameEvent;
    import manager.GameEventDispatch;

    public class AdC
    {

        private static var _instance:AdC

        public function AdC()
        {
            GameEventDispatch.instance.on(GameEvent.ShowAd, this, showAd);

        }

        public function showAd():void
        {
            if (ENV.isShowBannerAndAD())
            {
                if (WxC.isInMiniGame())
                {
                    WxC.instance.showVideoAD()
                }
            }
        }

        public static function get instance():AdC
        {
            return _instance || (_instance = new AdC());
        }
    }
}
