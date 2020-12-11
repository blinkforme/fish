package control
{
    import model.MsgM;

    import manager.ConfigManager;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.UiManager;

    public class MsgC
    {
        private static var _instance:MsgC;

        public function MsgC()
        {
            GameEventDispatch.instance.on(GameEvent.MsgTip, this, MsgTip);
            GameEventDispatch.instance.on(GameEvent.MsgTipContent, this, MsgTipContent);
        }

        private function MsgTipContent(data:*):void
        {
            if (MsgM.instance.content == null)
            {
                UiManager.instance.loadView("GoldTip");
            } else
            {

            }
            if (data["time"])
            {
                MsgM.instance.setContentInfo(data["str"], data["time"]);
            }
            else
            {
                MsgM.instance.setContentInfo(data);
            }
        }

        private function MsgTip(data:*):void
        {
            if (MsgM.instance.content == null)
            {
                UiManager.instance.loadView("GoldTip");
            } else
            {

            }
            MsgM.instance.setContentInfo(ConfigManager.getConfValue("cfg_tip", data, "txtContent") as String);

        }

        public static function get instance():MsgC
        {
            return _instance || (_instance = new MsgC());
        }

    }
}
