
package conf
{
    import manager.ConfigManager
	public class cfg_tip
	{
        public static function init(sheet:Object):cfg_tip
        {
            var a:cfg_tip = new cfg_tip();

            
            a.id=sheet[0];
            a.txtContent=sheet[1];

            return a;
        }

        public static function instance(key:Object):cfg_tip
		{
            return ConfigManager.getConfObject("cfg_tip",key) as cfg_tip;
		}


        
        public var id:int;
        public var txtContent:String;


	}
}