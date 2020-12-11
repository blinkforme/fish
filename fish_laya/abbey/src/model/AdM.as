package model
{

    public class AdM
    {
        private static var _instance:AdM;

        private var _watch_times
        private var _total_times
        private var _bannerHeight;
        public static function get instance():AdM
        {
            return _instance || (_instance = new AdM());
        }

        public function AdM()
        {

        }


        public function get bannerHeight():*
        {
            return _bannerHeight;
        }

        public function set bannerHeight(value):void
        {
            _bannerHeight = value;
        }

        public function get watch_times():*
        {
            return _watch_times;
        }

        public function set watch_times(value):void
        {
            _watch_times = value;
        }

        public function get total_times():*
        {
            return _total_times;
        }

        public function set total_times(value):void
        {
            _total_times = value;
        }
    }

}