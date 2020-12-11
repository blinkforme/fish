package view.firstCharge
{


    import control.WxC;

    import model.RoleInfoM;

    import conf.cfg_first_charge;
    import conf.cfg_goods;

    import laya.events.Event;
    import laya.ui.Box;
    import laya.utils.Handler;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;
    import manager.WebSocketManager;

    import ui.abbey.FirstChargePageUI;

    public class FirstChargePage extends FirstChargePageUI implements ResVo
    {

        private var _startX:Number = 0;
        private var _startY:Number = 0;

        public function FirstChargePage()
        {

        }

        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;
            bmask.on(Event.CLICK, this, null)
            _startX = this.x;
            _startY = this.y;

            quitBtn.on(Event.CLICK, this, onQuitBtnClick);
            initReward()
            initBtn()

            screenResize();
        }

        private function screenResize():void
        {
            var contentWidth:int = 800;//组件范围width
            var contentHeight:int = 550;//组件范围height
            var contentStartX:int = 240;//组件左边距
            var contentStartY:int = 100;//组件上边距
            var posXOff:Number = (Laya.stage.width - contentWidth) / 2;
            var posYOff:Number = (Laya.stage.height - contentHeight) / 2;
            this.pos(_startX + posXOff - contentStartX, _startY + posYOff - contentStartY);
            this.size(Laya.stage.width, Laya.stage.height);

            quitBtn.left = contentStartX - posXOff;
            quitBtn.top = contentStartY - posYOff;
        }


        private function updateItemReward(cell:Box, index:int):void
        {
            var ele_reward_img = cell.getChildByName("reward_type");
            var ele_reward_text = cell.getChildByName("reward_text");

            var data = cell.dataSource

            ele_reward_img.skin = cfg_goods.instance(data.reward_item_id + "").icon;
            ele_reward_text.text = 'x ' + data.reward_item_num;
        }

        public function initReward()
        {
            var cfg = cfg_first_charge.instance("1");

            list_reward.renderHandler = new Handler(this, updateItemReward);

            var index:Number = cfg.reward_item_ids.indexOf(23);

            if (index > -1)
            {
                cfg.reward_item_ids.splice(index, 1)
                cfg.reward_item_nums.splice(index, 1)
            }

            var rewards = []
            for (var i = 0; i < cfg.reward_item_ids.length; i++)
            {
                rewards.push({
                    reward_item_id: cfg.reward_item_ids[i],
                    reward_item_num: cfg.reward_item_nums[i]
                })
            }

            list_reward.array = rewards
        }

        public function initBtn()
        {
            chargeBtn.offAll(Event.CLICK);
            if (RoleInfoM.instance.getFirstChargeRewardAccepted())
            {
                chargeBtn.label = "已领取"
                onQuitBtnClick()

            } else
            {
                if (RoleInfoM.instance.getChargeTimes() > 0)
                {
                    txt.skin = "ui/firstCharge/finish_txt.png"
                    chargeBtn.on(Event.CLICK, this, function ()
                    {
                        WebSocketManager.instance.send(14002, null);
                    })
                } else
                {
                    txt.skin = "ui/firstCharge/charge_txt.png"
                    chargeBtn.on(Event.CLICK, this, function ()
                    {
                        UiManager.instance.closePanel("FirstCharge", true);
//                        if (WxC.isInMiniGame())
//                        {
//                            GameEventDispatch.instance.event(GameEvent.Shop, "tab_mini");
//                        }
//                        else
                        {
                            GameEventDispatch.instance.event(GameEvent.Shop, "tab_package");
                        }
                    })
                }
            }
        }


        public function endChargeReward(data:*)
        {
            RoleInfoM.instance.setFirstChargeRewardAccepted(1);
            initBtn()


            GameEventDispatch.instance.event(GameEvent.RewardTip, [data.reward_item_ids, data.reward_item_nums]);
        }


        private function onQuitBtnClick()
        {
            UiManager.instance.closePanel("FirstCharge", true);
        }


        public function unRegister():void
        {
            GameEventDispatch.instance.off(GameEvent.UpdateFirstCharge, this, initBtn);
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
        }


        public function register():void
        {
            //领取首充奖励
            GameEventDispatch.instance.on(GameEvent.UpdateFirstCharge, this, initBtn);
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
        }


    }
}
