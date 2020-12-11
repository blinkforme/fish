
package conf
{
    import manager.ConfigManager
	public class cfg_share
	{
        public static function init(sheet:Object):cfg_share
        {
            var a:cfg_share = new cfg_share();

            
            a.id=sheet[0];
            a.txt=sheet[1];
            a.image=sheet[2];

            return a;
        }

        public static function instance(key:Object):cfg_share
		{
            return ConfigManager.getConfObject("cfg_share",key) as cfg_share;
		}


        
        public var id:int;
        public var txt:String;
        public var image:String;


	}
}