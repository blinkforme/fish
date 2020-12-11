package model
{

    public class SettingM
    {

        private var _sound:int;//声音
        private var _music:int;//音效
        private var _animation:int;//特效  0--开启 1--关闭


        private static var _instance:SettingM;

        public function SettingM()
        {
            _sound = 100;
            _music = 100;
            _animation = 0;
        }

        public static function get instance():SettingM
        {
            return _instance || (_instance = new SettingM());
        }


        public function get sound():int
        {
            return _sound;
        }

        public function set sound(value:int):void
        {
            _sound = value;
        }

        public function get music():int
        {
            return _music;
        }

        public function set music(value:int):void
        {
            _music = value;
        }

        public function get animation():int
        {
            return _animation;
        }

        public function set animation(value:int):void
        {
            _animation = value;
        }
    }
}
