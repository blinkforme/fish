package manager
{
    import laya.events.Event;
    import laya.utils.Browser;

    public class ScreenAdaptManager
    {
        public var width:int = 0;
        public var height:int = 0;

        private static var _instance:ScreenAdaptManager;

        public var minWidth:int = 1220;
        public var maxWidth:int = 1800;
        public var minHeight:int = 720;
        public var maxHeight:int = 1120;
        public var maxRate:Number = maxWidth / minHeight;
        public var minRate:Number = minWidth / maxHeight;
        private var useClientHeight:int = 0;
        private var useClientWidth:int = 0;
        private var useBrowserWidth:int = 0;
        private var useBrowserHeight:int = 0;
        public var notch:String = "left";

        public function ScreenAdaptManager()
        {


        }

        private var screenRotation:Boolean = null;

        private function update():void
        {
            //bodyWidth = Browser.clientHeight;
            //bodyHeight = Browser.clientWidth;

            if (screenRotation == null || screenRotation != Laya.stage.canvasRotation)
            {
                screenRotation = Laya.stage.canvasRotation;
            }

            if (useBrowserWidth != Browser.clientWidth || useBrowserHeight != Browser.clientHeight || (notch != GameTools.notch() && "normal" != GameTools.notch()))// || notch !=  __JS__("notch()"))
            {
                //计算适配的设计宽高
                var browserRate:Number = Browser.clientWidth / Browser.clientHeight;
                if (Browser.clientWidth < Browser.clientHeight)
                {
                    browserRate = Browser.clientHeight / Browser.clientWidth;
                }
                useBrowserWidth = Browser.clientWidth;
                useBrowserHeight = Browser.clientHeight;
                if ("normal" != GameTools.notch())
                {
                    notch = GameTools.notch();//__JS__("notch()")
                }
                if (browserRate >= minRate && browserRate <= maxRate)
                {
                    var i:int = minHeight;
                    var preI:int = 0;
                    var iminRate:Number = 0;
                    var imaxRate:Number = 0;
                    var imaxHeight:int = maxHeight;
                    var findRate:Boolean = false;
                    //计算最小i
                    i = Math.ceil(minWidth / browserRate);
                    if (i < minHeight)
                    {
                        i = minHeight;
                    }
                    while (i <= imaxHeight)
                    {
                        iminRate = minWidth / i;
                        imaxRate = maxWidth / i;
                        if (imaxRate >= browserRate && iminRate <= browserRate)
                        {
                            //找到合适的分辨率

                            findRate = true;
                            useClientHeight = i;
                            useClientWidth = Math.floor(i * browserRate);
                            //trace("find height = " + useClientHeight + " width = " + useClientWidth);
                            break;
                        }
                        else
                        {
                            preI = i;
                            i = Math.floor((i + imaxHeight) / 2);
                            if ((minWidth / i) > browserRate)
                            {
                                imaxHeight = i;
                                i = preI + 1;
                            }
                            else
                            {
                                if (i <= preI)
                                {
                                    i = preI + 1;
                                }
                            }
                        }
                    }
                    if (!findRate)
                    {
                        useClientWidth = Math.floor(i * browserRate);
                        useClientHeight = i;
                    }
                }
                else if (browserRate > minRate)
                {
                    useClientHeight = minHeight;
                    useClientWidth = maxWidth;
                }
                else
                {
                    useClientHeight = maxHeight;
                    useClientWidth = minWidth;
                }
                //开始调整屏幕适配
                Laya.stage.width = useClientWidth;
                Laya.stage.height = useClientHeight;
                GameTools.screenResize();
                //trace("width = " + useClientWidth + " height = " + useClientHeight + " bwidth = " + Browser.clientWidth + " bHeight = " + Browser.clientHeight);
                GameEventDispatch.instance.event(GameEvent.ScreenResize, null);
            }
        }

        public function init():void
        {
            update();
            Laya.stage.on(Event.RESIZE,this,this.update)
        }


        public static function get instance():ScreenAdaptManager
        {
            return _instance || (_instance = new ScreenAdaptManager());
        }

    }
}
