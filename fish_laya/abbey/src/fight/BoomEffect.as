package fight
{

    import laya.display.Sprite;
    import laya.maths.Point;

    import manager.ConfigManager;
    import manager.GameTools;
    import manager.SpineTemplet;

    public class BoomEffect
    {
        private var _startSprite:Sprite;
        private var _endAni:SpineTemplet;
        private var _startEnd:Boolean = false;
        private var _runTime:Number = 0;
        private var _deltaX:Number = 0;
        private var _deltaY:Number = 0;
        private var _speed:Number = 1000;
        private var _angle:Number = 0;
        private static var _cacheArray:Array = null;
        private static var _cacheObject:Object = null;

        public function BoomEffect(skillId:int, aniName:String, startPos:Point, endPos:Point, startParent:Sprite, endParent:Sprite)
        {
            _startSprite = new Sprite();
            startParent.addChild(_startSprite);
            _endAni = new SpineTemplet(aniName);
            endParent.addChild(_endAni);
            _endAni.visible = false;
        }

        public static function create(skillId:int, aniName:String, startPos, endPos, startParent:Sprite, endParent:Sprite):BoomEffect
        {
            if (!_cacheArray)
            {
                _cacheArray = [];
            }
            if (!_cacheObject)
            {
                _cacheObject = new Object();
            }
            var ret:BoomEffect;
            if (_cacheArray.length > 0)
            {
                ret = _cacheArray[0] as BoomEffect;
                _cacheArray.splice(0, 1);
            }
            else
            {
                ret = new BoomEffect(skillId, aniName, startPos, endPos, startParent, endParent);
            }
            ret.init(skillId, startPos, endPos, startParent, endParent);
            return ret;
        }

        public function destroy():void
        {
            _startSprite.visible = false;
            _endAni.visible = false;
			_endAni.stop();
            _cacheArray.push(this);
        }

        public function getRunTime():Number
        {
            return _runTime;
        }

        public function getAngle():Number
        {
            return _angle;
        }

        public function init(skillId:int, startPos, endPos, startParent:Sprite, endParent:Sprite):void
        {
            var len:Number = GameTools.CalPointLen(startPos, endPos);
            _runTime = len / _speed;
            _angle = GameTools.CalLineAngle(startPos, endPos)
            _startSprite.rotation = GameTools.CalLineAngle(startPos, endPos) + 90;
            _startSprite.pivotX = 42;
            _startSprite.pivotY = 42;
            _startSprite.pos(startPos.x, startPos.y);
            _startSprite.loadImage(ConfigManager.getConfValue("cfg_skill", skillId, "show") as String);
            _startSprite.visible = true;
            _endAni.pos(endPos.x, endPos.y);
            _endAni.stop();
            _endAni.visible = false;
            var radian:Number = _angle * Math.PI / 180;
            _deltaX = Math.cos(radian);
            _deltaY = Math.sin(radian);
        }

        public function isValid():Boolean
        {
            return !_endAni.visible || _endAni.isPlaying();
        }

        public function update(delta:Number):void
        {
            if (_runTime > 0)
            {
                _runTime -= delta;
                _startSprite.x = _startSprite.x + delta * _deltaX * _speed;
                _startSprite.y = _startSprite.y + delta * _deltaY * _speed;
                if (_runTime <= 0)
                {
                    _startSprite.visible = false;
                    _endAni.visible = true;
                    _endAni.play(0, false);
                }
            }
            else
            {

            }
        }

    }
}
