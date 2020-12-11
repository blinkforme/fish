package control
{
    import model.UpgradeM;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.UiManager;

    public class UpgradeC
    {
        private static var _instance:UpgradeC;

        public function UpgradeC()
        {
            GameEventDispatch.instance.on(GameEvent.UpgradeC, this, gradeC);


        }

        private function gradeC(dataOne:*, isShow:*):void
        {

            UpgradeM.instance.setInfo(dataOne, isShow);
            !ENV.isShowDied() && UiManager.instance.loadView("Levelup");

        }

        public static function get instance():UpgradeC
        {
            return _instance || (_instance = new UpgradeC());
        }
    }
}
