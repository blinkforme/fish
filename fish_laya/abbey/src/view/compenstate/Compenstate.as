package view.compenstate
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class Compenstate extends BaseView implements PanelVo
    {
        public function Compenstate()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(CompenstateView, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
