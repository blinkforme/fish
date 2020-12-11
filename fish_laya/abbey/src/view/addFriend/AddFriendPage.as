package view.addFriend
{
    import engine.tool.StartParam;

    import laya.events.Event;
    import laya.utils.Handler;

    import manager.ApiManager;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.GameTools;
    import manager.ResVo;
    import manager.ShieldWordManager;
    import manager.UiManager;

    import model.LoginInfoM;

    import ui.abbey.AddFriendPageUI;

    import model.FriendM;


    public class AddFriendPage extends AddFriendPageUI implements ResVo
    {

        public function AddFriendPage()
        {

        }

        public function StartGames(parm:Object = null):void
        {
            bmask.on(Event.CLICK, this, null)
            cancelBtn.on(Event.CLICK, this, onQuitBtn)
            confirmBtn.on(Event.CLICK, this, onConfirmBtn)
            initBox()
            screenResize();
        }

        private function initBox()
        {
            if (FriendM.instance.findFriendInfo.icon && String(FriendM.instance.findFriendInfo.icon).length > 0)
            {
                icon.skin = FriendM.instance.findFriendInfo.icon + ""
            } else
            {
                icon.skin = "ui/common/nan.png"
            }

            level.text = "LV." + String(FriendM.instance.findFriendInfo.level)
            if (FriendM.instance.findFriendInfo.jjhId)
            {
                idLabel.text = "ID:" + String(FriendM.instance.findFriendInfo.jjhId)
            } else
            {
                idLabel.text = "ID:" + "*******"
            }
            nameLabel.text = LoginInfoM.instance.filterName(GameTools.formatNickName(String(FriendM.instance.findFriendInfo.name)));
        }

        private function onConfirmBtn():void
        {
            if (!FriendM.instance.findFriendInfo.robot)
            {
                var msgStr:String
                var nullReg:RegExp = /^\s*$/
                if (desInput.text.length <= 0 || nullReg.test(desInput.text))
                {
                    msgStr = "加个好友一起捕鱼吧！"
                } else
                {

                    msgStr = ShieldWordManager.instance.filterInfo(desInput.text)
                    msgStr = LoginInfoM.instance.filterName(msgStr)
                    desInput.text = msgStr
                }
                var token:String = StartParam.instance.getParam("access_token")
                var idStr:String = String(FriendM.instance.findFriendInfo.id)
                ApiManager.instance.getAddFriend(token, idStr, msgStr, Handler.create(this, addFriendSuccess), Handler.create(this, addFriendError))
            } else
            {
                onQuitBtn()
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "已发送")
            }
        }

        public function addFriendSuccess(data:*):void
        {
            onQuitBtn()
            if (data.code == "success")
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "已发送")
            } else
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, data.msg)
            }
        }

        public function addFriendError(data:*):void
        {

        }

        private function onQuitBtn()
        {
            desInput.text = ""
            UiManager.instance.closePanel("AddFriend", true)
        }

        private function screenResize():void
        {
            this.size(Laya.stage.width, Laya.stage.height);
        }

        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);

        }

        public function unRegister():void
        {
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
        }

    }
}
