
package conf
{
    import manager.ConfigManager
	public class cfg_task
	{
        public static function init(sheet:Object):cfg_task
        {
            var a:cfg_task = new cfg_task();

            
            a.id=sheet[0];
            a.task_type=sheet[1];
            a.next_task=sheet[2];
            a.task_name=sheet[3];
            a.task_name_down=sheet[4];
            a.task_value_n=sheet[5];
            a.task_value_f=sheet[6];
            a.reward_item_ids=sheet[7];
            a.reward_item_nums=sheet[8];
            a.img_url=sheet[9];
            a.img_url_down=sheet[10];
            a.scene_id=sheet[11];
            a.activity_item_ids=sheet[12];
            a.activity_item_nums=sheet[13];
            a.worldcup_item_ids=sheet[14];
            a.worldcup_item_nums=sheet[15];

            return a;
        }

        public static function instance(key:Object):cfg_task
		{
            return ConfigManager.getConfObject("cfg_task",key) as cfg_task;
		}


        
        public var id:int;
        public var task_type:int;
        public var next_task:int;
        public var task_name:String;
        public var task_name_down:String;
        public var task_value_n:int;
        public var task_value_f:int;
        public var reward_item_ids:Array;
        public var reward_item_nums:Array;
        public var img_url:String;
        public var img_url_down:String;
        public var scene_id:int;
        public var activity_item_ids:Array;
        public var activity_item_nums:Array;
        public var worldcup_item_ids:Array;
        public var worldcup_item_nums:Array;


	}
}