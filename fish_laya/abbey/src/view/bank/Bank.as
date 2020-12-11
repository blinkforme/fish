package view.bank
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class Bank extends BaseView implements PanelVo
    {
        public function Bank()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(BankPage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
