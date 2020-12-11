
package conf
{
    import manager.ConfigManager
	public class cfg_rewardDetails
	{
        public static function init(sheet:Object):cfg_rewardDetails
        {
            var a:cfg_rewardDetails = new cfg_rewardDetails();

            
            a.id=sheet[0];
            a.rewardName=sheet[1];
            a.award=sheet[2];
            a.rewardUrl=sheet[3];
            a.weight=sheet[4];
            a.goodId=sheet[5];
            a.red_pack_activity_Name=sheet[6];
            a.red_pack_activity_award=sheet[7];
            a.red_pack_activity_rewardUrl=sheet[8];
            a.red_pack_activity_weight=sheet[9];
            a.red_pack_activity_goodId=sheet[10];
            a.com_fish_coin=sheet[11];
            a.condition=sheet[12];
            a.re_rewardName=sheet[13];
            a.re_award=sheet[14];
            a.re_rewardUrl=sheet[15];
            a.reward_type=sheet[16];

            return a;
        }

        public static function instance(key:Object):cfg_rewardDetails
		{
            return ConfigManager.getConfObject("cfg_rewardDetails",key) as cfg_rewardDetails;
		}


        
        public var id:int;
        public var rewardName:String;
        public var award:Array;
        public var rewardUrl:String;
        public var weight:int;
        public var goodId:int;
        public var red_pack_activity_Name:String;
        public var red_pack_activity_award:Array;
        public var red_pack_activity_rewardUrl:String;
        public var red_pack_activity_weight:int;
        public var red_pack_activity_goodId:int;
        public var com_fish_coin:int;
        public var condition:Array;
        public var re_rewardName:String;
        public var re_award:Array;
        public var re_rewardUrl:String;
        public var reward_type:String;


	}
}