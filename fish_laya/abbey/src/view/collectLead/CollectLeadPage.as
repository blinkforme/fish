package view.collectLead
{
    import engine.analysis.BuriedManager;
    import engine.analysis.BuriedTypes;

    import laya.events.Event;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;
    import manager.WebSocketManager;

    import model.RewardM;
    import model.WxM;

    import ui.abbey.CollectLeadPageUI;

    public class CollectLeadPage extends CollectLeadPageUI implements ResVo
    {

        private var _startX:Number = 0;
        private var _startY:Number = 0;

        public function CollectLeadPage()
        {

        }

        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;
            bmask.on(Event.CLICK, this, null)
            _startX = this.x;
            _startY = this.y;
            getPrizeBtn.on(Event.CLICK, this, getPrize)
            quitBtn.on(Event.CLICK, this, onQuitBtnClick);
            screenResize();
            initPage();
        }


        private function getPrize():void
        {
            if (RewardM.instance._isCollect == 0)
            {
                if (sceneContrast())
                {
                    WebSocketManager.instance.send(39003, {})
                    if (RewardM.instance._isFristCollect == 0)
                    {
                        BuriedManager.instance.addBuriedData(BuriedTypes.receive_game, {is_first_receive: 1})
                    } else if (RewardM.instance._isFristCollect == 1)
                    {
                        BuriedManager.instance.addBuriedData(BuriedTypes.receive_game, {is_first_receive: 0})
                    }
                } else
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请从[我的小程序]入口处登陆")
                }
            } else if (RewardM.instance._isCollect == 1)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请勿重复领取")
            }
        }

        private function compareVersion(v1, v2):Number
        {
            v1 = v1.split('.')
            v2 = v2.split('.')
            const len = Math.max(v1.length, v2.length)

            while (v1.length < len)
            {
                v1.push('0')
            }
            while (v2.length < len)
            {
                v2.push('0')
            }

            for (var i = 0; i < len; i++)
            {
                const num1 = parseInt(v1[i])
                const num2 = parseInt(v2[i])

                if (num1 > num2)
                {
                    return 1
                } else if (num1 < num2)
                {
                    return -1
                }
            }
            return 0
        }

        private function sceneContrast():Boolean
        {
            //            var version = __JS__("wx").getSystemInfoSync().SDKVersion
            var sceneId = BackScene();
            if (sceneId == 1089 || sceneId == 1104 || sceneId == 1001)
            {
                return true
            }
            return false;
        }

        private function BackScene():Number
        {
            var num:Number = WxM.instance.isBackScene;
            return num;
        }

        private function initPage():void
        {
            if (RewardM.instance._isCollect == 1)
            {
                drawTips.text = "已领取";
                getPrizeBtn.gray = true;
            }
        }

        private function screenResize():void
        {
            var contentWidth:int = 800;//组件范围width
            var contentHeight:int = 550;//组件范围height
            var contentStartX:int = 240;//组件左边距
            var contentStartY:int = 100;//组件上边距
            var posXOff:Number = (Laya.stage.width - contentWidth) / 2;
            var posYOff:Number = (Laya.stage.height - contentHeight) / 2;
            this.pos(_startX + posXOff - contentStartX, _startY + posYOff - contentStartY);
            this.size(Laya.stage.width, Laya.stage.height);

            quitBtn.left = contentStartX - posXOff;
            quitBtn.top = contentStartY - posYOff;
        }

        private function onQuitBtnClick()
        {
            UiManager.instance.closePanel("CollectLead", true);
        }

        public function unRegister():void
        {
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.off(GameEvent.isCollect, this, initPage);
        }


        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.on(GameEvent.isCollect, this, initPage);
        }


    }
}
