package view.resetLoad
{
    import laya.events.Event;

    import manager.ResVo;

    import ui.abbey.ResetLoadUI;

    public class ResetLoadPage extends ResetLoadUI implements ResVo
    {
        private var _type:String;

        public function ResetLoadPage()
        {
            super();
        }

        public function StartGames(parm:Object = null):void
        {
            confirmBtn.on(Event.CLICK, this, clickConfirm);
        }

        private function clickConfirm():void
        {


        }

        public function register():void
        {
        }

        public function unRegister():void
        {
        }
    }
}
