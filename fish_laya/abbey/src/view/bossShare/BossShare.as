package view.bossShare
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class BossShare extends BaseView implements PanelVo
    {
        public function BossShare()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(BossSharePage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
