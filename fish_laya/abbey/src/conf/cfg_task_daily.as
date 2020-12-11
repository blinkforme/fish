
package conf
{
    import manager.ConfigManager
	public class cfg_task_daily
	{
        public static function init(sheet:Object):cfg_task_daily
        {
            var a:cfg_task_daily = new cfg_task_daily();

            
            a.id=sheet[0];

            return a;
        }

        public static function instance(key:Object):cfg_task_daily
		{
            return ConfigManager.getConfObject("cfg_task_daily",key) as cfg_task_daily;
		}


        
        public var id:int;


	}
}