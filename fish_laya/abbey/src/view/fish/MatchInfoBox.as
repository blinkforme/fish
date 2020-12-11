package view.fish
{

    import laya.events.Event;
    import laya.ui.Box;
    import laya.ui.Image;
    import laya.ui.Label;
    import laya.utils.Handler;

    import manager.GameConst;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.GameTools;

    import model.FightM;
    import model.LoginInfoM;
    import model.MatchM;
    import model.MatchM;
    import model.RoleInfoM;

    import proto.ProtoSeatInfo;

    import ui.fight.matchInfoBoxUI;

    public class MatchInfoBox
    {
        private var _view:matchInfoBoxUI;

        //[{name:我是玩家,num:111,me:0}]
        private var _listInfo:Array;

        public function MatchInfoBox()
        {
            _listInfo = [];
        }

        private static var _instance:MatchInfoBox;

        public static function get instance():MatchInfoBox
        {
            return _instance || (_instance = new MatchInfoBox());
        }

        public function init(view:matchInfoBoxUI)
        {
            _view = view;
            _view.on(Event.MOUSE_DOWN, this, downSkip);
            _view.list.renderHandler = new Handler(this, renderHandlerList)
        }

        private function renderHandlerList(cell:Box, index:int):void
        {
            var config:Object = cell.dataSource;
            var ele_myselfImg:Image = cell.getChildByName("myselfImg") as Image;
            var ele_firstImg:Image = cell.getChildByName("firstImg") as Image;
            var ele_rank:Label = cell.getChildByName("rank") as Label;
            var ele_name:Label = cell.getChildByName("name") as Label;
            var ele_money:Label = cell.getChildByName("money") as Label;
            ele_firstImg.visible = false;
            ele_myselfImg.visible = false;
            ele_rank.color = "#ffffff";
            ele_name.color = "#ffffff";
            ele_money.color = "#ffffff";
            if (index == 0)
            {
                ele_firstImg.visible = true;
            }
            if (config.me == 1)
            {
                ele_rank.color = "#fbff80";
                ele_name.color = "#fbff80";
                ele_money.color = "#fbff80";
                ele_myselfImg.visible = true;
            }
            ele_rank.text = (index + 1) + "";
            ele_name.text = config.name + "";
            ele_money.text = config.num + "";
        }

        private function downSkip(event:Event):void
        {
            event.stopPropagation();
        }

        private function matchingSynRoomData():void
        {
            var roomCount:String = (MatchM.instance.contestFee / 10000).toFixed(0);
            if (roomCount.length <= 2)
            {
                _view.title.fontSize = 23;
            } else
            {
                _view.title.fontSize = 19;
            }
            _view.title.text = roomCount + "万";
            _view.roomText.text = "创建者:" + LoginInfoM.instance.filterName(GameTools.formatNickName(MatchM.instance.matchNameRule(MatchM.instance.roomName),16));
            FightM.instance.initCountDown(MatchM.instance.roomTime, _view.countDownLabel);
        }

        public function countPlayerRankInfo():void
        {
            var seatInfo:ProtoSeatInfo;
            var listTemp:Array = [];
            var seatId:Number = 0;
            var objTemp:Object = {};
            for (var i:int = 1; i <= 4; i++)
            {
                objTemp = {};
                seatInfo = new ProtoSeatInfo();
                seatId = FightM.instance.getSeatIdByShowSeatId(i);
                if (MatchM.instance.offLineSeatIndex && MatchM.instance.offLineSeatIndex.indexOf(seatId) >= 0)
                {
                    objTemp.name = MatchM.instance.offLineInfoMsg[seatId].name;
                    objTemp.me = MatchM.instance.offLineInfoMsg[seatId].me;
                    objTemp.num = MatchM.instance.offLineInfoMsg[seatId].num;
                    listTemp.push(objTemp);
                } else
                {
                    seatInfo = FightM.instance.getSeatInfo(seatId);
                    if (seatInfo)
                    {
                        objTemp.name = LoginInfoM.instance.filterName(GameTools.formatNickName(MatchM.instance.matchNameRule(seatInfo.name), 8));
                        if (i == 1)
                        {
                            objTemp.me = 1;
                            objTemp.num = RoleInfoM.instance.getContestScore() - FightM.instance.getGoodsUnreachNum(seatInfo.agent, GameConst.currency_contest_score);
                        } else
                        {
                            objTemp.me = 0;
                            objTemp.num = seatInfo.contestScore
                        }
                        listTemp.push(objTemp);
                    }
                }
            }
            if (MatchM.instance.isMatchSart == 1)
            {
                _listInfo = listTemp.sort(sortContestScore);
            } else
            {
                _listInfo = listTemp;
            }
            _view.list.array = _listInfo;
        }

        private function sortContestScore(a, b)
        {
            if (a.num >= b.num)
            {
                return -1;
            } else
            {
                return 1;
            }
        }


        public function register():void
        {
            if (!_view)
            {
                return
            }
            GameEventDispatch.instance.on(GameEvent.MatchingSynRoomData, this, matchingSynRoomData);
            GameEventDispatch.instance.on(GameEvent.MatchingGameSynState, this, countPlayerRankInfo);
        }

        public function unRegister():void
        {
            if (!_view)
            {
                return
            }
            GameEventDispatch.instance.off(GameEvent.MatchingSynRoomData, this, matchingSynRoomData);
            GameEventDispatch.instance.off(GameEvent.MatchingGameSynState, this, countPlayerRankInfo);
        }

        public function resetUi():void
        {
            if (!_view)
            {
                return
            }
            _view.visible = FightM.instance.isMatchingGame()
            if (_view.visible)
            {
                FightM.instance.initCountDown(FightM.instance.getContestEndTime(), _view.countDownLabel);
            }
        }

        public function updateTime()
        {
            if (!_view)
            {
                return
            }
            if (_view.visible && MatchM.instance.isMatchSart == 1)
            {
                FightM.instance.contestEndTimeSub();
                FightM.instance.initCountDown(FightM.instance.getContestEndTime(), _view.countDownLabel);
            }
        }
    }
}
