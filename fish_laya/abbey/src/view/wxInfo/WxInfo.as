package view.wxInfo
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class WxInfo extends BaseView implements PanelVo
    {
        public function WxInfo()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(WxInfoPage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
