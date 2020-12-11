package control
{
    import manager.GameConst;
    import manager.GameTools;

    import model.LevelM;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.UiManager;

    import model.LoginInfoM;
    import model.RoleInfoM;

    import struct.QuitTipInfo;

    public class LevelC
    {
        private static var _instance:LevelC;

        public static function get instance():LevelC
        {
            return _instance || (_instance = new LevelC());
        }

        public function LevelC()
        {
            GameEventDispatch.instance.on(String(42000), this, isHaveRankReward);
            GameEventDispatch.instance.on(String(42002), this, onGetReward);
            GameEventDispatch.instance.on(String(42005), this, fishGoldBoxIsShow);
            GameEventDispatch.instance.on(GameEvent.LevelC, this, LevelTip);
            GameEventDispatch.instance.on(GameEvent.OpenSubscibe, this, onOpenSubscibe);
        }

        private function onOpenSubscibe():void
        {
            WxC.subscribeInfo([1]);
        }

        private function fishGoldBoxIsShow(res:*):void
        {
            if (res)
            {
                LoginInfoM.instance.isShowRankAniBox = res.show;
                GameEventDispatch.instance.event(GameEvent.RankAniRefesh)
            }
        }

        private function onGetReward(res:*):void
        {
            if (res.code == 0)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "领取成功");
                if (WxC.isInMiniGame() && RoleInfoM.instance.subsState(1) == false)
                {
                    if (RoleInfoM.instance.subscribeState(1) == 0)
                    {
                        var info:QuitTipInfo = new QuitTipInfo();
                        info.state = GameConst.quit_state_mid_confirm_subscibe;
                        info.content = ""
                        info.middleTxt = "订阅"
                        info.commonMsg = GameEvent.OpenSubscibe;
                        info.isHaveTime = false;
                        GameEventDispatch.instance.event(GameEvent.QuitTip, info);
                    } else
                    {
                        GameEventDispatch.instance.event(GameEvent.OpenSubscibe);
                    }
                }

            } else if (res.code == 1)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "领取成功");
            } else
            {
                GameTools.dealCode(res.code);
            }
        }

        private function isHaveRankReward(res:*):void
        {
            if (res)
            {
                LevelM.instance.isCanReward = res.can_reward;
                if (res.data['1'])
                {
                    LevelM.instance.coinRankLv = res.data['1'].ranking;
                    if (Array.isArray(res.data['1'].reward))
                    {
                        LevelM.instance.coinReward = res.data['1'].reward;
                    } else
                    {
                        LevelM.instance.coinReward = [];
                    }

                } else
                {
                    LevelM.instance.coinRankLv = -1;
                }
                if (res.data['2'])
                {
                    LevelM.instance.strengthRankLv = res.data['2'].ranking;
                    if (Array.isArray(res.data['2'].reward))
                    {
                        LevelM.instance.strengthReward = res.data['2'].reward;
                    } else
                    {
                        LevelM.instance.strengthReward = [];
                    }
                } else
                {
                    LevelM.instance.strengthRankLv = -1;
                }
                GameEventDispatch.instance.event(GameEvent.SynRankReward);
            }

        }

        private function LevelTip(data:*):void
        {
            LevelM.instance.setInfo(data);
            !ENV.isShowDied() && UiManager.instance.loadView("Level");
        }

    }
}
