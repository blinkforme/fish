
package conf
{
    import manager.ConfigManager
	public class cfg_task_vitality
	{
        public static function init(sheet:Object):cfg_task_vitality
        {
            var a:cfg_task_vitality = new cfg_task_vitality();

            
            a.id=sheet[0];
            a.need_vitality=sheet[1];
            a.reward_item_ids=sheet[2];
            a.reward_item_nums=sheet[3];

            return a;
        }

        public static function instance(key:Object):cfg_task_vitality
		{
            return ConfigManager.getConfObject("cfg_task_vitality",key) as cfg_task_vitality;
		}


        
        public var id:int;
        public var need_vitality:int;
        public var reward_item_ids:Array;
        public var reward_item_nums:Array;


	}
}