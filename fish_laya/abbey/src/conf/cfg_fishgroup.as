
package conf
{
    import manager.ConfigManager
	public class cfg_fishgroup
	{
        public static function init(sheet:Object):cfg_fishgroup
        {
            var a:cfg_fishgroup = new cfg_fishgroup();

            
            a.id=sheet[0];
            a.tmin=sheet[1];
            a.tmax=sheet[2];
            a.cmin=sheet[3];
            a.cmax=sheet[4];
            a.args=sheet[5];
            a.delay=sheet[6];

            return a;
        }

        public static function instance(key:Object):cfg_fishgroup
		{
            return ConfigManager.getConfObject("cfg_fishgroup",key) as cfg_fishgroup;
		}


        
        public var id:int;
        public var tmin:int;
        public var tmax:int;
        public var cmin:int;
        public var cmax:int;
        public var args:Number;
        public var delay:Number;


	}
}