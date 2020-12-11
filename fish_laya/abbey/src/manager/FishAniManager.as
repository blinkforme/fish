package manager
{
    import laya.net.Loader;

    public class FishAniManager
    {
        private static var _instance:FishAniManager;
        private var animalName:String;
        private var _ani:GameAnimation;
        private var data:Object;
        private var fishani:GameAnimation;

        public function FishAniManager()
        {

        }

        public static function get instance():FishAniManager
        {
            return _instance || (_instance = new FishAniManager());
        }

        //通过动画的名字得到动画对应的类
        public function loadAnimation(name:String):GameAnimation
        {
            _ani = new GameAnimation();
            return _ani.loadAtlas("res/atlas/ani/" + name + ".atlas");
            Loader.getAtlas("res/atlas/ani/" + name + ".atlas");
        }

        public function load(name:String):GameAnimation
        {
            data = ConfigManager.getConfObject("cfg_anicollision", name);
            _ani = new GameAnimation();
            fishani = _ani.loadImages(aniUrls(data.anilength));
            fishani.interval = data.aniSpeed
            return fishani;
        }


        public function loadAni(name:String, pngName:String, length:int):GameAnimation
        {
            _ani = new GameAnimation();
            return _ani.loadImages(aniUrls(length));
        }

        public function loadAniFrames(name:String):Array
        {
            data = ConfigManager.getConfObject("cfg_anicollision", name);
            return GameAnimation.createFrames(_ani.loadImages(aniUrls(data.anilength)), null);
        }

        private function aniUrls(length:int):Array
        {
            var urls:Array = [];
            for (var i:int = 1; i <= length; i++)
            {
                //动画资源路径要和动画图集打包前的资源命名对应起来
                urls.push(data.aniPath + i + ".png")
            }
            return urls;
        }

        private function get Res():Array
        {
            var arr:Array = [];
            return null;
        }

    }
}
