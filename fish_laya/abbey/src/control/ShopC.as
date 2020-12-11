package control
{


    import conf.cfg_goods;

    import engine.tool.StartParam;

    import laya.utils.Handler;

    import manager.ApiManager;

    import manager.GameTools;

    import model.ExchangeM;

    import model.LoginInfoM;
    import model.RoleInfoM;

    import conf.cfg_commodity;
    import conf.cfg_first_charge;

    import emurs.ShowType;

    import laya.utils.Browser;

    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.UiManager;
    import manager.WebSocketManager;

    import model.ShopM;

    import proto.C2s_13003;
    import proto.C2s_14000;
    import proto.C2s_14031;

    import view.shop.Shop;

    public class ShopC
    {
        private static var _instance:ShopC;
        private var appPayCheckCount:Number = 0;
        private var appPayOrder:String = "";
        private var buyGoodsCfg:cfg_commodity;


        public function ShopC()
        {
            GameEventDispatch.instance.on(GameEvent.Shop, this, openShop);
            GameEventDispatch.instance.on(GameEvent.ChangeSkin, this, changeSkin);
            GameEventDispatch.instance.on(GameEvent.AppPaySuccess, this, appPaySuccess);

            GameEventDispatch.instance.on(GameEvent.ShopBuy, this, buy);
            GameEventDispatch.instance.on(String(13005), this, updateSkins);
            GameEventDispatch.instance.on(String(14007), this, finishAcceptMonthCardReward);

            GameEventDispatch.instance.on(String(14009), this, finishAcceptMonthCardReward);
            //            GameEventDispatch.instance.on(String(14010), this, buyJump);
            GameEventDispatch.instance.on(String(14011), this, buySuccess);

            GameEventDispatch.instance.on(String(14003), this, endChargeReward);
            //兑换
            GameEventDispatch.instance.on(String(14015), this, endExchange);
            GameEventDispatch.instance.on(String(14016), this, syncExchange);


            GameEventDispatch.instance.on(String(14023), this, syncMiniBalance);
            GameEventDispatch.instance.on(String(14021), this, syncActivityTicket);

            GameEventDispatch.instance.on(String(14018), this, endGift);
            GameEventDispatch.instance.on(String(14020), this, endConfirmGift);
            GameEventDispatch.instance.on(String(14030), this, showRewardTip);
            GameEventDispatch.instance.on(String(14029), this, endUseMonthCard);
            GameEventDispatch.instance.on(String(14032), this, appOrderCheckRet);
            GameEventDispatch.instance.on(String(14061), this, endSync360UserInfo);


            //            GameEventDispatch.instance.on(String(14025), this, onEndMiniShopBuy);

        }

        //        public function onEndMiniShopBuy(data:*):void
        //        {
        //            if (0 == data.code)
        //            {
        //                GameEventDispatch.instance.event(GameEvent.ShopRefresh, "");
        //            }
        //        }
        public function endSync360UserInfo():void
        {
            GameEventDispatch.instance.event(GameEvent.UpdateProfile);
        }

        public function showRewardTip(data:*):void
        {
            GameEventDispatch.instance.event(GameEvent.RewardTip, [data.reward_item_ids, data.reward_item_nums])
        }

        public function endUseMonthCard(data:*):void
        {
            if (0 == data.code)
            {

                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "使用成功");
                GameEventDispatch.instance.event(GameEvent.EndUseMonthCard);

            } else if (1 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "参数错误");
            } else if (2 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "该道具不可使用");
            } else if (3 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "该道具不可使用");
            } else if (4 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "月卡道具不足");
            } else
            {
                GameTools.dealCode(data.code)
            }
        }

        public function endConfirmGift(data:*):void
        {
            if (0 == data.code)
            {
                if (data.reward_item_ids)
                {
                    GameEventDispatch.instance.event(GameEvent.RewardTip, [data.reward_item_ids, data.reward_item_nums]);
                }
                GameEventDispatch.instance.event(GameEvent.GiftConfirmFinish, data);
            } else if (1 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "重复领取");
            } else if (2 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "操作失败");
            } else
            {
                GameTools.dealCode(data.code)
            }
        }

        public function endGift(data:*):void
        {
            if (0 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "赠送成功");
                GameEventDispatch.instance.event(GameEvent.GiftFinish, data);
            } else if (1 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "道具不足");
            } else if (2 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "不能赠送给自己");
            } else if (3 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "该道具不能赠送");
            } else if (5 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTip, 46);
            } else if (6 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "激活月卡，开放赠送功能");
            } else if (7 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "解锁炮台，开放赠送功能");
            } else
            {
                GameTools.dealCode(data.code)
            }
        }


        public function endExchange(data:*):void
        {
            if (0 == data.code)
            {
                if (data['result'])
                {
                    var type = data.result["data"].type;
                    if (type == "red_pack")
                    {
                        if (ExchangeM.instance.curSelect == 1)
                        {
                            GameEventDispatch.instance.event(GameEvent.MsgTipContent, {
                                str: "兑换成功,请前往《集结号捕鱼H5》公众号,领取福袋",
                                time: 1500
                            })
                        } else if (ExchangeM.instance.curSelect == 2)
                        {
                            GameEventDispatch.instance.event(GameEvent.MsgTipContent, {
                                str: "兑换成功,请前往《集结号福袋》小程序,领取福袋",
                                time: 1500
                            })
                        }
                    } else if (type == "pf_score")
                    {
                        var commodityNum = parseInt(data.result["data"].item_num)
                        var curNum = parseInt(data.result["data"].new_pf_score)
                        GameEventDispatch.instance.event(GameEvent.MsgTipContent, {
                            str: commodityNum + "积分兑换成功，当前剩余总积分" + curNum,
                            time: 1500
                        });
                        GameEventDispatch.instance.event(GameEvent.ExchangeFinish, null);
                    } else
                    {
                        if (data.is_show)
                        {
                            GameEventDispatch.instance.event(GameEvent.RewardTip, [data.reward_item_ids, data.reward_item_nums]);
                        }
                        GameEventDispatch.instance.event(GameEvent.ExchangeFinish, data);
                    }
                } else
                {
                    GameEventDispatch.instance.event(GameEvent.ExchangeFinish, data);
                }
            } else if (1 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "珍珠不足");
            } else if (2 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "库存不足");
            } else if (3 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "金币不足");
            } else if (4 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "参数错误");
            } else if (5 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "商品兑换时间已结束");
            } else if (6 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "更新库存失败");
            } else if (8 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "用户数据错误");
            } else if (9 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "珍珠兑换失败,请稍后重试");
            } else if (10 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "兑换超过限制");
            } else if (11 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "珍珠兑换失败,请稍后重试");
            } else if (13 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "该账号存在风险，已被微信拦截");
            } else if (14 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "您已达到上限");
            } else if (15 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请先关注《集结号捕鱼H5》公众号");
            } else if (20 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "系统错误");
            } else if (30 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "账号未绑定");
            } else if (31 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "该渠道兑换已关闭");
            } else if (32 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "兑换红包参数错误");
            }
            //                    福利转转转活动
            else if (100 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "福利转转转活动已结束");
            } else if (101 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "皮肤已经拥有");
            } else if (102 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "您已经兑换过该皮肤");
            } else
            {
                GameTools.dealCode(data.code);
            }
            GameEventDispatch.instance.event(GameEvent.UpdateExchangeBtn)

        }

        public function syncActivityTicket(data:*):void
        {
            var num:Number = data["num"]
            RoleInfoM.instance.activity_ticket = num
            GameEventDispatch.instance.event(GameEvent.UpdateActivityTicket, num);
        }

        public function syncPreferencesPayType(data:*):void
        {
            if (data)
            {
                ExchangeM.instance.payType = data.redpack_type
            }
        }

        public function syncExchange(data:*):void
        {
            var exchange:Number = data["exchange"]
            RoleInfoM.instance.setExchange(exchange);
            GameEventDispatch.instance.event(GameEvent.UpdateExchange, exchange);
        }

        public function sendSyncMiniBalance():void
        {
            WebSocketManager.instance.send(14022, {});
        }

        public function syncGoldExchange(data:*):void
        {
            //TODO
            GameEventDispatch.instance.event(GameEvent.UpdateGoldExchange);
        }

        public function syncMiniBalance(data:*):void
        {
            if (0 == data.code)
            {
                var balance:Number = data["balance"]

                if (data["charge_times"])
                {
                    var chargeTime:Number = data["charge_times"]
                    RoleInfoM.instance.setChargeTimes(chargeTime)
                }

                RoleInfoM.instance.mini_balance = balance;
                GameEventDispatch.instance.event(GameEvent.UpdateMiniBalance, balance);
                GameEventDispatch.instance.event(GameEvent.UpdateFirstCharge);
            } else
            {

            }

        }


        public function endChargeReward(data:*)
        {
            if (0 == data.code)
            {
                RoleInfoM.instance.setFirstChargeRewardAccepted(1);
                //前端屏蔽召唤道具
                var index:Number = data.reward_item_ids.indexOf(23);

                if (index > -1)
                {
                    data.reward_item_ids.splice(index, 1)
                    data.reward_item_nums.splice(index, 1)
                }

                GameEventDispatch.instance.event(GameEvent.RewardTip, [data.reward_item_ids, data.reward_item_nums]);
                GameEventDispatch.instance.event(GameEvent.UpdateFirstCharge);
            } else
            {
                console.log("重复领取")
            }

        }

        /**
         * 是否显示首冲按钮
         * @return
         */
        public function isShowFirstIcon():Boolean
        {
            if (RoleInfoM.instance.getFirstChargeRewardAccepted())
            {
                return false
            } else
            {
                if (RoleInfoM.instance.getLevel() >= cfg_first_charge.instance("1").level)
                {
                    return true
                }
                if (RoleInfoM.instance.getChargeTimes() > 0)
                {
                    return true
                }
                return false
            }
        }


        private function appOrderCheckRet(data:*):void
        {
            if (data.code == 0)
            {
                GameEventDispatch.instance.event(GameEvent.AppOrderCheckOk, null);
                Laya.timer.clear(this, appPayCheck);
            }
        }


        private function appPayCheck():void
        {
            appPayCheckCount++;
            if (appPayCheckCount < 6 && appPayOrder.length > 0)
            {
                var p:C2s_14031 = new C2s_14031();
                p.order_no = appPayOrder;
                WebSocketManager.instance.send(14031, p);
                Laya.timer.once(2000, this, this.appPayCheck);
            }
        }

        private function appPaySuccess(order_no:*):void
        {
            appPayOrder = order_no;
            GameEventDispatch.instance.event(GameEvent.OpenWait);
            appPayCheckCount = 0;
            Laya.timer.once(1000, this, this.appPayCheck);
        }

        //支付跳转
        private function buyJump(data:*):void
        {
            if (data.code == "success")
            {
                if (StartParam.instance.getParam("platform") == GameConst.platform_android_app)
                {
                    var appPayStr:String = JSON.stringify(data.data);
                    __JS__("AndroidInterface.onWXPay(appPayStr)");
                } else if (StartParam.instance.getParam("platform") == GameConst.platform_android_360)
                {
                    var appPayStr:String = JSON.stringify(data.data);
                    __JS__("AndroidInterface.on360Pay(appPayStr)");

                } else if (StartParam.instance.getParam("platform") == GameConst.platform_android_meizu)
                {
                    var appPayStr:String = JSON.stringify(data.data);
                    __JS__("AndroidInterface.onMZPay(appPayStr)");
                } else if (StartParam.instance.getParam("platform") == GameConst.platform_android_baidu)
                {
                    var appPayStr:String = JSON.stringify(data.data);
                    __JS__("AndroidInterface.onBaiduPay(appPayStr)");
                } else if (StartParam.instance.getParam("platform") == GameConst.platform_android_huawei)
                {
                    var appPayStr:String = JSON.stringify(data.data);
                    __JS__("AndroidInterface.onHuaweiPay(appPayStr)");
                } else if (StartParam.instance.getParam("platform") == GameConst.platform_android_yyb)
                {
                    var appPayStr:String = JSON.stringify(data.data);
                    __JS__("AndroidInterface.onYingyongbaoPay(appPayStr)");
                } else if (StartParam.instance.getParam("platform") == GameConst.platform_android_xiaomi)
                {
                    var appPayStr:String = JSON.stringify(data.data);
                    __JS__("AndroidInterface.onXiaomiPay(appPayStr)");
                } else if (StartParam.instance.getParam("platform") == GameConst.platform_android_ali)
                {
                    var appPayStr:String = JSON.stringify(data.data);
                    __JS__("AndroidInterface.onAliPay(appPayStr)");
                } else if (StartParam.instance.getParam("platform") == GameConst.platform_android_quick)
                {

                    var appPayStr:String = JSON.stringify(data.data);
                    __JS__("AndroidInterface.onQuickPay(appPayStr)");
                } else if (StartParam.instance.getParam("platform") == GameConst.platform_yyly)
                {
                    YylyC.pay(data);
                } else if (StartParam.instance.getParam("platform") == GameConst.platform_360)
                {
                    T360C.pay(data.data);
                } else if (StartParam.instance.getParam("platform") == GameConst.platform_yawy)
                {
                    YawyC.pay(data.data);
                } else if (StartParam.instance.getParam("platform") == GameConst.platform_aiqiyi)
                {
                    var win:* = __JS__("window")
                    var arr = [
                        "http://togame.pps.tv",
                        "http://togame.iqiyi.com",
                        "http://playgame.pps.tv",
                        "http://playgame.iqiyi.com",
                        "http://playgame2.iqiyi.com"
                    ]
                    for (var i:Number = 0; i < 5; i++)
                    {
                        var url:String = arr[i]
                        Browser.window.top.postMessage(data.data, url);
                    }
                } else if (StartParam.instance.getParam("platform") == GameConst.platform_cocos)
                {
                    CocosC.pay(data.data)
                } else
                {
                    var url = data.data.url;
                    __JS__("window.top.location.href = url")
                }

            } else if (data.code == "payment_limit")
            {
                GameEventDispatch.instance.event(GameEvent.MsgTip, 37);
            } else if (data.code == "month_payment_limit")
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, data.msg);
            } else
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, data.msg);
            }
        }

        //发放礼物后的信息同步
        private function buySuccess(data:*):void
        {

            if (0 == data.code)
            {
                UiManager.instance.closePanel("BuySelect", false);
                if (!data.tab)
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTip, 6);
                } else
                {
                    if (data.skins)
                    {
                        RoleInfoM.instance.setSkins(data.skins)
                    }
                    if (data.purchased_items)
                    {
                        RoleInfoM.instance.setPurchasedItems(data.purchased_items)
                    }
                    if (data.charge_times)
                    {
                        RoleInfoM.instance.setChargeTimes(data.charge_times)
                    }
                    if (data.charge_total)
                    {
                        RoleInfoM.instance.setChargeTotal(data.charge_total)
                    }
                    if (data.vip_exp)
                    {
                        RoleInfoM.instance.setVipExp(data.vip_exp)
                    }
                    if (data.vip)
                    {
                        RoleInfoM.instance.setVip(data.vip)
                    }
                    if (data.month_card)
                    {
                        RoleInfoM.instance.setMonthCard(data.month_card)
                    }

                    WebSocketManager.instance.send(50001, {})
                    GameEventDispatch.instance.event(GameEvent.MonthCardUpdate);
                    GameEventDispatch.instance.event(GameEvent.UpdateFirstCharge);
                    GameEventDispatch.instance.event(GameEvent.ShopRefresh, data.tab);
                    if (Object.keys(data.reward_item_ids).length !== 0)
                    {
                        GameEventDispatch.instance.event(GameEvent.RewardTip, [data.reward_item_ids, data.reward_item_nums]);
                    }
                }
            } else if (1 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTip, 7);
            } else if (2 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTip, 8);
            } else if (3 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTip, 9);
            } else if (4 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTip, 10);
            } else if (200 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "活动已结束");
            }


        }

        private function openShop(tab_name:*):void
        {
            if (WxC.isHideShop())
            {
                if (tab_name == "tab_skin")
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "功能未开放");

                } else if (tab_name == "tab_coin")
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "金币不足");

                } else if (tab_name == "tab_package")
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "功能未开放");

                } else if (tab_name == "tab_diamond")
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "钻石不足");
                } else if (tab_name == "tab_mini")
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "功能未开放");
                } else
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "功能未开放");
                }
            } else
            {
                if (ENV.branchSwitch("shop"))
                {
                    UiManager.instance.loadView("Shop", tab_name, ShowType.SMALL_TO_BIG);
                    GameEventDispatch.instance.event(GameEvent.ShopRefresh, tab_name);
                }
            }
        }

        private function changeSkin(skin_id:int):void
        {
            var p:C2s_13003 = new C2s_13003();
            p.skin = skin_id;
            p.battery = 0;
            WebSocketManager.instance.send(13003, p);
        }

        private function updateSkins(data:*):void
        {
            if (data.skins)
            {
                RoleInfoM.instance.setSkins(data.skins)
                GameEventDispatch.instance.event(GameEvent.ShopRefresh, GameConst.shop_tab_skin);
            }
        }

        private function finishAcceptMonthCardReward(data:*):void
        {
            if (data.month_card)
            {
                RoleInfoM.instance.setMonthCard(data.month_card)
            }
            if (data.reward_item_ids)
            {
                GameEventDispatch.instance.event(GameEvent.RewardTip, [data.reward_item_ids, data.reward_item_nums]);
            }
            GameEventDispatch.instance.event(GameEvent.MonthCardUpdate);
        }

        private function buy(commodity:cfg_commodity):void
        {
            buyGoodsCfg = commodity
            var sonBoxId = commodity.boxid;
            if (cfg_goods.instance(commodity.good_ids[0]).type == 7)
            {
                callBuy(buyGoodsCfg)
            } else
            {
                if (ShopM.instance.getGoodsMidId(commodity.id))
                {
                    var data = ShopM.instance.getGoodsMidId(commodity.id)
                    processBuy(data.pmList, data.boxid)
                } else
                {
                    GameEventDispatch.instance.event(GameEvent.OpenWait);
                    ApiManager.instance.buyCommodity(sonBoxId, new Handler(this, completeHandle, [commodity]), new Handler(this, error))
                }
            }
        }

        private function completeHandle(cfg:cfg_commodity, res:*):void
        {
            if (res.code == "success")
            {
                var data:Array = res.data
                if (data)
                {
                    ShopM.instance.setGoodsMidId(cfg.id, data)
                }
                processBuy(data.pmList, data.boxid)
            }
        }

        private function processBuy(pmList, boxid):void
        {
            GameEventDispatch.instance.event(GameEvent.CloseWait);
            if (pmList.length == 1)
            {
                callBuy(buyGoodsCfg, boxid, pmList[0].mid)
            } else
            {
                UiManager.instance.loadView("BuySelect", {"buyGoodsCfg": buyGoodsCfg, "pmList": pmList, "boxid": boxid}, ShowType.SMALL_TO_BIG)
            }
        }

        public function callBuy(cfg:cfg_commodity, boxid:int = -1, mid:int = -1):void
        {
            var a:C2s_14000 = new C2s_14000();
            a.id = cfg.id;
            a.platform = StartParam.instance.getParam("platform");
            a.mid = mid;
            a.boxid = boxid
            WebSocketManager.instance.send(14000, a);
        }

        private function error():void
        {
            trace("商品pmList为空无法购买")
        }

        public static function get instance():ShopC
        {
            return _instance || (_instance = new ShopC());
        }
    }
}
