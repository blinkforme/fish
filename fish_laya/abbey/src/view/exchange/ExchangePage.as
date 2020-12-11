package view.exchange
{
    import control.LoginC;
    import control.WxC;

    import emurs.ShowType;

    import engine.tool.StartParam;

    import model.ActivityM;
    import model.ExchangeM;
    import model.LoginInfoM;
    import model.RoleInfoM;

    import laya.utils.Browser;
    import laya.events.Event;
    import laya.ui.Box;
    import laya.ui.Button;
    import laya.ui.FontClip;
    import laya.ui.Image;
    import laya.ui.Label;
    import laya.utils.Handler;

    import manager.ApiManager;
    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;
    import manager.WebSocketManager;

    import struct.QuitTipInfo;

    import ui.abbey.ExchangePageUI;

    public class ExchangePage extends ExchangePageUI implements ResVo
    {


        private var _startX:Number = 0;
        private var _startY:Number = 0;

        private var last_time:Number = 0;//刷新缓存

        //兑换物品列表
        private var exchangeArray:Array = [];
        private var realArray:Array = [];
        private var virtualArray:Array = [];
        private var pfScoreArray:Array = [];

        private var selectBtnArr:Object = {};


        private var select_type:String = "virtual";//virtual--虚拟物品  real--实物
        private var exchangeData:Object = null;//当前兑换物品的数据
        private var userTel:String = "";//用户手机号
        private var cache_time:Number = 5000;//接口缓存毫秒数

        var bindCountDownNum:Number = 60
        private var canSendSms:Boolean = true

        public function ExchangePage()
        {
        }

        private function maskClick(event:Event):void
        {
            event.stopPropagation();
        }

        public function StartGames(parm:Object = null):void
        {
            haveScoreBox.visible = false;
            nomalBox.visible = false;
            this.hitTestPrior = false;
            quitExchange.visible = false;
            bmask.on(Event.CLICK, this, null)
            mask1.on(Event.CLICK, this, maskClick)
            _startX = this.x;
            _startY = this.y;
            ExchangeM.instance.curSelect = 0
            quitBtn.on(Event.CLICK, this, onQuitBtnClick);
            list1.renderHandler = new Handler(this, updateItem);
            list2.renderHandler = new Handler(this, updateItem2);
            quickRegister.on(Event.CLICK, this, onQuickRegister);
            getvcode.on(Event.CLICK, this, sendBindVCode)
            bindBtn.on(Event.CLICK, this, bindTel);
            quitExchange.on(Event.CLICK, this, quitExchangeBtn);
            exchangeBtn.on(Event.CLICK, this, exchangeBtnClick)
            findIntegralBtn.on(Event.CLICK, this, onFindIntegralBtn);
            initBtn();
            screenResize();
            onRealBtn();
            list1.visible = true;
            list2.visible = false;
            box_labels.visible = false;
            exchangeBox.visible = false;
            list2.array = []
        }

        private function onFindIntegralBtn()
        {
            UiManager.instance.loadView("PublicAccount", null, ShowType.SMALL_TO_BIG)
        }

        private function bindTel():void
        {
            var pattern_tel:RegExp = /^[1][0-9]{10}$/;
            var pattern_vcode:RegExp = /^[0-9]{6}$/;
            var pattern_id:RegExp = /^[0-9]*$/;

            if (!pattern_tel.test(telephone.text))
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "手机号不符合规范");
            } else if (jjhID.text.length <= 0 || !pattern_id.test(jjhID.text))
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "集结号ID不符合规范，请填写数字");
            } else if (!pattern_vcode.test(vCode.text))
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "验证码不符合规范");
            } else
            {
                var userID:String = LoginInfoM.instance.uid + "";
                var number:String = jjhNumber.text;
                var id:String = jjhID.text;
                var password:String = cipher.text;
                var tel:String = telephone.text;
                var code:String = vCode.text;
                WebSocketManager.instance.send(33020, {
                    u_user_id: userID, phone: tel,
                    jjhaccounts: number, jjhuserid: id,
                    logonpass: password, code: code
                })
            }
        }

        private function sendBindVCode():void
        {
            var tel:String = telephone.text
            var pattern_tel:RegExp = /^[1][0-9]{10}$/;

            if (!canSendSms)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请等待倒计时结束");
            } else if (!pattern_tel.test(tel))
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "手机号不符合规范");
            } else
            {
                getvcode.offAll(Event.CLICK)
                bindCountDownNum = 60
                bindCountDown.text = "60s"
                bindCountDown.visible = true
                Laya.timer.loop(1000, this, initBindCountDown);
                getvcode.gray = true;
                canSendSms = false;
                WebSocketManager.instance.send(33014, {phone: tel})
            }
        }

        private function initBindCountDown():void
        {
            bindCountDownNum--
            bindCountDown.visible = true
            bindCountDown.text = bindCountDownNum + "s"

            if (bindCountDownNum < 0)
            {
                bindCountDown.visible = false
                getvcode.gray = false
                canSendSms = true
                getvcode.on(Event.CLICK, this, sendBindVCode)
                Laya.timer.clear(this, initBindCountDown)
            }
        }

        private function onQuickRegister()
        {
            onQuitBtnClick();
            UiManager.instance.loadView("QuickRegister", GameConst.from_bank)
        }

        private function initBtn():void
        {

            if (ActivityM.instance.redPackTicketContinueTime)
            {
                haveScoreBox.visible = true;
                nomalBox.visible = false;
                renderBox(haveScoreBox);
            } else
            {
                haveScoreBox.visible = false;
                nomalBox.visible = true;
                renderBox(nomalBox);
            }
        }

        private function renderBox(box:Box):void
        {
            var tab_real:Button = box.getChildByName("tab_real") as Button;
            var tab_virtual:Button = box.getChildByName("tab_virtual") as Button;
            var tab_order:Button = box.getChildByName("tab_order") as Button;
            var tab_pf_score:Button = box.getChildByName("tab_pf_score") as Button;
            selectBtnArr = {
                tab_real: tab_real,
                tab_virtual: tab_virtual,
                tab_order: tab_order,
                tab_pf_score: tab_pf_score
            }
            tab_real.on(Event.CLICK, this, onRealBtn);
            tab_virtual.on(Event.CLICK, this, onVirtualBtn);
            tab_order.on(Event.CLICK, this, onOrderBtn);
            if (tab_pf_score)
            {
                tab_pf_score.on(Event.CLICK, this, onScoreBtn);
            }
        }

        public function onBtnCopyClick(e):void
        {
            WxC.wx_set_clipboard_data("jjhbyh5");
        }

        private function exchangeBtnClick():void
        {

            var pattern_tel:RegExp = /^[1][0-9]{10}$/;
            if (tel.text != tel_confirm.text)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "两次输入的手机号不一致");
            } else if (!pattern_tel.test(tel.text))
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "手机号不符合规范");
            } else
            {
                this.userTel = tel.text;

                var info:QuitTipInfo = new QuitTipInfo();
                info.state = GameConst.quit_state_left_cancel_right_confirm;
                info.content = "确认兑换？";
                info.confirmCallback = Handler.create(this, exchange, [exchangeData]);
                info.conFirmArgs = exchangeData;
                info.autoCloseTime = 10;
                GameEventDispatch.instance.event(GameEvent.QuitTip, info);
            }

        }


        private function quitExchangeBtn():void
        {
            exchangeBox.visible = false
            quitExchange.visible = false;
            quitBtn.visible = true;
            tel.text = "";
            tel_confirm.text = "";
            mask1.visible = false
        }

        private function clearSelect()
        {
            selectBtnArr['tab_real'].selected = false;
            selectBtnArr['tab_virtual'].selected = false;
            selectBtnArr['tab_order'].selected = false;
            if (ActivityM.instance.redPackTicketContinueTime)
            {
                selectBtnArr['tab_pf_score'].selected = false;
            }
        }

        public function onVirtualBtn():void
        {
            clearSelect();
            descBox.visible = true;
            desTwo.visible = true;
            desOne.visible = false;
            desThree.visible = false;
            selectBtnArr['tab_virtual'].selected = true;
            list1.visible = true;
            box_score.visible = false;
            list2.visible = false;
            box_labels.visible = false;
            select_type = "virtual";
            labaNumBox.visible = true;
            labaNum.text = RoleInfoM.instance.getExchange() + "";
            findIntegralBtn.visible = false;
            getExchanges()
            list1.scrollTo(0)

        }

        public function onRealBtn():void
        {
            clearSelect();
            descBox.visible = true;
            desTwo.visible = true;
            desOne.visible = false;
            desThree.visible = false;
            selectBtnArr['tab_real'].selected = true;
            list1.visible = true;
            box_score.visible = false;
            list2.visible = false;
            box_labels.visible = false;
            select_type = "real";
            labaNumBox.visible = true;
            labaNum.text = RoleInfoM.instance.getExchange() + "";
            findIntegralBtn.visible = false;
            getExchanges();
            list1.scrollTo(0)
        }

        public function onOrderBtn():void
        {
            clearSelect();
            labaNumBox.visible = false;
            descBox.visible = true;
            desTwo.visible = false;
            desOne.visible = false;
            desThree.visible = true;
            selectBtnArr['tab_order'].selected = true;
            list1.visible = false;
            box_score.visible = false;
            list2.visible = true;
            box_labels.visible = true;
            getOrders();
            list2.scrollTo(0)
        }

        public function onScoreBtn():void
        {
            clearSelect();
            clearInput();
            descBox.visible = true;
            desTwo.visible = false;
            desThree.visible = false;
            selectBtnArr['tab_pf_score'].selected = true;
            labaNumBox.visible = false;
            list1.visible = false;
            list2.visible = false;
            box_score.visible = false;
            box_labels.visible = false;
            list1.scrollTo(0)
            if (RoleInfoM.instance.is_bind_tel)
            {
                desOne.visible = true;
                select_type = "pf_score";
                getExchanges();
                list1.visible = true;
                labaNumBox.visible = true;
                findIntegralBtn.visible = true;
                labaNum.text = RoleInfoM.instance.getExchange() + "";
            } else
            {
                desOne.visible = false;
                box_score.visible = true;
                initBindJJId()
            }
        }

        private function updateExchange(exchangeNum:*):void
        {
            if (exchangeNum)
            {
                labaNum.text = ActivityM.instance.exchangeConversion(GameConst.currency_exchange, exchangeNum) + ""
            } else
            {
                labaNum.text = "0"
            }

        }

        private function clearInput():void
        {
            jjhNumber.text = "";
            jjhID.text = "";
            cipher.text = "";
            telephone.text = "";
            vCode.text = "";
        }

        private function initBindJJId()
        {
            if (ENV.openQuickRegister)
            {
                initQuickBtn()
            }
        }

        private function initQuickBtn():void
        {

            if (RoleInfoM.instance.jjhNumber && RoleInfoM.instance.jjhId)
            {
                quickRegister.visible = false
                bindBtn.x = 344;
                jjhNumber.text = RoleInfoM.instance.jjhNumber;
                jjhID.text = RoleInfoM.instance.jjhId;
                telephone.text = RoleInfoM.instance.tel ? RoleInfoM.instance.tel : "";
                if (RoleInfoM.instance.jjhPass && RoleInfoM.instance.bankPass)
                {
                    cipher.text = RoleInfoM.instance.jjhPass;
                }
            } else
            {
                quickRegister.visible = true
                bindBtn.x = 484;
            }
        }

        private function parsePrice(price:Number)
        {
            if (parseInt(price) >= 10000)
            {
                return parseInt(parseInt(price) / 10000) + "万";

            } else
            {
                return price + ""
            }
        }

        private function updateItem2(cell:Box, index:int):void
        {
            var d:Object = cell.dataSource;

            var ele_item_name:Label = cell.getChildByName("item_name") as Label;
            var ele_item_cost:Label = cell.getChildByName("item_cost") as Label;
            var ele_item_date:Label = cell.getChildByName("item_date") as Label;
            var ele_item_status:Image = cell.getChildByName("item_status") as Image;

            var ele_price_unit:Image = cell.getChildByName("price_unit") as Image;

            if (d.goods_id == 60)
            {
                ele_price_unit.skin = "ui/common_ex/unit_exchange.png"
            } else if (d.goods_id == 1)
            {
                ele_price_unit.skin = "ui/common_ex/unit_coin.png"
            }

            ele_item_name.text = d.name;

            ele_item_cost.text = parsePrice(ActivityM.instance.exchangeConversion(d.goods_id, d.price));
            ele_item_date.text = d.created_time;
            if ("virtual" == d.type)
            {
                ele_item_status.skin = "ui/exchange/success.png";
            } else
            {
                if ("pending" == d.status)
                {
                    ele_item_status.skin = "ui/exchange/status_pending.png";
                } else if ("finished" == d.status)
                {
                    ele_item_status.skin = "ui/exchange/success.png";
                }
            }
        }

        public function getOrders():void
        {
            var token = StartParam.instance.getParam("access_token");
            ApiManager.instance.exchangeRecords(token, GameConst.coin_type_exchange, Handler.create(this, function (result:Object)
            {
                if ("success" == result.code)
                {
                    var arr:Array = result.data.rows;
                    list2.array = arr;
                } else
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "获取订单");
                    console.log("error")
                    console.log(result)
                }


            }), Handler.create(this, function (result:Object)
            {
                console.log("error")
                console.log(result)
            }))
        }

        public function getExchanges():void
        {
            var token = StartParam.instance.getParam("access_token");
            var cur_d:Date = new Date();
            var cur_time:Number = cur_d.getTime();

            if ((cur_time - last_time) > cache_time)
            {
                last_time = cur_time
                wait_ani.visible = true;
                var token = StartParam.instance.getParam("access_token");
                ApiManager.instance.exchangeList(token, GameConst.coin_type_exchange, function (result:Object)
                {
                    exchangeArray = result.data
                    realArray = [];
                    virtualArray = [];
                    pfScoreArray = [];
                    for (var i:Number = 0; i < exchangeArray.length; i++)
                    {
                        if (exchangeArray[i].type == "virtual")
                        {
                            virtualArray.push(exchangeArray[i])
                        } else if (exchangeArray[i].type == "real")
                        {
                            realArray.push(exchangeArray[i])
                        } else if (exchangeArray[i].type == "pf_score")
                        {
                            pfScoreArray.push(exchangeArray[i])
                        }
                    }
                    if (select_type == "virtual")
                    {
                        list1.array = virtualArray;
                    } else if (select_type == "real")
                    {
                        list1.array = realArray;
                    } else if (select_type == "pf_score")
                    {
                        list1.array = pfScoreArray;
                    } else
                    {
                        list1.array = [];
                    }

                    wait_ani.visible = false;
                })

            } else
            {
                if (select_type == "virtual")
                {
                    list1.array = virtualArray;
                } else if (select_type == "real")
                {
                    list1.array = realArray;
                } else if (select_type == "pf_score")
                {
                    list1.array = pfScoreArray;
                } else
                {
                    list1.array = [];
                }
            }
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
            quitExchange.left = contentStartX - posXOff;
            quitExchange.top = contentStartY - posYOff;
        }

        private function exchange(data:Object):void
        {
            if (data.type == "virtual")
            {
                ActivityM.instance.countDownArr[data.id] = ActivityM.instance.countDownTimes;
            }
            WebSocketManager.instance.send(14014, {
                        id: data.id,
                        phone: userTel
                    }
            )
        }


        private function exchangeComplete(result:Object):void
        {

            mask1.visible = false
            exchangeBox.visible = false;
            quitExchange.visible = false;
            quitBtn.visible = true;
            last_time = last_time - cache_time;
            getExchanges()
            if (result)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "兑换成功");
            }
        }


        private function updateItem(cell:Box, index:int):void
        {
            var d:Object = cell.dataSource;

            var ele_buy_btn:Button = cell.getChildByName("btn") as Button;
            var ele_desc:Label = cell.getChildByName("desc") as Label;
            var ele_remain:Label = cell.getChildByName("remain") as Label;
            var ele_price_unit:Image = cell.getChildByName("price_unit") as Image;
            var ele_price:FontClip = cell.getChildByName("price") as FontClip;
            var ele_img:Image = cell.getChildByName("img") as Image;
            var ele_title:Label = cell.getChildByName("title") as Label
            var countDownLabel:Label = cell.getChildByName("countDownLabel") as Label;
            countDownLabel.visible = false;
            ele_title.text = d.name;
            ele_desc.text = d.summary;
            ele_remain.text = "今日剩余：" + d.num;


            var user_coin:Number = 0
            var need_more_text = ""
            if (d.goods_id == 60)
            {
                user_coin = RoleInfoM.instance.getExchange()
                ele_price_unit.skin = "ui/common_ex/unit_exchange.png";
                need_more_text = "珍珠不足"
            } else if (d.goods_id == 1)
            {
                user_coin = RoleInfoM.instance.getCoin()
                ele_price_unit.skin = "ui/common_ex/unit_coin.png";
                need_more_text = "金币不足"
            }

            var price:Number = ActivityM.instance.exchangeConversion(d.goods_id, d.price)
            ele_price.value = parsePrice(price);

            ele_img.skin = d.image_url;

            ele_buy_btn.offAll(Event.CLICK);
            var that = this;


            if (d.num > 0)
            {
                if (user_coin * 1 >= price * 1)
                {
                    ele_buy_btn.stateNum = 2;
                    ele_buy_btn.skin = "ui/common_ex/btn_yellow.png"
                    ele_price_unit.gray = false
                    ele_price.gray = false
                } else
                {
                    ele_buy_btn.stateNum = 1;
                    ele_buy_btn.skin = "ui/common_ex/btn_gray.png"
                    ele_price_unit.gray = true
                    ele_price.gray = true
                }
            } else
            {
                ele_buy_btn.stateNum = 1;
                ele_buy_btn.skin = "ui/common_ex/btn_gray.png"
                ele_price_unit.gray = true
                ele_price.gray = true
            }


            if (user_coin * 1 >= price * 1)
            {
                if (d.num > 0)
                {
                    if (d.type == "real")
                    {
                        ele_buy_btn.on(Event.CLICK, this, onExchangeBtn,[d])
                    } else if (d.type == "virtual")
                    {
                        if (!ActivityM.instance.countDownArr[d.id] || ActivityM.instance.countDownArr[d.id] < 1)
                        {
                            ele_buy_btn.on(Event.CLICK, this, function ()
                            {
                                var info:QuitTipInfo = new QuitTipInfo();
                                info.state = GameConst.quit_state_left_cancel_right_confirm;
                                info.content = "确认兑换？";
                                info.confirmCallback = Handler.create(this, exchange, [d]);
                                info.conFirmArgs = exchangeData;
                                info.autoCloseTime = 10;
                                GameEventDispatch.instance.event(GameEvent.QuitTip, info);
                            })
                        } else
                        {
                            countDownLabel.text = "倒计时:" + ActivityM.instance.countDownArr[d.id] + "s";
                            countDownLabel.visible = true;
                            ele_buy_btn.stateNum = 1;
                            ele_buy_btn.skin = "ui/common_ex/btn_gray.png"
                            ele_price_unit.gray = true
                            ele_price.gray = true
                        }
                    } else if (d.type == "pf_score")
                    {
                        ele_buy_btn.on(Event.CLICK, this, function ()
                        {

                            var info:QuitTipInfo = new QuitTipInfo();
                            info.state = GameConst.quit_state_left_cancel_right_confirm;
                            info.content = "确认兑换？";
                            info.confirmCallback = Handler.create(this, exchange, [d]);
                            info.conFirmArgs = exchangeData;
                            info.autoCloseTime = 10;
                            GameEventDispatch.instance.event(GameEvent.QuitTip, info);
                        });
                    }

                } else
                {
                    ele_buy_btn.on(Event.CLICK, this, function ()
                            {
                                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "库存不足");
                            }
                    )
                }
            }
            //兑换券不足
            else
            {
                ele_buy_btn.on(Event.CLICK, this, function ()
                        {
                            GameEventDispatch.instance.event(GameEvent.MsgTipContent, need_more_text);
                        }
                )
            }
        }

        private function onExchangeBtn(d:Object):void
        {
            var bindInfo:Object = RoleInfoM.instance.getUserBindInfo()
            exchangeData = copyObj(d);
            console.log("xxx",bindInfo)
            if (bindInfo && bindInfo['type'] && bindInfo['type'] != 2)
            {
                if (/^1[3456789]\d{9}$/.test(bindInfo['phone']))
                {
                    var info:QuitTipInfo = new QuitTipInfo();
                    info.state = GameConst.quit_state_left_cancel_right_confirm;
                    info.content = "确认兑换？";
                    info.confirmCallback = Handler.create(this, exchange, [d]);
                    info.conFirmArgs = exchangeData;
                    info.autoCloseTime = 10;
                    GameEventDispatch.instance.event(GameEvent.QuitTip, info);
                }else
                {
                    mask1.visible = true;
                    tel.text = "";
                    tel_confirm.text = "";
                    exchangeBox.visible = true;
                    quitExchange.visible = true;
                    quitBtn.visible = false;
                }
            }else
            {
                UiManager.instance.loadView("BindInfo", null, ShowType.SMALL_TO_BIG);
            }

        }

        //兑换成功存用户手机号
        private function saveTel():void
        {
            console.log("userTel",userTel)
            if (this.userTel && this.userTel.length > 0)
            {
                console.log("已存")
                RoleInfoM.instance.user_bind_info['phone'] = this.userTel
            }
        }

        private function onQuitBtnClick():void
        {
            UiManager.instance.closePanel("Exchange", true);
        }

        private function refreshList1():void
        {
            list1.refresh();
        }

        public function unRegister():void
        {
            GameEventDispatch.instance.off(GameEvent.UpdateExchange, this, updateExchange);
            GameEventDispatch.instance.off(GameEvent.SynBankBindSuccess, this, onScoreBtn);
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.off(GameEvent.ExchangeFinish, this, exchangeComplete);
            GameEventDispatch.instance.off(GameEvent.RefreshVirtualList, this, refreshList1);
            GameEventDispatch.instance.off(GameEvent.ExchangeFinish, this, saveTel);
        }

        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.UpdateExchange, this, updateExchange);
            GameEventDispatch.instance.on(GameEvent.SynBankBindSuccess, this, onScoreBtn);
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.on(GameEvent.ExchangeFinish, this, exchangeComplete);
            GameEventDispatch.instance.on(GameEvent.RefreshVirtualList, this, refreshList1);
            GameEventDispatch.instance.on(GameEvent.ExchangeFinish, this, saveTel);
        }

        private function copyObj(obj)
        {
            if ((obj instanceof Array)) return copyArr(obj);
            var rst = {};
            var key;
            for (key in obj)
            {
                if (obj[key] === null || obj[key] === undefined)
                {
                    rst[key] = obj[key];
                } else if (((obj[key]) instanceof Array))
                {
                    rst[key] = copyArr(obj[key]);
                } else if ((typeof (obj[key]) == 'object'))
                {
                    rst[key] = copyObj(obj[key]);
                } else
                {
                    rst[key] = obj[key];
                }
            }
            return rst;
        }

        private function copyArr(arr)
        {
            var rst;
            rst = [];
            var i = 0, len = 0;
            len = arr.length;
            for (i = 0; i < len; i++)
            {
                rst.push(copyObj(arr[i]));
            }
            return rst;
        }
    }
}
