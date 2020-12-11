package control
{

    import engine.tool.StartParam;

    import manager.WebSocketManager;

    import model.ExchangeM;

    import model.LevelM;
    import model.LoginInfoM;
    import model.RoleInfoM;

    import manager.ConfigManager;
    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.GameSoundManager;
    import manager.GameTools;

    import proto.S2c_10007;
    import proto.S2c_10008;
    import proto.S2c_10009;
    import proto.S2c_16001;
    import proto.S2c_18001;
    import proto.S2c_20001;
    import proto.S2c_20003;
    import proto.S2c_profile;

    public class RoleInfoC
    {
        private static var _instance:RoleInfoC;

        public function RoleInfoC()
        {
            GameEventDispatch.instance.on(String(10004), this, updateProfile);
            GameEventDispatch.instance.on(String(10007), this, syncCurrency);
            GameEventDispatch.instance.on(String(10008), this, syncRes);
            GameEventDispatch.instance.on(String(10009), this, levelUp);
            GameEventDispatch.instance.on(String(14001), this, syncBuyData);
            GameEventDispatch.instance.on(String(16001), this, buffSync);
            GameEventDispatch.instance.on(String(18001), this, updateGoodsItem);
            GameEventDispatch.instance.on(String(20001), this, updateSignIn);
            GameEventDispatch.instance.on(String(20003), this, signInGetAward);
            GameEventDispatch.instance.on(String(10011), this, skillResTipConfirm);
            GameEventDispatch.instance.on(String(15002), this, getReward);
            GameEventDispatch.instance.on(String(10021), this, resetAwardScore);
            GameEventDispatch.instance.on(String(31001), this, syncCoin);
            GameEventDispatch.instance.on(String(12047), this, syncCostCoin);
            GameEventDispatch.instance.on(String(41004), this, ifSubscription);
            GameEventDispatch.instance.on(String(19015), this, syncBindCode);
            GameEventDispatch.instance.on(String(10025), this, syncShortRoleState);
            GameEventDispatch.instance.on(String(50002), this, syncShortData);
            GameEventDispatch.instance.on(String(50004), this, drawReturn);
            GameEventDispatch.instance.on(String(50006), this, drawReturn);
            GameEventDispatch.instance.on(String(50008), this, drawReturn);
        }

        private function syncShortRoleState(data:*):void
        {
            RoleInfoM.instance.short_pf = data.short_pf

        }

        private function syncBuyData(data:*):void
        {
            if (data.code == 0)
            {
                WebSocketManager.instance.send(50001, {})
            }else if (data.code == 1)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "重复购买")
            }else if (data.code == 2)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent,"金币不足")
            }
        }

        private function drawReturn(re:*):void
        {
            if (re)
            {
                if (re.code == 1)
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "奖励已领取，请勿重复领取")
                } else if (re.code == 2)
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "不合法的ID")
                } else if (re.code == 3)
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "未满足领取条件")
                } else if (re.code == 10)
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "用户身份错误")
                }
            }
        }

        private function syncShortData(re:Object):void
        {
            if (re.code == 0)
            {
                var data = re.short_info;
                RoleInfoM.instance.curDay = data.curday;
                RoleInfoM.instance.total = data.short_charge_total;
                RoleInfoM.instance.receive = data.sign_accept_ids;
                RoleInfoM.instance.pay_accept_ids = data.pay_accept_ids;
                RoleInfoM.instance.level_accept_ids = data.level_accept_ids;
                RoleInfoM.instance.pay_expire = data.pay_expire;
                RoleInfoM.instance.grade_expire = data.grade_expire;
            }
            GameEventDispatch.instance.event(GameEvent.syncShortData);
        }

        private function syncBindCode(data:Object):void
        {
            if (data)
            {
                if (data.wx)
                {
                    ExchangeM.instance.wxBindTicket = data.wx.bind_ticket;
                    ExchangeM.instance.wxExpiredTime = data.wx.expired_time;
                    ExchangeM.instance.wxIsBind = data.wx.is_bind;
                }
                if (data.ali)
                {
                    ExchangeM.instance.alipayBindTicket = data.ali.bind_ticket;
                    ExchangeM.instance.alipayExpiredTime = data.ali.expired_time;
                    ExchangeM.instance.alipayIsBind = data.ali.is_bind;
                }
                GameEventDispatch.instance.event(GameEvent.SynBindCode);
            }
        }

        private function ifSubscription(data:*):void
        {
            if (data.show == 0 || StartParam.instance.getParam("is_display_public_no_subscribe") == 0)
            {
                RoleInfoM.instance.setFirstSubscription(false);//不显示
                GameEventDispatch.instance.event(GameEvent.SyncSubscriptionIco);//关闭主页ico
                GameEventDispatch.instance.event(GameEvent.Closesubpanel);//关闭所有sub相关页
            }
            else if (data.show == 1)
            {
                RoleInfoM.instance.setFirstSubscription(true);//显示
            }
        }

        private function syncCostCoin(data:*):void
        {
            RoleInfoM.instance.setCostCoin(data.cost_coin);
        }

        private function syncCoin(data:*):void
        {
            RoleInfoM.instance.setCoin(data.coin);
            GameEventDispatch.instance.event(GameEvent.UpdateProfile);
        }

        private function resetAwardScore(data:*):void
        {

            RoleInfoM.instance.setAwardScore(0);
            GameEventDispatch.instance.event(GameEvent.UpdateProfile);
        }

        private function getReward(data:*):void
        {
            if (0 == data.code)
            {
                RoleInfoM.instance.setFcoin(data.fish_coin);
                RoleInfoM.instance.setFcount(0);
                GameEventDispatch.instance.event(GameEvent.UpdateProfile);
            }
        }

        private function skillResTipConfirm(data:*):void
        {
            RoleInfoM.instance.setSkillResTip(1);
        }


        private function updateSignIn(data:*):void
        {
            var protoData:S2c_20001 = new S2c_20001()
            protoData.award_get = data['award_get'];
            protoData.day = data['day'];
            RoleInfoM.instance.updateSignInData(protoData.day, protoData.award_get);
            if (data['pop_rank'] == 0 || data['pop_rank'] == 1)
            {
                LevelM.instance.isPopupRankPage = data['pop_rank'];
            }
            GameEventDispatch.instance.event(GameEvent.SignInUpdate);
        }

        private function signInGetAward(data:*):void
        {
            var protoData:S2c_20003 = data as S2c_20003;
            if (0 == protoData.code)
            {
                RoleInfoM.instance.updateSignInData(protoData.day, protoData.award_get);
                GameEventDispatch.instance.event(GameEvent.SignInUpdate);
            }
        }

        private function updateGoodsItem(data:*):void
        {
            var protoData:S2c_18001 = data as S2c_18001;
            RoleInfoM.instance.updateGoodsItem(protoData.goods, protoData.num);
            GameEventDispatch.instance.event(GameEvent.GoodsUpdate);
        }

        private function buffSync(data:*):void
        {
            var protoData:S2c_16001 = data as S2c_16001;
            GameEventDispatch.instance.event(GameEvent.BuffUpdate);
        }

        //发消息
        private function levelUp(data:*):void
        {
            var levelInfo:S2c_10009 = data as S2c_10009;
            RoleInfoM.instance.setLevel(levelInfo.level)
            var soundPath:String = ConfigManager.getConfValue("cfg_global", 1, "level_up_sound") as String;
            GameSoundManager.playSound(soundPath);
            var countArr:Array = LevelM.instance.getCountArr(levelInfo.level);
            var goodsArr:Array = LevelM.instance.getGoodsArr(levelInfo.level);
            GameEventDispatch.instance.event(GameEvent.UpgradeC, [goodsArr, countArr]);
            //首充图标
            GameEventDispatch.instance.event(GameEvent.UpdateFirstCharge);
            YylyC.RoleLevelUp(levelInfo.level);
        }

        private function syncRes(data:*):void
        {
            var res:S2c_10008 = data as S2c_10008;
            RoleInfoM.instance.setCoin(res.coin);
            RoleInfoM.instance.setExp(res.exp);
            RoleInfoM.instance.setFcoin(res.fcoin);
            RoleInfoM.instance.setFcount(res.fcount);
            RoleInfoM.instance.setDiamond(res.diamond);
            RoleInfoM.instance.setBindCoin(res.bcoin);
            RoleInfoM.instance.setContestScore(res.cscore);
            GameEventDispatch.instance.event(GameEvent.UpdateProfile);
        }

        private function syncCurrency(data:*):void
        {
            var currency:S2c_10007 = data as S2c_10007;
            if (GameConst.currency_coin == currency.type)
            {
                RoleInfoM.instance.setCoin(currency.num);
            }
            if (GameConst.currency_diamond == currency.type)
            {
                RoleInfoM.instance.setDiamond(currency.num);
            }
            if (GameConst.currency_bind_coin == currency.type)
            {
                RoleInfoM.instance.setBindCoin(currency.num);
            }
            GameEventDispatch.instance.event(GameEvent.UpdateProfile);
        }

        private function updateProfile(data:*):void
        {

            data = data["a"]
            var mapDic:Array = [
                "name",//0
                "level",//1
                "vip",//2
                "vip_exp",//3
                "exp",//4
                "fish_coin",//5
                "battery",//6
                "coin",//7
                "skins",//8
                "cskin",//9
                "diamond",//10
                "goods",//11
                "purchased_items",//12
                "vip_buy",//13
                "task_new",//14
                "task_daily",//15
                "create_time",//16
                "task_daily_ids",//17
                "charge_total",//18
                "charge_times",//19
                "first_charge_reward_accepted",//20
                "skill_res_tip",//21
                "login_days",//22
                "award_score",//23
                "avatar",//24
                "red_points",//25
                "day_index",//26
                "month_card",//27
                "puuid",//28
                "exchange",//29
                "bcoin",//30
                "at_coin",//31
                "wxmini_balance",//32
                'is_set_bank_password',//33
                'bank_gold',//34
                'worldcup_battery_accepted',//35
                "worldcup_coin",//36
                "is_bind_tel",//37
                "tel",//38
                "guide_status"//39
            ];
            RoleInfoM.instance.init_time_skins(data[40])

            RoleInfoM.instance.coin_rate = data[41]
            RoleInfoM.instance.chance_rate = data[42]

            RoleInfoM.instance.coin_rate_buy = data[43]
            RoleInfoM.instance.chance_rate_buy = data[44]
            ExchangeM.instance._platform = data[45]
            RoleInfoM.instance.setUserBindInfo(data[46])
            var obj:Object = {}
            data = data as Array;
            for (var i = 0; i < data.length; i++)
            {
                obj[mapDic[i]] = data[i]
            }
            var profileData:S2c_profile = obj as S2c_profile;
            RoleInfoM.instance.setProfileInfo(profileData);
            RoleInfoM.instance.puuid = obj["puuid"]

            var is360:Boolean = StartParam.instance.getParam("platform") == GameConst.platform_360

            if (is360)
            {
                if (GameTools.getUrlParamValue('is_new') == 1)
                {
                    T360C.initNickname()
                }

            }

            //            if (StartParam.instance.getParam("platform") == GameConst.platform_360)
            //            {
            //                T360C.initNickname()
            //            }

            GameEventDispatch.instance.event(GameEvent.UpdateProfile);


        }

        public static function get instance():RoleInfoC
        {
            return _instance || (_instance = new RoleInfoC());
        }
    }
}
