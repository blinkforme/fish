
package conf
{
    import manager.ConfigManager
	public class cfg_wheel
	{
        public static function init(sheet:Object):cfg_wheel
        {
            var a:cfg_wheel = new cfg_wheel();

            
            a.id=sheet[0];
            a.txt_share_title=sheet[1];
            a.txt_share_content=sheet[2];
            a.txt_rule_title=sheet[3];
            a.txt_rule1=sheet[4];

            return a;
        }

        public static function instance(key:Object):cfg_wheel
		{
            return ConfigManager.getConfObject("cfg_wheel",key) as cfg_wheel;
		}


        
        public var id:int;
        public var txt_share_title:String;
        public var txt_share_content:String;
        public var txt_rule_title:String;
        public var txt_rule1:String;


	}
}