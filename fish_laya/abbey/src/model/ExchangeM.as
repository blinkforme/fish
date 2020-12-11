package model
{
    import control.WxC;

    import manager.GameConst;

    public class ExchangeM
    {
        private static var _instance:ExchangeM;

        //微信绑定
        private var _wxIsBind:Number; //是否已经绑定
        private var _wxBindTicket:String; //绑定码
        private var _wxExpiredTime:Number; //绑定码过期时间

        //支付宝绑定
        private var _alipayIsBind:Number; //是否已经绑定
        private var _alipayBindTicket:String; //绑定码
        private var _alipayExpiredTime:Number; //绑定码过期时间

        //微信渠道 支付宝和微信兑换开关
        private var _wx_wxExchangeOpen:Boolean = false
        private var _wx_alipayExchangeOpen:Boolean = false

        //h5渠道 支付宝和微信兑换开关
        private var _h5_wxExchangeOpen:Boolean = false
        private var _h5_alipayExchangeOpen:Boolean = false

        //渠道 1小游戏  2非小游戏
        public var _platform:Number = 2;


        //绑定支付偏好 0:没有 1微信 2支付宝
        private var _payType:Number = 0;

        private var _curSelect:Number = 0;

        public static function get instance():ExchangeM
        {
            return _instance || (_instance = new ExchangeM());
        }

        public function ExchangeM()
        {

        }

        public function get payType():Number
        {
            return _payType;
        }

        public function set payType(value:Number):void
        {
            _payType = value;
        }

        public function get wxIsBind():Number
        {
            return _wxIsBind;
        }

        public function set wxIsBind(value:Number):void
        {
            _wxIsBind = value;
        }

        public function get wxBindTicket():String
        {
            return _wxBindTicket;
        }

        public function set wxBindTicket(value:String):void
        {
            _wxBindTicket = value;
        }

        public function get wxExpiredTime():Number
        {
            return _wxExpiredTime;
        }

        public function set wxExpiredTime(value:Number):void
        {
            _wxExpiredTime = value;
        }

        public function get alipayIsBind():Number
        {
            return _alipayIsBind;
        }

        public function set alipayIsBind(value:Number):void
        {
            _alipayIsBind = value;
        }

        public function get alipayBindTicket():String
        {
            return _alipayBindTicket;
        }

        public function set alipayBindTicket(value:String):void
        {
            _alipayBindTicket = value;
        }

        public function get alipayExpiredTime():Number
        {
            return _alipayExpiredTime;
        }

        public function set alipayExpiredTime(value:Number):void
        {
            _alipayExpiredTime = value;
        }

        public function set wx_wxExchangeOpen(value:Boolean):void
        {
            _wx_wxExchangeOpen = value;
        }

        public function set wx_alipayExchangeOpen(value:Boolean):void
        {
            _wx_alipayExchangeOpen = value;
        }

        public function set h5_wxExchangeOpen(value:Boolean):void
        {
            _h5_wxExchangeOpen = value;
        }

        public function set h5_alipayExchangeOpen(value:Boolean):void
        {
            _h5_alipayExchangeOpen = value;
        }

        public function get curSelect():Number
        {
            return _curSelect;
        }

        public function set curSelect(value:Number):void
        {
            _curSelect = value;
        }
    }

}