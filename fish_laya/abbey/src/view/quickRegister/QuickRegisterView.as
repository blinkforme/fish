package view.quickRegister
{
    import conf.cfg_battery;

    import control.LoginC;

    import emurs.ShowType;

    import engine.tool.StartParam;

    import laya.events.Event;

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

    import ui.abbey.CertificationPageUI;
    import ui.abbey.QuickRegisterPageUI;

    public class QuickRegisterView extends QuickRegisterPageUI implements ResVo
    {
        private var _startX:Number = 0;
        private var _startY:Number = 0;

        private var codeTime:Number = 60;
        private var confirmDelayTime:Number = 5;


        public function QuickRegisterView()
        {
            super();
        }

        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;
            _startX = this.x;
            _startY = this.y;
            initBox(parm);
            nameInput.on(Event.FOCUS_CHANGE, this, onFocusChange);
            idCardInput.on(Event.FOCUS_CHANGE, this, onFocusChange);
            telephoneInput.on(Event.FOCUS_CHANGE, this, onFocusChange);
            confirmCode.on(Event.FOCUS_CHANGE, this, onFocusChange);
            confirmBtn.on(Event.CLICK, this, onConfirmBtn);
            cancelBtn.on(Event.CLICK, this, onCancelBtn);
            quitBtn.on(Event.CLICK, this, onCancelBtn);
            cancelBtn4.on(Event.CLICK, this, onCancelBtn);
            copyBtn.on(Event.CLICK, this, onCopyBtn);
            confirmBtn2.on(Event.CLICK, this, onConfirmBtn2);
            getCode.on(Event.CLICK, this, onGetCode);
            confirmBtn3.on(Event.CLICK, this, onConfirmBtn3);
            confirmBtn4.on(Event.CLICK, this, onConfirmBtn4);
            GameTools.clipTxt(clipConfirm, "确定", GameConst.font_red);
            GameTools.clipTxt(confirmClip, "确定", GameConst.font_red);
            GameTools.clipTxt(fontClip1, "确定", GameConst.font_red);
            GameTools.clipTxt(fontClip2, "确定", GameConst.font_red);
            GameTools.clipTxt(clipCancel, "取消", GameConst.font_green);
            GameTools.clipTxt(cancelClip, "取消", GameConst.font_green);
            screenResize();
            bmask.on(Event.CLICK, this, clickMask);
        }

        private function onGetCode()
        {
            var telephone:String = telephoneInput.text;
            if (telephone == "")
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请输入手机号码");
                return;
            } else if (telephone.length != 11)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请输入正确的手机号码");
                return;
            }
            WebSocketManager.instance.send(33014, {phone: telephone, type: 2});
        }

        private function onCopyBtn()
        {
            GameTools.copyText(link.text)
        }

        private function onConfirmBtn2()
        {
            UiManager.instance.closePanel("QuickRegister", false);
        }

        private function onConfirmBtn4()
        {
            UiManager.instance.closePanel("Certification", false);
            hideAll()
            box1.visible = true
        }

        private function onConfirmBtn3()
        {
            onCancelBtn()
        }

        private function initBox(parm:Object = null):void
        {
            if (parm == null)
            {
                hideAll()
                box2.visible = true
                jjhAccount.text = RoleInfoM.instance.jjhNumber;
                jjhId.text = RoleInfoM.instance.jjhId;

            } else if (parm == GameConst.from_bank)
            {
                hideAll()
                box1.visible = true
            } else if (parm == GameConst.from_certifucation)
            {
                hideAll()
                prompt_box.visible = true
            }
        }


        private function clearInput():void
        {
            nameInput.text = "";
            idCardInput.text = "";
            telephoneInput.text = "";
            confirmCode.text = "";
        }


        private function onFocusChange():void
        {
            nameInput.repaint();
            idCardInput.repaint();
            telephoneInput.repaint();
            confirmCode.repaint();
            this.repaint();
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
            var code:String = confirmCode.text;
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
            } else if (code == "")
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请输入验证码");
                return;
            } else if (code.length != 6)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请输入正确的验证码");
                return;
            }

            if (getAge(cardId) && getAge(cardId) < 18)
            {
                GameTools.showTip("您未满18周岁，无法注册")
//                WebSocketManager.instance.send(60001, {name: name, cardId: cardId, ageType: 0, phone: telephone, code: code, is_quick_reg: 1});
            } else
            {
                WebSocketManager.instance.send(60001, {name: name, cardId: cardId, ageType: 1, phone: telephone, code: code, is_quick_reg: 1});

            }
            RoleInfoM.instance.tel = telephoneInput.text
            clearCodeTimer()
        }

        private function onCancelBtn(isCancel:Boolean = true):void
        {
            clearInput();

            UiManager.instance.closePanel("QuickRegister", false);
            var certInfo:CertificationInfo = new CertificationInfo();
            certInfo.openFrom = GameConst.from_quick_register;
            CertificationM.instance.info = certInfo;
            if (ENV.branchSwitch("certification"))
            {
                UiManager.instance.loadView("Certification", null, ShowType.SMALL_TO_BIG);
            }
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

        private function getCodeResult(data:*):void
        {
            if (data.code == 0)
            {
                GameTools.showTip("发送验证码成功")
                codeTimer.visible = true;
                codeTimer.text = codeTime + "s";
                Laya.timer.loop(1000, this, updateCodeTime)
                getCode.disabled = true;

            } else
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "发送验证码失败")
            }
        }

        private function updateCodeTime():void
        {
            codeTime = codeTime - 1;
            if (codeTime <= 0)
            {
                clearCodeTimer()
                return
            }
            codeTimer.text = codeTime + "s";
        }

        private function clearCodeTimer():void
        {
            Laya.timer.clear(this, updateCodeTime)
            codeTimer.visible = false;
            getCode.disabled = false;
            codeTime = 60;
        }

        private function hideAll()
        {
            box1.visible = false
            box2.visible = false
            box3.visible = false
            prompt_box.visible = false
        }

        private function showJJhInfo():void
        {
            GameEventDispatch.instance.event(GameEvent.MsgTipContent, "注册成功")
            hideAll()
            box3.visible = true
            jjhAccount2.text = RoleInfoM.instance.jjhNumber;
            jjhId2.text = RoleInfoM.instance.jjhId;
            jjhPass.text = RoleInfoM.instance.jjhPass;
            bankPsd2.text = RoleInfoM.instance.bankPass;
            confirmDelay.text = confirmDelayTime + "s";
            confirmDelay.visible = true
            confirmBtn3.disabled = true
            Laya.timer.loop(1000,this,updateConfirmTime)
        }

        private function updateConfirmTime():void
        {
            confirmDelayTime = confirmDelayTime - 1;
            if (confirmDelayTime <= 0)
            {
                clearConfirmTimer()
                return
            }
            confirmDelay.text = confirmDelayTime + "s";
        }

        private function clearConfirmTimer():void
        {
            Laya.timer.clear(this, clearConfirmTimer)
            confirmDelay.visible = false;
            confirmBtn3.disabled = false;
            confirmDelayTime = 60;
        }

        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.on(String(33015), this, getCodeResult);
            GameEventDispatch.instance.on(GameEvent.UpdateJJHAcInfo, this, showJJhInfo);
        }


        public function unRegister():void
        {
            this.x = _startX;
            this.y = _startY;
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.off(String(33015), this, getCodeResult);
            GameEventDispatch.instance.off(GameEvent.UpdateJJHAcInfo, this, showJJhInfo);
        }


    }
}
