
package conf
{
    import manager.ConfigManager
	public class cfg_task_red_reward
	{
        public static function init(sheet:Object):cfg_task_red_reward
        {
            var a:cfg_task_red_reward = new cfg_task_red_reward();

            
            a.id=sheet[0];
            a.taskNum=sheet[1];
            a.reward_money_1=sheet[2];
            a.reward_money_2=sheet[3];
            a.reward_money_3=sheet[4];
            a.reward_ratio_1=sheet[5];
            a.reward_ratio_2=sheet[6];
            a.reward_ratio_3=sheet[7];

            return a;
        }

        public static function instance(key:Object):cfg_task_red_reward
		{
            return ConfigManager.getConfObject("cfg_task_red_reward",key) as cfg_task_red_reward;
		}


        
        public var id:int;
        public var taskNum:int;
        public var reward_money_1:Number;
        public var reward_money_2:Number;
        public var reward_money_3:Number;
        public var reward_ratio_1:Number;
        public var reward_ratio_2:Number;
        public var reward_ratio_3:Number;


	}
}