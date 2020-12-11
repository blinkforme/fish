package view.fish
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class Fish extends BaseView implements PanelVo
    {
        public function Fish()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(FishPage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_FIGHT_PAGE;
        }
    }
}
