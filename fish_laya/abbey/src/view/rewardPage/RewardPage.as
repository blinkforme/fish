package view.rewardPage
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class RewardPage extends BaseView implements PanelVo
    {
        public function RewardPage()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(RewardPageView, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
