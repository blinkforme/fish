package view.friend
{
    import conf.cfg_battery;
    import conf.cfg_goods;

    import control.RedpointC;
    import control.T360C;
    import control.WxC;

    import emurs.ShowType;

    import engine.tool.StartParam;

    import laya.events.Event;
    import laya.ui.Box;
    import laya.ui.Button;
    import laya.ui.Image;
    import laya.ui.Label;
    import laya.ui.List;
    import laya.utils.Browser;
    import laya.utils.Handler;
    import laya.utils.Tween;

    import manager.ApiManager;
    import manager.ConfigManager;
    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.GameTools;
    import manager.ResVo;
    import manager.ShieldWordManager;
    import manager.UiManager;
    import manager.WebSocketManager;

    import model.FightM;
    import model.FriendM;
    import model.LoginInfoM;
    import model.RoleInfoM;
    import model.SkillM;

    import struct.FriendInfo;
    import struct.QuitTipInfo;

    import ui.abbey.FriendPageUI;

    public class FriendPage extends FriendPageUI implements ResVo
    {

        private var isClickGiftArr:Array;
        private var sendInfo:FriendInfo;
        private var giftData:Object;
        private var inputCount:Number = 1;

        private var chooseIndex:Number = -1

        public function FriendPage()
        {

        }

        public function StartGames(parm:Object = null):void
        {
            this.on(Event.MOUSE_DOWN, this, recoveryAllGiftBox)
            checkOnLineBox.selected = false
            closeGiftBox()
            bmask.on(Event.CLICK, this, null)
            quitBtn.on(Event.CLICK, this, onQuitBtn)
            friendBtn.on(Event.MOUSE_OUT, this, onMouseOut)
            friendBtn.on(Event.MOUSE_OVER, this, onMouseOver)
            friendBtn.on(Event.CLICK, this, onFriendBtn)
            friendBtn.on(Event.MOUSE_UP, this, onMouseOut)
            addFriendBtn.on(Event.CLICK, this, onAddFriendBtn)
            findBtn.on(Event.CLICK, this, onFindBtn)
            quit_gift_box.on(Event.CLICK, this, closeGiftBox)
            count_jia.on(Event.CLICK, this, countJia);
            count_jian.on(Event.CLICK, this, countJian);
            useBtn.on(Event.CLICK, this, onUseBtn)
            gift_confirm.on(Event.CLICK, this, onGiftConfirm)
            signatureBtn.on(Event.CLICK, this, openSignatureBox)
            codequiteBtn.on(Event.CLICK, this, closeSignatureBox)
            codeconfirmBtn.on(Event.CLICK, this, onSignatureBtn)
            grantBtn.on(Event.CLICK, this, onGrantBtn)
            allRejectBtn.on(Event.CLICK, this, checkFriendship, [GameConst.reject_status, 1])
            allAgreeBtn.on(Event.CLICK, this, checkFriendship, [GameConst.agree_status, 1])
            friendList.renderHandler = new Handler(this, renderFriendList)
            addFriendList.renderHandler = new Handler(this, renderAddFriendList)
            checkOnLineBox.on(Event.CLICK, this, onCheckOnLineBox);
            writegiftInput.on(Event.INPUT, this, onFocusChange)
            onFriendBtn();
            showFriendRedPoint();
            syncBankInfoEnd()
            GameTools.clipTxt(fontClip2, "取消", GameConst.font_red);
            GameTools.clipTxt(fontClip1, "购买", GameConst.font_green);
            screenResize();
        }

        private function onMouseOut(e:Event):void
        {
            if (!friendBtn.selected)
            {
                numPercent.strokeColor = "#043e63"
            }
        }

        private function onMouseOver(e:Event):void
        {
            if (!friendBtn.selected)
            {
                numPercent.strokeColor = "#653a00"
            }
        }

        private function onCheckOnLineBox()
        {
            refreshFriendList()
        }

        private function syncBankInfoEnd():void
        {
            if (T360C.is360Game())
            {
                idLabel.text = "我的ID:" + StartParam.instance.getParam("uid")
                copyBtn.offAll(Event.CLICK);
                if (WxC.isInMiniGame())
                {
                    copyBtn.on(Event.CLICK, this, onBtnCopyClick);
                }
                else
                {
                    copyBtn.on(Event.CLICK, this, onCopyUserId)
                }
            } else
            {
                if (StartParam.instance.getParam("jjhid") && StartParam.instance.getParam("jjhid").length > 0)
                {
                    idLabel.text = "我的ID:" + StartParam.instance.getParam("jjhid");//(RoleInfoM.instance.puuid + "").split(":")[1]
                    copyBtn.offAll(Event.CLICK);
                    if (WxC.isInMiniGame())
                    {
                        copyBtn.on(Event.CLICK, this, onBtnCopyClick);
                    }
                    else
                    {
                        copyBtn.on(Event.CLICK, this, onCopyUserId)
                    }
                } else
                {
                    copyBtn.visible = true;
                    copyBtn.disabled = true
                    idLabel.text = "绑定成功获取ID"
                }
            }
        }

        public function onCopyUserId():void
        {
            GameTools.copyToClipboard(idLabel.text.slice(5));
        }

        public function onBtnCopyClick(event:Event):void
        {
            WxC.wx_set_clipboard_data(idLabel.text.slice(5));
        }

        private function onFindBtn():void
        {
            var idStr:String = findIdInput.text
            var idReg:RegExp = /^[1-9]\d*$/
            if (idStr.length < 6 || idStr.length > 10 || !idReg.test(idStr))
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请输入正确的ID")
                return
            }
            FriendM.instance.searchFriend(idStr)
        }

        private function onUseBtn()
        {
            closeGiftBox()
        }

        private function onGrantBtn()
        {
            UiManager.instance.loadView("MonthCard", {id: GameConst.month_card_id}, ShowType.SMALL_TO_BIG);
            closeGiftBox()
        }

        private function renderFriendList(cell:Box, index:int):void
        {
            var config:FriendInfo = cell.dataSource
            var ele_bg:Image = cell.getChildByName("bg") as Image
            var ele_rankImg:Image = cell.getChildByName("rankImg") as Image
            var ele_rankLabel:Label = cell.getChildByName("rankLabel") as Label
            var ele_icon:Image = cell.getChildByName("icon") as Image
            var ele_name:Label = cell.getChildByName("name") as Label
            var ele_level:Label = cell.getChildByName("level") as Label
            var ele_onlineLabel:Label = cell.getChildByName("onlineLabel") as Label
            var ele_signature:Label = cell.getChildByName("signature") as Label
            var ele_deleteBtn:Button = cell.getChildByName("deleteBtn") as Button
            var ele_giftBtn:Button = cell.getChildByName("giftBtn") as Button
            var giftListBg:Image = cell.getChildByName("giftListBg") as Image
            var ele_giftList:List = cell.getChildByName("giftList") as List

            ele_rankImg.visible = false
            ele_rankLabel.visible = false
            giftListBg.visible = false
            isClickGiftArr[index] = -1
            ele_giftList.visible = false
            if (index == 0)
            {
                ele_rankImg.skin = "ui/friend/rank1.png"
                ele_rankImg.visible = true
            } else if (index == 1)
            {
                ele_rankImg.skin = "ui/friend/rank2.png"
                ele_rankImg.visible = true
            } else if (index == 2)
            {
                ele_rankImg.skin = "ui/friend/rank3.png"
                ele_rankImg.visible = true
            } else
            {
                ele_rankLabel.text = String(index + 1)
                ele_rankLabel.visible = true
            }

            if (config.icon && String(config.icon).length > 0)
            {
                ele_icon.skin = config.icon
            } else
            {
                ele_icon.skin = "ui/common/nan.png"
            }
            ele_name.text = LoginInfoM.instance.filterName(GameTools.formatNickName(config.name))
            ele_level.text = "LV." + config.level
            if (config.online)
            {
                ele_onlineLabel.disabled = false
                ele_onlineLabel.text = "在线"
            } else
            {
                ele_onlineLabel.disabled = true
                ele_onlineLabel.text = "离线"
            }
            if (config.signature == "")
            {
                ele_signature.text = "欢迎来到集结号捕鱼"
            } else
            {
                ele_signature.text = config.signature
            }
            ele_deleteBtn.offAll(Event.CLICK)
            ele_giftBtn.offAll(Event.CLICK)
            ele_deleteBtn.on(Event.CLICK, this, requestDeleteFriend, [String(config.id)])
            ele_giftBtn.on(Event.CLICK, this, onRefreshGiftBox, [index])
            ele_giftList.renderHandler = Handler.create(this, renderGiftList, null, false)

        }

        private function onRefreshGiftBox(index:Number):void
        {
            var cell:Box
            var giftListBg:Image
            var ele_giftList:List
            if (chooseIndex >= 0 && chooseIndex == index)
            {
                cell = friendList.getCell(index);
                giftListBg = cell.getChildByName("giftListBg") as Image
                ele_giftList = cell.getChildByName("giftList") as List
                giftListBg.visible = false
                ele_giftList.visible = false
                ele_giftList.array = FightM.instance.getyuleiItems()
                isClickGiftArr[index] = index
                chooseIndex = -1
                return
            }
            recoveryGiftBox()
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
                if (WxC.isInMiniGame() && Browser.onIOS)
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent,"激活月卡，开放赠送功能")
                } else
                {
                    tip_box.scaleX = 0;
                    tip_box.scaleY = 0;
                    Tween.to(tip_box, {scaleX: 1.05, scaleY: 1.05}, 300, null, Handler.create(this, showComplete))
                    tip_box.visible = true;
                    giftbox1.visible = true;
                    giftbox2.visible = false;
                    quit_gift_box.visible = false;
                }
            } else
            {
                cell = friendList.getCell(index);
                (cell.getChildByName("giftListBg") as Image).visible = true
                ele_giftList = (cell.getChildByName("giftList") as List)
                ele_giftList.visible = true
                ele_giftList.array = FightM.instance.getyuleiItems()
                isClickGiftArr[index] = index
                chooseIndex = index
            }
        }

        private function recoveryAllGiftBox(event:Event):void
        {
            if (event.target && event.target.name && (event.target.name == "giftList"
                    || event.target.name == "giftListBg" || event.target.name == "giftBtn"
                    || (event.target.parent && event.target.parent.parent &&
                            event.target.parent.parent.name == "giftList")))
            {
                return
            }
            if (tip_box.visible)
            {
                return
            }
            recoveryGiftBox()
        }

        private function recoveryGiftBox():void
        {
            if (box1.visible == true && chooseIndex >= 0)
            {
                var cell:Box
                var giftListBg:Image
                var ele_giftList:List
                for (var i:int = 0; i < friendList.array.length; i++)
                {
                    cell = friendList.getCell(i);
                    if (cell)
                    {
                        giftListBg = cell.getChildByName("giftListBg") as Image
                        ele_giftList = cell.getChildByName("giftList") as List
                        giftListBg.visible = false
                        ele_giftList.visible = false
                    }
                    isClickGiftArr[i] = -1
                    chooseIndex = -1
                }
            }
        }

        private function requestDeleteFriend(id:String):void
        {
            var info:QuitTipInfo = new QuitTipInfo();
            info.state = GameConst.quit_state_left_cancel_right_confirm;
            info.content = "是否确认删除互相的好友关系？";
            info.confirmCallback = Handler.create(this, deleteFriend, [id]);
            info.autoCloseTime = 10;
            GameEventDispatch.instance.event(GameEvent.QuitTip, info);
        }

        private function deleteFriend(id:String):void
        {
            var token:String = StartParam.instance.getParam("access_token")
            ApiManager.instance.deleteFriend(token, id, Handler.create(this, deleteFriendSuccess), Handler.create(this, deleteFriendError))
        }

        private function deleteFriendSuccess(data:*)
        {
            if (data.code == "success")
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "删除成功")
                WebSocketManager.instance.send(70003, {});
            } else
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, data.msg)
            }
        }

        private function deleteFriendError(data:*)
        {
        }


        private function renderGiftList(cell:Box, index:int):void
        {
            var config:cfg_goods = cell.dataSource;
            var ele_giftIcon:Image = cell.getChildByName("giftIcon") as Image
            var ele_giftLabel:Label = cell.getChildByName("giftLabel") as Label
            ele_giftIcon.skin = config.icon;
            ele_giftLabel.text = SkillM.instance.skillCount(5 + index, false) + ""
            cell.offAll(Event.CLICK);
            cell.on(Event.CLICK, this, sendGift, [config, SkillM.instance.skillCount(5 + index, false)])

        }

        private function sendGift(config, good_count:Number)
        {
            var mini_battery:Number = ConfigManager.getConfValue("cfg_global", 1, "min_battery") as Number
            if (RoleInfoM.instance.getBattery() < mini_battery)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, cfg_battery.instance(mini_battery).comsume + "倍炮台，开放赠送功能");
                return;
            }
            if (good_count == 0)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "道具不足");
            } else
            {
                giftData = config
                tip_box.scaleX = 0;
                tip_box.scaleY = 0;
                Tween.to(tip_box, {scaleX: 1.05, scaleY: 1.05}, 300, null, Handler.create(this, showComplete))
                sendInfo = friendList.array[chooseIndex] as FriendInfo
                inputCount = 1
                item_count.value = "1"
                tip_box.visible = true;
                giftbox1.visible = false;
                giftbox2.visible = true;
                quit_gift_box.visible = true;
                username.text = sendInfo.name + "";
                if (sendInfo.icon && String(sendInfo.icon).length > 0)
                {
                    userimg.skin = sendInfo.icon
                } else
                {
                    userimg.skin = "ui/common/nan.png"
                }
                gift_icon.skin = giftData.icon;
                gift_name.text = giftData.name;
            }
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

        private function closeGiftBox():void
        {
            tip_box.visible = false
            quit_gift_box.visible = false
        }

        private function onGiftConfirm():void
        {

            var item_count:Number = inputCount;
            var info:QuitTipInfo = new QuitTipInfo();
            info.state = GameConst.quit_state_left_cancel_right_confirm;
            info.content = "<span>确认赠送</span> <span style='color:red'>&nbsp;" + giftData.name + " x " + item_count + "&nbsp;</span> <span>给 </span> <span  style='color:red'>&nbsp;" + GameTools.nameSkip(username.text) + "&nbsp;</span><span>？</span>";
            info.confirmCallback = Handler.create(this, gift, [item_count]);
            info.autoCloseTime = 10;
            GameEventDispatch.instance.event(GameEvent.QuitTip, info);
        }

        private function gift():void
        {
            var item_count:Number = inputCount;
            var data:Object = {item_id: giftData.id, item_count: item_count, user_id: parseInt(sendInfo.id)}
            WebSocketManager.instance.send(14017, data)
            recoveryGiftBox()
            closeGiftBox()
        }

        private function showComplete():void
        {
            Tween.to(tip_box, {scaleX: 1, scaleY: 1}, 250);
        }

        private function renderAddFriendList(cell:Box, index:int):void
        {
            var config:Object = cell.dataSource
            var ele_icon:Image = cell.getChildByName("icon") as Image
            var ele_name:Label = cell.getChildByName("name") as Label
            var ele_level:Label = cell.getChildByName("level") as Label
            var ele_des:Label = cell.getChildByName("des") as Label
            var ele_shieldBtn:Button = cell.getChildByName("shieldBtn") as Button
            var ele_rejectBtn:Button = cell.getChildByName("rejectBtn") as Button
            var ele_agreeBtn:Button = cell.getChildByName("agreeBtn") as Button

            if (config.avatar && String(config.avatar).length > 0)
            {
                ele_icon.skin = config.avatar
            } else
            {
                ele_icon.skin = "ui/common/nan.png"
            }
            ele_name.text = LoginInfoM.instance.filterName(GameTools.formatNickName(config.nickname))
            ele_level.text = "LV." + config.level
            ele_des.text = config.to_msg
            ele_shieldBtn.offAll(Event.CLICK)
            ele_rejectBtn.offAll(Event.CLICK)
            ele_agreeBtn.offAll(Event.CLICK)
            ele_shieldBtn.on(Event.CLICK, this, checkFriendship, [GameConst.shield_status, 0, config['user_id']]);
            ele_rejectBtn.on(Event.CLICK, this, checkFriendship, [GameConst.reject_status, 0, config['user_id']]);
            ele_agreeBtn.on(Event.CLICK, this, checkFriendship, [GameConst.agree_status, 0, config['user_id']]);
        }

        private function checkFriendship(status:Number, isAll:Number, id:Number = null):void
        {
            if (status == GameConst.agree_status)
            {
                if (FriendM.instance.friendArr.length >= FriendM.instance.friendLimit)
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "好友过多，请删除好友后再试")
                    return
                }
            }
            var token:String = StartParam.instance.getParam("access_token")
            ApiManager.instance.updateFriendRelation(token, status, isAll, id, Handler.create(this, updateFriendshipSuccess, [status]), Handler.create(this, updateFriendshipError))
        }

        private function updateFriendshipSuccess(status:Number, data:*)
        {
            if (data.code == "success")
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "已完成")
                WebSocketManager.instance.send(70004, {});
                if (status == GameConst.agree_status)
                {
                    WebSocketManager.instance.send(70003, {});
                }
            } else
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, data.msg)
            }
        }

        private function updateFriendshipError(data:*)
        {

        }

        private function closeSignatureBox():void
        {
            writegiftcode.visible = false
            codequiteBtn.visible = false
        }

        private function openSignatureBox():void
        {
            if (FriendM.instance.signatureStr == "")
            {
                writegiftInput.text = ""
            } else
            {
                writegiftInput.text = FriendM.instance.signatureStr;
            }
            codeconfirmBtn.disabled = true
            writegiftcode.visible = true
            codequiteBtn.visible = true
        }

        private function onFocusChange(e:Event):void
        {
            if (writegiftInput.text == FriendM.instance.signatureStr)
            {
                codeconfirmBtn.disabled = true
            } else
            {
                codeconfirmBtn.disabled = false
            }
        }

        private function onSignatureBtn():void
        {
            var nullReg:RegExp = /^\s*$/
            var str:String = writegiftInput.text
            if (nullReg.test(str))
            {
                str = null
            } else
            {
                str = ShieldWordManager.instance.filterInfo(writegiftInput.text)
                str = LoginInfoM.instance.filterName(str)
                writegiftInput.text = str;
            }
            var token = StartParam.instance.getParam("access_token");
            ApiManager.instance.updateRemark(token, str, Handler.create(this, updateRemarkSuccess), Handler.create(this, updateRemarkError))
        }

        private function updateRemarkSuccess(data:*):void
        {
            if (data.code == "success")
            {
                FriendM.instance.signatureStr = data.data.current_remark;
                signatureInput.text = FriendM.instance.signatureStr
                closeSignatureBox()
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "修改完成")
            } else
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, data.msg)
            }
        }

        private function updateRemarkError(data:*):void
        {

        }

        private function onFriendBtn():void
        {
            bgImg.height = 381
            bgImg.y = 213
            friendBtn.selected = true
            addFriendBtn.selected = false
            box1.visible = true
            box2.visible = false
            numPercent.strokeColor = "#653a00"
            refreshFriendList()
        }

        private function refreshFriendList()
        {
            noFriendBox.visible = false
            friendList.visible = false
            noFriendLabel.visible = false
            noOnLineLabel.visible = false
            isClickGiftArr = []
            var arr:Array = []
            if (checkOnLineBox.selected)
            {
                arr = FriendM.instance.onlineFriendArr
            } else
            {
                arr = FriendM.instance.friendArr
            }
            friendList.array = arr
            friendList.refresh()
            if (!arr || !arr.length || arr.length <= 0)
            {
                if (checkOnLineBox.selected == true)
                {
                    noOnLineLabel.visible = true
                } else
                {
                    noFriendLabel.visible = true
                }
                noFriendBox.visible = true
            } else
            {
                friendList.visible = true
            }
            if (FriendM.instance.signatureStr == "")
            {
                signatureInput.text = "留下你的个性签名，让好友们更好的认识你吧"
            } else
            {
                signatureInput.text = FriendM.instance.signatureStr;
            }
            numPercent.text = "(" + FriendM.instance.friendArr.length + "/" + FriendM.instance.friendLimit + ")"
        }

        private function onAddFriendBtn():void
        {
            bgImg.height = 428
            bgImg.y = 166
            findIdInput.text = ""
            friendBtn.selected = false
            addFriendBtn.selected = true
            box1.visible = false
            box2.visible = true
            numPercent.strokeColor = "#043e63"
            refreshApplyFriendList()
        }

        private function refreshApplyFriendList()
        {
            nothingBox.visible = false
            addFriendList.visible = false
            allRejectBtn.visible = false
            allAgreeBtn.visible = false
            if (!FriendM.instance.noApplyFriendList())
            {
                nothingBox.visible = true

            } else
            {
                addFriendList.array = FriendM.instance.applyFriendArr
                addFriendList.visible = true
                allRejectBtn.visible = true
                allAgreeBtn.visible = true
            }
        }

        private function showFriendRedPoint():void
        {
            var vertical_h = 10
            var horizontal_percent = 0.75
            if (FriendM.instance.noApplyFriendList())
            {
                RedpointC.instance.removeRedPoint(addFriendBtn)
                RedpointC.instance.addRedPointToIcon(addFriendBtn, horizontal_percent, vertical_h)
            } else
            {
                RedpointC.instance.removeRedPoint(addFriendBtn)
            }
        }

        private function onQuitBtn():void
        {
            UiManager.instance.closePanel("Friend", true)
        }

        private function screenResize():void
        {
            this.size(Laya.stage.width, Laya.stage.height);
        }

        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.refreshFriendList, this, refreshFriendList);
            GameEventDispatch.instance.on(GameEvent.refreshApplyFriendList, this, refreshApplyFriendList);
            GameEventDispatch.instance.on(GameEvent.refreshApplyFriendList, this, showFriendRedPoint);
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);

        }

        public function unRegister():void
        {
            GameEventDispatch.instance.off(GameEvent.refreshFriendList, this, refreshFriendList);
            GameEventDispatch.instance.off(GameEvent.refreshApplyFriendList, this, refreshApplyFriendList);
            GameEventDispatch.instance.off(GameEvent.refreshApplyFriendList, this, showFriendRedPoint);
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
        }

    }
}
