package view.feedBack
{
    import control.WxC;

    import engine.tool.StartParam;

    import manager.GameConst;

    import model.LoginInfoM;

    import laya.events.Event;
    import laya.utils.Handler;

    import manager.ApiManager;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;

    import ui.abbey.FeedBackPageUI;

    public class FeedBackPage extends FeedBackPageUI implements ResVo
    {
        private var _content:String;

        public function FeedBackPage()
        {
            super();
        }

        public function StartGames(parm:Object = null):void
        {

            feedBtn.on(Event.CLICK, this, clickFeed);
            quitBtn.on(Event.CLICK, this, clickQuit);
            screenResize();
            if(ENV.isShowBannerAndAD()&& WxC.compareVersion(WxC.wxSDKVersion, GameConst.wxSDKVersion) >= 0){
                feedBox.centerY= -100
            }else {
                feedBox.centerY= 0
            }
        }

        private function clickQuit():void
        {
            UiManager.instance.closePanel("FeedBack", false);


        }

        private function clickFeed():void
        {
            _content = feedInput.text;
            if (_content.length == 0)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "反馈内容不能为空");
            } else
            {
                ApiManager.instance.getFeedBack(StartParam.instance.getParam("access_token"), _content, Handler.create(this, feedComplete), null);
            }

        }

        private function feedComplete(msg:Object):void
        {
            if (msg["code"] == "success")
            {
                UiManager.instance.closePanel("FeedBack", false);
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "反馈成功");

            }

        }

        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
        }

        private function screenResize():void
        {
            bmask.width = Laya.stage.width
            bmask.height = Laya.stage.height
            this.size(Laya.stage.width, Laya.stage.height);

        }

        public function unRegister():void
        {
            feedInput.text = "";
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
        }
    }
}
