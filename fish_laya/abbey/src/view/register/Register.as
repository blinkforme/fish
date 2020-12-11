package view.register
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class Register extends BaseView implements PanelVo
    {
        public function Register()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(RegisterPage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
