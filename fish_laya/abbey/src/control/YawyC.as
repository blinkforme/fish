package control
{
    public class YawyC
    {


        public function YawyC()
        {

        }

        public static function pay(data:*):void
        {
            var win:* = __JS__("window")
            win.yawysdk.pay(data)
        }
    }
}
