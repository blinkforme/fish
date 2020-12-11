
package conf
{
    import manager.ConfigManager
	public class cfg_register
	{
        public static function init(sheet:Object):cfg_register
        {
            var a:cfg_register = new cfg_register();

            
            a.id=sheet[0];
            a.weekName=sheet[1];
            a.rewardID=sheet[2];
            a.rewardCount=sheet[3];
            a.replace_reward_id=sheet[4];
            a.replace_reward_count=sheet[5];
            a.db_vip=sheet[6];

            return a;
        }

        public static function instance(key:Object):cfg_register
		{
            return ConfigManager.getConfObject("cfg_register",key) as cfg_register;
		}


        
        public var id:int;
        public var weekName:String;
        public var rewardID:int;
        public var rewardCount:int;
        public var replace_reward_id:int;
        public var replace_reward_count:int;
        public var db_vip:int;


	}
}