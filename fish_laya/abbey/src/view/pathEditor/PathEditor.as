package view.pathEditor
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class PathEditor extends BaseView implements PanelVo
    {
        public function PathEditor()
        {
            super();
        }

        public function get pngNum():int
        {
            return 1;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(PathEditorView, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_NORMAL;
        }
    }
}
