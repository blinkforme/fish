package view.monthCard
{


    import conf.cfg_battery;
    import conf.cfg_goods;

    import control.WxC;

    import control.WxC;

    import emurs.ShowType;

    import engine.tool.StartParam;

    import laya.utils.Tween;

    import manager.ApiManager;
    import manager.GameTools;

    import manager.WebSocketManager;

    import model.CertificationM;

    import model.LoginInfoM;

    import model.LoginM;

    import model.RoleInfoM;

    import conf.cfg_commodity;
    import conf.cfg_goods;

    import laya.display.Text;
    import laya.events.Event;
    import laya.ui.Box;
    import laya.ui.FontClip;
    import laya.ui.List;
    import laya.utils.Browser;
    import laya.utils.Handler;

    import manager.ConfigManager;
    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;

    import struct.CertificationInfo;

    import struct.QuitTipInfo;

    import ui.abbey.MonthCardPageUI;

    public class MonthCardPage extends MonthCardPageUI implements ResVo
    {

        private var _startX:Number = 0;
        private var _startY:Number = 0;
        private var giftUserId:Number = null;

        private var curPage = 0;


        //    目前就一张月卡，这里写死
        private var card_id:Number = GameConst.month_card_id;
        private var arr:Array;


        function MonthCardPage()
        {


        }

        public function StartGames(parm:Object = null):void
        {
            if (parm && parm["id"])
            {
                this.card_id = parm["id"]
            }

            this.hitTestPrior = false;
            bmask.on(Event.CLICK, this, null)
            _startX = this.x;
            _startY = this.y;

            tip_box.visible = false;
            quitBtn.on(Event.CLICK, this, onQuitBtnClick);
            quit_gift_box.on(Event.CLICK, this, onQuitBoxBtn)
            scroll_left.on(Event.CLICK, this, onScrollLeft)
            scroll_right.on(Event.CLICK, this, onScrollRight)
            list.renderHandler = new Handler(this, updateItem);

            var os:Number = Browser.onIOS ? 1 : Browser.onAndroid ? 2 : 3
            arr = ConfigManager.filter("cfg_commodity", function (cfg:cfg_commodity)
            {
                return cfg.tab == "tab_package" && cfg.card_type == 0 && cfg.os == os
            })

            list.array = arr

            for (var i:Number = 0; i < arr.length; i++)
            {
                if (arr[i].id == card_id)
                {
                    curPage = i;
                    break
                }
            }
            list.scrollTo(curPage)
            resetCardTitle()
            onScrollEnd()

            screenResize();
        }

        private function resetCardTitle()
        {
            card_title.skin = arr[curPage].card_title2
        }

        private function onScrollRight()
        {
            ++curPage
            list.tweenTo(curPage, 300);
            resetCardTitle()
            onScrollEnd()
        }

        private function onScrollLeft()
        {
            --curPage
            list.tweenTo(curPage, 300);
            resetCardTitle()
            onScrollEnd()
        }

        private function onScrollEnd()
        {
            scroll_left.visible = true;
            scroll_right.visible = true;
            if (curPage == 0)
            {
                scroll_left.visible = false;
            }
            if (curPage == list.length - 1)
            {
                scroll_right.visible = false;
            }
        }


        private function updateItem(cell:*, index:int):void
        {
            var config:cfg_commodity = cell.dataSource;
            var ele_day_num:Text = cell.getChildByName("day_num") as Text


            var buy_box:Box = cell.getChildByName("buy_box") as Box
            var send_box:Box = cell.getChildByName("send_box") as Box
            var list_reward1:List = cell.getChildByName("list_reward1") as List
            var list_reward2:List = cell.getChildByName("list_reward2") as List
            var list_reward3:List = cell.getChildByName("list_reward3") as List

            ele_day_num.text = config.card_duration + ""
            initBuyClick(buy_box, config)

            send_box.offAll(Event.CLICK)
            send_box.on(Event.CLICK, this, initSendClick, [config])

            init_list_reward(list_reward1, list_reward2, list_reward3, config)
        }

        private function initBuyClick(buy_box:Box, config:cfg_commodity):void
        {

            var ele_price:FontClip = buy_box.getChildByName('price') as FontClip;
            buy_box.offAll(Event.CLICK);

            ele_price.value = Math.ceil(config.currency_amount / LoginInfoM.instance.getShopRate()) + "";

            buy_box.on(Event.CLICK, this, function ()
                    {
                            if (CertificationM.instance.isOpenCertification())
                            {
                                var certInfo:CertificationInfo = new CertificationInfo();
                                certInfo.openFrom = GameConst.from_month;
                                certInfo.buyInfo = config;
                                CertificationM.instance.info = certInfo;
                                CertificationM.instance.OpenCertification()
                            } else
                            {
                                GameEventDispatch.instance.event(GameEvent.ShopBuy,config)
                            }
                            UiManager.instance.closePanel("MonthCard", true);
                    }
            )
        }

        private function initSendClick(cfg:cfg_commodity):void
        {
            var mini_battery:Number = ConfigManager.getConfValue("cfg_global", 1, "min_battery") as Number

            if (RoleInfoM.instance.getBattery() <= mini_battery)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, cfg_battery.instance(mini_battery + 1).comsume + "倍炮台，开放赠送功能");
                return;
            }

            if (CertificationM.instance.isOpenCertification())
            {
                var certInfo:CertificationInfo = new CertificationInfo();
                certInfo.openFrom = GameConst.from_gift;
                certInfo.buyInfo = cfg;
                CertificationM.instance.info = certInfo;
                CertificationM.instance.OpenCertification()
            }  else
            {
                adultPlayer(cfg);
            }
        }

        private function adultPlayer(cfg:Object):void
        {
            tip_box.pivotX = Laya.stage.mouseX
            tip_box.pivotY = Laya.stage.mouseY;
            tip_box.x = Laya.stage.mouseX;
            tip_box.y = Laya.stage.mouseY;
            tip_box.scaleX = 0;
            tip_box.scaleY = 0;
            GameEventDispatch.instance.event(GameEvent.CloseWait);
            Tween.to(tip_box, {scaleX: 1.05, scaleY: 1.05}, 300, null, Handler.create(this, showComplete))
            input_userid.text = "";
            tip_box.visible = true;
            quit_gift_box.visible = true;
            query_btn.on(Event.CLICK, this, onQueryUserID)
            gift_confirm.on(Event.CLICK, this, onGiftConfirm, [cfg])
        }

        private function showComplete():void
        {
            Tween.to(tip_box, {scaleX: 1, scaleY: 1}, 250);
        }


        private function onQueryUserID():void
        {
            var pattern_user_id:RegExp = /^[1-9][0-9]+$/;
            if (!pattern_user_id.test(input_userid.text))
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "用户ID不符合规范");
            } else
            {
                var user_id:Number = input_userid.text as Number;
                var token = StartParam.instance.getParam("access_token");
                ApiManager.instance.queryUserName(token, user_id, Handler.create(this, function (result:Object)
                {
                    if ("success" == result.code)
                    {
                        var data:Object = result.data;

                        var nickName:String = data.nickname as String;
                        var userId:Number = data.id;
                        username.text = LoginInfoM.instance.filterName(GameTools.formatNickName(nickName, 20));
                        if (data.avatar)
                        {
                            userimg.skin = data.avatar;
                        }
                        userinfo_box.visible = true
                        giftUserId = userId;

                    } else if ("user_not_found" == result.code)
                    {
                        GameEventDispatch.instance.event(GameEvent.MsgTipContent, "用户不存在");
                    }

                }), Handler.create(this, function (result:Object)
                {
                    console.log("error")
                    console.log(result)
                }))
            }
        }

        private function onGiftConfirm(re:cfg_commodity):void
        {
            var pattern_user_id:RegExp = /^[1-9][0-9]+$/;
            if (input_userid.text == "")
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请输入用户ID");
            } else if (!pattern_user_id.test(input_userid.text))
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "用户ID不符合规范");
            } else if (!giftUserId)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请点击查询按钮，确认用户身份");
            } else
            {
                onQuitBoxBtn();
                var data:Object = {item_id: re.good_ids[0], item_count: 1, user_id: giftUserId, buy_month_card: true};

                WxC.isInMiniGame() ? data['platform'] = "mini" : data['platform'] = StartParam.instance.getParam("platform")


                if (WxC.isInMiniGame())
                {
                    if (RoleInfoM.instance.mini_balance >= re.mini_currency_amount)
                    {
                        WebSocketManager.instance.send(14017, data)
                    } else
                    {
                        WxC.wx_requestPayment(re);
                    }
                } else
                {
                    WebSocketManager.instance.send(14017, data)
                }
            }
        }


        private function onQuitBoxBtn():void
        {
            tip_box.visible = false;
            quit_gift_box.visible = false;
            quitBtn.visible = true;
            input_userid.text = "";
            username.text = "";
            userinfo_box.visible = false
        }


        private function updateItemReward(cell:Box, index:int):void
        {
            var ele_reward_img = cell.getChildByName("reward_type");
            var ele_reward_text = cell.getChildByName("reward_text");

            var data = cell.dataSource

            ele_reward_img.skin = cfg_goods.instance(data.reward_item_id + "").icon;
            ele_reward_text.text = 'x ' + data.reward_item_num;
        }


        private function init_list_reward(list_reward1:List, list_reward2:List, list_reward3:List, cfg:cfg_commodity):void
        {

            list_reward1.renderHandler = new Handler(this, updateItemReward);
            list_reward2.renderHandler = new Handler(this, updateItemReward);
            list_reward3.renderHandler = new Handler(this, updateItemReward);

            var rewards1:Array = [];
            var rewards2:Array = [];
            var rewards3:Array = [];


            var total_reward_coin:Number = 0;
            var total_reward_diamond:Number = 0;

            for (var i = 0; i < cfg.reward_item_ids.length; i++)
            {
                rewards1.push({
                    reward_item_id: cfg.reward_item_ids[i],
                    reward_item_num: cfg.reward_item_nums[i]
                })
                if (1 == cfg_goods.instance(cfg.reward_item_ids[i]).type)
                {
                    total_reward_coin += cfg.reward_item_nums[i]
                }

                if (4 == cfg_goods.instance(cfg.reward_item_ids[i]).type)
                {
                    total_reward_diamond += cfg.reward_item_nums[i]
                }
            }

            var cfgObj:cfg_commodity = cfg_commodity.instance(GameConst.month_card_id)

            for (var i = 0; i < cfgObj.reward_item_ids.length; i++)
            {
                rewards2.push({
                    reward_item_id: cfg.reward_item_ids[i],
                    reward_item_num: cfgObj.reward_item_nums[i]
                })

                if (1 == cfg_goods.instance(cfg.reward_item_ids[i]).type)
                {
                    total_reward_coin += cfgObj.reward_item_nums[i] * cfg.card_duration
                }

                if (4 == cfg_goods.instance(cfg.reward_item_ids[i]).type)
                {
                    total_reward_diamond += cfgObj.reward_item_nums[i] * cfg.card_duration
                }
            }

            rewards3.push({reward_item_id: 1, reward_item_num: total_reward_coin})
            rewards3.push({reward_item_id: 4, reward_item_num: total_reward_diamond})

            list_reward1.array = rewards1;
            list_reward2.array = rewards2;
            list_reward3.array = rewards3;

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
            quit_gift_box.left = contentStartX - posXOff;
            quitBtn.top = contentStartY - posYOff;
            quit_gift_box.top = contentStartY - posYOff;
        }


        private function onQuitBtnClick():void
        {
            UiManager.instance.closePanel("MonthCard", true);
        }


        public function unRegister():void
        {
            this.x = _startX;
            this.y = _startY;
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.off(GameEvent.OpenGift, this, adultPlayer);

        }


        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.on(GameEvent.OpenGift, this, adultPlayer);

        }


    }
}
