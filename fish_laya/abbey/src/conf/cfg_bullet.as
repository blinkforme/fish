
package conf
{
    import manager.ConfigManager
	public class cfg_bullet
	{
        public static function init(sheet:Object):cfg_bullet
        {
            var a:cfg_bullet = new cfg_bullet();

            
            a.id=sheet[0];
            a.name=sheet[1];
            a.comsume=sheet[2];
            a.speed=sheet[3];

            return a;
        }

        public static function instance(key:Object):cfg_bullet
		{
            return ConfigManager.getConfObject("cfg_bullet",key) as cfg_bullet;
		}


        
        public var id:int;
        public var name:String;
        public var comsume:int;
        public var speed:Number;


	}
}