package view.pack
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class Pack extends BaseView implements PanelVo
    {
        public function Pack()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(PackPage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
