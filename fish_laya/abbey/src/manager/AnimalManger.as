package manager
{
    import laya.display.Animation;
    import laya.net.Loader;

    public class AnimalManger
    {
        private static var _instance:AnimalManger;
        private var animalName:String;
        private var _ani:Animation;
        private var data:Object;
        private var fishani:Animation;

        public function AnimalManger()
        {

        }

        public static function get instance():AnimalManger
        {
            return _instance || (_instance = new AnimalManger());
        }

        //通过动画的名字得到动画对应的类
        public function loadAnimation(name:String):Animation
        {
            _ani = new Animation();
            return _ani.loadAtlas("res/atlas/ani/" + name + ".atlas");
            Loader.getAtlas("res/atlas/ani/" + name + ".atlas");
        }


        public function load(name:String):Animation
        {
            data = ConfigManager.getConfObject("cfg_anicollision", name);
            _ani = new Animation();
            fishani = _ani.loadImages(aniUrls(data.anilength));
            fishani.interval = data.aniSpeed
            return fishani;
        }


        public function loadAni(name:String, pngName:String, length:int):Animation
        {
            _ani = new Animation();
            return _ani.loadImages(aniUrls(length));
        }

        public function loadAniFrames(name:String):Array
        {
            data = ConfigManager.getConfObject("cfg_anicollision", name);
            return Animation.createFrames(_ani.loadImages(aniUrls(data.anilength)), null);
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
