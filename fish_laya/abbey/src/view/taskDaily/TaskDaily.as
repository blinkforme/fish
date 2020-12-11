package view.taskDaily
{

    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class TaskDaily extends BaseView implements PanelVo
    {
        public function TaskDaily()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(TaskDailyPage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
