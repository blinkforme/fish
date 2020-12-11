package view.bank
{
    import engine.tool.StartParam;

    import manager.GameConst;

    import model.LoginInfoM;
    import model.RoleInfoM;

    import laya.events.Event;
    import laya.ui.Label;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;
    import manager.WebSocketManager;

    import ui.abbey.BankPageUI;

    public class BankPage extends BankPageUI implements ResVo
    {
        private var _startX:Number = 0;
        private var _startY:Number = 0;


        private var cursor:Label;


        public function BankPage()
        {
            super();
        }

        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;

            _startX = this.x;
            _startY = this.y;
            quitBtn.on(Event.CLICK, this, onClose);
            depositBtn.on(Event.CLICK, this, onDeposit)
            takeBtn.on(Event.CLICK, this, onTake)
            takeTxt.on(Event.CHANGE, this, onTakeChange)
            infoBtn.on(Event.CLICK, this, onInfoBtn)
            if (ENV.openQuickRegister && RoleInfoM.instance.isQuickRegister == 1)
            {
                infoBtn.visible = true
            } else
            {
                infoBtn.visible = false
            }
            //            绑定页面事件
            clearInput();
            screenResize();
            initCoin();
            initBox();
            clearAllTimer();
        }

        private function onInfoBtn()
        {
            UiManager.instance.loadView("QuickRegister")
        }

        private function clearAllTimer():void
        {
            Laya.timer.clear(this, synCoin);
        }

        private function addTimer():void
        {
            Laya.timer.loop(10000, this, synCoin);
        }

        private function synCoin():void
        {
            WebSocketManager.instance.send(33012, {});
        }

        private function loopCursor():void
        {
            if (cursor)
            {
                cursor.visible = !cursor.visible
            }
        }

        private function initBox():void
        {
            if (RoleInfoM.instance.is_bind_tel == 1)
            {
                bank_box.visible = true
                setBindTel();
                addTimer();
                syncBankCoin();
            }
        }

        private function onTakeChange(e:Event):void
        {
            if (parseInt(takeTxt.text) > RoleInfoM.instance.bank_gold)
            {
                takeTxt.text = RoleInfoM.instance.bank_gold + ""
            }
        }

        private function onDeposit():void
        {

            if (!depositTxt.text)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请输入金额");
            } else if (parseInt(depositTxt.text) < 0)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请输入正确的金额");
            } else if (parseInt(depositTxt.text) < 50000)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "每次最少存入5万金币");
            } else if (parseInt(depositTxt.text) > 50000000)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "每次最多存入5000万金币");
            } else if (parseInt(depositTxt.text) > RoleInfoM.instance.getCoin())
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "存入金币数量已超出携带金币数量");
            } else
            {
                var gold:Number = parseInt(depositTxt.text);
                WebSocketManager.instance.send(33002, {gold: gold})
            }
        }

        private function onTake():void
        {
            if (!takeTxt.text)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请输入金额");
            } else if (!bankpassword.text)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请输入密码");
            } else if (parseInt(takeTxt.text) < 0)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请输入正确的金额");
            } else if (parseInt(takeTxt.text) < 5000)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "每次最少取出5万金币");
            } else if (parseInt(takeTxt.text) > 50000000)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "每次最多取出5000万金币");
            } else if (parseInt(takeTxt.text) > RoleInfoM.instance.bank_gold)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "取出金币数量已超出银行金币数量");
            } else
            {
                var gold:Number = parseInt(takeTxt.text);
                var password:String = bankpassword.text;
                WebSocketManager.instance.send(33004, {gold: gold, password: password})
            }
        }

        private function initCoin():void
        {
            carryCoin.text = RoleInfoM.instance.getCoin() + ""
            bankCoin.text = RoleInfoM.instance.bank_gold + ""
        }

        private function onClose():void
        {
            Laya.timer.clearAll(this)
            UiManager.instance.closePanel("Bank", false);
        }

        private function bankUpdate():void
        {
            initBox();
            initCoin()
        }

        private function clearInput():void
        {
            depositTxt.text = "";
            takeTxt.text = "";
            bankpassword.text = "";
        }

        private function endBankDeposit():void
        {
            clearInput()
        }

        private function check(num:Number):Number
        {
            if (num > 20)
            {
                return 1
            } else if (num == 20)
            {
                return 0
            } else
            {
                return -1
            }
        }

        private function endBankTake():void
        {
            clearInput()
        }

        private function endBankTakeFail():void
        {
            bankpassword.text = ""
        }

        private function syncBankCoin():void
        {
            if (RoleInfoM.instance._SyncSwish == 1)
            {
                WebSocketManager.instance.send(33012, {});
                RoleInfoM.instance._SyncSwish = 0;
                Laya.timer.once(10000, this, function ()
                {
                    RoleInfoM.instance._SyncSwish = 1;
                });
            }
        }

        private function endSyncBankCoin():void
        {
            initCoin();
            setBindTel();
        }

        private function setBindTel():void
        {
            telLabel.text = '绑定账号：' + RoleInfoM.instance.jjhNumber;
            jjhIdLable.text = 'ID：' + StartParam.instance.getParam("jjhid");
        }

        private function screenResize():void
        {
            mask1.width = Laya.stage.width
            mask1.height = Laya.stage.height
            this.size(Laya.stage.width, Laya.stage.height);
        }

        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.on(GameEvent.BankUpdate, this, bankUpdate);
            GameEventDispatch.instance.on(GameEvent.EndBankDeposit, this, endBankDeposit);
            GameEventDispatch.instance.on(GameEvent.EndBankTake, this, endBankTake);
            GameEventDispatch.instance.on(GameEvent.EndBankTakeFail, this, endBankTakeFail);
            GameEventDispatch.instance.on(GameEvent.SyncBankCoin, this, endSyncBankCoin);


        }


        public function unRegister():void
        {
            Laya.timer.clear(this, loopCursor)

            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.off(GameEvent.BankUpdate, this, bankUpdate)
            GameEventDispatch.instance.off(GameEvent.EndBankDeposit, this, endBankDeposit);
            GameEventDispatch.instance.off(GameEvent.EndBankTake, this, endBankTake);
            GameEventDispatch.instance.off(GameEvent.EndBankTakeFail, this, endBankTakeFail);
            GameEventDispatch.instance.off(GameEvent.SyncBankCoin, this, endSyncBankCoin);
        }
    }
}
