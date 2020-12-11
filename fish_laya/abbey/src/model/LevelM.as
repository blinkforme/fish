package model
{
    import conf.cfg_level;
    import conf.cfg_scene;

    import manager.ConfigManager;
    import manager.GameConst;

    public class LevelM
    {
        private static var _instance:LevelM;
        private var keyArr:Array;
        private var sceneType:int;
        private var sceneArr:Array;

        //排行榜
        private var _isCanReward:Number = 0;
        private var _coinRankLv:Number = -1;
        private var _coinReward:Array;
        private var _strengthRankLv:Number = -1;
        private var _strengthReward:Array;

        private var _loopMsg:String = "";

        private var _todayStrIsHaveReward:Boolean = false;
        private var _todayCoinIsHaveReward:Boolean = false;
        private var _isPopupRankPage:Number = 0;

        public function LevelM()
        {
            if (!_coinReward)
            {
                _coinReward = new Array();
            }
            if (!_strengthReward)
            {
                _strengthReward = new Array();
            }
        }

        public function loopMsg():String
        {
            if (ActivityM.instance.getActivityData(GameConst.activity_rank))
            {
                var data:* = ActivityM.instance.getActivityData(GameConst.activity_rank)
                _loopMsg = data.config.timing_msg;
            } else
            {
                _loopMsg = "";
            }
            return _loopMsg;
        }

        public function get rankDoubleReward():Boolean
        {
            return ActivityM.instance.activityIsProceed(GameConst.activity_rank)
        }

        public static function get instance():LevelM
        {
            return _instance || (_instance = new LevelM());
        }

        public function setInfo(stype:int):void
        {
            sceneType = stype;
            keyArr = new Array();
            var items = ConfigManager.getConfBySheet("cfg_scene");
            for (var i in items)
            {
                keyArr.push(i)
            }

            sceneArr = new Array();
            sceneArr = ConfigManager.groupby("cfg_scene", "sceneType")[stype];

        }


        public function getUnloc(id:int):int
        {
            var levlem:cfg_scene = sceneArr[id];
            return levlem.unlock
        }


        public function getCountArr(level:*):Array
        {
            var cfg:cfg_level = cfg_level.instance(level);
            return cfg.awardCount;
        }

        public function getGoodsArr(level:*):Array
        {
            var cfg:cfg_level = cfg_level.instance(level)
            return cfg.awardId;
        }

        public function listArr():Array
        {
            var arr:Array = [];
            for (var j:int = 0; j < sceneArr.length; j++)
            {
                var levelem:cfg_scene = sceneArr[j];
                arr.push({levelImg: {skin: levelem.imageurl}});
            }
            return arr;
        }

        public function get isCanReward():Number
        {
            return _isCanReward;
        }

        public function set isCanReward(value:Number):void
        {
            _isCanReward = value;
        }

        public function get coinRankLv():Number
        {
            return _coinRankLv;
        }

        public function set coinRankLv(value:Number):void
        {
            _coinRankLv = value;
        }

        public function get coinReward():Array
        {
            return _coinReward;
        }

        public function set coinReward(value:Array):void
        {
            _coinReward = value;
        }

        public function get strengthRankLv():Number
        {
            return _strengthRankLv;
        }

        public function set strengthRankLv(value:Number):void
        {
            _strengthRankLv = value;
        }

        public function get strengthReward():Array
        {
            return _strengthReward;
        }

        public function set strengthReward(value:Array):void
        {
            _strengthReward = value;
        }

        public function get todayStrIsHaveReward():Boolean
        {
            return _todayStrIsHaveReward;
        }

        public function get todayCoinIsHaveReward():Boolean
        {
            return _todayCoinIsHaveReward;
        }

        public function setTodayStrIsHaveReward(result:Object):void
        {
            var strLv:Number = result.data["strength_top_me"];
            var strList:Array = result.data["strength_top"]
            var coinLv:Number = result.data["gold_top_me"];
            var coinList:Array = result.data["gold_top"]

            if (strList[(strLv - 1) + ""] && strList[(strLv - 1) + ""].reward.length > 0)
            {
                _todayStrIsHaveReward = true;
            } else
            {
                _todayStrIsHaveReward = false;
            }
            if (coinList[(coinLv - 1) + ""] && coinList[(coinLv - 1) + ""].reward.length > 0)
            {
                _todayCoinIsHaveReward = true;
            } else
            {
                _todayCoinIsHaveReward = false;
            }
        }

        public function get isPopupRankPage():Number
        {
            return _isPopupRankPage;
        }

        public function set isPopupRankPage(value:Number):void
        {
            _isPopupRankPage = value;
        }
    }
}
