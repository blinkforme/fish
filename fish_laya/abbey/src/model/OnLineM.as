package model
{
    import conf.cfg_goods;
    import conf.cfg_onLine;

    import manager.ConfigManager;
    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;

    public class OnLineM
    {
        private static var _instance:OnLineM;
        private static var _awardId:int; //可以领取的奖励id
        private static var _leftTime:Number; //可领取的剩余时间
        private var _index:Number = 1;  //获取奖励的id
        private var _isAni:Boolean = false;

        public function OnLineM()
        {
            _awardId = -1;
            _leftTime = 0;
        }

        public static function get instance():OnLineM
        {
            return _instance || (_instance = new OnLineM());
        }

        public function get isAni():Boolean
        {
            return _isAni;
        }

        public function set isAni(ani:Boolean):void
        {
            _isAni = ani;
        }

        public function getAwardStatus(awardId:int):int
        {

            if (_awardId < 0)
            {
                return GameConst.online_award_status_getted;
            }
            if (awardId < _awardId)
            {
                return GameConst.online_award_status_getted;
            }
            else if (awardId > _awardId)
            {
                return GameConst.online_award_status_not_start;
            }
            return GameConst.online_award_status_start;
        }


        public function getRewardStatus(awardId:int):int
        {
            return null;
        }

        public function get RewardIndex():Number
        {
            return _index;
        }

        public function set RewardIndex(index:Number):void
        {
            _index = index;
        }

        public function getLeftTime():Number
        {
            return _leftTime;
        }

        public function setLeftTime(leftTime:Number):void
        {
            _leftTime = leftTime;
        }

        public function setAwardId(id:int):void
        {
            _awardId = id;
        }

        public function timeTick(delta:Number):void
        {
            if (_leftTime > 0)
            {

                _leftTime -= delta;
                if (_leftTime <= 0)
                {
                    GameEventDispatch.instance.event(GameEvent.StartRefersh);
                    list;

                }
            }
        }

        public function get idArr():Array
        {
            var arr:Array = new Array();
            var items = ConfigManager.getConfBySheet("cfg_onLine");

            for (var i in items)
            {
                arr.push(parseInt(i))
            }
            return arr
        }

        public function get list():Array
        {

            var listArr:Array = [];
            var can_acc = false;
            for (var i:int = 0; i < idArr.length; i++)
            {
                var online:cfg_onLine = cfg_onLine.instance(idArr[i]);
                if (getAwardStatus(idArr[i]) == GameConst.online_award_status_getted)
                {

                    listArr.push({
                        icon: {skin: imageUrl(online.rewardID)},
                        coinLabel: {text: online.rewardCount},
                        reaminTime: {text: online.receiveTime},
                        receiveBtn: {gray: true, mouseEnabled: false},
                        receivelabel: {text: "已领取", gray: true}
                    });

                } else if (getAwardStatus(idArr[i]) == GameConst.online_award_status_not_start)
                {
                    listArr.push({
                        icon: {skin: imageUrl(online.rewardID)},
                        coinLabel: {text: online.rewardCount},
                        reaminTime: {text: online.receiveTime},
                        receiveBtn: {gray: true, mouseEnabled: false},
                        receivelabel: {text: "领取", gray: true}
                    });

                } else if (getAwardStatus(idArr[i]) == GameConst.online_award_status_start && getLeftTime() <= 0)
                {

                    can_acc = true;
                    listArr.push({
                        icon: {skin: imageUrl(online.rewardID)},
                        coinLabel: {text: online.rewardCount},
                        reaminTime: {text: online.receiveTime},
                        receiveBtn: {gray: false, mouseEnabled: true},
                        receivelabel: {text: "领取", gray: false}
                    });
                } else
                {

                    listArr.push({
                        icon: {skin: imageUrl(online.rewardID)},
                        coinLabel: {text: online.rewardCount},
                        reaminTime: {text: online.receiveTime},
                        receiveBtn: {gray: true, mouseEnabled: false},
                        receivelabel: {text: "领取", gray: true}
                    });

                }
            }
            return listArr;
        }


        //领取奖励
        public function get onLineList():Array
        {
            var onlineList:Array = [];
            var can_acc = false;
            for (var i:int = 0; i < idArr.length; i++)
            {
                var online:cfg_onLine = cfg_onLine.instance(idArr[i]);
                if (getAwardStatus(idArr[i]) == GameConst.online_award_status_getted)
                {
                    onlineList.push({count: online.rewardCount, name: "未领取", rewardUrl: "ui/common/lqjl_1.png"});
                } else if (getAwardStatus(idArr[i]) == GameConst.online_award_status_not_start)
                {
                    onlineList.push({count: online.rewardCount, name: "未领取", rewardUrl: "ui/common/lqjl_1.png"});
                } else if (getAwardStatus(idArr[i]) == GameConst.online_award_status_start && getLeftTime() <= 0)
                {
                    onlineList.push({count: online.rewardCount, name: "可以领取", rewardUrl: "ui/common/lqjl_2.png"});
                } else
                {
                    onlineList.push({count: online.rewardCount, name: "未领取", rewardUrl: "ui/common/lqjl_1.png"});
                }
            }
            return onlineList;
        }

        public function getAwardState(id:Number):Object
        {
            var _onlineList:Array = [];
            var can_acc = false;
            for (var i:int = 0; i < idArr.length; i++)
            {
                var online:cfg_onLine = cfg_onLine.instance(idArr[i]);
                if (getAwardStatus(idArr[i]) == GameConst.online_award_status_getted)
                {
                    _onlineList.push({
                        count: online.rewardCount,
                        name: "未领取",
                        rewardUrl: "ui/fish/lqjl_1.png",
                        enable: false,
                        isVisible: true,
                        isTimeVisible: true
                    });
                } else if (getAwardStatus(idArr[i]) == GameConst.online_award_status_not_start)
                {
                    _onlineList.push({
                        count: online.rewardCount,
                        name: "未领取",
                        rewardUrl: "ui/fish/lqjl_1.png",
                        enable: false,
                        isVisible: true,
                        isTimeVisible: true
                    });
                } else if (getAwardStatus(idArr[i]) == GameConst.online_award_status_start && getLeftTime() <= 0)
                {
                    _onlineList.push({
                        count: online.rewardCount,
                        name: "可以领取",
                        rewardUrl: "ui/fish/lqjl_1.png",
                        enable: true,
                        isVisible: true,
                        isTimeVisible: false
                    });
                } else
                {
                    _onlineList.push({
                        count: online.rewardCount,
                        name: "未领取",
                        rewardUrl: "ui/fish/lqjl_1.png",
                        enable: false,
                        isVisible: true,
                        isTimeVisible: true
                    });
                }
            }
            if (id >= _onlineList.length || id < 0)
            {
                var obj:Object = {
                    count: "",
                    name: "未领取",
                    rewardUrl: "ui/fish/lqjl_3.png",
                    enable: false,
                    isVisible: false,
                    isTimeVisible: true
                }
                return obj;
            } else
            {
                return _onlineList[id];
            }
        }

        public function get isComplete():Boolean
        {
            if (getAwardStatus(idArr[idArr.length - 1]) == GameConst.online_award_status_getted)
            {
                return true
            } else
            {
                return false;
            }
        }

        //得到图片地址
        public function imageUrl(goodsId:int):String
        {
            var goods:cfg_goods = cfg_goods.instance(goodsId + "");
            return goods.icon;
        }

        public function vipTime(id:String):String
        {
            var cfg:cfg_onLine = cfg_onLine.instance(id + "");
            return cfg.vipTimes;
        }


    }
}
