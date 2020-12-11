package view.shop
{

    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class Shop extends BaseView implements PanelVo
    {
        public function Shop()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(ShopPage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
