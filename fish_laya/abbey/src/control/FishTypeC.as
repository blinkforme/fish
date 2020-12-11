package control
{
    import model.FishTypeM;

    import emurs.ShowType;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.UiManager;

    public class FishTypeC
    {
        private static var _instance:FishTypeC;

        public function FishTypeC()
        {
            GameEventDispatch.instance.on(GameEvent.FishTypeC, this, FishTip);
        }

        private function FishTip(data:*):void
        {
            FishTypeM.instance.setInfo();
            UiManager.instance.loadView("FishType", null, ShowType.SMALL_TO_BIG);

        }

        public static function get instance():FishTypeC
        {
            return _instance || (_instance = new FishTypeC());
        }
    }
}
