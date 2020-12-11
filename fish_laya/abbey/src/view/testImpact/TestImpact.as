package view.testImpact
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class TestImpact extends BaseView implements PanelVo
    {
        public function TestImpact()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(ImpactVIew, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_NORMAL;
        }
    }
}
