
package conf
{
    import manager.ConfigManager
	public class cfg_rech_award
	{
        public static function init(sheet:Object):cfg_rech_award
        {
            var a:cfg_rech_award = new cfg_rech_award();

            
            a.id=sheet[0];
            a.title=sheet[1];
            a.rechSum=sheet[2];
            a.reward_ids=sheet[3];
            a.reward_nums=sheet[4];
            a.remark=sheet[5];

            return a;
        }

        public static function instance(key:Object):cfg_rech_award
		{
            return ConfigManager.getConfObject("cfg_rech_award",key) as cfg_rech_award;
		}


        
        public var id:int;
        public var title:String;
        public var rechSum:int;
        public var reward_ids:Array;
        public var reward_nums:Array;
        public var remark:String;


	}
}