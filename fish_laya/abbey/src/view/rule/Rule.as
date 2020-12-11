package view.rule
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class Rule extends BaseView implements PanelVo
    {
        public function Rule()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(RuleView, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
