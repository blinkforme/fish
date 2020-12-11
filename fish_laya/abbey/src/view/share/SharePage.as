package view.share
{


    import conf.cfg_goods;

    import control.RedpointC;
    import control.WxC;

    import laya.ui.Box;
    import laya.ui.Image;

    import laya.ui.Label;

    import model.ActivityM;

    import model.ShareM;
    import model.WxM;


    import laya.events.Event;
    import laya.utils.Handler;
    import laya.utils.Tween;

    import manager.ApiManager;
    import manager.ConfigManager;
    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;
    import manager.WebSocketManager;

    import proto.C2s_34002;
    import proto.C2s_34004;

    import struct.QuitTipInfo;

    import ui.abbey.SharePageUI;

    public class SharePage extends SharePageUI implements ResVo
    {
        private var _nameArr:Array;
        private var _itemArr:Array;
        private var _infoArr:Array;
        private var _userInfoArr:Array;
        private var _headArr:Array;
        private var _headnameArr:Array;
        private var _roationArr:Array = [0, 45, 90, 135, 180, 225, 270, 315];
        private var _targetRoation:Number = 0;
        private var _prizeId:Number;
        private var _grayArr:Array;
        private var _isClick:Boolean = true;
        private var _lotteryTimes:Number = -1;
        private var noCanLotteryTims = 0;
        private var _isClose:Boolean = true;
        private var _type:Number = -1;
        private var _isClickLock:Boolean = true;
        private var _goodsArr:Array = [];
        private var _countsArr:Array = [];
        private var _everyItemArr:Array;
        private var _everyNameArr:Array;

        public function SharePage()
        {
            super();
            initItem();
            initHead();
            initEveryItem();
        }

        public function StartGames(parm:Object = null):void
        {

            clickAble();
            isShowShare();
            _isClose = true
            _isClick = true;
            _isClickLock = true;
            _infoArr = ShareM.instance.shareInfoArr;
            //startOne.on(Event.CLICK,this,clickStart);
            //startTwo.on(Event.CLICK,this,clickTwo);
            initEvent();
            startLottery.on(Event.CLICK, this, clicklottery);
            noLottery.on(Event.CLICK, this, clickNoLottery);
            initData();
            screenResize();
            clickLock();
            onQuitHelp();
            var accessToken:String = WxC.accessToken;
            closeBtn.on(Event.CLICK, this, clickClose);
            helpBtn.on(Event.CLICK, this, openHelpBox);
            quitHelp.on(Event.CLICK, this, onQuitHelp);
            list1.renderHandler = new Handler(this, updateHelp)
            list1.hScrollBarSkin = "";
            ApiManager.instance.shareInfo(accessToken, Handler.create(this, share), null);
        }

        public function clickNoLottery():void
        {
            clickBuyOne();
        }

        public function isShowShare():void
        {
            if (WxC.isInMiniGame())
            {
                evShareBtn.visible = WxM.instance.isShow;
                ThreeBar.visible = WxM.instance.isShow;
                addActivityPointShow();
            }

            if (ConfigManager.items("cfg_shareLottery_rule").length != 0)
            {
                helpBtn.visible = true;
            } else
            {
                helpBtn.visible = false;
            }
        }

        private function addActivityPointShow():void
        {
            var vertical_h = 10
            var horizontal_percent = 0.75

            if (ActivityM.instance.isShowShareRebate)
            {
                RedpointC.instance.removeActivityPoint(evShareBtn)
                RedpointC.instance.addActivityPointToIcon(evShareBtn, horizontal_percent, vertical_h, false)
            } else
            {
                RedpointC.instance.removeActivityPoint(evShareBtn)
            }
        }


        private function initEvent():void
        {
            evShareBtn.on(Event.CLICK, this, clickShare);
            lockingBtn.on(Event.CLICK, this, clickLock);
            wildBtn.on(Event.CLICK, this, clickWild);
            buyOneBtn.on(Event.CLICK, this, clickBuyOne);
            buyTenBtn.on(Event.CLICK, this, clickBuyTen);
        }

        private function clickBuyTen():void
        {
            //            clickUnable();
            //            var cs:C2s_34004 = new C2s_34004();
            //            cs.count = 10;
            //            cs.type = _type;
            //            WebSocketManager.instance.send(34004, cs);

            var info:QuitTipInfo = new QuitTipInfo();
            info.state = GameConst.quit_state_left_cancel_right_confirm;
            info.content = ConfigManager.getConfValue("cfg_tip", 71, "txtContent") as String;
            info.confirmMsg = GameEvent.BoomLotteryTen;
            info.autoCloseTime = 10;
            GameEventDispatch.instance.event(GameEvent.QuitTip, info);

        }

        private function openHelpBox():void
        {
            helpBoxMask.visible = true;
            helpBox.visible = true;
            quitHelp.visible = true;
            list1.refresh();
        }

        private function onQuitHelp():void
        {
            helpBox.visible = false;
            helpBoxMask.visible = false;
            quitHelp.visible = false;
        }

        private function updateHelp(cell:Box, index:Number):void
        {
            var date:Object = cell.dataSource;

            var ele_icon:Image = cell.getChildByName("icon") as Image;
            var ele_pro:Label = cell.getChildByName("pro") as Label;
            var ele_desc = cell.getChildByName("desc") as Label;

            ele_icon.skin = cfg_goods.instance(date.id).icon;
            ele_pro.text = date.pro;
            ele_desc.text = date.desc;
        }

        private function boomLotteryTen():void
        {
            clickUnable();
            var cs:C2s_34004 = new C2s_34004();
            cs.count = 10;
            cs.type = _type;
            WebSocketManager.instance.send(34004, cs);
        }

        private function clickUnable():void
        {
            evShareBtn.mouseEnabled = false;
            lockingBtn.mouseEnabled = false;
            wildBtn.mouseEnabled = false;
            buyOneBtn.mouseEnabled = false;
            buyTenBtn.mouseEnabled = false;
            closeBtn.mouseEnabled = false;
            startLottery.mouseEnabled = false;
            noLottery.mouseEnabled = false;
        }

        private function clickAble():void
        {
            evShareBtn.mouseEnabled = true;
            lockingBtn.mouseEnabled = true;
            wildBtn.mouseEnabled = true;
            buyOneBtn.mouseEnabled = true;
            closeBtn.mouseEnabled = true;
            startLottery.mouseEnabled = true;
            buyTenBtn.mouseEnabled = true;
            noLottery.mouseEnabled = true;
        }


        private function clickBuyOne():void
        {
            //            clickUnable();
            //            var cs:C2s_34004 = new C2s_34004();
            //            cs.count = 1;
            //            cs.type = _type;
            //            WebSocketManager.instance.send(34004, cs);

            var info:QuitTipInfo = new QuitTipInfo();
            info.state = GameConst.quit_state_left_cancel_right_confirm;
            info.content = ConfigManager.getConfValue("cfg_tip", 71, "txtContent") as String;
            info.confirmMsg = GameEvent.BoomLotteryOne;
            info.autoCloseTime = 10;
            GameEventDispatch.instance.event(GameEvent.QuitTip, info);

        }

        private function boomLotteryOne():void
        {
            clickUnable();
            var cs:C2s_34004 = new C2s_34004();
            cs.count = 1;
            cs.type = _type;
            WebSocketManager.instance.send(34004, cs);
        }

        private function clickShare():void
        {
            hideAll();
            helpBtn.visible = false;
            evShareBtn.selected = true;
            userImg.visible = true;
            startLottery.visible = true;
            panBox.visible = true;
            Sharelabel.visible = true;
            ThreeBar.visible = true
        }

        private function clickLock():void
        {
            hideAll();
            helpBtn.visible = true;
            oneBar.visible = true;
            lockingBtn.selected = true;
            buyBox.visible = true;
            noLottery.visible = true;
            everyBox.visible = true;
            _type = 1;
            onePrize.text = "50000"
            tenPrize.text = "500000"
            lockData();
            lockinglabel.visible = true;

            var help_arr:Array = [];
            var cfg:Array = ConfigManager.items("cfg_shareLottery_rule");
            for (var i = 0; i < cfg.length; i++)
            {
                if (cfg[i].lottry_id == 1)
                {
                    help_arr.push({
                        id: cfg[i].rewardId,
                        pro: cfg[i].lottry_probability,
                        desc: cfg[i].lottry_description
                    })
                }
            }
            list1.array = help_arr;
        }

        private function clickWild():void
        {
            hideAll();
            helpBtn.visible = true;
            TwoBar.visible = true;
            wildBtn.selected = true;
            buyBox.visible = true;
            noLottery.visible = true;
            everyBox.visible = true;
            _type = 2;
            wildData();
            onePrize.text = "500000"
            tenPrize.text = "5000000"
            wildlabel.visible = true;

            var help_arr:Array = [];
            var cfg:Array = ConfigManager.items("cfg_shareLottery_rule");
            for (var i = 0; i < cfg.length; i++)
            {
                if (cfg[i].lottry_id == 2)
                {
                    help_arr.push({
                        id: cfg[i].rewardId,
                        pro: cfg[i].lottry_probability,
                        desc: cfg[i].lottry_description
                    })
                }
            }
            list1.array = help_arr;

        }

        private function hideAll():void
        {
            evShareBtn.selected = false;
            lockingBtn.selected = false;
            wildBtn.selected = false;
            oneBar.visible = false;
            TwoBar.visible = false;
            ThreeBar.visible = false;
            buyBox.visible = false;
            userImg.visible = false;
            startLottery.visible = false;
            noLottery.visible = false;
            panBox.visible = false;
            everyBox.visible = false;
            Sharelabel.visible = false;
            lockinglabel.visible = false;
            wildlabel.visible = false;
        }


        private function clickClose():void
        {
            if (_isClose)
            {
                UiManager.instance.closePanel("Share", false);

            }
        }

        private function clicklottery():void
        {
            //	tranTarget(4);

            if (_isClick == true)
            {
                WebSocketManager.instance.send(34000, null);

                clickUnable();
                _isClick = false;
            }

        }

        private function initHead():void
        {
            _headArr = [];
            _headnameArr = [head_1, head_2, head_3, head_4, head_5];
            for (var i:int = 0; i < _headnameArr.length; i++)
            {
                var head:Head = new Head(_headnameArr[i]);
                _headArr.push(head);
            }
        }


        private function initItem():void
        {
            _itemArr = [];
            _nameArr = [item_1, item_2, item_3, item_4, item_5, item_6, item_7, item_8];
            for (var i:int = 0; i < _nameArr.length; i++)
            {
                var item:Item = new Item(_nameArr[i]);
                _itemArr.push(item);
            }
        }

        private function initEveryItem():void
        {
            _everyItemArr = [];
            _everyNameArr = [everyItem_1, everyItem_2, everyItem_3, everyItem_4, everyItem_5, everyItem_6, everyItem_7, everyItem_8];
            for (var i:int = 0; i < _everyNameArr.length; i++)
            {
                var everyItem:EveryItem = new EveryItem(_everyNameArr[i]);
                _everyItemArr.push(everyItem);
            }
        }

        private function initData():void
        {
            for (var i:int = 0; i < _itemArr.length; i++)
            {
                Item(_itemArr[i]).setItemInfo(_infoArr[i]);
            }
        }


        private function lockData():void
        {
            for (var i:int = 0; i < _everyItemArr.length; i++)
            {
                EveryItem(_everyItemArr[i]).setItemInfo(_infoArr[i], 1);
            }
        }

        public function wildData():void
        {
            for (var i:int = 0; i < _everyItemArr.length; i++)
            {
                for (var i:int = 0; i < _everyItemArr.length; i++)
                {
                    EveryItem(_everyItemArr[i]).setItemInfo(_infoArr[i], 2);
                }
            }
        }

        private function clickTwo():void
        {

            UiManager.instance.closePanel("Share", false);
        }

        private function share(obj:Object):void
        {
            _userInfoArr = [];
            _grayArr = [];
            var noCanLotteryTims:Number = 0;
            if (obj["code"] == "success")
            {
                _userInfoArr = obj["data"]["invited_user"]
                _grayArr = obj["data"]["prize_ids"]
                _lotteryTimes = obj["data"]["can_lottery_times"]
            }
            if (_userInfoArr == null)
            {
                _userInfoArr = [];
            }

            if (_grayArr == null)
            {
                _grayArr = [];
            }
            for (var i:int = 0; i < 5; i++)
            {
                Head(_headArr[i]).setHeadInfo(_userInfoArr[i]);
            }

            for (var i:int = 0; i < _grayArr.length; i++)
            {
                var prizeId:Number = _grayArr[i];
                for (var j:int = 0; j < 8; j++)
                {
                    if (_itemArr[j].id == prizeId)
                    {
                        _itemArr[j].isDray();
                    }
                }
            }
            if (_userInfoArr.length > 0)
            {
                noCanLotteryTims = _userInfoArr.length - _lotteryTimes;
                if (noCanLotteryTims > 0)
                {
                    for (var i:int = 0; i < noCanLotteryTims; i++)
                    {
                        Head(_headArr[i]).haveLottery();
                    }
                }

            }

        }


        private function tranTarget(id:Number):void
        {
            var index:Number = id - 1;
            _targetRoation = _roationArr[index];
            var firstRoation:Number = panBox.rotation + 1000;
            //Laya.timer.loop(5,this,start);
            Tween.to(panBox, {rotation: firstRoation}, 700, null, Handler.create(this, complete));
        }

        private function complete():void
        {
            var secondRoation:Number = panBox.rotation + 800;
            Tween.to(panBox, {rotation: secondRoation}, 700, null, Handler.create(this, Oncomplete));

        }

        private function Oncomplete():void
        {
            var thirdRaotion:Number = panBox.rotation + 600;
            Tween.to(panBox, {rotation: thirdRaotion}, 700, null, Handler.create(this, twocomplete));

        }

        private function twocomplete():void
        {
            var n:Number = Math.floor(panBox.rotation / 360);
            var currentRoation:Number = panBox.rotation;
            var targetRoation:Number = (n + 2) * 360 + _targetRoation;

            Tween.to(panBox, {rotation: targetRoation}, 700, null, Handler.create(this, threecomplete));
        }


        private function threecomplete():void
        {
            _isClose = true;

            clickAble();
            var c2s:C2s_34002 = new C2s_34002();
            c2s.prize_id = _prizeId;
            WebSocketManager.instance.send(34002, c2s);
        }

        private function screenResize():void
        {
            helpBoxMask.width = Laya.stage.width * 2;
            helpBoxMask.height = Laya.stage.height * 2;
            bgMask.width = Laya.stage.width * 2;
            bgMask.height = Laya.stage.height * 2;
            this.size(Laya.stage.width, Laya.stage.height);

        }

        private function showLottery(msg:Object):void
        {
            _isClick = true;
            if (msg.code == 0)
            {
                noCanLotteryTims = noCanLotteryTims + 1;
                if (noCanLotteryTims > 0)
                {
                    for (var i:int = 0; i < noCanLotteryTims; i++)
                    {
                        Head(_headArr[i]).haveLottery();
                    }
                }
                var prizeId:Number = msg["prize_id"];
                for (var i:int = 0; i < _itemArr.length; i++)
                {
                    if (Item(_itemArr[i]).id == prizeId)
                    {
                        Item(_itemArr[i]).isDray();
                    }
                }
                var goodsId:Number = ShareM.instance.getGoodsId(prizeId);
                var count:Number = ShareM.instance.count(prizeId);
                GameEventDispatch.instance.event(GameEvent.RewardTip, [[goodsId], [count]]);
            }

        }


        private function lotteryComplete(msg:Object):void
        {
            if (msg.code == 0)
            {
                _isClose = false;
                _prizeId = msg["prize_id"];
                tranTarget(_prizeId);
            } else if (msg.code == 1)
            {
                _isClick = true;
                clickAble()
            } else if (msg.code == 2)
            {
                _isClick = true;
                clickAble();
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "今日抽奖次数已达到上限，请明日再来");

            } else if (msg.code == 3)
            {
                _isClick = true;
                clickAble();
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "抽奖次数不够，邀请好友可获得更多抽奖次数");
            }
            else if (msg.code == 100)
            {
                clickAble();
                _isClick = true;
            } else
            {
                clickAble();
                _isClick = true;

            }
        }

        public function register():void
        {
            GameEventDispatch.instance.on(String(34001), this, lotteryComplete);
            GameEventDispatch.instance.on(String(34003), this, showLottery);
            GameEventDispatch.instance.on(String(34005), this, startZhuan);
            GameEventDispatch.instance.on(String(34007), this, getReward);
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.on(GameEvent.BoomLotteryOne, this, boomLotteryOne);
            GameEventDispatch.instance.on(GameEvent.BoomLotteryTen, this, boomLotteryTen);
        }

        public function unRegister():void
        {
            GameEventDispatch.instance.off(String(30001), this, lotteryComplete);
            GameEventDispatch.instance.off(String(34003), this, showLottery);
            GameEventDispatch.instance.off(String(34005), this, startZhuan);
            GameEventDispatch.instance.off(String(34007), this, getReward);
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.off(GameEvent.BoomLotteryOne, this, boomLotteryOne);
            GameEventDispatch.instance.off(GameEvent.BoomLotteryTen, this, boomLotteryTen);
        }

        private function startRaote():void
        {

        }

        private function getReward(msg:Object):void
        {
            if (msg.code == 0)
            {
                var goodsArr:Array = msg["reward_item_ids"];
                var countsArr:Array = msg["reward_item_nums"];
                GameEventDispatch.instance.event(GameEvent.RewardTip, [goodsArr, countsArr]);
            }

        }

        private function roateTarget(id:Number):void
        {
            //var index:Number = id-1;
            //_targetRoation = _roationArr[index];
            var firstRoation:Number = everyBox.rotation + 500;
            //Laya.timer.loop(5,this,start);
            Tween.to(everyBox, {rotation: firstRoation}, 375, null, Handler.create(this, Everycomplete));
        }

        private function Everycomplete():void
        {
            var secondRoation:Number = everyBox.rotation + 400;
            Tween.to(everyBox, {rotation: secondRoation}, 375, null, Handler.create(this, EveryOncomplete));

        }

        private function EveryOncomplete():void
        {
            var thirdRaotion:Number = everyBox.rotation + 300;
            Tween.to(everyBox, {rotation: thirdRaotion}, 375, null, Handler.create(this, Everytwocomplete));
        }

        private function Everytwocomplete():void
        {
            var n:Number = Math.floor(everyBox.rotation / 360);
            var currentRoation:Number = everyBox.rotation;
            var targetRoation:Number = (n + 2) * 360 + 45;
            GameEventDispatch.instance.event(GameEvent.RewardTip, [_goodsArr, _countsArr]);
            Tween.to(everyBox, {rotation: targetRoation}, 375, null, Handler.create(this, Everythreecomplete));
        }

        private function Everythreecomplete():void
        {
            clickAble();
            //WebSocketManager.instance.send(34006,null);
        }

        private function startZhuan(msg:Object):void
        {
            if (msg.code == 0)
            {
                _countsArr = msg["reward_item_nums"];
                _goodsArr = msg["reward_item_ids"];
                roateTarget(3);
            } else if (msg.code == 1)
            {
                clickAble();
            } else if (msg.code == 2)
            {
                clickAble();
                GameEventDispatch.instance.event(GameEvent.Shop, "tab_coin");
            } else if (msg.code == 3)
            {
                clickAble();
            } else if (msg.code == 99)
            {

            } else if (msg.code == 100)
            {

            }

        }


    }
}
