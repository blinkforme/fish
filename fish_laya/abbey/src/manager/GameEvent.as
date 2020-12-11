package manager
{
    public class GameEvent
    {
        public static const ReceiveHandshake:String = "ReceiveHandshake";//
        public static const ReceiveSGHandshake:String = "ReceiveSGHandshake";//小游戏握手
        public static const WsClose:String = "WsClose";
        public static const SGWsClose:String = "SGWsClose";//小游戏网络断开
        public static const WsError:String = "WsError";
        public static const SGWsError:String = "SGWsError";//小游戏网络出错
        public static const WsOpen:String = "WsOpen";
        public static const FightStart:String = "FightStart";//战斗开始
        public static const FightStop:String = "FightStop";//战斗结束
        public static const ParseFishData:String = "ParseFishData";//解析鱼数据
        public static const NewBullet:String = "NewBullet";//释放子弹
        public static const OnlineBullet:String = "OnlineBullet";
        public static const UpdateProfile:String = "UpdateProfile";
        public static const FightPlayerUpdate:String = "FightPlayerUpdate";//战斗玩家数据更新
        public static const FightCoinUpdate:String = "FightCoinUpdate";
        public static const ShowGetGoodsEffect:String = "ShowGetCoinEffect";//显示金币获取特效
        public static const QuitTip:String = "QuitTip" //退出游戏
        public static const MsgTip:String = "MsgTp"; //消息的toast的提示,根据msg id
        public static const MsgTipContent:String = "MsgTipContent"; //直接传提示


        public static const BatteryUpgrade:String = "BatteryUpgrade";//炮台升级
        public static const FishTypeC:String = "FishTypeC";//鱼的信息展示
        public static const RewardFish:String = "RewardFish";// 奖金鱼抽奖面板
        public static const RefreshTaskNew:String = "RefreshTaskNew";// 刷新新手任务数据
        public static const RefreshTaskDaily:String = "RefreshTaskDaily";// 刷新日常任务数据
        public static const RefreshTaskDailyTotal:String = "RefreshTaskDailyTotal";// 刷新日常任务数据
        public static const FinishTaskDaily:String = "FinishTaskDaily";// 完成日常任务
        public static const FinishTaskNew:String = "FinishTaskNew";// 完成新手任务
        public static const Shop:String = "Shop";// 商店
        public static const ShopBuy:String = "ShopBuy";// 商店购买
        public static const ShopRefresh:String = "ShopRefresh";// 刷新tab
        public static const ChangeSkin:String = "ChangeSkin";// 更换皮肤
        public static const ZhenFan:String = "ZhenFan";
        public static const TypeChange:String = "TypeChange"
        public static const LevelC:String = "LevelC"
        public static const RewardTip:String = "RewardTip"
        public static const HourseC:String = "HourseC"
        public static const BatteryBuyRet:String = "BatteryBuyRet"; //炮台更新
        public static const EnterFightPage:String = "EnterFightPage"; //进入战斗界面
        public static const BuffUpdate:String = "BuffUpdate"; //buff跟新
        public static const He:String = "He";
        public static const PlayCard:String = "PlayCard";
        public static const SkillUpdate:String = "SkillUpdate";
        public static const GoodsUpdate:String = "GoodsUpdate";
        public static const ViolentUpdate:String = "ViolentUpdate";//狂暴状态更新
        public static const BoomSelectUpdate:String = "BoomSelectUpdate";//炸弹状态切换
        public static const SignInUpdate:String = "SignInUpdate";//签到状态更新
        public static const OpenGift:String = "OpenGift";//签到状态更新

        public static const UpdateFirstCharge:String = "UpdateFirstCharge";//更新首冲状态

        public static const MonthCardUpdate:String = "MonthCardUpdate";//月卡刷新
        public static const OnlineAwardUpdate:String = "OnlineAwardUpdate"; //在线状态更新
        public static const HorseTipUpdate:String = "HorseTipUpdate"; //跑马灯提示更新
        public static const ConfirmUseSkill:String = "ConfirmUseSkill";
        public static const ShowGuide:String = "ShowGuide";//显示指引
        public static const ShowRedPoint:String = "ShowRedPoint";//显示小红点
        public static const ClearRedPoint:String = "ClearRedPoint";//消除小红点

        public static const FinishReward:String = "FinishReward";//完成抽奖的时候
        public static const UseGoodsConfirmAndJumpToShop:String = "UseGoodsConfirmAndJumpToShop";//使用道具确认并且提示进入商场

        public static const StartRefersh:String = "StartRefersh";//开始刷新游戏

        public static const SystemReset:String = "SystemReset";//系统重置

        public static const ShootError:String = "ShootError";
        public static const ClearCoin:String = "ClearCoin"
        public static const StopTime:String = "StopTime"
        public static const HeCLick:String = "HeClick"
        public static const ReturnConfirm:String = "ReturnConfirm";
        public static const LoadUi:String = "LoadUi";
        public static const ShowFishCoin:String = "ShowFishCoin";//飘获得的鱼币
        public static const SetFishCoin:String = "SetFishCoin"
        public static const PlayComplete:String = "PlayComplete"
        public static const UpgradeC:String = "UpgradeC"
        public static const CloseRewadTip:String = "CloseRewardTip"

        public static const UpdateGoldPoolInfo:String = "UpdateGoldPoolInfo";//更新奖金池信息
        public static const GetGoldPoolAward:String = "GetGoldPoolAward"; //获得奖金池的奖金
        public static const UpdateTime:String = "UpdataTime"//更新时间

        public static const ExitLoginView:String = "ExitLoginView"; //退出登录界面

        public static const ScreenResize:String = "ScreenResize"; //屏幕重置
        public static const GetCatchShowEffectEndPos:String = "GetCatchShowEffectEndPos";//获取特效飞回去的位置
        public static const UpdateFish:String = "UpdateFish"//更新鱼
        public static const CloseUi:String = "CloseUi";
        public static const GoShop:String = "GoShop";
        public static const lockStart:String = "lockStart";
        public static const stopLock:String = "stopLock";
        public static const OpenMakeUp:String = "OpenMakeUp"
        public static const AutoShootTimeOut:String = "AutoShootTimeOut";
        public static const TestCom:String = "TestCom";//测试补偿奖励
        public static const PlayBossComing:String = "PlayBossComeIn";
        public static const WelcomeGetIn:String = "WelcomeGetIn";//入场动画
        public static const FishTide:String = "FishComing";//鱼潮来了
        public static const StartLoad:String = "StartLoad";//开始加载资源
        public static const RestInRoom:String = "RestInRoom"//进入房间


        public static const GiftConfirmFinish:String = "GiftConfirmFinish"//接受赠送完成
        public static const GiftFinish:String = "GiftFinish"//赠送完成
        public static const ExchangeFinish:String = "ExchangeFinish"//兑换完成
        public static const ActivityExchangeFinish:String = "ActivityExchangeFinish"//兑换完成
        public static const UpdateExchange:String = "UpdateExchange"//更新兑换券
        public static const UpdateMiniBalance:String = "UpdateMiniBalance"//更新集结币
        public static const UpdateActivityTicket:String = "UpdateActivityTicket"//更新活动券
        public static const UpdateGoldExchange:String = "UpdateGoldExchange"//更新兑换券

        public static const ExitsGame:String = "ExitsGame" //彻底返回游戏
        public static const TestHorse:String = "TestHorse" //测试跑马灯
        public static const Regic:String = "Regic";
        public static const PlayerCoinChange:String = "PlayerCoinChange";//玩家金币改变
        public static const GetPaoPos:String = "GetPaoPos";//获取炮的位置
        public static const SetPaoRotation:String = "SetPaoRotation";
        public static const RefreshLotteryRecord:String = "RefreshLotteryRecord";//刷新抽奖记录


        public static const SyncActivityData:String = "SyncActivityData";
        public static const SyncActivityStatus:String = "SyncActivityStatus";

        public static const WxMiniLoginComplete:String = "WxMiniLoginComplete";//微信授权完成

        public static const WxCheckSessionOk:String = "WxCheckSessionOk"; //用户登陆状态有效
        public static const WxCheckSessionFail:String = "WxCheckSessionFail"; //用户登陆状态无效

        public static const WxMiniGameExit:String = "WxMiniGameExit";

        public static const WxResetLogin:String = "WxResetLogin"
        public static const CloseReset:String = "CloseReset"

        public static const WxGetClipBoard:String = "WxGetClipBoard";
        public static const WxReset:String = "WxReset"

        public static const OpenWait:String = "OpenWait"
        public static const CloseWait:String = "CloseWait"
        public static const BankUpdate:String = "BankUpdate"
        public static const EndBankDeposit:String = "EndBankDeposit"
        public static const SyncBankCoin:String = "SyncBankCoin"

        public static const EndBankTake:String = "EndBankTake"
        public static const EndBankTakeFail:String = "EndBankTakeFail"
        public static const RightWait:String = "RightWait"
        public static const AreaShareSucess:String = "AreaShareSucess"


        //    'daily', 'match', 'snatch', 'challenge'
        public static const EndDailyMatchSign:String = "EndDailyMatchSign"
        public static const EndSnatchMatchSign:String = "EndSnatchMatchSign"
        public static const EndAcceptChallengeMatchReward:String = "EndAcceptMatchReward"
        public static const EndAcceptDailyMatchReward:String = "EndAcceptDailyMatchReward"

        public static const ContestFightStart:String = "ContestFightStart";


        public static const EndUseMonthCard:String = "EndUseMonthCard";//使用月卡

        public static const ScreenShare:String = "ScreenShare";
        public static const ScreenShareComplete:String = "ScreenShareComplete";
        public static const BoomLotteryOne:String = "BoomLotteryOne";
        public static const BoomLotteryTen:String = "BoomLotteryTen";

        public static const WxAppLoginIn:String = "WxAppLoginIn";

        public static const EndAcceptWorldCup:String = "EndAcceptWorldCup";

        public static const EndSyncWorldCupCoin:String = "EndSyncWorldCupCoin";

        public static const EndWorldCupLottery:String = "EndWorldCupLottery";
        public static const FinishChangeSkin:String = "FinishChangeSkin";

        public static const WxSaveShareFile:String = "WxSaveShareFile";

        public static const CloseRegisterPage:String = "CloseRegisterPage";//关闭签到界面，检测新手引导
        public static const StartNoviceGuide:String = "StartNoviceGuide";//开始新手引导
        public static const NoviceGuideRefresh:String = "NoviceGuideRefresh";//新手引导刷新
        public static const FinishNoviceGuideStep:String = "FinishGuide";//完成新手引导
        public static const FinishNoviceGuideStep2:String = "FinishGuide";//完成新手引导2

        public static const NoviceGuideClickBar:String = "NoviceGuideClickBar";//新手引导打开拉条
        public static const NoviceGuideUnlockBattery:String = "NoviceGuideUnlockBattery";//新手引导升级炮台
        public static const NoviceGuideAcceptTaskNew:String = "NoviceGuideAcceptTaskNew";//新手引导完成新手任务
        public static const NoviceGuideChangeBattery:String = "NoviceGuideChangeBattery";//新手引导更换炮台
        public static const NoviceShoot:String = "NoviceShoot";//新手引导射击
        public static const NoviceShootUp:String = "NoviceShootUp";//新手引导射击
        public static const NoviceShootMove:String = "NoviceShootMove";//新手引导射击
        public static const NoviceGuideShoot:String = "NoviceGuideShoot";//新手引导发射子弹
        public static const NoviceSliderContest:String = "NoviceSliderContest";//新手滑动到比赛
        public static const NoviceOpenContest:String = "NoviceOpenContest";//新手引导进入比赛场
        public static const NoviceSignContest:String = "NoviceSignContest";//新手引导报名比赛
        public static const NoviceSignContestConfirm:String = "NoviceSignContestConfirm";//新手引导报名比赛确认
        public static const NoviceListChange:String = "NoviceListChange";//新手引导列表滚动
        public static const NoviceListFinish:String = "NoviceListFinish";//新手引导列表滚动完成
        public static const CloseNovice:String = "CloseNovice";//关闭新手引导


        public static const AndroidReturnKey:String = "AndroidReturnKey"; //android 返回键

        public static const AppPaySuccess:String = "AppPaySuccess";//app购买成功
        public static const AppOrderCheckOk:String = "AppOrderCheckOk";


        public static const PaoOneReset:String = "PaoOneReset";
        public static const YylyLoginComplete:String = "YylyLoginComplete";
        public static const CocosNativeLoginComplete:String = "CocosLoginComplete";

        //7.4-11的世界杯活动
        public static const BettingSuccess:String = "stcBettingSuccess";//下注成功信息
        public static const StcUserGetMoneyPrize:String = "StcUserGetMoneyPrize";//发奖金
        public static const OnSyncBetData:String = "OnSyncBetData";//同步中信息
        public static const OnEndWorldCupExchange:String = "OnEndWorldCupExchange";//世界杯活动兑换成功

        //转盘活动
        public static const WheelExchange:String = "WheelExchange";
        public static const WheelStart:String = "WheelStart";
        public static const UpdateWheel:String = "UpdateWheel";
        public static const WheelscoreUpdate:String = "WheelscoreUpdate";
        public static const WheeltipsUpdate:String = "WheeltipsUpdate";
        public static const UpdataWheelMidAutumn:String = "UpdataWheelMidAutumn";//转盘中秋节活动
        //关注公众号
        public static const SyncSubscriptionIco:String = "SyncSubscriptionIco";
        public static const UpdateGiftlist:String = "UpdateGiftlist";
        public static const SubDisabled:String = "SubDisabled";
        public static const ResetSubBtn:String = "ResetSubBtn";
        public static const Closesubpanel:String = "Closesubpanel";


        //活动
        public static const ActRegister:String = "ActRegister";    //签到
        public static const ActCurrency:String = "ActCurrency";    //刷新账户
        public static const ActCdk:String = "ActCdk";              //cdk接收
        public static const CloseAccount:String = "CloseAccount";
        public static const ExchangeTime:String = "ExchangeTime";   //剩余兑换次数

        //        更换双倍倍率和命中
        public static const BatteryRateChagne:String = "BatteryRateChagne";

        //播放广告
        public static const ShowAd:String = "ShowAd";
        public static const OnSyncAdWatchRemainTimes:String = "OnSyncAdWatchRemainTimes";


        //匹配赛
        public static const MatchingGameSynState:String = "MatchingGameSynState";//同步匹配赛开始前状态
        public static const MatchingSynRusultMsg:String = "MatchingSynRusultMsg";//匹配赛结算信息
        public static const MatchingSynRoomData:String = "MatchingSynRoomData";//同步匹配赛房间信息
        public static const MatchingGameAgainStart:String = "MatchingGameAgainStart";//同步匹配赛房间信息
        public static const SynFindMatchGameData:String = "SynFindMatchGameData";//通过房间号查到比赛信息返回


        public static const isCollect:String = "isCollect";//是否领取过收藏奖励
        public static const LoadMiniAdRes:String = "LoadMiniAdRes";
        public static const LoadSecondMainfest:String = "LoadSecondMainfest";
        public static const syncShortData:String = "syncShortData";

        public static const SyncCertificationInfo:String = "SyncCertificationInfo";

        //同步喇叭任务数据
        public static const SynRedData:String = "SynRedData"; //刷新喇叭数据
        public static const SynTaskCoinData:String = "SynTaskCoinData"; //刷新任务金币数据
        public static const SynBindCode:String = "SynBindCode";
        public static const UpdateExchangeBtn:String = "UpdateExchangeBtn";

        //打开银行事件

        public static const SynBankBindSuccess:String = "SynBankBindSuccess";
        public static const OpenBankView:String = "OpenBankView";
        public static const SynRankReward:String = "SynRankReward";
        public static const RankAniRefesh:String = "RankAniRefesh";
        public static const OpenSubscibe:String = "OpenSubscibe";

        public static const RefreshVirtualList:String = "RefreshVirtualList";
        public static const UpdateJJHAcInfo:String = "UpdateJJHAcInfo"; //更新集结号信息

        public static const refreshApplyFriendList:String = "refreshApplyFriendList";//刷新申请好友列表
        public static const refreshFriendList:String = "refreshFriendList";//刷新好友列表



        //刷新比赛场信息
        public static const RefreshMatchData:String = "RefreshMatchData" //刷新比赛场信息
        public static const CloseOtherBar:String = "CloseOtherBar";//关闭所有滑出bar
        public static const GetIntoMatchRoom:String = "GetIntoMatchRoom" //判断完成 进入比赛房间

        //商城福利倒计时
        public static const ExchangeInterval:String = "ExchangeInterval"


        //每日礼包信息
        public static const UpdFesDailyGift:String = "UpdFesDailyGift";//更新每日礼包信息

        //平台实名认证
        public static const BindInfoTel:String = "BindInfoTel"; //平台实名成功
    }
}
