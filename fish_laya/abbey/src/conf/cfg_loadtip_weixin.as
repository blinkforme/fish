
package conf
{
    import manager.ConfigManager
	public class cfg_loadtip_weixin
	{
        public static function init(sheet:Object):cfg_loadtip_weixin
        {
            var a:cfg_loadtip_weixin = new cfg_loadtip_weixin();

            
            a.id=sheet[0];
            a.txtContent=sheet[1];

            return a;
        }

        public static function instance(key:Object):cfg_loadtip_weixin
		{
            return ConfigManager.getConfObject("cfg_loadtip_weixin",key) as cfg_loadtip_weixin;
		}


        
        public var id:int;
        public var txtContent:String;


	}
}