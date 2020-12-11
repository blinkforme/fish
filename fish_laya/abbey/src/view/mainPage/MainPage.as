package view.mainPage
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class MainPage extends BaseView implements PanelVo
    {

        public function MainPage()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(MainPageView, parm, name);

        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_NORMAL;
        }
    }
}
