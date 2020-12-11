package fight
{

    import laya.display.Sprite;
    import laya.maths.Point;
    import laya.ui.FontClip;

    import manager.ConfigManager;
    import manager.GameSoundManager;

    public class AwardEffect
    {
        private static var awardNumActionY:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -6, -11, -18, -24, -30, -36, -42, -48, -54];
        private static var awardNumActiconScale:Array = [0.5, 0.7, 0.9, 1.1, 1.3, 1.5, 1.4, 1.3, 1.2, 1.1, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
        private static var awardNumActiconAlpha:Array = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 229 / 255, 204 / 255, 178 / 255, 153 / 255, 127 / 255, 102 / 255, 76 / 255, 51 / 255, 25 / 255];
        private var numFont:FontClip;
        private var originX:Number;
        private var originY:Number;
        private var numActionIndex:Number;
        private var _delay:Number;
        private var _delayIndex:int = 0;
        private static var _cacheArray:Array = null;
        private static var _cacheObject:Object = null;

        public static function create(value:int, pos:Point, own:Boolean, parent:Sprite, delay:Number, preLoad:Boolean = false):AwardEffect
        {
            if (!_cacheArray)
            {
                _cacheArray = [];
            }
            if (!_cacheObject)
            {
                _cacheObject = new Object();
            }
            var ret:AwardEffect;
            if (!preLoad && _cacheArray.length > 0)
            {
                ret = _cacheArray[0] as AwardEffect;
                ret.init(value, pos, own, parent, delay);
                _cacheArray.splice(0, 1);
            }
            else
            {
                ret = new AwardEffect(value, pos, own, parent, delay);
            }
            if (own)
            {
                var soundPath:String = ConfigManager.getConfValue("cfg_global", 1, "get_coin_sound") as String;
                GameSoundManager.playSound(soundPath);
            }
            return ret;
        }

        public function destroy():void
        {
            //			if(numFont)
            //			{
            //				numFont.removeSelf();
            //				numFont = null;
            //			}
            numFont.visible = false;
            _cacheArray.push(this);
        }

        public function init(value:int, pos:Point, own:Boolean, parent:Sprite, delay:Number):void
        {
            var fontStr:String = "font/font_1.png";
            if (!own)
            {
                fontStr = "font/font_2.png";
            }

            if (!numFont)
            {
                numFont = new FontClip(fontStr, "/.+-0123456789枚万亿");
                parent.addChild(numFont);
            }
            numFont.skin = fontStr;

            _delay = delay;
            _delayIndex = 0;
            numFont.value = "+" + value;
            originX = pos.x;
            originY = pos.y;
            if (originX < 40)
            {
                originX = 40;
            }
            if (originX > Laya.stage.width - 40)
            {
                originX = Laya.stage.width - 40;
            }
            if (originY < 50)
            {
                originY = 50;
            }
            if (originY > Laya.stage.height - 10)
            {
                originY = Laya.stage.height - 10;
            }
            numActionIndex = 0;
            numFont.pos(originX, originY);
            numFont.anchorX = 0.5;
            numFont.anchorY = 0.5;
            numFont.visible = _delay <= 0;
            updateNumberPos();
        }

        public function AwardEffect(value:int, pos:Point, own:Boolean, parent:Sprite, delay:Number)
        {
            init(value, pos, own, parent, delay);
        }

        private function updateNumberPos():void
        {
            if (numFont && (numActionIndex < awardNumActionY.length))
            {
                numFont.pos(originX, originY + awardNumActionY[numActionIndex]);
                numFont.scale(awardNumActiconScale[numActionIndex], awardNumActiconScale[numActionIndex]);
                numFont.alpha = awardNumActiconAlpha[numActionIndex];
            }
        }

        public function isValid():Boolean
        {
            return numActionIndex < awardNumActionY.length;
        }

        public function update(delta:Number):void
        {
            if (_delay > 0)
            {
                _delay -= delta;
                if (_delay <= 0)
                {
                    numFont.visible = true;
                }
                return;
            }
            _delayIndex += 1;
            if (_delayIndex >= 3)
            {
                numActionIndex += 1;
                _delayIndex = 0;
            }
            updateNumberPos();
        }

    }
}
