package view.fishType
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class FishType extends BaseView implements PanelVo
    {
        public function FishType()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(FishTypeView, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
