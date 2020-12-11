package view.fish
{

    public class GoodsFlyManager
    {
        private static var _instance:GoodsFlyManager;
        private var _flyEffectArray:Array;

        public function GoodsFlyManager()
        {
            _flyEffectArray = [];
            Laya.timer.frameLoop(1, this, loop);
        }

        public static function get instance():GoodsFlyManager
        {
            return _instance || (_instance = new GoodsFlyManager());
        }

        public function removeInvalidEffect(removeAll:Boolean = false):void
        {
            var invalidEffect:Array = [];
            for (var i:int = 0; i < _flyEffectArray.length; i++)
            {
                var flyEffect:GoodsFlyEffect = _flyEffectArray[i] as GoodsFlyEffect;
                if (flyEffect.isEnd() || removeAll)
                {
                    invalidEffect.push(flyEffect);
                }
            }
            var count:int = invalidEffect.length;
            for (var j:int = 0; j < count; j++)
            {
                var removeEffect:GoodsFlyEffect = invalidEffect[j] as GoodsFlyEffect;
                removeEffect.destroy();
                for (var k:int = 0; k < _flyEffectArray.length; k++)
                {
                    if (_flyEffectArray[k] === removeEffect)
                    {
                        _flyEffectArray.splice(k, 1);
                        break;
                    }
                }
            }
        }

        private function loop():void
        {
            var delta:Number = Laya.timer.delta / 1000;
            var flyEffect:GoodsFlyEffect;
            for (var i:int = 0; i < _flyEffectArray.length; i++)
            {
                flyEffect = _flyEffectArray[i];
                flyEffect.update(delta);
            }
            if (_flyEffectArray.length > 0)
            {
                removeInvalidEffect();
            }
        }

        public function addFlyEffect(effect:GoodsFlyEffect):void
        {
            _flyEffectArray.push(effect);
        }

    }
}
