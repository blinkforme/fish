package view.insideNotice
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class InsideNotice extends BaseView implements PanelVo
    {
        public function InsideNotice()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(InsidePage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_MSG_TIP;
        }
    }
}
