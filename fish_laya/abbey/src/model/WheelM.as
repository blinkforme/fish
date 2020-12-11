package model
{

    public class WheelM
    {
        private var _frontIct:Array = [0, 0, 0];//前三个转盘是否可转
        private var _times:Array = [0, 0, 0, 0, 0];//各转盘已转次数
        private var _allTimes:Array = [12, 12, 5, 12, 12];//各转盘上限次数
        private var _wheelScore:Array = [0, 0, 0, 0, 0];//各转盘已转累计值
        private var _wheelToday:Array = [0, 0, 0];//前三个转盘当日累计值

        private var _costScore:Array = [0, 0, 0, 0, 0];//转盘当日消耗

        private var _playerScore:Number = 0;//玩家活动积分
        private var _wheelShopScore:int = 0;//玩家转盘商城积分

        private var _isExchange:Number=0;//积分是否对换成礼包码
        private var _cdkey:String="";//礼包码
        private var _midAutumnScore:Number;//兑换需要积分

        private static var _instance:WheelM;

        public function WheelM()
        {

        }

        public static function get instance():WheelM
        {
            return _instance || (_instance = new WheelM());
        }



        public function getIct():Array
        {
            return _frontIct;
        }

        public function setIct(_arr:Array):void
        {
            _frontIct = _arr;
        }

        public function getPlayerScore():Number
        {
            return _playerScore;
        }

        public function setPlayerScore(_num:Number):void
        {
            _playerScore = _num;
        }

        public function setShopScore(_num:int):void
        {
            _wheelShopScore = _num;
        }

        public function getShopScore():int
        {
            return _wheelShopScore;
        }


        public function getTimes():Array
        {
            return _times;
        }

        public function setTimes(_arr:Array):void
        {
            _times = _arr;
        }


        public function getAllTimes():Array
        {
            return _allTimes;
        }

        public function setAllTimes(_arr:Array):void
        {
            _allTimes = _arr;
        }


        public function getcostScore():Array
        {
            return _costScore;
        }

        public function setcostScore(_arr:Array):void
        {
            _costScore = _arr;
        }


        public function getwheelScore():Array
        {
            return _wheelScore;
        }

        public function setwheelScore(_arr:Array):void
        {
            _wheelScore = _arr;
        }


        public function getwheelToday():Array
        {
            return _wheelToday;
        }

        public function setwheelToday(_arr:Array):void
        {
            _wheelToday = _arr;
        }

        public function get isExchange():Number
        {
            return _isExchange;
        }

        public function set isExchange(num:Number):void
        {
            _isExchange = num;
        }

        public function get cdKey():String
        {
            return _cdkey;
        }

        public function set cdKey(str:String):void
        {
            _cdkey = str;
        }

        public function get midAutumnScore():Number
        {
            return _midAutumnScore;
        }

        public function set midAutumnScore(num:Number):void
        {
            _midAutumnScore = num;
        }

    }

}
