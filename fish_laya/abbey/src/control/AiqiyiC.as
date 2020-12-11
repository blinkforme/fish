package control
{
    import engine.tool.StartParam;

    import model.LoginInfoM;

import conf.cfg_bulletmodel;

import manager.GameConst;
import manager.GameTools;

public class AiqiyiC
	{
        private static var _instance:AiqiyiC;

        public static function get instance():AiqiyiC
        {
            return _instance || (_instance = new AiqiyiC());
        }

        public function AiqiyiC()
		{
			
		}

		public function DataSendMessge():void
		{
            if(StartParam.instance.getParam("platform") == GameConst.platform_aiqiyi)
            {
				if(GameTools.getUrlParamValue('is_new') == 1){
                    var objRole = {
                        type:'dataCount',
                        msg :'role'
                    }
                    postData(objRole)
				}
				var objSer = {
					type:'dataCount',
					msg :'server'
				}
				postData(objSer)
 				var objStart = {
					type:'dataCount',
					msg :'start'
				}
				postData(objStart)
            }
        }

		public function postData(obj:*):void
		{
            var win:* = __JS__("window")
            var arr = [
                "http://togame.pps.tv",
                "http://togame.iqiyi.com",
                "http://playgame.pps.tv",
                "http://playgame.iqiyi.com",
                "http://playgame2.iqiyi.com"
            ]
            for (var i:Number = 0; i < 5; i++)
            {
                var url:String = arr[i]
                win.top.postMessage(obj,url);
            }
		}
	}

}
