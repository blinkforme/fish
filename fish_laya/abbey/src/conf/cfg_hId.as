
package conf
{
    import manager.ConfigManager
	public class cfg_hId
	{
        public static function init(sheet:Object):cfg_hId
        {
            var a:cfg_hId = new cfg_hId();

            
            a.id=sheet[0];
            a.txtColor=sheet[1];
            a.txtContent=sheet[2];
            a.txtType=sheet[3];

            return a;
        }

        public static function instance(key:Object):cfg_hId
		{
            return ConfigManager.getConfObject("cfg_hId",key) as cfg_hId;
		}


        
        public var id:int;
        public var txtColor:String;
        public var txtContent:String;
        public var txtType:int;


	}
}