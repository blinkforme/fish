package model
{
    import engine.tool.StartParam;

    public class LoginInfoM
    {
        public var code:Number;
        public var name:String;
        public var uid:Number;
        public var privacyArr:Array = new Array();
        public var gameArr:Array = new Array();


        private var _shopRate:Number;

        public var mainPageShow:Boolean = false;//主界面是否加载过

        private var _openBankBatteryLevel:Number = 0;
        private var _openCertification:Number = 0; //强制实名认证开关
        private var _isShowRankAniBox:Number = 0;
        private var _ageType:Number = 1;

        private var _nameFilter:Array = []

        //游戏状态位操作:1:主界面使用骨骼 2:炮使用骨骼 4:鱼场使用俯视视角,8:显示banner
        private static var _instance:LoginInfoM;

        public function LoginInfoM()
        {
            _shopRate = 1;
        }


        public function set nameFilter(value:Array):void
        {
            _nameFilter = value;
        }

        public function filterName(name:String):String
        {
            var tmp:String = name;
            for (var i = 0; i < _nameFilter.length; i++)
            {
                var nameFilterElement = _nameFilter[i];
                tmp = tmp.replace(new RegExp(nameFilterElement, "gm"), "*")
            }
            return tmp
        }

        public static function get instance():LoginInfoM
        {
            return _instance || (_instance = new LoginInfoM());
        }

        public function fromApp():Boolean
        {
            return StartParam.instance.getParam("platform") == "app";
        }

        public function from360App():Boolean
        {
            return StartParam.instance.getParam("platform") == "360";
        }

        public function fromMeizu():Boolean
        {
            return StartParam.instance.getParam("platform") == "meizu";
        }

        public function fromHuawei():Boolean
        {
            return StartParam.instance.getParam("platform") == "huawei";
        }

        public function fromQuick():Boolean
        {
            return StartParam.instance.getParam("platform") == "quick";
        }

        public function fromAndroid():Boolean
        {
            return fromApp() || from360App() || fromMeizu() || fromHuawei() || fromQuick()
        }

        public function setShopRate(rate:Number):void
        {
            _shopRate = rate;
        }

        public function getShopRate():Number
        {
            return _shopRate;
        }


        public function get openBankBatteryLevel():Number
        {
            return _openBankBatteryLevel;
        }

        public function set openBankBatteryLevel(value:Number):void
        {
            _openBankBatteryLevel = value;
        }

        public function set openCertification(value:Number):void
        {
            _openCertification = value;
        }

        public function get openCertification():Number
        {
            return _openCertification
        }

        public function get ageType():Number
        {
            return _ageType;
        }

        public function set ageType(value:Number):void
        {
            _ageType = value
        }

        public function get isShowRankAniBox():Number
        {
            return _isShowRankAniBox;
        }

        public function set isShowRankAniBox(value:Number):void
        {
            _isShowRankAniBox = value;
        }
    }
}
