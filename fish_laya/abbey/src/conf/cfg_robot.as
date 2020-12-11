
package conf
{
    import manager.ConfigManager
	public class cfg_robot
	{
        public static function init(sheet:Object):cfg_robot
        {
            var a:cfg_robot = new cfg_robot();

            
            a.id=sheet[0];

            return a;
        }

        public static function instance(key:Object):cfg_robot
		{
            return ConfigManager.getConfObject("cfg_robot",key) as cfg_robot;
		}


        
        public var id:int;


	}
}