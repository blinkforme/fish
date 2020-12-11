package model
{


    import laya.net.Loader;


    public class LoginM
    {
        private static var _instance:LoginM;


        private var _resArr:Array;
        private var _loginState:Number;

        private var _spineArr:Array;

        private var _sceneId:Number;
        private var _contestId:int;
        private var _roomId:int = -1;
        private var _pageId:String;
        private var _IsfirstEntryGame:Boolean = true;
        private var _preLoadFishIds:Array = null;
        private var _preLoadBullet:Boolean = false;

        //是否完成身份认证
        private var _isCompleteCertification:Number = 0;
        private var _popupCertificationTimes:Number = 0;
        private var _isNovicePlayer:Number = 1//1是新手玩家  0不是新手玩家
        private var _replaceRankName:String = "***"//1是新手玩家  0不是新手玩家

        public function LoginM()
        {
            _preLoadFishIds = [];
        }

        public function setFishIdPreload(fishId:int):void
        {
            _preLoadFishIds[fishId] = 1;
        }

        public function isFishIdPreload(fishId:int):Boolean
        {
            if (_preLoadFishIds[fishId])
            {
                return true;
            }
            return false;
        }

        public function setBulletPreload():void
        {
            _preLoadBullet = true;
        }

        public function isBulletPreload():Boolean
        {
            return _preLoadBullet;
        }

        public static function get instance():LoginM
        {
            return _instance || (_instance = new LoginM());
        }

        public function get IsfirstEntryGame():Boolean
        {
            return _IsfirstEntryGame
        }

        public function set IsfirstEntryGame(isFirst:Boolean):void
        {
            _IsfirstEntryGame = isFirst;
        }

        public function get pageId():String
        {
            return _pageId;
        }

        public function set pageId(id:String):void
        {
            _pageId = id;
        }

        public function getMapUrl(url:String):String
        {
            var dic:Object = Laya.loader.getRes("manifest.json");

            if (dic[url])
            {
                return dic[url];
            }
            return url;
        }


        public function get sceneId():Number
        {
            return _sceneId;
        }

        public function set sceneId(id:Number):void
        {
            _contestId = 0;
            _sceneId = id;
            _roomId = -1;
        }

        public function getContestId():Number
        {
            return _contestId;
        }

        public function setContestId(contestId:Number, sceneId:Number):void
        {
            _contestId = contestId;
            _sceneId = sceneId;
        }

        public function set resArr(res:Array):void
        {
            _resArr = res;
        }

        public function get resArr():Array
        {
            return _resArr;
        }

        public function set loginState(state:Number):void
        {
            _loginState = state;
        }

        public function get loginState():Number
        {
            return _loginState;
        }

        public function get spineArr():Array
        {
            return _spineArr
        }

        public function set spineArr(arr:Array):void
        {
            _spineArr = arr;
        }


        public function get roomId():int
        {
            return _roomId;
        }

        public function set roomId(value:int):void
        {
            _roomId = value;
        }

        public function get isCompleteCertification():Number
        {
            return _isCompleteCertification;
        }

        public function set isCompleteCertification(value:Number):void
        {
            _isCompleteCertification = value;
        }

        public function get popupCertificationTimes():Number
        {
            return _popupCertificationTimes;
        }

        public function set popupCertificationTimes(value:Number):void
        {
            _popupCertificationTimes = value;
        }

        public function get isNovicePlayer():Number
        {
            return _isNovicePlayer;
        }

        public function set isNovicePlayer(value:Number):void
        {
            _isNovicePlayer = value;
        }

        public function get replaceRankName():String
        {
            return _replaceRankName;
        }
    }
}
