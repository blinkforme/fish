package view.friend
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class Friend extends BaseView implements PanelVo
    {
        public function Friend()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(FriendPage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
