
package conf
{
    import manager.ConfigManager
	public class cfg_scene
	{
        public static function init(sheet:Object):cfg_scene
        {
            var a:cfg_scene = new cfg_scene();

            
            a.id=sheet[0];
            a.play_id=sheet[1];
            a.robot_time=sheet[2];
            a.type=sheet[3];
            a.fish_arr=sheet[4];
            a.skills=sheet[5];
            a.smallfish_arr=sheet[6];
            a.bigfish_arr=sheet[7];
            a.unlock=sheet[8];
            a.robot_mag=sheet[9];
            a.max_mag=sheet[10];
            a.min_mag=sheet[11];
            a.pri=sheet[12];
            a.is_basic=sheet[13];
            a.form=sheet[14];
            a.form_arr=sheet[15];
            a.form_arr_down=sheet[16];
            a.play_group=sheet[17];
            a.nextArea=sheet[18];
            a.img=sheet[19];
            a.sceneBgImg=sheet[20];
            a.sceneBgImg_down=sheet[21];
            a.backMusic=sheet[22];
            a.levelname=sheet[23];
            a.imageurl=sheet[24];
            a.sceneType=sheet[25];
            a.msgTip=sheet[26];
            a.unlockImage=sheet[27];
            a.web=sheet[28];
            a.range=sheet[29];
            a.msg_tip_id=sheet[30];
            a.spine_name=sheet[31];
            a.spine_name_down=sheet[32];
            a.resource=sheet[33];
            a.description=sheet[34];
            a.show_ani=sheet[35];
            a.hidden_battery_level=sheet[36];
            a.doubleRate=sheet[37];

            return a;
        }

        public static function instance(key:Object):cfg_scene
		{
            return ConfigManager.getConfObject("cfg_scene",key) as cfg_scene;
		}


        
        public var id:int;
        public var play_id:int;
        public var robot_time:Array;
        public var type:int;
        public var fish_arr:Array;
        public var skills:Array;
        public var smallfish_arr:Array;
        public var bigfish_arr:Array;
        public var unlock:int;
        public var robot_mag:Array;
        public var max_mag:int;
        public var min_mag:int;
        public var pri:int;
        public var is_basic:int;
        public var form:int;
        public var form_arr:Array;
        public var form_arr_down:Array;
        public var play_group:int;
        public var nextArea:int;
        public var img:String;
        public var sceneBgImg:String;
        public var sceneBgImg_down:String;
        public var backMusic:String;
        public var levelname:String;
        public var imageurl:String;
        public var sceneType:int;
        public var msgTip:String;
        public var unlockImage:String;
        public var web:Number;
        public var range:int;
        public var msg_tip_id:int;
        public var spine_name:String;
        public var spine_name_down:String;
        public var resource:int;
        public var description:String;
        public var show_ani:int;
        public var hidden_battery_level:int;
        public var doubleRate:Array;


	}
}