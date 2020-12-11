package view.load
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class Load extends BaseView implements PanelVo
    {
        public function Load()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(LoadPageView, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_ERROR_TIP;
        }
    }
}
