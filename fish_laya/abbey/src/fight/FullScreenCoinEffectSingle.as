package fight
{
    import laya.display.Sprite;
    import laya.utils.Ease;

    import manager.ConfigManager;
    import manager.FishAniManager;
    import manager.GameAnimation;
    import manager.GameConst;

    public class FullScreenCoinEffectSingle
    {
        public var startX:Number;
        public var startY:Number;
        public var endX:Number;
        public var endY:Number;
        public var delay:Number;
        public var parent:Sprite;
        public var ani:GameAnimation = null;
        public var ani_play_time:Number;

        public static var play_time:Number = 1000;
        public static var play_time_offset:Number = 2500;
        public var is_end:Boolean = false;

        private var maxNumber:Number = 12;
        private var minNumber:Number = 6;
        private var _c:Number;

        public function FullScreenCoinEffectSingle(startX:Number, startY:Number, endX:Number, endY:Number, scaleX:Number, scaleY:Number,
                                                   skewX:Number, skewY:Number,
                                                   delay:Number, parent:Sprite)
        {

            this.init(startX, startY, endX, endY, scaleX, scaleY, skewX, skewY, delay, parent)
        }

        public function init(startX:Number, startY:Number, endX:Number, endY:Number, scaleX:Number, scaleY:Number,
                             skewX:Number, skewY:Number,
                             delay:Number, parent:Sprite):void
        {

            this.startX = startX
            this.startY = startY
            this.endX = endX;
            this.endY = endY;
            this.delay = delay;
            this.parent = parent;
            this.ani_play_time = play_time + random(play_time_offset);
            _c = (Math.random() * (maxNumber - minNumber) + minNumber) / 10;
			if(!ani)
			{
            	ani = FishAniManager.instance.load("coin1") as GameAnimation;
				//ani.outLoop = true;
				ani.pivot(ConfigManager.getConfValue("cfg_anicollision", "coin", "pivotX") as Number,
					ConfigManager.getConfValue("cfg_anicollision", "coin", "pivotY") as Number);
			}
            ani.x = startX;
            ani.y = startY;
            ani.scaleX = scaleX;
            ani.scaleY = scaleY;
            ani.skewX = skewX;
            ani.skewY = skewY;
			
			ani.visible = true;
			is_end = false;
            ani.play(0, true);
            
            parent.addChild(ani);
        }

        public static function getInstance(startX:Number, startY:Number, endX:Number, endY:Number, scaleX:Number, scaleY:Number,
                                           skewX:Number, skewY:Number,
                                           delay:Number, parent:Sprite):FullScreenCoinEffectSingle
        {
            return new FullScreenCoinEffectSingle(startX, startY, endX, endY, scaleX, scaleY, skewX, skewY, delay, parent)
        }

        public static function random(num)
        {
            return Math.floor(Math.random() * num)
        }


        public function clear():void
        {
			ani.alpha = 1;
			ani.interval = 60;
			ani.visible = false;
			if(GameConst.unused_remove_self)
			{
				ani.removeSelf();
			}
			ani.stop();
			is_end = true;
        }

        public function update(cur_time:Number):void
        {

            var distance_percent:Number = Ease.strongOut(cur_time, 0, _c, ani_play_time);//(cur_time / ani_play_time) * (1 - Math.log(cur_time / ani_play_time));
            ani.x = startX + (endX - startX) * distance_percent
            ani.y = startY + (endY - startY) * distance_percent


            var speed:Number = -Math.log(cur_time / ani_play_time)
            ani.interval = (35 / speed) > 60 ? 60 : (35 / speed);

            ani.alpha = speed
			
            if (cur_time >= ani_play_time)
            {
				ani.alpha = 1;
				ani.interval = 60;
                ani.visible = false;
				if(GameConst.unused_remove_self)
				{
					ani.removeSelf();
				}
				ani.stop();
				is_end = true;
            }
			else
			{
				//ani.outFrameLoop(Laya.timer.delta);
			}
        }


    }
}
