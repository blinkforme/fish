package view.subscription
{
    import control.WxC;

    import model.RoleInfoM;
    import model.SubscriptionM;

    import laya.events.Event;
    import laya.ui.Box;
    import laya.ui.Image;
    import laya.ui.Label;
    import laya.utils.Browser;
    import laya.utils.Handler;

    import manager.ConfigManager;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;
    import manager.WebSocketManager;

    import ui.abbey.subscriptionUI;

    /**
     * ...
     * @author ...
     */
    public class SubscriptionPage extends subscriptionUI implements ResVo
    {
        private var _startX:Number = 0;
        private var _startY:Number = 0;

        public function SubscriptionPage()
        {

        }

        private function screenResize():void
        {
            var contentWidth:int = 1070;//组件范围width
            var contentHeight:int = 650;//组件范围height
            var contentStartX:int = 110;//组件左边距
            var contentStartY:int = 30;//组件上边距
            var posXOff:Number = (Laya.stage.width - contentWidth) / 2;
            var posYOff:Number = (Laya.stage.height - contentHeight) / 2;
            this.pos(_startX + posXOff - contentStartX, _startY + posYOff - contentStartY);
            this.size(Laya.stage.width, Laya.stage.height);

            close_btn.left = contentStartX - posXOff;
            close_btn.top = contentStartY - posYOff;
            codequiteBtn.left = contentStartX - posXOff;
            codequiteBtn.top = contentStartY - posYOff;
        }

        /* INTERFACE manager.ResVo */

        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;
            codequiteBtn.visible=false;
            _startX = this.x;
            _startY = this.y;

            var _isInMiniGame:Boolean;
            close_btn.on(Event.MOUSE_DOWN, this, onClose);//h5-btn

            if (WxC.isInMiniGame())
            {
                _isInMiniGame = true;
            } else
            {
                _isInMiniGame = false;
            }


            //页面
            if (Browser.onWeiXin && !_isInMiniGame)
            {
                initboxtxt("h5wxin");//微信内页
                this.gotohttp.on(Event.MOUSE_DOWN, this, onGotosub);
            }
            else if (WxC.isInMiniGame() && _isInMiniGame)
            {
                initboxtxt("wx");//微信小游戏
                this.copybtn.on(Event.MOUSE_DOWN, this, onBtnCopyClick);//复制到剪切板
            }
            else
            {
                initboxtxt("h5wxout");//微信外页
            }
            this.giftcodeBtn.on(Event.CLICK, this, showWriteGiftCode);

            writegiftcode.visible = false;
            WebSocketManager.instance.send(41000, {});//状态查询:获取list表

            screenResize();
        }


        public function onBtnCopyClick(e):void
        {
            WxC.wx_set_clipboard_data("jjhbyh5");
        }

        private function initboxtxt(_str:String):void
        {
            var txtArr:Array = [this.txtbox_wx, this.txtbox_h5wxin, this.txtbox_h5wxout];

            for (var i:int, _arr = txtArr; i < _arr.length; i++)
            {
                _arr[i].visable = false;
            }

            switch (_str)
            {
                case "wx":
                    this.txtbox_h5wxout.visible = true;
                    break;
                case "h5wxin":
                    this.txtbox_h5wxin.visible = true;
                    break;
                case "h5wxout":
                    this.txtbox_h5wxout.visible = true;
                    break;
            }
        }


        private function showWriteGiftCode():void
        {
            close_btn.visible=false;
            codequiteBtn.visible=true;
            writegiftcode.visible = true;
            codeconfirmBtn.on(Event.CLICK, this, onCodeConfirmClick);
            codequiteBtn.on(Event.CLICK, this, onCodeQuiteClick);
        }

        private var canbeCode:Boolean = true;

        private function onCodeConfirmClick():void
        {
            var _code:String = writegiftInput.text;
            SubscriptionM.instance.setGiftcode(_code);
            //SubscriptionM
            if (_code.length == 0)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "礼包码不能为空");
            }
            else if (_code.length > 0 && canbeCode)
            {
                canbeCode = false;
                WebSocketManager.instance.send(41002, {key: _code});
                Laya.timer.once(2000, this, function ()
                {
                    canbeCode = true;
                });
                //WebSocketManager.instance.send(39000, {key: _code});
            }
        }

        private function onCodeQuiteClick():void
        {
            writegiftInput.text = "";
            writegiftcode.visible = false;
            close_btn.visible=true;
            codequiteBtn.visible=false;
        }


        private function subDisabled():void
        {
            if (!giftcodeBtn.disabled)
            {
                giftcodeBtn.disabled = true;
                onCodeQuiteClick();
            }

            close_btn.on(Event.MOUSE_DOWN, this, function ():void
            {
                onClose();
                WebSocketManager.instance.send(41000, {});//状态查询
            });
        }


        private function setsubBtn(_ifdisabled:Boolean = false):void
        {
            giftcodeBtn.disabled = !_ifdisabled;
        }


        private function onGotosub():void
        {
            var base:String = "MzI5MjgwMzczMw==";//MzI5MjgwMzczMw== h5//MzAwMTAzNTAwMA== node
            var suburl:String = "https://mp.weixin.qq.com/mp/profile_ext?action=home&__biz=" + base + "#wechat_redirect";
            var suburl2:String = "https://mp.weixin.qq.com/mp/profile_ext?action=home&__biz=MzI5MjgwMzczMw==&scene=124#wechat_redirect";

            var newIframe:Object = __JS__('window').open(suburl);
            //var newIframe:Object = __JS__('window').location.href = suburl;
            //var newIframe:Object = __JS__('window').history.back(suburl);

            //var refresh:Object = __JS__('location').reload(suburl2);
            var refresh:Object = __JS__('window').location.replace(suburl);
            //var refresh:Object = __JS__('window').navigate(suburl);

            /*延时刷新
             * var onload:Object=__JS__('window').onload = function(){
                var url=suburl;
                if( url.indexOf("r=")==-1 ){
                    var t = new Date();
                    __JS__('window').location.href = "<%=request.getContextPath()%>/url?r="+t.getTime();
                }
            }
            */
        }


        private function updateItem(cell:Box, index:int):void
        {
            var d:Object = cell.dataSource;
            var ele_remain:Label = cell.getChildByName("reward") as Label;
            var ele_img:Image = cell.getChildByName("img") as Image;

            ele_remain.text = d.num;
            ele_img.skin = d.icon;
        }


        private function updatelist(res):void
        {
            //静态
            var ifStaticList:Boolean = true;
            if (ifStaticList)
            {
                this.giftlist.visible = false;
                return;
            }


            //获取动态列表
            var listId:Array = [];
            var listNum:Array = [];
            for (var i:int = 0; i < res.length; i++)
            {
                listId.push(res[i][0]);
                listNum.push(res[i][1]);
            }

            var popArr:Array = ConfigManager.filter("cfg_goods");
            var resArr:Array = ConfigManager.filter("cfg_goods", function (item)
            {
                for (var i:int = 0; i < listId.length; i++)
                {
                    if (listId[i] == item.id)
                    {
                        item.num = listNum[i];
                        return item;
                    }
                }
            });
            this.giftlist.array = resArr;
            this.giftlist.renderHandler = new Handler(this, updateItem);
        }


        private function onClose():void
        {
            if (!RoleInfoM.instance.getFirstSubscription())
            {
                writegiftcode.visible = false;//关闭code兑换页
                GameEventDispatch.instance.event(GameEvent.SyncSubscriptionIco);//关闭主页ico
            }
            UiManager.instance.closePanel("Subscription", false);//关闭sub页
        }


        public function unRegister():void
        {
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.off(GameEvent.SubDisabled, this, subDisabled);
            GameEventDispatch.instance.off(GameEvent.UpdateGiftlist, this, updatelist);
            GameEventDispatch.instance.off(GameEvent.ResetSubBtn, this, setsubBtn);
            GameEventDispatch.instance.off(GameEvent.Closesubpanel, this, onClose);
        }


        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.on(GameEvent.SubDisabled, this, subDisabled);
            GameEventDispatch.instance.on(GameEvent.UpdateGiftlist, this, updatelist);
            GameEventDispatch.instance.on(GameEvent.ResetSubBtn, this, setsubBtn);
            GameEventDispatch.instance.on(GameEvent.Closesubpanel, this, onClose);
        }

    }

}
