package view.setting
{

    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class Setting extends BaseView implements PanelVo
    {
        public function Setting()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(SettingPage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
