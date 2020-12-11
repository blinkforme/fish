
package conf
{
    import manager.ConfigManager
	public class cfg_fishgrouppath
	{
        public static function init(sheet:Object):cfg_fishgrouppath
        {
            var a:cfg_fishgrouppath = new cfg_fishgrouppath();

            
            a.id=sheet[0];
            a.group=sheet[1];
            a.time=sheet[2];
            a.angle=sheet[3];
            a.patharg=sheet[4];
            a.segInfo=sheet[5];
            a.loop=sheet[6];
            a.mirror=sheet[7];
            a.closePath=sheet[8];
            a.path=sheet[9];

            return a;
        }

        public static function instance(key:Object):cfg_fishgrouppath
		{
            return ConfigManager.getConfObject("cfg_fishgrouppath",key) as cfg_fishgrouppath;
		}


        
        public var id:int;
        public var group:int;
        public var time:Number;
        public var angle:int;
        public var patharg:Number;
        public var segInfo:Array;
        public var loop:int;
        public var mirror:int;
        public var closePath:int;
        public var path:Array;


	}
}