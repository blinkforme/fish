
package conf
{
    import manager.ConfigManager
	public class cfg_global
	{
        public static function init(sheet:Object):cfg_global
        {
            var a:cfg_global = new cfg_global();

            
            a.id=sheet[0];
            a.bomb_collision_count=sheet[1];
            a.bomb_scale_width=sheet[2];
            a.bomb_scale_height=sheet[3];
            a.award_effect_time=sheet[4];
            a.award_effect_scale_min=sheet[5];
            a.gold_stay_time=sheet[6];
            a.gold_sound1_value=sheet[7];
            a.gold_sound_play_interval=sheet[8];
            a.bullet_interval=sheet[9];
            a.normalFishTime=sheet[10];
            a.bezierRate=sheet[11];
            a.bezierRateTime=sheet[12];
            a.server_model=sheet[13];
            a.form_interval=sheet[14];
            a.clear_up_time=sheet[15];
            a.form_born_inverval=sheet[16];
            a.form_end_born=sheet[17];
            a.sta_data_time=sheet[18];
            a.db_max=sheet[19];
            a.db_buff=sheet[20];
            a.db_num=sheet[21];
            a.award_group=sheet[22];
            a.max_bullet_num=sheet[23];
            a.max_call_num=sheet[24];
            a.boss_delay_form_born=sheet[25];
            a.click_sound=sheet[26];
            a.get_coin_sound=sheet[27];
            a.hit_sound=sheet[28];
            a.battery_unlock_sound=sheet[29];
            a.shoot_sound=sheet[30];
            a.level_up_sound=sheet[31];
            a.tide_sound=sheet[32];
            a.bingo_sound=sheet[33];
            a.extra_drop_sound=sheet[34];
            a.get_sound=sheet[35];
            a.cost_coin_max=sheet[36];
            a.min_level=sheet[37];
            a.min_battery=sheet[38];
            a.mini_battery=sheet[39];
            a.camera_shot=sheet[40];
            a.double_coin_battery=sheet[41];
            a.double_chance_battery=sheet[42];
            a.maxWatchADTimes
=sheet[43];
            a.watchAdRewardIds
=sheet[44];
            a.watchAdRewardNums
=sheet[45];
            a.route_of_entry_reward_ids=sheet[46];
            a.route_of_entry_reward_nums=sheet[47];
            a.sign_days=sheet[48];
            a.rech_days=sheet[49];
            a.upgrade_days=sheet[50];
            a.raffle_config=sheet[51];

            return a;
        }

        public static function instance(key:Object):cfg_global
		{
            return ConfigManager.getConfObject("cfg_global",key) as cfg_global;
		}


        
        public var id:int;
        public var bomb_collision_count:int;
        public var bomb_scale_width:Number;
        public var bomb_scale_height:Number;
        public var award_effect_time:Number;
        public var award_effect_scale_min:Number;
        public var gold_stay_time:Number;
        public var gold_sound1_value:int;
        public var gold_sound_play_interval:Number;
        public var bullet_interval:Number;
        public var normalFishTime:Number;
        public var bezierRate:Number;
        public var bezierRateTime:Number;
        public var server_model:String;
        public var form_interval:int;
        public var clear_up_time:int;
        public var form_born_inverval:Number;
        public var form_end_born:Number;
        public var sta_data_time:Array;
        public var db_max:int;
        public var db_buff:Array;
        public var db_num:int;
        public var award_group:int;
        public var max_bullet_num:int;
        public var max_call_num:int;
        public var boss_delay_form_born:int;
        public var click_sound:String;
        public var get_coin_sound:String;
        public var hit_sound:String;
        public var battery_unlock_sound:String;
        public var shoot_sound:String;
        public var level_up_sound:String;
        public var tide_sound:String;
        public var bingo_sound:String;
        public var extra_drop_sound:String;
        public var get_sound:String;
        public var cost_coin_max:int;
        public var min_level:int;
        public var min_battery:int;
        public var mini_battery:int;
        public var camera_shot:String;
        public var double_coin_battery:int;
        public var double_chance_battery:int;
        public var maxWatchADTimes
:int;
        public var watchAdRewardIds
:Array;
        public var watchAdRewardNums
:Array;
        public var route_of_entry_reward_ids:Array;
        public var route_of_entry_reward_nums:Array;
        public var sign_days:int;
        public var rech_days:int;
        public var upgrade_days:int;
        public var raffle_config:Object;


	}
}