package view.useTicket
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class UseTicket extends BaseView implements PanelVo
    {

        public function UseTicket()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(UseTicketPage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }

    }

}