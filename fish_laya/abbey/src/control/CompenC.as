package control
{
    import model.CompenM;

    import emurs.ShowType;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.UiManager;

    public class CompenC
    {
        private static var _instance:CompenC;

        public function CompenC()
        {
            GameEventDispatch.instance.on(GameEvent.OpenMakeUp, this, openMakeUp);
            GameEventDispatch.instance.on(String(10022), this, startMake);
            //GameEventDispatch.instance.on(GameEvent.TestCom, this, startMake);

        }

        private function startMake(data:*):void
        {
            //if(CompenM.instance.currentTimes<=CompenM.instance.totalTimes){
            //trace("跳出来啊");
            if (data.from && data.from > 0)
            {
                CompenM.instance.rewardFrom = data.from;
            }
            CompenM.instance.compenArr = data.show;
            !ENV.isShowDied() && UiManager.instance.loadView("Compenstate", null, ShowType.SMALL_TO_BIG);
            //}
        }

        private function openMakeUp(data:*):void
        {
            //if(CompenM.instance.currentTimes!=4){
            if (CompenM.instance.currentTimes <= CompenM.instance.totalTimes)
            {
                //trace(data+"-----");
                //CompenM.instance.compenArr=data;
                !ENV.isShowDied() &&  UiManager.instance.loadView("Compenstate", null, ShowType.SMALL_TO_BIG);
            }


        }

        public static function get instance():CompenC
        {
            return _instance || (_instance = new CompenC());
        }
    }
}
