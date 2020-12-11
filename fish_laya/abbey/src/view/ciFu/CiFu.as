package view.ciFu
{
    import view.brokePage.*;
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class CiFu extends BaseView implements PanelVo
    {
        public function CiFu()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(CiFuPage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
