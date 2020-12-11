
package conf
{
    import manager.ConfigManager
	public class cfg_onLine
	{
        public static function init(sheet:Object):cfg_onLine
        {
            var a:cfg_onLine = new cfg_onLine();

            
            a.id=sheet[0];
            a.rewardID=sheet[1];
            a.receiveTime=sheet[2];
            a.rewardCount=sheet[3];
            a.vipRank=sheet[4];
            a.vipTimes=sheet[5];

            return a;
        }

        public static function instance(key:Object):cfg_onLine
		{
            return ConfigManager.getConfObject("cfg_onLine",key) as cfg_onLine;
		}


        
        public var id:int;
        public var rewardID:int;
        public var receiveTime:int;
        public var rewardCount:int;
        public var vipRank:int;
        public var vipTimes:String;


	}
}