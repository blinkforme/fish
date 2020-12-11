
package conf
{
    import manager.ConfigManager
	public class cfg_shareLottery
	{
        public static function init(sheet:Object):cfg_shareLottery
        {
            var a:cfg_shareLottery = new cfg_shareLottery();

            
            a.id=sheet[0];
            a.rewardId=sheet[1];
            a.rewardCount=sheet[2];
            a.weight=sheet[3];
            a.rewardId_Junior=sheet[4];
            a.rewardCount_Junior=sheet[5];
            a.rewardId_Medium=sheet[6];
            a.rewardCount_Medium=sheet[7];
            a.activity_rewardId=sheet[8];
            a.activity_rewardCount=sheet[9];
            a.activity_weight=sheet[10];
            a.probability_junior=sheet[11];
            a.description_junior=sheet[12];
            a.probability_medium=sheet[13];
            a.description_medium=sheet[14];

            return a;
        }

        public static function instance(key:Object):cfg_shareLottery
		{
            return ConfigManager.getConfObject("cfg_shareLottery",key) as cfg_shareLottery;
		}


        
        public var id:int;
        public var rewardId:int;
        public var rewardCount:int;
        public var weight:int;
        public var rewardId_Junior:int;
        public var rewardCount_Junior:int;
        public var rewardId_Medium:int;
        public var rewardCount_Medium:int;
        public var activity_rewardId:int;
        public var activity_rewardCount:int;
        public var activity_weight:int;
        public var probability_junior:String;
        public var description_junior:String;
        public var probability_medium:String;
        public var description_medium:String;


	}
}