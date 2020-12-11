package model
{
    import conf.cfg_share;

    import manager.ConfigManager;

    import ui.abbey.rewpageUI;

    public class WxM
    {
        private static var _instance:WxM;
        private var _imgUrl:String = "ui/common/nan.png"
        private var _idArr:Array = null;
        private var _isShow:Boolean = true;
        public var _backScene:Number;

        public function WxM()
        {

        }


        public function get isShow():Boolean
        {
            return _isShow;
        }

        public function get isBackScene():Number
        {
            return _backScene;
        }

        public function set isShow(isshow:Boolean):void
        {
            _isShow = isshow;
        }

        public function get shareInfo():cfg_share
        {
            if (null == _idArr)
            {
                _idArr = new Array();
                var items = ConfigManager.getConfBySheet("cfg_share");
                for (var i in items)
                {
                    _idArr.push(parseInt(i))
                }
            }
            var id:Number = getIndex(_idArr.length);
            var cfg:cfg_share = cfg_share.instance(_idArr[id]);
            return cfg;
        }

        public function getIndex(len:Number):Number
        {
            var index:Number = Math.floor(Math.random() * len);
            return index;
        }

        public static function get instance():WxM
        {
            return _instance || (_instance = new WxM());
        }

        public function set imageUrl(imgUrl:String):void
        {
            _imgUrl = imgUrl;
        }

        public function get imageUrl():String
        {
            return _imgUrl;
        }
    }
}
