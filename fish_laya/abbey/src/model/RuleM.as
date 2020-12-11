package model
{
    import conf.cfg_goods;

    import manager.GameEvent;
    import manager.GameEventDispatch;

    public class RuleM
    {
        private static var _instance:RuleM;
        private var _integral:Number;
        private var _url:String;
        private var _coinCount:Number
        private var _goodsId:int;
        private var _hour:Number;
        private var _minute:Number = 0;
        private var _second:Number = 0;
        private var _islist:Boolean = true;
        private var _totalTime:Number = 0;

        private var _activityID:Array
        private var _activityNum:Array

        public function RuleM()
        {
            _coinCount = 0
        }

        public static function get instance():RuleM
        {
            return _instance || (_instance = new RuleM());
        }

        public function set integral(integr:Number):void
        {
            _integral = integr;
        }


        public function get integral():Number
        {
            return _integral;
        }


        public function get isShowScene():Boolean
        {
            if (FightM.instance.sceneId == 4)
            {
                return true;
            } else
            {
                return false;
            }
        }

        public function isRewardShowScene():Boolean
        {
            if (FightM.instance.sceneId == 4 || FightM.instance.sceneId == 1)
            {
                return false;
            }
            return true;
        }

        //小时
        public function get hour():Number
        {
            return Math.floor(_hour);
        }

        //分
        public function get minute():Number
        {
            return Math.floor(_minute);
        }

        public function get showTime():String
        {
            var min:String = minute + ""
            var sec:String = second + "";
            var hou:String = hour + "";
            if (minute < 10)
            {
                min = "0" + minute;
            }
            if (second < 10)
            {
                sec = "0" + second;
            }
            if (hour < 10)
            {
                hou = "0" + hour;
            }
            var showtime:String = "倒计时: 00" + ":" + min + ":" + sec;
            return showtime;
        }


        public function get isList():Boolean
        {
            return _islist;
        }

        public function set isList(isl:Boolean):void
        {
            _islist = isl;
        }

        //秒
        public function get second():Number
        {
            return Math.floor(_second);
        }


        public function set second(se:Number):void
        {
            _second = se;
        }

        public function set minute(min:Number):void
        {
            _minute = min;
        }

        public function set hour(h:Number):void
        {
            _hour = h;
        }

        public function get goodsId():Number
        {
            return _goodsId;
        }

        public function set goodsId(id:Number):void
        {
            _goodsId = id;
        }

        public function get imageUrl():String
        {
            var cfg:cfg_goods = cfg_goods.instance(goodsId + "");
            return cfg.icon;
        }

        public function get coinCount():Number
        {
            return _coinCount;
        }

        public function set coinCount(coin:Number):void
        {
            _coinCount = coin;
        }

        public function get totalTime():Number
        {
            return Math.floor(_totalTime);
        }

        public function set totalTime(total:Number):void
        {
            _totalTime = total;
        }


        public function setTime(time:int):void
        {

            if (time != null)
            {
                var date:Date = new Date(time * 1000);
                //			var currentHour:Number = date.getHours();
                //			var currentMinute:Number = date.getMinutes();
                //			var currentSecond:Number = date.getSeconds();
                //			totalTime = (currentHour+1)*3600-(currentHour*3600+currentMinute*60+second)
                RuleM.instance.hour = date.getHours();

                RuleM.instance.minute = 59 - date.getMinutes();

                RuleM.instance.second = 59 - date.getSeconds();
                if (second < 0)
                {
                    second = 59;
                }
                GameEventDispatch.instance.event(GameEvent.UpdateTime);
            }
        }

        public function get activityID():Array
        {
            return _activityID;
        }

        public function set activityID(value:Array):void
        {
            _activityID = value;
        }

        public function get activityNum():Array
        {
            return _activityNum;
        }

        public function set activityNum(value:Array):void
        {
            _activityNum = value;
        }

    }
}
