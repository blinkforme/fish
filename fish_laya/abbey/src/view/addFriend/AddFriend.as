package view.addFriend
{
    import emurs.UiType;

    import manager.BaseView;
    import manager.PanelVo;

    public class AddFriend extends BaseView implements PanelVo
    {
        public function AddFriend()
        {
            super();
        }

        public function get pngNum():int
        {
            return 0;
        }

        public function startGame(parm:Object = null, name:String = null):void
        {
            creatPanel(AddFriendPage, parm, name);
        }

        public function get uiType():String
        {
            return UiType.UI_TYPE_DLG;
        }
    }
}
