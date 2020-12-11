package control
{
    import model.FriendM;

    import manager.GameEvent;
    import manager.GameEventDispatch;


    public class FriendC
    {

        private static var _instance:FriendC

        public function FriendC()
        {
            GameEventDispatch.instance.on(String(70000), this, intoGameSynAllFriendInfo)
            GameEventDispatch.instance.on(String(70001), this, synFriendInfo)
            GameEventDispatch.instance.on(String(70002), this, synApplyFriendList)
        }

        public static function get instance():FriendC
        {
            return _instance || (_instance = new FriendC())
        }

        private function intoGameSynAllFriendInfo(data:*)
        {
            if (data['friends_list'])
            {
                FriendM.instance.friendArr = data['friends_list']
                if (data['friend_remark'])
                {
                    FriendM.instance.signatureStr = data['friend_remark']
                }
                GameEventDispatch.instance.event(GameEvent.refreshFriendList)
            }

        }

        private function synFriendInfo(data:*)
        {
            if (data['delta_friends_list'])
            {
                FriendM.instance.deltaFriendArr = data['delta_friends_list']
                FriendM.instance.updateFriendArr()
                if (data['friend_remark'])
                {
                    FriendM.instance.signatureStr = data['friend_remark']
                }
                GameEventDispatch.instance.event(GameEvent.refreshFriendList)
            }
        }

        private function synApplyFriendList(data:*)
        {
            if (data['list'])
            {
                FriendM.instance.applyFriendArr = data['list']
                GameEventDispatch.instance.event(GameEvent.refreshApplyFriendList)
            }
        }


    }
}