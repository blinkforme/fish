package engine.workers
{
    import laya.net.HttpRequest;
    import laya.net.ResourceVersion;
    import laya.utils.Browser;

    public class WorkerManager
    {
        private static var _instance:WorkerManager;
        private var _worker:Worker;
        private var _workerFilePath:String = "my_task.js"
        private var _workerManifestFilePath:String = "";
        private var _isExistWorker:Boolean = false

        public static function get instance():WorkerManager
        {
            return _instance || (_instance = new WorkerManager())
        }

        public function isExistWorker():Boolean
        {
            if (__JS__("Worker"))
            {
                if(_workerManifestFilePath==""&&ResourceVersion.manifest)
                {
                    _workerManifestFilePath=ResourceVersion.manifest[_workerFilePath]
                    _isExistWorker = true;
                }else if (_workerManifestFilePath!=""&&ResourceVersion.manifest)
                {
                    _isExistWorker = true;
                }else if(_workerManifestFilePath==""&&!ResourceVersion.manifest)
                {
                    _workerManifestFilePath=_workerFilePath
                    _isExistWorker = true;
                }else if(_workerManifestFilePath!=""&&!ResourceVersion.manifest)
                {
                    _isExistWorker = true;
                }else
                {
                    _isExistWorker = false;
                }
            } else
            {
                _isExistWorker = false;
            }
            return _isExistWorker
        }


        public function init():void
        {
            if (isExistWorker())
            {
                if (!_worker)
                {
                    _worker = new Worker(_workerManifestFilePath)
                    onMessage();
                    startWorker();
                }
            } else
            {
                console.log("Sorry, your browser does not support Web Workers...")
            }
        }

        private function onMessage():void
        {
            _worker.onmessage = function (oEvent):void
            {
                console.log(oEvent)
                console.log("Called back by the worker!\n")

                if (oEvent.type == "Buried")
                {
                    var request:HttpRequest = new HttpRequest();
                    var fullUrl:String = ENV.buriedUrl + "/common/collector"
                    request.send(fullUrl, Browser.window.JSON.stringify(oEvent.data), "post", 'json', ["Content-Type", "application/json"]);
                }
            }
        }

        //开启worker线程
        private function startWorker():void
        {
            _worker.postMessage("start")
        }

        public function finishWorker():void
        {
            if(_worker)
            {
                _worker.terminate();
            }
        }

        public function postMessage(type:String, data:Object):void
        {
            _worker.postMessage({type: type, data: data})
        }

    }
}
