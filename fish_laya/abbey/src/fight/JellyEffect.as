package fight
{
    import laya.display.Animation;
    import laya.display.Sprite;
    
    import manager.AnimalManger;
    import manager.ConfigManager;
    import manager.FishAniManager;
    import manager.GameAnimation;

    public class JellyEffect
    {
        private var _parent:Sprite;
        private var _aniArray:Array;
        private var _bornTimeLeft:Number;
        private var _moveUpSpeed:Number = 20;
		private static var _cacheArray:Array = [];
        public function JellyEffect(parent:Sprite)
        {
            _parent = parent;
            _aniArray = [];
        }

        public function hide():void
        {
            for (var i:int = 0; i < _aniArray.length; i++)
            {
                var ani:Animation = _aniArray[i] as Animation;
//                ani.removeSelf();
				ani.visible = false;
				_cacheArray.push(ani);
            }
            _aniArray.length = 0;;
        }

        public function reset():void
        {
            _bornTimeLeft = 0;
        }

        //指定范围的随机数
        private function get randRange():Number
        {
            return Math.random() * 0.1 + 0.6
        }

		private var _removeArray:Array = [];
        public function update(delta:Number):void
        {
            var ani:GameAnimation;
            if (_bornTimeLeft >= 0)
            {
                _bornTimeLeft -= delta;
                if (_bornTimeLeft <= 0)
                {
                    var scaleNum:Number = randRange;
                    var aniName:String = "shuimu";
					if(_cacheArray.length <= 0)
					{
                    	ani = FishAniManager.instance.load(aniName);
						//ani.outLoop = true;
                    	ani.pivot(ConfigManager.getConfValue("cfg_anicollision", aniName, "pivotX") as int,
                            ConfigManager.getConfValue("cfg_anicollision", aniName, "pivotY") as int);
					}
					else
					{
						ani = _cacheArray.pop() as GameAnimation;
					}
					ani.visible = true;
                    ani.play(0, true);
                    ani.y = 720;
                    ani.x = 10 + 1260 * Math.random();
                    ani.scaleX = scaleNum;
                    ani.scaleY = scaleNum;
                    //ani.alpha = scaleNum;
                    _bornTimeLeft = 4;
                    _parent.addChild(ani);
                    _aniArray.push(ani);
                }
            }
            var i:int = 0;
            for (i = 0; i < _aniArray.length; i++)
            {
                ani = _aniArray[i] as GameAnimation;
                ani.x = ani.x - delta * 4;
                ani.y = ani.y - delta * 16;
				//ani.outFrameLoop(delta);
            }

            //var invalidAni:Array = [];
			_removeArray.length = 0;
            for (i = 0; i < _aniArray.length; i++)
            {
                ani = _aniArray[i] as GameAnimation;
                if (ani.x < -100 || ani.y < -100)
                {
					_removeArray.push(ani);
                }
            }
            var count:int = _removeArray.length;
            for (var j:int = 0; j < count; j++)
            {
                ani = _removeArray[j] as GameAnimation;
                for (var k:int = 0; k < _aniArray.length; k++)
                {
                    if (_aniArray[k] === ani)
                    {
                        _aniArray.splice(k, 1);
                        break;
                    }
                }
				_cacheArray.push(ani);
                //ani.removeSelf();
            }

        }

    }
}
