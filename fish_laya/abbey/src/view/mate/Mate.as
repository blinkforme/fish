package view.mate
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class Mate extends BaseView implements PanelVo
    {
        public function Mate()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(MateView, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
