package view.exchange
{

    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class Exchange extends BaseView implements PanelVo
    {
        public function Exchange()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(ExchangePage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
