package view.changeSkin
{

    import control.WxC;

    import laya.ui.Image;

    import model.ActivityM;
    import model.RoleInfoM;

    import conf.cfg_battery_skin;

    import emurs.ShowType;

    import laya.events.Event;
    import laya.ui.Box;
    import laya.ui.Label;
    import laya.utils.Dictionary;
    import laya.utils.Handler;

    import manager.ConfigManager;
    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;

    import ui.abbey.ChangeSkinPageUI;

    public class ChangeSkinPage extends ChangeSkinPageUI implements ResVo
    {

        private static var dic:Dictionary = new Dictionary();
        private var _startX:Number = 0;
        private var _startY:Number = 0;

        public function ChangeSkinPage()
        {

        }


        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;

            _startX = this.x;
            _startY = this.y;

            bmask.on(Event.CLICK, this, null)

            list1.refresh()

            screenResize()

            quitBtn.on(Event.CLICK, this, onQuitBtnClick);

            list1.renderHandler = new Handler(this, updateItem);

            onRefresh()
        }

        private function screenResize():void
        {
            var contentWidth:int = 1000;//组件范围widthGameEventDispatch.instance.off(GameEvent.ScreenResize,this,screenResize);
            var contentHeight:int = 660;//组件范围height
            var contentStartX:int = 140;//组件左边距
            var contentStartY:int = 30;//组件上边距
            var posXOff:Number = (Laya.stage.width - contentWidth) / 2;
            var posYOff:Number = (Laya.stage.height - contentHeight) / 2;
            this.pos(_startX + posXOff - contentStartX, _startY + posYOff - contentStartY);
            this.size(Laya.stage.width, Laya.stage.height);

            quitBtn.left = contentStartX - posXOff;
            quitBtn.top = contentStartY - posYOff;
        }


        private function updateItem(cell:Box, index:int):void
        {
            var config:cfg_battery_skin = cell.dataSource;
            var ele_remain:Label = cell.getChildByName('remain') as Label

            var skins:Array = RoleInfoM.instance.getSkins();
            skins = RoleInfoM.instance.getAllSkins();
            var has_skin:Boolean = skins.indexOf(config.id) >= 0;
            var is_cur:Boolean = RoleInfoM.instance.getCurSkin() == config.id;
            var ele_img = cell.getChildByName("img") as Image
            var ele_item_label = cell.getChildByName("item_label") as Label
            var ele_desc = cell.getChildByName("desc") as Label

            var ele_status = cell.getChildByName("status")

            ele_status.offAll(Event.CLICK);

            //世界杯活动
            if (config.activity == GameConst.activity_worldcup)
            {
                if (ActivityM.instance.activityIsActive(GameConst.activity_worldcup)
                        && RoleInfoM.instance.haveValidMonthCard()
                        && RoleInfoM.instance.worldcup_battery_accepted == 1
                )
                {
                    has_skin = true
                }
            }

            var remain_day:Number = RoleInfoM.instance.getSkinRemainTime(config.id)

            if (remain_day > 0)
            {
                ele_remain.visible = true
                ele_remain.text = "剩余" + remain_day + "天"
            } else
            {
                ele_remain.visible = false

            }

            if (is_cur)
            {
                ele_status.skin = "ui/changeSkin/equipped.png";
                ele_status.stateNum = 1;
            } else if (has_skin)
            {
                ele_status.skin = "ui/changeSkin/equip.png";
                ele_status.stateNum = 3;
                ele_status.on(Event.CLICK, this, changeSkin(config))
            } else
            {
                if (config.activity == GameConst.activity_worldcup)
                {
                    //                    TODO,changeto  获得
                    ele_status.skin = "ui/changeSkin/buy.png";
                    ele_status.stateNum = 3;
                    ele_status.on(Event.CLICK, this, getWorldCupSkin, [config])

                } else
                {
                    ele_status.skin = "ui/changeSkin/buy.png";
                    ele_status.stateNum = 3;
                    ele_status.on(Event.CLICK, this, buySkin, [config])
                }


            }

            if (config.id == 9)
            {
                ele_img.scale(0.7,0.7)
                ele_img.height = 162
            }else if (config.id == 10)
            {
                ele_img.height = 162
            }else
            {
                ele_img.height = 132
                ele_img.scale(1,1)
            }

            ele_img.skin = config.batteryImg;
            ele_item_label.text = config.itemLabel;
            ele_desc.text = config.desc;
        }

        private function buySkin(cfg:cfg_battery_skin)
        {
            if (cfg.tip_id == 0)
            {
                UiManager.instance.closePanel("ChangeSkin", false);

                GameEventDispatch.instance.event(GameEvent.Shop, "tab_skin");
            } else
            {
                GameEventDispatch.instance.event(GameEvent.MsgTip, cfg.tip_id);
            }

        }

        private function getWorldCupSkin(cfg:cfg_battery_skin)
        {
            if (ActivityM.instance.worldCupActivityBatteryCanBuy())
            {
                UiManager.instance.closePanel("ChangeSkin", false);
                GameEventDispatch.instance.event(GameEvent.Shop, GameConst.shop_tab_skin);
            } else
            {
                if (ActivityM.instance.activityIsActive(GameConst.activity_worldcup))
                {
                    UiManager.instance.closePanel("ChangeSkin", false);
                    UiManager.instance.loadView("Russia", {tab: "tab_battery"}, ShowType.SMALL_TO_BIG);
                }
            }

        }

        private function changeSkin(config:cfg_battery_skin)
        {
            return function ()
            {
                GameEventDispatch.instance.event(GameEvent.ChangeSkin, config.id);
            }
        }

        private function onQuitBtnClick()
        {
            UiManager.instance.closePanel("ChangeSkin", true);
        }

        private function onRefresh()
        {
            list1.array = ConfigManager.filter("cfg_battery_skin", function (item:cfg_battery_skin)
            {
                return item.toskin > 0
            })
        }


        public function unRegister():void
        {
            GameEventDispatch.instance.off(GameEvent.ShopRefresh, this, onRefresh);
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.off(GameEvent.EndAcceptWorldCup, this, onRefresh);
            GameEventDispatch.instance.off(GameEvent.FinishChangeSkin, this, onRefresh);
        }


        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.ShopRefresh, this, onRefresh);
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.on(GameEvent.EndAcceptWorldCup, this, onRefresh);
            GameEventDispatch.instance.on(GameEvent.FinishChangeSkin, this, onRefresh);
        }


    }
}
