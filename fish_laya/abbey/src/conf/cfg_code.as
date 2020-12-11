
package conf
{
    import manager.ConfigManager
	public class cfg_code
	{
        public static function init(sheet:Object):cfg_code
        {
            var a:cfg_code = new cfg_code();

            
            a.id=sheet[0];
            a.txtContent=sheet[1];

            return a;
        }

        public static function instance(key:Object):cfg_code
		{
            return ConfigManager.getConfObject("cfg_code",key) as cfg_code;
		}


        
        public var id:int;
        public var txtContent:String;


	}
}