
package conf
{
    import manager.ConfigManager
	public class cfg_battery
	{
        public static function init(sheet:Object):cfg_battery
        {
            var a:cfg_battery = new cfg_battery();

            
            a.id=sheet[0];
            a.need_diamond=sheet[1];
            a.cast_diamond=sheet[2];
            a.maxDegree=sheet[3];
            a.degree=sheet[4];
            a.comsume=sheet[5];
            a.award=sheet[6];
            a.buff=sheet[7];
            a.prize=sheet[8];

            return a;
        }

        public static function instance(key:Object):cfg_battery
		{
            return ConfigManager.getConfObject("cfg_battery",key) as cfg_battery;
		}


        
        public var id:int;
        public var need_diamond:int;
        public var cast_diamond:int;
        public var maxDegree:int;
        public var degree:int;
        public var comsume:int;
        public var award:Array;
        public var buff:Array;
        public var prize:int;


	}
}