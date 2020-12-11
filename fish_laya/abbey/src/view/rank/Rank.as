package view.rank
{

    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class Rank extends BaseView implements PanelVo
    {
        public function Rank()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(RankPage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
