package view.bindInfo
{

    import laya.events.Event;

    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.GameTools;
    import manager.ResVo;
    import manager.UiManager;
    import manager.WebSocketManager;

    import model.RoleInfoM;

    import ui.abbey.BindInfoPageUI;

    public class BindInfoView extends BindInfoPageUI implements ResVo
    {
        private var _startX:Number = 0;
        private var _startY:Number = 0;

        private var codeTime:Number = 60;
        private var tel:Number


        public function BindInfoView()
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
            passwordInput.on(Event.FOCUS_CHANGE, this, onFocusChange);

            confirmBtn.on(Event.CLICK, this, onConfirmBtn);
            cancelBtn.on(Event.CLICK, this, onCancelBtn);
            quitBtn.on(Event.CLICK, this, onCancelBtn);
            getCode.on(Event.CLICK, this, onGetCode);

            GameTools.clipTxt(confirmClip, "确定", GameConst.font_red);
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

        private function initBox(parm:Object = null):void
        {
            box1.visible = true
        }


        private function clearInput():void
        {
            nameInput.text = "";
            idCardInput.text = "";
            telephoneInput.text = "";
            confirmCode.text = "";
            passwordInput.text = "";
        }


        private function onFocusChange():void
        {
            nameInput.repaint();
            idCardInput.repaint();
            telephoneInput.repaint();
            confirmCode.repaint();
            passwordInput.repaint();
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
            var passWord:String = passwordInput.text;
            var idCardReg:RegExp = /^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$/;
            var telReg:RegExp = /^1[345678]\d{9}$/;
            if (name == "")
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请输入真实姓名");
                return;
            } else if (!nameReg.test(name))
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "输入姓名不符合规范");
                return;
            } else if (cardId == "")
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
            } else if (!telReg.test(telephone))
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请输入正确的手机号码");
                return;
            } else if (code == "")
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请输入验证码");
                return;
            } else if (code.length != 4)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请输入正确的验证码");
                return;
            } else
            {
                this.tel = Number(telephone);
                WebSocketManager.instance.send(60001, {
                    name: name,
                    cardId: cardId,
                    ageType: 1,
                    pwd: passWord,
                    phone: telephone,
                    code: code,
                    is_quick_reg: 1
                });
                clearCodeTimer()
            }
        }

        private function bindSuccess():void
        {
            RoleInfoM.instance.user_bind_info['type'] = 1
            UiManager.instance.closePanel("BindInfo", false);
        }

        private function onCancelBtn(isCancel:Boolean = true):void
        {
            clearInput();
            UiManager.instance.closePanel("BindInfo", false);
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
                if (data['msg'])
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, data['msg'])
                }else
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "发送验证码失败")
                }

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

        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.on(String(33015), this, getCodeResult);
            GameEventDispatch.instance.on(GameEvent.BindInfoTel, this, bindSuccess)
        }

        public function unRegister():void
        {
            this.x = _startX;
            this.y = _startY;
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.off(String(33015), this, getCodeResult);
            GameEventDispatch.instance.off(GameEvent.BindInfoTel, this, bindSuccess)
        }


    }
}
