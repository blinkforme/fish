package manager
{


    import control.WxC;

    import emurs.UiType;

    import engine.analysis.BuriedManager;
    import engine.analysis.BuriedTypes;

    import laya.net.Loader;
    import laya.utils.ClassUtils;
    import laya.utils.Handler;

    import model.LoadResM;
    import model.LoginInfoM;

    import view.addFriend.AddFriend;

    import view.bank.Bank;
    import view.bindInfo.BindInfo;
    import view.bossShare.BossShare;
    import view.brokePage.BrokePage;
    import view.buySelect.BuySelect;

    import view.certification.Certification;
    import view.changeSkin.ChangeSkin;
    import view.ciFu.CiFu;
    import view.collectLead.CollectLead;
    import view.compenstate.Compenstate;
    import view.exchange.Exchange;
    import view.feedBack.FeedBack;
    import view.firstCharge.FirstCharge;
    import view.fish.Fish;
    import view.fishType.FishType;
    import view.friend.Friend;
    import view.goldTip.GoldTip;
    import view.horseTip.HorseTip;
    import view.insideNotice.InsideNotice;
    import view.levelup.Levelup;

    import view.load.Load;
    import view.login.Login;
    import view.mainPage.MainPage;
    import view.mask.Mask;
    import view.match.Match;
    import view.newMatch.NewMatch;
    import view.matchSettle.MatchSettle;
    import view.mate.Mate;
    import view.monthCard.MonthCard;
    import view.noviceGuide.NoviceGuide;
    import view.pack.Pack;
    import view.pathEditor.PathEditor;
    import view.prize.Prize;
    import view.publicAccount.PublicAccount;
    import view.quickRegister.QuickRegister;
    import view.quitTip.QuitTip;
    import view.rank.Rank;
    import view.redActivity.RedActivity;
    import view.register.Register;
    import view.resetLoad.ResetLoad;
    import view.resetLogin.ResetLogin;
    import view.rewardPage.RewardPage;
    import view.rewardTip.RewardTip;
    import view.rule.Rule;
    import view.setting.Setting;
    import view.sgBrokePage.SgBrokePage;
    import view.share.Share;
    import view.shop.Shop;
    import view.shortGift.ShortGift;
    import view.subscription.Subscription;
    import view.taskDaily.TaskDaily;
    import view.taskNew.TaskNew;
    import view.testImpact.TestImpact;
    import view.useTicket.UseTicket;
    import view.userBan.UserBan;
    import view.wait.Wait;
    import view.wdlogin.Wdlogin;
    import view.wxInfo.WxInfo;

    public class UiManager
    {
        private static var _instance:UiManager;
        private var _name:String;
        private var _param:Object;
        private var _panel:*;
        private var _caches:Object;
        private var _basePanelMaxDepth:int = 100;
        private var _noramlUiStepAdd:int = 50;
        private var _noramlUiMaxNum:int = 10;
        private var _fightUiStepAdd:int = 1;
        private var _fightUiMaxNum:int = 30;
        private var _fightUiPageStepAdd:int = 1;
        private var _fightUiPageMaxNum:int = 3;
        private var _dlgUiStepAdd:int = 50;
        private var _dlgUiMaxNum:int = 10;
        private var _guideMaxDepth:int = 30;
        private var _disconnectStepAdd:int = 1;
        private var _disconnectMaxNum:int = 1;
        private var _errorUiMaxDepth:int = 30;
        private var _normalList:Array;
        private var _dlglist:Array;
        private var _effecType:String;
        private var _emptyResUi:Object = new Object();

        public function UiManager()
        {
            _caches = new Object();
            _normalList = new Array();
            _dlglist = new Array();

            _emptyResUi["Mask"] = true;
            _emptyResUi["SgBrokePage"] = true;
            _emptyResUi["BrokePage"] = true;
            _emptyResUi["QuitTip"] = true;
            _emptyResUi["GoldTip"] = true;
            _emptyResUi["InsideNotice"] = true;
            _emptyResUi["Compenstate"] = true;
            // _emptyResUi["Fish"] = true;
            _emptyResUi["ResetLogin"] = true;
            _emptyResUi["Mate"] = true;
            _emptyResUi["Wait"] = true;
            // _emptyResUi["MatchSettle"] = true;
            _emptyResUi["FeedBack"] = true;
            _emptyResUi["BossShare"] = true;
            _emptyResUi["LevelUp"] = true;
            _emptyResUi["UserBan"] = true;
            _emptyResUi["Certification"] = true;
            _emptyResUi["WxInfo"] = true;
            _emptyResUi["BuySelect"] = true
            if (WxC.isInMiniGame())
            {
                _emptyResUi["Load"] = true;
            }
        }

        public function reset():void
        {
            _caches = new Object();
            _normalList = new Array();
            _dlglist = new Array();
        }

        public static function get instance():UiManager
        {
            return _instance || (_instance = new UiManager());
        }


        //ui界面的资源是否为空
        private function uiResEmpty(name:String):Boolean
        {
            return _emptyResUi[name];
        }

        public function toLowHead(str:String):String
        {
            var rst:String;
            if (str.length <= 1) return str.toLowerCase();
            rst = str.charAt(0).toLowerCase() + str.substr(1);
            return rst;
        }

        public function loadView(name:String, param:Object = null, effectType:String = null):void
        {
            if (WxC.isHideShop())
            {
                if (name == 'MonthCard')
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "需要月卡");
                } else if (name == 'FirstCharge')
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "功能未开放");
                } else
                {
                    _effecType = effectType;
                    _name = name;
                    _param = param;
                    _panel = (_caches[_name] || ClassUtils.getInstance("view." + toLowHead(_name) + "." + _name));
                    _caches[_name] = _panel;
                    if (uiResEmpty(name))
                    {
                        loadComplete(_panel, name);
                    } else
                    {
                        if (_name != "HorseTip")
                        {
                            GameEventDispatch.instance.event(GameEvent.OpenWait);
                        }

                        if (LoadResM.instance.configSecondLoad || !LoginInfoM.instance.mainPageShow){
                            Laya.loader.load(res, Handler.create(this, loadComplete, [_panel, name]));
                        }else{
                            GameEventDispatch.instance.event(GameEvent.LoadSecondMainfest, {name:name, param:param, effectType:effectType});
                        }
                    }
                    eventEnterMainPage(name);
                    GameEventDispatch.instance.event(GameEvent.LoadUi, name);
                }
            } else
            {
                _effecType = effectType;
                _name = name;
                _param = param;
                _panel = (_caches[_name] || ClassUtils.getInstance("view." + toLowHead(_name) + "." + _name));
                _caches[_name] = _panel;
                if (uiResEmpty(name))
                {
                    loadComplete(_panel, name);
                } else
                {
                    if (_name != "HorseTip")
                    {
                        GameEventDispatch.instance.event(GameEvent.OpenWait);
                    }

                    if (LoadResM.instance.configSecondLoad || !LoginInfoM.instance.mainPageShow){
                        Laya.loader.load(res, Handler.create(this, loadComplete, [_panel, name]));
                    }else{
                        GameEventDispatch.instance.event(GameEvent.LoadSecondMainfest, {name:name, param:param, effectType:effectType});
                    }
                }
                eventEnterMainPage(name);
                GameEventDispatch.instance.event(GameEvent.LoadUi, name);
            }
        }

        private var isEnterMain:Boolean = false;

        private function eventEnterMainPage(page:String):void
        {
            if (!isEnterMain && page == "MainPage")
            {
                BuriedManager.instance.addBuriedData(BuriedTypes.enter_main);
                isEnterMain = true;
            }
        }

        private function loadComplete(pan:Object, name:String):void
        {
            if (_effecType)
            {
                pan.EffectType = _effecType;
            }
            pan.startGame(_param, name);
            pan.setPanelBaseDepth(getNextBaseDepth(pan.uiType));
            addUiToList(pan);

        }

        public function loadUi(Panel:Class, param:Object = null):void
        {
            _panel = new Panel();

            var arr:Array = Panel.prototype.__className.split('.');
            _name = arr[arr.length - 1];
            Laya.loader.load(res, Handler.create(this, loadComplete));


        }


        //游戏各种界面的基础层级
        private function getUiBaseDepth(type:String):int
        {
            var ret:int = 0;
            switch (type)
            {
                case UiType.UI_TYPE_BASE:
                {
                    ret = 0;
                    break;
                }
                case UiType.UI_TYPE_NORMAL:
                {
                    ret = _basePanelMaxDepth;
                    break;
                }
                case UiType.UI_TYPE_FIGHT:
                {
                    ret = getUiBaseDepth(UiType.UI_TYPE_NORMAL) + _noramlUiMaxNum * _noramlUiStepAdd;
                    break;
                }
                case UiType.UI_TYPE_FIGHT_PAGE:
                {
                    ret = getUiBaseDepth(UiType.UI_TYPE_FIGHT) + _fightUiMaxNum * _fightUiStepAdd;
                    break;
                }
                case UiType.UI_TYPE_DLG:
                {
                    ret = getUiBaseDepth(UiType.UI_TYPE_FIGHT_PAGE) + _fightUiPageMaxNum * _fightUiPageStepAdd;
                    break;
                }
                case UiType.UI_TYPE_GUIDE:
                {
                    ret = getUiBaseDepth(UiType.UI_TYPE_DLG) + _dlgUiMaxNum * _dlgUiStepAdd;
                    break;
                }
                case UiType.UI_TYPE_DISCONNECT:
                {
                    ret = getUiBaseDepth(UiType.UI_TYPE_GUIDE) + _guideMaxDepth;
                    break;
                }
                case UiType.UI_TYPE_ERROR_TIP:
                {
                    ret = getUiBaseDepth(UiType.UI_TYPE_DISCONNECT) + _disconnectStepAdd * _disconnectMaxNum;
                    break;
                }
                case UiType.UI_TYPE_MSG_TIP:
                {
                    ret = getUiBaseDepth(UiType.UI_TYPE_ERROR_TIP) + _errorUiMaxDepth;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return ret;
        }

        public function getFightBaseDepth():int
        {
            return getUiBaseDepth(UiType.UI_TYPE_FIGHT);
        }

        public function getFightUiBaseDepth():int
        {
            return getUiBaseDepth(UiType.UI_TYPE_FIGHT_PAGE);
        }

        private function getNextBaseDepth(type:String):int
        {
            var ret:int = 0;
            switch (type)
            {
                case UiType.UI_TYPE_BASE:
                {
                    ret = 0;
                    break;
                }
                case UiType.UI_TYPE_NORMAL:
                {
                    ret = _basePanelMaxDepth + _normalList.length * _noramlUiStepAdd;
                    break;
                }
                case UiType.UI_TYPE_FIGHT:
                {
                    ret = getUiBaseDepth(UiType.UI_TYPE_FIGHT);
                    break;
                }
                case UiType.UI_TYPE_FIGHT_PAGE:
                {
                    ret = getUiBaseDepth(UiType.UI_TYPE_FIGHT_PAGE);
                    break;
                }
                case UiType.UI_TYPE_DLG:
                {
                    ret = getUiBaseDepth(UiType.UI_TYPE_DLG) + _dlglist.length * _dlgUiStepAdd;
                    break;
                }
                case UiType.UI_TYPE_GUIDE:
                {
                    ret = getUiBaseDepth(UiType.UI_TYPE_GUIDE);
                    break;
                }
                case UiType.UI_TYPE_DISCONNECT:
                {
                    ret = getUiBaseDepth(UiType.UI_TYPE_DISCONNECT);
                }
                case UiType.UI_TYPE_MSG_TIP:
                {
                    ret = getUiBaseDepth(UiType.UI_TYPE_MSG_TIP);
                    break;
                }
                case UiType.UI_TYPE_ERROR_TIP:
                {
                    ret = getUiBaseDepth(UiType.UI_TYPE_ERROR_TIP);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return ret;
        }


        private function removieFromList(panel:*):void
        {
            switch (panel.uiType)
            {
                case UiType.UI_TYPE_NORMAL:
                {
                    if (_normalList.indexOf(panel) != -1)
                    {
                        _normalList.splice(_normalList.indexOf(panel), 1);
                        resetBasePanelDepth(_normalList, getUiBaseDepth(UiType.UI_TYPE_NORMAL), _noramlUiStepAdd);
                    }
                    break;
                }
                case UiType.UI_TYPE_DLG:
                {
                    if (_dlglist.indexOf(panel) != -1)
                    {
                        _dlglist.splice(_dlglist.indexOf(panel), 1);
                        resetBasePanelDepth(_dlglist, getUiBaseDepth(UiType.UI_TYPE_DLG), _dlgUiStepAdd);
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
        }


        private function get pngNum():int
        {
            return _panel.pngNum
        }

        private function get res():Array
        {
            var arr:Array = [{url: "res/atlas/ui/" + toLowHead(_name) + ".atlas", type: Loader.ATLAS}];
            for (var i:int = 0; i < pngNum; i++)
            {
                arr.push({
                    url: "ui/" + toLowHead(_name) + "/" + toLowHead(_name) + "_" + i + ".png",
                    type: Loader.IMAGE
                });
            }
            return arr;
        }

        public function unloadView():void
        {

        }

        private function addUiToList(panel:*):void
        {
            switch (panel.uiType)
            {
                case UiType.UI_TYPE_NORMAL:
                {
                    if (_normalList.indexOf(panel) == -1)
                    {
                        _normalList.push(panel);
                    }
                    break;
                }
                case UiType.UI_TYPE_DLG:
                {
                    if (_dlglist.indexOf(panel) == -1)
                    {
                        _dlglist.push(panel);
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
        }

        private function resetBasePanelDepth(list:Array, baseDepth:int, stepAdd:int):void
        {
            for (var i:int = 0; i < list.length; i++)
            {
                list[i].setPanelBaseDepth(baseDepth);
                baseDepth += stepAdd;
            }

        }

        public function closePanel(name:String, isRemovie:Boolean):void
        {
            var panel:* = _caches[name];
            if (panel != null)
            {
                removieFromList(panel);
                if (isRemovie)
                {
                    panel.removie();
                } else
                {
                    panel.hide();
                }
                GameEventDispatch.instance.event(GameEvent.CloseUi, name);
            }
            Laya.loader.clearTextureRes("res/atlas/ui/" + toLowHead(name) + ".png");
        }

        public static function init():void
        {
            var reg:Function = ClassUtils.regClass;
            reg("view.wxInfo.WxInfo", WxInfo);
            reg("view.certification.Certification", Certification);
            reg("view.bank.Bank", Bank);
            reg("view.bossShare.BossShare", BossShare);
            reg("view.brokePage.BrokePage", BrokePage);
            reg("view.addFriend.AddFriend", AddFriend);
            reg("view.friend.Friend", Friend);
            reg("view.load.Load", Load);
            reg("view.login.Login", Login);
            reg("view.mainPage.MainPage", MainPage);
            reg("view.mask.Mask", Mask);
            reg("view.wait.Wait", Wait);
            reg("view.insideNotice.InsideNotice", InsideNotice);
            reg("view.register.Register", Register);
            reg("view.rewardTip.RewardTip", RewardTip);
            reg("view.changeSkin.ChangeSkin", ChangeSkin);
            reg("view.compenstate.Compenstate", Compenstate);
            reg("view.exchange.Exchange", Exchange);
            reg("view.feedBack.FeedBack", FeedBack);
            reg("view.firstCharge.FirstCharge", FirstCharge);
            reg("view.fish.Fish", Fish);
            reg("view.fishType.FishType", FishType);
            reg("view.goldTip.GoldTip", GoldTip);
            reg("view.horseTip.HorseTip", HorseTip);
            reg("view.levelup.Levelup", Levelup);
            reg("view.match.Match", Match);
            reg("view.newMatch.NewMatch", NewMatch);
            reg("view.matchSettle.MatchSettle", MatchSettle);
            reg("view.mate.Mate", Mate);
            reg("view.monthCard.MonthCard", MonthCard);
            reg("view.noviceGuide.NoviceGuide", NoviceGuide);
            reg("view.pack.Pack", Pack);
            reg("view.pathEditor.PathEditor", PathEditor);
            reg("view.prize.Prize", Prize);
            reg("view.quitTip.QuitTip", QuitTip);
            reg("view.rank.Rank", Rank);
            reg("view.resetLoad.ResetLoad", ResetLoad);
            reg("view.resetLogin.ResetLogin", ResetLogin);
            reg("view.rewardPage.RewardPage", RewardPage);
            reg("view.rule.Rule", Rule);
            reg("view.setting.Setting", Setting);
            reg("view.sgBrokePage.SgBrokePage", SgBrokePage);
            reg("view.share.Share", Share);
            reg("view.shop.Shop", Shop);
            reg("view.taskDaily.TaskDaily", TaskDaily);
            reg("view.taskNew.TaskNew", TaskNew);
            reg("view.testImpact.TestImpact", TestImpact);
            reg("view.userBan.UserBan", UserBan);
            reg("view.wdlogin.Wdlogin", Wdlogin);
            reg("view.subscription.Subscription", Subscription);
            reg("view.useTicket.UseTicket", UseTicket);
            reg("view.collectLead.CollectLead", CollectLead);
            reg("view.redActivity.RedActivity", RedActivity);
            reg("view.shortGift.ShortGift", ShortGift);
            reg("view.quickRegister.QuickRegister", QuickRegister);
            reg("view.ciFu.CiFu", CiFu);
            reg("view.publicAccount.PublicAccount", PublicAccount);
            reg("view.buySelect.BuySelect", BuySelect);
            reg("view.bindInfo.BindInfo", BindInfo);
        }
    }
}
