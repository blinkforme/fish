package model
{
    public class SettleM
    {
        private static var _instance:SettleM;
        private var _totalCount:Number = 0;
        private var _listArr:Array = new Array();
        private var _pmop:Number;

        public function SettleM()
        {

        }

        public static function get instance():SettleM
        {
            return _instance || (_instance = new SettleM());
        }

        public function setInfo():void
        {

        }

        public function set totalCount(totalCount:Number):void
        {
            _totalCount = totalCount;
        }

        public function clearData():void
        {
            _totalCount = 0;
            _listArr = [];
        }

        public function get totalCount():Number
        {
            return _totalCount;
        }

        public function addTotalCount(count:Number):void
        {
            _totalCount = _totalCount + count;
        }

        public function get listArr():Array
        {
            var list:Array = [];
            for (var i:int = _listArr.length - 1; i > -1; i--)
            {
                list.push(_listArr[i]);
            }
            return list;
        }

        public function listUtisl():void
        {
            var list:Array = [];
            for (var i:int = _listArr.length - 1; i > -1; i--)
            {
                list.push(_listArr[i]);
            }
        }

        public function get pump():Number
        {
            return _pmop
        }

        public function set pump(pmop:Number):void
        {
            _pmop = pmop;
        }


    }
}
