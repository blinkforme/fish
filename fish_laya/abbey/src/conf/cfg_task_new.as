
package conf
{
    import manager.ConfigManager
	public class cfg_task_new
	{
        public static function init(sheet:Object):cfg_task_new
        {
            var a:cfg_task_new = new cfg_task_new();

            
            a.id=sheet[0];
            a.title=sheet[1];
            a.task_ids=sheet[2];
            a.reward_item_ids=sheet[3];
            a.reward_item_nums=sheet[4];

            return a;
        }

        public static function instance(key:Object):cfg_task_new
		{
            return ConfigManager.getConfObject("cfg_task_new",key) as cfg_task_new;
		}


        
        public var id:int;
        public var title:String;
        public var task_ids:Array;
        public var reward_item_ids:Array;
        public var reward_item_nums:Array;


	}
}