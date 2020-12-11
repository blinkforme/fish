package model
{
    import laya.display.Sprite;

    import manager.GameTools;

    import model.FightM;

    public class MatchM
    {

        private static var _instance:MatchM;
        private var _isMatchSart:Number = 0;//比赛是否开始
        private var _prepareState:Object = {1: 0, 2: 0, 3: 0, 4: 0};//房间内准备状态
        private var _roomName:String = "";//房主名字
        private var _roomTime:Number = 0;//房间持续时间
        private var _contestFee:Number = 0;//房间报名费
        private var _theRoomNumber:Number = -1;//房间人数
        private var _prepareNum:Number = -1;//准备人数
        private var _resultMsg:Object;
        private var _findRoomData:Object;//通过房间号查询到的比赛id 消耗id 消耗num

        private var _matchData:Object
        private var _storageData:Object

        private var _contest_open:Number = 0; //比赛场开关 1:开启 2:关闭

        private var _offLineInfoMsg:Array = []
        private var _offLineSeatIndex:Array = [];

        public function MatchM()
        {

        }

        public static function get instance():MatchM
        {
            return _instance || (_instance = new MatchM());
        }

        public function set matchData(value:Object):void
        {
            _matchData = value
        }

        public function get matchData():Object
        {
            return _matchData
        }

        public function set contestOpen(value:Number):void
        {
            _contest_open = value
        }

        public function get contestOpen():Number
        {
            return _contest_open
        }

        public function set storageData(value:Object):void
        {
            _storageData = value
        }

        public function get storageData():Object
        {
            return _storageData
        }

        public function initMatchimgGameData(againGame:Boolean = false):void
        {
            _isMatchSart = 0;
            if (!againGame)
            {
                _prepareState = {1: 0, 2: 0, 3: 0, 4: 0};
                _theRoomNumber = -1;
                _roomName = "";
                _prepareNum = -1;
                _roomTime = 0;
                _contestFee = 0;
            }
        }

        /**
         * 玩家限时准备   倒计时
         */
        public function matchCountDown(end_time:Number, element:Object):void
        {

            var now:Number = new Date().getTime() as Number

            var now_time:Number = Math.floor((now / 1000));

            var diff_time:Number = end_time;//end_time - now_time

            if (diff_time < 0)
            {
                diff_time = 0
            }


            var minutesleft:* = Math.floor(((diff_time) % 3600) / 60)

            var secondsleft:* = (diff_time) % 60;

            //format 0 prefixes
            if (minutesleft < 10) minutesleft = "0" + minutesleft;
            if (secondsleft < 10) secondsleft = "0" + secondsleft;
            element.text = "准备倒计时：" + minutesleft + ":" + secondsleft;
        }

        /**
         * 是否打开了结算界面
         */
        public function isMatchSettleShow():Boolean
        {
            var ret:Boolean = false;
            var uiLayer:Sprite = null;
            for (var i:int = 0; i < Laya.stage.numChildren; i++)
            {
                uiLayer = Laya.stage.getChildAt(i) as Sprite;

                if (uiLayer && uiLayer.visible && uiLayer.name.length > 0)
                {
                    if (uiLayer.name == "MatchSettle")
                    {
                        ret = true;
                        break;
                    }
                }

            }
            return ret;
        }

        public function get isMatchSart():Number
        {
            return _isMatchSart;
        }

        public function set isMatchSart(value:Number):void
        {
            if (_isMatchSart == 0 && value == 1)
            {
                _offLineSeatIndex = null;
            }
            _isMatchSart = value;
        }

        public function setPrepareState(stateArr:Array):void
        {
            var perpareNum:Number = 0;
            for (var i:int = 0; i < stateArr.length; i++)
            {
                var seatId:Number = FightM.instance.getShowSeatId(i + 1);
                _prepareState[seatId] = stateArr[i];
                if (_prepareState[seatId] == 1)
                {
                    perpareNum++;
                }
            }
            _prepareNum = perpareNum;
        }

        public function matchNameRule(curName:String):String
        {
            if (FightM.instance.isMatchingGame() && curName.length > 2)
            {
                return "***" + curName.slice(2);
            } else if (FightM.instance.isMatchingGame() && curName.length == 2)
            {
                return "***" + curName.slice(1);
            } else
            {
                return curName
            }
        }

        public function get prepareState():Object
        {
            return _prepareState;
        }

        public function get roomName():String
        {
            return _roomName;
        }

        public function set roomName(value:String):void
        {
            _roomName = value;
        }

        public function get theRoomNumber():Number
        {
            return _theRoomNumber;
        }

        public function set theRoomNumber(value:Number):void
        {
            _theRoomNumber = value;
        }

        public function get prepareNum():Number
        {
            return _prepareNum;
        }

        public function get resultMsg():Object
        {
            return _resultMsg;
        }

        public function set resultMsg(value:Object):void
        {
            _resultMsg = value;
        }

        public function get findRoomData():Object
        {
            return _findRoomData;
        }

        public function set findRoomData(value:Object):void
        {
            _findRoomData = value;
        }

        public function get roomTime():Number
        {
            return _roomTime;
        }

        public function set roomTime(value:Number):void
        {
            _roomTime = value;
        }

        public function get contestFee():Number
        {
            return _contestFee;
        }

        public function set contestFee(value:Number):void
        {
            _contestFee = value;
        }

        public function get offLineSeatIndex():Array
        {
            return _offLineSeatIndex;
        }

        public function setOffLineSeatIndex(value:Number):void
        {
            if (!_offLineSeatIndex)
            {
                _offLineSeatIndex = [];
                _offLineInfoMsg = [];
                var seatInfo = FightM.instance.getSeatInfo(value);
                _offLineSeatIndex.push(value);
                _offLineInfoMsg[value] = ({
                    name: LoginInfoM.instance.filterName(GameTools.formatNickName(MatchM.instance.matchNameRule(seatInfo.name), 8)),
                    me: 0,
                    num: seatInfo.contestScore
                });
            } else
            {
                if (_offLineSeatIndex.indexOf(value) < 0)
                {
                    var seatInfo = FightM.instance.getSeatInfo(value);
                    _offLineSeatIndex.push(value);
                    _offLineInfoMsg[value] = ({
                        name: LoginInfoM.instance.filterName(GameTools.formatNickName(MatchM.instance.matchNameRule(seatInfo.name), 8)),
                        me: 0,
                        num: seatInfo.contestScore
                    });
                }
            }
        }

        public function get offLineInfoMsg():Array
        {
            return _offLineInfoMsg;
        }
    }
}
