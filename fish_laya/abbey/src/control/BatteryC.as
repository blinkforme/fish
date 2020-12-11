package control
{
    import manager.GameTools;

    import model.RoleInfoM;

    import manager.GameEvent;
    import manager.GameEventDispatch;

    public class BatteryC
    {
        private static var _instance:BatteryC;

        public function BatteryC()
        {
            GameEventDispatch.instance.on(String(13004), this, onFinishChangeSkin);
            GameEventDispatch.instance.on(String(13008), this, onDoubleChange);
            GameEventDispatch.instance.on(String(13010), this, onEndBuyDouble);
        }

        private function onEndBuyDouble(data):void
        {
            if (0 == data.code)
            {

            } else if (1 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "钻石不足");
            }
        }

        private function onDoubleChange(data):void
        {
            if (0 == data.code)
            {
                RoleInfoM.instance.coin_rate = data['coin_rate']
                RoleInfoM.instance.chance_rate = data['chance_rate']
                RoleInfoM.instance.coin_rate_buy = data['coin_rate_buy']
                RoleInfoM.instance.chance_rate_buy = data['chance_rate_buy']

                GameEventDispatch.instance.event(GameEvent.BatteryRateChagne);
            }else
            {
                GameTools.dealCode(data.code)
            }
        }

        private function onFinishChangeSkin(data:*)
        {
            RoleInfoM.instance.setCurSkin(data['cskin'])
            GameEventDispatch.instance.event(GameEvent.FinishChangeSkin, []);

        }

        public static function get instance():BatteryC
        {
            return _instance || (_instance = new BatteryC());
        }
    }
}
