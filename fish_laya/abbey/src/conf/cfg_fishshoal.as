
package conf
{
    import manager.ConfigManager
	public class cfg_fishshoal
	{
        public static function init(sheet:Object):cfg_fishshoal
        {
            var a:cfg_fishshoal = new cfg_fishshoal();

            
            a.id=sheet[0];
            a.scene=sheet[1];
            a.fish=sheet[2];
            a.rule_3d_c=sheet[3];

            return a;
        }

        public static function instance(key:Object):cfg_fishshoal
		{
            return ConfigManager.getConfObject("cfg_fishshoal",key) as cfg_fishshoal;
		}


        
        public var id:int;
        public var scene:int;
        public var fish:int;
        public var rule_3d_c:Object;


	}
}