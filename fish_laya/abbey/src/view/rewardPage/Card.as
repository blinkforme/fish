package view.rewardPage
{
    import manager.GameConst;

    import model.ActivityM;

    import conf.cfg_goods;

    import laya.display.Animation;
    import laya.events.Event;
    import laya.ui.Box;
    import laya.ui.FontClip;
    import laya.ui.Image;
    import laya.ui.Label;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.UiManager;
    import manager.WebSocketManager;

    import proto.C2s_15001;

    public class Card
    {
        private var backImage:Box;
        private var frontBox:Box;
        private var txt:Label;
        private var coinCount:Label;
        private var rewardImage:Image;
        private var commonImg:Image;
        private var commonClip:FontClip;
        private var backAni:Animation;
        private var frontAni:Animation;
        private var arr:Array = new Array();
        private var isClik:Boolean = false;
        private var c2s:C2s_15001;
        private var backX:Number;
        private var isIn:Boolean = false;

        public function Card(box:Box, image:Box, back:Animation, front:Animation)
        {
            frontBox = box;
            backImage = image;
            backImage.visible = false;
            frontBox.visible = true;
            isClik = false;
            txt = frontBox.getChildByName("txt") as Label;
            coinCount = frontBox.getChildByName("count") as Label;
            rewardImage = frontBox.getChildByName("image") as Image;
            commonImg = frontBox.getChildByName("common") as Image;
            commonClip = commonImg.getChildByName("common_num") as FontClip;
            commonImg.visible = false
            backAni = back;
            frontAni = front;
            c2s = new C2s_15001();
            c2s.type = 101;
            backX = box.x;
            GameEventDispatch.instance.on(GameEvent.ZhenFan, this, zhen);
            GameEventDispatch.instance.on(GameEvent.TypeChange, this, typeChange);
            GameEventDispatch.instance.on(GameEvent.PlayCard, this, playCard);
            GameEventDispatch.instance.on(GameEvent.HeCLick, this, heClick);
            backImage.mouseEnabled = false;
            backImage.on(Event.CLICK, this, clickback);
            GameEventDispatch.instance.on(GameEvent.SetFishCoin, this, setFishCoin);
        }

        private function setFishCoin():void
        {
            isClik = false;
            backImage.mouseEnabled = false;

        }

        public function heClick():void
        {
            backImage.mouseEnabled = true;
            isClik = true;

        }

        private function playCard(id:Number, url:String, count:int, rewardName:String):void
        {
            if (isIn)
            {
                isIn = false;
                frontAni.play(0, false);
                frontAni.on(Event.COMPLETE, this, playComplete);
                rewardImage.skin = url;
                coinCount.text = count + "";
                txt.text = rewardName + "";
                var extraReward:Array = ActivityM.instance.getRewardPageExtra(id);
                if (extraReward && ActivityM.instance.isShowRewRebate)
                {
                    commonImg.visible = true;
                    commonImg.skin = cfg_goods.instance(extraReward[0]).icon;
                    commonClip.value = extraReward[1];
                } else
                {
                    commonImg.visible = false;
                }
            }
        }

        public function typeChange(index:int):void
        {

            c2s.type = index;
        }

        public function clickback():void
        {
            if (isClik)
            {
                //frontAni.play(0,false);
                // frontAni.on(Event.COMPLETE,this,playComplete);
                //GameEventDispatch.instance.on(String(15001),this,reveice);
                GameEventDispatch.instance.event(GameEvent.StopTime);
                GameEventDispatch.instance.event(GameEvent.SetFishCoin);
                WebSocketManager.instance.send(15001, c2s);
                isIn = true;
                isClik = false;
            }

        }

        private function reveice(data:*):void
        {

        }


        private function playComplete():void
        {
            Laya.timer.once(5000, this, endComplete);

        }

        private function endComplete():void
        {
            UiManager.instance.closePanel("RewardPage", false);


        }

        private function zhen():void
        {
            //isClik = true;
            backAni.play(0, false);
            backAni.on(Event.COMPLETE, this, bakcComplete);

        }

        private function bakcComplete():void
        {
            backImage.visible = true;
            Laya.timer.once(500, this, startHe);

        }

        private function startHe():void
        {
            GameEventDispatch.instance.event(GameEvent.He);
            //Laya.timer.once(300,this,he);

        }

        private function he():void
        {
            isClik = true;

        }

        private function complete():void
        {


        }

        private function end():void
        {


        }

        public function setInfo(info:Object):void
        {
            var extraReward:Array = ActivityM.instance.getRewardPageExtra(info.id);
            txt.text = info.txt;
            rewardImage.skin = info.image;
            arr = info.count
            if (arr[0] == GameConst.currency_exchange)
            {
                coinCount.text = ActivityM.instance.exchangeConversion(GameConst.currency_exchange, arr[1]) + "";
            } else
            {
                coinCount.text = arr[1];
            }
            if (extraReward && ActivityM.instance.isShowRewRebate)
            {
                commonImg.visible = true;
                commonImg.skin = cfg_goods.instance(extraReward[0]).icon;
                commonClip.value = extraReward[1];
            } else
            {
                commonImg.visible = false;
            }

            //isClik = false;
        }

        private function initEvent():void
        {
            backImage.on(Event.CLICK, this, clickImage);
        }

        public function clearCLik():void
        {
            frontAni.off(Event.COMPLETE, this, playComplete);
            backAni.off(Event.COMPLETE, this, bakcComplete);
            Laya.timer.clear(this, startHe);
            Laya.timer.clear(this, endComplete);
            backImage.off(Event.CLICK, this, clickback);
            GameEventDispatch.instance.off(GameEvent.ZhenFan, this, zhen);
            GameEventDispatch.instance.off(GameEvent.TypeChange, this, typeChange);
            GameEventDispatch.instance.off(GameEvent.PlayCard, this, playCard);
        }


        private function clickImage():void
        {


        }

    }
}
