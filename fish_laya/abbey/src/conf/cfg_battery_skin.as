
package conf
{
    import manager.ConfigManager
	public class cfg_battery_skin
	{
        public static function init(sheet:Object):cfg_battery_skin
        {
            var a:cfg_battery_skin = new cfg_battery_skin();

            
            a.id=sheet[0];
            a.ani=sheet[1];
            a.batteryImg=sheet[2];
            a.batteryImg1=sheet[3];
            a.itemLabel=sheet[4];
            a.batteryBaseImg=sheet[5];
            a.name=sheet[6];
            a.web=sheet[7];
            a.action=sheet[8];
            a.follow=sheet[9];
            a.catch_count=sheet[10];
            a.multi=sheet[11];
            a.speed=sheet[12];
            a.shootInterval=sheet[13];
            a.offLen=sheet[14];
            a.offX=sheet[15];
            a.offAngle=sheet[16];
            a.desc=sheet[17];
            a.channel=sheet[18];
            a.tip_id=sheet[19];
            a.activity=sheet[20];
            a.more_change=sheet[21];
            a.less_change=sheet[22];
            a.toskin=sheet[23];
            a.isShowInList=sheet[24];

            return a;
        }

        public static function instance(key:Object):cfg_battery_skin
		{
            return ConfigManager.getConfObject("cfg_battery_skin",key) as cfg_battery_skin;
		}


        
        public var id:int;
        public var ani:String;
        public var batteryImg:String;
        public var batteryImg1:String;
        public var itemLabel:String;
        public var batteryBaseImg:String;
        public var name:String;
        public var web:String;
        public var action:String;
        public var follow:String;
        public var catch_count:int;
        public var multi:int;
        public var speed:Number;
        public var shootInterval:Number;
        public var offLen:Array;
        public var offX:Array;
        public var offAngle:Array;
        public var desc:String;
        public var channel:Array;
        public var tip_id:int;
        public var activity:String;
        public var more_change:int;
        public var less_change:int;
        public var toskin:int;
        public var isShowInList:int;


	}
}