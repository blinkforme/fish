
package conf
{
    import manager.ConfigManager
	public class cfg_robotname
	{
        public static function init(sheet:Object):cfg_robotname
        {
            var a:cfg_robotname = new cfg_robotname();

            
            a.id=sheet[0];

            return a;
        }

        public static function instance(key:Object):cfg_robotname
		{
            return ConfigManager.getConfObject("cfg_robotname",key) as cfg_robotname;
		}


        
        public var id:int;


	}
}