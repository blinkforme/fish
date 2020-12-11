package fight
{

    import laya.display.Sprite;

    public class FullScreenCoinEffect
    {

//        public static var cache_arr:Array = [];
		private static var _cache_obj:Array = []; 
		private static var _update_obj:Array = [];
        public var eff_arr:Array = [];
        public var cur_time:Number = 0;

        public var is_play:Boolean = false;

        public function FullScreenCoinEffect()
        {
        }

		public static function create(preLoad:Boolean = false):FullScreenCoinEffect
		{
			var ret:FullScreenCoinEffect = null;
			if (!preLoad && _cache_obj.length > 0)
			{
				ret = _cache_obj[0] as FullScreenCoinEffect;
				_cache_obj.splice(0, 1);
			}
			else
			{
				ret = new FullScreenCoinEffect();
			}
			
			return ret;
		}

        public static function random(num)
        {
            return Math.floor(Math.random() * num)
        }

        public static function random_pn()
        {
            return Math.random() > 0.5 ? 1 : -1
        }

        public function loop():void
        {
			var isEnd:Boolean = true;
            cur_time += Laya.timer.delta;
            for (var i:int = 0; i < eff_arr.length; i++)
            {
                var effect:FullScreenCoinEffectSingle = eff_arr[i];
				if(!effect.is_end)
				{
                	effect.update(cur_time);
				}
				if(!effect.is_end)
				{
					isEnd = false;
				}
//                if (effect.is_end)
//                {
//                    eff_arr.splice(i, 1);
//                    cache_arr.push(effect)
//                }
//				else
//				{
//					isEnd = false;
//				}
            }
			if(isEnd)
			{
				_cache_obj.push(this);
				Laya.timer.clear(this, loop);
			}
        }
		
		public function stop():void
		{
			for (var i:int = 0; i < eff_arr.length; i++)
			{
				var effect:FullScreenCoinEffectSingle = eff_arr[i];
				effect.clear();
			}
			_cache_obj.push(this);
			Laya.timer.clear(this, loop);
		}
		
        private function getObject(startX:Number, startY:Number, endX:Number, endY:Number, scaleX:Number, scaleY:Number,
                                   skewX:Number, skewY:Number,
                                   delay:Number, parent:Sprite):FullScreenCoinEffectSingle
        {
//            if (cache_arr.length > 0)
//            {
//                var eff:FullScreenCoinEffectSingle = cache_arr[0]
//				cache_arr.splice(0, 1);
////                cache_arr.unshift()
//                eff.init(startX, startY, endX, endY, scaleX, scaleY, skewX, skewY, delay, parent)
//                return eff;
//            } else
//            {
                return FullScreenCoinEffectSingle.getInstance(startX, startY, endX, endY, scaleX, scaleY, skewX, skewY, delay, parent)
//            }
        }
		
		private var _scaleXs:Array = [1.2, 1.5, 1.3, 1.5, 1.3, 0.8, 1.1];
		private var _points:Array = [0, 0, 0, 0, 0, 0]
        public function play(parent:Sprite):void
        {
            cur_time = 0;
			//is_play = true;
            var scaleXs:Array = [1.2, 1.5, 1.3, 1.5, 1.3, 0.8, 1.1]

            var points:Array = [250, Laya.stage.width / 2, Laya.stage.width - 220,
                Laya.stage.height / 2, Laya.stage.height / 2, Laya.stage.height / 2];
			var tmpIndex:Number = 0;
            for (var j:Number = 0; j < 3; j++)
            {
                var x:Number = points[j]
                var y:Number = points[j + 3]


                for (var i:Number = 0; i < 60; i++)
                {
                    var sx:Number = x + random(50) * random_pn();
                    var ex:Number = Math.random() * Laya.stage.width


                    var sy:Number = y + random(50) * random_pn();
                    var ey:Number = Math.random() * Laya.stage.height

                    var scx:Number = scaleXs[random(scaleXs.length)]
                    var scy:Number = scx
                    var skx:Number = Math.random() * 180
                    var sky:Number = -skx
					if(eff_arr[tmpIndex])
					{
						eff_arr[tmpIndex].init(sx,sy,ex,ey,scx,scy,skx,sky,1,parent);
					}
					else
					{
						var eff:FullScreenCoinEffectSingle = getObject(sx, sy, ex, ey, scx, scy, skx, sky, 1, parent);
						eff_arr.push(eff);
					}
					tmpIndex++;
                    
                }
            }

            
            Laya.timer.frameLoop(1, this, loop);

        }

    }
}
