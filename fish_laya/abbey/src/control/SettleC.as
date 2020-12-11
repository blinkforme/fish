package control
{
    public class SettleC
    {
        private static var _instance:SettleC;

        public function SettleC()
        {

        }

        public static function get instance():SettleC
        {
            return _instance || (_instance = new SettleC());
        }
    }
}
