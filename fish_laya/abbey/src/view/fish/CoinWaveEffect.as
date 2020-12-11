package view.fish
{
    import laya.display.Sprite;
    import laya.utils.Handler;

    public class CoinWaveEffect
    {
        private static var _instance:CoinWaveEffect;
        private var _target:Sprite;
        private var _scaleX:Number;
        private var _scaleY:Number;
        private var _isAdd:Boolean = true;

        public function CoinWaveEffect()
        {

        }

        public static function get instance():CoinWaveEffect
        {
            return _instance || (_instance = new CoinWaveEffect());
        }

        //飘字特效
        public function cainWaveEffect(target:*, complete:Handler):void
        {


            Laya.timer.frameLoop(1, this, start);
        }

        private function start():void
        {


        }


    }
}
