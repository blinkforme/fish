package view.useTicket
{
    import control.ActivityC;
    import control.WxC;

    import model.ActivityM;
    import model.LoginInfoM;
    import model.LoginM;
    import model.RoleInfoM;

    import conf.cfg_goods;
    import conf.cfg_scene;

    import emurs.ShowType;

    import laya.events.Event;
    import laya.ui.Box;
    import laya.ui.Button;
    import laya.ui.FontClip;
    import laya.ui.Image;
    import laya.ui.Label;
    import laya.ui.List;
    import laya.utils.Ease;
    import laya.utils.Handler;
    import laya.utils.Tween;

    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.GameTools;
    import manager.ResVo;
    import manager.UiManager;
    import manager.WebSocketManager;

    import struct.QuitTipInfo;

    import ui.abbey.UseTicketPageUI;

    import view.item.FesDailyGiftItem;

    public class UseTicketPage extends UseTicketPageUI implements ResVo
    {
        private var _startX:Number = 0;
        private var _startY:Number = 0;
        private var itemBtnObj:Array;
        private var canbeCode:Boolean = true;
        private var exchangeData:Object = null;//当前兑换物品的数据
        private var _activePage:Number;
        private var _activeArr:Array;
        private var _activeMaxPage:Number;

        //------------------欢乐气球------------------------------
        private var leftLimitRot:Number = -90;
        private var rightLimitRot:Number = 90;
        private var isClick:Boolean = true;
        private var faSheGrade:Number = 2;//1  2  3
        private var rotationSpeed:Number = 1;
        private var endY:Number = 70;
        private var endX:Number = 143;
        private var startY:Number = 190;
        private var startX:Number = 270;
        private var isHitTarget:Boolean = false;
        private var hitRange:Array = [[-58, -47], [-44, -30], [-22, -7], [6, 21], [31, 44], [47, 58]];
        private var balloonArr:Array;
        private var hitAirBalloon:Number = 0;
        private var chooseFlyBtn:Number = 2;//选择飞镖类型 1  2  3
        private var balloonLimit:Number = 6;
        private var hitBalloonArr:Array;
        private var _itemTabArr:Array;
        private static const ITEM_TAB_NUM:int = 5;
        private static const DAILY_GIFT_BTN_TAG:String = "DAILY_GIFT_BTN_TAG";

        public function UseTicketPage()
        {

        }

        public function StartGames(parm:Object = null):void
        {
            copyBtn.visible = false;
            this.hitTestPrior = false;
            bmask.on(Event.CLICK, this, null);
            bmask_b.on(Event.CLICK, this, null)
            initPicture();
            closeAccountBox.visible = false;
            returnMainBtn.visible = false;
            _activeArr = ActivityM.instance.activeImg();
            _startX = this.x;
            _startY = this.y;
            initBox();
            //            activityExplain()
            _activePage = 0;
            _activeMaxPage = _activeArr.length - 1;
            bmask.on(Event.CLICK, this, null)
            for (var i:int = 0; i < ITEM_TAB_NUM; ++i)
            {
                this["itemBtn_" + i].on(Event.CLICK, this, selectBox, [i]);
            }
            balloonArr = [balloon_1, balloon_2, balloon_3, balloon_4, balloon_5, balloon_6];
            returnAccountBtn.on(Event.CLICK, this, onReturnAccountBtn);
            rankList.renderHandler = new Handler(this, rankListRender);
            close_btn.on(Event.MOUSE_DOWN, this, onClose);
            returnMainBtn.on(Event.MOUSE_DOWN, this, onCloseBox);
            list1.renderHandler = new Handler(this, updateExchange);
            list_sign.renderHandler = new Handler(this, updateSign);
            list_gift.renderHandler = new Handler(this, updateGift);
            accountBtn.on(Event.CLICK, this, onCloseAccountBtn);
            list_act.on(Event.CLICK, this, onClick);
            secondBtn.on(Event.CLICK, this, faShe, [2]);
            this.costRmbBtn.on(Event.CLICK, this, this.onBuyDailyGift);
            list_sign.hScrollBarSkin = "";
            list1.hScrollBarSkin = "";
            screenResize();
            initTabPage()
        }

        private function initPicture():void
        {
            if (ActivityM.instance.activityPictureConfig)
            {
                select_0.skin = ActivityM.instance.activityPictureConfig[0];
                select_1.skin = ActivityM.instance.activityPictureConfig[1];
                select_2.skin = ActivityM.instance.activityPictureConfig[1];
                select_3.skin = ActivityM.instance.activityPictureConfig[2];
                select_4.skin = ActivityM.instance.activityPictureConfig[3];
            }

            if (WxC.isInMiniGame())
            {
                copyBtn.visible = true;
            }
        }

        private function initBox():void
        {
            itemBtn_0.visible = true;
            itemBtn_1.visible = ActivityM.instance.isShowDirectChanges;
            itemBtn_2.visible = ActivityM.instance.isShowGiftBox;
            itemBtn_3.visible = true;
            itemBtn_4.visible = ActivityM.instance.isShowDailyGift;
            // 每日礼包和分享礼盒的位置一样
            itemBtnObj = [itemBtn_0, itemBtn_1, itemBtn_2, itemBtn_4, itemBtn_3];
            var canShowPage:Number = 0;
            for (var i:int = 0; i < itemBtnObj.length; i++)
            {
                if (itemBtnObj[i].visible)
                {
                    itemBtnObj[i].x = canShowPage * 180 + 174;
                    canShowPage++;
                }
            }
            if (!ActivityM.instance.isShowRankActivity)
            {
                accountBtn.gray = true;
                secondBtn.gray = true;
            } else
            {
                accountBtn.gray = false;
                secondBtn.gray = false;
                secondBtn.toggle = true;
            }
            selectBox(0);
        }

        private function selectBox(page:Number):void
        {
            for (var i:int = 0; i < ITEM_TAB_NUM; ++i)
            {
                this["itemBtn_" + i].selected = page == i;
                this["itemBox_" + i].visible = page == i;
            }
            Laya.timer.clear(this, startFlyDarts);
            switch (page)
            {
                case 0:
                    activityExplain();
                    break;
                case 1:
                    itemBox_1.visible = true;
                    ActivityC.instance.syncExchangeTime()
                    directChanges();
                    break;
                case 2:
                    giftBox();
                    break;
                case 3:
                    rankActivity();
                    break;
                case 4:
                    updDailyGiftBox();
                    break;
            }
        }

        private function activityExplain():void
        {
            rewardFlush();
            Laya.timer.once(100, this, scrollList);
            list_act.array = _activeArr;
            list_act.on(Event.MOUSE_OVER, this, activeMouseOver);
            list_act.on(Event.MOUSE_OUT, this, activeMouseOut);
            list_act.tweenTo(_activePage, 3000);
            Laya.timer.once(3000, this, activeRecursion);
        }


        private function rewardFlush():void
        {
            var actRegiData:Array = ActivityM.instance.actRegisterDate;
            var reg_obj:Object = ActivityM.instance._getCommonActivityConfig(GameConst.activity_common_register)
            var reg_arr:Object = [];
            if (reg_obj)
            {
                reg_arr = reg_obj.reward
            }
            var timeObj:Object = ActivityM.instance._getCommonActivityConfig(GameConst.activity_common_register)
            var time_arr:Array = [];
            if (timeObj)
            {
                time_arr = timeObj.time
            }
            list_sign.visible = ActivityM.instance.isShowRegisterRebate;
            var reward = [];

            if (ActivityM.instance.isShowRegisterRebate)
            {
                for (var i = 0; i < reg_arr.length; i++)
                {
                    if (reg_arr && reg_arr.length > 1)
                    {

                        reward.push({
                                    id: reg_arr[i][0]
                                    , num: reg_arr[i][1], state: actRegiData[i], time: time_arr[i]
                                }
                        )
                    }
                }
                list_sign.array = reward;
            } else
            {
                list_act.pos(0, 0);
                tab1.pos(930, 300);
                list_sign.visible = false;
            }
        }

        private function scrollList():void
        {
            var date:int = ActivityM.instance.actRegisterTime - 1;
            list_sign.scrollTo(date);
        }

        private function onClick():void
        {
            if (_activeArr && _activeArr[_activePage].view)
            {
                var Ary = _activeArr[_activePage].view;
                if (Ary == "shop")
                {
                    GameEventDispatch.instance.event(GameEvent.Shop, "tab_package");
                } else if (Ary == "Match")
                {

                    var info:QuitTipInfo = new QuitTipInfo();
                    info.state = GameConst.quit_state_left_cancel_right_confirm;
                    info.content = "确认进入万年巨鳄关卡？";
                    info.confirmCallback = Handler.create(this, function ()
                    {
                        var cfg:cfg_scene = cfg_scene.instance(4);
                        var batteryLevel = RoleInfoM.instance.getBattery();
                        if (batteryLevel >= cfg.unlock)
                        {
                            WebSocketManager.instance.send(12003, null);
                            LoginM.instance.sceneId = 4;
                            GameEventDispatch.instance.event(GameEvent.StartLoad, [GameConst.loadFishState]);
                            onClose();
                        } else
                        {
                            GameEventDispatch.instance.event(GameEvent.MsgTip, cfg.msg_tip_id);
                        }
                    });
                    info.conFirmArgs = null;
                    info.autoCloseTime = 10;
                    GameEventDispatch.instance.event(GameEvent.QuitTip, info);
                } else if (Ary == "MatchGame")
                {
                    onClose();
                    UiManager.instance.loadView("NewMatch",null,ShowType.SMALL_TO_BIG);
                } else if (Ary == "Lottery")
                {
                    selectBox(4);
                } else if (Ary == "Rank")
                {
                    selectBox(1);

                } else
                {
                    var info:QuitTipInfo = new QuitTipInfo();
                    info.state = GameConst.quit_state_left_cancel_right_confirm;
                    info.content = "确认进入万年巨鳄关卡？";
                    info.confirmCallback = Handler.create(this, function ()
                    {
                        var cfg:cfg_scene = cfg_scene.instance(4);
                        var batteryLevel = RoleInfoM.instance.getBattery();
                        if (batteryLevel >= cfg.unlock)
                        {
                            WebSocketManager.instance.send(12003, null);
                            LoginM.instance.sceneId = 4;
                            GameEventDispatch.instance.event(GameEvent.StartLoad, [GameConst.loadFishState]);
                            onClose();
                        } else
                        {
                            GameEventDispatch.instance.event(GameEvent.MsgTip, cfg.msg_tip_id);
                        }
                    });
                    info.conFirmArgs = null;
                    info.autoCloseTime = 10;
                    GameEventDispatch.instance.event(GameEvent.QuitTip, info);
                    // UiManager.instance.loadView(Ary, null, ShowType.SMALL_TO_BIG);
                    // UiManager.instance.closePanel("UseTicket", false);
                }

            } else
            {


            }

        }

        private function refreshActCdk():void
        {
            giftBox();
        }

        private function updateSign(cell:Box, index:int):void
        {
            var config:Object = cell.dataSource;
            var ele_img:Image = cell.getChildByName("img") as Image;
            var ele_days:Label = cell.getChildByName("days") as Label;
            var ele_num:Label = cell.getChildByName("num") as Label;
            var ele_right:Image = cell.getChildByName("rightBtn") as Image;
            var ele_bg:Image = cell.getChildByName("bg") as Image;
            var ele_bmask:Image = cell.getChildByName("bmask") as Image;
            var sign_day:Number = ActivityM.instance.actRegisterTime;
            ele_img.skin = cfg_goods.instance(config.id).icon;
            ele_days.text = "第" + config.time + "天";
            ele_num.text = "" + config.num;
            ele_bg.skin = "ui/useTicket/img_kuang_02.png";
            ele_bg.offAll(Event.CLICK);
            if (index + 1 == sign_day)
            {
                ele_bg.skin = "ui/useTicket/img_kuang_02aa.png";
                ele_bg.on(Event.CLICK, this, onClickSign);
            } else
            {
                ele_bg.on(Event.CLICK, this, function ()
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "不在签到时间内");
                })
            }

            if (index + 1 < sign_day || config.state == 1)
            {
                ele_bmask.visible = true;
            } else
            {
                ele_bmask.visible = false;
            }

            if (config.state == 1)
            {
                ele_right.visible = true;
            } else
            {
                ele_right.visible = false;
            }
        }

        private function onClickSign():void
        {
            WebSocketManager.instance.send(40007, null)
        }

        private function onBuyDailyGift(evt:Event):void
        {
            if (!evt || !evt.target)
            {
                return;
            }
            var comActId:int = evt.target[DAILY_GIFT_BTN_TAG];
            if (comActId)
            {
                var giftConfig:Object = ActivityM.instance.getCurDailyGiftStageConfig(comActId);
                GameEventDispatch.instance.event(GameEvent.ShopBuy,{id: giftConfig.commodity_id})
            }
        }

        private function activeMouseOver():void
        {
            Laya.timer.clear(this, activeRecursion);
        }

        private function activeMouseOut():void
        {
            activeRecursion();
        }

        public function onScroll(index:Number):void
        {
            _activePage = index;
            Laya.timer.clear(this, activeRecursion);
            list_act.tweenTo(index, 0, new Handler(this, function ()
            {
                Laya.timer.once(3000, this, activeRecursion);
            }));

        }

        public function initTabPage():void
        {
            _itemTabArr = [item0, item1, item2, item3, item4, item5, item6]
            for (var i:int = 0; i < _itemTabArr.length; i++)
            {
                if ((i + 1) <= _activeArr.length)
                {
                    _itemTabArr[i].visible = true
                    _itemTabArr[i].on(Event.CLICK, this, onScroll, [i]);
                } else
                {
                    _itemTabArr[i].visible = false
                }
            }
            if (_activeArr.length == 0 )
            {
                _activeArr.push(
                        {img: {skin: "https://sq-img.jjhgame.com/FnUVnf-wF1u-HSYah7vHCL2OTyyh"}}
                )
            }
            tab1.anchorX = 1;
            tab1.anchorY = 1;
        }

        private function activeRecursion():void
        {
            if (_activePage < _activeMaxPage)
            {
                _activePage = _activePage + 1;
            } else
            {
                _activePage = 0;
            }
            list_act.tweenTo(_activePage, 3000);
            Laya.timer.once(3000, this, activeRecursion);
        }

        private function directChanges():void
        {
            var obj:Object = ActivityM.instance._getCommonActivityConfig(GameConst.activity_common_directchanges)
            if (obj)
            {
                var flush_time:Array = obj.flush_time
                var tipText = "每天"
                for (var i = 0; i < flush_time.length; i++)
                {
                    tipText += flush_time[i] + "点"
                    if (i < flush_time.length - 1)
                    {
                        tipText += "、"
                    }
                }
                tipText += "进行补货，记得来购买";
                exchangeTip.text = tipText
                list1.array = obj.exchange;
            }
            initCur();
        }

        private function initCur():void
        {
            list1.refresh();
        }

        private function updateExchange(cell:Box, index:int):void
        {
            var config:Object = cell.dataSource;
            var ele_buy_btn:Button = cell.getChildByName("btn") as Button;
            var ele_remain:Label = cell.getChildByName("remain") as Label;
            var ele_price:Label = ele_buy_btn.getChildByName("price") as Label;
            var ele_price_unit:Image = cell.getChildByName("price_unit") as Image;
            var ele_img:Image = cell.getChildByName("img") as Image;
            var ele_desc:Label = cell.getChildByName("desc") as Label;
            var exchangeTimes:Array = ActivityM.instance.exchangeTimes;

            var reward_arr:Array = config.reward;
            var consume_arr:Array = config.consume;
            if (exchangeTimes[index])
            {
                ele_remain.text = "剩余：" + exchangeTimes[index];
            } else
            {
                ele_remain.text = "剩余：0";
            }
            ele_desc.text = config.detail;

            if (consume_arr[1] <= 100000)
            {
                ele_price.text = parseInt(consume_arr[1]) + "";
            } else
            {
                ele_price.text = (parseInt(consume_arr[1])) / 100000 + "万";
            }

            //            ele_price.value = parseInt(consume_arr[1]) + "";
            ele_img.skin = cfg_goods.instance(reward_arr[0]).icon;
            ele_buy_btn.offAll(Event.CLICK);
            ele_price_unit.skin = cfg_goods.instance(consume_arr[0]).icon;


            if (ActivityM.instance.exchangeInterval <= 0)
            {
                if (exchangeTimes[index] > 0)
                {
                    if (ActivityM.instance.getGoodsNum(consume_arr[0]) >= consume_arr[1])
                    {
                        ele_buy_btn.stateNum = 2;
                        ele_buy_btn.skin = "ui/common_ex/btn_yellow.png";
                        ele_price.gray = false
                    } else
                    {
                        ele_buy_btn.stateNum = 1;
                        ele_buy_btn.skin = "ui/common_ex/btn_gray.png";
                        ele_price.gray = true
                    }
                } else
                {

                    ele_buy_btn.stateNum = 1;
                    ele_buy_btn.skin = "ui/common_ex/btn_gray.png";
                    ele_price.gray = true
                }

                if (ActivityM.instance.getGoodsNum(consume_arr[0]) >= consume_arr[1])
                {
                    if (exchangeTimes[index] > 0)
                    {
                        ele_buy_btn.on(Event.CLICK, this, function ()
                        {
                            var info:QuitTipInfo = new QuitTipInfo();
                            info.state = GameConst.quit_state_left_cancel_right_confirm;
                            info.content = "确认兑换？";
                            info.confirmCallback = Handler.create(this, exchange, [index + 1]);
                            info.conFirmArgs = exchangeData;
                            info.autoCloseTime = 10;
                            GameEventDispatch.instance.event(GameEvent.QuitTip, info);
                        })
                    } else
                    {
                        ele_buy_btn.on(Event.CLICK, this, function ()
                        {
                            GameEventDispatch.instance.event(GameEvent.MsgTipContent, "库存不足");
                        })
                    }
                } else
                {
                    ele_buy_btn.on(Event.CLICK, this, function ()
                            {
                                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "道具不足");
                            }
                    )
                }
            } else
            {
                ele_buy_btn.stateNum = 1;
                ele_buy_btn.skin = "ui/common_ex/btn_gray.png";
                ele_price.gray = true
                ele_price.text = ActivityM.instance.exchangeInterval + "s"
                ele_buy_btn.on(Event.CLICK, this, function ()
                        {
                            GameEventDispatch.instance.event(GameEvent.MsgTipContent, "30s内不能再次购买");
                        }
                )
            }
        }

        private function giftBox():void
        {

            var gift_obj:Object = ActivityM.instance._getCommonActivityConfig(GameConst.activity_common_giftbox);
            var consume_arr:Array = gift_obj["consume"];
            integralBox.visible = false;
            conversionBox.visible = false;
            convertBox.visible = false;
            txt_share_content.text = gift_obj["at_detail"];
            list_gift.array = gift_obj["reward"];
            if (ActivityM.instance.exchange == 0)   //如果没兑换礼包码
            {
                integralBox.visible = true;
            } else
            {
                conversionBox.visible = true;
            }
            integral_Icon.skin = cfg_goods.instance(consume_arr[0]).icon;
            integral_label.text = consume_arr[1];
            if (ActivityM.instance.actCurrency(consume_arr[0]) < consume_arr[1])
            {
                integralBtn.gray = true;
                integral_label.gray = true;
            } else
            {
                integralBtn.gray = false;
                integral_label.gray = false;
            }
            integralBtn.on(Event.CLICK, this, onIntegralBtn);
            giftBagCode.text = ActivityM.instance.giftCdk;
            conversionBtn.on(Event.CLICK, this, onConversionBtn);
            returnMainBtn.on(Event.CLICK, this, onReturnMainBtn);
            yesBtn.on(Event.CLICK, this, onYesBtn);
            copyBtn.on(Event.CLICK, this, onCopyBtn);

        }

        private function updDailyGiftBox():void
        {
            var comActId:int = GameConst.activity_common_main_daily_gift;
            this.updDailyGiftCostBtn(comActId);
            this.updDailyGiftAward(comActId);
        }

        private function updDailyGiftAward(activityCommonId:int):void
        {
            var giftConfig:Object = ActivityM.instance.getCurDailyGiftStageConfig(activityCommonId);
            if (giftConfig)
            {
                var awards:Array = giftConfig.rewards;
                var ctrl:FesDailyGiftItem = null;
                var award:Array = null
                for (var i:int = 1, l:int = awards ? awards.length : 0; i <= l; ++i)
                {
                    ctrl = this["giftItem" + i];
                    award = awards[i - 1];
                    if (!ctrl || !award)
                    {
                        continue;
                    }
                    ctrl.init(award[3], award[2])
                }
            }
        }

        private function updDailyGiftCostBtn(activityCommonId:int):void
        {
            var isAllBuyed:Boolean = ActivityM.instance.isDailyGiftAllBuyed(activityCommonId);
            this.costRmbBtn.visible = !isAllBuyed;
            this.tipText.visible = isAllBuyed;
            if (!isAllBuyed)
            {
                var giftConfig:Object = ActivityM.instance.getCurDailyGiftStageConfig(activityCommonId);
                var costRmbStr:String = "";
                if (giftConfig)
                {
                    costRmbStr = giftConfig.price + "元";
                    this.costRmbBtn[DAILY_GIFT_BTN_TAG] = activityCommonId;
                }
                costRmbText.text = costRmbStr;
            }
        }

        private function updateGift(cell:Box, index:int):void
        {
            var data:Object = cell.dataSource;
            var ele_img:Image = cell.getChildByName("img") as Image;
            var ele_num:Label = cell.getChildByName("num") as Label;

            ele_img.skin = cfg_goods.instance(data.prop_id).icon;
            ele_num.text = ActivityM.instance.exchangeConversion(data.prop_id, data.prop_num) + "";
        }

        private function onIntegralBtn():void
        {
            var gift_obj:Object = ActivityM.instance._getCommonActivityConfig(GameConst.activity_common_giftbox);
            var consume_arr:Array = gift_obj["consume"];
            if (ActivityM.instance.actCurrency(consume_arr[0]) < consume_arr[1])
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "道具不足");
            } else
            {
                var info:QuitTipInfo = new QuitTipInfo();
                info.state = GameConst.quit_state_left_cancel_right_confirm;
                info.content = "确认兑换礼盒？";
                info.confirmCallback = Handler.create(this, function ()
                {
                    WebSocketManager.instance.send(40013, null);
                });
                info.conFirmArgs = null;
                info.autoCloseTime = 10;
                GameEventDispatch.instance.event(GameEvent.QuitTip, info);
            }
        }

        private function onConversionBtn():void
        {
            close_btn.visible = false;
            convertBox.visible = true;
            returnMainBtn.visible = true;
        }

        private function onReturnMainBtn():void
        {
            writegiftInput.text = "";
            close_btn.visible = true;
            convertBox.visible = false;
            returnMainBtn.visible = false;
        }

        private function onYesBtn():void
        {
            var code:String = writegiftInput.text;
            if (code.length == 0)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "礼包码不能为空");
            } else if (code.length > 0 && canbeCode)
            {
                canbeCode = false;
                WebSocketManager.instance.send(39000, {key: code});
                Laya.timer.once(2000, this, function ()
                {
                    canbeCode = true;
                });
            }
        }

        private function onCopyBtn():void
        {
            GameTools.copyText("" + ActivityM.instance.giftCdk);
        }

        private function rankActivity():void
        {
            refreshRankList();
            consume_82.skin = cfg_goods.instance("82").icon;
            consumeNum_82.value = "x" + ActivityM.instance.actCurrency(GameConst.activity_currency_two) as String;
            faSheGrade = 2;
            detailLable.text = ActivityM.instance._getCommonActivityConfig(GameConst.activity_common_rankactivity)["detail"] + "";
            initFlyDartsStates();
        }

        private function rankListRender(cell:Box, index:int):void
        {
            var config:Object = cell.dataSource;
            var imgBox:Box = cell.getChildByName("imgBox") as Box;
            var playimg:Image = imgBox.getChildByName("playimg") as Image;
            var integralLabel:Label = cell.getChildByName("Integral") as Label;
            var playerName:Label = cell.getChildByName("player_name") as Label;
            var rankLabel:Label = cell.getChildByName("rankLab") as Label;
            var levelLabel:Label = cell.getChildByName("level") as Label;
            var rankIcon:Image = cell.getChildByName("rank_icon") as Image;
            var listReward:List = cell.getChildByName("list_reward") as List;

            listReward.renderHandler = new Handler(this, listRewardRender);
            if (config.user_avatar)
            {
                playimg.skin = config.user_avatar;
            }
            integralLabel.text = config.integral + "";
            var name:String = config.user_nickname;
            if (name.length > 4)
            {
                name = name.substring(0, 4) + "...";
            }
            playerName.text = LoginInfoM.instance.filterName(name);
            rankLabel.text = (index + 1) + "";
            levelLabel.text = "lv." + config.user_level;
            rankIcon.visible = false;
            var award = ActivityM.instance.rankRewards[index];

            var rewards = []
            for (var i = 0; i < award.length; i += 2)
            {
                rewards.push({
                    reward_item_id: award[i],
                    reward_item_num: award[i + 1]
                })
            }
            listReward.array = rewards
        }

        private function listRewardRender(cell:Box, index:int):void
        {
            var data = cell.dataSource
            var rewardImg:Image = cell.getChildByName("reward_type") as Image;
            var rewardLabel:Label = cell.getChildByName("reward_text") as Label;
            rewardImg.skin = cfg_goods.instance(data.reward_item_id + "").icon;
            rewardLabel.text = 'x ' + ActivityM.instance.getExchangeConversionDesc(data.reward_item_id, data.reward_item_num);
        }

        private function initFlyDartsStates():void
        {
            darts.rotation = 0;
            hitAirBalloon = 0;
            isHitTarget = false;
            isClick = true;
            endY = 70;
            darts.x = startX;
            darts.y = startY;
            Laya.timer.loop(1, this, startFlyDarts);
        }

        private function startFlyDarts():void
        {
            if (darts.rotation >= rightLimitRot || darts.rotation <= leftLimitRot)
            {
                rotationSpeed = -rotationSpeed;
            }
            darts.rotation = darts.rotation + rotationSpeed

        }

        private function isHaveEnough(num:Number):Boolean
        {
            var boo:Boolean = false;
            switch (num)
            {
                case 1:
                    boo = ActivityM.instance.actCurrency(81) >= ActivityM.instance.getBalloonConsume(GameConst.activity_currency_one)
                    break;
                case 2:
                    boo = ActivityM.instance.actCurrency(82) >= ActivityM.instance.getBalloonConsume(GameConst.activity_currency_two)
                    break;
                case 3:
                    boo = ActivityM.instance.actCurrency(83) >= ActivityM.instance.getBalloonConsume(GameConst.activity_currency_three)
                    break;
            }
            return boo;
        }

        private function faShe(grade:Number):void
        {
            chooseFlyBtn = grade;
            refreshRankList();
            if (ActivityM.instance.isShowRankActivity)
            {
                secondBtn.gray = false;
                if (chooseFlyBtn == faSheGrade && isClick)
                {
                    if (isHaveEnough(faSheGrade))
                    {
                        isClick = false;
                        Laya.timer.clear(this, startFlyDarts);
                        calculateFlightPath(darts.rotation);
                        Tween.to(darts, {x: endX, y: endY}, 300, Ease.linearOut, Handler.create(this, endSettlement));
                        consumeNum_82.value = "x" + (ActivityM.instance.actCurrency(GameConst.activity_currency_two) - 1) as String;
                    } else
                    {
                        GameEventDispatch.instance.event(GameEvent.MsgTipContent, "道具不足");
                    }
                } else
                {
                    if (chooseFlyBtn != faSheGrade && isClick)
                    {
                        faSheGrade = grade;
                    }
                }
            } else
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "游戏已结束")
            }
        }

        private function refreshRankList():void
        {
            hitBalloonArr = ActivityM.instance.getHitBalloonArr(chooseFlyBtn);
            for (var i:int = 0; i < balloonArr.length; i++)
            {
                balloonArr[i].visible = true;
                if (hitBalloonArr.length > 0 && hitBalloonArr.indexOf(i + 1) >= 0)
                {
                    balloonArr[i].visible = false;
                }
            }
            var config = ActivityM.instance.getChooseFlyRankList(chooseFlyBtn)
            var gameData = ActivityM.instance._getCommonActivityConfig(GameConst.activity_common_rankactivity);
            var range:Array = gameData["settle"]["8" + chooseFlyBtn];

            for (var i:int = 0; i < range.length; i++)
            {
                var label:Label = detailBox.getChildByName("detail_" + i) as Label;
                label.text = GameTools.getCoinStr(range[i][1])
            }
            if (config.score != null)
            {
                myselfIntegral.text = config.score + "";
            } else
            {
                myselfIntegral.text = "0";
            }
            ActivityM.instance.rankRewards = gameData["rank_award"]["8" + chooseFlyBtn];
            if (ActivityM.instance.unifiedBalloonRanking(config.rank) != "undefined")
            {
                myselfRank.text = ActivityM.instance.unifiedBalloonRanking(config.rank);
            } else
            {
                myselfRank.text = "未进入排名";
            }

            if (config.rank_arr.length > 0)
            {
                rankList.array = config.rank_arr;
            } else
            {
                rankList.array = null;
            }
        }

        private function onReturnAccountBtn():void
        {
            returnAccountBtn.visible = false;
            closeAccountBox.visible = false;
            close_btn.visible = true;
            refreshRankList();
            initFlyDartsStates();
        }

        private function openCloseAccountBox(res:*):void
        {
            returnAccountBtn.visible = true;
            closeAccountBox.visible = true;
            close_btn.visible = false;
            endScore.value = res.unit_score + "";
            rankLabel.text = res.rank + ""
            rewardImg.skin = cfg_goods.instance(res.reward_item_ids).icon
            rewardText.text = res.reward_item_nums[0] + "";
            scorestLabel.text = "本场最高得分" + res.max_score;
        }

        private function onCloseAccountBtn():void
        {
            if (ActivityM.instance.isShowRankActivity)
            {
                hitBalloonArr = ActivityM.instance.getHitBalloonArr(chooseFlyBtn);
                if (hitBalloonArr.length > 0)
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "结算")
                    var id:Number = ("8" + chooseFlyBtn) as Number
                    WebSocketManager.instance.send(40018, {type: id})
                } else
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "没有可领取的奖励")
                }
            } else
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "游戏已结束")
            }
        }

        private function calculateFlightPath(rotation:Number):void
        {
            for (var i:int = 0; i < hitRange.length; i++)
            {
                var item = hitRange[i];
                if (item[0] <= rotation && rotation <= item[1])
                {
                    hitAirBalloon = i + 1;
                    endY = 70;
                    isHitTarget = true;
                    break;
                }
            }
            var rot:Number = 90 - Math.abs(rotation);
            var sanJiaoY:Number = darts.height * 0.8 * GameTools.CalSinBySheet(rot);
            var sanJiaoX:Number = darts.height * 0.8 * GameTools.CalCosBySheet(rot);
            var k:Number = (darts.y - endY) / sanJiaoY;
            if (rotation >= 0)
            {
                endX = darts.x + (sanJiaoX * k);
                if (!isHitTarget && (endX + sanJiaoX) > 540)
                {
                    endX = 540 - sanJiaoX;
                    k = (endX - darts.x) / sanJiaoX;
                    endY = darts.y - (k * sanJiaoY);
                }
            } else
            {
                endX = darts.x - (sanJiaoX * k);
                if (!isHitTarget && (endX - sanJiaoX) < 0)
                {
                    endX = 0 + sanJiaoX;
                    k = (darts.x - endX) / sanJiaoX;
                    endY = darts.y - (k * sanJiaoY);
                }
            }
            if (hitBalloonArr.indexOf(hitAirBalloon) >= 0)
            {
                isHitTarget = false;
            }
            var id:Number = ("8" + faSheGrade) as Number
            WebSocketManager.instance.send(40016, {type: id, isHit: isHitTarget, seat: hitAirBalloon});
        }

        private function endSettlement():void
        {
            if (isHitTarget)
            {
                balloonArr[hitAirBalloon - 1].visible = false;
                if (hitBalloonArr.length < (balloonLimit - 1))
                {
                    hitAirBalloon = 0;
                    isHitTarget = false;
                    isClick = true;
                    endY = 70;
                    darts.x = startX;
                    darts.y = startY;
                    Laya.timer.loop(1, this, startFlyDarts);
                } else
                {
                    //结算
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "结算")
                    var id:Number = ("8" + faSheGrade) as Number
                    WebSocketManager.instance.send(40018, {type: id})
                }

            } else//未打中结算
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "结算")
                var id:Number = ("8" + faSheGrade) as Number
                WebSocketManager.instance.send(40018, {type: id})
            }
        }


        private function refreshAct():void
        {
            rewardFlush();
            list_sign.refresh();
        }

        private function refreshTime():void
        {
            list1.refresh();
        }

        private function exchange(data:Number):void
        {
            WebSocketManager.instance.send(40010, {id: data})
        }

        private function onCloseBox():void
        {
            returnMainBtn.visible = false;
            close_btn.visible = true;
            convertBox.visible = false;
        }

        private function onClose():void
        {
            UiManager.instance.closePanel("UseTicket", false);
        }

        private function screenResize():void
        {
            var contentWidth:int = 600;//组件范围width
            var contentHeight:int = 400;//组件范围height
            var contentStartX:int = 340;//组件左边距
            var contentStartY:int = 160;//组件上边距
            var posXOff:Number = (Laya.stage.width - contentWidth) / 2;
            var posYOff:Number = (Laya.stage.height - contentHeight) / 2;
            this.pos(_startX + posXOff - contentStartX, _startY + posYOff - contentStartY);
            this.size(Laya.stage.width, Laya.stage.height);

            returnMainBtn.left = contentStartX - posXOff;
            returnMainBtn.top = contentStartY - posYOff;
            close_btn.left = contentStartX - posXOff;
            close_btn.top = contentStartY - posYOff;
        }

        private function syncActivityData()
        {
            if (!ActivityM.instance.isShowShopRebate)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "活动已结束")
                onClose()
            }
        }

        //注册消息发送事件
        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.on(GameEvent.CloseAccount, this, openCloseAccountBox);
            GameEventDispatch.instance.on(GameEvent.ActRegister, this, refreshAct);
            GameEventDispatch.instance.on(GameEvent.ActCurrency, this, initCur);
            GameEventDispatch.instance.on(GameEvent.ActCdk, this, refreshActCdk);
            GameEventDispatch.instance.on(GameEvent.ExchangeTime, this, refreshTime)
            GameEventDispatch.instance.on(GameEvent.ExchangeInterval, this, refreshTime)
            GameEventDispatch.instance.on(GameEvent.UpdFesDailyGift, this, updDailyGiftBox)
            GameEventDispatch.instance.on(GameEvent.SyncActivityData, this, syncActivityData)
        }

        //取消注册的消息发送事件
        public function unRegister():void
        {
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.off(GameEvent.CloseAccount, this, openCloseAccountBox);
            GameEventDispatch.instance.off(GameEvent.ActRegister, this, refreshAct);
            GameEventDispatch.instance.off(GameEvent.ActCurrency, this, initCur);
            GameEventDispatch.instance.off(GameEvent.ActCdk, this, refreshActCdk);
            GameEventDispatch.instance.off(GameEvent.ExchangeTime, this, refreshTime)
            GameEventDispatch.instance.off(GameEvent.ExchangeInterval, this, refreshTime)
            GameEventDispatch.instance.off(GameEvent.UpdFesDailyGift, this, updDailyGiftBox)
            GameEventDispatch.instance.off(GameEvent.SyncActivityData, this, syncActivityData)
        }
    }
}
