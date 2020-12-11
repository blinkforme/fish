
package conf
{
    import manager.ConfigManager
	public class cfg_first_charge
	{
        public static function init(sheet:Object):cfg_first_charge
        {
            var a:cfg_first_charge = new cfg_first_charge();

            
            a.id=sheet[0];
            a.level=sheet[1];
            a.reward_item_ids=sheet[2];
            a.reward_item_nums=sheet[3];
            a.reward_skin_id=sheet[4];

            return a;
        }

        public static function instance(key:Object):cfg_first_charge
		{
            return ConfigManager.getConfObject("cfg_first_charge",key) as cfg_first_charge;
		}


        
        public var id:int;
        public var level:int;
        public var reward_item_ids:Array;
        public var reward_item_nums:Array;
        public var reward_skin_id:int;


	}
}