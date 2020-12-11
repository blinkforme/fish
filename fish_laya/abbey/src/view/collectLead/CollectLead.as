package view.collectLead
{

    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class CollectLead extends BaseView implements PanelVo
    {
        public function CollectLead()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(CollectLeadPage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
