package view.feedBack
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class FeedBack extends BaseView implements PanelVo
    {
        public function FeedBack()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(FeedBackPage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
