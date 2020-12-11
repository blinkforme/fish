package manager
{
    public class ShieldWordManager
    {
        private static var _instance:ShieldWordManager;
        private var senwords:Array

        public function ShieldWordManager()
        {
            init()
        }

        public static function get instance():ShieldWordManager
        {
            return _instance || (_instance = new ShieldWordManager());
        }
        private function init():void
        {
            senwords = ConfigManager.items("cfg_shieldWord")
        }

        public function filterInfo(text:String):String
        {
            if (senwords == null)
            {
                return text
            }

            for (var i = 0; i < senwords.length; i++)
            {
                var obj:Object = senwords[i];

                text = text.replace(obj.sensitiveword, "**");
            }
            return text
        }

        public function filterSpace(text:String):String
        {
            var index = text.indexOf(" ")
            var re1:RegExp = new RegExp(" ", "g")
            text = text.replace(re1, "")
            return text
        }

    }
}
