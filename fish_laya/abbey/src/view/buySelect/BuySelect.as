package view.buySelect
{
    import view.quitTip.*;
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class BuySelect extends BaseView implements PanelVo
    {
        public function BuySelect()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(BuySelectView, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DISCONNECT;
        }
    }
}
