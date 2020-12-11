package view.shortGift
{
    import conf.cfg_global;

    import control.RedpointC;

    import engine.tool.StartParam;

    import laya.ui.Button;

    import manager.ConfigManager;

    import model.ActivityM;


    import conf.cfg_goods;

    import laya.events.Event;
    import laya.ui.Box;
    import laya.ui.Image;
    import laya.ui.Label;
    import laya.utils.Handler;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;
    import manager.WebSocketManager;

    import model.LoginInfoM;
    import model.RoleInfoM;


    import ui.abbey.ShortGiftPageUI;


    public class ShortGiftPage extends ShortGiftPageUI implements ResVo
    {
        private var _startX:Number = 0;
        private var _startY:Number = 0;
        private var listType:Number = 1;
        private var redRoll:Array;

        public function UseTicketPage()
        {

        }

        public function StartGames(parm:Object = null):void
        {
            _startX = this.x;
            _startY = this.y;
            this.hitTestPrior = false;
            redRoll = RoleInfoM.instance.calcRed();
            bmask.on(Event.CLICK, this, null)
            itemBtn_0.on(Event.CLICK, this, selectBox, [0]);
            itemBtn_1.on(Event.CLICK, this, selectBox, [1]);
            itemBtn_2.on(Event.CLICK, this, selectBox, [2]);
            close_btn.on(Event.MOUSE_DOWN, this, onClose);
            list1.renderHandler = new Handler(this, updateDate);
            list1.array = ConfigManager.items("cfg_actsign")
            list1.hScrollBarSkin = "";
            addRed()
            updateBtn();
            initBox();
            screenResize();
        }


        private function initBox():void
        {
            if (itemBtn_0.visible == false)
            {
                selectBox(1);
            } else
            {
                selectBox(0);
            }

            scrollList();
            if (RoleInfoM.instance.short_pf == 2)
            {
                itemBtn_2.visible = false;
            }
        }

        private function updateBtn():void
        {
            var now:Number = parseInt(new Date().getTime() / 1000);
            if (RoleInfoM.instance.curDay == RoleInfoM.instance.receive.length - 1)
            {
                if (StartParam.instance.getParam("ctime") + cfg_global.instance(1).sign_days * 86400 < now)
                {
                    itemBtn_1.y = 0;
                    itemBtn_2.y = 95;
                    selectBox(1);
                    itemBtn_0.visible = false;
                }
            }

            if (StartParam.instance.getParam("ctime") + cfg_global.instance(1).rech_days * 86400 < now)
            {
                itemBtn_1.visible = false;
            }


            if (StartParam.instance.getParam("ctime") + cfg_global.instance(1).upgrade_days * 86400 < now)
            {
                itemBtn_2.visible = false;
            }
        }

        private function selectBox(page:Number):void
        {
            itemBtn_0.selected = false;
            itemBtn_1.selected = false;
            itemBtn_2.selected = false;
            itemBtn_0.skin = "ui/shortGift/btn_fl_02.png"
            itemBtn_1.skin = "ui/shortGift/btn_cz_02.png"
            itemBtn_2.skin = "ui/shortGift/btn_cj_02.png"
            var now:Number = Math.floor(new Date().getTime() / 1000);
            var time:Number = parseInt(StartParam.instance.getParam("ctime"));

            if (page == 0)
            {
                var remain:Number = Math.floor(cfg_global.instance(1).sign_days * 86400);
                var D:Number = parseFloat((time + remain - now) / 86400);
                var day:Number = Math.floor(D);
                var H:Number = Math.floor(((time + remain - now) - day * 86400) / 3600);
                var hour:Number = Math.floor(H);
                listType = 1;
                if (day < 0)
                {
                    remine_time.text = "活动剩余时间：00天00小时";
                } else
                {
                    remine_time.text = "活动剩余时间：" + day + "天" + hour + "小时";
                }

                scrollList();
                itemBtn_0.selected = true;
                itemBtn_0.skin = "ui/shortGift/btn_fl_01.png"
                list1.array = ConfigManager.items("cfg_actsign")
            } else if (page == 1)
            {
                var remain:Number = cfg_global.instance(1).rech_days * 86400 as Number;
                var D:Number = (time + remain - now) / 86400 as Number;
                var day:Number = parseInt(D) as Number;
                var H:Number = (time + remain - now - day * 86400) / 3600 as Number;
                var hour:Number = parseInt(H);
                listType = 2;
                if (day < 0)
                {
                    remine_time.text = "活动剩余时间：00天00小时";
                } else
                {
                    remine_time.text = "活动剩余时间：" + day + "天" + hour + "小时";
                }
                scrollList();
                itemBtn_1.selected = true;
                itemBtn_1.skin = "ui/shortGift/btn_cz_01.png"
                list1.array = filterRechData();
            } else if (page == 2)
            {
                var remain:Number = cfg_global.instance(1).upgrade_days * 86400 as Number;
                var D:Number = (time + remain - now) / 86400 as Number;
                var day:Number = parseInt(D) as Number;
                var H:Number = (time + remain - now - day * 86400) / 3600 as Number;
                var hour:Number = parseInt(H);
                listType = 3;
                if (day < 0)
                {
                    remine_time.text = "活动剩余时间：00天00小时";
                } else
                {
                    remine_time.text = "活动剩余时间：" + day + "天" + hour + "小时";
                }
                scrollList();
                itemBtn_2.selected = true;
                itemBtn_2.skin = "ui/shortGift/btn_cj_01.png"
                list1.array = ConfigManager.items("cfg_upgradeRed")
            }

            list1.refresh();
        }

        private function addRed():void
        {
            var vertical_h = 10
            var horizontal_percent = 0.75


            if (redRoll[0] == 1)
            {
                RedpointC.instance.removeRedPoint(itemBtn_0)
                RedpointC.instance.addRedPointToIcon(itemBtn_0, horizontal_percent, vertical_h)
            } else
            {
                RedpointC.instance.removeRedPoint(itemBtn_0)
            }

            if (redRoll[1] == 1)
            {
                RedpointC.instance.removeRedPoint(itemBtn_1)
                RedpointC.instance.addRedPointToIcon(itemBtn_1, horizontal_percent, vertical_h)
            } else
            {
                RedpointC.instance.removeRedPoint(itemBtn_1)
            }


            if (RoleInfoM.instance.short_pf != 2)
            {
                if (redRoll[2] == 1)
                {
                    RedpointC.instance.removeRedPoint(itemBtn_2)
                    RedpointC.instance.addRedPointToIcon(itemBtn_2, horizontal_percent, vertical_h)
                } else
                {
                    RedpointC.instance.removeRedPoint(itemBtn_2)
                }
            }
        }


        private function scrollList():void
        {
            if (listType == 1)
            {
                if (RoleInfoM.instance.curDay < 3)
                {
                    list1.scrollTo(0)
                } else
                {
                    list1.scrollTo(RoleInfoM.instance.curDay - 2);
                }
            }

            if (listType == 2)
            {
                var arr = RoleInfoM.instance.pay_accept_ids
                var len = 0;
                if (RoleInfoM.instance.pay_accept_ids)
                {
                    len = arr.length;
                    var newArr = arr.sort();
                    list1.scrollTo(newArr[len - 1] - 1)
                } else
                {
                    list1.scrollTo(0)
                }
            }

            if (listType == 3)
            {
                var arr = RoleInfoM.instance.level_accept_ids
                var len = 0;
                if (RoleInfoM.instance.level_accept_ids)
                {
                    len = arr.length;
                    var newArr = arr.sort();
                    list1.scrollTo(newArr[len - 1] - 1)
                } else
                {
                    list1.scrollTo(0)
                }
            }
        }

        /*充值福利列表过滤*/
        private function filterRechData():Array
        {
            var arr:Array = new Array()
            var cfg:Array = ConfigManager.items("cfg_rech_award")
            var extra:Number = 1
            for (var i = 0; i < cfg.length; i++)
            {
                if (RoleInfoM.instance.total >= cfg[i].rechSum)
                {
                    arr.push(cfg[i])
                } else
                {
                    if (extra < 3)
                    {
                        extra++
                        arr.push(cfg[i])
                    }
                }
            }
            return arr
        }

        private function updateDate(cell:Box, index:int):void
        {
            var config:Object = cell.dataSource;
            var ele_img:Image = cell.getChildByName("img") as Image;
            var ele_days:Label = cell.getChildByName("days") as Label;
            var ele_num:Label = cell.getChildByName("num") as Label;
            var ele_rightBtn:Button = cell.getChildByName("rightBtn") as Button;
            var ele_received:Button = cell.getChildByName("not_received") as Button;
            var ele_condition:Label = cell.getChildByName("condition") as Label;
            var ele_progress:Label = cell.getChildByName("progress") as Label;

            var sign_now:Number = RoleInfoM.instance.curDay;
            ele_img.skin = cfg_goods.instance(config.reward_ids).icon;

            ele_days.text = config.title;
            ele_num.text = "" + config.remark;

            if (listType == 1)
            {
                ele_progress.visible = false;
                if (index < sign_now)
                {
                    ele_condition.visible = false;
                    if (RoleInfoM.instance.receive.indexOf(config.id) > -1)
                    {
                        ele_received.visible = true;
                        ele_rightBtn.visible = false;
                    } else
                    {
                        ele_received.visible = false;
                        ele_rightBtn.visible = true;
                    }
                } else
                {
                    ele_condition.visible = true;
                    ele_rightBtn.visible = false;
                    ele_received.visible = false;
                    ele_condition.text = "再登录" + (index + 1 - sign_now) + "天可领取"
                }
            }

            if (listType == 2)
            {
                if (RoleInfoM.instance.total >= config.rechSum)
                {
                    ele_condition.visible = false;
                    ele_progress.visible = false;
                    if (RoleInfoM.instance.pay_accept_ids.indexOf(config.id) > -1)
                    {
                        ele_received.visible = true;
                        ele_rightBtn.visible = false;
                    } else
                    {
                        ele_received.visible = false;
                        ele_rightBtn.visible = true;
                    }
                } else
                {
                    ele_condition.visible = true;
                    ele_progress.visible = true;
                    ele_rightBtn.visible = false;
                    ele_received.visible = false;
                    ele_condition.text = "累计充值" + config.rechSum + "元可领取"
                    ele_progress.text = RoleInfoM.instance.total + "/" + config.rechSum
                }
            }

            if (listType == 3)
            {
                ele_condition.visible = false;
                if (RoleInfoM.instance.getLevel() >= config.level)
                {
                    ele_progress.visible = false;
                    if (RoleInfoM.instance.level_accept_ids.indexOf(config.id) > -1)
                    {
                        ele_received.visible = true;
                        ele_rightBtn.visible = false;
                    } else
                    {
                        ele_received.visible = false;
                        ele_rightBtn.visible = true;
                    }
                } else
                {
                    ele_progress.visible = true;
                    ele_rightBtn.visible = false;
                    ele_received.visible = false;
                    ele_progress.text = "达到" + config.level + "级可领取";
                }
            }

            ele_rightBtn.on(Event.CLICK, this, onRightBtn, [config.id])
        }

        private function onRightBtn(id:Number):void
        {
            if (listType == 1)
            {
                WebSocketManager.instance.send(50003, {id: id})
            } else if (listType == 2)
            {
                WebSocketManager.instance.send(50005, {id: id})
            } else if (listType == 3)
            {
                WebSocketManager.instance.send(50007, {id: id})
            }
        }

        private function refreshList():void
        {
            redRoll = RoleInfoM.instance.calcRed();
            list1.refresh();
            updateBtn();
            addRed();
        }

        private function onClose():void
        {
            UiManager.instance.closePanel("ShortGift", false);
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

            close_btn.left = contentStartX - posXOff;
            close_btn.top = contentStartY - posYOff;
        }

        //注册消息发送事件
        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.on(GameEvent.syncShortData, this, refreshList);

        }

        //取消注册的消息发送事件
        public function unRegister():void
        {
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.off(GameEvent.syncShortData, this, refreshList);
        }
    }
}