
package conf
{
    import manager.ConfigManager
	public class cfg_upgradeRed
	{
        public static function init(sheet:Object):cfg_upgradeRed
        {
            var a:cfg_upgradeRed = new cfg_upgradeRed();

            
            a.id=sheet[0];
            a.title=sheet[1];
            a.level=sheet[2];
            a.reward_ids=sheet[3];
            a.reward_nums=sheet[4];
            a.remark=sheet[5];

            return a;
        }

        public static function instance(key:Object):cfg_upgradeRed
		{
            return ConfigManager.getConfObject("cfg_upgradeRed",key) as cfg_upgradeRed;
		}


        
        public var id:int;
        public var title:String;
        public var level:int;
        public var reward_ids:Array;
        public var reward_nums:Array;
        public var remark:String;


	}
}