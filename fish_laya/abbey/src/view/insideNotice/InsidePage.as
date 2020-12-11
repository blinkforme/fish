package view.insideNotice
{
    import control.WxC;

    import engine.tool.StartParam;

    import laya.events.Event;
    import laya.utils.Handler;

    import manager.ApiManager;
    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;

    import ui.abbey.InsidePageUI;

    public class InsidePage extends InsidePageUI implements ResVo
    {
        private var _startX:Number = 0;
        private var _startY:Number = 0;
        private var a:String = "<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;欢迎来到集结号捕鱼H5</span><br/>&nbsp;<br/><br/>3月24日~3月28日，集结号捕鱼H5首次活动来袭！诚意满满，福利多多！让鱼雷疯狂起来，让金币爆起来~<br/>1.活动期间使用紫金鱼雷、黄金鱼雷和白银鱼雷获得的最高金币数量会变为相应积分进行排行，每个排行前10名的玩家，可以获得高额奖励，更可获得游戏中从未投放过的七彩鱼雷<br/>2.月卡用户，每日可额外领取一枚白银鱼雷<br/>3.在商城购买部分道具，可额外获得鱼雷补给<br/><span>集结号感谢所有玩家的支持和配合，祝您游戏愉快！如果在游戏中遇到任何问题，欢迎您咨询客服寻求帮助。请点击下方确定按钮开始游戏.</span><br/>&nbsp;<br/>客服电话:0579-82917777"

        public function InsidePage()
        {
            super();
        }


        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;


            if (!ENV.branchSwitch("notice"))
            {
                clickConfirm()
            }
            _startX = this.x;
            _startY = this.y;
            screenResize();
            insideBox.visible = false;
            masking.visible = false;
            confirmBtn.visible = false;
            contentPanel.vScrollBarSkin = "";
            content.autoSize = true;
            content.style.fontSize = 22;
            content.style.color = "#136673";
            content.style.width = 510;
            var server:String = getUrlParamValue("server");
            waitAni.visible = true;
            waitAni.play(0, true);
            confirmBtn.on(Event.CLICK, this, clickConfirm);
            masking.on(Event.CLICK, this, clickConfirm);
            ApiManager.instance.get_announce("inside", Handler.create(this, completeHandler), Handler.create(this, error), server);
        }

        private function clickConfirm():void
        {
            GameEventDispatch.instance.event(GameEvent.Regic);
            UiManager.instance.closePanel("InsideNotice", false);
        }

        private function getUrlParamValue(name:String):*
        {
            if (!WxC.isInMiniGame())
            {
                var url:String = __JS__("window.document.location.href.toString()");
                var u:* = url.split("?");
                if (u[1] is String)
                {
                    u = u[1].split("&");
                    var gets:Object = {};
                    for (var i:String in u)
                    {
                        var j:String = u[i].split("=");
                        gets[j[0]] = j[1];
                    }
                    return gets[name];
                }
            }
            return null
        }

        private function error(msg:Object):void
        {

            trace("请求失败");
        }

        private function completeHandler(msg:Object):void
        {

            var m:Array = msg.data.notice
            if (m != null)
            {
                if (m.length != 0)
                {
                    var n:Object = m[0];

                    n = m[0];
                    var con:String = n.content;
                    if (con.length > 0)
                    {
                        insideBox.visible = true;
                        masking.visible = true;
                        confirmBtn.visible = true;
                        content.innerHTML = con;
                        content.height = content.contextHeight;
                        contentPanel.removeChild(content);
                        contentPanel.addChild(content);
                    }else
                    {
                        clickConfirm()
                    }
                }else
                {
                    clickConfirm()
                }
                waitAni.visible = false;
            }else
            {
                clickConfirm()
            }
        }

        private function screenResize():void
        {
            var contentWidth:int = 600;//组件范围width
            var contentHeight:int = 448;//组件范围height
            var contentStartX:int = 320;//组件左边距
            var contentStartY:int = 148;//组件上边距
            var posXOff:Number = (Laya.stage.width - contentWidth) / 2;
            var posYOff:Number = (Laya.stage.height - contentHeight) / 2;
            this.pos(_startX + posXOff - contentStartX, _startY + posYOff - contentStartY);
            this.size(Laya.stage.width, Laya.stage.height);

            confirmBtn.left = contentStartX - posXOff;
            confirmBtn.top = contentStartY - posYOff;

        }

        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            if (ENV.isShowBannerAndAD())
            {
                if (WxC.isInMiniGame() && WxC.compareVersion(WxC.wxSDKVersion, GameConst.wxSDKVersion) >= 0)
                {
                    insideBox.y = 120
                    WxC.instance.showBannerAD()
                } else
                {
                    insideBox.y = 140
                }
            } else
            {
                insideBox.y = 140
            }
        }

        public function unRegister():void
        {
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            if (ENV.isShowBannerAndAD())
            {
                if (WxC.isInMiniGame())
                {

                    WxC.instance.hideBannerAD()
                }
            }
        }
    }
}
