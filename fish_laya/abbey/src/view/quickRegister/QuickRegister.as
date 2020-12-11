package view.quickRegister
{
    import view.certification.*;
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class QuickRegister extends BaseView implements PanelVo
    {
        public function QuickRegister()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(QuickRegisterView, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
