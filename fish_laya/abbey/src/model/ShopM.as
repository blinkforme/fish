package model
{

    public class ShopM
    {

        private var _goodsMidId:Object = {};

        private static var _instance:ShopM;
        public function ShopM()
        {

        }

        public static function get instance():ShopM
        {
            return _instance || (_instance = new ShopM());
        }

        public function getGoodsMidId(key:int)
        {
            return _goodsMidId[key]?_goodsMidId[key]:null;
        }

        public function setGoodsMidId(key:int,data):void
        {
            if (!_goodsMidId[key])
            {
                _goodsMidId[key] = data
            }
        }
    }
}
