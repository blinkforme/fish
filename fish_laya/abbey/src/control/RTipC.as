package control
{
    import model.RTipM;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.UiManager;

    public class RTipC
    {
        private static var _instance:RTipC;

        public function RTipC()
        {
            GameEventDispatch.instance.on(GameEvent.RewardTip, this, RewardTip);
        }

        private function RewardTip(dataOne:*, dataTwo:*, isShow:*):void
        {
            RTipM.instance.setInfo(dataOne, dataTwo, isShow);
            UiManager.instance.loadView("RewardTip");
        }

        public static function get instance():RTipC
        {
            return _instance || (_instance = new RTipC());
        }
    }
}
