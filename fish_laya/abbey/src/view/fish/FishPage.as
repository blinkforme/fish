package view.fish
{
    import conf.cfg_task_red_reward;

    import control.RedpointC;
    import control.ShopC;
    import control.TaskC;
    import control.WxC;

    import engine.tool.StartParam;

    import manager.ApiManager;
    import manager.GameTools;
    import manager.GameTools;
    import manager.GameTools;

    import model.ActivityM;
    import model.AdM;
    import model.FightM;
    import model.FightM;
    import model.GunM;
    import model.LevelM;
    import model.LoginInfoM;
    import model.LoginM;
    import model.MatchM;
    import model.MatchM;
    import model.OnLineM;
    import model.RegiM;
    import model.RewardM;
    import model.RoleInfoM;
    import model.RuleM;
    import model.SkillM;

    import conf.cfg_goods;
    import conf.cfg_scene;
    import conf.cfg_task;

    import emurs.ShowType;

    import fight.BulletInfo;
    import fight.FightManager;

    import laya.display.Animation;
    import laya.display.Sprite;
    import laya.events.Event;
    import laya.maths.Point;
    import laya.ui.Box;
    import laya.ui.FontClip;
    import laya.ui.Image;
    import laya.ui.Label;
    import laya.ui.ProgressBar;
    import laya.utils.Browser;
    import laya.utils.Ease;
    import laya.utils.Handler;
    import laya.utils.Tween;

    import manager.AnimalManger;
    import manager.ConfigManager;
    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.GameSoundManager;
    import manager.GameTools;
    import manager.ResVo;
    import manager.ScreenAdaptManager;
    import manager.SpineTemplet;
    import manager.UiManager;
    import manager.WebSocketManager;

    import proto.C2s_13003;
    import proto.C2s_19000;
    import proto.C2s_19002;
    import proto.C2s_shootBullet;
    import proto.ProtoSeatInfo;
    import proto.S2c_22000;
    import proto.S2c_22001;

    import struct.QuitTipInfo;

    import ui.fight.fishPageUI;

    import model.FriendM;

    public class FishPage extends fishPageUI implements ResVo
    {
        private var uniId:int = 1;
        private var paoImage:Animation;
        private var isClick:Boolean = true;
        private var isShow:Boolean = false;
        private var isClickBtn:Boolean = true;
        private var isClickPanel:Boolean = false;
        private var rewardFishCount:int = 0;
        private var rewardCoinCount:int = 0;
        private var isClickGun:Boolean = true;
        private var isClickP:Boolean = false;
        private var isGunShow:Boolean = false;
        private var giveCoin:Number;
        private var powerOneTxt:Label;
        private var powerTwoTxt:Label;
        private var pro:ProgressBar;
        private var needDiaClip:FontClip;
        private var haveDiaClip:FontClip;
        private var giveClip:FontClip;
        //private var image:Image;
        private var seatCSkinList:Array;

        private var desX:Number; //子弹目标x
        private var desY:Number; //子弹目标y
        private var jichiNumOne:FontClip;
        private var jichiNumTwo:FontClip;
        private var jichP:ProgressBar;
        private var jiNowCount:FontClip;
        private var baseFishCount:FontClip;
        private var enterSetPao:Boolean = false;
        private var skillImageOne:Image;
        private var skillImageTwo:Image;
        private var skillImageThree:Image;
        private var skillImageFour:Image;
        private var skillImageFive:Image;
        private var skillImageSix:Image;
        private var skillClipOne:FontClip;
        private var skillClipTwo:FontClip;
        private var skillClipThree:FontClip;
        private var skillClipFour:FontClip;
        private var skillClipFive:FontClip;
        private var skillClipSix:FontClip;
        private var aniOne:Animation;
        private var aniTwo:Animation;
        private var aniThree:Animation;
        private var aniFour:Animation;
        private var aniFive:Animation;
        private var IsOneClick:Boolean = true;
        private var IsTwoClick:Boolean = true;
        private var IsThreeClick:Boolean = true;
        private var IsFourClick:Boolean = true;
        private var IsFiveClick:Boolean = true;
        private var violentOne:Animation;
        private var violentTwo:Animation;
        private var violentThree:Animation;
        private var violentFour:Animation;
        private var violentOneBg:Animation;
        private var violentTwoBg:Animation;
        private var violentThreeBg:Animation;
        private var violentFourBg:Animation;
        private var paoOneMount:Sprite;
        private var paoTwoMount:Sprite;
        private var paoThreeMount:Sprite;
        private var paoFourMount:Sprite;
        private var diamondOne:Image;
        private var diamondTwo:Image;
        private var diamondThree:Image;
        private var diamondFour:Image;
        private var diamondFive:Image;
        private var diamondSix:Image;
        private var _bulletMaxTip:Boolean = false;

        private var unlockBatteryTip:Boolean = false;
        private var unlockBatteryTipTime:Number = 0;

        private var rewardFishTip:Boolean = false;
        private var rewardFishTipTime:Number = 0;
        private var guide:Animation;
        private var clip:FontClip;

        private var isUpdate:Boolean = false;
        private var unLockOut:Boolean = false; //解锁动画在外面
        private var unLockInside:Boolean = true; //解锁动画在里面
        private var lotteryOut:Boolean = false; //抽奖动画在外面；
        private var lotteryInside:Boolean = true; //抽奖动画
        private var isAtuoFire:Boolean = true;  //是否自动发炮
        private var FireState:int = GameConst.noAutoFire;//不自动法袍
        private var isAuto:Boolean = true;
        private var startId:Number = 0;
        private var endId:Number = 0;

        private var selectBoomIndex:int = 0;

        private var isLevel:Boolean = false;
        private var _leftTime:Number;
        private var _onlineCount:Number;
        private var _coinUnchangeTime:Number = 0;
        private var _rewardNameArr:Array = ["点击进行普通抽奖", "点击进行青铜抽奖", "点击进行白银抽奖", "点击进行黄金抽奖", "点击进行钻石抽奖", "点击进行至尊抽奖"];

        private var _rewardLevelName:Label;


        //    提示转圈动画
        private var _task_spine:SpineTemplet;
        private var _battery_spine:SpineTemplet;
        private var _lottery_spine:SpineTemplet;
        private var month_icon_bg:SpineTemplet;
        private var lottery_icon_bg:SpineTemplet;
        private var battery_icon_bg:SpineTemplet;
        private var showOffTime:Number = 0;
        private var isPlayingRankAni:Boolean = false;

        public function FishPage()
        {
            super();
            cancelImg.on(Event.CLICK, this, function (event:Event)
            {
                useSkill(selectBoomIndex)
                event.stopPropagation();
            })
        }

        public function StartGames(parm:Object = null):void
        {

            //刷新喇叭数据
            WebSocketManager.instance.send(19009, null)
            if (FightM.instance.seatId <= 0)
            {
                paoone.visible = true;
                taione.visible = true;
                goldOne.visible = true;
                coinOne.visible = true;
                kuangone.visible = true;
                return;
            }
            FireState = GameConst.noAutoFire;
            enterSetPao = true;
            _coinUnchangeTime = 0;
            seatCSkinList = [0, 0, 0, 0];
            LoginM.instance.roomId = -1;
            this.on(Event.MOUSE_DOWN, this, mouseDown);
            this.on(Event.MOUSE_MOVE, this, mouseMove);
            this.on(Event.MOUSE_OUT, this, mouseOut);
            this.on(Event.MOUSE_UP, this, mouseUp);
            this.on(Event.CLICK, this, clickPanel);
            yuleiList.renderHandler = new Handler(this, yuleiRenderHander);
            paoImage = paoone;
            initViolent();
            initPowerUi();
            initEvent();
            initUi();
            fightPlayerUpdate();
            backPanel.visible = false
//            BackBox.instance.init(backPanel)
            MatchInfoBox.instance.init(matchRoomPanel)
            MatchResultBox.instance.init(matchResultPanel)

            //播放领取每日任务动画
            playTaskShine()
            playBatteryShine()
            playLotteryShine()
            playMonthCardShine()

            updateFishCount();

            GameEventDispatch.instance.event(GameEvent.EnterFightPage);

            updatePower();

            gunImg.on(Event.CLICK, this, clickGunImg);
            gunBoxOne.on(Event.CLICK, this, clickBoxOne);
            gunBoxTwo.on(Event.CLICK, this, clickBoxTwo);
            //gunBox.on(Event.CLICK,this,clickGun);

            poweradd.on(Event.CLICK, this, clickPowerAdd);
            powersub.on(Event.CLICK, this, clickPowerSub);
            changeSkinBtn.on(Event.CLICK, this, onChangeSkinBtn);
            checkBtn.on(Event.CLICK, this, onCheckBtn);
            settingBtn.on(Event.CLICK, this, onSettingBtn);
            returnBtn.on(Event.CLICK, this, onReturnBtn);
            skill_1.on(Event.CLICK, this, clickSkill1);
            skill_2.on(Event.CLICK, this, clickSkill2);
            skill_3.on(Event.CLICK, this, clickSkill3);
            skill_4.on(Event.CLICK, this, clickSkill4);
            skill_5.on(Event.CLICK, this, clickSkill5);
            skill_6.on(Event.CLICK, this, clickSkill6);


            skill_1.on(Event.MOUSE_DOWN, this, downSkip);
            skill_2.on(Event.MOUSE_DOWN, this, downSkip);
            skill_3.on(Event.MOUSE_DOWN, this, downSkip);
            skill_4.on(Event.MOUSE_DOWN, this, downSkip);
            skill_5.on(Event.MOUSE_DOWN, this, downSkip);
            skill_6.on(Event.MOUSE_DOWN, this, downSkip);
            alreadyOne.on(Event.MOUSE_DOWN, this, downSkip);
            alreadyTwo.on(Event.MOUSE_DOWN, this, downSkip);
            alreadyThree.on(Event.MOUSE_DOWN, this, downSkip);
            alreadyFour.on(Event.MOUSE_DOWN, this, downSkip);

            cancle.visible = false;
            initSkillUi();
            updateSKill();
            initSkillAni();

            initGuide();
            gunImg.on(Event.MOUSE_DOWN, this, downSkip);
            gunBoxOne.on(Event.MOUSE_DOWN, this, downSkip);
            gunBoxTwo.on(Event.MOUSE_DOWN, this, downSkip);
            box_task.on(Event.MOUSE_DOWN, this, downSkip);
            changeSkinBtn.on(Event.MOUSE_DOWN, this, downSkip);
            checkBtn.on(Event.MOUSE_DOWN, this, downSkip);
            settingBtn.on(Event.MOUSE_DOWN, this, downSkip);
            returnBtn.on(Event.MOUSE_DOWN, this, downSkip);
            poweradd.on(Event.MOUSE_DOWN, this, downSkip);
            powersub.on(Event.MOUSE_DOWN, this, downSkip);
            month.on(Event.MOUSE_DOWN, this, downSkip);
            countBox.on(Event.MOUSE_DOWN, this, downSkip);
            receiveImg.on(Event.MOUSE_DOWN, this, downSkip);
            //month_icon.on(Event.MOUSE_DOWN, this, downSkip);
            //month_icon_bg.on(Event.MOUSE_DOWN, this, downSkip);
            nchou.on(Event.MOUSE_DOWN, this, downSkip);
            buchou.on(Event.MOUSE_DOWN, this, downSkip);
            taione.on(Event.MOUSE_DOWN, this, downSkip);
            taitwo.on(Event.MOUSE_DOWN, this, downSkip);
            taithree.on(Event.MOUSE_DOWN, this, downSkip);
            taifour.on(Event.MOUSE_DOWN, this, downSkip);
            since.on(Event.MOUSE_DOWN, this, downSkip);
            auto.on(Event.MOUSE_DOWN, this, downSkip);
            cancle.on(Event.MOUSE_DOWN, this, downSkip);
            lqjlani.on(Event.MOUSE_DOWN, this, downSkip);
            onLineBox.on(Event.MOUSE_DOWN, this, downSkip);
            matchWaitBox.on(Event.MOUSE_DOWN, this, downSkip);
            waitBtn.on(Event.CLICK, this, onPrepareBtn);
            auto.on(Event.CLICK, this, clickAtuo);
            cancle.on(Event.CLICK, this, cancleAuto);
            initMask();

            violenUpdate();
            cancelImg.visible = FightManager.instance.getSkillBoomSelectFlag();
            cancelImg1.visible = FightManager.instance.getSkillBoomSelectFlag();
            skillUpdate();
            //        FightC.instance.playBgMusic();


            if (RuleM.instance.isShowScene)
            {
                box_task.visible = false;
            } else
            {
                box_task.visible = true;
            }

            //刷新一次任务
            refreshTask();
            list_reward.renderHandler = new Handler(this, updateItemReward);
            showRedPoint()
            initMonthCardIcon()

            reward.on(Event.MOUSE_DOWN, this, downSkip);
            since.on(Event.CLICK, this, clickIntergal);
            clip = new FontClip();
            since.visible = ENV.isShowDied() ? false : RuleM.instance.isShowScene;
            resetUi();

            Laya.timer.frameLoop(1, this, this.frameUpdate);
            Laya.timer.loop(1000, this, updateTime);
            updateCoinCount();
            startSign();
            totalIntergal.changeText("积分:" + Math.floor(RoleInfoM.instance.getAwardScore()) + "");
            initMatchingGame();
            initWarningList();
            playGetIn()
            onLineReward();
            refreshLottery();

            doubleCoin.on(Event.CLICK, this, onDoubleCoin)
            doubleChance.on(Event.CLICK, this, onDoubleChance)
            //            rankAniBox.on(Event.CLICK, this, onRankAniBox);
            doubleCoin.on(Event.MOUSE_DOWN, this, downSkip);
            doubleChance.on(Event.MOUSE_DOWN, this, downSkip);
            //            rankAniBox.on(Event.MOUSE_DOWN, this, downSkip);
            initDoubleRate()
            //            initRankAniBox();
        }

        private function clickIntergal():void
        {
            UiManager.instance.loadView("Rule");

        }

        private function onRankAniBox():void
        {
            UiManager.instance.loadView("Rank", null, ShowType.SMALL_TO_BIG);
        }

        private function initRankAniBox():void
        {
            isPlayingRankAni = false;
            rankAniImg.visible = false;
            rankAniBox.centerX = -900;
            if (ENV.isShowDied())
            {
                return;
            }
            if (LoginInfoM.instance.isShowRankAniBox == 1 && FightM.instance.isShowRankAni())
            {
                ApiManager.instance.get_rank_list(StartParam.instance.getParam("access_token"), function (result:Object)
                {
                    LevelM.instance.setTodayStrIsHaveReward(result);
                })
                Laya.timer.once(5000, this, actionRankAni)
            }
        }

        private function actionRankAni():void
        {
            if (!isPlayingRankAni)
            {
                isPlayingRankAni = true;
                rankAni.play(0, false);
                Laya.timer.once(3000, this, rankAniEnd);
            }
        }

        private function rankAniEnd():void
        {
            if (LoginInfoM.instance.isShowRankAniBox == 0)
            {
                rankAniImg.visible = false;
                rankAniBox.centerX = -900;
                isPlayingRankAni = false;
                return;
            }
            if (isPlayingRankAni)
            {
                if (LevelM.instance.isCanReward)
                {
                    rankAniLable.text = "领取排行榜奖励啦!!!"

                    rankAniLable.fontSize = 25;
                } else
                {
                    if (LevelM.instance.todayStrIsHaveReward)
                    {
                        rankAniLable.text = "保持当前实力榜排名，明日登录可领取奖励哦!!!"
                    } else
                    {
                        rankAniLable.text = "进入实力榜就有排名奖励哦!!!"
                    }
                }
                if (rankAniImg.visible == false)
                {
                    rankAniImg.visible = true;
                }
            }
        }

        private function onPrepareBtn():void
        {
            if (FightM.instance.isMatchingGame() && MatchM.instance.isMatchSart == 0)
            {
                WebSocketManager.instance.send(12101, null);
            }
        }


        private function endChangeBatteryRate():void
        {
            initDoubleRate()
        }

        private function initDoubleRate():void
        {
            var cfg:cfg_scene = cfg_scene.instance(FightM.instance.sceneId + "")
            doubleCoin.visible = false
            doubleCoin.gray = false
            doubleCoinLock.visible = false
            doubleCoinCancel.visible = false

            doubleChance.visible = false
            doubleChance.gray = false
            doubleChanceLock.visible = false
            doubleChanceCancel.visible = false


            if (cfg.doubleRate[0] == 1)
            {
                doubleCoin.visible = true
                if (RoleInfoM.instance.canDoubelCoin())
                {
                    doubleCoin.gray = false
                    doubleCoinLock.visible = false
                    if (RoleInfoM.instance.coin_rate == 1)
                    {
                        doubleCoinCancel.visible = false
                    } else
                    {
                        doubleCoinCancel.visible = true
                    }
                } else
                {
                    doubleCoin.gray = true
                    doubleCoinLock.visible = true
                }
            }


            if (cfg.doubleRate[1] == 1)
            {
                doubleChance.visible = true
                if (RoleInfoM.instance.canDoubelChance())
                {
                    doubleChance.gray = false
                    doubleChanceLock.visible = false
                    if (RoleInfoM.instance.chance_rate == 1)
                    {
                        doubleChanceCancel.visible = false
                    } else
                    {
                        doubleChanceCancel.visible = true
                    }
                } else
                {
                    doubleChance.gray = true
                    doubleChanceLock.visible = true
                }
            }

        }

        private function unlockDouble(type:String):void
        {
            WebSocketManager.instance.send(13009, {type: type})
        }


        private function onDoubleCoin():void
        {
            if (RoleInfoM.instance.canDoubelCoin())
            {
                if (RoleInfoM.instance.coin_rate == 1)
                {
                    WebSocketManager.instance.send(13007, {coin: 2})
                } else
                {
                    WebSocketManager.instance.send(13007, {coin: 1})
                }

            } else
            {
                var info:QuitTipInfo = new QuitTipInfo();
                info.state = GameConst.quit_state_left_cancel_right_confirm;
                info.content = "是否使用500钻石激活？";
                info.confirmCallback = Handler.create(this, unlockDouble, ['coin']);
                info.conFirmArgs = ['coin'];
                info.autoCloseTime = 10;
                GameEventDispatch.instance.event(GameEvent.QuitTip, info);
            }
        }

        private function onDoubleChance():void
        {
            if (RoleInfoM.instance.canDoubelChance())
            {
                if (RoleInfoM.instance.chance_rate == 1)
                {
                    WebSocketManager.instance.send(13007, {chance: 2})
                } else
                {
                    WebSocketManager.instance.send(13007, {chance: 1})
                }

            } else
            {
                var info:QuitTipInfo = new QuitTipInfo();
                info.state = GameConst.quit_state_left_cancel_right_confirm;
                info.content = "是否使用500钻石激活？";
                info.confirmCallback = Handler.create(this, unlockDouble, ['chance']);
                info.conFirmArgs = ['chance'];
                info.autoCloseTime = 10;
                GameEventDispatch.instance.event(GameEvent.QuitTip, info);
            }
        }

        private function startWave():void
        {
            coinWave(1200, 70, -10, -110);
        }

        //在线奖励功能
        private function onLineReward():void
        {
            lqjlani.play(0, true);
            _leftTime = OnLineM.instance.getLeftTime();
            refreshOnline();
            //if(OnLineM.instance.isAni){
            //OnLineImgEffect();
            //}
            //receiveBtn.on(Event.CLICK,this,clickReceive);
            //        receiveImg.on(Event.CLICK, this, clickReceive);
            //        countBox.on(Event.CLICK, this, clickReceive);
            //		lqjlani.on(Event.CLICK,this,clickReceive);
            onLineBox.on(Event.CLICK, this, clickReceive);
            //        Laya.timer.loop(1000, this, startTime);
        }

        private function startTime():void
        {

            if (_leftTime >= 1)
            {
                _leftTime = _leftTime - 1;
                updateOnlintTime(_leftTime);
            }

        }

        private function updateOnlintTime(time:Number):void
        {
            if (time <= 0)
            {
                time = 0;
            }
            leftTime.text = timeUtils(time) + "";
        }

        private function clickReceive():void
        {
            if (countBox.mouseEnabled == true)
            {
                var s2c:S2c_22000 = new S2c_22000();
                s2c.id = OnLineM.instance.RewardIndex;
                WebSocketManager.instance.send(22000, s2c);

            } else
            {
                GameTools.buttonEffect(receiveImg, 0.8, 0.8);
            }

        }

        public function timeUtils(time:int):String
        {
            var minute:String = Math.floor(time / 60) + "";
            var second:String = Math.floor(time % 60) + "";
            if (minute < 10)
            {
                minute = "0" + minute
            }

            if (second < 10)
            {
                second = "0" + second
            }
            var m:String = minute + ":" + second;
            return m;
        }

        private function refreshOnline():void
        {
            var obj:Object = OnLineM.instance.getAwardState(OnLineM.instance.RewardIndex - 1);
            rewardCount.text = obj.count;
            //btnState.text = obj.name;
            receiveImg.skin = obj.rewardUrl;
            receiveImg.visible = obj.isTimeVisible
            receiveImg.y = 80;
            //receiveImg.mouseEnabled = obj.enable;
            countBox.mouseEnabled = obj.enable;
            leftTime.visible = obj.isTimeVisible;
            getImg.visible = !obj.isTimeVisible;
            timeBox.visible = obj.isVisible;
            countBox.visible = obj.isVisible;
            lqjlani.visible = !obj.isTimeVisible
            _onlineCount = obj.count;
        }


        //在线奖励动效
        private function OnLineImgEffect():void
        {
            receiveImg.visible = false;
            lqjlani.play(0, true);
            //Laya.timer.frameLoop(1, this, giftShowOff);
        }

        private function giftShowOff():void
        {
            var delta:Number = Laya.timer.delta;
            var distance:Number = 15;
            var origin_y:Number = 80;
            var y:Number = origin_y - distance;

            var upTime:Number = 600;
            var totalTime:Number = 2000;
            var downTime:Number = totalTime - upTime;
            showOffTime += delta;
            if (showOffTime > totalTime)
            {
                showOffTime = 0
                receiveImg.y = origin_y;
            } else
            {
                if (showOffTime < upTime)
                {
                    receiveImg.y = Ease.sineIn(showOffTime, origin_y, -distance, upTime)
                } else
                {
                    receiveImg.y = Ease.bounceOut(showOffTime - upTime, y, distance, downTime)
                }
            }
        }

        private function pngPaoUpdate(pao:*):void
        {
            var paoMount:Sprite = pao.getChildAt(1) as Sprite;
            var spineAni:* = paoMount.getChildAt(0);
            if (spineAni && spineAni is BatteryImgAction)
            {
                spineAni.update();
            }
        }

        private function frameUpdate():void
        {
            paoAnimationCheck();
            startRoate();
            shootTick();
            pngPaoUpdate(paoone);
            pngPaoUpdate(paotwo);
            pngPaoUpdate(paothree);
            pngPaoUpdate(paofour);

        }


        private function cancleAuto(event:*):void
        {
            stopAuto();
            event.stopPropagation();
        }

        private function stopAuto():void
        {
            if (FireState == GameConst.atuoFire)
            {
                Laya.timer.clear(this, this.continuousShoot);
            }
            cancle.visible = false;
            FireState = GameConst.noAutoFire;
        }

        private function pauseAuto():void
        {
            if (FireState == GameConst.atuoFire)
            {
                Laya.timer.clear(this, continuousShoot);
                FireState = GameConst.oPauseAutoFire;
            }
        }

        private function resumeAuto():void
        {
            if (FireState == GameConst.oPauseAutoFire)
            {
                if (!FightManager.instance.getSkillBoomSelectFlag() && !FightM.instance.isOwnLock() && fishPageAutoShootEnable())
                {
                    Laya.timer.frameLoop(1, this, this.continuousShoot);
                    FireState = GameConst.atuoFire;
                }
            }
        }

        private function fishPageAutoShootEnable():Boolean
        {
            var ret:Boolean = true;
            var uiLayer:Sprite = null;
            for (var i:int = 0; i < Laya.stage.numChildren; i++)
            {
                uiLayer = Laya.stage.getChildAt(i) as Sprite;

                if (uiLayer && uiLayer.visible && uiLayer.name.length > 0 && uiLayer.zOrder > this.zOrder)
                {
                    if (uiLayer.name != "Levelup" &&
                            uiLayer.name != "HorseTip" &&
                            uiLayer.name != "GoldTip" &&
                            uiLayer.name != "Mask" &&
                            uiLayer.name != "Prize")
                    {
                        ret = false;
                        break;
                    }
                }

            }
            return ret;
        }

        private function clickAtuo(event:*):void
        {
            //            if (RoleInfoM.instance.haveValidMonthCard() || FightM.instance.getAutoTime() > 0)
            //            {
            if (!FightManager.instance.getSkillBoomSelectFlag() && !FightM.instance.isOwnLock())
            {
                desX = 20 + Math.random() * (GameConst.design_width - 40);
                desY = 50 + Math.random() * (GameConst.design_height - 100);
                continuousShootLeftTime = FightM.instance.getShootInterval();
                FireState = GameConst.atuoFire;
                cancle.visible = true;
                isAtuoFire = false;
                Laya.timer.frameLoop(1, this, this.continuousShoot);
            }
            if (FightManager.instance.getSkillBoomSelectFlag())
            {
                GameEventDispatch.instance.event(GameEvent.MsgTip, 39);
            } else if (FightM.instance.isOwnLock())
            {
                GameEventDispatch.instance.event(GameEvent.MsgTip, 38);
            }
            //            } else
            //            {
            //                goShop();
            //                //monthTip();
            //            }
            event.stopPropagation();

        }

        private function iphoneXLeftLayout():void
        {
            changeSkinBtn.left = 20 + GameTools.iphoneXOffset;
//            month.left = 20 + GameTools.iphoneXOffset;
            unlockBox.left = -527 + GameTools.iphoneXOffset;
            lottey.left = -527 + GameTools.iphoneXOffset;
            backPanel.left = -359 + GameTools.iphoneXOffset;
        }

        private function iphoneXLeftLayoutReset():void
        {
            changeSkinBtn.left = 70;
            unlockBox.left = -477;
            lottey.left = -477;
            backPanel.left = -359;
//            month.left = 70;
        }

        private function iphoneXRightLayout():void
        {
            skill_bg.right = -30 + GameTools.iphoneXOffset;
            skill_1.right = 2 + GameTools.iphoneXOffset;
            skill_2.right = 2 + GameTools.iphoneXOffset;
            skill_3.right = 2 + GameTools.iphoneXOffset;
            skill_4.right = 2 + GameTools.iphoneXOffset;
            skill_5.right = 2 + GameTools.iphoneXOffset;
            skill_6.right = 2 + GameTools.iphoneXOffset;
            yulei.right = -55 + GameTools.iphoneXOffset;
        }

        private function iphoneXRightLayoutReset():void
        {
            skill_bg.right = 20;
            skill_1.right = 52;
            skill_2.right = 52;
            skill_3.right = 52;
            skill_4.right = 52;
            skill_5.right = 52;
            skill_6.right = 52
            yulei.right = -5
        }

        private function isMateShow():Boolean
        {
            var ret:Boolean = false;
            var uiLayer:Sprite = null;
            for (var i:int = 0; i < Laya.stage.numChildren; i++)
            {
                uiLayer = Laya.stage.getChildAt(i) as Sprite;

                if (uiLayer && uiLayer.visible && uiLayer.name.length > 0)
                {
                    if (uiLayer.name == "Mate")
                    {
                        ret = true;
                        break;
                    }
                }

            }
            return ret;
        }

        private function isMatchSettleShow():Boolean
        {
            var ret:Boolean = false;
            var uiLayer:Sprite = null;
            for (var i:int = 0; i < Laya.stage.numChildren; i++)
            {
                uiLayer = Laya.stage.getChildAt(i) as Sprite;

                if (uiLayer && uiLayer.visible && uiLayer.name.length > 0)
                {
                    if (uiLayer.name == "MatchSettle")
                    {
                        ret = true;
                        break;
                    }
                }

            }
            return ret;
        }

        private function syncActivityStatus()
        {
            if (ActivityM.instance.redPackTicketContinueTime && FightM.instance.coinShootScene() && RuleM.instance.isRewardShowScene())
            {
                lottey.visible = true;
            } else
            {
                lottey.visible = false;
            }

            if (lottey.visible == true)
            {
                settingBtn.centerY = 65;
                lottey.centerY = -13;
                returnBtn.centerY = 145
            } else
            {
                settingBtn.centerY = -15;
                returnBtn.centerY = 65;
            }
        }

        private function resetUi():void
        {
            paoone.y = GameTools.designPosYMapScreenPosY(692);
            paoone.x = GameTools.designPosXMapScreenPosX(430);
            box_1.x = paoone.x - 402;
            box_1.y = paoone.y - 76;
            powerOne.x = paoone.x;
            powerOne.y = paoone.y + 2;
            paotwo.x = GameTools.designPosXMapScreenPosX(GameConst.design_width / 2 + 210);
            paotwo.y = GameTools.designPosYMapScreenPosY(GameConst.design_height - 28);
            box_2.x = paotwo.x - 94;
            box_2.y = paotwo.y - 76;
            powerTwo.x = paotwo.x;
            powerTwo.y = paotwo.y + 2;
            dentwo.x = paotwo.x + 110;
            dentwo.y = paotwo.y - 6;
            paothree.y = GameTools.designPosYMapScreenPosY(30);//30;
            paothree.x = paotwo.x;//deWidth/2+210;
            powerThree.x = paothree.x;
            powerThree.y = paothree.y - 4;
            box_3.x = paothree.x - 94;
            box_3.y = paothree.y - 32;
            denthree.x = paothree.x + 110;
            denthree.y = paothree.y + 10;
            paofour.y = GameTools.designPosYMapScreenPosY(30)//30;
            paofour.x = paoone.x//deWidth/2-210;
            powerFour.x = paofour.x;
            powerFour.y = paofour.y - 4;
            denfour.x = paofour.x - 110;
            denfour.y = paofour.y + 10;
            box_4.x = paofour.x - 382;
            box_4.y = paofour.y - 32;
            since.x = Laya.stage.width / 2;
            since.y = 10;
            box_task.x = Laya.stage.width / 2;
            box_task.y = 10;

            if (GameTools.isIphoneXCrossScreen())
            {
                if (ScreenAdaptManager.instance.notch == "left")
                {
                    iphoneXLeftLayout()
                    iphoneXRightLayoutReset()
                } else if (ScreenAdaptManager.instance.notch == "right")
                {
                    iphoneXRightLayout()
                    iphoneXLeftLayoutReset()
                }
            } else
            {
                iphoneXRightLayoutReset()
                iphoneXLeftLayoutReset()
            }

            this.size(Laya.stage.width, Laya.stage.height);

            FightManager.instance.setLockLinePosArray([paoone.x, paoone.y, paotwo.x, paotwo.y, paothree.x, paothree.y, paofour.x, paofour.y]);
            unlockBox.visible = false; //FightM.instance.coinShootScene();
            changeSkinBtn.visible = FightM.instance.coinShootScene();
            BackBox.instance.resetUi();
            MatchInfoBox.instance.resetUi();
            if (!ENV.isShowDied())
            {
                month.visible = false; //FightM.instance.coinShootScene();
            } else
            {
                month.visible = false;
            }
            syncActivityStatus()

            //box_task.visible = FightM.instance.coinShootScene();

            onLineBox.visible = FightM.instance.coinShootScene();

            seatZsOne.visible = FightM.instance.coinShootScene();
            seatJifenOne.visible = !FightM.instance.coinShootScene();
            coinOne.visible = FightM.instance.coinShootScene();
            ccoinOne.visible = !FightM.instance.coinShootScene();
            auto.visible = FightM.instance.coinShootScene();
            //cancle.visible = FightM.instance.coinShootScene();
            autoTimeTip.visible = FightM.instance.coinShootScene();
            contestTimeBox.visible = false;//!FightM.instance.coinShootScene();
            if (!FightM.instance.isMatchingGame())
            {
                contestTimeBox.visible = !isMateShow();
                FightM.instance.initCountDown(FightM.instance.getContestEndTime(), contestTimeText);
            }
            //新手引导炮位置
            GameEventDispatch.instance.event(GameEvent.PaoOneReset, [paoone.x, paoone.y]);


        }


        private function closeAllMatchGameModule():void
        {
            alreadyOne.visible = false;
            alreadyTwo.visible = false;
            alreadyThree.visible = false;
            alreadyFour.visible = false;
        }


        private function startAgainMatchingGame():void
        {

            MatchM.instance.initMatchimgGameData(true);
            initMatchingGame();
        }


        private function updateMatchingGamePanel():void
        {
            if (!isMatchSettleShow())
            {
                initMatchingGame();
            }
        }

        //匹配赛 刷新界面
        private function initMatchingGame():void
        {
            if (FightM.instance.isMatchingGame())
            {
                waitBox.visible = false;
                waitBtn.visible = false;
                if (!MatchM.instance.isMatchSart)
                {
                    matchWaitBox.visible = true;
                    closeAllMatchGameModule();
                    playerMatchingGameStateShow();
                } else
                {
                    matchWaitBox.visible = false;
                    closeAllMatchGameModule();
                }

            } else
            {
                matchWaitBox.visible = false;
                closeAllMatchGameModule();
            }
        }

        private function playerMatchingGameStateShow():void
        {
            var seatInfo:ProtoSeatInfo;
            seatInfo = FightM.instance.getSeatInfo(FightM.instance.getSeatIdByShowSeatId(1));
            if (seatInfo)
            {
                if (MatchM.instance.prepareState[1])
                {
                    waitBox.visible = true;
                    alreadyOne.visible = true
                } else
                {
                    waitBtn.visible = true;
                }
            }
            seatInfo = FightM.instance.getSeatInfo(FightM.instance.getSeatIdByShowSeatId(2));
            if (seatInfo)
            {
                if (MatchM.instance.prepareState[2])
                {
                    alreadyTwo.visible = true
                }
            }
            seatInfo = FightM.instance.getSeatInfo(FightM.instance.getSeatIdByShowSeatId(3));
            if (seatInfo)
            {
                if (MatchM.instance.prepareState[3])
                {
                    alreadyThree.visible = true
                }
            }
            seatInfo = FightM.instance.getSeatInfo(FightM.instance.getSeatIdByShowSeatId(4));
            if (seatInfo)
            {
                if (MatchM.instance.prepareState[4])
                {
                    alreadyFour.visible = true
                }
            }
        }

        private function useBoom(skillIndex:Number, event:Event):void
        {
            selectBoomIndex = skillIndex;
            useSkill(skillIndex);
            yulei.visible = false;
            event.stopPropagation();
        }

        private function clickOnline():void
        {
            UiManager.instance.loadView("OnLineReward", null, ShowType.SMALL_TO_BIG);

        }

        private function boomUpdate():void
        {
            cancelImg1.visible = FightManager.instance.getSkillBoomSelectFlag();
            cancelImg.visible = FightManager.instance.getSkillBoomSelectFlag();


            if (FightManager.instance.getSkillBoomSelectFlag())
            {
                pauseAuto();
            } else
            {
                resumeAuto();
            }


        }

        private function violenUpdate():void
        {

            violentOne.visible = FightM.instance.isShowSeatViolent(1);
            violentOneBg.visible = FightM.instance.isShowSeatViolent(1);
            violentTwo.visible = FightM.instance.isShowSeatViolent(2);
            violentTwoBg.visible = FightM.instance.isShowSeatViolent(2);
            violentThree.visible = FightM.instance.isShowSeatViolent(3);
            violentThreeBg.visible = FightM.instance.isShowSeatViolent(3);
            violentFour.visible = FightM.instance.isShowSeatViolent(4);
            violentFourBg.visible = FightM.instance.isShowSeatViolent(4);

        }

        private function initMask():void
        {
            if (!roateMaskOne.getChildAt(0))
            {
                roateMaskOne.addChild(AnimalManger.instance.load("cd"));
                roateMaskTwo.addChild(AnimalManger.instance.load("cd"));
                roateMaskThree.addChild(AnimalManger.instance.load("cd"));
                roateMaskFour.addChild(AnimalManger.instance.load("cd"));
                roateMaskFive.addChild(AnimalManger.instance.load("cd"));
                roateMaskSix.addChild(AnimalManger.instance.load("cd"));
            }
        }


        private function rotateRoation(remainTime:Number, totalTime:Number, maskSp:Sprite, id:int):void
        {
            if (remainTime > 0)
            {
                //			maskSp.mask.graphics.clear();
                //			var startEngle:Number = (totalTime - remainTime * 1000) / totalTime * 360 + -90;
                //			maskSp.mask.graphics.drawPie(0, 0, 50, startEngle, 270, "#88ee1a");
                var ani:Animation = maskSp.getChildAt(0) as Animation;
                var percent:int = Math.floor((totalTime - remainTime * 1000) * 80 / totalTime);
                //			maskSp.loadImage("ani/cd/yy1_" + percent + ".png");
                ani.interval = 100000;
                ani.play(percent, false);
                maskSp.visible = true;
            } else
            {
                maskSp.visible = false;
            }
        }

        private function startRoate():void
        {
            rotateRoation(remainTime(0), totalTime(0), roateMaskOne, 0);
            rotateRoation(remainTime(1), totalTime(1), roateMaskTwo, 1);
            rotateRoation(remainTime(2), totalTime(2), roateMaskThree, 2);
            rotateRoation(remainTime(3), totalTime(3), roateMaskFour, 3);
            rotateRoation(getBoomRamainTime(), totalTime(4), roateMaskFive, 4);
            rotateRoation(remainTime(10), totalTime(10), roateMaskSix, 10);
        }


        private function initViolent():void
        {
            if (!violentOne)
            {
                var paotaiName:String = "paotai";
                var paoshengName:String = "paosheng";
                paoOneMount = new Sprite();
                violentOne = AnimalManger.instance.load(paoshengName);
                violentOneBg = AnimalManger.instance.load(paotaiName);
                violentOne.pivot((ConfigManager.getConfValue("cfg_anicollision", paoshengName, "pivotX") as int),
                        ConfigManager.getConfValue("cfg_anicollision", paoshengName, "pivotY") as int);
                violentOneBg.pivot((ConfigManager.getConfValue("cfg_anicollision", paotaiName, "pivotX") as int),
                        ConfigManager.getConfValue("cfg_anicollision", paotaiName, "pivotY") as int);
                violentOne.play(0, true);
                violentOneBg.play(0, true);


                paoone.addChild(violentOneBg);
                paoone.addChild(paoOneMount);
                paoone.addChild(violentOne);


                paoTwoMount = new Sprite();
                violentTwo = AnimalManger.instance.load(paoshengName);
                violentTwoBg = AnimalManger.instance.load(paotaiName);
                violentTwo.pivot((ConfigManager.getConfValue("cfg_anicollision", paoshengName, "pivotX") as int),
                        ConfigManager.getConfValue("cfg_anicollision", paoshengName, "pivotY") as int);
                violentTwoBg.pivot((ConfigManager.getConfValue("cfg_anicollision", paotaiName, "pivotX") as int),
                        ConfigManager.getConfValue("cfg_anicollision", paotaiName, "pivotY") as int);
                violentTwo.play(0, true);
                violentTwoBg.play(0, true);
                paotwo.addChild(violentTwoBg);
                paotwo.addChild(paoTwoMount);
                paotwo.addChild(violentTwo);

                paoThreeMount = new Sprite();
                violentThree = AnimalManger.instance.load(paoshengName);
                violentThreeBg = AnimalManger.instance.load(paotaiName);
                violentThree.pivot((ConfigManager.getConfValue("cfg_anicollision", paoshengName, "pivotX") as int),
                        ConfigManager.getConfValue("cfg_anicollision", paoshengName, "pivotY") as int);
                violentThreeBg.pivot((ConfigManager.getConfValue("cfg_anicollision", paotaiName, "pivotX") as int),
                        ConfigManager.getConfValue("cfg_anicollision", paotaiName, "pivotY") as int);
                violentThree.play(0, true);
                violentThreeBg.play(0, true);
                violentThreeBg.scaleY = -1;

                paothree.addChild(violentThreeBg);
                paothree.addChild(paoThreeMount);
                paothree.addChild(violentThree);

                paoFourMount = new Sprite();
                violentFour = AnimalManger.instance.load(paoshengName);
                violentFourBg = AnimalManger.instance.load(paotaiName);
                violentFour.pivot((ConfigManager.getConfValue("cfg_anicollision", paoshengName, "pivotX") as int),
                        ConfigManager.getConfValue("cfg_anicollision", paoshengName, "pivotY") as int);
                violentFourBg.pivot((ConfigManager.getConfValue("cfg_anicollision", paotaiName, "pivotX") as int),
                        ConfigManager.getConfValue("cfg_anicollision", paotaiName, "pivotY") as int);
                violentFour.play(0, true);
                violentFourBg.play(0, true);
                violentFourBg.scaleY = -1;

                paofour.addChild(violentFourBg);
                paofour.addChild(paoFourMount);
                paofour.addChild(violentFour);

            }
        }

        private function goodsUpdate():void
        {
            updateSKill();

        }

        private function skillUpdate():void
        {

            updateSkillBtn();
        }


        private function updateSkillBtn():void
        {
            //			aniOne.visible = true;
            //			aniTwo.visible = true;
            //			aniThree.visible = true;
            //			aniFour.visible = true;
            //			aniFive.visible = true;
            //			aniOne.play(startInex(0),false);
            //			aniTwo.play(startInex(1),false);
            //			aniThree.play(startInex(2),false);
            //			aniFour.play(startInex(3),false);
            //			aniFive.play(startInex(4),false);
            //			roateRoation(remainTime(0),totalTime(0),spOne);
            //			roateRoation(remainTime(1),totalTime(1),spTwo);
            //			roateRoation(remainTime(2),totalTime(2),spThree);
            //			roateRoation(remainTime(3),totalTime(3),spFour);
            //			roateRoation(remainTime(4),totalTime(4),spFive);


        }


        public function get oneStartIndex():int
        {

            return null;
        }

        public function startInex(id:int):Number
        {
            var skillId:int = FightM.instance.getSkillId(id);
            var cdLeftTime:Number = FightM.instance.getSkillCdLeftTime(skillId);
            var totalTime:Number = SkillM.instance.skillTime(id);
            var t:Number = totalTime / 36;
            var remainTimw:Number = totalTime - cdLeftTime;
            var index:int = remainTimw / t;
            return index * 10 + -90;
        }

        public function totalTime(id:int):Number
        {
            return SkillM.instance.skillTime(id);
        }


        //抽奖状态的旋转效果
        private function lotteryEffect():void
        {

        }


        public function getBoomRamainTime():Number
        {
            var lt:Number = 0;
            for (var boomSkillId:int = 6; boomSkillId <= 10; boomSkillId++)
            {
                var cdLeftTime:Number = FightM.instance.getSkillCdLeftTime(boomSkillId);
                if (cdLeftTime > lt)
                {
                    lt = cdLeftTime
                }
            }
            if (lt <= 0)
            {
                lt = 0;
            }

            return lt
        }

        public function remainTime(id:int):Number
        {
            var skillId:int = FightM.instance.getSkillId(id);
            var cdLeftTime:Number = FightM.instance.getSkillCdLeftTime(skillId);
            if (cdLeftTime <= 0)
            {
                cdLeftTime = 0;
            }
            return cdLeftTime;
        }

        //开始角度
        public function startEngel(id:int):Number
        {
            var skillId:int = FightM.instance.getSkillId(id);
            var cdLeftTime:Number = FightM.instance.getSkillCdLeftTime(skillId);
            var totalTime:Number = SkillM.instance.skillTime(id);
            var t:Number = totalTime / 36;
            var remainTimw:Number = totalTime - cdLeftTime;
            var index:int = remainTimw / t;
            return index * 10 + -90;
        }


        private function initSkillAni():void
        {
            //        aniOne = AnimalManger.instance.load("skill");
            //        this.addChild(aniOne);
            //        aniTwo = AnimalManger.instance.load("skill");
            //        this.addChild(aniTwo);
            //        aniThree = AnimalManger.instance.load("skill");
            //        this.addChild(aniThree);
            //        aniFour = AnimalManger.instance.load("skill");
            //        this.addChild(aniFour);
            //        aniFive = AnimalManger.instance.load("skill");
            //        this.addChild(aniFive);
            //        aniOne.x = skill_1.x;
            //        aniOne.y = skill_1.y;
            //        aniTwo.x = skill_2.x;
            //        aniTwo.y = skill_2.y;
            //        aniThree.x = skill_3.x;
            //        aniThree.y = skill_3.y;
            //        aniFour.x = skill_4.x;
            //        aniFour.y = skill_4.y;
            //        aniFive.x = skill_5.x;
            //        aniFive.y = skill_5.y;
            //        aniOne.visible = false;
            //        aniTwo.visible = false;
            //        aniThree.visible = false;
            //        aniFour.visible = false;
            //        aniFive.visible = false;
        }

        private function initSkillUi():void
        {
            skillImageOne = skill_1.getChildByName("skill_1") as Image;
            skillImageTwo = skill_2.getChildByName("skill_2") as Image;
            skillImageThree = skill_3.getChildByName("skill_3") as Image;
            skillImageFour = skill_4.getChildByName("skill_4") as Image;
            skillImageFive = skill_5.getChildByName("skill_5") as Image;
            skillClipOne = skill_1.getChildByName("skillClip_1") as FontClip;
            skillClipTwo = skill_2.getChildByName("skillClip_2") as FontClip;
            skillClipThree = skill_3.getChildByName("skillClip_3") as FontClip;
            skillClipFour = skill_4.getChildByName("skillClip_4") as FontClip;
            skillClipFive = skill_5.getChildByName("skillClip_5") as FontClip;
            skillClipSix = skill_6.getChildByName("skillClip_1") as FontClip;
            diamondOne = skill_1.getChildByName("zs") as Image;
            diamondTwo = skill_2.getChildByName("zs") as Image;
            diamondThree = skill_3.getChildByName("zs") as Image;
            diamondFour = skill_4.getChildByName("zs") as Image;
            diamondFive = skill_5.getChildByName("zs") as Image;
            diamondFive.visible = false;
            diamondSix = skill_6.getChildByName("zs") as Image;
            diamondSix.visible = false;
        }


        private function yuleiRenderHander(cell:Box, index:Number):void
        {
            var config:cfg_goods = cell.dataSource;
            var iconImg:Image = cell.getChildByName("icon") as Image;
            var yulei_count:FontClip = cell.getChildByName("yulei_count") as FontClip;
            iconImg.skin = config.icon;
            setFontClipValue(yulei_count, SkillM.instance.skillCount(5 + index) + "")
            cell.offAll(Event.CLICK);
            cell.offAll(Event.MOUSE_DOWN);
            cell.on(Event.CLICK, this, useBoom, [5 + index]);
            cell.on(Event.MOUSE_DOWN, this, downSkip);
        }

        private function updateSKill():void
        {
            var arr:Array = [
                {skill: skill_1, diamond: diamondOne, skill_count: skillClipOne, index: 0},
                {skill: skill_2, diamond: diamondTwo, skill_count: skillClipTwo, index: 1},
                {skill: skill_3, diamond: diamondThree, skill_count: skillClipThree, index: 2}

            ]

            !ENV.isShowDied() && arr.push({skill: skill_4, diamond: diamondFour, skill_count: skillClipFour, index: 3})
            skill_4.visible = !ENV.isShowDied();
            skill_5.visible = false
//            arr.push(/*{skill: skill_6, diamond: diamondSix, skill_count: skillClipSix, index: 10},*/
//                    {skill: skill_5, diamond: diamondFive, skill_count: skillClipFive, index: 5})


            var centerArr:Array = [-75, 15, 105, 195, 285];
            var pointIndex:int = 0;

            for (var i:int = 0; i < arr.length; i++)
            {
                var skillBox:Box = arr[i].skill;
                var diamond:Image = arr[i].diamond;
                var skillCount:FontClip = arr[i].skill_count;
                var index:int = arr[i].index;
                var isYulei:Boolean = index == 5;
                if (SkillM.instance.skillUrl(index) != null)
                {
                    skillBox.visible = true;
                    skillBox.centerY = centerArr[pointIndex];
                    pointIndex++;

                    //鱼雷
                    if (isYulei)
                    {
                        yuleiList.array = FightM.instance.getyuleiItems();
                        yuleiList.width = yuleiList.array.length * 89;
                        yuleiList.x = 500 - yuleiList.array.length * 89;
                        yuleiBg.width = yuleiList.array.length * 89 + 125;
                        var total_count:int = 0;
                        for (var i:int = 0; i < yuleiList.array.length; i++)
                        {
                            total_count += SkillM.instance.skillCount(index + i);
                        }
                        setFontClipValue(skillCount, total_count + "");
                    } else
                    {
                        if (SkillM.instance.skillCount(index) > 0)
                        {
                            diamond.visible = false;
                            setFontClipValue(skillCount, SkillM.instance.skillCount(index) + "");
                        } else if (index == 10)
                        {
                            setFontClipValue(skillCount, "0");
                        } else
                        {

                            diamond.visible = true;
                            setFontClipValue(skillCount, SkillM.instance.diamondCount(index) + "");
                        }
                    }

                } else if (index == 10 && FightM.instance.coinShootScene())
                {
                    skillBox.visible = true;
                    skillBox.centerY = centerArr[pointIndex];
                    pointIndex++;
                } else
                {
                    skillBox.visible = false;
                }
            }
            skill_bg.height = pointIndex * 90;
            console.log("pointIndex",pointIndex)
            skill_bg.centerY = (pointIndex - 2) * 15;
            diamondSix.visible = false;
            skillClipSix.visible = true;

            skill_6.visible = false;

        }


        public function closeOtherBars(event:Event):void
        {
            deblockGoEffect();
            lotteryGoEffect();
        }


        private function useSkill(skillIndex:int):void
        {
            var skillId:int = FightM.instance.getSkillId(skillIndex);
            var cdLeftTime:Number = FightM.instance.getSkillCdLeftTime(skillId);

            if (cdLeftTime <= 0 && skillId > 0)
            {
                var skillType:int = ConfigManager.getConfValue("cfg_skill", skillId, "skill_type") as int;
                if (skillType == GameConst.skill_type_boom)
                {
                    if (SkillM.instance.skillCount(skillIndex) <= 0)
                    {
                        GameEventDispatch.instance.event(GameEvent.MsgTip, 2);
                    } else
                    {
                        FightManager.instance.setSkillBoomSelectFlag(skillId);
                    }
                } else if (skillType == GameConst.skill_type_auto)
                {
                    if (SkillM.instance.skillCount(skillIndex) <= 0)
                    {
                        GameEventDispatch.instance.event(GameEvent.MsgTip, 40);
                    } else
                    {
                        FightManager.instance.useSkill(skillId);
                    }
                } else
                {
                    if (!FightManager.instance.getSkillBoomSelectFlag())
                    {
                        if (SkillM.instance.isConsumeEnough(skillIndex))
                        {
                            //                        var msg: C2s_17001 = new C2s_17001();
                            //                        msg.id = skillId;
                            //                        WebSocketManager.instance.send(17001, msg);
                            FightManager.instance.useSkill(skillId);
                        } else
                        {
                            if (WxC.isHideShop())
                            {
                                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "钻石不足");
                            } else
                            {
                                var info:QuitTipInfo = new QuitTipInfo();
                                info.state = GameConst.quit_state_left_cancel_right_confirm;
                                info.content = "钻石不足是否前去充值";
                                info.confirmMsg = GameEvent.Shop;
                                info.conFirmArgs = GameConst.shop_tab_diamond;
                                info.autoCloseTime = 10;
                                if (RoleInfoM.instance.isSkillResTip())
                                {
                                    GameEventDispatch.instance.event(GameEvent.QuitTip, info);
                                } else
                                {
                                    var tmpInfo:QuitTipInfo = new QuitTipInfo();
                                    var diamondNum:int = SkillM.instance.skillDiamondCount(skillId);
                                    tmpInfo.state = GameConst.quit_state_left_cancel_right_confirm;
                                    tmpInfo.content = "道具不足，是否花费" + diamondNum + "钻石释放该技能";
                                    tmpInfo.confirmMsg = GameEvent.UseGoodsConfirmAndJumpToShop;
                                    tmpInfo.conFirmArgs = info;
                                    tmpInfo.autoCloseTime = 10;
                                    GameEventDispatch.instance.event(GameEvent.QuitTip, tmpInfo);
                                }
                            }


                        }

                    }
                }
            }
        }

        private function downSkip(event:Event):void
        {
            event.stopPropagation();
        }

        private function clickSkill1(event:Event):void
        {
            useSkill(0);
            event.stopPropagation();
        }

        private function clickSkill6(event:Event):void
        {
            useSkill(10);
            event.stopPropagation();
        }

        private function aniOnePlayComplete():void
        {
            IsOneClick = true;
            //        aniOne.visible = false;

        }

        private function clickSkill2(event:Event):void
        {
            useSkill(1);
            event.stopPropagation();
        }

        private function aniTwoComplete():void
        {
            IsTwoClick = true;
            aniTwo.visible = false;

        }

        private function clickSkill3(event:Event):void
        {
            useSkill(2);
            event.stopPropagation();
        }

        private function aniThreeComplete():void
        {
            IsThreeClick = true;
            aniThree.visible = false;

        }

        private function clickSkill4(event:Event):void
        {
            //			if(IsFourClick){
            //			  IsFourClick = false;
            //			  aniFour.visible = true;
            //			  aniFour.interval = SkillM.instance.skillTime(3)/40;
            //			  aniFour.play(0,false);
            //		      aniFour.on(Event.COMPLETE,this,aniFourComplete);
            //			}
            useSkill(3);
            event.stopPropagation();
        }

        private function aniFourComplete():void
        {
            IsFourClick = true;
            aniFour.visible = false;

        }

        private function clickSkill5(event:Event):void
        {
            if (getBoomRamainTime() <= 0)
            {
                yulei.visible = !yulei.visible
            }
            //        if (cancelImg.visible == false) {
            //            GameTools.buttonEffect(skill_5);
            //        }
            event.stopPropagation();

        }

        private function staraniFiveComplete():void
        {
            IsFiveClick = true;
            aniFive.visible = false;

        }


        private function initUi():void
        {

            jichP = buchou.getChildByName("pre") as ProgressBar;
            jiNowCount = buchou.getChildByName("now") as FontClip;
            baseFishCount = buchou.getChildByName("base") as FontClip;
            jichiNumTwo = nchou.getChildByName("rewCount") as FontClip;
            _rewardLevelName = nchou.getChildByName("ctxt") as Label;
            autoTimeTip.visible = false;
            setFontClipValue(diamodOne, "0");
            setFontClipValue(diamodTwo, "0");
            setFontClipValue(diamodThree, "0");
            setFontClipValue(diamodFour, "0");
        }

        private function clickPowerAdd(event:Event):void
        {

            //collcet();
            lotteryGoEffect();
            //deblockGoEffect();
            event.stopPropagation();
            var sceneId:int = FightM.instance.getSceneId();
            var useBattery:int = FightM.instance.getOwnUseBattery();
            var nextBattry:int = useBattery;
            var ownBattery:int = RoleInfoM.instance.getBattery();
            var sceneMinMag:int = ConfigManager.getConfValue("cfg_scene", sceneId, "min_mag") as int;
            var sceneMaxMag:int = ConfigManager.getConfValue("cfg_scene", sceneId, "max_mag") as int;
            if (useBattery == sceneMaxMag)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTip, 24);
            }
            if (FightM.instance.isMatchingGame())
            {
                if (useBattery < sceneMaxMag)
                {
                    nextBattry++;
                } else
                {
                    nextBattry = sceneMinMag;
                }
            } else
            {
                if (useBattery < sceneMaxMag && useBattery < ownBattery)
                {
                    nextBattry++;
                } else
                {
                    nextBattry = sceneMinMag;
                }
            }
            var protoData:C2s_13003 = new C2s_13003();
            protoData.skin = 0;
            protoData.battery = nextBattry;
            WebSocketManager.instance.send(13003, protoData);
        }

        private function _clickPowerSub():void
        {
            var sceneId:int = FightM.instance.getSceneId();
            var useBattery:int = FightM.instance.getOwnUseBattery();
            var nextBattry:int = useBattery;
            var ownBattery:int = RoleInfoM.instance.getBattery();
            var sceneMinMag:int = ConfigManager.getConfValue("cfg_scene", sceneId, "min_mag") as int;
            var sceneMaxMag:int = ConfigManager.getConfValue("cfg_scene", sceneId, "max_mag") as int;
            if (useBattery == sceneMinMag)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTip, 25);
            }
            if (FightM.instance.isMatchingGame())
            {
                if (useBattery > sceneMinMag)
                {
                    nextBattry--;
                } else
                {
                    nextBattry = sceneMaxMag;
                }
            } else
            {
                if (useBattery > sceneMinMag)
                {
                    nextBattry--;
                } else
                {
                    nextBattry = Math.min(ownBattery, sceneMaxMag);
                }
            }
            var protoData:C2s_13003 = new C2s_13003();
            protoData.skin = 0;
            protoData.battery = nextBattry;
            WebSocketManager.instance.send(13003, protoData);
        }

        private function clickPowerSub(event:Event):void
        {
            //collcet();
            lotteryGoEffect();
            event.stopPropagation();
            _clickPowerSub()
        }


        private function clickBoxTwo(event:Event):void
        {
            event.stopPropagation();
            GameEventDispatch.instance.event(GameEvent.Shop, GameConst.shop_tab_diamond);
        }


        private function collcet():void
        {
            if (nchou.x == 8)
            {
                chu.play(0, false);
            }
        }

        private function unlockbattery():void
        {
            WebSocketManager.instance.send(13001, null);

            //刷新解锁炮台弹出提示
            unlockBatteryTip = false
            unlockBatteryTipTime = new Date().getTime();
        }

        private function clickBoxOne(event:Event):void
        {
            event.stopPropagation();

            unlockbattery()
        }

        private function initPowerUi():void
        {
            powerOneTxt = gunBoxOne.getChildByName("ptxt") as Label;
            giveClip = gunBoxOne.getChildByName("rewardCount") as FontClip;
            pro = gunBoxTwo.getChildByName("pre") as ProgressBar;
            powerTwoTxt = gunBoxTwo.getChildByName("ptxt") as Label;
            needDiaClip = gunBoxTwo.getChildByName("needZ") as FontClip;
            haveDiaClip = gunBoxTwo.getChildByName("yZuan") as FontClip;
        }

        private function hideGunShow():void
        {
            paoCollect();
        }

        private function updatePower():void
        {
            var power:Number = GunM.instance.getNextPower(RoleInfoM.instance.getBattery());
            if (power < 0)
            {
                gunImg.visible = false;
                battery_icon_bg.visible = false;
                gunBoxOne.visible = false;
                gunBoxTwo.visible = false;
                hideGunShow();
                return;
            }
            var needCount:Number = GunM.instance.needDiamod(RoleInfoM.instance.getBattery());
            var haveCount:Number = RoleInfoM.instance.getDiamond();
            var giveCount:Number = GunM.instance.giveCount(RoleInfoM.instance.getBattery());


            updatePowerData(power, haveCount, needCount, giveCount);
        }

        private function updatePowerData(power:Number, haveCount:Number, needCount:Number, giveCount:Number):void
        {
            if (haveCount >= needCount)
            {
                gunBoxOne.visible = true;
                gunBoxTwo.visible = false;
                battery_icon_bg.visible = true;
                if (isAuto)
                {
                    isAuto = false;
                    deblockComeEffect();
                    unlockBatteryTip = true
                    unlockBatteryTipTime = new Date().getTime();
                }

            } else
            {
                isAuto = true;
                gunBoxOne.visible = false;
                gunBoxTwo.visible = true;
                battery_icon_bg.visible = false;
            }
            if (power < 0)
            {
                gunImg.visible = false;
                battery_icon_bg.visible = false;
                gunBoxOne.visible = false;
                gunBoxTwo.visible = false;
            }
            powerOneTxt.changeText("点击解锁" + power + "倍炮");
            powerTwoTxt.changeText("点击解锁" + power + "倍炮");
            setFontClipValue(haveDiaClip, haveCount + "");
            setFontClipValue(needDiaClip, needCount + "");
            setFontClipValue(giveClip, giveCount + "");
            pro.value = haveCount / needCount;
        }


        private function clickGunImg(event:Event):void
        {
            GameTools.buttonEffect(gunImg);
            //collcet();
            playLockEffect();  //播放解锁动效
            lotteryGoEffect(); //抽奖进去动效
            event.stopPropagation();
            updatePower();


            if (isClickGun)
            {
            }
        }


        public function paoRelease():void
        {
            if (gunBoxTwo.x == -327)
            {
                release.play(0, false);
            }
        }

        private function releaseComplete():void
        {
            isGunShow = true;
            isClickP = true;

        }


        public function onChangeSkinBtn(event:Event):void
        {
//            GameTools.buttonEffect(changeSkinBtn);
            // paoCollect();
            // collcet();
            lotteryGoEffect();
            deblockGoEffect();
            event.stopPropagation();
            GameEventDispatch.instance.event(GameEvent.ClearRedPoint, GameConst.point_weapon);
            UiManager.instance.loadView("ChangeSkin", null, ShowType.SMALL_TO_BIG);
        }

        public function onCheckBtn(event:Event):void
        {
            event.stopPropagation();
            GameEventDispatch.instance.event(GameEvent.FishTypeC);
        }

        public function onSettingBtn(event:Event):void
        {
            event.stopPropagation();
            UiManager.instance.loadView("Setting", null, ShowType.SMALL_TO_BIG);
        }

        public function onReturnBtn(event:Event):void
        {
            event.stopPropagation();
            var info:QuitTipInfo = new QuitTipInfo();
            info.state = GameConst.quit_state_left_cancel_right_confirm;
            if (FightM.instance.isMatchingGame() && (MatchM.instance.isMatchSart == 1 && MatchResultBox.instance.view().visible == false))
            {
                info.content = "现在退出比赛，系统将扣除报名费的60%作为惩罚";
            } else
            {
                info.content = "是否退出房间？";
            }
            info.confirmMsg = GameEvent.ReturnConfirm;
            info.autoCloseTime = 10;
            GameEventDispatch.instance.event(GameEvent.QuitTip, info);
        }


        public function taskDaily():void
        {
            GameEventDispatch.instance.event(GameEvent.RefreshTaskDaily);
            UiManager.instance.loadView("TaskDaily", null, ShowType.SMALL_TO_BIG);
        }

        private function updateFishCount():void
        {
            //        totalIntergal.text = "积分:" + Math.floor(RoleInfoM.instance.getAwardScore()) + "";
            totalIntergal.changeText("积分:" + Math.floor(RoleInfoM.instance.getAwardScore()));
            rewardCoinCount = RoleInfoM.instance.getFcoin();
            rewardFishCount = RoleInfoM.instance.getFcount();
            goldOne.value = RoleInfoM.instance.getCoin() + "";

            if (rewardFishCount > 5)

                rewardCoinCount = RoleInfoM.instance.getFcoin();

            rewardFishCount = RoleInfoM.instance.getFcount();

            if (rewardFishCount >= RewardM.instance.baseFishCount())
            {
                if (RuleM.instance.isShowScene)
                {
                    lottery_icon_bg.visible = false
                } else
                {
                    lottery_icon_bg.visible = true;

                }
                if (RuleM.instance.isShowScene == false)
                {
                    nchou.visible = true;
                } else
                {
                    nchou.visible = false;
                }
                buchou.visible = false;

                if (!rewardFishTip)
                {
                    rewardFishTip = true
                    rewardFishTipTime = new Date().getTime();
                }

            } else
            {
                lottery_icon_bg.visible = false;
                nchou.visible = false;
                buchou.visible = true;
            }

            jichP.value = rewardFishCount / RewardM.instance.baseFishCount();
            // jichiNumOne.value = rewardCoinCount + "";
            //        jichiNumTwo.value = rewardCoinCount + "";
            //        jiNowCount.value = rewardFishCount + "";
            setFontClipValue(jichiNumTwo, rewardCoinCount + "");
            setFontClipValue(jiNowCount, rewardFishCount + "");

            var seatInfo:ProtoSeatInfo;
            var seatId:int;
            var unreachNum:int = 0;
            seatId = FightM.instance.getSeatIdByShowSeatId(1);
            seatInfo = FightM.instance.getSeatInfo(seatId);
            if (seatInfo)
            {
                if (!FightM.instance.coinShootScene())
                {
                    unreachNum = FightM.instance.getGoodsUnreachNum(seatInfo.agent, GameConst.currency_contest_score);
                } else
                {
                    unreachNum = FightM.instance.getGoodsUnreachNum(seatInfo.agent, GameConst.currency_diamond);
                }

            }

            //        diamodOne.value = (RoleInfoM.instance.getDiamond() - unreachNum) + "";
            if (!FightM.instance.coinShootScene())
            {
                setFontClipValue(diamodOne, RoleInfoM.instance.getContestScore() - unreachNum + "");
            } else
            {
                setFontClipValue(diamodOne, (RoleInfoM.instance.getDiamond() - unreachNum) + "");
            }

            //        baseFishCount.value = RewardM.instance.baseFishCount() + "";
            setFontClipValue(baseFishCount, RewardM.instance.baseFishCount() + "");

            //rewardCountTxt.value = rewardCoinCount + "";
            // rewardFishCountTxt.value = rewardFishCount + "";

            //判断炮台升级

            var nextPower:Number = GunM.instance.getNextPower(RoleInfoM.instance.getBattery());
            if (nextPower > 0)
            {
                var needCount:Number = GunM.instance.needDiamod(RoleInfoM.instance.getBattery());
                var haveCount:Number = RoleInfoM.instance.getDiamond();
                if (haveCount > needCount && !unlockBatteryTip)
                {
                    // updatePower()
                    // paoRelease()
                    // deblockComeEffect();
                    // unlockBatteryTip = true
                    //unlockBatteryTipTime = new Date().getTime();
                }
            }
            updatePower();
            GameEventDispatch.instance.event(GameEvent.UpdateFish);
            if (!FightM.instance.coinShootScene())
            {
                contestScoreUpdate();
                MatchInfoBox.instance.countPlayerRankInfo();
            }
        }


        private function playWait(den:Image):void
        {

            Tween.to(den, {scaleX: 0.8, scaleY: 0.8}, 5000, null, Handler.create(this, play, [den]));
        }

        private function play(m:Image):void
        {

            Tween.to(m, {scaleX: 1, scaleY: 1}, 5000, null, Handler.create(this, playWait, [m]));

        }

        private function playNext(m:Image):void
        {
            //Tween.to(m,{scaleX:0.8,scaleY:0.8},5000,null,Handler.create(this,play,[m]));

        }


        private function playGetGoods(i:int, goodsId:int, pos_x:Number, pos_y:Number, delay:Number, isOwn:Boolean, rnd:Array):Number
        {
            var effect:GoodsFlyEffect = GoodsFlyEffect.Create(goodsId, pos_x, pos_y, PaoPoint(i).x, PaoPoint(i).y, delay, this, isOwn, rnd);
            GoodsFlyManager.instance.addFlyEffect(effect);
            return effect.getEffectTime();
            return 0;
        }


        private function PaoPoint(i:int):Point
        {
            switch (i)
            {
                case 1:
                {
                    return new Point(box_1.x + coinOne.x, box_1.y + coinOne.y);
                    break;
                }
                case 2:
                {
                    return new Point(box_2.x + coinTwo.x, box_2.y + coinTwo.y);
                    break;
                }
                case 3:
                {

                    return new Point(box_3.x + coinThree.x, box_3.y + coinThree.y);
                    break;
                }
                case 4:
                {

                    return new Point(box_4.x + coinFour.x, box_4.y + coinFour.y);
                    break;
                }

                default:
                {
                    return null;
                    break;
                }
            }

        }


        private function initEvent():void
        {
            //closeBtn.on(Event.CLICK,this,clickClose);
            // closeBtn.visible = false;
            reward.on(Event.CLICK, this, clickreward);
            //rewardBox.on(Event.CLICK, this, clickBox);
            nchou.on(Event.CLICK, this, clickBox);
            buchou.on(Event.CLICK, this, clickBox);
        }

        private function clickBox(event:Event):void
        {
            // collcet();
            // paoCollect();
            //playLotteryEffect();  //抽奖进去动效
            WebSocketManager.instance.send(15003, null);
            GameEventDispatch.instance.event(GameEvent.RewardFish, [rewardFishCount, rewardCoinCount]);
            lotteryGoEffect();
            deblockGoEffect();//解锁进去动效
            // chu.play(0, false);
            event.stopPropagation();

        }

        private function paoCollect():void
        {
            //nchou.visible = !RuleM.instance.isShowScene;
            //buchou.visible = !RuleM.instance.isShowScene;
            if (gunBoxTwo.x == 8 && (nchou.x == -327 || nchou.x == 8))
            {
                collect.play(0, false);
            }
        }

        private function clickreward(event:Event):void
        {
            //collcet();
            GameTools.buttonEffect(reward);
            //paoCollect();
            //paoJin();
            playLotteryEffect(); //播放抽奖进出动效
            deblockGoEffect(); //解锁进去动效

            //pl
            // jin.play(0, false);
            if (isShow == false && isClickBtn == true)
            {
                isClickBtn = false;
                event.stopPropagation();
                //  jin.play(0,false);
                jin.on(Event.COMPLETE, this, showComplete);
                //Tween.to(rewardBox, {x: 980}, 400, null, Handler.create(this, showComplete));
            }

        }

        private function paoJin():void
        {
            if (nchou.x == -327 && (gunBoxTwo.x == 8 || gunBoxTwo.x == -327))
            {
                jin.play(0, false);
            } else if (nchou.x == 8 && (gunBoxTwo.x == 8 || gunBoxTwo.x == -327))
            {
                chu.play(0, false);
            }
        }

        private function showComplete():void
        {
            isShow = true;
            isClickPanel = true;

        }

        private var _shootBulletInfo:BulletInfo = new BulletInfo();
        private var _shootOnlineInfo:C2s_shootBullet = new C2s_shootBullet();

        //发射子弹
        private function shootBullet(endX:Number, endY:Number):void
        {
            if (MatchResultBox.instance.view().visible == true)
            {
                return;
            }

            if (FightM.instance.getSceneId() <= 0 ||
                    FightM.instance.getOwnUseBattery() <= 0)
            {
                return;
            }

            switch (FightM.instance.seatId)
            {
                case 1:
                {
                    paoImage = paoone;
                    break;
                }
                case 2:
                {
                    paoImage = paotwo;
                    break;
                }
                case 3:
                {
                    paoImage = paothree;
                    break;
                }
                case 4:
                {
                    paoImage = paofour;
                    break;
                }
            }

            if (GameConst.fix_left_down_pos)
            {
                paoImage = paoone;
            }
            var refAngle:Number = GameTools.CalLineAngleP4(GameTools.screenPosXMapDesignPosX(paoImage.x), GameTools.screenPosYMapDesignPosY(paoImage.y)
                    , endX, endY);

            var skin_id:Number = RoleInfoM.instance.getCurSkin()
            var lenArray:Array = ConfigManager.getConfValue("cfg_battery_skin", skin_id, "offLen") as Array;
            //var info:BulletInfo = new BulletInfo();

            _shootBulletInfo.showDelay = 0;
            var angle:Number;// = refAngle;
            var radian:Number;// = angle * Math.PI / 180;
            var deltaX:Number; // = Math.cos(radian);
            var deltaY:Number;// = Math.sin(radian);
            var length:Number;// = lenArray[0];

            var comsume:int = ConfigManager.getConfValue("cfg_battery", FightM.instance.getOwnUseBattery(), "comsume") as int;
            var catchCount:int = ConfigManager.getConfValue("cfg_battery_skin", RoleInfoM.instance.getCurSkin(), "catch_count") as int;
            var multi:int = ConfigManager.getConfValue("cfg_battery_skin", RoleInfoM.instance.getCurSkin(), "multi") as int;
            var totalCoin:int = RoleInfoM.instance.getCoin() + RoleInfoM.instance.getBindCoin();
            if (!FightM.instance.coinShootScene())
            {
                totalCoin = RoleInfoM.instance.getContestCoin();
            }
            comsume = comsume * catchCount * FightM.instance.getCoinRate() * FightM.instance.getChangeRate()
            if (FightM.instance.seatId > 0)
            {
                if (!FightManager.instance.isBulletReachMaxNum())
                {
                    var seatInfo:ProtoSeatInfo = FightM.instance.getSeatInfo(FightM.instance.seatId);
                    if (totalCoin >= comsume)
                    {
                        {
                            //var onlineInfo:C2s_shootBullet = new C2s_shootBullet();
                            var multiOffsetInfo:Array = ConfigManager.getConfValue("cfg_battery_skin", RoleInfoM.instance.getCurSkin(), "offAngle") as Array;
                            var offX:Array = ConfigManager.getConfValue("cfg_battery_skin", RoleInfoM.instance.getCurSkin(), "offX") as Array;
                            _shootOnlineInfo.bt = FightM.instance.getOwnUseBattery();
                            _shootOnlineInfo.sk = RoleInfoM.instance.getCurSkin();
                            _shootOnlineInfo.sr = 1;
                            _shootOnlineInfo.index = FightM.instance.seatId;
                            _shootOnlineInfo.tick = FightManager.instance.getCurTick();
                            _shootBulletInfo.sr = _shootOnlineInfo.sr;
                            _shootBulletInfo.sk = _shootOnlineInfo.sk;
                            _shootBulletInfo.tick = _shootOnlineInfo.tick;
                            _shootBulletInfo.fuid = 0;
                            _shootBulletInfo.index = _shootOnlineInfo.index;
                            _shootBulletInfo.count = ConfigManager.getConfValue("cfg_battery_skin", _shootBulletInfo.sk, "catch_count") as int;
                            _shootBulletInfo.showDelay = 0;
                            _shootBulletInfo.agent = FightM.instance.getOwnAgent();
                            for (var i:int = 0; i < multi; i++)
                            {
                                angle = refAngle + multiOffsetInfo[i];
                                //radian = angle * Math.PI / 180;
                                deltaX = GameTools.CalCosBySheet(angle);//Math.cos(radian);
                                deltaY = GameTools.CalSinBySheet(angle);//Math.sin(radian);
                                length = lenArray[i];
                                _shootBulletInfo.startX = GameTools.screenPosXMapDesignPosX(paoImage.x) + offX[i] + deltaX * length;
                                _shootBulletInfo.startY = GameTools.screenPosYMapDesignPosY(paoImage.y) + deltaY * length;
                                _shootBulletInfo.endX = _shootBulletInfo.startX + deltaX * length;
                                _shootBulletInfo.endY = _shootBulletInfo.startY + deltaY * length;
                                _shootOnlineInfo.startX = FightM.instance.getMirrorPosXByOwnSeat(Math.floor(_shootBulletInfo.startX));
                                _shootOnlineInfo.startY = FightM.instance.getMirrorPosYByOwnSeat(Math.floor(_shootBulletInfo.startY));
                                _shootOnlineInfo.endX = FightM.instance.getMirrorPosXByOwnSeat(Math.floor(_shootBulletInfo.endX));
                                _shootOnlineInfo.endY = FightM.instance.getMirrorPosYByOwnSeat(Math.floor(_shootBulletInfo.endY));
                                _shootBulletInfo.endX = _shootOnlineInfo.endX;
                                _shootBulletInfo.endY = _shootOnlineInfo.endY;
                                _shootBulletInfo.startX = _shootOnlineInfo.startX;
                                _shootBulletInfo.startY = _shootOnlineInfo.startY;
                                if (_shootBulletInfo.startX >= 0 && _shootBulletInfo.startX <= Laya.stage.width &&
                                        _shootBulletInfo.startY >= 0 && _shootBulletInfo.startY <= Laya.stage.height)
                                {
                                    _shootOnlineInfo.uid = FightM.instance.getBulletUid();
                                    _shootBulletInfo.uniId = _shootOnlineInfo.uid;
                                    if (0 == i)
                                    {
                                        _shootOnlineInfo.m = 1;
                                        GameEventDispatch.instance.event(GameEvent.OnlineBullet, _shootBulletInfo);

                                    } else
                                    {
                                        _shootOnlineInfo.m = 0;
                                    }
                                    GameEventDispatch.instance.event(GameEvent.NewBullet, _shootBulletInfo);
                                    var preDate:Date = new Date();
                                    WebSocketManager.instance.send(12014, _shootOnlineInfo);
                                    GameEventDispatch.instance.event(GameEvent.NoviceGuideShoot, null);
                                    var nowDate:Date = new Date();
                                    if (nowDate.getTime() - preDate.getTime() > 3)
                                    {
                                        //trace("send time = " + (nowDate.getTime() - preDate.getTime()));
                                    }
                                } else
                                {
                                }

                                _bulletMaxTip = false;
                                totalCoin -= comsume;
                                if (totalCoin < comsume)
                                {
                                    break;
                                }
                            }
                        }
                    } else
                    {
                        Laya.timer.clear(this, this.continuousShoot);
                        stopAuto();
                        if (FightM.instance.coinShootScene())
                        {
                            if (ENV.isShowBannerAndAD())
                            {
                                var canPlayAd = AdM.instance.watch_times < AdM.instance.total_times

                                if (canPlayAd)
                                {

                                    var info:QuitTipInfo = new QuitTipInfo();
                                    info.state = GameConst.quit_state_left_cancel_right_confirm;
                                    info.content = "观看广告即可领取金币奖励";
                                    info.confirmEvent = GameEvent.Shop;
                                    info.confirmEventArgs = [GameConst.shop_tab_coin];
                                    info.cancelEvent = GameEvent.ShowAd;
                                    info.cancelEventArgs = [];

                                    info.leftTxt = "观看广告"
                                    info.rightTxt = "立即购买"
                                    info.middleTxt = "观看广告"
                                    if (Browser.onIOS)
                                    {
                                        info.state = GameConst.quit_state_mid_confirm;
                                        info.confirmEvent = GameEvent.ShowAd;
                                        info.confirmEventArgs = [];
                                    }
                                    info.isHaveTime = false;
                                    GameEventDispatch.instance.event(GameEvent.QuitTip, info);
                                } else
                                {
                                    GameEventDispatch.instance.event(GameEvent.MsgTip, 3);
                                    GameEventDispatch.instance.event(GameEvent.Shop, GameConst.shop_tab_coin);
                                }

                            } else
                            {
                                GameEventDispatch.instance.event(GameEvent.MsgTip, 3);
                                GameEventDispatch.instance.event(GameEvent.Shop, GameConst.shop_tab_coin);
                            }
                        } else
                        {

                        }
                    }


                } else
                {
                    if (!_bulletMaxTip)
                    {
                        GameEventDispatch.instance.event(GameEvent.MsgTip, 19);
                        _bulletMaxTip = true;
                    }
                }
            }
        }

        private var continuousShootLeftTime:Number = 0;

        private function shootTick():void
        {
            continuousShootLeftTime -= Laya.timer.delta / 1000;
        }

        private function continuousShoot():void
        {
            if (continuousShootLeftTime <= 0)
            {
                shootBullet(desX, desY);
                continuousShootLeftTime = FightM.instance.getShootInterval();
            }
        }

        private var mouseMoveValid:Boolean = false;

        private function mouseDown(event:Event):void
        {

            desX = GameTools.screenPosXMapDesignPosX(event.stageX); //event.stageX;
            desY = GameTools.screenPosYMapDesignPosY(event.stageY);//event.stageY;
            mouseMoveValid = true;
            if (isShow == true && isClickPanel == true)
            {
                return;
            }

            if (isGunShow == true && isClickP == true)
            {
                return;
            }
            if (continuousShootLeftTime > 0)
            {
                return
            }


            yulei.visible = false;
            //if(FireState==GameConst.noAutoFire)
            {
                if (!FightManager.instance.touchHandle(event.stageX, event.stageY))
                {
                    continuousShootLeftTime = FightM.instance.getShootInterval();
                    Laya.timer.frameLoop(1, this, this.continuousShoot);
                    shootBullet(desX, desY);
                }
            }


        }

        private function mouseMove(event:Event):void
        {
            if (mouseMoveValid)
            {
                desX = GameTools.screenPosXMapDesignPosX(event.stageX);//event.stageX;
                desY = GameTools.screenPosYMapDesignPosY(event.stageY);//event.stageY;
            }
        }

        private function mouseOut(event:Event):void
        {
            mouseMoveValid = false;
            if (FireState == GameConst.noAutoFire)
            {
                Laya.timer.clear(this, this.continuousShoot);
            }
        }

        private function mouseUp(event:Event):void
        {


            mouseMoveValid = false;
            if (FireState == GameConst.noAutoFire)
            {
                Laya.timer.clear(this, this.continuousShoot);
            }

        }

        private function playPaoStand(pao:Animation, seatId:int):void
        {


            if (pao.visible && seatCSkinList[seatId - 1] > 0)
            {
                var spineAni:*;
                var paoMount:Sprite = pao.getChildAt(1) as Sprite;
                spineAni = paoMount.getChildAt(0);// as SpineTemplet;
                if (spineAni && !spineAni.isPlaying())
                {
                    spineAni.play("stand", true);
                }
            }
        }

        private function paoAnimationCheck():void
        {
            playPaoStand(paoone, FightM.instance.getSeatIdByShowSeatId(1));
            playPaoStand(paotwo, FightM.instance.getSeatIdByShowSeatId(2));
            playPaoStand(paothree, FightM.instance.getSeatIdByShowSeatId(3));
            playPaoStand(paofour, FightM.instance.getSeatIdByShowSeatId(4));
        }


        private function clickPanel(event:Event):void
        {
            //抽奖，自动弹出停留10秒
            if (!rewardFishTip || ((new Date().getTime() - rewardFishTipTime) / 1000) > 10)
            {
                // collcet();
                //lotteryGoEffect();
                //lotteryComeEffect(); //抽奖进去动效
            }

            //炮台升级，自动弹出停留10秒
            if (!unlockBatteryTip || ((new Date().getTime() - unlockBatteryTipTime) / 1000) > 10)
            {
                deblockGoEffect();
            }

            if (isShow == true && isClickPanel == true)
            {
                isClickPanel = false;
                return;
            }

            if (isGunShow == true && isClickP == true)
            {
                return;
            }
        }

        private function setFontClipValue(font:FontClip, str:String):void
        {
            if (font.value != str)
            {
                font.value = str;
            }
        }

        private function updateGold(countOne:Number, countTwo:Number, countThree:Number, countFour:Number):void
        {
            setFontClipValue(goldOne, countOne + "");
            setFontClipValue(goldTwo, countTwo + "");
            setFontClipValue(goldThree, countThree + "");
            setFontClipValue(goldFour, countFour + "");
        }

        private function satrt():void
        {
            isClick = true;

        }

        private function playEffenct(seatId:int):void
        {
            var spineAni:*;
            var paoMount:Sprite = paoImage.getChildAt(1) as Sprite;
            spineAni = paoMount.getChildAt(0);// as SpineTemplet;
            if (spineAni)
            {

                spineAni.play("attack", false);
            }

        }

        private function setPaoRotation(data:*):void
        {
            var violentAni:Animation;
            var violentAniBg:Animation;
            switch (data.seat_id)
            {
                case 1:
                {
                    paoImage = paoone;
                    violentAni = violentOne;
                    violentAniBg = violentOneBg;
                    break;
                }
                case 2:
                {
                    paoImage = paotwo;
                    violentAni = violentTwo;
                    violentAniBg = violentTwoBg;
                    break;
                }
                case 3:
                {
                    paoImage = paothree;
                    violentAni = violentThree;
                    violentAniBg = violentThreeBg;
                    break;
                }
                case 4:
                {
                    paoImage = paofour;
                    violentAni = violentFour;
                    violentAniBg = violentFourBg;
                    break;
                }
            }
            var paoAni:Sprite = paoImage.getChildAt(1) as Sprite;
            paoAni.rotation = data.angle;
            violentAni.rotation = data.angle;
            playEffenct(data.seat_id);
        }

        private function onlineBullet(data:*):void
        {
            var info:BulletInfo = data as BulletInfo;

            var showSeatId:int = FightM.instance.getShowSeatId(info.index);

            var violentAni:Animation;
            var violentAniBg:Animation;
            switch (showSeatId)
            {
                case 1:
                {
                    paoImage = paoone;
                    violentAni = violentOne;
                    violentAniBg = violentOneBg;
                    break;
                }
                case 2:
                {
                    paoImage = paotwo;
                    violentAni = violentTwo;
                    violentAniBg = violentTwoBg;
                    break;
                }
                case 3:
                {
                    paoImage = paothree;
                    violentAni = violentThree;
                    violentAniBg = violentThreeBg;
                    break;
                }
                case 4:
                {
                    paoImage = paofour;
                    violentAni = violentFour;
                    violentAniBg = violentFourBg;
                    break;
                }
            }

            playEffenct(info.index);
            var startX:Number = GameTools.designPosXMapScreenPosX(FightM.instance.getMirrorPosXByOwnSeat(info.startX));
            var endX:Number = GameTools.designPosXMapScreenPosX(FightM.instance.getMirrorPosXByOwnSeat(info.endX));
            var startY:Number = GameTools.designPosYMapScreenPosY(FightM.instance.getMirrorPosYByOwnSeat(info.startY));
            var endY:Number = GameTools.designPosYMapScreenPosY(FightM.instance.getMirrorPosYByOwnSeat(info.endY));


            var angle:Number = GameTools.CalLineAngleP4(startX, startY, endX, endY);

            var paoAni:Sprite = paoImage.getChildAt(1) as Sprite;
            paoAni.rotation = angle;
            violentAni.rotation = angle;
            if (info.index == FightM.instance.seatId)
            {
                var soundPath:String = ConfigManager.getConfValue("cfg_global", 1, "shoot_sound") as String;

                if (WxC.isInMiniGame())
                {
                    soundPath = "wxlocal/shoot.mp3";
                    //SoundManager.stopEarListSound(soundPath);
                }
                GameSoundManager.playSound(soundPath);
            }
        }

        public function receiveHandshake(data:*):void
        {
            WebSocketManager.instance.send(12001, null);
        }

        private function updatePlayerStatus(seatInfo:ProtoSeatInfo, pao:Animation,
                                            tai:Image, gold:FontClip, rotation:Number, wait:Image,
                                            coin:Image, kuang:Image, paoLabel:FontClip, role:Box,
                                            name:Label,
                                            seatId:int, vipFont:FontClip, violentAni:Animation, roleImg:Image):void
        {
            //            role.offAll(Event.CLICK)
            //            role.offAll(Event.MOUSE_DOWN)
            if (seatInfo)
            {
                var paoMount:Sprite = pao.getChildAt(1) as Sprite;
                if (!pao.visible || !paoMount.getChildAt(0))
                {
                    pao.visible = true;
                    tai.visible = true;
                    gold.visible = true;
                    coin.visible = true;
                    kuang.visible = true;
                    paoLabel.visible = true;
                    role.visible = true;
                    name.visible = true;
                    //p.visible = true;
                    //                pao.rotation = rotation;
                    paoMount.rotation = rotation;
                    violentAni.rotation = rotation;

                    pao.rotation = 0;
                }
                if (seatInfo.avatar != roleImg.skin)
                {
                    if (seatInfo.avatar == null || seatInfo.avatar.length <= 0)
                    {
                        roleImg.skin = "ui/common/nan.png";
                    } else
                    {
                        roleImg.skin = seatInfo.avatar;
                    }
                }

                if (wait)
                {
                    wait.visible = false;
                }
                if (seatCSkinList[seatId - 1] != seatInfo.cskin)
                {
                    seatCSkinList[seatId - 1] = seatInfo.cskin;
                    var spineAni:*;
                    var aniName:String = ConfigManager.getConfValue("cfg_battery_skin", seatCSkinList[seatId - 1], "ani") as String;
                    var aniPngName:String = ConfigManager.getConfValue("cfg_battery_skin", seatCSkinList[seatId - 1], "batteryImg1") as String;
                    spineAni = paoMount.getChildAt(0);// as SpineTemplet;

                    if (spineAni)
                    {
                        spineAni.removeSelf();
                    }

                    if (aniPngName && aniPngName.length > 0)
                    {
                        spineAni = new BatteryImgAction();
                        spineAni.loadImage(aniPngName);
                    } else
                    {
                        spineAni = new SpineTemplet(aniName);
                    }
                    paoMount.addChild(spineAni);
                    spineAni.play("born", false);

                }

                setFontClipValue(paoLabel, ConfigManager.getConfValue("cfg_battery", seatInfo.battery, "comsume") as String);
                setFontClipValue(vipFont, seatInfo.level + "");
//                name.changeText(LoginInfoM.instance.filterName(MatchM.instance.matchNameRule(seatInfo.name)));
                name.changeText(seatInfo.name);
                //                if (FightM.instance.seatId != seatId)
                //                {
                //                    role.on(Event.CLICK, this, function (event)
                //                    {
                //                        if (seatInfo['long_uid'])
                //                        {
                //                            FriendM.instance.searchFriend(seatInfo['long_uid'])
                //                        } else
                //                        {
                //                            var data = {
                //                                code: "success",
                //                                data: {
                //                                    nickname: seatInfo.name,
                //                                    avatar: seatInfo.avatar,
                //                                    level: seatInfo.level,
                //                                    stauts: 0
                //                                }
                //                            };
                //                            FriendM.instance.searchFriend(null, data, true)
                //                        }
                //                    })
                //                }
                //                role.on(Event.MOUSE_DOWN, this, downSkip)
            } else
            {
                if (pao.visible)
                {
                    pao.visible = false;
                    tai.visible = false;
                    gold.visible = false;
                    coin.visible = false;
                    kuang.visible = false;
                    paoLabel.visible = false;
                    role.visible = false;
                    name.visible = false;
                    //  p.visible = false;
                }
                if (roleImg.skin != "ui/common/nan.png")
                {
                    roleImg.skin = "ui/common/nan.png";
                }
                if (wait)
                {
                    wait.visible = true;
                    Tween.clearAll(wait);
                    playWait(wait);
                }
                seatCSkinList[seatId - 1] = 0;
            }
        }


        private function fightPlayerUpdate():void
        {
            var seatInfo:ProtoSeatInfo;
            var seatId:int;
            seatId = FightM.instance.getSeatIdByShowSeatId(1);
            seatInfo = FightM.instance.getSeatInfo(seatId);
            updatePlayerStatus(seatInfo, paoone, taione, goldOne, 270, null, coinOne, kuangone, powerOne,
                    roleOne, nameOne, seatId, fontVipOne, violentOne, playimgOne);
            if (WxC.isInMiniGame() && WxC.author == 1)
            {
                nameOne.text = LoginInfoM.instance.filterName(RoleInfoM.instance.getName());
                if (playimgOne.skin != RoleInfoM.instance.getAvatar())
                {
                    playimgOne.skin = RoleInfoM.instance.getAvatar();
                }
            }
            seatId = FightM.instance.getSeatIdByShowSeatId(2);
            seatInfo = FightM.instance.getSeatInfo(seatId);
            updatePlayerStatus(seatInfo, paotwo, taitwo, goldTwo, 270, dentwo, coinTwo, kuangtwo, powerTwo, roleTwo,
                    nameTwo, seatId, fontVipTwo, violentTwo, playimgTwo);

            diamondBoxTwo.visible = !FightM.instance.coinShootScene() && null != seatInfo;
            coinTwo.visible = FightM.instance.coinShootScene() && null != seatInfo;
            ccoinTwo.visible = !FightM.instance.coinShootScene() && null != seatInfo;

            seatId = FightM.instance.getSeatIdByShowSeatId(3);
            seatInfo = FightM.instance.getSeatInfo(seatId);
            updatePlayerStatus(seatInfo, paothree, taithree, goldThree, 90, denthree, coinThree, kuangthree, powerThree, roleThree,
                    nameThree, seatId, fontVipThree, violentThree, playimgThree);
            diamondBoxThree.visible = !FightM.instance.coinShootScene() && null != seatInfo;
            coinThree.visible = FightM.instance.coinShootScene() && null != seatInfo;
            ccoinThree.visible = !FightM.instance.coinShootScene() && null != seatInfo;

            seatId = FightM.instance.getSeatIdByShowSeatId(4);
            seatInfo = FightM.instance.getSeatInfo(seatId);
            updatePlayerStatus(seatInfo, paofour, taifour, goldFour, 90, denfour, coinFour, kuangfour, powerFour, roleFour,
                    nameFour, seatId, fontVipFour, violentFour, playimgFour);
            diamondBoxFour.visible = !FightM.instance.coinShootScene() && null != seatInfo;
            coinFour.visible = FightM.instance.coinShootScene() && null != seatInfo;
            ccoinFour.visible = !FightM.instance.coinShootScene() && null != seatInfo;
            fightCoinUpdate(null);
        }

        private function contestScoreUpdate():void
        {
            var seatInfo:ProtoSeatInfo;

            seatInfo = FightM.instance.getSeatInfo(FightM.instance.getSeatIdByShowSeatId(2));
            if (seatInfo)
            {
                setFontClipValue(diamodTwo, String(seatInfo.contestScore));
            }
            seatInfo = FightM.instance.getSeatInfo(FightM.instance.getSeatIdByShowSeatId(3));
            if (seatInfo)
            {
                setFontClipValue(diamodThree, String(seatInfo.contestScore));
            }
            seatInfo = FightM.instance.getSeatInfo(FightM.instance.getSeatIdByShowSeatId(4));
            if (seatInfo)
            {
                setFontClipValue(diamodFour, String(seatInfo.contestScore));
            }
        }


        private function goldUpdate(gold:FontClip, diamond:FontClip, value:Number):void
        {
            var len:Number = (value + "").length;
            //        gold.value = value + "";
            setFontClipValue(gold, value + "");
            if (len > 10)
            {
                var scale:Number = 0.6 / 2;
                gold.scale(scale, scale);
                if (diamond)
                {
                    diamond.scale(scale, scale);
                }

            } else
            {
                var scale:Number = 0.8 / 2;
                gold.scale(scale, scale);
                if (diamond)
                {
                    diamond.scale(scale, scale);
                }
            }
        }

        private function fightCoinUpdate(data:*):void
        {
            var seatInfo:ProtoSeatInfo;
            var coin:int = 0;
            seatInfo = FightM.instance.getSeatInfo(FightM.instance.getSeatIdByShowSeatId(1));
            if (seatInfo)
            {

                coin = seatInfo.coin - RuleM.instance.coinCount + seatInfo.skipCoin;
                if (!FightM.instance.coinShootScene())
                {
                    coin = seatInfo.contestCoin;
                }
                if (coin < 0)
                {
                    coin = 0;
                }

                goldUpdate(goldOne, diamodOne, coin);
            }
            seatInfo = FightM.instance.getSeatInfo(FightM.instance.getSeatIdByShowSeatId(2));
            if (seatInfo)
            {
                coin = seatInfo.coin;
                if (!FightM.instance.coinShootScene())
                {
                    coin = seatInfo.contestCoin;
                }
                if (coin < 0)
                {
                    coin = 0;
                }
                goldUpdate(goldTwo, null, coin);
            }
            seatInfo = FightM.instance.getSeatInfo(FightM.instance.getSeatIdByShowSeatId(3));
            if (seatInfo)
            {
                coin = seatInfo.coin;
                if (!FightM.instance.coinShootScene())
                {
                    coin = seatInfo.contestCoin;
                }
                if (coin < 0)
                {
                    coin = 0;
                }
                goldUpdate(goldThree, null, coin);
            }
            seatInfo = FightM.instance.getSeatInfo(FightM.instance.getSeatIdByShowSeatId(4));
            if (seatInfo)
            {
                coin = seatInfo.coin;
                if (!FightM.instance.coinShootScene())
                {
                    coin = seatInfo.contestCoin;
                }
                if (coin < 0)
                {
                    coin = 0;
                }
                goldUpdate(goldFour, null, coin);
            }
        }

        private function showGetGoodsEffect(data:*):void
        {
            data.useTime = playGetGoods(data.seat_id, data.goodId, data.pos_x, data.pos_y, data.delay, data.isOwn, data.rnd);
        }

        public function exitFight(data:*):void
        {
            GoodsFlyManager.instance.removeInvalidEffect(true);
            UiManager.instance.closePanel("Fish", false);
        }

        private function batteryBuyRet(data:*):void
        {
            updatePower();
            var award = data.award
            coinWave(award[1], 90, -164, -110)

            initDoubleRate()
        }

        private function finishTask(task_id:int)
        {
            var a:C2s_19000 = new C2s_19000();
            a.task_id = task_id;
            a.is_daily = true;

            WebSocketManager.instance.send(19000, a);

        }

        private function updateItemReward(cell:*, index:int):void
        {
            var ele_reward_img = cell.getChildByName("reward_type");
            var ele_reward_text = cell.getChildByName("reward_text");

            var data = cell.dataSource

            ele_reward_img.skin = cfg_goods.instance(data.reward_item_id + "").icon;
            ele_reward_text.changeText('x ' + data.reward_item_num);
            //        ele_reward_text.text = 'x ' + data.reward_item_num;
        }

        private var task_percent:Object = {}
        private var unfinish_arr:Array = [];

        private function refreshTaskTotal()
        {
            task_percent = {}
            unfinish_arr = []
            refreshTask()
        }


        //提示解锁炮弹
        private function playMonthCardShine()
        {

            //25_wuqi  25_meire  25_lingquguangxiao
            //dingbiankuang icon_cj icon_js zuobiankuang
            if (!month_icon_bg)
            {
                month_icon_bg = new SpineTemplet("guang1");
                month_icon_bg.play("icon_cj", true);
                month_icon_bg.setPos(17, 27);
                month_icon_bg.visible = false;
                month_icon_bg.setPivot(0, 0);
            }

            if (!lottery_icon_bg)
            {
                lottery_icon_bg = new SpineTemplet("guang1");
                lottery_icon_bg.play("icon_js", true);
                lottery_icon_bg.setPos(18, 18);
                lottery_icon_bg.visible = false;
                lottery_icon_bg.setPivot(0, 0);
            }

            if (!battery_icon_bg)
            {
                battery_icon_bg = new SpineTemplet("guang1");
                battery_icon_bg.play("icon_js", true);
                battery_icon_bg.setPos(17, 17);
                battery_icon_bg.visible = false;
                battery_icon_bg.setPivot(0, 0);
            }


            reward.addChild(lottery_icon_bg);
            gunImg.addChild(battery_icon_bg);
//            month.addChild(month_icon_bg);
        }


        //抽奖长边框
        private function playLotteryShine()
        {
            if (!_lottery_spine)
            {
                _lottery_spine = new SpineTemplet("guang1");
                _lottery_spine.play("zuobiankuang", true);
                _lottery_spine.setPos(79, 24);
                _lottery_spine.visible = true;
                _lottery_spine.setPivot(0, 0);
                _lottery_spine.setScale(0.9, 0.75);
            }


            nchou.addChild(_lottery_spine);
        }

        //提示解锁炮弹
        private function playBatteryShine()
        {
            if (!_battery_spine)
            {
                _battery_spine = new SpineTemplet("guang1");
                _battery_spine.play("zuobiankuang", true);
                _battery_spine.setPos(80, 26);
                _battery_spine.visible = true;
                _battery_spine.setPivot(0, 0);
                _battery_spine.setScale(0.9, 0.74);
            }
            gunBoxOne.addChild(_battery_spine);
        }

        //提示每日任务
        private function playTaskShine()
        {
            if (!_task_spine)
            {
                _task_spine = new SpineTemplet("guang1");
                _task_spine.play("25_meire", true);
                _task_spine.setPos(68, 25);
                _task_spine.visible = false;
                _task_spine.setPivot(0, 0);
                _task_spine.setScale(0.91, 0.85);
            }
            box_task.addChild(_task_spine);
        }

        private function refreshTask()
        {
            var task_ids = RoleInfoM.instance.getTaskDailyIds();

            var confs:Array = ConfigManager.filter("cfg_task", function (item:cfg_task)
            {
                return task_ids.indexOf(item.id) > -1
            });
            var taskData = RoleInfoM.instance.getTaskDaily()
            box_task.offAll(Event.CLICK)

            var finish_arr:Array = [];


            for (var i = 0; i < confs.length; i++)
            {
                var task_id:int = confs[i].id;
                var percent = TaskC.instance.taskPercent(taskData, confs[i])
                var old_percent = 0

                if (Object.keys(task_percent).indexOf(task_id + "") >= 0)
                {
                    old_percent = task_percent[task_id + ""];
                }
                task_percent[task_id + ""] = percent


                var is_accept = taskData.rec_ids.indexOf(confs[i].id) > -1;
                var is_finish = percent == 1;


                var index:int = unfinish_arr.indexOf(task_id);

                if (unfinish_arr.indexOf(task_id) < -1)
                {
                    unfinish_arr.push(task_id)
                }

                if (is_accept)
                {
                    if (index >= 0)
                    {
                        unfinish_arr.splice(index, 1)
                    }
                } else if (is_finish)
                {
                    if (index >= 0)
                    {
                        unfinish_arr.splice(index, 1)
                    }
                    finish_arr.push(task_id)
                } else
                {
                    if (index < 0)
                    {
                        unfinish_arr.push(task_id)
                    } else
                    {
                        if (percent > old_percent)
                        {
                            unfinish_arr.splice(index, 1)
                            unfinish_arr.unshift(task_id)
                        }
                    }


                }
            }
            if (finish_arr.length > 0)
            {
                var task_id = finish_arr[0];
                var taskConfig = cfg_task.instance(task_id)

                var rewards = []
                for (var i = 0; i < taskConfig.reward_item_ids.length; i++)
                {
                    if (ActivityM.instance.activityIsActive(GameConst.activity_bonus))
                    {
                        rewards.push({
                            reward_item_id: taskConfig.activity_item_ids[i],
                            reward_item_num: taskConfig.activity_item_nums[i]
                        })
                    } else
                    {
                        rewards.push({
                            reward_item_id: taskConfig.reward_item_ids[i],
                            reward_item_num: taskConfig.reward_item_nums[i]
                        })
                    }
                }

                list_reward.array = rewards
                if (rewards.length == 1)
                {
                    list_reward.pivotX = -52;
                    click_a.pivotX = -35
                } else
                {
                    click_a.pivotX = 0
                    list_reward.pivotX = 0
                }

                list_reward.visible = true;
                click_a.visible = true;
                p_task.visible = false;
                p_txt.visible = false;
                //            shine_bg.visible = true;
                _task_spine.visible = true;
                task_icon.visible = false;
                task_icon_bg.visible = false;
                task_icon.skin = taskConfig.img_url
                //task_name.text = taskConfig.task_name
                task_name.changeText(taskConfig.task_name);
                task_name.visible = false;

                if (!RuleM.instance.isShowScene)
                {
                    box_task.visible = true;
                }

                box_task.on(Event.CLICK, this, function (event:Event)
                {
                    event.stopPropagation();
                    finishTask(task_id)
                });
            } else if (unfinish_arr.length > 0)
            {
                var task_id = unfinish_arr[0]
                var taskConfig = cfg_task.instance(task_id)
                var percent = TaskC.instance.taskPercent(taskData, taskConfig)
                p_task.visible = true;
                p_txt.visible = true;
                //            p_txt.value = TaskC.instance.getCurTaskValue(taskData, taskConfig) + "/" + taskConfig.task_value_n
                setFontClipValue(p_txt, TaskC.instance.getCurTaskValue(taskData, taskConfig) + "/" + taskConfig.task_value_n);
                p_task.value = percent;
                list_reward.visible = false;
                click_a.visible = false;
                //task_name.text = taskConfig.task_name
                task_name.changeText(taskConfig.task_name);
                task_name.visible = true;
                _task_spine.visible = false;
                task_icon.visible = true;
                task_icon.skin = taskConfig.img_url;
                task_icon_bg.visible = true;

                if (!RuleM.instance.isShowScene)
                {
                    box_task.visible = true;
                }
                // shine.clear()
                box_task.on(Event.CLICK, this, function (event:Event)
                {
                    event.stopPropagation();
                    taskDaily()
                });

            } else
            {
                box_task.visible = false;
            }
            if (!FightM.instance.coinShootScene())
            {
                box_task.visible = false;
            }
            //		box_task.visible = false
        }

        private function initMonthCardIcon():void
        {
            month_icon.offAll(Event.CLICK);
            month_icon_bg.visible = false;
            if (ENV.isShowDied())
            {
                return;
            }
            if (WxC.isHideShop())
            {
                if (RoleInfoM.instance.haveValidMonthCard())
                {
                    month_icon.skin = "ui/common_ex/icon_yk1.png"
                    month_icon.visible = true
                    var cards:Object = RoleInfoM.instance.getMonthCard();
                    for (var id in cards)
                    {
                        if (cards[id].can_accept)
                        {
                            month_icon.on(Event.CLICK, this, function (event:Event)
                            {
                                event.stopPropagation();
                                var a:Object = {};
                                a.id = id;
                                WebSocketManager.instance.send(14006, a);
                            });
                            month_icon_bg.visible = true;
                            return;
                        }
                    }
                    month_icon_bg.visible = false;
                } else
                {
                    month_icon.visible = false
                    month_icon_bg.visible = false;
                }
            } else
            {
                if (ShopC.instance.isShowFirstIcon())
                {
                    month_icon.skin = "ui/common_ex/icon_sc.png"
                    if (RoleInfoM.instance.getChargeTimes() > 0)
                    {
                        month_icon_bg.visible = true;
                    }
                    month_icon.on(Event.CLICK, this, function (event:Event)
                    {
                        event.stopPropagation();
                        UiManager.instance.loadView("FirstCharge", null, ShowType.SMALL_TO_BIG);
                    })
                } else
                {
                    if (RoleInfoM.instance.haveValidMonthCard())
                    {
                        month_icon.skin = "ui/common_ex/icon_yk1.png"

                        var cards:Object = RoleInfoM.instance.getMonthCard();
                        for (var id in cards)
                        {
                            if (cards[id].can_accept)
                            {
                                month_icon.on(Event.CLICK, this, function (event:Event)
                                {
                                    event.stopPropagation();
                                    var a:Object = {};
                                    a.id = id;
                                    WebSocketManager.instance.send(14006, a);
                                });
                                month_icon_bg.visible = true;
                                return;
                            }
                        }
                        month_icon.on(Event.CLICK, this, function (event:Event)
                        {
                            event.stopPropagation();
                            GameEventDispatch.instance.event(GameEvent.Shop, "tab_package");
                        })


                        month_icon_bg.visible = false;
                    } else
                    {
                        month_icon.skin = "ui/common_ex/icon_yk.png"
                        month_icon_bg.visible = false;
                        month_icon.on(Event.CLICK, this, function (event:Event)
                        {
                            event.stopPropagation();
                            UiManager.instance.loadView("MonthCard", {id: GameConst.month_card_id}, ShowType.SMALL_TO_BIG);
                        })
                    }

                }

            }
        }

        private function showRedPoint():void
        {
            var red_points:int = RoleInfoM.instance.getRedPoints();
            if (GameConst.point_weapon & red_points)
            {
                RedpointC.instance.removeRedPoint(changeSkinBtn)
                RedpointC.instance.addRedPointToIcon(changeSkinBtn, 0.75, 6)
            } else
            {
                RedpointC.instance.removeRedPoint(changeSkinBtn)

            }
//            BackBox.instance.showRedPoint()
        }


        private function initGuide():void
        {
            guide = AnimalManger.instance.load("guide");
            //        guide.x = 300;
            //        guide.y = 300;
            guide.pivotX = ConfigManager.getConfValue("cfg_anicollision", "guide", "pivotX") as Number;
            guide.pivotY = ConfigManager.getConfValue("cfg_anicollision", "guide", "pivotX") as Number;
            this.addChild(guide);
            guide.play(0, true);
            guide.visible = false;
            guide.name = "guide"

        }

        private function showGuide(config:*)
        {
            var target = null

            var x:Number;
            var y:Number;

            switch (config.task_type)
            {
                case 2:
                    target = reward;
                    guide.x = 33;
                    guide.y = 33;
                    break;
                case 4:
                    guide.x = 44;
                    guide.y = 44;
                    switch (config.task_value_f)
                    {
                        case 21:
                            // target = roateMaskOne;
                            target = skill_1;
                            break;
                        case 22:
                            target = skill_2;
                            //target = roateMaskTwo;
                            break;
                        case 23:
                            target = skill_3;
                            //target = roateMaskThree;
                            break;
                        case 24:
                            target = skill_4;
                            // target = roateMaskFour;
                            break;
                        case 51:
                            target = skill_6;
                            break;
                    }
                    break;
                case 5:
                    guide.x = 33;
                    guide.y = 33;
                    target = gunImg;
                    break;

            }
            if (target)
            {

                guide.visible = true

                target.addChild(guide)

                Laya.timer.once(5000, this, function ()
                {
                    //                guide.visible = false
                    target.removeChildByName("guide")
                });
            }
        }

        private function bossComingInit(fish_id:Number):void
        {

            var comeSound:String = ConfigManager.getConfValue("cfg_fish", fish_id, "comeSound") as String;
            if (comeSound.length > 0)
            {
                GameSoundManager.playSound(comeSound);
            }
            var scene_id:Number = FightM.instance.sceneId;

            boss_img.skin = "ui/fish/boss_" + scene_id + ".png";
            boss_txt.skin = "ui/fish/welcome_boss_" + scene_id + ".png";

            if (scene_id == 3)
            {
                boss_coming.skin = "ui/fish/boss_txt_carry.png"
            } else
            {
                boss_coming.skin = "ui/fish/boss_txt_coming.png"
            }

            boss_img.visible = true;
            boss_txt.visible = true;
            boss_txt_bg.visible = true;
            boss_coming.visible = true;
            boss_mask_top.visible = true;
            boss_mask_bottom.visible = true;
            boss_warning.visible = true;
            boss_warning2.visible = true;

            var that = this;

            var t1:Tween = Tween.to(boss_warning, {x: -2000}, 5000, null)
            var t2:Tween = Tween.to(boss_warning2, {x: -2000}, 5000, null)

            Tween.to(boss_img, {centerX: -200}, 250, Ease.linearIn, Handler.create(that, function ()
            {
                Laya.timer.once(800, that, function ()
                {
                    Tween.to(boss_img, {scaleX: 1.2, scaleY: 1.2}, 100, Ease.linearIn, Handler.create(that, function ()
                    {
                        Tween.to(boss_img, {
                            scaleX: 0,
                            scaleY: 0,
                            alpha: 0
                        }, 300, Ease.linearIn, Handler.create(that, function ()
                        {
                            boss_img.visible = false;
                            boss_img.scale(1, 1);
                            boss_img.centerX = -1200;
                            boss_img.alpha = 1;
                        }))
                    }))
                })
            }));

            Tween.to(boss_txt_bg, {centerX: 200}, 300, Ease.linearIn, Handler.create(that, function ()
            {
                Laya.timer.once(800, that, function ()
                {
                    Tween.to(boss_txt_bg, {scaleX: 1.2, scaleY: 1.2}, 100, Ease.linearIn, Handler.create(that, function ()
                    {
                        Tween.to(boss_txt_bg, {
                            scaleX: 0,
                            scaleY: 0,
                            alpha: 0
                        }, 300, Ease.linearIn, Handler.create(that, function ()
                        {
                            boss_txt_bg.visible = false;
                            boss_txt_bg.scale(1, 1);
                            boss_txt_bg.centerX = -1000;
                            boss_txt_bg.alpha = 1;
                        }))
                    }))
                })
            }));
            Tween.to(boss_coming, {centerX: 350}, 350, Ease.linearIn, Handler.create(that, function ()
            {
                Laya.timer.once(800, that, function ()
                {
                    Tween.to(boss_coming, {
                        scaleX: 1.2,
                        scaleY: 1.2
                    }, 100, Ease.linearIn, Handler.create(that, function ()
                    {
                        Tween.to(boss_coming, {
                            scaleX: 0,
                            scaleY: 0,
                            alpha: 0
                        }, 300, Ease.linearIn, Handler.create(that, function ()
                        {
                            boss_coming.visible = false;
                            boss_coming.scale(1, 1);
                            boss_coming.centerX = 1000;
                            boss_coming.alpha = 1;

                            Tween.clear(t1);
                            Tween.clear(t2);

                            boss_mask_top.visible = false;
                            boss_mask_bottom.visible = false;
                            boss_warning.visible = false
                            boss_warning2.visible = false
                            boss_warning.x = -334;
                            boss_warning2.x = -334;
                        }))
                    }))
                })
            }));


        }

        private function initWarningList():void
        {
            boss_warning.renderHandler = new Handler(this, updateWarning);
            boss_warning.array = [{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}]
        }

        private function updateWarning(cell:Box, index:int):void
        {
            var img:Image = cell.getChildByName("warning") as Image;
            img.skin = "ui/fish/boss_warn.png"
        }

        private function playBossComing(fish_id:Number):void
        {
            bossComingInit(fish_id)
        }

        private function fishTide():void
        {
            var that = this;
            boss_mask_top.visible = true;
            boss_mask_bottom.visible = true;
            boss_warning.visible = true;
            boss_warning2.visible = true;
            fishTideImg.visible = true;

            var t1:Tween = Tween.to(boss_warning, {x: -2000}, 5000, null)
            var t2:Tween = Tween.to(boss_warning2, {x: -2000}, 5000, null)

            Tween.to(fishTideImg, {centerX: -0}, 250, Ease.linearIn, Handler.create(that, function ()
            {
                Laya.timer.once(1600, that, function ()
                {
                    fishTideImg.visible = false;
                    fishTideImg.centerX = -1200;

                    Tween.clear(t1);
                    Tween.clear(t2);
                    boss_mask_top.visible = false;
                    boss_mask_bottom.visible = false;
                    boss_warning.visible = false
                    boss_warning2.visible = false
                    boss_warning.x = -334;
                    boss_warning2.x = -334;
                })
            }))

        }


        private function playGetIn():void
        {
            var scene_id:Number = FightM.instance.sceneId;
            var that = this;

            var scene_cfg:cfg_scene = cfg_scene.instance(scene_id)

            if (scene_cfg.show_ani)
            {
                welcome_txt.skin = "ui/fish/welcome_" + scene_id + ".png"
                welcome_boss.skin = "ui/fish/welcome_boss_" + scene_id + ".png"
                welcome_bg.visible = true
                welcome_boss.visible = true
                welcome_txt.visible = true;

                Tween.to(welcome_bg, {centerX: -20}, 250, Ease.linearIn, Handler.create(that, function ()
                {
                    Laya.timer.once(800, that, function ()
                    {
                        welcome_bg.visible = false;
                        welcome_bg.centerX = -1200;
                    })
                }))

                Tween.to(welcome_txt, {centerX: -50}, 250, Ease.backInOut, Handler.create(that, function ()
                {
                    Laya.timer.once(800, that, function ()
                    {
                        welcome_txt.visible = false;
                        welcome_txt.centerX = -900;
                    })
                }))

                Tween.to(welcome_boss, {centerX: 250}, 250, Ease.backInOut, Handler.create(that, function ()
                {
                    Laya.timer.once(800, that, function ()
                    {
                        welcome_boss.visible = false;
                        welcome_boss.centerX = 1200;
                    })
                }))
            } else
            {

            }
        }

        private function startSign():void
        {
            if (RegiM.instance.isGet)
            {
                UiManager.instance.loadView("Register", null, ShowType.SMALL_TO_BIG);
            }
        }

        private function shootError(data:*):void
        {
            autoFireReset();
            //        Laya.timer.clear(this, this.continuousShoot);
        }

        private function gamereset():void
        {
            autoFireReset();
            //        Laya.timer.clear(this, this.continuousShoot);
        }

        private function onFinishReward():void
        {
            rewardFishTip = false;
        }

        private var FireStateSetPuaseUiName:String = "";

        private function loadUi(data:*):void
        {
            if (FireState == GameConst.atuoFire)
            {
                var name:String = data as String
                if (name != "Levelup" &&
                        name != "HorseTip" &&
                        name != "GoldTip")
                {
                    FireStateSetPuaseUiName = name;
                    Laya.timer.clear(this, this.continuousShoot);
                    FireState = GameConst.oPauseAutoFire;
                }

            }
        }

        private function closeUi(data:*):void
        {
            resumeAuto();
        }

        private function stopLock():void
        {
            resumeAuto();
        }

        private function lockStart():void
        {
            pauseAuto();

        }

        private function goShop():void
        {
            // GameEventDispatch.instance.event(GameEvent.Shop, "tab_package");
            UiManager.instance.loadView("MonthCard", {id: GameConst.month_card_id});
        }


        private function getCatchShowEffectPos(data:*):void
        {
            if (data.seat_id == 1)
            {
                data.x = box_1.x + roleOne.x + 39;
                data.y = box_1.y + roleOne.y + 39;
            } else if (data.seat_id == 2)
            {
                data.x = box_2.x + roleTwo.x + 39;
                data.y = box_2.y + roleTwo.y + 39;
            } else if (data.seat_id == 3)
            {
                data.x = box_3.x + roleThree.x + 39;
                data.y = box_3.y + roleThree.y + 39;
            } else
            {
                data.x = box_4.x + roleFour.x + 39;
                data.y = box_4.y + roleFour.y + 39;
            }
            data.getPos = true;
        }

        private function getPaoPos(data:*):void
        {
            if (data.seat_id == 1)
            {
                data.x = paoone.x;
                data.y = paoone.y;
            } else if (data.seat_id == 2)
            {
                data.x = paotwo.x;
                data.y = paotwo.y;
            } else if (data.seat_id == 3)
            {
                data.x = paothree.x;
                data.y = paothree.y;
            } else
            {
                data.x = paofour.x;
                data.y = paofour.y;
            }
            data.getPos = true;
        }

        private function screenResize():void
        {

            resetUi();
        }

        private function update():void
        {
            isUpdate = true;
            //Laya.timer.loop(1000, this, updateTime);

        }

        private function addActivityPointShow():void
        {

            var vertical_h = 10
            var horizontal_percent = 0.75

            if (ActivityM.instance.isShowRewRebate)
            {
                RedpointC.instance.removeActivityPoint(reward)
                RedpointC.instance.addActivityPointToIcon(reward, horizontal_percent - 0.2, vertical_h - 20, false)
            } else
            {
                RedpointC.instance.removeActivityPoint(reward)
            }

            if (ActivityM.instance.isShowSinceRebate)
            {
                RedpointC.instance.removeActivityPoint(since)
                RedpointC.instance.addActivityPointToIcon(since, horizontal_percent, vertical_h, false)
            } else
            {
                RedpointC.instance.removeActivityPoint(since)
            }
        }


        private function updateTime():void
        {
            addActivityPointShow();
            if (isUpdate)
            {
                RuleM.instance.second = RuleM.instance.second - 1;
                if (RuleM.instance.second == -1)
                {
                    RuleM.instance.second = 59;
                    RuleM.instance.minute = RuleM.instance.minute - 1;
                    if (RuleM.instance.minute < 0)
                    {
                        RuleM.instance.minute = 59;
                    }
                }
                //            currentTime.text = RuleM.instance.showTime;
                currentTime.changeText(RuleM.instance.showTime);
            }
            if (FightM.instance.getAutoTime() > 0 && FightM.instance.coinShootScene())
            {
                autoTimeTip.visible = true;
                autoTimeTip.changeText(FightM.instance.getAutoTimeStr())
            } else
            {
                autoTimeTip.visible = false;
            }
            _coinUnchangeTime += 1;
            if (_coinUnchangeTime > 600)
            {
                GameEventDispatch.instance.event(GameEvent.CloseNovice, null);
                fightReturn();
                var tmpInfo:QuitTipInfo = new QuitTipInfo();
                tmpInfo.isHaveTime = false;
                tmpInfo.state = GameConst.quit_state_mid_confirm;
                tmpInfo.content = ConfigManager.getConfValue("cfg_tip", 43, "txtContent") as String;
                GameEventDispatch.instance.event(GameEvent.QuitTip, tmpInfo);
                UiManager.instance.closePanel("Red", false)
            }
            startTime();
            if (!FightM.instance.coinShootScene())
            {
                if (!FightM.instance.isMatchingGame())
                {
                    contestTimeBox.visible = !isMateShow();
                    if (contestTimeBox.visible)
                    {
                        FightM.instance.contestEndTimeSub();
                        FightM.instance.initCountDown(FightM.instance.getContestEndTime(), contestTimeText);
                    }
                } else
                {
                    if (contestTimeBox.visible != false)
                    {
                        contestTimeBox.visible = false
                    }
                    MatchInfoBox.instance.updateTime();
                }
            }
        }

        private function contestFightStart():void
        {
            if (!FightM.instance.isMatchingGame())
            {
                contestTimeBox.visible = !isMateShow();
            }
        }

        private function updateGoldPool():void
        {
            updateCoinCount();
        }

        private function updateCoinCount():void
        {
            //        totalCoin.text = FightM.instance.getGoldPoolTotalValue() + "";
            totalCoin.changeText(FightM.instance.getGoldPoolTotalValue() + "");
        }

        private function signUpdate(data:*):void
        {
            startSign();
        }


        //获取了鱼的数量
        private function getAward(count:int):void
        {
            coinWave(count, 70, -10, -110);
            // lotteryWave(count,-10,-30);
            lotteryComeEffect();
            Laya.timer.once(100, this, refresh);
        }

        private function refresh():void
        {
            RewardM.instance.setInfo();
            rewardFishCount = RoleInfoM.instance.getFcount();
            startId = RewardM.instance.selectTab(rewardCoinCount);
            _rewardLevelName.text = _rewardNameArr[startId];
            if (startId != endId || rewardFishCount == RewardM.instance.baseFishCount())
            {
                isLevel = true;
                Laya.timer.once(10000, this, remainShou);
            } else
            {
                Laya.timer.once(3000, this, shou);
            }
            endId = startId;

        }

        private function refreshLottery():void
        {
            RewardM.instance.setInfo();
            rewardFishCount = RoleInfoM.instance.getFcount();
            startId = RewardM.instance.selectTab(rewardCoinCount);
            _rewardLevelName.text = _rewardNameArr[startId];
        }


        private function remainShou():void
        {
            isLevel = false
            lotteryGoEffect();

        }

        private function shou():void
        {
            if (isLevel == false)
            {
                lotteryGoEffect();
            }

        }


        private function coinWave(count:Number, clipX:Number, clipY:Number, endY:Number):void
        {
            var clip:FontClip = new FontClip("font/font_1.png", "/.+-0123456789枚万亿");
            clip.value = "+" + count + "";
            //  clip.x = clipX;
            // clip.y = clipY;
            clip.centerY = clipY;
            clip.left = clipX;
            clip.anchorX = 0.5;
            clip.anchorY = 0.5;
            clip.scaleX = 1 / 2;
            clip.scaleY = 1 / 2;
            this.addChild(clip);
            Laya.timer.once(1500, this, hideClip, [clip]);
            Tween.to(clip, {scaleX: 4 / 2, scaleY: 4 / 2}, 500, null, Handler.create(this, waveComplete, [clip, endY]));


        }

        private function hideClip(clip:*):void
        {

            if (clip != null)
            {
                clip.visible = false
            }

        }

        private function waveComplete(clip:*, endY:*):void
        {
            Tween.to(clip, {
                scaleX: 2,
                scaleY: 2,
                alpha: 0.5
            }, 500, null, Handler.create(this, scaleComplete, [clip, endY]));

        }


        private function lotteryWave(count:Number, clipX:Number, clipY:Number):void
        {
            var clip:FontClip = new FontClip("font/font_1.png", "/.+-0123456789枚万亿");
            clip.value = "+" + count + "";
            //clip.centerY = clipY;
            clip.centerY = clipY;
            clip.left = clipX;
            clip.anchorX = 0.5;
            clip.anchorY = 0.5;
            clip.scaleX = 1 / 2;
            clip.scaleY = 1 / 2;
            this.addChild(clip);

            Tween.to(clip, {scaleX: 3, scaleY: 3}, 800, null, Handler.create(this, waveFirstComplete, [clip]));


        }

        private function waveFirstComplete(clip:*):void
        {
            Tween.to(clip, {scaleX: 0, scaleY: 0}, 800, null, Handler.create(this, waveSecondComplete, [clip]));

        }

        private function waveSecondComplete(clip:*):void
        {
            this.removeChild(clip);
            Tween.clearAll(clip);

        }

        private function scaleComplete(clip:*, endY:*):void
        {
            Tween.to(clip, {centerY: endY, alpha: 0}, 500, null, Handler.create(this, yComplete, [clip]));

        }

        private function yComplete(clip:*):void
        {
            this.removeChild(clip);
            Tween.clearAll(clip);

        }

        private function jinComplete():void
        {
            Laya.timer.once(1000, this, startShou);

        }

        private function startShou():void
        {
            if (nchou.x == 8)
            {
                chu.play(0, false);
            }
        }


        //解锁出来动效
        private function deblockComeEffect():void
        {
            if (unLockInside)
            {
                unLockInside = false;
                collect.play(0, false);
                collect.on(Event.COMPLETE, this, collectComplete);
            }
        }

        private function collectComplete():void
        {
            unLockOut = true;
            unLockInside = false;

        }

        //播放解锁动效
        private function playLockEffect():void
        {
            deblockComeEffect();
            deblockGoEffect();
        }

        //解锁进来动效
        private function deblockGoEffect():void
        {
            if (unLockOut)
            {
                unLockOut = false;
                release.play(0, false);
                release.on(Event.COMPLETE, this, releaComplete);
            }
        }

        private function releaComplete():void
        {
            unLockOut = false;
            unLockInside = true;
        }

        //播放抽奖出来动效
        private function lotteryComeEffect():void
        {
            if (ENV.isShowDied())
            {
                return;
            }
            if (lotteryInside || nchou.x == 0)
            {
                lotteryInside = false;
                chu.play(0, false);
                chu.on(Event.COMPLETE, this, chuComplete);
            }
        }

        private function chuComplete():void
        {
            lotteryOut = true;
            lotteryInside = false;

        }

        //播放抽奖进去动效
        private function lotteryGoEffect():void
        {
            if (ENV.isShowDied())
            {
                return;
            }
            if (lotteryOut || nchou.x == 535)
            {
                lotteryOut = false;
                jin.play(0, false);
                jin.on(Event.COMPLETE, this, jinEComplete);
            }
        }

        private function jinEComplete():void
        {
            lotteryInside = true;
            lotteryOut = false;

        }

        //播放抽奖动效
        private function playLotteryEffect():void
        {
            lotteryComeEffect();
            lotteryGoEffect();
        }

        private function fightReturn():void
        {
            if (FightM.instance.seatId > 0)
            {
                WebSocketManager.instance.send(12003, null);

                //            UiManager.instance.closePanel("Fish", false);
                //            UiManager.instance.loadView("MainPage");
            } else
            {
                exitFight(null);
            }

        }

        private function autoFireReset():void
        {
            cancle.visible = false;
            FireState = GameConst.oPauseAutoFire;
            Laya.timer.clear(this, this.continuousShoot);
        }

        private function autoShootTimeOut():void
        {
            stopAuto();
        }

        private function playerCoinChange():void
        {
            _coinUnchangeTime = 0;
        }

        public function register():void
        {
            WebSocketManager.instance.send(15003, null);
            GameEventDispatch.instance.on(GameEvent.SystemReset, this, gamereset);
            GameEventDispatch.instance.on(GameEvent.OnlineBullet, this, onlineBullet);
            GameEventDispatch.instance.on(GameEvent.FightStop, this, exitFight);
            GameEventDispatch.instance.on(GameEvent.MatchingGameAgainStart, this, startAgainMatchingGame);
            GameEventDispatch.instance.on(GameEvent.MatchingGameSynState, this, updateMatchingGamePanel);
            GameEventDispatch.instance.on(GameEvent.FightPlayerUpdate, this, fightPlayerUpdate);
            GameEventDispatch.instance.on(GameEvent.FightCoinUpdate, this, fightPlayerUpdate);
            GameEventDispatch.instance.on(GameEvent.ShowGetGoodsEffect, this, showGetGoodsEffect);
            GameEventDispatch.instance.on(GameEvent.BatteryBuyRet, this, batteryBuyRet);
            GameEventDispatch.instance.on(GameEvent.SyncActivityStatus, this, syncActivityStatus);

            GameEventDispatch.instance.on(GameEvent.RefreshTaskDaily, this, refreshTask);
            GameEventDispatch.instance.on(GameEvent.RefreshTaskDailyTotal, this, refreshTaskTotal);
            GameEventDispatch.instance.on(GameEvent.FinishTaskDaily, this, refreshTask);

            GameEventDispatch.instance.on(GameEvent.BoomSelectUpdate, this, boomUpdate);

            GameEventDispatch.instance.on(GameEvent.SkillUpdate, this, skillUpdate);
            GameEventDispatch.instance.on(GameEvent.GoodsUpdate, this, goodsUpdate);
            GameEventDispatch.instance.on(GameEvent.ViolentUpdate, this, violenUpdate);
            GameEventDispatch.instance.on(GameEvent.UpdateProfile, this, updateFishCount);
            GameEventDispatch.instance.on(GameEvent.ShowGuide, this, showGuide);
            GameEventDispatch.instance.on(GameEvent.ShowRedPoint, this, showRedPoint);
            GameEventDispatch.instance.on(GameEvent.FinishReward, this, onFinishReward);
            GameEventDispatch.instance.on(GameEvent.ShootError, this, shootError);
            GameEventDispatch.instance.on(GameEvent.ReturnConfirm, this, fightReturn);
            GameEventDispatch.instance.on(GameEvent.LoadUi, this, loadUi);
            GameEventDispatch.instance.on(GameEvent.CloseUi, this, closeUi);
            GameEventDispatch.instance.on(GameEvent.ShowFishCoin, this, getAward);
            GameEventDispatch.instance.on(GameEvent.SignInUpdate, this, signUpdate);
            GameEventDispatch.instance.on(GameEvent.UpdateGoldPoolInfo, this, updateGoldPool);
            GameEventDispatch.instance.on(GameEvent.UpdateTime, this, update);
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.on(GameEvent.GetCatchShowEffectEndPos, this, getCatchShowEffectPos);
            GameEventDispatch.instance.on(GameEvent.GoShop, this, goShop);
            GameEventDispatch.instance.on(GameEvent.lockStart, this, lockStart);
            GameEventDispatch.instance.on(GameEvent.stopLock, this, stopLock);
            GameEventDispatch.instance.on(GameEvent.AutoShootTimeOut, this, autoShootTimeOut);

            GameEventDispatch.instance.on(GameEvent.MonthCardUpdate, this, initMonthCardIcon);//月卡更新
            GameEventDispatch.instance.on(GameEvent.UpdateFirstCharge, this, initMonthCardIcon);//首冲更新

            GameEventDispatch.instance.on(GameEvent.PlayBossComing, this, playBossComing);
            GameEventDispatch.instance.on(GameEvent.WelcomeGetIn, this, playGetIn);
            GameEventDispatch.instance.on(GameEvent.FishTide, this, fishTide);

            GameEventDispatch.instance.on(GameEvent.OnlineAwardUpdate, this, receive);
            GameEventDispatch.instance.on(GameEvent.StartRefersh, this, starRefreshOnline);
            LoginM.instance.pageId = GameConst.FISH_PAGE;
            GameEventDispatch.instance.on(GameEvent.PlayerCoinChange, this, playerCoinChange);
            GameEventDispatch.instance.on(GameEvent.GetPaoPos, this, getPaoPos);
            GameEventDispatch.instance.on(GameEvent.SetPaoRotation, this, setPaoRotation);
            GameEventDispatch.instance.on(GameEvent.ContestFightStart, this, contestFightStart);

            GameEventDispatch.instance.on(GameEvent.NoviceGuideUnlockBattery, this, unlockbattery);
            GameEventDispatch.instance.on(GameEvent.NoviceGuideChangeBattery, this, _clickPowerSub);
            GameEventDispatch.instance.on(GameEvent.NoviceShoot, this, mouseDown);
            GameEventDispatch.instance.on(GameEvent.NoviceShootUp, this, mouseUp);
            GameEventDispatch.instance.on(GameEvent.NoviceShootMove, this, mouseMove);

            GameEventDispatch.instance.on(GameEvent.BatteryRateChagne, this, endChangeBatteryRate);
            //            GameEventDispatch.instance.on(GameEvent.RankAniRefesh, this, rankAniEnd);
            GameEventDispatch.instance.on(GameEvent.CloseOtherBar, this, closeOtherBars);

            BackBox.instance.register()
            MatchInfoBox.instance.register()
            MatchResultBox.instance.register()
        }

        private function starRefreshOnline():void
        {
            OnLineM.instance.isAni = true;
            refreshOnline();
            //OnLineImgEffect();


        }

        private function receive(data:S2c_22001):void
        {
            OnLineM.instance.isAni = false;
            _leftTime = OnLineM.instance.getLeftTime();
            //OnLineM.instance.RewardIndex = data.id;
            getImg.visible = false;
            leftTime.visible = true;
            refreshOnline();
            receiveImg.skin = "ui/fish/lqjl_2.png";
            Laya.timer.once(500, this, resetImg);


        }

        private function resetImg():void
        {
            refreshOnline();

        }


        public function unRegister():void
        {
            //Tween.clearAll(denone);
            Tween.clearAll(dentwo);
            Tween.clearAll(denthree);
            Tween.clearAll(denfour);
            autoFireReset();
            Laya.timer.clear(this, this.paoAnimationCheck);
            Laya.timer.clear(this, this.shootTick);
            Laya.timer.clear(this, updateTime);
            Laya.timer.clear(this, frameUpdate);
            GameEventDispatch.instance.off(GameEvent.SystemReset, this, gamereset);
            GameEventDispatch.instance.off(GameEvent.OnlineBullet, this, onlineBullet);
            //GameEventDispatch.instance.off(String(10000), this, receiveHandshake);
            GameEventDispatch.instance.off(GameEvent.MatchingGameAgainStart, this, startAgainMatchingGame);
            GameEventDispatch.instance.off(GameEvent.MatchingGameSynState, this, updateMatchingGamePanel);
            GameEventDispatch.instance.off(GameEvent.FightStop, this, exitFight);
            GameEventDispatch.instance.off(GameEvent.FightPlayerUpdate, this, fightPlayerUpdate);
            GameEventDispatch.instance.off(GameEvent.FightCoinUpdate, this, fightPlayerUpdate);
            GameEventDispatch.instance.off(GameEvent.ShowGetGoodsEffect, this, showGetGoodsEffect);
            GameEventDispatch.instance.off(GameEvent.BatteryBuyRet, this, batteryBuyRet);

            GameEventDispatch.instance.off(GameEvent.RefreshTaskDaily, this, refreshTask);
            GameEventDispatch.instance.off(GameEvent.FinishTaskDaily, this, refreshTask);
            GameEventDispatch.instance.off(GameEvent.RefreshTaskDailyTotal, this, refreshTaskTotal);

            GameEventDispatch.instance.off(GameEvent.CloseUi, this, closeUi);
            GameEventDispatch.instance.off(GameEvent.BoomSelectUpdate, this, boomUpdate);

            GameEventDispatch.instance.off(GameEvent.SkillUpdate, this, skillUpdate);
            GameEventDispatch.instance.off(GameEvent.GoodsUpdate, this, goodsUpdate);
            GameEventDispatch.instance.off(GameEvent.ViolentUpdate, this, violenUpdate);
            GameEventDispatch.instance.off(GameEvent.UpdateProfile, this, updateFishCount);
            GameEventDispatch.instance.off(GameEvent.SyncActivityStatus, this, syncActivityStatus);

            GameEventDispatch.instance.off(GameEvent.ShowGuide, this, showGuide);

            if (rankAni.isPlaying)
            {
                rankAni.stop()
            }
            rankAniBox.centerX = -900;
            rankAniImg.visible = false;
            GameEventDispatch.instance.off(GameEvent.ShowRedPoint, this, showRedPoint);
            GameEventDispatch.instance.off(GameEvent.FinishReward, this, onFinishReward);
            GameEventDispatch.instance.off(GameEvent.ShootError, this, shootError);
            GameEventDispatch.instance.off(GameEvent.ReturnConfirm, this, fightReturn);
            GameEventDispatch.instance.off(GameEvent.LoadUi, this, loadUi);
            // GameEventDispatch.instance.off(GameEvent.SignInUpdate, this, signUpdate);
            GameEventDispatch.instance.off(GameEvent.UpdateGoldPoolInfo, this, updateGoldPool);
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.off(GameEvent.GetCatchShowEffectEndPos, this, getCatchShowEffectPos);

            GameEventDispatch.instance.off(GameEvent.GoShop, this, goShop);
            GameEventDispatch.instance.off(GameEvent.lockStart, this, lockStart);
            GameEventDispatch.instance.off(GameEvent.stopLock, this, stopLock);

            GameEventDispatch.instance.on(GameEvent.AutoShootTimeOut, this, autoShootTimeOut);

            GameEventDispatch.instance.off(GameEvent.MonthCardUpdate, this, initMonthCardIcon);
            GameEventDispatch.instance.off(GameEvent.UpdateFirstCharge, this, initMonthCardIcon);
            GameEventDispatch.instance.off(GameEvent.PlayBossComing, this, playBossComing);
            GameEventDispatch.instance.off(GameEvent.WelcomeGetIn, this, playGetIn);
            GameEventDispatch.instance.off(GameEvent.FishTide, this, fishTide);

            GameEventDispatch.instance.off(GameEvent.OnlineAwardUpdate, this, receive);
            GameEventDispatch.instance.off(GameEvent.StartRefersh, this, starRefreshOnline);
            GameEventDispatch.instance.off(GameEvent.PlayerCoinChange, this, playerCoinChange);
            GameEventDispatch.instance.off(GameEvent.GetPaoPos, this, getPaoPos);
            GameEventDispatch.instance.off(GameEvent.SetPaoRotation, this, setPaoRotation);
            GameEventDispatch.instance.off(GameEvent.ContestFightStart, this, contestFightStart);

            yulei.visible = false;
            playimgOne.skin = "ui/common/nan.png";
            playimgTwo.skin = "ui/common/nan.png";
            playimgThree.skin = "ui/common/nan.png";
            playimgFour.skin = "ui/common/nan.png";


            GameEventDispatch.instance.off(GameEvent.NoviceGuideUnlockBattery, this, unlockbattery);
            GameEventDispatch.instance.off(GameEvent.NoviceGuideChangeBattery, this, _clickPowerSub);
            GameEventDispatch.instance.off(GameEvent.NoviceShoot, this, mouseDown);

            GameEventDispatch.instance.off(GameEvent.NoviceShootUp, this, mouseUp);
            GameEventDispatch.instance.off(GameEvent.NoviceShootMove, this, mouseMove);

            GameEventDispatch.instance.off(GameEvent.BatteryRateChagne, this, endChangeBatteryRate);
            //            GameEventDispatch.instance.off(GameEvent.RankAniRefesh, this, rankAniEnd);
            GameEventDispatch.instance.off(GameEvent.CloseOtherBar, this, closeOtherBars);

            BackBox.instance.unRegister();
            MatchInfoBox.instance.unRegister();
            MatchResultBox.instance.unRegister();
        }
    }
}
