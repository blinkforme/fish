
package conf
{
    import manager.ConfigManager
	public class cfg_novice_guide
	{
        public static function init(sheet:Object):cfg_novice_guide
        {
            var a:cfg_novice_guide = new cfg_novice_guide();

            
            a.id=sheet[0];
            a.type=sheet[1];
            a.click_name=sheet[2];
            a.click_event=sheet[3];
            a.step_box_name=sheet[4];
            a.step_list_name=sheet[5];
            a.effect_name1=sheet[6];

            return a;
        }

        public static function instance(key:Object):cfg_novice_guide
		{
            return ConfigManager.getConfObject("cfg_novice_guide",key) as cfg_novice_guide;
		}


        
        public var id:int;
        public var type:String;
        public var click_name:String;
        public var click_event:String;
        public var step_box_name:String;
        public var step_list_name:String;
        public var effect_name1:String;


	}
}