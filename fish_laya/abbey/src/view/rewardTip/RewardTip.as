package view.rewardTip
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class RewardTip extends BaseView implements PanelVo
    {
        public function RewardTip()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(RewardTipView, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_MSG_TIP;
        }
    }
}
