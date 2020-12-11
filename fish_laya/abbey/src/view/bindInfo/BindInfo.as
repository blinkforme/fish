package view.bindInfo
{
    import view.quickRegister.*;
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class BindInfo extends BaseView implements PanelVo
    {
        public function BindInfo()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(BindInfoView, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
