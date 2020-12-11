package control
{
    import engine.tool.StartParam;

    import manager.GameConst;

    import model.RoleInfoM;

    import manager.GameTools;
    import manager.WebSocketManager;

    public class T360C
    {


        public function T360C()
        {

        }

        private static var buyer = null;

        public static function endGet360Info(user)
        {
            var qid = GameTools.getUrlParamValue('360_qid')
            if (user.nickname)
            {
                RoleInfoM.instance.setName(user.nickname)
            }
            if (user.img_url)
            {
                RoleInfoM.instance.avatar = user.img_url
            }
            WebSocketManager.instance.send(14060, {qid: qid, nickname: user.nickname, img_url: user.img_url})
        }

        public static function initNickname():void
        {
            var qid = GameTools.getUrlParamValue('360_qid')
            var win:* = __JS__("window")
            var H5_GAME_360:* = win.H5_GAME_360
            if (!buyer)
            {
                buyer = new H5_GAME_360();
            }
            var CONST = H5_GAME_360.CONST;
            buyer.emit(CONST.EVENT.USER.INFO, {qid: qid}, endGet360Info)
        }

        public static function pay(data:*):void
        {
            var win:* = __JS__("window")
            var H5_GAME_360:* = win.H5_GAME_360

            if (!buyer)
            {
                buyer = new H5_GAME_360();
            }

            var CONST = H5_GAME_360.CONST;
            buyer.emit(CONST.EVENT.BUY.START, data);
        }

        public static function is360Game():Boolean
        {
            if (StartParam.instance.getParam("platform") == GameConst.platform_360 || StartParam.instance.getParam("platform") == GameConst.platform_android_360)
            {
                return true;
            }
            return false;
        }
    }
}
