
package conf
{
    import manager.ConfigManager
	public class cfg_level
	{
        public static function init(sheet:Object):cfg_level
        {
            var a:cfg_level = new cfg_level();

            
            a.id=sheet[0];
            a.name=sheet[1];
            a.exp=sheet[2];
            a.awardId=sheet[3];
            a.awardCount=sheet[4];

            return a;
        }

        public static function instance(key:Object):cfg_level
		{
            return ConfigManager.getConfObject("cfg_level",key) as cfg_level;
		}


        
        public var id:int;
        public var name:String;
        public var exp:int;
        public var awardId:Array;
        public var awardCount:Array;


	}
}