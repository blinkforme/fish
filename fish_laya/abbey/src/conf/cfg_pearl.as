
package conf
{
    import manager.ConfigManager
	public class cfg_pearl
	{
        public static function init(sheet:Object):cfg_pearl
        {
            var a:cfg_pearl = new cfg_pearl();

            
            a.id=sheet[0];

            return a;
        }

        public static function instance(key:Object):cfg_pearl
		{
            return ConfigManager.getConfObject("cfg_pearl",key) as cfg_pearl;
		}


        
        public var id:int;


	}
}