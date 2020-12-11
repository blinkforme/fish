package model
{
    import struct.FriendInfo;

    import view.friend.*;

    import emurs.ShowType;

    import engine.tool.StartParam;

    import laya.utils.Handler;

    import manager.ApiManager;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.UiManager;

    public class FriendM
    {

        private static var _instance:FriendM

        //好友数量限制
        private var _friendLimit:Number = 50
        //搜索好友信息
        private var _findFriendInfo:Object;

        //好友列表
        private var _friendArr:Array;
        //增量好友信息
        private var _deltaFriendArr:Array;
        //好友列表所有信息
        private var _friendObj:Object;

        //申请好友列表
        private var _applyFriendArr:Array;

        //个性签名
        private var _signatureStr:String = "";

        public function FriendM()
        {
            _findFriendInfo = {}
            _friendArr = []
            _applyFriendArr = []

        }

        public static function get instance():FriendM
        {
            return _instance || (_instance = new FriendM())
        }

        public function noApplyFriendList()
        {
            if (!_applyFriendArr || !_applyFriendArr.length || _applyFriendArr.length <= 0)
            {
                return false
            }
            return true
        }

        public function searchFriend(idStr:String, data:* = null, isRobot:Boolean = false):void
        {
            if (_friendArr.length < _friendLimit)
            {
                if (data && isRobot == true && idStr == null)
                {
                    FriendM.instance.SearchFriendSuccess(data, isRobot)
                } else
                {
                    var token:String = StartParam.instance.getParam("access_token");
                    ApiManager.instance.getSearchFriend(token, idStr, Handler.create(this, SearchFriendSuccess), Handler.create(this, SearchFriendError))
                }
            } else
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "好友过多，请删除好友后再试")
            }
        }

        public function SearchFriendSuccess(data:*, isRobot:Boolean = false):void
        {
            if (data.code == "success")
            {
                if (data.data['stauts'] == 1)
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "该玩家已经你的好友")
                } else
                {
                    data.data['robot'] = isRobot
                    FriendM.instance.findFriendInfo = data['data']
                    UiManager.instance.loadView("AddFriend", null)
                }
            }else
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent,data.msg);
            }

        }

        public function SearchFriendError(data:*):void
        {

        }


        public function set findFriendInfo(value:Object):void
        {
            _findFriendInfo = {
                id: value.robot ? null : value.user_id,
                jjhId: value.robot ? null : value.jjh_user_id,
                name: value.nickname,
                icon: value.avatar,
                level: value.level,
                robot: value.robot
            }
        }

        public function get findFriendInfo():Object
        {
            return _findFriendInfo
        }

        public function get friendLimit():Number
        {
            return _friendLimit;
        }

        public function set friendLimit(value:Number)
        {
            _friendLimit = value;
        }

        public function get applyFriendArr():Array
        {
            return _applyFriendArr;
        }

        public function set applyFriendArr(value:Array):void
        {
            _applyFriendArr = value;
        }

        public function get friendArr():Array
        {
            return _friendArr;
        }

        public function set friendArr(value:Array):void
        {
            _friendArr = []
            _friendObj = {}
            for (var i:int = 0; i < value.length; i++)
            {
                var obj:FriendInfo = new FriendInfo()
                obj.rank = value[i][0]
                obj.id = value[i][1]
                obj.name = value[i][2]
                obj.icon = value[i][3]
                obj.level = value[i][4]
                obj.online = value[i][5]
                obj.signature = value[i][6]
                _friendObj[obj.id] = obj
                _friendArr[obj.rank - 1] = obj
            }
        }


        public function get onlineFriendArr():Array
        {
            var curArr:Array = []
            for (var i:int = 0; i < _friendArr.length; i++)
            {
                if (_friendArr[i].online)
                {
                    curArr.push(_friendArr[i])
                }
            }
            return curArr;
        }

        public function get deltaFriendArr():Array
        {
            return _deltaFriendArr;
        }

        public function set deltaFriendArr(value:Array):void
        {
            _deltaFriendArr = []
            for (var i:int = 0; i < value.length; i++)
            {
                var obj:FriendInfo = new FriendInfo()
                obj.rank = value[i][0]
                obj.id = value[i][1]
                obj.name = value[i][2]
                obj.icon = value[i][3]
                obj.level = value[i][4]
                obj.online = value[i][5]
                obj.signature = value[i][6]
                _deltaFriendArr.push(obj)
            }
        }

        public function updateFriendArr()
        {
            var obj:FriendInfo;
            for (var i:int = 0; i < _deltaFriendArr.length; i++)
            {
                obj = _deltaFriendArr[i] as FriendInfo;
                _friendObj[obj.id] = obj
                _friendArr[obj.rank - 1] = obj
            }
        }

        public function get signatureStr():String
        {
            return _signatureStr;
        }

        public function set signatureStr(value:String):void
        {
            _signatureStr = value;
        }
    }
}