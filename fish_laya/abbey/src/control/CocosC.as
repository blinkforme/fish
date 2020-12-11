package control
{
    import control.CocosC;

    import laya.utils.Handler;

    import manager.GameEvent;
    import manager.GameEventDispatch;

    public class CocosC
    {
        public function CocosC()
        {
        }


        public static var gameId:Number = 652541363
        public static var cocosGameSdk = __JS__("GameSDK")

        public static var loginParam = null


        public static function init():void
        {
            console.log("cocos init")
            cocosGameSdk.setOnInitCB(function (param)
            {
                console.log("cocoscb2")
                console.log(param["nickName"])
                CocosC.loginParam = param
                GameEventDispatch.instance.event(GameEvent.CocosNativeLoginComplete);
            });
            __JS__("GameSDK").init(gameId)
        }

        public static function pay(param):void
        {
            cocosGameSdk.pay(param["orderId"],param["goodsName"],param["goodsDesc"],param["orderAmount"],param["extension"],param["notifyURL"]);
        }
    }
}
