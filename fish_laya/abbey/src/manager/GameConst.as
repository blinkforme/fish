package manager
{
    public class GameConst
    {
        public static const handshake_ok:int = 200; //握手成功
        public static const handshake_illegal:int = 301; //非法账户
        public static const handshake_new:int = 404; //新建用户
        public static const playercreate_ok:int = 0; //用户创建成功
        public static const playercreater_ename:int = 1; //用户名称已经使用过
        public static const fight_get_in_in_room:int = 2; //已在房间中进入失败
        public static const fight_get_in_fail:int = 1; //进入失败
        public static const fight_get_in_ok:int = 0; //进入成功
        public static const fight_get_in_cost_max:int = 4;//当天消耗金币太多
        public static const fishmaxlayer:int = 40;//鱼的最大层数
        public static const fish_type_size_group:int = 0;//鱼群
        public static const fish_type_size_small:int = 1;//小鱼
        public static const fish_type_size_middle:int = 2;//中型鱼
        public static const fish_type_size_big:int = 3;//大鱼
        public static const fish_type_size_boss:int = 4;//boss
        public static const fish_group_type_left_to_right:int = 0;//鱼群左到右
        public static const fish_group_type_path:int = 1;//路径鱼群
        public static const fish_fit_rnd_none:int = 0;
        public static const fish_fit_rnd_once:int = 1;
        public static const fish_fit_rnd_cfg:int = 2;
        public static const fish_fit_rnd_cfg_once:int = 3;
        public static const fish_fit_rnd_everyone:int = 4;
        public static const fish_play_type_none:int = 0;
        public static const fish_play_type_local_bomb:int = 1;
        public static const fish_play_type_screen_bomb:int = 2;
        public static const fish_play_type_dasanyuan:int = 3;
        public static const fish_play_type_fish_type_bomb:int = 4;
        public static const fish_play_type_energy:int = 5;
        public static const fish_play_type_dasixi:int = 6;
        public static const fish_play_type_yiwangdajin:int = 7;
        public static const fixed_update_time:Number = (1 / 50);
        public static const area_play_type_max_num:int = 15;
        public static const draw_collision_rect:Boolean = false;
        public static const currency_coin:int = 1;
        public static const currency_fish_coin:int = 2;
        public static const currency_exp:int = 3;
        public static const currency_diamond:int = 4;
        public static const currency_rmb:int = 5;
        public static const currency_goods:int = 6;
        public static const currency_contest_score:int = 201;
        public static const currency_exchange:int = 60;
        public static const currency_bind_coin:int = 10;
        public static const server_mode:int = 0; //服务器模式 0:local 1:stage 2:prod
        public static const main_edit_menu_show:Boolean = false;//主界面编辑菜单是否显示
        public static const fix_left_down_pos:Boolean = true;//固定左下角位置
        public static const show_fish_swim_path_id:Boolean = false;//显示鱼游动的路径id
        public static const fish_path_mirror_none:int = 1;
        public static const fish_path_mirror_x:int = 2;
        public static const fish_path_mirror_y:int = 3;
        public static const fish_path_mirror_xy:int = 4;
        public static const skill_type_freeze:int = 1;//冰冻
        public static const skill_type_lock:int = 2;//锁定
        public static const skill_type_call:int = 3;//召唤
        public static const skill_type_violent:int = 4;//狂暴
        public static const skill_type_boom:int = 5;//炸弹
        public static const skill_type_auto:int = 6;//自动发炮
        public static const lock_effect_layer_index:int = 0;
        public static const boom_effect_layer_index:int = 1;
        public static const bullet_layer_index:int = 2;
        public static const award_effect_layer_index:int = 3;
        public static const catch_show_layer_index:int = 4;
        public static const boom_mask_layer_index:int = fishmaxlayer * 2 - 2;
        public static const use_res_release_skill:int = 5; //使用资源释放技能
        public static const sign_in_getted:int = 0; //已经领取
        public static const sign_in_getting:int = 2; //可领取
        public static const sign_in_not_reach:int = 3; //未到领取时间
        public static const fish_catch_type_normal:int = 0;
        public static const fish_catch_type_extra_drop:int = 1;
        public static const fish_catch_type_boss:int = 2;
        public static const fish_catch_type_black_hole:int = 3;
        public static const fish_catch_type_award_pool:int = 4;
        public static const online_award_status_getted:int = 1; //已经领取
        public static const online_award_status_start:int = 2; //开始计时领取
        public static const online_award_status_not_start:int = 3; //未开始计时领取
        public static const quit_state_left_confirm_right_cancel:int = 0;
        public static const quit_state_left_cancel_right_confirm:int = 1;
        public static const quit_state_mid_confirm:int = 2;
        public static const quit_state_left_cancel_right_confirm_rank:int = 4;
        public static const quit_state_mid_confirm_subscibe:int = 5;

        public static const shop_tab_diamond:String = "tab_diamond";
        public static const shop_tab_coin:String = "tab_coin";
        public static const shop_tab_skin:String = "tab_skin";
        public static const shop_tab_package:String = "tab_package";
        public static const shop_tab_mini:String = "tab_mini";
        public static const shop_tab_mini_coin:String = "tab_mini_coin";

        public static const sceneId_1:Number = 1;  //深海巨鲸渔场id


        public static const reconnect_type_other_device_login:int = 1;//账号在其他设备登录
        public static const reconnect_type_kick:int = 2; //玩家被踢出
        public static const reconnect_type_socket_error:int = 3; //网络出错
        public static const reconnect_type_server_error:int = 4;//服务器异常
        public static const reconnect_type_user_check_error:int = 5; //用户校验失败
        public static const reconnect_type_network_error:int = 6; //网络状态提示
        public static const reconnect_admin_kick:int = 7; //管理员主动踢下线&封号
        //小红点类型
        public static const point_new_task_finish:int = 1; //新手任务完成
        public static const point_online_reward:int = 2; //在线奖励
        public static const point_weapon:int = 4; //新武器
        public static const point_sign:int = 8; //签到小红点
        public static const point_first_charge:int = 16; //首充小红点
        public static const point_vip_buy:int = 32; //VIP小红点
        public static const point_month_card:int = 64; //月卡小红点
        public static const point_gift:int = 128; //赠送小红点
        public static const point_rank:int = 8192; //赠送小红点


        public static const ani_type_frame:int = 0; //帧动画
        public static const ani_type_skeleton:int = 1; //骨骼动画
        public static const ani_type_3d:int = 2; //3d动画

        //发射子弹失败时发生的动作
        public static const shoot_bullet_fail_action_sub_allow:int = 1; //领取低保
        public static const shoot_bullet_fail_action_open_shop:int = 2; //

        //默认声音大小
        public static const default_sound:Number = 0.5;
        public static const default_bgm_music:Number = 0.5;

        public static const in_fight_normal:int = 0; //正常状态，快速进入
        public static const in_fight_by:int = 1;//捕鱼房间中

        //场景玩法类型
        public static const scene_play_extra_drop:int = 1;//额外掉落
        public static const scene_play_money_bag:int = 2;//钱袋捕获
        public static const scene_play_black_hole:int = 3;//黑洞
        public static const scene_play_award_pool:int = 4;//奖池


        public static const Dec_Active:int = 21; //12月活动id
        public static const server_local:Boolean = true;


        public static const edition_department_version:Boolean = true;

        public static const design_width:int = 1280;
        public static const design_height:int = 720;
        public static const atuoFire:int = 0 //自动发炮
        public static const noAutoFire:int = 1;//不自动发炮
        public static const oPauseAutoFire:int = 2;//打开界面自动法袍

        public static const appid:String = "wxeb898598bd6698dd";
        public static const jumpLink:String = "http://cdn.597w.com/shareprod"
        public static const loadMainState:Number = 0; //加载主界面的状态
        public static const loadFishState:Number = 1 //加载战斗界面的状态
        public static const FISH_PAGE:String = "fish_page";
        public static const MAIN_PAGE:String = "main_page"


        public static const activity_bomb:String = 'bomb';
        public static const activity_bonus:String = 'bonus';
        public static const activity_worldcup:String = 'worldcup2';//新的世界杯活动，老得不用了
        public static const activity_wheel:String = 'turntable';
        public static const activity_common:String = 'multi_at';//公共活动
        public static const activity_rank:String = 'top_double';//排行榜双倍奖励
        public static const activity_red_pack:String = 'red_pack';//喇叭活动

        public static const activity_common_shop:Number = 1;//商场返利（充值）
        public static const activity_common_rew:Number = 2;//渔场内抽奖页面
        public static const activity_common_daymatch:Number = 3;//活动日常赛
        public static const activity_common_register:Number = 4;//签到奖励
        public static const activity_common_share:Number = 5;//分享奖励 每日转盘
        public static const activity_common_since:Number = 6;//第四关奖金池
        public static const activity_common_directchanges:Number = 101;//直接兑换
        public static const activity_common_giftbox:Number = 102;//分享礼盒
        public static const activity_common_rankactivity:Number = 103;//排行榜活动
        public static const activity_common_main_rank:Number = 105;//主界面排行榜
        public static const activity_common_main_daily_gift:Number = 106;//主界面每日礼包
        public static const activity_common_main_match:Number = 107;//四人赛场活动是否开启


        public static const activity_currency_one:Number = 81; //12月活动币1的goodsID
        public static const activity_currency_two:Number = 82;  //  币2
        public static const activity_currency_three:Number = 83;  //  币3

        public static const coin_type_exchange:String = "exchange_card"
        public static const coin_type_activity:String = "at_coin"
        public static const coin_type_worldcup:String = "worldcup"
        public static const coin_type_wheel:String = "zbwk_coin";//转盘活动

        public static const scene_resource_coin:int = 1;
        public static const scene_resource_contest_coin:int = 2;

        public static const contest_daily_scene_id:int = 5;//日常赛
        public static const contest_tz_scene_id:int = 6;//挑战赛
        public static const contest_match_scene_id:int = 7;//匹配赛
        public static const contest_qd_scene_id:int = 8;//抢夺赛

        public static const platform:String = platform_h5;
        public static const platform_h5:String = "h5";
        public static const platform_wx_sg:String = "wx_gs";

        public static const platform_wx:Number = 1;
        public static const platform_not_wx:Number = 2;

        public static const public_no_id_none:int = 0; //无渠道
        public static const public_no_id_jjh:int = 1;//集结号娱乐公众号
        public static const public_no_id_jjhh5:int = 2;//集结号捕鱼H5公众号
        public static const public_no_id_ljby:int = 3; //游戏坛子

        public static const month_card_id:Number = 18;

        public static const week_card_id:Number = 41;
        public static const worldcup_battery_id:Number = 9

        public static const show_died:Number = 0x20;//鱼场是否俯视视角
        public static const show_banner:Number = 0x08;//鱼场是否俯视视角


        public static const start_scene_pull:Number = 1104; //从微信聊天界面下拉菜单启动游戏
        public static const start_scene_collect:Number = 1103; //从发现我的小程序进入

        public static const user_status_normal:String = "normal";
        public static const user_status_ban:String = "ban";
        public static const user_status_limited:String = "limited";


        public static const novice_guide_click = "click";
        public static const novice_guide_fight = "fight";
        public static const novice_guide_shoot = "shoot";
        public static const novice_guide_slider = "slider"
        public static const novice_guide_new = "new"
        public static const novice_guide_acceptNew = "acceptNew"
        public static const novice_guide_quitNew = "quitNew"
        public static const novice_guide_daily = "daily"
        public static const novice_guide_daily_go = "dailyGo"
        public static const novice_guide_daily_use_prop = "dailyUseProp"
        public static const novice_guide_daily_accept = "acceptDaily"

        public static const novice_guide_quitDaily = "quitDaily"
        public static const novice_guide_unlockBattery = "unlockBattery"
        public static const novice_guide_changeBattery = "changeBattery"


        public static const platform_yyly = "yyly";
        public static const platform_360 = "360h5";
        public static const platform_yawy = "yawy";
        public static const platform_aiqiyi = "aiqiyi";
        public static const platform_cocos = "cocos";

        public static const platform_android_baidu = "baidu";
        public static const platform_android_huawei = "huawei";
        public static const platform_android_360 = "360";
        public static const platform_android_app = "app";
        public static const platform_android_meizu = "meizu";
        public static const platform_android_yyb = "yyb";
        public static const platform_android_aiqiyi = "aiqiyi";
        public static const platform_android_xiaomi = "xiaomi";
        public static const platform_android_ali = "ali";
        public static const platform_android_quick = "quick";


        public static const novice_guide_slider_contest = "slider_to_contest"
        public static const novice_guide_open_contest_icon = "open_contest_icon"
        public static const novice_guide_sign_contest = "sign_contest"
        public static const novice_guide_sign_contest_confirm = "sign_contest_confirm"
        public static const novice_guide_rank = "rank"
        public static const novice_guide_quitRank = "rankQuit"
        public static const novice_guide_quitFight = "quitFight"
        public static const novice_guide_open_follow = "openFollow"

        public static const font_red = "red";
        public static const font_red_sheet = "取出立即购买获得消确定继 续搜索同意拒绝复制升级解 锁游戏领前往充放置全部加 入房间重抽报名免费";
        public static const font_green = "green";
        public static const font_green_sheet = "存入取消查看确定装备邀请 一键升级返回大厅反馈分享 礼包码炫耀下领奖励提交开 启使用完成布置规则询赠送 购买个观看广告订阅兑换全 部";
        public static const wxSDKVersion:String = "2.0.6";

        public static const from_login = "login";
        public static const from_shop = "shop";
        public static const from_main = "main";
        public static const from_month = "month";
        public static const from_gift = "Gift";
        public static const from_bank = "bank";
        public static const from_quick_register = "quick_register";
        public static const from_certifucation = "certifucation";

        public static const shield_status = 3
        public static const reject_status = 2
        public static const agree_status = 1
    }
}
