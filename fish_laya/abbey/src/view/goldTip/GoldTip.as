package view.goldTip
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class GoldTip extends BaseView implements PanelVo
    {
        public function GoldTip()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(GoldView, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_MSG_TIP;
        }
    }
}
