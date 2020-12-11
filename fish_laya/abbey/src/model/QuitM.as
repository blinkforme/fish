package model
{
    import manager.ConfigManager;

    import struct.QuitTipInfo;

    public class QuitM
    {
        private static var _instance:QuitM;
        private var _mainContent:String;
        private var _timeContent:int;
        private var _contentObject:Object;
        private var _topContent:String;

        private var _name:int;
        ;

        private var _id:int;
        ;

        private var _state:int

        private var _tipInfo:QuitTipInfo;

        public function QuitM()
        {

        }

        public static function get instance():QuitM
        {
            return _instance || (_instance = new QuitM());
        }

        public function setTipInfo(info:QuitTipInfo):void
        {
            _tipInfo = info;
        }

        public function getTipInfo():QuitTipInfo
        {
            return _tipInfo;
        }

        public function setContent(id:int):void
        {
            _id = id;
            _contentObject = ConfigManager.getConfObject("cfg_content", String(id));
            _mainContent = _contentObject.mainContent;
            _timeContent = _contentObject.timeContent;
            _topContent = _contentObject.topContent;
            _state = _contentObject.state;
        }

        public function get mainContent():String
        {
            return _mainContent;
        }

        public function get topContent():String
        {
            return _topContent;
        }

        public function get timeContent():int
        {
            return _timeContent;
        }


        public function get name():int
        {
            return _name;
        }

        public function get id():int
        {
            return _id;

        }

        public function get state():int
        {
            return _state;
        }


    }
}
