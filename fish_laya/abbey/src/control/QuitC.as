package control
{
    import model.QuitM;

    import emurs.ShowType;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.UiManager;

    public class QuitC
    {
        private static var _instance:QuitC;

        public function QuitC()
        {
            GameEventDispatch.instance.on(GameEvent.QuitTip, this, QuitTip);
        }

        private function QuitTip(data:*):void
        {

            QuitM.instance.setTipInfo(data);
            UiManager.instance.loadView("QuitTip", null, ShowType.SMALL_TO_BIG);
        }

        public static function get instance():QuitC
        {
            return _instance || (_instance = new QuitC());
        }


    }
}
