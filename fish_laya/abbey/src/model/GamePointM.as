package model
{
    import conf.cfg_gamepoints;

    import manager.ConfigManager;

    public class GamePointM
    {
        private static var _instance:GamePointM;

        public static function get instance():GamePointM
        {
            return _instance || (_instance = new GamePointM());
        }

        public function get listPoint():Array
        {
            var arr:Array = [];
            var k:int = 0;
            if (currentCoint < middlePoint)
            {
                for (var i:int = 0; i < 5; i++)
                {
                    arr.push(pointArr[i]);
                }
                return arr;
            } else
            {
                for (var j:int = 0; j < idArr.length; j++)
                {
                    if (currentCoint == getPoints(idArr[j]))
                    {
                        k = j;
                        break;
                    }

                    if (currentCoint < getPoints(idArr[j]))
                    {
                        k = j - 1;
                        break;
                    }
                }

                if (currentCoint > maxPoint)
                {
                    k = idArr.length - 1;
                }
                for (var m:int = k - 4; m <= k; m++)
                {
                    arr.push(pointArr[m]);
                }
                return arr;
            }
        }


        public function get grayList():Array
        {
            var arr:Array = [];
            for (var i:int = 0; i < listPoint.length; i++)
            {
                if (currentCoint >= listPoint[i])
                {
                    arr.push(false);
                } else
                {
                    arr.push(true);
                }
            }
            return arr;
        }


        public function get maxPoint():Number
        {
            var maxId:Number = idArr[idArr.length - 1];
            var cfg:cfg_gamepoints = cfg_gamepoints.instance(maxId + "");
            return cfg.point;
        }

        public function getPoints(id:Number):Number
        {

            var cfg:cfg_gamepoints = cfg_gamepoints.instance(id + "");
            return cfg.point;

        }

        public function get middlePoint():Number
        {
            var cfg:cfg_gamepoints = cfg_gamepoints.instance("6");
            return cfg.point;
        }


        public function get pointArr():Array
        {
            var arr:Array = [];
            for (var i:int = 0; i < idArr.length; i++)
            {
                var cfg:cfg_gamepoints = cfg_gamepoints.instance(idArr[i]);
                arr.push(cfg.point);
            }
            return arr;
        }


        public function get currentCoint():Number
        {
            return RoleInfoM.instance.getCoin();
        }


        public function get idArr():Array
        {
            var arr:Array = new Array();
            var items = ConfigManager.getConfBySheet("cfg_gamepoints");
            for (var i:int in items)
            {
                arr.push(i)
            }
            return arr
        }
    }

}
