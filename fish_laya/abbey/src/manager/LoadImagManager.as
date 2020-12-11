package manager
{
    import laya.events.Event;
    import laya.ui.Image;
    import laya.utils.Handler;

    public class LoadImagManager
    {
        private static var _instance:LoadImagManager;

        public function LoadImagManager()
        {
        }

        public static function get instance():LoadImagManager
        {
            return _instance || (_instance = new LoadImagManager());
        }

        public function showImag(url:String, image:Image):void
        {
            Laya.loader.load(url, Handler.create(this, loadComplete, [image, url]));
            Laya.loader.on(Event.ERROR, this, onerror, [image, url]);
        }

        //加载失败
        private function onerror(image:Image, url:String):void
        {
            Laya.loader.load(url, Handler.create(this, loadComplete, [image, url]));
            Laya.loader.on(Event.ERROR, this, onerror, [image, url]);

        }

        //加载成功
        private function loadComplete(image:Image, url:String):void
        {
            image.skin = url;

        }
    }
}
