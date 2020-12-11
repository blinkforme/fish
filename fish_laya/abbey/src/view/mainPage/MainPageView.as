package view.mainPage
{
    import control.NoviceC;
    import control.RedpointC;
    import control.ShopC;
    import control.T360C;
    import control.WxC;
    import control.WxShareC;
    import control.YylyC;

    import engine.tool.StartParam;

    import model.ActivityM;
    import model.CertificationM;
    import model.FriendM;
    import model.LevelM;
    import model.LoadResM;
    import model.LoginInfoM;
    import model.LoginM;
    import model.MatchM;
    import model.RewardM;
    import model.RoleInfoM;
    import model.RuleM;
    import model.WxM;

    import conf.cfg_global;
    import conf.cfg_scene;

    import emurs.ShowType;

    import laya.events.Event;
    import laya.particle.Particle2D;
    import laya.ui.Box;
    import laya.ui.FontClip;
    import laya.ui.Image;
    import laya.ui.Label;
    import laya.utils.Browser;
    import laya.utils.Handler;
    import laya.display.Animation;
    import laya.display.Sprite;

    import manager.ConfigManager;
    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.GameTools;
    import manager.ResVo;
    import manager.ScreenAdaptManager;
    import manager.SpineTemplet;
    import manager.UiManager;
    import manager.WebSocketManager;

    import proto.C2s_12001;
    import proto.S2c_14006;

    import struct.CertificationInfo;

    import ui.abbey.MainPageUI;

    public class MainPageView extends MainPageUI implements ResVo
    {


        private var horseTxt:Label;
        private var fontClip:FontClip;
        private var sp:Particle2D;
        private var spine:SpineTemplet;
        private var _count:int = 0;
        private var _isStop:Boolean = false;
        private var scroll_value:Number = 0;
        private var _cfg:cfg_scene;
        private var _horseTipArray:Array = [{id: 1, a6: 300, agent: true}, {id: 3, a6: 700, agent: true}, {
            id: 4,
            a6: 100,
            agent: true
        }, {id: 4, a6: 800, agent: false}, {id: 5, a2: "2018,3,6", a4: "2019,5,4", agent: true}, {
            id: 3,
            a6: 134,
            agent: false
        }];
        private var isTrack:Boolean = false;
        private var _index:int = -1;

        private var isBombActivityCountDownStart:Boolean = false;
        private var isBonusActivityCountDownStart:Boolean = false;

        private var chapterArr:Array = []

        private var iphoneXOffset:Number = 70;

        private var currencyOffset:Number = 250;

        public function MainPageView()
        {

            YylyC.EnterGame();

            if (!isTrack)
            {
                isTrack = true;
            }
        }

        public function StartGames(param:Object = null):void
        {
            if (WxC.isInMiniGame())
            {
                //ShopC.instance.sendSyncMiniBalance()
            }
            WebSocketManager.instance.send(50001, {});
            LoginInfoM.instance.mainPageShow = true;


            pathBtn.on(Event.CLICK, this, clickPath);
            shopBtn.on(Event.CLICK, this, openShop);
            firstChargeBtn.on(Event.CLICK, this, firstCharge);
            friendBtn.on(Event.CLICK, this, onFriendBtn);
            subscriptionBtn.on(Event.CLICK, this, firstSubscription);
            exchangeBtn.on(Event.CLICK, this, exchange);
            packBtn.on(Event.CLICK, this, pack);
            wxInfoBtn.on(Event.CLICK, this, onWxInfoBtn);
            registerBtn.on(Event.CLICK, this, clickRegister);
            addCoinBtn.on(Event.CLICK, this, addCoin);
            addDiamondBtn.on(Event.CLICK, this, addDiamond);
            if (WxC.isInMiniGame())
            {
                addMiniBtn.on(Event.CLICK, this, addMini);
            }
            settingBtn.on(Event.CLICK, this, onChangeSettingBtn);
            ranking_btn.on(Event.CLICK, this, onRankBtn);
            activityBtn.on(Event.CLICK, this, onActivityBtn);
            bankBtn.on(Event.CLICK, this, onBankBtn);
            shareBtn.on(Event.CLICK, this, clickShare);
            useTicketBtn.on(Event.CLICK, this, onUseTicketBtn);
            redPackBtn.on(Event.CLICK, this, onRedPackBtn);
            collectBtn.on(Event.CLICK, this, onCollectBtn);
            shortGiftBtn.on(Event.CLICK, this, onShortGiftBtn);


            if (RoleInfoM.instance.short_pf == 1 || RoleInfoM.instance.short_pf == 2)
            {
                if (StartParam.instance.getParam("ctime") + cfg_global.instance(1).rech_days * 86400 < parseInt(new Date().getTime() / 1000))
                {
                    shortGiftBtn.visible = false
                } else
                {
                    shortGiftBtn.visible = true
                }

            } else
            {
                shortGiftBtn.visible = false
            }

            collectUpdate()
            useTicketBtn.visible = false;
            redPackBtn.visible = false;
            profileUpdate()
            if (!GameConst.main_edit_menu_show)
            {
                pathBtn.visible = false;
            }
            initMonthCardIcon();
            showRedPoint()
            showFriendRedPoint()
            screenResize();

            levelList.refresh();
            Laya.timer.loop(1000, this, startPlay);

            this.visible = true;

            init()

            levelList.hScrollBarSkin = "";
            levelList.renderHandler = new Handler(this, updateItem);
            novicePlay.on(Event.CLICK, this, onClickPlay);
            noviceNotPlay.on(Event.CLICK, this, onClickNotPlay);
            maskNovice.on(Event.CLICK, this, onClickNoviceMask);
            refreshCertificationInfo();
            refreshGetWxInfo();
            certificationBtn.on(Event.CLICK, this, onCertificationBtn);
            shortRed(); //短信福利红点
            initFirstChargeBtn();
            closeSubIco();//是否已关注公众号
            resetIcon()
            resetCurrencyBox()

            if (WxC.isHideShop())
            {
                addDiamondBtn.visible = false
                addCoinBtn.visible = false
                addMiniBtn.visible = false
            }
            if (WxShareC.loadResSuccess)
            {
                initMiniBtn()
            }

            if (WxC.isInMiniGame())
            {
                trace("场景id ", WxM.instance.isBackScene)
                trace("基础库版本 ", __JS__("wx").getSystemInfoSync().SDKVersion)
            }
        }

        private function onWxInfoBtn():void
        {
            UiManager.instance.loadView("WxInfo", null, ShowType.SMALL_TO_BIG);
        }

        private function refreshGetWxInfo():void
        {
            if (WxC.isInMiniGame())
            {
                if (WxC.author == 2)
                {
                    wxInfoBtn.visible = true;
                } else
                {
                    wxInfoBtn.visible = false;
                }
            }
        }

        private function refreshCertificationInfo():void
        {
            certificationBtn.visible = !LoginM.instance.isCompleteCertification;
            certificationBtn.visible = ENV.branchSwitch("certification")
        }

        private function initMiniBtn():void
        {
            if (WxShareC.isInMiniGame())
            {
                if (WxShareC.miniProgramArr.length > 0)
                {
                    mini_btn.visible = true
                    mini_btn.on(Event.CLICK, this, navigateToMiniProgram)
                    var obj = WxShareC.getCurMiniPro()
                    resetAdAni()
                    mini_name.text = obj.game_name
                    mini_name_bg.text = obj.game_name
                    if (WxShareC.miniProgramArr.length > 1)
                    {
                        Laya.timer.loop(5000, this, updataIndexMiniPro)
                    }
                } else
                {
                    mini_btn.visible = false
                }
            } else
            {
                mini_btn.visible = false
            }

        }


        private function updataIndexMiniPro()
        {
            WxShareC.updataIndexMiniPro()
            var obj = WxShareC.getCurMiniPro()
            resetAdAni()
            mini_name.text = obj.game_name
            mini_name_bg.text = obj.game_name
        }

        private function resetAdAni()
        {
            var adAni:Animation = WxShareC.instance.adAni()
            if (mini_btn.getChildByName("ad_btn"))
            {
                mini_btn.removeChildByName("ad_btn")
            }
            mini_btn.addChild(adAni)

        }

        private function navigateToMiniProgram():void
        {
            if (WxC.isInMiniGame())
            {

                WxShareC.navigateToMiniProgram()
            } else
            {

            }
        }

        private function collectUpdate():void
        {
            if (RewardM.instance._isCollect == 0 && WxC.instance.MiniStartObj() && !ENV.isShowDied())
            {
                collectGift_box.visible = true;
            } else
            {
                collectGift_box.visible = false;
            }
        }

        private function resetCurrencyBox():void
        {
            miniBox.visible = true
            goldBox.visible = true
            diamond_box.visible = true
            if (WxC.isMiniLayout())
            {

            } else
            {
                miniBox.visible = false
                goldBox.left = goldBox.left - currencyOffset
                diamond_box.left = diamond_box.left - currencyOffset
                currencyOffset = 0
            }
        }

        private function resetIcon():void
        {
            var startRight:Number = 20
            var startBottom:Number = 10
            var icons:Array = [shopBtn, registerBtn, month_icon, exchangeBtn, packBtn, bankBtn, firstChargeBtn, subscriptionBtn, friendBtn]

            hiddenIcon()
            //IOS小游戏隐藏按钮
            if (WxC.isHideShop())
            {
                shopBtn.visible = false
                month_icon.visible = false
                firstChargeBtn.visible = false
            }

            if (StartParam.instance.getParam("is_open_bank") == 0 || T360C.is360Game())
            {
                bankBtn.visible = false;
            }
            if (ENV.isShowDied())
            {
                subscriptionBtn.visible = false;
                month_icon.visible = false
            }
            for (var i:Number = 0; i < icons.length; i++)
            {
                var icon = icons[i]


                if (icon.visible)
                {
                    icon.right = startRight;
                    icon.bottom = startBottom;
                    startRight += 120
                }

                if (icon == ranking_btn)
                {
                    NoviceC.instance.stepPosData[GameConst.novice_guide_rank] = {
                        right: icon.right,
                        bottom: icon.bottom
                    }
                }

                if (icon == subscriptionBtn)
                {
                    NoviceC.instance.stepPosData[GameConst.novice_guide_open_follow] = {
                        right: icon.right,
                        bottom: icon.bottom
                    }
                }

            }
        }

        private function hiddenIcon():void
        {
            certificationBtn.visible = ENV.branchSwitch("band")
            wxInfoBtn.visible = ENV.branchSwitch("band")
            bankBtn.visible = ENV.branchSwitch("bank")
            subscriptionBtn.visible = ENV.branchSwitch("certification")
            exchangeBtn.visible = ENV.branchSwitch("exchange")
            shopBtn.visible = ENV.branchSwitch("shop")
//            useTicketBtn.visible = ENV.branchSwitch("useTicket")
            redPackBtn.visible = ENV.branchSwitch("redPack")
        }

        private function onClickNoviceMask(event:Event):void
        {
            event.stopPropagation()
        }

        private function clickWorldCup():void
        {
            UiManager.instance.loadView("Russia", null, ShowType.SMALL_TO_BIG);
        }

        private function clickShare():void
        {
            UiManager.instance.loadView("Share", null, ShowType.SMALL_TO_BIG);

        }

        public function onCopyUserId():void
        {
            GameTools.copyToClipboard(user_id.text.slice(3));
        }

        public function initCountDownBomb():void
        {
            var end_time:Number = ActivityM.instance.getActivityEndTime(GameConst.activity_bomb);

            var now:Number = new Date().getTime() as Number

            var now_time:Number = Math.floor((now / 1000));

            var diff_time:Number = end_time - now_time

            if (diff_time < 0)
            {
                diff_time = 0
            }

            var hoursleft = Math.floor((diff_time) / 3600)

            var minutesleft = Math.floor(((diff_time) % 3600) / 60)

            var secondsleft = (diff_time) % 60;

            //format 0 prefixes
            if (minutesleft < 10) minutesleft = "0" + minutesleft;
            if (secondsleft < 10) secondsleft = "0" + secondsleft;


            var text:String = "活动剩余:\n"
            if (hoursleft < 10)
            {
                text = text + " "
            }
            text = text + hoursleft + ":" + minutesleft + ":" + secondsleft;

            activity_count_down.text = text;
        }

        private function startPlay():void
        {
            addActivityPointShow();
            useTicketBtn.visible = ActivityM.instance.activityTicketContinueTime;
            redPackBtn.visible = ActivityM.instance.redPackTicketContinueTime;
            resetRightBtn();
            hiddenIcon();
            _index = _index + 1;
            if (_index < _horseTipArray.length)
            {
                GameEventDispatch.instance.event(GameEvent.TestHorse, [_horseTipArray[_index]]);
            }

        }

        private function resetRightBtn():void
        {
            if (useTicketBtn.visible && redPackBtn.top == 100)
            {
                redPackBtn.top = 210;
            } else if (!useTicketBtn.visible && redPackBtn.visible)
            {
                redPackBtn.top = 100;
            }
        }

        public function onBankBtn(event:Event):void
        {
            if (!RoleInfoM.instance.is_bind_tel)
            {
                var info:CertificationInfo = new CertificationInfo();
                info.openFrom = GameConst.from_bank;
                CertificationM.instance.info = info;
                CertificationM.instance.OpenCertification()
            } else
            {
                var info:CertificationInfo = new CertificationInfo();
                info.openFrom = GameConst.from_bank;
                CertificationM.instance.info = info;
                CertificationM.instance.OpenCertification()
            }
        }

        public function onUseTicketBtn(event:Event):void
        {
            UiManager.instance.loadView("UseTicket", null, ShowType.SMALL_TO_BIG);
        }

        public function onRedPackBtn(event:Event):void
        {
            UiManager.instance.loadView("RedActivity", null, ShowType.SMALL_TO_BIG);
        }

        public function onBtnCopyClick(event:Event):void
        {
            WxC.wx_set_clipboard_data(user_id.text.slice(3));
        }

        public function onActivityBtn(event:Event):void
        {
            UiManager.instance.loadView("Activity", null, ShowType.SMALL_TO_BIG);
        }

        public function onRankBtn(event:Event):void
        {
            UiManager.instance.loadView("Rank", null, ShowType.SMALL_TO_BIG);
        }

        public function onChangeSettingBtn(event:Event):void
        {
            UiManager.instance.loadView("Setting", null, ShowType.SMALL_TO_BIG);
        }

        private function clickRegister(event:Event):void
        {
            WxC.subscribeInfo([2]);
            UiManager.instance.loadView("Register", null, ShowType.SMALL_TO_BIG);
        }

        private function onCollectBtn(event:Event):void
        {
            UiManager.instance.loadView("CollectLead", null, ShowType.SMALL_TO_BIG);
        }

        private function onCertificationBtn(event:Event):void
        {
            if (CertificationM.instance.isOpenCertification())
            {
                var info:CertificationInfo = new CertificationInfo();
                info.openFrom = GameConst.from_main;
                CertificationM.instance.info = info;
                CertificationM.instance.OpenCertification()
            }
        }

        private function onShortGiftBtn():void
        {
            WebSocketManager.instance.send(50001, {})
            UiManager.instance.loadView("ShortGift", null, ShowType.SMALL_TO_BIG);
        }

        public function openShop(event:Event):void
        {


            event.stopPropagation();
            GameEventDispatch.instance.event(GameEvent.Shop, "tab_coin");

        }


        private function init():void
        {
            if (RuleM.instance.isList == true)
            {
                RuleM.instance.isList == false;


                var arr:Array = ConfigManager.filter("cfg_scene", function (conf:cfg_scene)
                {
                    return conf.type == 0 && conf.hidden_battery_level > RoleInfoM.instance.getBattery()
                })
                for (var i = 0; i < arr.length; i++)
                {
                    arr[i]['is_match'] = false
                }

                arr.push({"is_match": true, "spine_name": "jinjiyuchang"})

                if (arr.length != chapterArr.length)
                {
                    for (var i = 0; i < levelList.cells.length; i++)
                    {
                        levelList.cells[i].getChildByName("sp").removeChildByName('spine')
                    }
                    chapterArr = arr;
                    levelList.array = chapterArr;
                }
            }
        }


        private function updateItem(cell:Box, index:int):void
        {
            var battery:Number = RoleInfoM.instance.getBattery();
            var cfg:Object = cell.dataSource;

            var ele_unlock_image:Image = cell.getChildByName("unlockImageBg") as Image;
            var ele_unlock_image_txt:FontClip = cell.getChildByName("unlockTxt") as FontClip;
            var ele_item_img:Image = cell.getChildByName("sp") as Image
            var activityImg:Image = cell.getChildByName("activityImg") as Image
            activityImg.visible = false;
            if (ActivityM.instance.activityPictureConfig && ActivityM.instance.activityPictureConfig[5])
            {
                activityImg.skin = ActivityM.instance.activityPictureConfig[5];
            }
            ele_item_img.offAll(Event.CLICK)
            if (ele_item_img.getChildByName("spine") == null)
            {
                var spineRoot:Sprite = new Sprite()
                var spine:SpineTemplet = new SpineTemplet(cfg.spine_name);
                spineRoot.addChild(spine);
                spine.play(0, true);
                spine.pivot(spine.spineWidth / 2, spine.spineHeight / 2)
                spineRoot.name = "spine";
                spineRoot.x = 175
                spineRoot.y = 190
                cell.getChildByName("sp").addChild(spineRoot)
            }

            if (!cfg.is_match)
            {
                activityImg.visible = isOpenPoint(cfg.id);

                ele_item_img.offAll(Event.CLICK);

                ele_unlock_image.visible = false;
                ele_unlock_image_txt.visible = false;
                ele_unlock_image_txt.value = cfg.unlockImage;

                if (battery < cfg.unlock)
                {
                    ele_unlock_image.visible = true;
                    ele_unlock_image_txt.visible = true;
                }

                ele_item_img.on(Event.CLICK, this, gamePage(cfg))
            } else
            {
                if (ActivityM.instance.isShowMatchActivity)
                {
                    activityImg.visible = true;
                } else
                {
                    activityImg.visible = isOpenPoint(5);
                }
                ele_unlock_image.visible = false;
                ele_unlock_image_txt.visible = false;

                ele_item_img.offAll(Event.CLICK)
                ele_item_img.on(Event.CLICK, this, onMatchBtnClick)
            }

        }


        private function isOpenPoint(scenId:Number):Boolean
        {
            if (ActivityM.instance.activityPictureConfig && ActivityM.instance.activityPictureConfig[5])
            {
                switch (scenId)
                {
                    case 1:
                        return false;
                    case 2:
                        return ActivityM.instance.isShowRewRebate;
                    case 3:
                        return ActivityM.instance.isShowRewRebate;
                    case 4:
                        return ActivityM.instance.isShowSinceRebate;
                    case 5:
                        return ActivityM.instance.isShowDayMatchRebate;
                }
            }
            return false;
        }


        private function gamePage(cfg:cfg_scene):Object
        {
            return function ()
            {
                _cfg = cfg;
                var batteryLevel = RoleInfoM.instance.getBattery();
                if (batteryLevel >= cfg.unlock)
                {
                    LoginM.instance.sceneId = cfg.id;
                    GameEventDispatch.instance.event(GameEvent.StartLoad, [GameConst.loadFishState]);
                } else
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTip, cfg.msg_tip_id);
                }
            }
        }

        public function onMatchBtnClick():void
        {
            if (MatchM.instance.contestOpen && MatchM.instance.contestOpen == 1)
            {
                UiManager.instance.loadView("NewMatch", null, ShowType.SMALL_TO_BIG);
            } else
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "比赛场尚未开启")
            }

            //            UiManager.instance.loadView("Match", null, ShowType.SMALL_TO_BIG);
        }

        public function firstCharge():void
        {
            UiManager.instance.loadView("FirstCharge", null, ShowType.SMALL_TO_BIG);
        }

        public function onFriendBtn():void
        {
            UiManager.instance.loadView("Friend", null, ShowType.SMALL_TO_BIG);
        }

        public function firstSubscription():void
        {
            UiManager.instance.loadView("Subscription", null, ShowType.SMALL_TO_BIG);
        }

        public function exchange():void
        {
            UiManager.instance.loadView("Exchange", null, ShowType.SMALL_TO_BIG);

        }

        public function pack():void
        {
            UiManager.instance.loadView("Pack", null, ShowType.SMALL_TO_BIG);
        }

        private function refreshMonthCard():void
        {
            initMonthCardIcon();
        }

        private function initMonthCardIcon():void
        {
            month_icon.offAll(Event.CLICK);
            if (RoleInfoM.instance.haveValidMonthCard())
            {
                var cards:Object = RoleInfoM.instance.getMonthCard();
                for (var id in cards)
                {
                    if (cards[id].can_accept)
                    {
                        month_icon.on(Event.CLICK, this, function (event:Event)
                        {
                            event.stopPropagation();
                            var a:S2c_14006 = new S2c_14006();
                            a.id = id;

                            WebSocketManager.instance.send(14006, a);
                        })
                        return
                    }
                }

                month_icon.on(Event.CLICK, this, function (event:Event)
                {
                    event.stopPropagation();
                    UiManager.instance.loadView("MonthCard", {id: GameConst.month_card_id}, ShowType.SMALL_TO_BIG);
                })

            } else
            {
                month_icon.on(Event.CLICK, this, function (event:Event)
                {
                    event.stopPropagation();
                    UiManager.instance.loadView("MonthCard", {id: GameConst.month_card_id}, ShowType.SMALL_TO_BIG);
                })
            }
        }


        public function initFirstChargeBtn():void
        {
            if (ShopC.instance.isShowFirstIcon())
            {
                firstChargeBtn.visible = true;
            } else
            {
                firstChargeBtn.visible = false;
                closeSubIco();
            }
            resetIcon();
        }

        private function closeSubIco():void
        {
            //41004  {show:0}
            if (RoleInfoM.instance.getFirstSubscription())
            {
                subscriptionBtn.visible = true;
            } else
            {
                subscriptionBtn.visible = false;
            }
            resetIcon();
        }


        private function showRedPoint():void
        {
            var red_points = RoleInfoM.instance.getRedPoints()

            var vertical_h = 10
            var horizontal_percent = 0.75

            if (GameConst.point_sign & red_points)
            {
                RedpointC.instance.removeRedPoint(registerBtn)
                RedpointC.instance.addRedPointToIcon(registerBtn, horizontal_percent, vertical_h)
            } else
            {
                RedpointC.instance.removeRedPoint(registerBtn)
            }

            if (GameConst.point_first_charge & red_points)
            {
                RedpointC.instance.removeRedPoint(firstChargeBtn)
                RedpointC.instance.addRedPointToIcon(firstChargeBtn, horizontal_percent, vertical_h)
            } else
            {
                RedpointC.instance.removeRedPoint(firstChargeBtn)
            }
            if (GameConst.point_month_card & red_points)
            {
                RedpointC.instance.removeRedPoint(shopBtn)
                RedpointC.instance.addRedPointToIcon(shopBtn, horizontal_percent, vertical_h)
            } else
            {
                RedpointC.instance.removeRedPoint(shopBtn)
            }

            if (GameConst.point_month_card & red_points)
            {
                RedpointC.instance.removeRedPoint(month_icon)
                RedpointC.instance.addRedPointToIcon(month_icon, horizontal_percent, vertical_h)
            } else
            {
                RedpointC.instance.removeRedPoint(month_icon)
            }

            if (GameConst.point_gift & red_points)
            {
                RedpointC.instance.removeRedPoint(packBtn)
                RedpointC.instance.addRedPointToIcon(packBtn, horizontal_percent, vertical_h)
            } else
            {
                RedpointC.instance.removeRedPoint(packBtn)
            }
            if (!ENV.isShowDied())
            {
                if ((GameConst.point_rank & red_points) && !LevelM.instance.rankDoubleReward)
                {
                    RedpointC.instance.removeSpinePoint(ranking_btn)
                    RedpointC.instance.addSpinePointToIcon(ranking_btn, horizontal_percent + 0.1, vertical_h + 20)
                } else
                {
                    RedpointC.instance.removeSpinePoint(ranking_btn)
                }
            } else
            {
                RedpointC.instance.removeSpinePoint(ranking_btn)
            }
        }

        private function shortRed():void
        {
            var vertical_h = 10
            var horizontal_percent = 0.75
            var arr_red:Array = RoleInfoM.instance.calcRed();
            for (var i = 0; i < arr_red.length; i++)
            {
                if (arr_red[i] == 1)
                {
                    RedpointC.instance.removeRedPoint(shortGiftBtn)
                    RedpointC.instance.addRedPointToIcon(shortGiftBtn, horizontal_percent, vertical_h)
                    break;
                } else
                {
                    RedpointC.instance.removeRedPoint(shortGiftBtn)
                }
            }
        }

        private function showFriendRedPoint():void
        {
            var vertical_h = 10
            var horizontal_percent = 0.75
            if (FriendM.instance.noApplyFriendList())
            {
                RedpointC.instance.removeRedPoint(friendBtn)
                RedpointC.instance.addRedPointToIcon(friendBtn, horizontal_percent, vertical_h)
            } else
            {
                RedpointC.instance.removeRedPoint(friendBtn)
            }
        }

        private function addActivityPointShow():void//当刷新开关时候 重新刷新活动图标
        {
            var vertical_h = 10
            var horizontal_percent = 0.75

            if (ActivityM.instance.isShowShopRebate)
            {
                RedpointC.instance.removeActivityPoint(shopBtn)
                RedpointC.instance.addActivityPointToIcon(shopBtn, horizontal_percent, vertical_h, false)
            } else
            {
                RedpointC.instance.removeActivityPoint(shopBtn)
            }

            if (WxC.isInMiniGame() && ActivityM.instance.isShowShareRebate)
            {
                RedpointC.instance.removeActivityPoint(shareBtn);
                RedpointC.instance.addActivityPointToIcon(shareBtn, horizontal_percent, vertical_h, false)
            } else
            {
                RedpointC.instance.removeActivityPoint(shareBtn)
            }

            if (ActivityM.instance.activityTicketContinueTime)
            {
                RedpointC.instance.removeActivityPoint(useTicketBtn);
                RedpointC.instance.addActivityPointToIcon(useTicketBtn, horizontal_percent, vertical_h, false)
            } else
            {
                RedpointC.instance.removeActivityPoint(useTicketBtn)
            }
            if (LevelM.instance.rankDoubleReward)
            {
                RedpointC.instance.removeDoubleRewardPoint(ranking_btn);
                RedpointC.instance.addDoubleRewardPointToIcon(ranking_btn, horizontal_percent - 0.2, vertical_h - 15, false)
            } else
            {
                RedpointC.instance.removeDoubleRewardPoint(ranking_btn)
            }
            if (ActivityM.instance.isShowMainRank)
            {
                RedpointC.instance.removeActivityPoint(ranking_btn);
                RedpointC.instance.addActivityPointToIcon(ranking_btn, horizontal_percent, vertical_h, false)
            } else
            {
                RedpointC.instance.removeActivityPoint(ranking_btn)
            }
        }


        private function start():void
        {
            UiManager.instance.loadView("HorseTip");
        }

        private function startMovie():void
        {
            horseTxt.x = horseTxt.x - 3;

        }

        private function clickPath():void
        {
            //UiManager.instance.loadView("FishType");
            // GameEventDispatch.instance.event(GameEvent.RewardFish);
            UiManager.instance.loadView("TestImpact");
            //GameEventDispatch.instance.event(GameEvent.RewardFish);

        }

        private function addCoin(event:Event):void
        {
            event.stopPropagation();
            GameEventDispatch.instance.event(GameEvent.Shop, "tab_coin");
        }

        private function addMini(event:Event):void
        {
            event.stopPropagation();
            GameEventDispatch.instance.event(GameEvent.Shop, "tab_mini");
        }

        private function addDiamond(event:Event):void
        {
            event.stopPropagation();
            GameEventDispatch.instance.event(GameEvent.Shop, "tab_diamond");
        }


        private function profileUpdate():void
        {
            var tmpCoin:int = (RoleInfoM.instance.getCoin() - RuleM.instance.coinCount + RoleInfoM.instance.getBindCoin());

            if (RoleInfoM.instance.getAvatar())
            {
                if (playimg.skin != RoleInfoM.instance.getAvatar())
                {
                    playimg.skin = RoleInfoM.instance.getAvatar()
                }
            }


            var coin:String;
            var diamond:String = RoleInfoM.instance.getDiamond() + "";

            if (tmpCoin < 0)
            {
                tmpCoin = 0;
            }
            coin = tmpCoin + "";
            goldCount.text = coin;
            diamondCount.text = diamond;
            if (WxC.isInMiniGame())
            {
                miniCount.text = RoleInfoM.instance.mini_balance + "";
            }

            if (coin.length > 10 || diamond.length > 10)
            {
                var scale:Number = 0.8;
                goldCount.scale(scale, scale);
                diamondCount.scale(scale, scale);
            } else
            {
                goldCount.scale(1, 1)
                diamondCount.scale(1, 1)
            }
            levelCount.text = "lv." + RoleInfoM.instance.getLevel() + "";

            nickname.text = LoginInfoM.instance.filterName(GameTools.formatNickName(RoleInfoM.instance.getName()));
            syncBankInfoEnd();
            levelList.refresh()
        }

        private function syncBankInfoEnd():void
        {
            if (T360C.is360Game())
            {
                user_id.text = "ID:" + StartParam.instance.getParam("uid")
                if (WxC.isInMiniGame())
                {
                    btnCopy.visible = true;
                    btnCopy.disabled = false;
                    btnCopy.offAll(Event.CLICK);
                    btnCopy.on(Event.CLICK, this, onBtnCopyClick);
                } else
                {
                    btnCopy.visible = false
                    user_id.offAll(Event.CLICK);
                    user_id.on(Event.CLICK, this, onCopyUserId)
                }
            } else
            {
                if (StartParam.instance.getParam("jjhid") && StartParam.instance.getParam("jjhid").length > 0)
                {
                    user_id.text = "ID:" + StartParam.instance.getParam("jjhid");//(RoleInfoM.instance.puuid + "").split(":")[1]

                    if (WxC.isInMiniGame())
                    {
                        btnCopy.visible = true;
                        btnCopy.disabled = false;
                        btnCopy.offAll(Event.CLICK);
                        btnCopy.on(Event.CLICK, this, onBtnCopyClick);
                    } else
                    {
                        btnCopy.visible = false
                        user_id.offAll(Event.CLICK);
                        user_id.on(Event.CLICK, this, onCopyUserId)
                    }
                } else if (StartParam.instance.getParam("uid") && StartParam.instance.getParam("uid").length > 0)
                {
                    user_id.text = "ID:" + StartParam.instance.getParam("uid");//(RoleInfoM.instance.puuid + "").split(":")[1]

                    // if (WxC.isInMiniGame())
                    // {
                    //     btnCopy.visible = true;
                    //     btnCopy.disabled = false;
                    //     btnCopy.offAll(Event.CLICK);
                    //     btnCopy.on(Event.CLICK, this, onBtnCopyClick);
                    // } else
                    // {
                    btnCopy.visible = false
                    user_id.offAll(Event.CLICK);
                    user_id.on(Event.CLICK, this, onCopyUserId)
                    // }
                } else
                {
                    if (WxC.isInMiniGame())
                    {
                        btnCopy.visible = true;
                        btnCopy.disabled = true
                    } else
                    {
                        btnCopy.visible = false
                    }
                    user_id.text = "绑定成功获取ID"
                }
            }
        }

        private function upgradeBattery():void
        {
            levelList.refresh();
        }

        private function isIphoneXCrossScreen():Boolean
        {
            var isIphoneXCrossScreen:Boolean = GameTools.isCrossScreen() && Browser.clientWidth == 812 && Browser.onIOS;
            return isIphoneXCrossScreen
        }


        private function screenResize():void
        {
            bg_img.width = 1280;
            bg_img.height = 720;
            maskNovice.width = Laya.stage.width
            maskNovice.height = Laya.stage.height

            if ((Laya.stage.height / Laya.stage.width) > (720 / 1280))
            {
                bg_img.height = Laya.stage.height;
            } else
            {
                bg_img.width = Laya.stage.width;
            }
            levelList.y = Laya.stage.height / 2;
            levelList.width = Laya.stage.width;
            shareBtn.visible = ENV.openSharePage;

            shareBtn.left = 70
            if (isIphoneXCrossScreen())
            {
                if (ScreenAdaptManager.instance.notch == "left")
                {
                    shareBtn.left = 20 + iphoneXOffset
                } else if (ScreenAdaptManager.instance.notch == "right")
                {
                }
            }
            this.size(Laya.stage.width, Laya.stage.height);
        }

        private function resetRoom():void
        {
            //LoginM.instance.sceneId = _cfg.id
            var c2s = new C2s_12001();
            c2s.scene_id = _cfg.id;
            WebSocketManager.instance.send(12001, c2s);

        }

        private function updateMiniBalance():void
        {
            miniCount.text = RoleInfoM.instance.mini_balance + "";
        }

        private function onClickPlay():void
        {
            noviceBox.visible = false
            maskNovice.visible = false
            WebSocketManager.instance.send(37000, {"is_finish": 0, "step_id": 'step1'})
        }

        private function onClickNotPlay():void
        {
            noviceBox.visible = false
            maskNovice.visible = false

            GameEventDispatch.instance.event(GameEvent.StartNoviceGuide, ['steps1']);
        }

        private function checkNovice():void
        {
            var step1_data:Object = RoleInfoM.instance.guide_status['step1']
            if (step1_data)
            {
                if (step1_data.status == 0)
                {
                    noviceBox.visible = true
                    maskNovice.visible = true
                }
            }
        }

        private function openBankView():void
        {
            UiManager.instance.loadView("Bank", null, ShowType.SMALL_TO_BIG);
        }

        public function noviceSliderContest():void
        {
            levelList.tweenTo(10, 2000)
        }

        public function noviceOpenContest():void
        {
            onMatchBtnClick()
        }

        public function noviceListChange(value):void
        {
            levelList.scrollBar.value = value
        }

        private function syncActivityData()
        {
            levelList.refresh()
        }

        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.LoadSecondMainfest, this, loadSecondPath);
            GameEventDispatch.instance.on(GameEvent.SyncBankCoin, this, syncBankInfoEnd);
            GameEventDispatch.instance.on(GameEvent.OpenBankView, this, openBankView);
            GameEventDispatch.instance.on(GameEvent.UpdateProfile, this, profileUpdate);
            GameEventDispatch.instance.on(GameEvent.UpdateFirstCharge, this, initFirstChargeBtn);
            GameEventDispatch.instance.on(GameEvent.ShowRedPoint, this, showRedPoint);
            GameEventDispatch.instance.on(GameEvent.BatteryBuyRet, this, upgradeBattery);
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.on(GameEvent.MonthCardUpdate, this, refreshMonthCard);
            //GameEventDispatch.instance.on(GameEvent.RestInRoom,this,resetRoom);
            LoginM.instance.pageId = GameConst.MAIN_PAGE;
            if (LoginM.instance.IsfirstEntryGame)
            {
                UiManager.instance.loadView("InsideNotice");
            }
            //UiManager.instance.loadView("InsideNotice");

            GameEventDispatch.instance.on(GameEvent.UpdateMiniBalance, this, updateMiniBalance);
            GameEventDispatch.instance.on(GameEvent.CloseRegisterPage, this, checkNovice);
            GameEventDispatch.instance.on(GameEvent.NoviceSliderContest, this, noviceSliderContest);
            GameEventDispatch.instance.on(GameEvent.NoviceOpenContest, this, noviceOpenContest);
            GameEventDispatch.instance.on(GameEvent.NoviceListChange, this, noviceListChange);

            GameEventDispatch.instance.on(GameEvent.SyncSubscriptionIco, this, closeSubIco);
            GameEventDispatch.instance.on(GameEvent.isCollect, this, collectUpdate);
            GameEventDispatch.instance.on(GameEvent.LoadMiniAdRes, this, initMiniBtn);
            GameEventDispatch.instance.on(GameEvent.syncShortData, this, shortRed);
            GameEventDispatch.instance.on(GameEvent.SyncCertificationInfo, this, refreshCertificationInfo);
            GameEventDispatch.instance.on(GameEvent.WxMiniLoginComplete, this, refreshGetWxInfo);
            GameEventDispatch.instance.on(GameEvent.refreshApplyFriendList, this, showFriendRedPoint);
            GameEventDispatch.instance.on(GameEvent.SyncActivityStatus, this, syncActivityData)
        }


        public function unRegister():void
        {
            GameEventDispatch.instance.off(GameEvent.LoadSecondMainfest, this, loadSecondPath);
            GameEventDispatch.instance.off(GameEvent.SyncBankCoin, this, syncBankInfoEnd);
            GameEventDispatch.instance.off(GameEvent.OpenBankView, this, openBankView);
            GameEventDispatch.instance.off(GameEvent.LoadMiniAdRes, this, initMiniBtn);
            Laya.timer.clear(this, updataIndexMiniPro)
            GameEventDispatch.instance.off(GameEvent.UpdateProfile, this, profileUpdate);
            GameEventDispatch.instance.off(GameEvent.UpdateFirstCharge, this, initFirstChargeBtn);
            GameEventDispatch.instance.off(GameEvent.ShowRedPoint, this, showRedPoint);
            GameEventDispatch.instance.off(GameEvent.BatteryBuyRet, this, upgradeBattery);
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.off(GameEvent.MonthCardUpdate, this, refreshMonthCard);
            //GameEventDispatch.instance.off(GameEvent.RestInRoom,this,resetRoom);
            LoginM.instance.IsfirstEntryGame = false;

            GameEventDispatch.instance.off(GameEvent.UpdateMiniBalance, this, updateMiniBalance);

            GameEventDispatch.instance.off(GameEvent.CloseRegisterPage, this, checkNovice);
            GameEventDispatch.instance.off(GameEvent.NoviceSliderContest, this, noviceSliderContest);
            GameEventDispatch.instance.off(GameEvent.NoviceOpenContest, this, noviceOpenContest);
            GameEventDispatch.instance.off(GameEvent.NoviceListChange, this, noviceListChange);

            GameEventDispatch.instance.off(GameEvent.SyncSubscriptionIco, this, closeSubIco);
            GameEventDispatch.instance.off(GameEvent.isCollect, this, collectUpdate);
            GameEventDispatch.instance.off(GameEvent.syncShortData, this, shortRed);
            GameEventDispatch.instance.off(GameEvent.SyncCertificationInfo, this, refreshCertificationInfo);
            GameEventDispatch.instance.off(GameEvent.WxMiniLoginComplete, this, refreshGetWxInfo);
            GameEventDispatch.instance.off(GameEvent.refreshApplyFriendList, this, showFriendRedPoint);
            GameEventDispatch.instance.off(GameEvent.SyncActivityStatus, this, syncActivityData)

            //            Laya.loader.clearTextureRes("spine/mainpage/datingbeijing.png");
            //            Laya.loader.clearTextureRes("spine/guang/25xuanzhuanguangxiao.png");

            //            五个场景骨骼
            //            Laya.loader.clearTextureRes("spine/jixieyuwang/H5_jixieyuwang.png");
            //            Laya.loader.clearTextureRes("spine/shenhaijujing/H5_shenhaijujing.png");
            //            Laya.loader.clearTextureRes("spine/tieqianxiewang/H5_tieqianxiewang.png");
            //            Laya.loader.clearTextureRes("spine/wannianjue/H5_wannianjue.png");
            //            Laya.loader.clearTextureRes("spine/jinjiyuchang/jinjiyuchang.png");

            //            if (!WxC.isInMiniGame())
            //            {
            //                Laya.loader.clearTextureRes("spine/loading/YX_Loading.png");
            //            }

        }

        private function loadSecondPath(data:Object):void
        {
//            console.log("data =========>>>",data.name);
            Laya.loader.load([{
                url: ConfigManager.getSecondConfigPath(),
                type: "json"
            }], Handler.create(this, function () {

//                console.log("第二份表资源加载完成 =======  ", data.name, data.param);
                LoadResM.instance.configSecondLoad = true;
                ConfigManager.initSecond();
                UiManager.instance.loadView(data.name, data.param, data.effectType);
            }));
        }
    }
}
