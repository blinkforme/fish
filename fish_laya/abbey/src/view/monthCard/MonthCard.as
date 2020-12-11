package view.monthCard
{

    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class MonthCard extends BaseView implements PanelVo
    {
        public function MonthCard()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(MonthCardPage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
