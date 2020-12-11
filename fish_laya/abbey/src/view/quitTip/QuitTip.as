package view.quitTip
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class QuitTip extends BaseView implements PanelVo
    {
        public function QuitTip()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(QuitTipView, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DISCONNECT;
        }
    }
}
