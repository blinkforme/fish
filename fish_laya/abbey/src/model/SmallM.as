package model
{
    public class SmallM
    {
        private static var _instance:SmallM;
        private var _url:String = ""; //小游戏服务器连接
        private var _isReceiVe:Boolean = false;

        public function SmallM()
        {

        }

        public static function get instance():SmallM
        {
            return _instance || (_instance = new SmallM());
        }

        public function setUrl(url:String):void
        {
            _url = url
        }

        public function getUrl():String
        {
            return _url;
        }

        public function get isReceive():Boolean
        {
            return _isReceiVe;
        }

        public function set isReceive(isRe:Boolean):void
        {
            _isReceiVe = isRe;
        }
    }
}
