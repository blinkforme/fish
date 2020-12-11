package view.redActivity
{
    import view.red.*;

    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class RedActivity extends BaseView implements PanelVo
    {
        public function RedActivity()
        {
            super();

        }


        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(RedActivityPage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
