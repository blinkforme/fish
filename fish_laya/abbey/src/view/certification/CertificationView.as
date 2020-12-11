package view.certification
{
    import conf.cfg_battery;

    import emurs.ShowType;

    import engine.tool.StartParam;

    import laya.events.Event;
    import laya.utils.Handler;

    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.GameTools;
    import manager.ResVo;
    import manager.UiManager;
    import manager.WebSocketManager;

    import model.CertificationM;
    import model.LoginInfoM;
    import model.LoginM;
    import model.RoleInfoM;

    import struct.CertificationInfo;
    import struct.QuitTipInfo;

    import ui.abbey.CertificationPageUI;

    public class CertificationView extends CertificationPageUI implements ResVo
    {
        private var _startX:Number = 0;
        private var _startY:Number = 0;

        private var _info:CertificationInfo;


        public function CertificationView()
        {
            super();
        }

        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;
            _startX = this.x;
            _startY = this.y;
            _info = CertificationM.instance.info;
            if (_info)
            {
                if (_info.openFrom == GameConst.from_login)
                {
                    WebSocketManager.instance.send(60003, null);
                }
            } else
            {
                console.error("info null")
            }

            initBox();
            nameInput.on(Event.FOCUS_CHANGE, this, onFocusChange);
            idCardInput.on(Event.FOCUS_CHANGE, this, onFocusChange);
            telephoneInput.on(Event.FOCUS_CHANGE, this, onFocusChange);
            confirmBtn.on(Event.CLICK, this, onConfirmBtn);
            cancelBtn.on(Event.CLICK, this, onCancelBtn);
            quitBtn.on(Event.CLICK, this, onCancelBtn);
            exitBtn.on(Event.CLICK, this, onExitBtn);
            promptBtn.on(Event.CLICK, this, onPrompt)
            getvcode.on(Event.CLICK, this, sendBindVCode)
            bindBtn.on(Event.CLICK, this, bindTel);

            screenResize();
            bmask.on(Event.CLICK, this, clickMask);
            quickRegister.on(Event.CLICK, this, onQuickRegister);
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
                bindBtn.x = 245;
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
                bindBtn.x = 359;
            }
        }

        private function onQuickRegister()
        {
            UiManager.instance.closePanel("Certification", false);
            UiManager.instance.loadView("QuickRegister", GameConst.from_bank)
        }

        private function initBox():void
        {

            if (_info.openFrom == GameConst.from_bank)
            {
                if (_info.bindState)
                {
                    onCancelBtn(false);
                } else
                {
                    clearAll();
                    prompt_box.visible = true
                    quitBtn.visible = true;
                }
            } else if (_info.openFrom == GameConst.from_quick_register)
            {
                clearAll()
                bindBox.visible = true
                bindCountDown.visible = false
                quitBtn.visible = true;
            } else
            {
                if (_info.bindState)
                {
                    clearAll();
                    initView();
                } else
                {
                    clearAll()
                    bindBox.visible = true
                    bindCountDown.visible = false
                    quitBtn.visible = true;
                }
            }
        }

        private function refreshBox():void
        {
            if (RoleInfoM.instance.is_bind_tel)
            {
                if (!LoginM.instance.isCompleteCertification)
                {
                    _info.bindState = RoleInfoM.instance.is_bind_tel;
                    StartParam.instance.parseParam(
                            {
                                jjhid: jjhID.text
                            })
                    GameEventDispatch.instance.event(GameEvent.SyncBankCoin);
                    clearAll();
                    initView();
                } else
                {
                    _info.realState = LoginM.instance.isCompleteCertification;
                    onCancelBtn();
                }
            }
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

        private function clearInput():void
        {
            jjhNumber.text = "";
            jjhID.text = "";
            cipher.text = "";
            telephone.text = "";
            vCode.text = "";
            nameInput.text = "";
            idCardInput.text = "";
            telephoneInput.text = "";
        }

        private function clearAll():void
        {
            box2.visible = false
            box1.visible = false;
            prompt_box.visible = false
            bindBox.visible = false
            quitBtn.visible = false;
        }

        private function onPrompt():void
        {
            if (_info.bindState)
            {
                onCancelBtn(false);
            } else
            {
                clearAll()
                bindBox.visible = true
                bindCountDown.visible = false
                quitBtn.visible = true;
            }
        }

        var bindCountDownNum:Number = 60
        private var canSendSms:Boolean = true

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

        private function onFocusChange():void
        {
            nameInput.repaint();
            idCardInput.repaint();
            telephoneInput.repaint();
            this.repaint();
        }

        private function onExitBtn():void
        {
            GameEventDispatch.instance.event(GameEvent.ExitsGame);
        }

        private function initView():void
        {
            if (_info.openFrom == GameConst.from_shop)
            {
                desLabel.text = "为了保证您的账号安全，请在充值前进行实名认证;完成后会获得20钻石奖励";
            } else
            {
                desLabel.text = "为了您有更好的游戏体验，将进行实名认证;完成后会获得20钻石奖励";
            }

            if (_info.realForciblySwithState == 1)
            {
                if (_info.ageState == 0)
                {
                    box1.visible = false;
                    box2.visible = true;
                } else
                {
                    box1.visible = true;
                    box2.visible = false;
                    confirmBtn.x = 250
                    cancelBtn.visible = false;
                }
            } else
            {
                confirmBtn.x = 350
                box1.visible = true;
                box2.visible = false;
                cancelBtn.visible = true;
            }


            GameTools.clipTxt(confirmClip, "确定", GameConst.font_red);
            GameTools.clipTxt(cancelClip, "取消", GameConst.font_green);
        }

        private function checkCardId(str:String):Boolean
        {
            if (str.length < 18)
            {
                return false;
            }
            var arr:Array = [];
            var sum:Number = 0;
            for (var i:int = 0; i < str.length; i++)
            {
                if (arr[i] != "X")
                {
                    arr[i] = (str[i] as int);
                } else
                {
                    arr[i] = str[i];
                }
            }
            sum = arr[0] * 7 + arr[1] * 9 + arr[2] * 10 + arr[3] * 5 + arr[4] * 8 + arr[5] * 4 + arr[6] * 2 + arr[7] * 1
                    + arr[8] * 6 + arr[9] * 3 + arr[10] * 7 + arr[11] * 9 + arr[12] * 10 + arr[13] * 5 + arr[14] * 8
                    + arr[15] * 4 + arr[16] * 2;
            sum = 1 - sum;
            if ((sum % 11 + 11) == 11 || arr[17] == (sum % 11 + 11) || (arr[17] == "X" && (sum % 11 + 11) == 10))
            {
                return true;
            }
            return false;
        }

        private function getAge(identityCard:String):Number
        {
            var len = (identityCard + "").length;
            if (len == 0)
            {
                return 0;
            } else
            {
                if ((len != 15) && (len != 18))
                {
                    return 0;
                }
            }
            var strBirthday = "";
            if (len == 18)
            {
                strBirthday = identityCard.substr(6, 4) + "/" + identityCard.substr(10, 2) + "/" + identityCard.substr(12, 2);
            }
            if (len == 15)
            {
                strBirthday = "19" + identityCard.substr(6, 2) + "/" + identityCard.substr(8, 2) + "/" + identityCard.substr(10, 2);
            }

            var birthDate = new Date(strBirthday);
            var nowDateTime = new Date();
            var age = nowDateTime.getFullYear() - birthDate.getFullYear();

            if (nowDateTime.getMonth() < birthDate.getMonth() || (nowDateTime.getMonth() == birthDate.getMonth() && nowDateTime.getDate() < birthDate.getDate()))
            {
                age--;
            }
            return age;
        }

        private function onConfirmBtn():void
        {
            var nameReg:RegExp = /^[\u4E00-\u9FA5]{2,6}$/;
            var name:String = nameInput.text;
            var cardId:String = idCardInput.text;
            var telephone:String = telephoneInput.text;
            var idCardReg:RegExp = /^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$/;
            if (name == "")
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请输入真实姓名");
                return;
            } else if (!nameReg.test(name))
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "输入姓名不符合规范");
                return;
            }
            else if (cardId == "")
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请输入身份证号");
                return;
            } else if (!idCardReg.test(cardId) || !checkCardId(idCardInput.text))
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "输入的身份证号不规范");
                return;
            } else if (telephone == "")
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请输入手机号码");
                return;
            } else if (telephone.length != 11)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请输入正确的手机号码");
                return;
            }

            if (getAge(cardId) && getAge(cardId) < 18)
            {
                if (_info.realForciblySwithState == 0)
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "未满18周岁，实名认证失败");
                } else
                {
                    WebSocketManager.instance.send(60001, {name: name, cardId: cardId, ageType: 0, phone: telephone});
                    box1.visible = false;
                    box2.visible = true;
                }
            } else
            {
                WebSocketManager.instance.send(60001, {name: name, cardId: cardId, ageType: 1, phone: telephone});
                onCancelBtn(false)
            }
        }

        private function onCancelBtn(isCancel:Boolean = true):void
        {
            clearInput();
            if (_info.openFrom == GameConst.from_login)
            {
                GameEventDispatch.instance.event(GameEvent.Regic);
            } else if (_info.openFrom == GameConst.from_shop)
            {
                if (isCancel)
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "实名认证后才能购买此商品");
                } else
                {
                    GameEventDispatch.instance.event(GameEvent.QuitTip, _info.quitInfo);
                }
            } else if (_info.openFrom == GameConst.from_month)
            {
                if (isCancel)
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "实名认证后才能购买此商品");
                } else
                {
                    GameEventDispatch.instance.event(GameEvent.ShopBuy, _info.buyInfo);
                }
            } else if (_info.openFrom == GameConst.from_gift)
            {
                if (isCancel)
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "实名认证后才能购买此商品");
                } else
                {
                    UiManager.instance.loadView('MonthCard', false, ShowType.SMALL_TO_BIG)
                    GameEventDispatch.instance.event(GameEvent.OpenGift, _info.buyInfo);
                }
            } else if (_info.openFrom == GameConst.from_bank)
            {
                if (isCancel)
                {

                } else
                {
                    var batteryLevel = RoleInfoM.instance.getBattery();
                    if (LoginInfoM.instance.openBankBatteryLevel != 0 && batteryLevel < LoginInfoM.instance.openBankBatteryLevel)
                    {
                        var batteryLv = cfg_battery.instance(LoginInfoM.instance.openBankBatteryLevel).comsume;
                        GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请解锁" + batteryLv + "炮倍")
                    } else
                    {
                        GameEventDispatch.instance.event(GameEvent.OpenBankView);
                    }
                }
            }
            CertificationM.instance.info = null;
            UiManager.instance.closePanel("Certification", false);
        }

        private function clickMask():void
        {

        }

        private function screenResize():void
        {
            var contentWidth:int = 700;//组件范围width
            var contentHeight:int = 450;//组件范围height
            var contentStartX:int = 290;//组件左边距
            var contentStartY:int = 155;//组件上边距
            var posXOff:Number = (Laya.stage.width - contentWidth) / 2;
            var posYOff:Number = (Laya.stage.height - contentHeight) / 2;
            this.pos(_startX + posXOff - contentStartX, _startY + posYOff - contentStartY);
            this.size(Laya.stage.width, Laya.stage.height);

            quitBtn.left = contentStartX - posXOff;
            quitBtn.top = contentStartY - posYOff;
        }

        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.SynBankBindSuccess, this, refreshBox);
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
        }

        public function unRegister():void
        {
            this.x = _startX;
            this.y = _startY;
            GameEventDispatch.instance.off(GameEvent.SynBankBindSuccess, this, refreshBox);
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
        }
    }
}
