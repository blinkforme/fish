
package conf
{
    import manager.ConfigManager
	public class cfg_content
	{
        public static function init(sheet:Object):cfg_content
        {
            var a:cfg_content = new cfg_content();

            
            a.id=sheet[0];
            a.mainContent=sheet[1];
            a.timeContent=sheet[2];
            a.topContent=sheet[3];
            a.state=sheet[4];

            return a;
        }

        public static function instance(key:Object):cfg_content
		{
            return ConfigManager.getConfObject("cfg_content",key) as cfg_content;
		}


        
        public var id:int;
        public var mainContent:String;
        public var timeContent:int;
        public var topContent:String;
        public var state:int;


	}
}