
package conf
{
    import manager.ConfigManager
	public class cfg_commodity
	{
        public static function init(sheet:Object):cfg_commodity
        {
            var a:cfg_commodity = new cfg_commodity();

            
            a.id=sheet[0];
            a.title=sheet[1];
            a.img=sheet[2];
            a.img_w=sheet[3];
            a.img_h=sheet[4];
            a.currency_id=sheet[5];
            a.currency_amount=sheet[6];
            a.mini_currency_id=sheet[7];
            a.mini_currency_amount=sheet[8];
            a.item_id=sheet[9];
            a.item_count=sheet[10];
            a.item_label=sheet[11];
            a.vip_exp=sheet[12];
            a.extra_item_id=sheet[13];
            a.extra_item_count=sheet[14];
            a.extra_item_good_id=sheet[15];
            a.extra_item_text=sheet[16];
            a.tab=sheet[17];
            a.buff=sheet[18];
            a.first_buy_gift_id=sheet[19];
            a.first_buy_gift_count=sheet[20];
            a.first_buy_good_id=sheet[21];
            a.first_buy_text=sheet[22];
            a.is_single_buy=sheet[23];
            a.sidebar_img=sheet[24];
            a.card_type=sheet[25];
            a.card_duration=sheet[26];
            a.reward_item_ids=sheet[27];
            a.reward_item_nums=sheet[28];
            a.card_title=sheet[29];
            a.card_title2=sheet[30];
            a.card_detail=sheet[31];
            a.good_ids=sheet[32];
            a.good_nums=sheet[33];
            a.activity=sheet[34];
            a.os=sheet[35];
            a.boxid=sheet[36];

            return a;
        }

        public static function instance(key:Object):cfg_commodity
		{
            return ConfigManager.getConfObject("cfg_commodity",key) as cfg_commodity;
		}


        
        public var id:int;
        public var title:String;
        public var img:String;
        public var img_w:int;
        public var img_h:int;
        public var currency_id:int;
        public var currency_amount:int;
        public var mini_currency_id:int;
        public var mini_currency_amount:int;
        public var item_id:int;
        public var item_count:int;
        public var item_label:String;
        public var vip_exp:int;
        public var extra_item_id:int;
        public var extra_item_count:int;
        public var extra_item_good_id:int;
        public var extra_item_text:String;
        public var tab:String;
        public var buff:Array;
        public var first_buy_gift_id:int;
        public var first_buy_gift_count:int;
        public var first_buy_good_id:int;
        public var first_buy_text:String;
        public var is_single_buy:int;
        public var sidebar_img:String;
        public var card_type:int;
        public var card_duration:int;
        public var reward_item_ids:Array;
        public var reward_item_nums:Array;
        public var card_title:String;
        public var card_title2:String;
        public var card_detail:String;
        public var good_ids:Array;
        public var good_nums:Array;
        public var activity:String;
        public var os:int;
        public var boxid:int;


	}
}