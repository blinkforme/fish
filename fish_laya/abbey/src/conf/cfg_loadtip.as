
package conf
{
    import manager.ConfigManager
	public class cfg_loadtip
	{
        public static function init(sheet:Object):cfg_loadtip
        {
            var a:cfg_loadtip = new cfg_loadtip();

            
            a.id=sheet[0];
            a.txtContent=sheet[1];

            return a;
        }

        public static function instance(key:Object):cfg_loadtip
		{
            return ConfigManager.getConfObject("cfg_loadtip",key) as cfg_loadtip;
		}


        
        public var id:int;
        public var txtContent:String;


	}
}