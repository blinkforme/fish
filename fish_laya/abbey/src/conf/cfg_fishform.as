
package conf
{
    import manager.ConfigManager
	public class cfg_fishform
	{
        public static function init(sheet:Object):cfg_fishform
        {
            var a:cfg_fishform = new cfg_fishform();

            
            a.id=sheet[0];

            return a;
        }

        public static function instance(key:Object):cfg_fishform
		{
            return ConfigManager.getConfObject("cfg_fishform",key) as cfg_fishform;
		}


        
        public var id:int;


	}
}