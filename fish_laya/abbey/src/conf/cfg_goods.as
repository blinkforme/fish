
package conf
{
    import manager.ConfigManager
	public class cfg_goods
	{
        public static function init(sheet:Object):cfg_goods
        {
            var a:cfg_goods = new cfg_goods();

            
            a.id=sheet[0];
            a.name=sheet[1];
            a.icon=sheet[2];
            a.replace_res=sheet[3];
            a.type=sheet[4];
            a.typeID=sheet[5];
            a.waceIcon=sheet[6];
            a.replace_reward_id=sheet[7];
            a.replace_reward_count=sheet[8];
            a.packed=sheet[9];
            a.pack_index=sheet[10];
            a.can_use=sheet[11];
            a.use_param=sheet[12];
            a.is_gift=sheet[13];
            a.is_alive=sheet[14];
            a.desc=sheet[15];

            return a;
        }

        public static function instance(key:Object):cfg_goods
		{
            return ConfigManager.getConfObject("cfg_goods",key) as cfg_goods;
		}


        
        public var id:int;
        public var name:String;
        public var icon:String;
        public var replace_res:Array;
        public var type:int;
        public var typeID:int;
        public var waceIcon:String;
        public var replace_reward_id:int;
        public var replace_reward_count:int;
        public var packed:int;
        public var pack_index:int;
        public var can_use:int;
        public var use_param:int;
        public var is_gift:int;
        public var is_alive:int;
        public var desc:String;


	}
}