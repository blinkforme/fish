package view.sgBrokePage
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class SgBrokePage extends BaseView implements PanelVo
    {
        public function SgBrokePage()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(SgBrokeView, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DISCONNECT;
        }
    }
}
