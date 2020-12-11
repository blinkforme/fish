package view.pack
{
    import control.WxC;

    import emurs.ShowType;

    import engine.tool.StartParam;

    import laya.utils.Tween;

    import model.LoginInfoM;

    import model.RoleInfoM;

    import conf.cfg_battery;
    import conf.cfg_goods;

    import laya.events.Event;
    import laya.ui.Box;
    import laya.ui.Button;
    import laya.ui.Image;
    import laya.ui.Label;
    import laya.utils.Handler;

    import manager.ApiManager;
    import manager.ConfigManager;
    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.GameTools;
    import manager.ResVo;
    import manager.UiManager;
    import manager.WebSocketManager;

    import struct.QuitTipInfo;

    import ui.abbey.PackPageUI;

    public class PackPage extends PackPageUI implements ResVo
    {


        private var _startX:Number = 0;
        private var _startY:Number = 0;

        private var giftData:Object = null;//当前赠送物品的数据
        private var giftUserId:Number = null;
        private var inputCount:Number = 1;

        private var curSelectIndex:Number = 0;

        public function PackPage()
        {
        }

        private function maskClick(event:Event):void
        {
            event.stopPropagation();
        }

        private function getPackItems():Array
        {
            var count:int;
            var goods:Array = ConfigManager.filter("cfg_goods", function (cfg)
            {
                if (cfg.packed == 1)
                {
                    if (cfg.can_use && cfg.type == 6)
                    {
                        count = RoleInfoM.instance.getGoodsItemNum(cfg.id);
                        if (count == 0)
                        {
                            return false;
                        }
                    }
                    return true;
                }
                return false;
            }) as Array
            goods.sort(function (a, b)
            {
                return a.pack_index - b.pack_index;
            })
            return goods;
        }

        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;
            quitOrder.visible = false;
            quit_gift_box.visible = false;
            bmask.on(Event.CLICK, this, null)
            mask1.on(Event.CLICK, this, maskClick)
            mask2.on(Event.CLICK, this, maskClick)
            _startX = this.x;
            _startY = this.y;
            list1.vScrollBarSkin = "";
            quitBtn.on(Event.CLICK, this, onQuitBtnClick);
            quitOrder.on(Event.CLICK, this, onQuitOrderBtnClick);
            curSelectIndex = 0;
            list1.renderHandler = new Handler(this, updateItem);
            list2.renderHandler = new Handler(this, updateItem2);
            screenResize();

            goodsUpdate()
            quit_gift_box.on(Event.CLICK, this, quitGiftBtn);
            gift_confirm.on(Event.CLICK, this, onGiftConfirm)
            tip_box.visible = false;

            query_btn.on(Event.CLICK, this, onQueryUserID)
            gift_records_btn.on(Event.CLICK, this, onGiftRecord)
            gift_records_btn.visible = false;
            use_prop.x = -12;
            use_all_prop.x = -12;
            order_view.visible = false;
            list2.array = []
            item_count.value = "1";

            count_jia.on(Event.CLICK, this, countJia);

            count_jian.on(Event.CLICK, this, countJian);

            userinfo_box.visible = false;
            showRedPoint();
            GameTools.clipTxt(useAllPropClip, "全部使用", GameConst.font_green);
        }

        private function useProp(good_count):void
        {
            if (good_count == 0)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "道具不足");
            } else
            {
                tip_box.visible = false;
                quit_gift_box.visible = false;
                WebSocketManager.instance.send(14028, {id: giftData.id})
            }
        }

        private function showRedPoint():void
        {
            var red_points:Number = RoleInfoM.instance.getRedPoints()
            if (GameConst.point_gift & red_points)
            {
                gift_record_txt_1.visible = true
                gift_record_txt_2.visible = false
            } else
            {
                gift_record_txt_1.visible = false
                gift_record_txt_2.visible = true
            }
        }

        private function clearCountTimer():void
        {
            Laya.timer.clear(this, countJia)
            Laya.timer.clear(this, countJian)

        }

        private function countJianFast():void
        {
            var that = this;
            Laya.timer.once(300, that, function ()
            {
                Laya.timer.loop(100, that, countJian)
            })

        }

        private function countJiaFast():void
        {
            var that = this;
            Laya.timer.once(300, that, function ()
            {
                Laya.timer.loop(100, this, countJia)
            })
        }

        private function countJia():void
        {
            inputCount = inputCount + 1;
            item_count.value = inputCount + ""
        }

        private function countJian():void
        {
            if (inputCount > 1)
            {
                inputCount = inputCount - 1;
            }
            item_count.value = inputCount + ""
        }

        public function getOrders():void
        {
            list2.array = [];
            var token:String = StartParam.instance.getParam("access_token");
            ApiManager.instance.giftList(token, 1, Handler.create(this, function (result:Object)
            {
                if ("success" == result.code)
                {
                    var arr:Array = result.data.rows;
                    list2.array = arr;
                } else
                {
                    console.log("error")
                    console.log(result)
                }


            }), Handler.create(this, function (result:Object)
            {
                console.log("error")
                console.log(result)
            }))
        }

        public function onGiftRecord():void
        {
            getOrders();
            tip_box.visible = false
            quit_gift_box.visible = false;
            order_view.visible = true
            quitOrder.visible = true;
            quitBtn.visible = false;
            mask2.visible = true
            list2.scrollTo(0)
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

        private function quitGiftBtn():void
        {

            tip_box.visible = false
            quitBtn.visible = true;
            quit_gift_box.visible = false;
            input_userid.text = "";
            username.text = "";
            userinfo_box.visible = false
            mask1.visible = false
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
            quit_gift_box.left = contentStartX - posXOff;
            quitBtn.top = contentStartY - posYOff;
            quit_gift_box.top = contentStartY - posYOff;
            quitOrder.left = contentStartX - posXOff;
            quitOrder.top = contentStartY - posYOff;
            tip_box.left = contentStartX - posXOff;
            tip_box.top = contentStartY - posYOff;
        }


        private function gift():void
        {
            var item_count:Number = inputCount;
            var data:Object = {item_id: giftData.id, item_count: item_count, user_id: giftUserId}

            WebSocketManager.instance.send(14017, data)
        }

        private function giftConfirm(gift_id:Number):void
        {
            var data:Object = {gift_id: gift_id}
            WebSocketManager.instance.send(14019, data)
        }

        private function onGiftConfirm():void
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
                var item_count:Number = inputCount;

                var info:QuitTipInfo = new QuitTipInfo();
                info.state = GameConst.quit_state_left_cancel_right_confirm;
                info.content = "<span>确认赠送</span> <span style='color:red'>&nbsp;" + giftData.name + " x " + item_count + "&nbsp;</span> <span>给 </span> <span  style='color:red'>&nbsp;" + GameTools.nameSkip(username.text) + "&nbsp;</span><span>？</span>";
                info.confirmCallback = Handler.create(this, gift, [item_count]);
                info.autoCloseTime = 10;
                GameEventDispatch.instance.event(GameEvent.QuitTip, info);
            }
        }

        private function onGift(good_count:Number):void
        {

            var mini_battery:Number = ConfigManager.getConfValue("cfg_global", 1, "min_battery") as Number


            if (RoleInfoM.instance.getBattery() < mini_battery)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, cfg_battery.instance(mini_battery).comsume + "倍炮台，开放赠送功能");
                return;
            }

            var month_card = RoleInfoM.instance.getMonthCard();
            var have_month_card:Boolean = false
            for (var key in month_card)
            {
                if (!month_card[key].is_expired)
                {
                    have_month_card = true
                    break;
                }
            }
            if (!have_month_card)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "激活月卡，开放赠送功能");
                return;
            }

            if (good_count == 0)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "道具不足");
            } else
            {

                tip_box.pivotX = Laya.stage.mouseX
                tip_box.pivotY = Laya.stage.mouseY;
                tip_box.x = Laya.stage.mouseX;
                tip_box.y = Laya.stage.mouseY;
                tip_box.scaleX = 0;
                tip_box.scaleY = 0;
                GameEventDispatch.instance.event(GameEvent.CloseWait);
                Tween.to(tip_box, {scaleX: 1.05, scaleY: 1.05}, 300, null, Handler.create(this, showComplete))

                inputCount = 1
                item_count.value = "1"
                giftUserId = null
                tip_box.visible = true;
                box1.visible = false;
                box2.visible = true;
                quit_gift_box.visible = true;
                quitBtn.visible = false;
                input_userid.text = "";
                username.text = "";
                mask1.visible = true
            }

        }

        private function updateItem2(cell:Box, index:int):void
        {
            var d:Object = cell.dataSource;

            var ele_item_name:Label = cell.getChildByName("item_name") as Label;
            var ele_gift_name:Label = cell.getChildByName("gift_name") as Label;
            var ele_receive_name:Label = cell.getChildByName("receive_name") as Label;

            var ele_item_date:Label = cell.getChildByName("time") as Label;
            var ele_item_op:Image = cell.getChildByName("op") as Image;
            var ele_item_op_bg:Button = cell.getChildByName("op_bg") as Button;
            var ele_item_img:Image = cell.getChildByName("item_img") as Image;
            var ele_sender_img:Image = cell.getChildByName("gift_avatar") as Image;
            var ele_receive_img:Image = cell.getChildByName("receive_avatar") as Image;


            ele_item_name.text = "x " + d.item_num;
            ele_gift_name.text = LoginInfoM.instance.filterName(GameTools.formatNickName(d.sender_nickname, 8));
            ele_receive_name.text = LoginInfoM.instance.filterName(GameTools.formatNickName(d.receipt_nickname, 8));
            ele_item_date.text = d.created_time.substring(5);
            ele_item_img.skin = cfg_goods.instance(d.item_id).icon;
            if (d.sender_avatar)
            {
                ele_sender_img.skin = d.sender_avatar
            }
            if (d.receipt_avatar)
            {
                ele_receive_img.skin = d.receipt_avatar
            }
            ele_item_op_bg.offAll(Event.CLICK);
            ele_item_op_bg.visible = false;
            if (d.is_me == 1)
            {
                if (d.status == "issued")
                {
                    ele_item_op.skin = "ui/pack/beib_fasong.png";
                } else if (d.status == "finished")
                {
                    ele_item_op.skin = "ui/pack/beib_linqu.png";
                } else
                {
                    ele_item_op.skin = "";
                }
            } else
            {
                if (d.status == "issued")
                {
                    ele_item_op_bg.visible = true
                    ele_item_op.skin = "ui/common_ex/t_accept.png";
                    ele_item_op_bg.on(Event.CLICK, this, giftConfirm, [d.id]);

                } else if (d.status == "finished")
                {
                    ele_item_op.skin = "ui/pack/beib_linqu.png";
                } else
                {
                    ele_item_op.skin = "";
                }
            }
        }

        private function onItemClick():void
        {
            var d:cfg_goods = giftData
            detail_icon.skin = d.icon;
            detail_name.text = d.name;
            detail_desc.text = d.desc;
            gift_icon.skin = d.icon;
            gift_name.text = d.name;
            gift_btn.offAll(Event.CLICK);
            use_prop.offAll(Event.CLICK);
            gift_btn.visible = false;
            use_all_prop.visible = false;
            GameTools.clipTxt(usePropFontClip, "使用", GameConst.font_green);
            var item_count:Number = getItemCount();
            if (d.can_use)
            {
                //                月卡
                if (d.type == 12)
                {
//                    if (RoleInfoM.instance.haveValidMonthCard())
//                    {
//                        gift_btn.visible = false;
//                        use_prop.visible = true;
//                        use_prop.on(Event.CLICK, this, onUsePropClick, [d])
//                        useBtn.on(Event.CLICK, this, useGoods, [item_count])
//                        grantBtn.on(Event.CLICK, this, function (event:Event)
//                        {
//                            var mini_battery:Number = ConfigManager.getConfValue("cfg_global", 1, "min_battery") as Number
//
//                            if (RoleInfoM.instance.getBattery() < mini_battery)
//                            {
//                                GameEventDispatch.instance.event(GameEvent.MsgTipContent, cfg_battery.instance(mini_battery).comsume + "倍炮台，开放赠送功能");
//                                return;
//                            }
//
//                            box1.visible = false;
//                            box2.visible = true;
//                        })
//                    } else
//                    {
                        use_prop.on(Event.CLICK, this, useGoods, [item_count])
                        gift_btn.visible = false
                        use_prop.visible = true
//                    }
                }
                //                        三天月卡道具等
                else if (d.type == 15)
                {
                    use_prop.on(Event.CLICK, this, useGoods, [item_count])
                    gift_btn.visible = false
                    use_prop.visible = true

                } else if (d.type == 6)
                {
                    use_all_prop.on(Event.CLICK, this, useGoods, [item_count])
                    gift_btn.visible = false;
                    use_prop.visible = false;
                    use_all_prop.visible = true;
                }

            } else
            {
                if (d.type == 8)
                {
                    GameTools.clipTxt(usePropFontClip, "兑换", GameConst.font_green);
                    use_prop.visible = true
                    use_prop.on(Event.CLICK, this, openExchangePage)
                } else
                {
                    use_prop.visible = false
                }
                //                gift_btn.visible = true
            }

            if (d.is_gift)
            {
                gift_btn.gray = false
                gift_btn.on(Event.CLICK, this, onGift, [item_count])
            } else
            {
                //                gift_btn.gray = true
            }
        }

        private function openExchangePage()
        {
            onQuitBtnClick()
            if (ENV.branchSwitch("exchange"))
            {
                UiManager.instance.loadView("Exchange", null, ShowType.SMALL_TO_BIG)
            }
        }

        private function onUsePropClick(d:Object):void
        {
            if (RoleInfoM.instance.getGoodsItemNum(d.id) <= 0)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "道具不足");
                return
            }

            tip_box.pivotX = Laya.stage.mouseX
            tip_box.pivotY = Laya.stage.mouseY;
            tip_box.x = Laya.stage.mouseX;
            tip_box.y = Laya.stage.mouseY;
            tip_box.scaleX = 0;
            tip_box.scaleY = 0;
            GameEventDispatch.instance.event(GameEvent.CloseWait);
            Tween.to(tip_box, {scaleX: 1.05, scaleY: 1.05}, 300, null, Handler.create(this, showComplete))

            title_txt.text = "是否使用" + d.name + "?";
            tip_box.visible = true;
            quit_gift_box.visible = true;
            box1.visible = true;
            box2.visible = false;
        }

        private function showComplete():void
        {
            Tween.to(tip_box, {scaleX: 1, scaleY: 1}, 250);
        }


        private function useGoods(nums:Number):void
        {
            var info:QuitTipInfo = new QuitTipInfo();
            info.state = GameConst.quit_state_left_cancel_right_confirm;
            info.content = "确认使用？";
            info.confirmCallback = Handler.create(this, useProp, [nums]);
            info.autoCloseTime = 10;
            GameEventDispatch.instance.event(GameEvent.QuitTip, info);
        }

        private function getItemCount():Number
        {
            var count:Number = 0;
            //奖券
            if (giftData.type == 8)
            {
                count = RoleInfoM.instance.getExchange();
            }
            //技能
            else if (giftData.type == 6)
            {
                count = RoleInfoM.instance.getGoodsItemNum(giftData.id);
            }
            //月卡
            else if (giftData.type == 12)
            {
                count = RoleInfoM.instance.getGoodsItemNum(giftData.id);
            }
            //有期限的月卡
            else if (giftData.type == 15)
            {
                count = RoleInfoM.instance.getGoodsItemNum(giftData.id);
            }
            return count
        }

        private function updateItem(cell:Box, index:int):void
        {
            var d:Object = cell.dataSource;
            var that = this;
            var ele_img:Image = cell.getChildByName("img") as Image;
            var select_bg:Image = cell.getChildByName("select_bg") as Image;
            var ele_count:Label = cell.getChildByName("item_count") as Label
            select_bg.visible = false;
            if (curSelectIndex == index)
            {
                select_bg.visible = true;
            }
            var item_count:Number = 0;
            //兑换券
            if (d.type == 8)
            {
                item_count = RoleInfoM.instance.getExchange();
            }
            //技能
            else if (d.type == 6)
            {
                item_count = RoleInfoM.instance.getGoodsItemNum(d.id);
            }
            //月卡  & 月卡道具
            else if (d.type == 12 || d.type == 15)
            {
                item_count = RoleInfoM.instance.getGoodsItemNum(d.id);
            }
            //活动券
            else if (d.type == 11)
            {
                item_count = RoleInfoM.instance.activity_ticket;
            }
            //扎比瓦卡
            else if (d.type == 13)
            {
                item_count = RoleInfoM.instance.worldcup_coin;
            }

            ele_count.text = "" + item_count


            if (0 == index && giftData == null)
            {
                giftData = d;
                onItemClick();
            }

            ele_img.offAll(Event.CLICK)
            ele_img.on(Event.CLICK, that, function ()
            {
                giftData = d;
                curSelectIndex = index;
                onItemClick()
                list1.refresh();
            });

            ele_img.skin = d.icon;

        }

        private function onQuitBtnClick():void
        {
            UiManager.instance.closePanel("Pack", true);
        }

        private function onQuitOrderBtnClick():void
        {
            order_view.visible = false
            quitOrder.visible = false;
            quitBtn.visible = true;
            mask2.visible = false
        }

        private function giftFinish(result:Object):void
        {
            list1.array = getPackItems();
            quitGiftBtn()
        }

        private function giftConfirmFinish(result:Object):void
        {
            list1.array = getPackItems();
            getOrders();
        }

        private function isDigitalString(str:String):Boolean
        {
            for (var i:int = 0; i < str.length; i++)
            {
                if (str[i] < '0' || str[i] > '9')
                {
                    return false;
                }
            }
            return true;
        }

        private function getClipBoard(content:String):void
        {
            if (content)
            {
                if (content.length == 10 && isDigitalString(content))
                {
                    input_userid.text = content;
                } else
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTip, 51);
                }
            } else
            {
                GameEventDispatch.instance.event(GameEvent.MsgTip, 50);
            }
        }

        private function goodsUpdate():void
        {
            curSelectIndex = 0;
            list1.scrollTo(0);
            list1.array = getPackItems()
            giftData = list1.array[0]
            onItemClick()
        }

        private function endUseMonthCard():void
        {
            onItemClick()
        }

        public function unRegister():void
        {
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.off(GameEvent.GiftFinish, this, giftFinish);
            GameEventDispatch.instance.off(GameEvent.GiftConfirmFinish, this, giftConfirmFinish);
            GameEventDispatch.instance.off(GameEvent.ShowRedPoint, this, showRedPoint);
            GameEventDispatch.instance.off(GameEvent.WxGetClipBoard, this, getClipBoard);
            GameEventDispatch.instance.off(GameEvent.GoodsUpdate, this, goodsUpdate);
            GameEventDispatch.instance.off(GameEvent.EndUseMonthCard, this, endUseMonthCard);

        }


        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.on(GameEvent.GiftFinish, this, giftFinish);
            GameEventDispatch.instance.on(GameEvent.GiftConfirmFinish, this, giftConfirmFinish);
            GameEventDispatch.instance.on(GameEvent.ShowRedPoint, this, showRedPoint);
            GameEventDispatch.instance.on(GameEvent.WxGetClipBoard, this, getClipBoard);
            GameEventDispatch.instance.on(GameEvent.GoodsUpdate, this, goodsUpdate);
            GameEventDispatch.instance.on(GameEvent.EndUseMonthCard, this, endUseMonthCard);
        }


    }
}
