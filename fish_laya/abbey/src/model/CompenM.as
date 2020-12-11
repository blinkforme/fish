package model
{
    import conf.cfg_goods;

    import laya.maths.Point;

    import proto.ComPro;
    import proto.MakePro;

    public class CompenM
    {
        private static var _instance:CompenM;
        private var _rewardName:String = "我开始中奖了啊";  //补偿奖励的名字
        private var _compenArr:Array;  //补偿奖励的ID数组
        private var _currentTimes:Number = 1; //当前显示奖励的次数
        private var _rewardFrom:Number = -1; //当前显示奖励的次数
        private var _comenList:Array;
        private var _totalTimes:Number; //总共需要展示的次数
        public function CompenM()
        {

        }

        public static function get instance():CompenM
        {
            return _instance || (_instance = new CompenM());
        }

        //补偿奖励的名字
        public function get rewardName():String
        {
            var compro:ComPro = compenArr[0] as ComPro
            return compro.tip;
        }

        public function set rewardName(name:String):void
        {
            _rewardName = name;
        }

        //当前领取的奖励的次数
        public function get currentTimes():Number
        {
            return _currentTimes;
        }

        public function set currentTimes(times:Number)
        {
            _currentTimes = times;
        }

        public function get compenArr():Array
        {
            return _compenArr;
        }

        public function set compenArr(arr:Array):void
        {
            _compenArr = arr;
        }

        public function get compenList():Array
        {
            var comList:Array = [];
            for (var i:int = 0; i < compenArr.length; i++)
            {
                var compro:ComPro = compenArr[i] as ComPro;
                var pro:MakePro = new MakePro();
                pro.count = ActivityM.instance.exchangeConversion(compro.id,compro.num);
                pro.icon = getUrl(compro.id + "");
                comList.push(pro);
            }
            return comList;
        }


        //需要领取的总共的次数
        public function get totalTimes():Number
        {
            if (compenList != null)
            {
                var len:Number = compenList.length;
                return Math.ceil(len / 4);
            } else
            {
                return 0;
            }
        }

        //刷新数据列表
        public function get refreshList():Array
        {
            var startIndex:Number = (currentTimes - 1) * 4;
            var endIndex:Number = startIndex + addIndex;
            return compenList.slice(startIndex, endIndex);
        }

        public function get showRefeshList():Array
        {
            var showlist:Array = [];
            for (var i:int = 0; i < refreshList.length; i++)
            {
                var pro:MakePro = refreshList[i];
                showlist.push({icon: {skin: pro.icon}, count: {text: pro.count}});
            }
            return showlist;
        }

        //得到icon的地址
        public function getUrl(id:String):String
        {
            var cfg:cfg_goods = cfg_goods.instance(id);
            return cfg.icon;
        }


        public function point(id:int):Point
        {
            if (id == 1)
            {
                return new Point(371, 302);
            } else if (id == 2)
            {
                return new Point(291, 302);
            } else if (id == 3)
            {
                return new Point(209, 302);
            } else if (id == 4)
            {
                return new Point(127, 302);
            } else
            {
                return null;
            }

        }

        public function get addIndex():Number
        {
            var index:Number = 0;
            if (currentTimes == totalTimes)
            {
                index = compenList.length - (currentTimes - 1) * 4;
            } else
            {
                index = 4;
            }
            return index;
        }

        public function get rewardFrom():Number
        {
            return _rewardFrom;
        }

        public function set rewardFrom(value:Number):void
        {
            _rewardFrom = value;
        }
    }
}
