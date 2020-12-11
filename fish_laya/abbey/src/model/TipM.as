package model
{
    public class TipM
    {
        private static var _instance:TipM;

        public function TipM()
        {
        }

        public static function get instance():TipM
        {
            return _instance || (_instance = new TipM());
        }

        public function getContent(id:int):void
        {

        }
    }
}
