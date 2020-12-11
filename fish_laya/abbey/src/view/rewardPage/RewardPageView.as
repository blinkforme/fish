package view.rewardPage
{
    import manager.GameConst;

    import model.ActivityM;

    import model.RewardM;
    import model.RoleInfoM;

    import conf.cfg_goods;

    import laya.display.Animation;
    import laya.events.Event;
    import laya.filters.ColorFilter;
    import laya.utils.Handler;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.GameTools;
    import manager.ResVo;
    import manager.UiManager;
    import manager.WebSocketManager;

    import ui.abbey.rewpageUI;

    public class RewardPageView extends rewpageUI implements ResVo
    {
        private var ani:Animation;
        private var cardArr:Array;
        private var boxArr:Array;
        private var beiArr:Array;
        private var backArr:Array;
        private var frontArr:Array;
        private var isChou:Boolean = false;
        private var baseFishCount:Number;
        private var baseCoinCount:Number;
        private var nameArr:Array = ["ui/rewardPage/tab1.png", "ui/rewardPage/tab2.png", "ui/rewardPage/tab3.png", "ui/rewardPage/tab4.png", "ui/rewardPage/tab5.png", "ui/rewardPage/tab6.png"];
        private var typeArr:Array = [101, 201, 301, 401, 501, 601];
        private var tabId:Number;
        private var startId:Number;
        private var isC:Boolean = false;
        private var _totalTime:int = 10;
        private var _startX:Number = 0;
        private var _startY:Number = 0;
        private var isChouComplete:Boolean = false;
        private var _fishCount:Number;
        private var _coinCount:Number;
        private var _recordArr:Array = new Array();
        private var _firstContent:String;
        private var _userName:String;

        public function RewardPageView()
        {
            super();
        }

        public function StartGames(parm:Object = null):void
        {
            //trace("已经调尽力啊了");
            //rewardlist.array = RewardM.instance.rewardArr(0);
            this.hitTestPrior = false;
            _startX = this.x;
            _startY = this.y;
            recordOne.style.width = 600;
            recordTwo.style.width = 600;
            recordThree.style.width = 600;
            recordFour.style.width = 600;
            _userName = GameTools.formatNickName(RoleInfoM.instance.getName())
            initData();
            _totalTime = 10;
            time.text = _totalTime + "";
            baseFishCount = RewardM.instance.baseFishCount();
            baseCoinCount = RewardM.instance.conditonValue(0);
            tablist.mouseEnabled = true;
            tablist.mouseEnabled = true;
            rewrarBtn.mouseEnabled = true;
            closeBtn.mouseEnabled = true;
            reardfishCount.value = RoleInfoM.instance.getFcoin() + "";
            nowcount.value = RoleInfoM.instance.getFcount() + "";
            _fishCount = RoleInfoM.instance.getFcoin();
            _coinCount = RoleInfoM.instance.getFcount();
            time.visible = false;
            //if(RoleInfoM.instance.getFcount()>5){
            reardfishCount.value = RoleInfoM.instance.getFcoin() + "";
            nowcount.value = RoleInfoM.instance.getFcount() + "";
            if (RoleInfoM.instance.getFcount() >= baseFishCount)
            {
                tablist.selectedIndex = RewardM.instance.selectTab(RoleInfoM.instance.getFcoin());
            } else
            {
                tablist.selectedIndex = 0;
            }


            startId = RewardM.instance.selectTab(RoleInfoM.instance.getFcoin());
            tabId = RewardM.instance.selectTab(RoleInfoM.instance.getFcoin());
            if (RoleInfoM.instance.getFcount() >= baseFishCount && RoleInfoM.instance.getFcoin() >= baseCoinCount)
            {
                isC = false;
                lotteryState();
                //stateTwo();
            } else
            {
                //stateOne();
                checkState();
                isC = true;
                // pro.value = RoleInfoM.instance.getFcount()/baseFishCount;
            }
            recevily();
            getData(RewardM.instance.rewardArr(tablist.selectedIndex));
            tablist.selectHandler = new Handler(this, onSelect);
            closeBtn.on(Event.CLICK, this, clickClose);
            rewrarBtn.on(Event.CLICK, this, clickReward);
            //			GameEventDispatch.instance.event(GameEvent.TypeChange,[typeArr[startId]]);
            //			GameEventDispatch.instance.on(String(15002),this,reveice);
            //			GameEventDispatch.instance.on(GameEvent.He,this,He);
            //			GameEventDispatch.instance.on(GameEvent.StopTime,this,stopTime);
            screenResize();
            repage.on(Event.CLICK, this, click);
            lotteryrecord();
            Laya.timer.loop(1000, this, refresh);

        }

        private function refresh():void
        {
            WebSocketManager.instance.send(15003, null);
        }

        private function lotteryrecord():void
        {
            _recordArr = RewardM.instance.RecordArr;
            recordOne.style.fontSize = 22;
            recordTwo.style.fontSize = 22;
            recordThree.style.fontSize = 22;
            recordFour.style.fontSize = 22;
            if (_recordArr.length > 0)
            {
                recordOne.innerHTML = _recordArr[0];
            }
            if (_recordArr.length > 1)
            {
                recordTwo.innerHTML = _recordArr[1];
            }
            if (_recordArr.length > 2)
            {
                recordThree.innerHTML = _recordArr[2];
            }
            if (_recordArr.length > 3)
            {
                recordFour.innerHTML = _recordArr[3];

            }
        }


        private function refeFish():void
        {
            var currentFishCount:Number = RoleInfoM.instance.getFcoin();
            var currentCoinCount:Number = RoleInfoM.instance.getFcount();
            if (_fishCount != currentFishCount || _coinCount != currentCoinCount)
            {
                _fishCount = currentFishCount;
                _coinCount = currentCoinCount;
                baseFishCount = RewardM.instance.baseFishCount();
                baseCoinCount = RewardM.instance.conditonValue(0);
                reardfishCount.value = RoleInfoM.instance.getFcoin() + "";
                nowcount.value = RoleInfoM.instance.getFcount() + "";
                startId = RewardM.instance.selectTab(RoleInfoM.instance.getFcoin());
                tabId = RewardM.instance.selectTab(RoleInfoM.instance.getFcoin());
                if (RoleInfoM.instance.getFcount() >= baseFishCount)
                {
                    tablist.selectedIndex = RewardM.instance.selectTab(RoleInfoM.instance.getFcoin());
                    getData(RewardM.instance.rewardArr(tablist.selectedIndex));
                    GameEventDispatch.instance.event(GameEvent.TypeChange, [typeArr[startId]]);
                } else
                {
                    //tablist.selectedIndex= 0;
                }
                if (RoleInfoM.instance.getFcount() >= baseFishCount && RoleInfoM.instance.getFcoin() >= baseCoinCount)
                {
                    isC = false;
                    lotteryState();
                } else
                {
                    checkState();
                    isC = true;
                }
            }
            //recevily();


        }

        private function click():void
        {
            //tablist.selectedIndex = 3;
        }


        private function screenResize():void
        {
            var contentWidth:int = 1040;//组件范围width
            var contentHeight:int = 636;//组件范围height
            var contentStartX:int = 120;//组件左边距
            var contentStartY:int = 54;//组件上边距
            var posXOff:Number = (Laya.stage.width - contentWidth) / 2;
            var posYOff:Number = (Laya.stage.height - contentHeight) / 2;
            this.pos(_startX + posXOff - contentStartX, _startY + posYOff - contentStartY);
            this.size(Laya.stage.width, Laya.stage.height);

            closeBtn.left = contentStartX - posXOff;
            closeBtn.top = contentStartY - posYOff;
        }

        private function stopTime():void
        {
            Laya.timer.clear(this, start);
            time.visible = false;

        }

        private function He():void
        {
            hee.play(0, false);
            hee.on(Event.COMPLETE, this, heComplete);
        }

        private function heComplete():void
        {
            time.visible = true;
            Laya.timer.loop(1000, this, start);
            GameEventDispatch.instance.event(GameEvent.HeCLick);

        }

        private function start():void
        {
            _totalTime = _totalTime - 1;
            updateTime(_totalTime);

        }

        private function updateTime(count:int):void
        {
            if (count == 0)
            {
                Laya.timer.clear(this, start);
                time.visible = false;
                cardArr[getIndex(5)].clickback();
            }
            time.text = count + ""
        }


        private function reveice(data:*):void
        {

            isChouComplete = true;
            checkState();
            reardfishCount.value = RoleInfoM.instance.getFcoin() + "";
            if (data.code == 0)
            {
                var imageUrl:String = RewardM.instance.imageUrl(data.id);
                var count:Number = RewardM.instance.rewardCount(data.id);
                var goodsId:Number = RewardM.instance.goodsId(data.id);
                var rewardName:String = RewardM.instance.rewardName(data.id);
                //_firstContent = RewardM.instance.getlotteryRecord(data.id,_userName);
                // recordOne.text = _firstContent;
                if (data.rep == 1)
                {
                    var cfg:cfg_goods = cfg_goods.instance(data.rep_id + "");
                    imageUrl = cfg.icon;
                    count = data.rep_count;
                    goodsId = data.rep_id;
                    rewardName = count + "金币";
                }
                closeBtn.mouseEnabled = true;
                var extraReward:Array = ActivityM.instance.getRewardPageExtra(data.id);
                if (goodsId == GameConst.currency_exchange)
                {
                    var countFormat = ActivityM.instance.exchangeConversion(GameConst.currency_exchange, count);
                    GameEventDispatch.instance.event(GameEvent.PlayCard, [data.id, imageUrl, countFormat, rewardName]);
                } else
                {
                    GameEventDispatch.instance.event(GameEvent.PlayCard, [data.id, imageUrl, count, rewardName]);
                }
                if (extraReward && ActivityM.instance.isShowRewRebate)
                {
                    GameEventDispatch.instance.event(GameEvent.RewardTip, [[goodsId, extraReward[0]], [count, extraReward[1]]]);
                } else
                {
                    GameEventDispatch.instance.event(GameEvent.RewardTip, [[goodsId], [count]]);
                }

                GameEventDispatch.instance.event(GameEvent.FinishReward);
            } else
            {
                closeBtn.mouseEnabled = true;
                GameEventDispatch.instance.event("MsgTp", 22);
                //UiManager.instance.closePanel("RewardPage",false);
            }
        }


        //		private function stateOne():void
        //		{
        //			btnTxt.text = "查看奖金鱼"
        //			notip.text = "捕鱼奖金不足哦"
        //			notip.x = 652;
        //			notip.y = 501;
        //			allCount.value = baseFishCount+""
        //			nowcount.visible = true;
        //			allCount.visible = true;
        //			isChou = false;
        //			chouTxt.visible = false;
        //			jibiTxt.visible = false;
        //
        //		}

        //		private function stateOne():void
        //		{
        //			btnTxt.text = "查看奖金鱼"
        //			notip.text = "捕鱼奖金不足哦"
        //			notip.x = 652;
        //			notip.y = 501;
        //
        //			allCount.value = String(baseFishCount);
        //
        //			nowcount.visible = true;
        //			allCount.visible = true;
        //			isChou = false;
        //			chouTxt.visible = false;
        //			jibiTxt.visible = false;
        //
        //		}


        //		private function stateTwo():void
        //		{
        //			isChou = true;
        //			//btnTxt.text = "点击抽奖"
        //			notip.text = "击杀奖金鱼可持续积累奖金池"
        //			notip.x = 523;
        //			notip.y = 501;
        //			if(tabId>=6){
        //				allCount.value = RewardM.instance.conditonValue(startId)+""
        //				//chouTxt.text = nameArr[startId];
        //				pro.value = 1;
        //			}else{
        //				//chouTxt.text = nameArr[tabId];
        //			    allCount.value = RewardM.instance.conditonValue(tabId)+""
        //			    pro.value = RoleInfoM.instance.getFcount()/RewardM.instance.conditonValue(tabId);
        //			}
        //			nowcount.value = RoleInfoM.instance.getFcoin()+"";
        //			chouTxt.visible = true;
        //			//jibiTxt.visible = true;
        //		}


        //抽奖状态
        private function lotteryState():void
        {
            isChou = true;
            notip.skin = "ui/rewardPage/cjts.png"
            rewrarBtn.skin = "ui/rewardPage/kaishi.png"
            nowcount.value = RoleInfoM.instance.getFcoin() + "";
            if (tabId >= 6)
            {
                allCount.value = RewardM.instance.conditionShowValue(startId) + "";
                chouTxt.skin = nameArr[startId];
                pro.value = 1;
            } else
            {
                chouTxt.skin = nameArr[tabId];
                allCount.value = RewardM.instance.conditionShowValue(tabId) + "";
                pro.value = RoleInfoM.instance.getFcoin() / RewardM.instance.conditonValue(tabId);
            }
        }

        //检查状态
        private function checkState():void
        {
            isChou = false;
            recevily();
            allCount.value = baseFishCount + "";
            nowcount.value = RoleInfoM.instance.getFcount() + "";
            notip.skin = "ui/rewardPage/yubuzu.png";
            rewrarBtn.skin = "ui/rewardPage/button_jiang.png";
            chouTxt.skin = "ui/rewardPage/jjy.png";
            pro.value = RoleInfoM.instance.getFcount() / baseFishCount;
        }


        private function clickReward():void
        {
            if (isChou)
            {
                tablist.mouseEnabled = false;
                rewrarBtn.mouseEnabled = false;
                closeBtn.mouseEnabled = false;
                GameEventDispatch.instance.event(GameEvent.ZhenFan);

            } else
            {
                GameEventDispatch.instance.event(GameEvent.FishTypeC);
            }
        }

        private function initData():void
        {
            boxArr = [box_0, box_1, box_2, box_3, box_4, box_5];
            beiArr = [bei_0, bei_1, bei_2, bei_3, bei_4, bei_5];
            backArr = [fan_0, fan_1, fan_2, fan_3, fan_4, fan_5];
            frontArr = [zhen_0, zhen_1, zhen_2, zhen_3, zhen_4, zhen_5];
            cardArr = new Array();
            for (var i:int = 0; i < 6; i++)
            {
                var card:Card = new Card(boxArr[i], beiArr[i], backArr[i], frontArr[i]);
                cardArr.push(card);
            }
        }

        private function rewardSelect(index:int):void
        {


        }

        private function clickClose():void
        {
            UiManager.instance.closePanel("RewardPage", true);
        }

        private function onSelect(index:int):void
        {


            if (index != startId && isChou && isC == false)
            {

                colrFilter();
            } else
            {
                recevily();
            }
            if (isC == false)
            {
                chouTxt.skin = nameArr[index]
                allCount.value = RewardM.instance.conditionShowValue(index) + "";
                pro.value = RoleInfoM.instance.getFcoin() / RewardM.instance.conditonValue(index);
            }
            GameEventDispatch.instance.event(GameEvent.TypeChange, [typeArr[index]]);
            getData(RewardM.instance.rewardArr(index));
            var arr:Array = RewardM.instance.rewardArr(index);

        }

        //		
        private function getData(arr:Array):void
        {
            for (var i:int = 0; i < cardArr.length; i++)
            {
                Card(cardArr[i]).setInfo(arr[i]);
            }
        }

        private function colrFilter():void
        {
            var grayscaleMat:Array = [
                0.4, 0.4, 0.4, 0, 0,
                0.4, 0.4, 0.4, 0, 0,
                0.4, 0.4, 0.4, 0, 0,
                0, 0, 0, 1, 0];
            var grayscaleFilter:ColorFilter = new ColorFilter(grayscaleMat);
            rewrarBtn.filters = [grayscaleFilter];
            //btnTxt.color = "#8ba48e"
            rewrarBtn.mouseEnabled = false;

        }

        private function recevily():void
        {
            rewrarBtn.filters = [];
            //btnTxt.color = "#16e32f"
            rewrarBtn.mouseEnabled = true;
        }


        public function register():void
        {
            GameEventDispatch.instance.event(GameEvent.TypeChange, [typeArr[startId]]);
            GameEventDispatch.instance.on(String(15002), this, reveice);
            GameEventDispatch.instance.on(GameEvent.He, this, He);
            GameEventDispatch.instance.on(GameEvent.StopTime, this, stopTime);
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.on(GameEvent.UpdateFish, this, updateFish);
            GameEventDispatch.instance.on(GameEvent.RefreshLotteryRecord, this, regfresh);

        }

        private function regfresh():void
        {
            lotteryrecord();

        }

        private function updateFish():void
        {

            refeFish();

        }

        public function unRegister():void
        {
            //trace("退出了抽奖");
            Laya.timer.clear(this, refresh);
            GameEventDispatch.instance.off(String(15002), this, reveice);
            GameEventDispatch.instance.off(GameEvent.He, this, He);
            GameEventDispatch.instance.off(GameEvent.StopTime, this, stopTime);
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.off(GameEvent.UpdateFish, this, updateFish);
            GameEventDispatch.instance.off(GameEvent.RefreshLotteryRecord, this, regfresh);
            Laya.timer.clear(this, start);
            if (cardArr != null)
            {
                for (var i:int = 0; i < cardArr.length; i++)
                {
                    Card(cardArr[i]).clearCLik();
                }
            }
            cardArr = null;
        }

        public function getIndex(index:int):Number
        {
            return Math.round(Math.random() * (index));
        }

    }


}
