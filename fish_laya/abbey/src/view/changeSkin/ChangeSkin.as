package view.changeSkin
{

    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class ChangeSkin extends BaseView implements PanelVo
    {
        public function ChangeSkin()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(ChangeSkinPage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
