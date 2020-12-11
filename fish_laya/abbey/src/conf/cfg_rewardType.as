
package conf
{
    import manager.ConfigManager
	public class cfg_rewardType
	{
        public static function init(sheet:Object):cfg_rewardType
        {
            var a:cfg_rewardType = new cfg_rewardType();

            
            a.id=sheet[0];
            a.firstId=sheet[1];
            a.secondId=sheet[2];
            a.threeId=sheet[3];
            a.fourId=sheet[4];
            a.fiveId=sheet[5];
            a.sixId=sheet[6];

            return a;
        }

        public static function instance(key:Object):cfg_rewardType
		{
            return ConfigManager.getConfObject("cfg_rewardType",key) as cfg_rewardType;
		}


        
        public var id:String;
        public var firstId:String;
        public var secondId:String;
        public var threeId:String;
        public var fourId:String;
        public var fiveId:String;
        public var sixId:String;


	}
}