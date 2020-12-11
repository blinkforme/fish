package struct
{
    import laya.utils.Handler;

    import manager.GameConst;

    public class QuitTipInfo
    {
        public var content:String;
        public var confirmMsg:String;
        public var conFirmArgs:Object;

        public var commonMsg:String;
        public var commonArgs:Object;

        public var cancelMsg:String;
        public var state:int;
        public var autoCloseTime:int;

        public var closeCallback:Handler;

        public var cancelArgs:Object;
        public var confirmCallback:Handler;
        public var isHaveTime:Boolean = true;
        public var quitMsg:String;
        public var quitArgs:Object;

        public var confirmEvent:String;
        public var confirmEventArgs:Object;

        public var cancelEvent:String;
        public var cancelEventArgs:Object;
        public var cancelCallback:Handler;

        public var middleTxt:String = "确定"
        public var middileTxtColor:String = GameConst.font_green
        public var leftTxt:String = "取消"
        public var leftTxtColor:String = GameConst.font_green
        public var rightTxt:String = "确定"
        public var rightTxtColor:String = GameConst.font_red

    }
}
