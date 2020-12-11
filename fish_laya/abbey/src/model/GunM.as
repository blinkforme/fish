package model
{
    import conf.cfg_battery;

    public class GunM
    {
        private static var _instance:GunM;

        public function GunM()
        {

        }

        public static function get instance():GunM
        {
            return _instance || (_instance = new GunM());
        }

        public function getNextPower(id:int):Number
        {
            var a:int = id + 1;
            var battery:cfg_battery = cfg_battery.instance(a + "");
            if (battery == null)
            {
                return -1;
            }
            return battery.comsume;
        }

        public function needDiamod(id:int):Number
        {
            var b:int = id + 1;
            var battery:cfg_battery = cfg_battery.instance(b + "");
            return battery.need_diamond;
        }

        public function giveCount(id:int):Number
        {
            var c:int = id + 1;
            var battery:cfg_battery = cfg_battery.instance(c + "");
            var arr:Array = battery.award;
            return arr[1];
        }
    }
}
