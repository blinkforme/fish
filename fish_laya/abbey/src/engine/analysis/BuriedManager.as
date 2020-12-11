package engine.analysis
{
    import engine.tool.StartParam;
    import engine.workers.WorkerManager;

    import laya.net.HttpRequest;
    import laya.utils.Browser;

    public class BuriedManager
    {

        private static var _instance:BuriedManager;

        public var buriedArr = []

        private var uid = ""
        private var is_new = ""
        private var pf = -1;

        public function BuriedManager()
        {
            if (!WorkerManager.instance.isExistWorker())
            {
                Laya.timer.loop(10000, this, sync)
            }
        }


        public static function get instance():BuriedManager
        {
            return _instance || (_instance = new BuriedManager());
        }

        private function request(params:Object)
        {
            var request:HttpRequest = new HttpRequest();
            var fullUrl:String = ENV.buriedUrl + "/common/collector"

            request.send(fullUrl, Browser.window.JSON.stringify(params), "post", 'json', ["Content-Type", "application/json"]);
        }


        private function getDeviceType():String
        {
            if (Browser.onIOS)
            {
                return "ios"
            } else if (Browser.onAndroid)
            {
                return "android"
            } else if (Browser.onPC)
            {
                return "pc"
            } else
            {
                return "unknown"
            }
        }


        private function getCommonParams():Object
        {

            if (!uid || uid == "")
            {
                uid = StartParam.instance.getParam("uid") + "";
            }
            if (!is_new || is_new == "")
            {
                is_new = StartParam.instance.getParam("is_new") + "";
            }
            if (parseInt(pf) < 0 || !pf)
            {
                pf = StartParam.instance.getParam("provider_id");
                if (typeof (pf) == "string")
                {
                    pf = parseInt(pf);
                }
            }
            return {
                uid: uid,
                game_id: ENV.buriedGameId,
                is_new: is_new,
                device: getDeviceType(),
                pf: pf
            }
        }


        public function addBuriedData(type, data = {}):void
        {
            buriedArr.push({type: type, data: data})
            if (WorkerManager.instance.isExistWorker())
            {
                var params = [getCommonParams(), buriedArr]
                buriedArr = []
                WorkerManager.instance.postMessage("Buried", params)
            }
        }

        public function sync():void
        {
            if (!WorkerManager.instance.isExistWorker())
            {
                if (buriedArr.length > 0)
                {
                    sendMulti(buriedArr)
                    buriedArr = []
                }
            }
        }

        public function sendMulti(dataArr:Array):void
        {
            var params = [getCommonParams(), dataArr]
            request(params)
        }

    }

}
