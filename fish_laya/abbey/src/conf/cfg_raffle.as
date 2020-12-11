
package conf
{
    import manager.ConfigManager
	public class cfg_raffle
	{
        public static function init(sheet:Object):cfg_raffle
        {
            var a:cfg_raffle = new cfg_raffle();

            
            a.id=sheet[0];

            return a;
        }

        public static function instance(key:Object):cfg_raffle
		{
            return ConfigManager.getConfObject("cfg_raffle",key) as cfg_raffle;
		}


        
        public var id:int;


	}
}