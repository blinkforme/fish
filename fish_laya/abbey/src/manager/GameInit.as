package manager
{
    import control.ActivityC;
    import control.AdC;
    import control.BankC;
    import control.BatteryC;
    import control.CompenC;
    import control.FightC;
    import control.FishTypeC;
    import control.HeartbeatC;
    import control.HourseC;
    import control.LevelC;
    import control.LoginC;
    import control.LoginInfoC;
    import control.MatchC;
    import control.MsgC;
    import control.NoviceC;
    import control.OnLineC;
    import control.QuitC;
    import control.RTipC;
    import control.RedpointC;
    import control.RegiC;
    import control.RewardC;
    import control.RoleInfoC;
    import control.RuleC;
    import control.ShopC;
    import control.TaskC;
    import control.UpgradeC;
	import control.WheelC;
	import control.SubscriptionC;

    import model.AdM;

    import model.MatchM;
    import model.ShopM;
    import model.SubscriptionM;
    import model.ActivityM;
    import model.CompenM;
    import model.FishTypeM;
    import model.HorseM;
    import model.LevelM;
    import model.LoadTipM;
    import model.LoginInfoM;
    import model.LoginM;
    import model.MsgM;
    import model.OnLineM;
    import model.QuitM;
    import model.RTipM;
    import model.RewardM;
    import model.RoleInfoM;
    import model.RuleM;
    import model.SmallM;
    import model.UpgradeM;
	import model.WheelM;

    import control.FriendC;

    import model.FriendM;

    public class GameInit
    {
        private static var _instance:GameInit;

        public function GameInit()
        {

        }

        public static function get instance():GameInit
        {
            return _instance || (_instance = new GameInit());
        }

        public function ModelInit():void
        {
            FriendM.instance;
            RoleInfoM.instance;
            LoginInfoM.instance;
            MsgM.instance;
            QuitM.instance;
            FishTypeM.instance;
            RewardM.instance;
            LevelM.instance;
            RTipM.instance;
            HorseM.instance;
            OnLineM.instance;
            SmallM.instance;
            UpgradeM.instance;
            RuleM.instance;
            CompenM.instance;
            LoginM.instance;
            LoadTipM.instance;
            MatchM.instance;
            ActivityM.instance;
			SubscriptionM.instance;
            AdM.instance;
            ShopM.instance;
        }

        public function ControlInit():void
        {
            FriendC.instance;
            RoleInfoC.instance;
            LoginInfoC.instance;
            HeartbeatC.instance;
            FightC.instance;
            MsgC.instance;
            QuitC.instance;
            FishTypeC.instance;
            RewardC.instance;
            ShopC.instance;
            TaskC.instance;
            LevelC.instance
            RTipC.instance;
            HourseC.instance;;
            OnLineC.instance;
            RedpointC.instance;
            UpgradeC.instance;
            RuleC.instance;
            RegiC.instance;
            CompenC.instance;
            LoginC.instance;
            ActivityC.instance;
            BankC.instance;
            MatchC.instance;
            BatteryC.instance;
            NoviceC.instance;
			SubscriptionC.instance;
            AdC.instance;
            WheelC.instance;
        }

        public function init():void
        {
            ModelInit();
            ControlInit();
        }
    }
}
