
package conf
{
    import manager.ConfigManager
	public class cfg_shieldWord
	{
        public static function init(sheet:Object):cfg_shieldWord
        {
            var a:cfg_shieldWord = new cfg_shieldWord();

            
            a.id=sheet[0];
            a.sensitiveword=sheet[1];

            return a;
        }

        public static function instance(key:Object):cfg_shieldWord
		{
            return ConfigManager.getConfObject("cfg_shieldWord",key) as cfg_shieldWord;
		}


        
        public var id:int;
        public var sensitiveword:String;


	}
}