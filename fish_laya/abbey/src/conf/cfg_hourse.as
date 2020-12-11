
package conf
{
    import manager.ConfigManager
	public class cfg_hourse
	{
        public static function init(sheet:Object):cfg_hourse
        {
            var a:cfg_hourse = new cfg_hourse();

            
            a.id=sheet[0];
            a.txt1=sheet[1];
            a.txt2=sheet[2];
            a.txt3=sheet[3];
            a.txt4=sheet[4];
            a.txt5=sheet[5];
            a.txt6=sheet[6];
            a.txt7=sheet[7];
            a.delay=sheet[8];

            return a;
        }

        public static function instance(key:Object):cfg_hourse
		{
            return ConfigManager.getConfObject("cfg_hourse",key) as cfg_hourse;
		}


        
        public var id:int;
        public var txt1:int;
        public var txt2:int;
        public var txt3:int;
        public var txt4:int;
        public var txt5:int;
        public var txt6:int;
        public var txt7:int;
        public var delay:int;


	}
}