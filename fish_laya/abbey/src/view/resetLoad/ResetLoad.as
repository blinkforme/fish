package view.resetLoad
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class ResetLoad extends BaseView implements PanelVo
    {
        public function ResetLoad()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(ResetLoadPage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
