package model
{
    import conf.cfg_goods;

    import laya.maths.Point;

    public class UpgradeM
    {
        private static var _instance:UpgradeM;
        private var _idLen:int;
        private var _urlArray:Array;
        private var _idArr:Array;
        private var _levelCount:Number;
        private var _countArr:Array;

        public function UpgradeM()
        {

        }

        public static function get instance():UpgradeM
        {
            return _instance || (_instance = new UpgradeM());
        }

        public function setInfo(url:Array, count:Array):void
        {
            _idArr = url;
            _countArr = count;
            _idLen = _idArr.length;
        }

        public function get countArr():Array
        {
            return _countArr;
        }

        public function get levelCount():Number
        {
            return _levelCount;
        }

        public function get pointList():Array
        {
            if (_idLen == 1)
            {
                return [new Point(640, 500)];
            } else if (_idLen == 2)
            {
                return [new Point(570, 500), new Point(710, 500)]
            } else if (_idLen == 3)
            {
                return [new Point(500, 500), new Point(640, 500), new Point(780, 500)]
            } else if (_idLen == 4)
            {
                return [new Point(430, 500), new Point(570, 500), new Point(710, 500), new Point(850, 500)];
            } else if (_idLen == 5)
            {
                return [new Point(360, 500), new Point(500, 500), new Point(640, 500), new Point(780, 500), new Point(920, 500)];
            } else if (_idLen == 6)
            {
                return [new Point(290, 500), new Point(430, 500), new Point(570, 500), new Point(710, 500), new Point(850, 500), new Point(990, 500)];
            } else if (_idLen == 7)
            {
                return [new Point(), new Point(), new Point(), new Point(), new Point(), new Point(), new Point()];
            } else if (_idLen == 8)
            {

            }
            return null;
        }

        public function get ImageArr():Array
        {
            _urlArray = new Array();
            for (var i:int = 0; i < _idArr.length; i++)
            {
                var goods:cfg_goods = cfg_goods.instance(_idArr[i]);
                _urlArray.push(goods.icon);

            }
            return _urlArray;
        }
    }
}
