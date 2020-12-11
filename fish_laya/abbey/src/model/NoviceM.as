package model
{
    public class NoviceM
    {
        private static var _instance:NoviceM;

        private  var curData:Object

        public function NoviceM()
        {

        }

        public static function get instance():NoviceM
        {
            return _instance || (_instance = new NoviceM());
        }
    }
}
