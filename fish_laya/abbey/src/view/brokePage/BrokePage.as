package view.brokePage
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class BrokePage extends BaseView implements PanelVo
    {
        public function BrokePage()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(BrokePageIVew, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DISCONNECT;
        }
    }
}
