package view.firstCharge
{

    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class FirstCharge extends BaseView implements PanelVo
    {
        public function FirstCharge()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(FirstChargePage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
