package view.taskNew
{

    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class TaskNew extends BaseView implements PanelVo
    {
        public function TaskNew()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(TaskNewPage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
