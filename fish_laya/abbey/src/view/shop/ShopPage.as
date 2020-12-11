package view.shop
{

    import conf.cfg_global;

    import control.ShopC;
    import control.WxC;

    import engine.analysis.BuriedManager;
    import engine.analysis.BuriedTypes;

    import laya.display.Sprite;
    import laya.utils.Browser;

    import model.ActivityM;
    import model.AdM;
    import model.CertificationM;
    import model.LoginInfoM;
    import model.RoleInfoM;
    import model.RuleM;

    import conf.cfg_commodity;
    import conf.cfg_goods;

    import emurs.ShowType;

    import laya.display.Text;
    import laya.events.Event;
    import laya.ui.Box;
    import laya.ui.Button;
    import laya.ui.FontClip;
    import laya.ui.Image;
    import laya.ui.Label;
    import laya.utils.Browser;
    import laya.utils.Handler;

    import manager.ConfigManager;
    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;
    import manager.WebSocketManager;

    import proto.S2c_14006;

    import struct.CertificationInfo;

    import struct.QuitTipInfo;

    import ui.abbey.ShopPageUI;

    public class ShopPage extends ShopPageUI implements ResVo
    {


        private var _startX:Number = 0;
        private var _startY:Number = 0;
        private var giftUserId:Number = null;
        private var shop_uid:String;

        public function ShopPage()
        {
        }


        public function StartGames(parm:Object = null):void
        {
            if (WxC.isInMiniGame())
            {
                ShopC.instance.sendSyncMiniBalance()
            }

            this.hitTestPrior = false;
            bmask.on(Event.CLICK, this, null)
            _startX = this.x;
            _startY = this.y;
            quitBtn.on(Event.CLICK, this, onQuitBtnClick);
            list1.renderHandler = new Handler(this, updateItem);
            list_card.renderHandler = new Handler(this, updateCardItem);
            list_card.hScrollBarSkin = ""

            tab_coin.on(Event.CLICK, this, onTabCoinClick);
            tab_diamond.on(Event.CLICK, this, onTabDiamondClick);
            tab_skin.on(Event.CLICK, this, onTabSkinClick);
            tab_package.on(Event.CLICK, this, onTabPackageClick);


            if (WxC.isMiniLayout())
            {
                tab_extra.visible = false
                tab_mini.visible = true
                tab_mini.on(Event.CLICK, this, onTabMiniClick);

                boxYuanbao.visible = true
            } else
            {
                tab_extra.visible = true
                tab_mini.visible = false

                boxYuanbao.visible = false
            }


            onSelect(parm)();
            updateProfile();
            showRedPoint()
            shop_uid = genShopUid()
            screenResize();
        }

        public function genShopUid():String
        {
            var ts:String = new Date().getTime() + ""

            return ts + 1000 + Math.floor(Math.random() * 8999) + ""
        }

        private function onTabCoinClick()
        {
            onRefresh('tab_coin')
        }

        private function onTabDiamondClick()
        {
            onRefresh('tab_diamond')
        }

        private function onTabSkinClick()
        {
            onRefresh('tab_skin')
        }

        private function onTabPackageClick()
        {
            onRefresh('tab_package')
        }

        private function onTabMiniClick()
        {
            onRefresh('tab_mini')
        }

        private function selectTab(tab_name)
        {
            var dic:Object;
            if (WxC.isInMiniGame())
            {
                dic = {
                    tab_skin: tab_skin,
                    tab_diamond: tab_diamond,
                    tab_coin: tab_coin,
                    tab_package: tab_package,
                    tab_mini: tab_mini
                }
            } else
            {
                dic = {
                    tab_skin: tab_skin,
                    tab_diamond: tab_diamond,
                    tab_coin: tab_coin,
                    tab_package: tab_package
                }
            }
            clearSelect()
            var target:Object = dic[tab_name];
            if (target == null)
            {
                return;
            }
            target.selected = true;

        }

        private function clearSelect()
        {
            if (WxC.isInMiniGame())
            {
                tab_mini.selected = false;
            }

            tab_coin.selected = false;
            tab_diamond.selected = false;
            tab_skin.selected = false;
            tab_package.selected = false;
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


            quitBtn.left = contentStartX - posXOff;
            quitBtn.top = contentStartY - posYOff;
        }

        function is_show_month_card(item:cfg_commodity)
        {
            if (RoleInfoM.instance.haveValidMonthCard())
            {
                if (item.card_type == 1)
                {
                    return true
                } else
                {
                    return true

                    if (RoleInfoM.instance.getMonthCard()[item.id])
                    {
                        return !RoleInfoM.instance.getMonthCard()[item.id].is_expired
                    }
                }
            } else
            {
                return item.card_type == 0
            }
        }

        function need_show_single_item(item:cfg_commodity)
        {
            if (item.is_single_buy == 1)
            {
                return RoleInfoM.instance.getPurchasedItems().indexOf(item.id) < 0
            } else
            {
                return true;
            }

        }

        private var adItemId:Number = 23245255;

        private function onSelect(tab_name:String)
        {
            import model.RoleInfoM;

            var os:Number = Browser.onIOS ? 1 : Browser.onAndroid ? 2 : 3
            return function ()
            {
                selectTab(tab_name)

                list1.visible = true;
                list_card.visible = false;
                if (tab_name == "tab_skin")
                {
                    var skins:Array = RoleInfoM.instance.getSkins();
                    list1.array = ConfigManager.filter("cfg_commodity", function (item:cfg_commodity)
                    {
                        if (item.activity == GameConst.activity_worldcup)
                        {
                            if (ActivityM.instance.worldCupActivityBatteryCanBuy() && skins.indexOf(item.item_id) < 0)
                            {
                                return item.os == os
                            } else
                            {
                                return false
                            }
                        } else
                        {
                            return item.tab == "tab_skin" && skins.indexOf(item.item_id) < 0 && need_show_single_item(item) && item.os == os

                        }
                    })
                } else if (tab_name == "tab_coin")
                {
                    var cfgs:Array = ConfigManager.filter("cfg_commodity", function (item:cfg_commodity)
                    {
                        return item.tab == GameConst.shop_tab_coin && need_show_single_item(item) && item.os == os
                    })
                    if (ENV.isShowBannerAndAD() && WxC.compareVersion(WxC.wxSDKVersion, GameConst.wxSDKVersion) >= 0)
                    {
                        var cfg:cfg_commodity = new cfg_commodity()

                        var cfg_g:cfg_global = cfg_global.instance(1)
                        cfg.img = "ui/common/coin2.png"
                        cfg.item_label = cfg_g.watchAdRewardNums[0] + "金币"//
                        cfg.id = adItemId
                        cfg.extra_item_count = 1
                        cfg.extra_item_text = "观看视频即可领取"
                        cfg.mini_currency_amount = cfg_g.watchAdRewardNums[0]
                        cfg.mini_currency_id = 1
                        cfgs.unshift(cfg)
                    }
                    list1.array = cfgs
                } else if (tab_name == "tab_package")
                {
                    list1.visible = false;
                    list_card.visible = true;
                    list_card.array = ConfigManager.filter("cfg_commodity",
                            function (item:cfg_commodity)
                            {
                                return item.tab == "tab_package" && need_show_single_item(item) && is_show_month_card(item) && item.os == os
                            })
                } else if (tab_name == "tab_diamond")
                {
                    list1.array = ConfigManager.filter("cfg_commodity", function (item:cfg_commodity)
                    {
                        return item.tab == "tab_diamond" && need_show_single_item(item) && item.os == os
                    })
                } else if (tab_name == "tab_mini")
                {
                    list1.array = ConfigManager.filter("cfg_commodity", function (item:cfg_commodity)
                    {
                        return item.tab == "tab_mini" && need_show_single_item(item) && item.os == os
                    })
                }
            }

        }

        private function updateItemReward(cell:Box, index:int):void
        {
            var ele_reward_img = cell.getChildByName("reward_type");
            var ele_reward_text = cell.getChildByName("reward_text");

            var data = cell.dataSource

            ele_reward_img.skin = cfg_goods.instance(data.reward_item_id + "").icon;
            ele_reward_text.text = 'x ' + data.reward_item_num;


        }

        private function updateCardItem(cell:Box, index:int):void
        {
            var config:cfg_commodity = cell.dataSource;

            var dic:Object = {
                1: {price_unit: "ui/common_ex/unit_coin.png", unit: "金币"},
                4: {price_unit: "ui/common_ex/unit_diamond.png", unit: "钻石"},
                5: {price_unit: "ui/common_ex/unit_rmb.png", unit: "人民币"},
                100: {price_unit: "ui/common/icon_yuanbao.png", unit: "集结币"}
            }

            var currency_id:Number;
            if (WxC.isInMiniGame())
            {
                currency_id = config.mini_currency_id;
            } else
            {
                currency_id = config.currency_id;
            }

            var ele_price = cell.getChildByName("price")
            var ele_price_unit = cell.getChildByName("price_unit")
            var ele_accept = cell.getChildByName("accept")
            var ele_remaining = cell.getChildByName("remain_day")
            var ele_btn = cell.getChildByName("btn")

            var ele_txt:Label = cell.getChildByName("txt") as Label
            //公共活动 商店产出系统
            var common_img:Image = cell.getChildByName("common") as Image
            var common_num:FontClip = common_img.getChildByName("common_num") as FontClip

            ele_btn.offAll(Event.CLICK);
            if (WxC.isInMiniGame())
            {
                ele_price.value = Math.ceil(config.mini_currency_amount / LoginInfoM.instance.getShopRate());
            } else
            {
                ele_price.value = Math.ceil(config.currency_amount / LoginInfoM.instance.getShopRate());
            }
            cell.getChildByName("card_title").skin = config.card_title;
            var list_reward = cell.getChildByName("list_reward");


            var month_card = RoleInfoM.instance.getMonthCard();
            var card:Object = null
            if(config.id == 18 || config.id == 1016 || config.id == 2016)
            {
                card = month_card[18]?month_card[18]:null
            }


            ele_accept.visible = false;
            ele_remaining.visible = false;
            ele_price.visible = false;
            ele_price_unit.visible = false;

            var obj:Object = ActivityM.instance._getCommonActivityConfig(GameConst.activity_common_shop)
            var shop_extra:Object = null;
            if (obj)
            {
                shop_extra = obj["month_card_daily_extra"]
            }
            if (ActivityM.instance.isShowShopRebate && shop_extra && shop_extra.length > 1)
            {
                ele_txt.visible = true
                if (config.id == 18)
                {
                    ele_txt.visible = false
                    common_img.visible = true
                    common_img.skin = cfg_goods.instance(shop_extra[0] + "").icon
                    common_num.value = "x " + shop_extra[1];
                } else
                {
                    common_img.visible = false
                    ele_txt.text = "活动期间每天送活动券*" + shop_extra[1];
                }
            } else
            {
                common_img.visible = false
                ele_txt.text = config.card_detail;
            }
            var have_buy:Boolean = false;
            if (!card)
            {

                ele_price.visible = true;
                ele_price_unit.visible = true;
                ele_price_unit.skin = dic[currency_id].price_unit;

                ele_btn.on(Event.CLICK, this, function ()
                {
                    if (WxC.isInMiniGame())
                    {
                        if (RoleInfoM.instance.mini_balance >= config.mini_currency_amount)
                        {
                            if (config.card_type == 1)
                            {
                                GameEventDispatch.instance.event(GameEvent.ShopBuy, config);
                            } else
                            {
                                UiManager.instance.closePanel("Shop", false);
                                UiManager.instance.loadView("MonthCard", {"id": config.id}, ShowType.SMALL_TO_BIG);
                            }
                        } else
                        {
                            if (Browser.onIOS)
                            {
                                ele_btn.on(Event.CLICK, this, function ()
                                        {
                                            GameEventDispatch.instance.event(GameEvent.MsgTip, 47);
                                        }
                                )

                            } else
                            {
                                if (config.card_type == 1)
                                {
                                    GameEventDispatch.instance.event(GameEvent.ShopBuy, config);
                                } else
                                {
                                    UiManager.instance.closePanel("Shop", false);
                                    UiManager.instance.loadView("MonthCard", {"id": config.id}, ShowType.SMALL_TO_BIG);
                                }
                            }
                        }
                    } else
                    {
                        UiManager.instance.closePanel("Shop", false);
                        UiManager.instance.loadView("MonthCard", {"id": config.id}, ShowType.SMALL_TO_BIG);
                    }
                })
            } else
            {
                if (card.can_accept)
                {
                    ele_accept.visible = true;
                    ele_btn.on(Event.CLICK, this, onAcceptMonthCardReward(config))
                    have_buy = true;
                } else if (!card.is_expired)
                {
                    ele_remaining.visible = true;
                    ele_remaining.text = "还剩余" + card.left + "天"
                    have_buy = true;
                } else
                {
                    ele_price.visible = true;
                    ele_price_unit.visible = true;


                    ele_btn.on(Event.CLICK, this, function ()
                            {
                                UiManager.instance.closePanel("Shop", false);
                                UiManager.instance.loadView("MonthCard", {"id": config.id}, ShowType.SMALL_TO_BIG);
                            }
                    )
                }

            }
            list_reward.renderHandler = new Handler(this, updateItemReward);
            if (have_buy)
            {
                var rewards = []
                for (var i = 0; i < config.good_ids.length; i++)
                {
                    rewards.push({
                        reward_item_id: config.good_ids[i],
                        reward_item_num: config.good_nums[i]
                    })
                }

                list_reward.array = rewards

            } else
            {
                var rewards = []
                for (var i = 0; i < config.good_ids.length; i++)
                {
                    rewards.push({
                        reward_item_id: config.good_ids[i],
                        reward_item_num: config.good_nums[i]
                    })
                }
                list_reward.array = rewards
            }
            if (rewards.length == 1)
            {
                list_reward.pivotX = -50;
            } else
            {
                list_reward.pivotX = 0
            }
        }

        //        商店活动额外奖励
        private function updateActivitySide(cell:Box):void
        {
            var config:cfg_commodity = cell.dataSource;

            //鱼类活动
            var bomb_img:Image = cell.getChildByName("bomb") as Image
            var bomb_num:FontClip = bomb_img.getChildByName("bomb_num") as FontClip

            var bombGift:Array = ActivityM.instance.getShopExtraArrByShopId(config.id, GameConst.activity_bomb) as Array;
            if (bombGift && ActivityM.instance.activityIsActive(GameConst.activity_bomb))
            {
                bomb_img.visible = true
                bomb_img.skin = cfg_goods.instance(bombGift[0] + "").icon
                bomb_num.value = "x " + bombGift[1];
            } else
            {
                bomb_img.visible = false
            }

            //福利活动
            var bonus_img:Image = cell.getChildByName("bonus") as Image
            var bonus_num:FontClip = bonus_img.getChildByName("bonus_num") as FontClip
            var giftArr:Array = ActivityM.instance.getShopExtraArrByShopId(config.id, GameConst.activity_bonus) as Array;
            if (giftArr && ActivityM.instance.activityIsActive(GameConst.activity_bonus))
            {
                bonus_img.visible = true
                bonus_img.skin = cfg_goods.instance(giftArr[0] + "").icon
                bonus_num.value = "x " + giftArr[1];
            } else
            {
                bonus_img.visible = false
            }

            //世界杯活动
            var activity_img:Image = cell.getChildByName("activity") as Image
            var activity_num:FontClip = activity_img.getChildByName("activity_num") as FontClip

            var giftArr:Array = ActivityM.instance.getShopExtraArrByShopId(config.id, GameConst.activity_worldcup) as Array;
            if (giftArr && ActivityM.instance.activityIsActive(GameConst.activity_worldcup))
            {
                activity_img.visible = true
                activity_img.skin = cfg_goods.instance(giftArr[0] + "").icon
                activity_num.value = "x " + giftArr[1];
            } else
            {
                activity_img.visible = false
            }

            //公共活动 商店产出系统
            var common_img:Image = cell.getChildByName("common") as Image
            var common_num:FontClip = common_img.getChildByName("common_num") as FontClip

            var giftArr:Array = ActivityM.instance.getShopExtraArrByShopId(config.id, GameConst.activity_common) as Array;
            if (giftArr && ActivityM.instance.isShowShopRebate)
            {
                common_img.visible = true
                common_img.skin = cfg_goods.instance(giftArr[0] + "").icon
                common_num.value = "x " + giftArr[1];
            } else
            {
                common_img.visible = false
            }
        }

        private function updateShopBuyBtn(cell:Box):void
        {
            var config:cfg_commodity = cell.dataSource;

            var ele_buy_btn:Button = cell.getChildByName("btn") as Button;
            ele_buy_btn.offAll(Event.CLICK);

            var can_buy:Boolean = true
            if (config.activity == GameConst.activity_worldcup)
            {
                can_buy = ActivityM.instance.worldCupActivityBatteryCanBuy()
            } else
            {
                can_buy = true
            }

            if (!can_buy)
            {
                ele_buy_btn.gray = true
                ele_buy_btn.on(Event.CLICK, this, function ()
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "无法购买");
                })
            } else
            {
                ele_buy_btn.on(Event.CLICK, this, function ()
                        {
                            GameEventDispatch.instance.event(GameEvent.ShopBuy, config)
                            //                                info.confirmCallback = Handler.create(this, function ()
                            //                                {
//                          //                                    BuriedManager.instance.addBuriedData(
                            //                                    BuriedTypes.click_buy_confirm,
                            //                                    {id: config.id, status: 1, shop_uid: shop_uid})
                            //                                });
                            //                                info.cancelCallback = Handler.create(this, function ()
                            //                                {
                            //                                    BuriedManager.instance.addBuriedData(
                            //                                            BuriedTypes.click_buy_cancel,
                            //                                            {id: config.id, status: 1, shop_uid: shop_uid})
                            //                                })

                            BuriedManager.instance.addBuriedData(
                                    BuriedTypes.click_buy,
                                    {id: config.id, status: 1, shop_uid: shop_uid}
                            )
                        }
                )
            }

        }

        private function updateItem(cell:Box, index:int):void
        {
            var config:cfg_commodity = cell.dataSource;
            var dic:Object = {
                1: {price_unit: "ui/common_ex/unit_coin.png", unit: "金币"},
                4: {price_unit: "ui/common_ex/unit_diamond.png", unit: "钻石"},
                5: {price_unit: "ui/common_ex/unit_rmb.png", unit: "人民币"},
                100: {price_unit: "ui/common/icon_yuanbao.png", unit: "集结币"}
            }
            var currency_id:Number;
            if (WxC.isInMiniGame())
            {
                currency_id = config.mini_currency_id;
            } else
            {
                currency_id = config.currency_id;
            }

            var gift_text:Text = cell.getChildByName("gift_text") as Text;
            gift_text.text = "";
            if (RoleInfoM.instance.getPurchasedItems().indexOf(config.id) > 0)
            {
                if (config.extra_item_count > 0)
                {
                    gift_text.text = config.extra_item_text;
                } else
                {
                    gift_text.text = ""
                }
            } else
            {
                if (config.first_buy_gift_count > 0)
                {
                    gift_text.text = config.first_buy_text;
                } else if (config.extra_item_count > 0)
                {
                    gift_text.text = config.extra_item_text;
                } else
                {
                    gift_text.text = ""
                }
            }

            var price_text:Label = cell.getChildByName("price_text") as Label
            var ad_times:Label = cell.getChildByName("ad_times") as Label
            var price_unit:Image = cell.getChildByName("price_unit") as Image
            var price:FontClip = cell.getChildByName("price") as FontClip
            var bg_img:Image = cell.getChildByName("bg") as Image

            price_text.text = config.item_label
            if (ENV.channelType == GameConst.public_no_id_ljby)
            {
                price_text.text = price_text.text.replace("集结币", "元宝");
            }

            price_unit.skin = dic[currency_id].price_unit;

            var goodsPrice = Math.ceil(config.currency_amount / LoginInfoM.instance.getShopRate())
            if (goodsPrice > 1000000)
            {
                price.value = (Number(goodsPrice) / 10000) + "万"
            } else
            {
                price.value = goodsPrice + ""
            }

            //活动奖励处理
            updateActivitySide(cell)

            ad_times.visible = false
            price_unit.visible = false
            price.visible = false
            //广告ID写死

            var isAddItem = config.id == adItemId
            if (isAddItem)
            {
                bg_img.skin = "ui/shop/bg_ad.png"
                ad_times.visible = true
                ad_times.text = "领取(" + AdM.instance.watch_times + "/" + AdM.instance.total_times + ")"
            } else
            {
                bg_img.skin = "ui/shop/item_bg.png"
                price_unit.visible = true
                price.visible = true
            }

            var ele_img:Image = cell.getChildByName("img") as Image
            ele_img.skin = config.img

            var side_img:Image = cell.getChildByName("side") as Image
            if (config.sidebar_img)
            {
                side_img.visible = true;
                side_img.skin = config.sidebar_img;
            } else
            {
                side_img.visible = false;
            }

            cell.offAll(Event.CLICK);

            if (isAddItem)
            {
                updateAdShowBtn(cell)
            } else
            {

                //            购买按钮处理
                updateShopBuyBtn(cell)
            }
        }

        public function updateAdShowBtn(cell:Box):void
        {

            var ele_buy_btn:Button = cell.getChildByName("btn") as Button;
            ele_buy_btn.offAll(Event.CLICK)
            ele_buy_btn.on(Event.CLICK, this, onShowAdClick)
        }


        public function onShowAdClick():void
        {
            if (AdM.instance.watch_times >= AdM.instance.total_times)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "今日观看次数已到达上线，请明日再来");
            } else
            {
                if (WxC.isInMiniGame())
                {
                    WxC.instance.showVideoAD()
                }
            }
        }

        private function onAcceptMonthCardReward(record):Object
        {
            return function ():void
            {
                var a:S2c_14006 = new S2c_14006();
                a.id = record.id;

                WebSocketManager.instance.send(14006, a);
            }
        }

        private function onQuitBtnClick()
        {
            UiManager.instance.closePanel("Shop", true);
        }

        private function updateProfile()
        {

            var coin:String = (RoleInfoM.instance.getCoin() - RuleM.instance.coinCount + RoleInfoM.instance.getBindCoin()) + "";
            var diamond:String = RoleInfoM.instance.getDiamond() + "";

            coin_value.value = coin;
            diamond_value.value = diamond;
            updateMiniBalance()

            if (coin.length > 10 || diamond.length > 10)
            {
                var scale:Number = 0.8;
                coin_value.scale(scale, scale);
                diamond_value.scale(scale, scale);
            } else
            {
                coin_value.scale(1, 1)
                diamond_value.scale(1, 1)
            }


        }

        private function onRefresh(tab_name:String)
        {
            if (tab_name)
            {
                onSelect(tab_name)()
            } else
            {
                list1.refresh()
                list_card.refresh()
            }

        }

        private function refreshMonthCard():void
        {
            list_card.refresh();
        }


        private function addRedPointToIcon(target, x, y, click_once = false):void
        {
            var img = new Image();
            img.name = "red_point"
            img.skin = "ui/common_ex/red_point.png"

            img.x = target.width * x
            img.y = y
            target.addChild(img);
            if (click_once)
            {
                target.once(Event.CLICK, target, function ()
                {
                    removeRedPoint(target)
                })
            }
        }

        private function removeRedPoint(target:Sprite):void
        {
            target.removeChildByName("red_point")
        }

        private function showRedPoint():void
        {
            var red_points = RoleInfoM.instance.getRedPoints()

            if (GameConst.point_month_card & red_points)
            {
                addRedPointToIcon(tab_package, 0.9, 6, false)
            } else
            {
                removeRedPoint(tab_package)
            }

        }

        private function updateMiniBalance():void
        {
            if (WxC.isInMiniGame())
                mini_balance.value = RoleInfoM.instance.mini_balance + "";
        }

        public function onSyncADInfo():void
        {
            list1.refresh()
        }

        public function unRegister():void
        {
            GameEventDispatch.instance.off(GameEvent.UpdateMiniBalance, this, updateMiniBalance);
            GameEventDispatch.instance.off(GameEvent.UpdateProfile, this, updateProfile);
            GameEventDispatch.instance.off(GameEvent.ShopRefresh, this, onRefresh);
            GameEventDispatch.instance.off(GameEvent.MonthCardUpdate, this, refreshMonthCard);
            GameEventDispatch.instance.off(GameEvent.ShowRedPoint, this, showRedPoint);
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.off(GameEvent.OnSyncAdWatchRemainTimes, this, onSyncADInfo);
        }


        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.UpdateMiniBalance, this, updateMiniBalance);
            GameEventDispatch.instance.on(GameEvent.UpdateProfile, this, updateProfile);
            GameEventDispatch.instance.on(GameEvent.ShopRefresh, this, onRefresh);
            GameEventDispatch.instance.on(GameEvent.MonthCardUpdate, this, refreshMonthCard);
            GameEventDispatch.instance.on(GameEvent.ShowRedPoint, this, showRedPoint);
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.on(GameEvent.OnSyncAdWatchRemainTimes, this, onSyncADInfo);
        }


    }
}
