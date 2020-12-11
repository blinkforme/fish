
package conf
{
    import manager.ConfigManager
	public class cfg_shareLottery_rule
	{
        public static function init(sheet:Object):cfg_shareLottery_rule
        {
            var a:cfg_shareLottery_rule = new cfg_shareLottery_rule();

            
            a.id=sheet[0];
            a.rewardId=sheet[1];
            a.lottry_goods=sheet[2];
            a.lottry_probability=sheet[3];
            a.lottry_description=sheet[4];
            a.lottry_id=sheet[5];

            return a;
        }

        public static function instance(key:Object):cfg_shareLottery_rule
		{
            return ConfigManager.getConfObject("cfg_shareLottery_rule",key) as cfg_shareLottery_rule;
		}


        
        public var id:int;
        public var rewardId:int;
        public var lottry_goods:String;
        public var lottry_probability:String;
        public var lottry_description:String;
        public var lottry_id:int;


	}
}