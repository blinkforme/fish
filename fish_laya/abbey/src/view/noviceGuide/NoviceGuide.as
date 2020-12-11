package view.noviceGuide
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class NoviceGuide extends BaseView implements PanelVo
    {
        public function NoviceGuide()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(NoviceGuidePage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_GUIDE;
        }
    }
}
