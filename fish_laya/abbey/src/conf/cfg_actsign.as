
package conf
{
    import manager.ConfigManager
	public class cfg_actsign
	{
        public static function init(sheet:Object):cfg_actsign
        {
            var a:cfg_actsign = new cfg_actsign();

            
            a.id=sheet[0];
            a.title=sheet[1];
            a.reward_ids=sheet[2];
            a.reward_nums=sheet[3];
            a.remark=sheet[4];

            return a;
        }

        public static function instance(key:Object):cfg_actsign
		{
            return ConfigManager.getConfObject("cfg_actsign",key) as cfg_actsign;
		}


        
        public var id:int;
        public var title:String;
        public var reward_ids:Array;
        public var reward_nums:Array;
        public var remark:String;


	}
}