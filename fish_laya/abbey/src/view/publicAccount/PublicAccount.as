package view.publicAccount
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class PublicAccount extends BaseView implements PanelVo
    {
        public function PublicAccount()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(PublicAccountPage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DISCONNECT;
        }
    }
}
