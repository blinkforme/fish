package manager
{
    import laya.events.EventDispatcher;

    public class GameEventDispatch extends EventDispatcher
    {
        private static var _instance:EventDispatcher;

        public function GameEventDispatch()
        {
            super();
        }

        public static function get instance():EventDispatcher
        {
            return _instance || (_instance = new EventDispatcher());
        }

    }
}
