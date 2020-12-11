package model
{
    import conf.cfg_goods;

    import laya.maths.Point;

    import manager.GameConst;

    public class RTipM
    {
        private static var _instance:RTipM;
        private var _imageUrl:String;
        private var _urlArray:Array;
        private var _idArr:Array;
        private var _idLen:int;
        private var _countArr:Array;
        private var _isShow:Boolean;

        public function RTipM()
        {
        }

        public static function get instance():RTipM
        {
            return _instance || (_instance = new RTipM());
        }

        public function setInfo(url:Array, count:Array, ishow:Boolean = false):void
        {
            _countArr = count;
            _idArr = url;
            if (_idArr != null)
            {
                _idLen = _idArr.length;
            }
            _isShow = ishow;
        }

        public function get imageUrl():String
        {
            return _imageUrl;
        }

        public function get pointList():Array
        {
            var fixedX:Number = 140;
            var fixedY:Number = 140;
            var arr:Array = [];
            if (_idLen <= 7)
            {
                for (var i:int = 0; i < _idLen; i++)
                {
                    var onePoint:Point = new Point((Laya.stage.width - fixedX * (_idLen - 1)) / 2 + fixedX * i, Laya.stage.height / 2);
                    arr.push(onePoint);
                }
            } else if (_idLen < 11 && _idLen >= 8)
            {
                for (var i:int = 0; i < _idLen; i++)
                {
                    var onePoint:Point
                    if ((i + 1) <= Math.floor(_idLen / 2))
                    {
                        onePoint = new Point((Laya.stage.width - fixedX * (Math.floor(_idLen / 2) - 1)) / 2 + fixedX * i, Laya.stage.height / 2 - fixedY / 2);
                    } else
                    {
                        onePoint = new Point((Laya.stage.width - fixedX * ((_idLen - Math.floor(_idLen / 2)) - 1)) / 2 + fixedX * (i - Math.floor(_idLen / 2)), Laya.stage.height / 2 + fixedY / 2);
                    }
                    arr.push(onePoint);
                }
            } else
            {
                return null;
            }
            return arr;
        }

        public function get isShow():Boolean
        {
            return _isShow;
        }

        public function get countArr():Array
        {
            return _countArr;
        }

        public function get ImageArr():Array
        {
            _urlArray = new Array();
            if (_idArr != null)
            {

                for (var i:int = 0; i < _idArr.length; i++)
                {
                    var goods:cfg_goods = cfg_goods.instance(_idArr[i]);
                    _urlArray.push(goods.icon);
                    if (_idArr[i] == GameConst.currency_exchange && _countArr[i])
                    {
                        _countArr[i] = ActivityM.instance.exchangeConversion(GameConst.currency_exchange, _countArr[i])
                    }
                }
            }
            return _urlArray;
        }

    }
}
