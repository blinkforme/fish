
package conf
{
    import manager.ConfigManager
	public class cfg_skill
	{
        public static function init(sheet:Object):cfg_skill
        {
            var a:cfg_skill = new cfg_skill();

            
            a.id=sheet[0];
            a.name=sheet[1];
            a.icon=sheet[2];
            a.skill_type=sheet[3];
            a.cd=sheet[4];
            a.lasttime=sheet[5];
            a.coin_range=sheet[6];
            a.need_prop=sheet[7];
            a.firing_rate=sheet[8];
            a.speed_rate=sheet[9];
            a.sound=sheet[10];
            a.show=sheet[11];
            a.income=sheet[12];

            return a;
        }

        public static function instance(key:Object):cfg_skill
		{
            return ConfigManager.getConfObject("cfg_skill",key) as cfg_skill;
		}


        
        public var id:int;
        public var name:String;
        public var icon:String;
        public var skill_type:int;
        public var cd:int;
        public var lasttime:int;
        public var coin_range:Array;
        public var need_prop:int;
        public var firing_rate:Number;
        public var speed_rate:Number;
        public var sound:String;
        public var show:String;
        public var income:int;


	}
}