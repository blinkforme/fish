package manager
{
    public class LogManager
    {
        public function LogManager()
        {
        }

        public static function Log(msg:String):void
        {
            if (GameConst.LOG_VISIBLE)
            {
                //trace(msg);
            }
        }
    }
}
