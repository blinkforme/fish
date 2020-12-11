
package conf
{
    import manager.ConfigManager
	public class cfg_fish
	{
        public static function init(sheet:Object):cfg_fish
        {
            var a:cfg_fish = new cfg_fish();

            
            a.id=sheet[0];
            a.aniName=sheet[1];
            a.aniName_down=sheet[2];
            a.coin_fly=sheet[3];
            a.group=sheet[4];
            a.group_down=sheet[5];
            a.horse_id=sheet[6];
            a.ctype=sheet[7];
            a.delay=sheet[8];
            a.diamond_drop=sheet[9];
            a.call=sheet[10];
            a.callEffectTime=sheet[11];
            a.lock_pri=sheet[12];
            a.weight=sheet[13];
            a.boom=sheet[14];
            a.specFlag=sheet[15];
            a.catch_show_range=sheet[16];
            a.show_ani_range=sheet[17];
            a.show_ani_name=sheet[18];
            a.catch_range=sheet[19];
            a.start_time=sheet[20];
            a.end_time=sheet[21];
            a.catch_time=sheet[22];
            a.catch_show_rate=sheet[23];
            a.catch_show=sheet[24];
            a.ani_name=sheet[25];
            a.action_name=sheet[26];
            a.dead_ani=sheet[27];
            a.come_ani_name=sheet[28];
            a.come_action_name=sheet[29];
            a.playCatchSound=sheet[30];
            a.comeSound=sheet[31];
            a.CatchSound=sheet[32];
            a.swimName=sheet[33];
            a.deadAniExist=sheet[34];
            a.hitSound=sheet[35];
            a.layer=sheet[36];
            a.isMirror=sheet[37];
            a.length=sheet[38];
            a.height=sheet[39];
            a.speed=sheet[40];
            a.sizeType=sheet[41];
            a.scale=sheet[42];
            a.chance=sheet[43];
            a.goldFishRate=sheet[44];
            a.coin_rate=sheet[45];
            a.goldFishHpRate=sheet[46];
            a.goldFishAwardCoin=sheet[47];
            a.Imageurl=sheet[48];
            a.Imageurl_down=sheet[49];
            a.fishType=sheet[50];
            a.fishname=sheet[51];
            a.fishname_down=sheet[52];
            a.shock=sheet[53];
            a.hitAni=sheet[54];
            a.hit_time=sheet[55];
            a.task_id=sheet[56];
            a.change_coin_value=sheet[57];
            a.change_num=sheet[58];
            a.ticket_type=sheet[59];
            a.stock=sheet[60];
            a.change_img=sheet[61];
            a.wagesX=sheet[62];
            a.wagesY=sheet[63];
            a.preLoadNum=sheet[64];
            a.replace_id=sheet[65];

            return a;
        }

        public static function instance(key:Object):cfg_fish
		{
            return ConfigManager.getConfObject("cfg_fish",key) as cfg_fish;
		}


        
        public var id:int;
        public var aniName:String;
        public var aniName_down:String;
        public var coin_fly:Array;
        public var group:int;
        public var group_down:int;
        public var horse_id:int;
        public var ctype:int;
        public var delay:Number;
        public var diamond_drop:int;
        public var call:int;
        public var callEffectTime:Number;
        public var lock_pri:int;
        public var weight:Array;
        public var boom:int;
        public var specFlag:Object;
        public var catch_show_range:Array;
        public var show_ani_range:Array;
        public var show_ani_name:String;
        public var catch_range:int;
        public var start_time:Number;
        public var end_time:Number;
        public var catch_time:Number;
        public var catch_show_rate:Number;
        public var catch_show:int;
        public var ani_name:String;
        public var action_name:String;
        public var dead_ani:String;
        public var come_ani_name:String;
        public var come_action_name:String;
        public var playCatchSound:int;
        public var comeSound:String;
        public var CatchSound:String;
        public var swimName:String;
        public var deadAniExist:int;
        public var hitSound:String;
        public var layer:int;
        public var isMirror:int;
        public var length:Number;
        public var height:Number;
        public var speed:Number;
        public var sizeType:int;
        public var scale:Number;
        public var chance:int;
        public var goldFishRate:Number;
        public var coin_rate:Number;
        public var goldFishHpRate:Number;
        public var goldFishAwardCoin:Number;
        public var Imageurl:String;
        public var Imageurl_down:String;
        public var fishType:int;
        public var fishname:String;
        public var fishname_down:String;
        public var shock:Array;
        public var hitAni:int;
        public var hit_time:Number;
        public var task_id:int;
        public var change_coin_value:int;
        public var change_num:int;
        public var ticket_type:int;
        public var stock:int;
        public var change_img:String;
        public var wagesX:int;
        public var wagesY:int;
        public var preLoadNum:int;
        public var replace_id:int;


	}
}