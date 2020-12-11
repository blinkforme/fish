package view.newMatch
{

    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class NewMatch extends BaseView implements PanelVo
    {
        public function NewMatch()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(NewMatchPage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
