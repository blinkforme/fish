package model
{
    import conf.cfg_fish;
    import conf.cfg_scene;

    public class FishTypeM
    {
        private static var _instance:FishTypeM;
        private var _infoList:Array;
        private var sceneId:int;
        private var aniNames:Array = [
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9",
            "10",
            "11",
            "12",
            "13",
            "14",
            "15",
            "201",
            "202"
        ];

        public function FishTypeM()
        {

        }

        public static function get instance():FishTypeM
        {
            return _instance || (_instance = new FishTypeM());
        }

        public function setInfo():void
        {
            //			_infoList = [];
            //			for(var i:int=0;i<aniNames.length;i++)
            //			{
            //				var fishData:Object = ConfigManager.getConfObject("cfg_fish",aniNames[i]);
            //				_infoList.push({txt:{value:fishData.coin_rate},image:{skin:fishData.Imageurl}});
            //			}
            sceneId = 1;
        }


        //展现大鱼列表
        public function get showSmallFish():Array
        {
            var smallArr:Array = [];
            for (var i:int = 0; i < smallFishArr.length; i++)
            {
                var fishData:cfg_fish = cfg_fish.instance(smallFishArr[i]);
                if (fishData.fishType == 1)
                {
                    smallArr.push({
                        txt: {text: fishData.coin_rate},
                        image: {skin: fishData.Imageurl},
                        bei: {skin: "ui/fishType/bei.png"}
                    });
                } else if (fishData.fishType == 0)
                {
                    smallArr.push({
                        txt: {text: fishData.coin_rate},
                        image: {skin: fishData.Imageurl},
                        bei: {skin: "ui/fishType/jinbian.png"}
                    });
                } else
                {
                    smallArr.push({
                        txt: {text: fishData.coin_rate},
                        image: {skin: fishData.Imageurl},
                        bei: {skin: "ui/fishType/boos.png"}
                    });
                }
            }
            return smallArr;
        }

        //展现小鱼列表
        public function get showBigFish():Array
        {
            var bigArr:Array = [];
            for (var i:int = 0; i < bigFishIdArr.length; i++)
            {
                var fishData:cfg_fish = cfg_fish.instance(bigFishIdArr[i]);
                if (fishData.fishType == 0)
                {
                    bigArr.push({
                        image: {skin: fishData.Imageurl},
                        name: {text: fishData.fishname},
                        beishu: {text: fishData.coin_rate},
                        bei: {skin: "ui/fishType/jinbian.png"}
                    });
                } else if (fishData.fishType == 1)
                {
                    bigArr.push({
                        image: {skin: fishData.Imageurl},
                        name: {text: fishData.fishname},
                        beishu: {text: fishData.coin_rate},
                        bei: {skin: "ui/fishType/bei.png"}
                    });
                } else
                {
                    bigArr.push({
                        image: {skin: fishData.Imageurl},
                        name: {text: fishData.fishname},
                        beishu: {text: fishData.coin_rate},
                        bei: {skin: "ui/fishType/boos.png"}
                    });
                }
            }
            return bigArr;
        }

        //大鱼的列表
        public function get bigFishIdArr():Array
        {
            var scene_id = FightM.instance.sceneId;
            var cfg:cfg_scene = cfg_scene.instance(scene_id + "");
            return cfg.bigfish_arr;
        }

        public function get smallFishArr():Array
        {
            var scene_id = FightM.instance.sceneId;
            var cfg:cfg_scene = cfg_scene.instance(scene_id + "");
            return cfg.smallfish_arr;
        }


        public function get infoList():Array
        {
            return _infoList;
        }
    }
}
