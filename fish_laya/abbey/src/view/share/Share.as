package view.share
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class Share extends BaseView implements PanelVo
    {
        public function Share()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(SharePage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
