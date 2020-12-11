package view.prize
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class Prize extends BaseView implements PanelVo
    {
        public function Prize()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(PrizeView, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
