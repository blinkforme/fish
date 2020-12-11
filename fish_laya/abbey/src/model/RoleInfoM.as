package model
{
    import control.YylyC;

    import conf.cfg_global;

    import manager.ConfigManager;
    import manager.GameConst;

    import proto.S2c_profile;

    public class RoleInfoM
    {

        private var _name:String;
        private var _level:int;
        private var _vip:int;
        private var _vip_exp:int;
        private var _coin:int;
        private var _diamond:int;
        private var _exp:int;
        private var _fcount:int;//奖金池鱼数量
        private var _fcoin:int;//奖金池中的金币
        private var _battery:int; //炮台等级


        private var _cskin:int; //当前皮肤
        private var _skins:Array; //当前拥有的皮肤

        public var _timesSkins:Array = [];//限时皮肤

        private var _goods:Array; //拥有的道具 {[i=x,n=x]} i=>id n=>num

        private var vip_buy:Array; //vip领取过的奖励
        private var purchased_items:Array; //购买过的商品
        private var task_new:Array = []; //新手任务数据
        private var task_daily:Object = {f: {}, good: {}}; //日常任务数据
        private var task_daily_ids:Array; //日常任务ids
        private var create_time:int; //创建时间
        private var day_index:int; //第几天
        private var charge_times:int;//充值次数
        private var charge_total:int;//充值总金额
        private var first_charge_reward_accepted:int;//是否领取过首充奖励
        private var firstSubscription:Boolean;//是否已关注过公众号
        private var login_days:int;//累计登陆

        private var month_card:Array = new Array();//月卡信息

        private var _sign_in_day:int; //当前是签到第几天
        private var _sign_award_get:int; //签到数据
        private var _skill_res_tip:int; //是否提示过用钻石购买道具并确认
        private var _award_score:Number = 0;//用户积分
        private var _award_value:int; //可领取的奖励

        private var red_points:int;

        public var avatar:String;//用户头像

        private var _cost_coin:int; //当前赚或者获取的金币
        private var _exchange:int;//兑换券
        private var _bcoin:int; //绑定金币
        private var _timeStamp:int; //

        public var activity_ticket:int;//福利活动
        public var is_set_bank_password:int;//是否设置银行密码
        public var is_bind_tel:int;//是否绑定集结号
        public var tel:String;//手机号
        public var jjhNumber:String;//集结号账号
        public var jjhId:String;//集结号id
        public var jjhPass:String;//集结号密码
        public var bankPass:String;//银行密码
        public var phoneNum:String;//注册手机号
        public var reenter:int = 0;//是否重新登入
        public var isQuickRegister:int = 0;//是否快速注册账号:1-是，0-否

        public var bank_gold:int;//银行金币
        public var mini_balance:int;//集结币
        public var _contest_coin:int;
        public var _contest_score:int;
        public var worldcup_battery_accepted:int;
        public var worldcup_coin:int;
        public var guide_status:Object = {}
        public var _SyncSwish:Number = 1; //同步银行金币开关


        //短链接活动
        public var short_pf:Number; //短信用户状态： 0-不是此渠道;1-是此渠道，新用户;2-是此渠道，老用户
        public var curDay = 0; //短信活动签到第几天
        public var total = 0; //短信活动当前消费总金额
        public var receive = []; //已经领取的签到id
        public var pay_accept_ids = []; //已经领过的充值奖励
        public var level_accept_ids = []; //已经领过的升级奖励
        public var pay_expire = 0;//充值返喇叭活动是否到期
        public var grade_expire = 0;//冲级返喇叭活动是否到期

        public var coin_rate:Number;
        public var chance_rate:Number;
        public var coin_rate_buy:Number;
        public var chance_rate_buy:Number;

        public var user_bind_info:Object;

        //订阅信息
        public var subscribe_tpl:Array = [];

        public function canDoubelCoin():Boolean
        {
            return coin_rate_buy == 1
        }

        public function canDoubelChance():Boolean
        {
            return chance_rate_buy == 1
        }

        private static var _instance:RoleInfoM;

        public function RoleInfoM()
        {
            _name = "unsync";
            _level = 0;
            _vip = 0;
            _coin = 0;
            _award_score = 0;
            _award_value = 0;
            _cost_coin = 0;
            _bcoin = 0;
            mini_balance = 0;
            var date:Date = new Date();
            _timeStamp = date.getTime();
        }

        public function isConsumeEnough(conId:Number, conNum):Boolean
        {
            if (conId == GameConst.currency_coin)
            {
                return _coin >= conNum;
            }
            if (conId == GameConst.currency_diamond)
            {
                return _diamond >= conNum;
            }
            for (var i:int = 0; i < _goods.length; i++)
            {
                if (_goods[i].i == conId)
                {
                    if (_goods[i].n >= conNum)
                    {
                        return true;
                    }
                    return false;
                }
            }
            return false;
        }

        public function subscribeState(type:int):Number
        {
            for (var i = 0; i < subscribe_tpl.length; i++)
            {
                if (subscribe_tpl[i].id && subscribe_tpl[i].id == type)
                {
                    return subscribe_tpl[i].is_remember
                }
            }
            return 0
        }

        public function subsState(type:int):Boolean
        {
            for (var i = 0; i < subscribe_tpl.length; i++)
            {
                if (subscribe_tpl[i].id && subscribe_tpl[i].id == type)
                {
                    return subscribe_tpl[i].status == "accept"
                }
            }
            return false
        }

        public function calcRed():Array
        {
            var A:Number = 0;
            var B:Number = 0;
            var C:Number = 0;
            var arr_red:Array;
            var config_rech:Array = ConfigManager.items("cfg_rech_award");
            var config_up:Array = ConfigManager.items("cfg_upgradeRed");
            var arr_re:Array = RoleInfoM.instance.receive;
            var arr_pay:Array = RoleInfoM.instance.pay_accept_ids;
            var arr_lv:Array = RoleInfoM.instance.level_accept_ids

            for (var i = 0; i < config_rech.length; i++)
            {
                if (total < config_rech[i].rechSum)
                {
                    break;
                }
            }

            for (var j = 0; j < config_up.length; j++)
            {
                if (_level < config_up[j].level)
                {
                    break;
                }
            }

            if (arr_re.length - 1 < curDay)
            {
                A = 1
            } else
            {
                A = 0
            }

            if (arr_pay.length < i + 1)
            {
                B = 1
            } else
            {
                B = 0
            }

            if (arr_lv.length < j + 1)
            {
                C = 1
            } else
            {
                C = 0
            }

            if (RoleInfoM.instance.short_pf != 2)
            {
                arr_red = [A, B, C]
            } else
            {
                arr_red = [A, B]
            }

            return arr_red;
        }

        public function getTimeStamp():Number
        {
            return _timeStamp;
        }

        public function setTimeStamp(stamp:int):void
        {
            _timeStamp = stamp;
        }

        public function getExchange():int
        {
            return (_exchange) as Number;
        }

        public function setExchange(exchange:int):void
        {
            _exchange = exchange
        }

        public function getCostCoin():int
        {
            return _cost_coin;
        }

        public function setCostCoin(value:int):void
        {
            _cost_coin = value;
        }

        public function getUserBindInfo():Object
        {
            return user_bind_info;
        }


        public function setUserBindInfo(value:Object):void
        {
            user_bind_info = value
        }

        public function isSkinExit(skinId:int):Boolean
        {
            return _skins.indexOf(skinId) > -1;
        }

        public function setContestCoin(value:int):void
        {
            _contest_coin = value;
        }

        public function getContestCoin():int
        {
            return _contest_coin;
        }

        public function setContestScore(value:int):void
        {
            _contest_score = value;
        }

        public function getContestScore():int
        {
            return _contest_score;
        }

        public function setAwardScore(score:Number):void
        {
            _award_score = score;
        }

        public function getAwardScore():Number
        {
            return _award_score;
        }

        public function getAwardValue():int
        {
            return _award_value;
        }

        public function setAwardValue(value:int):void
        {
            _award_value = value;
        }

        public function getRedPoints():int
        {
            return red_points;
        }

        public function setRedPoints(value:int):void
        {
            red_points = value;
        }

        public function getLoginDays():int
        {
            return login_days;
        }

        public function setLoginDays(value:int):void
        {
            login_days = value;
        }

        public function getVipBuy():Array
        {
            return vip_buy;
        }

        public function setVipBuy(value:Array):void
        {
            vip_buy = value;
        }

        public function getMonthCard():Array
        {
            return month_card;
        }

        public function setMonthCard(value:Array):void
        {
            month_card = value;
        }

        public function setChargeTotal(value:int):void
        {
            charge_total = value;
        }

        public function getChargeTotal():int
        {
            return charge_total;
        }

        public function setChargeTimes(value:int):void
        {
            charge_times = value;
        }

        public function getChargeTimes():int
        {
            return charge_times;
        }

        public function setFirstChargeRewardAccepted(value:int):void
        {
            first_charge_reward_accepted = value;
        }

        public function getFirstChargeRewardAccepted():int
        {
            return first_charge_reward_accepted;
        }

        public function setFirstSubscription(value:Boolean):void
        {
            firstSubscription = value;
        }

        public function getFirstSubscription():int
        {
            return firstSubscription;
        }

        public function setDayIndex(value:int):void
        {
            day_index = value;
        }

        public function getDayIndex():int
        {
            return day_index;
        }

        public function getTaskNew():Array
        {
            return task_new;
        }

        public function setTaskNew(value:Array):void
        {
            task_new = value;
        }

        public function updateTaskNew(value:Object):void
        {
            for (var key in value)
            {
                task_new[key as Number] = value[key as Number]
            }
        }

        public function getTaskDaily():Object
        {
            return task_daily;
        }

        public function setTaskDaily(value:Object):void
        {
            task_daily = value;
        }

        public function updateTaskDaily(value:Object):void
        {
            for (var key:String in value)
            {
                if (key == "f")
                {
                    for (var attrname in value.f)
                    {
                        task_daily.f[attrname] = value.f[attrname];
                    }
                } else if (key == "goods")
                {
                    for (var attrname in value.goods)
                    {
                        task_daily.goods[attrname] = value.goods[attrname];
                    }
                    //                    Object.assign(task_daily.goods,value.goods)
                } else
                {
                    task_daily[key] = value[key];
                }
            }
        }


        public function getTaskDailyIds():Array
        {
            if (Array.isArray(task_daily_ids))
            {
                return task_daily_ids
            } else
            {
                return []
            }
        }

        public function setTaskDailyIds(value:Array):void
        {
            task_daily_ids = value;
        }

        public function getPurchasedItems():Array
        {
            return purchased_items;
        }

        public function setPurchasedItems(value:Array):void
        {
            purchased_items = value;
        }

        public static function get instance():RoleInfoM
        {
            return _instance || (_instance = new RoleInfoM());
        }

        public function setProfileInfo(profileData:S2c_profile):void
        {
            _name = profileData.name;
            if (_level <= 0)
            {
                YylyC.RoleLevelUp(profileData.level);
            }
            _level = profileData.level;
            _vip = profileData.vip;
            _vip_exp = profileData.vip_exp;
            _coin = profileData.coin;
            _exp = profileData.exp;
            _fcount = profileData.fish_coin.count;
            _fcoin = profileData.fish_coin.value;
            _cskin = profileData.cskin;
            _battery = profileData.battery;
            _skins = profileData.skins;
            _diamond = profileData.diamond;
            _goods = profileData.goods;
            _award_score = profileData.award_score;

            purchased_items = profileData.purchased_items;
            vip_buy = profileData.vip_buy;
            task_new = profileData.task_new;
            task_daily = profileData.task_daily;
            create_time = profileData.create_time;
            day_index = profileData.day_index;
            task_daily_ids = profileData.task_daily_ids;
            charge_total = profileData.charge_total;
            charge_times = profileData.charge_times;
            first_charge_reward_accepted = profileData.first_charge_reward_accepted;
            red_points = profileData.red_points;


            month_card = profileData.month_card;

            login_days = profileData.login_days;
            _skill_res_tip = profileData.skill_res_tip;
            avatar = profileData.avatar;
            _exchange = profileData.exchange;
            _bcoin = profileData.bcoin;
            activity_ticket = profileData.at_coin;
            is_set_bank_password = profileData.is_set_bank_password
            bank_gold = profileData.bank_gold

            //mini_balance = profileData.wxmini_balance;

            worldcup_battery_accepted = profileData.worldcup_battery_accepted;
            worldcup_coin = profileData.worldcup_coin

            is_bind_tel = profileData.is_bind_tel
            tel = profileData.tel

            guide_status = profileData.guide_status
        }

        public function getAvatar():String
        {
            return avatar;
        }

        public function setSkillResTip(value:int):void
        {
            _skill_res_tip = value;
        }

        public function isSkillResTip():Boolean
        {
            return _skill_res_tip == 1;
        }

        public function setCreateTime(value:int):void
        {
            create_time = value;
        }

        public function getCreateTime():int
        {
            return create_time;
        }

        public function setName(name:String):String
        {
            this._name = name
        }

        public function getName():String
        {
            return _name;
        }

        public function setLevel(curLevel:int):void
        {
            _level = curLevel;
        }

        public function getLevel():int
        {
            return _level;
        }


        public function setVipExp(value:int):void
        {
            _vip_exp = value
        }

        public function getVipExp():int
        {
            return _vip_exp
        }

        public function setVip(value:int):void
        {
            _vip = value
        }

        public function getVip():int
        {
            return _vip;
        }

        public function getCoin():int
        {
            return _coin;
        }

        public function setCoin(num:int):void
        {
            _coin = num;
        }

        public function getBindCoin():int
        {
            return _bcoin;
        }

        public function setBindCoin(num:int):void
        {
            _bcoin = num;
        }

        public function getDiamond():int
        {
            return _diamond;
        }

        public function setDiamond(num:int):void
        {
            _diamond = num;
        }

        public function getExp():int
        {
            return _exp;
        }

        public function setExp(value:int):void
        {
            _exp = value;
        }

        public function getFcount():int
        {
            return _fcount;
        }

        public function setFcount(count:int):void
        {
            _fcount = count;
        }

        public function getFcoin():int
        {
            return _fcoin;
        }

        public function setFcoin(value:int):void
        {
            _fcoin = value;
        }

        public function getBattery():int
        {
            return _battery;
        }

        public function setBattery(value:int):void
        {
            _battery = value;
        }

        public function getCurSkin():int
        {
            return _cskin;
        }

        public function setCurSkin(skin:int):void
        {
            _cskin = skin;
        }

        public function getSkins():Array
        {
            return _skins;
        }

        public function setSkins(value:Array):void
        {
            _skins = value;
        }

        public var time_skin_data:Object = {};

        // 初始化限时皮肤
        public function init_time_skins(data:Array)
        {
            time_skin_data = {}
            _timesSkins = []
            for (var i = 0; i < data.length; i += 3)
            {
                var key = data[i] + ""
                var remain_day:Number = data[i + 1]
                if (remain_day > 0)
                {
                    _timesSkins.push(data[i])
                }
                time_skin_data[key] = {"remain": data[i + 1]}
            }
        }

        //判断拥有而且是限时的皮肤,
        // 返回正数则为剩余的时间，
        // 返回-1则没有该限时皮肤
        public function getSkinRemainTime(skin_id:Number):Number
        {
            if (RoleInfoM.instance.getSkins().indexOf(skin_id) > -1)
            {
                return -1
            } else
            {
                var skin_data:Object = time_skin_data[skin_id + ""]
                if (skin_data)
                {
                    var remain:Number = skin_data['remain']
                    if (remain > 0)
                    {
                        return remain
                    } else
                    {
                        return -1
                    }
                } else
                {
                    return -1
                }

            }
        }


        public function getAllSkins():Array
        {
            if (_timesSkins.length <= 0)
            {
                return _skins;
            }
            var allskins:Array = [];
            var skinId:int
            for (var i:int = 0; i < _timesSkins.length; i++)
            {
                skinId = _timesSkins[i];
                if (!checkHaveSkin(skinId))
                {
                    allskins.push(skinId);//添加 拼合
                }
            }
            allskins = allskins.concat(_skins);
            return allskins;
        }


        public function findTypeId(_id:int):int
        {
            var popArr:Array = ConfigManager.filter("cfg_goods");
            var skinId:int;
            for (var i:int = 0; i < popArr.length; i++)
            {
                if (popArr[i]['id'] == _id)
                {
                    skinId = popArr[i]['typeID'];
                    return skinId;
                }
            }
            return null;
        }

        private function checkHaveSkin(_id:int):Boolean
        {
            var _playerArr:Array = _skins;
            for (var i:int = 0; i < _playerArr.length; i++)
            {
                if (_playerArr[i] == _id)
                {
                    return true;
                }
            }
            return false;
        }


        public function getGoods():Array
        {
            return _goods;
        }

        public function setGoods(value:Array):void
        {
            _goods = value;
        }

        public function getGoodsItemNum(goodsId:int):int
        {
            var goodsItem:Object;
            for (var i:int = 0; i < _goods.length; i++)
            {
                goodsItem = _goods[i] as Object;
                if (goodsItem.i == goodsId)
                {
                    return goodsItem.n;
                }
            }
            return 0;
        }

        public function updateGoodsItem(goodsId:int, num:int):void
        {
            var goodsItem:Object;
            for (var i:int = 0; i < _goods.length; i++)
            {
                goodsItem = _goods[i] as Object;
                if (goodsItem.i == goodsId)
                {
                    goodsItem.n = num;
                    return;
                }
            }
            goodsItem = new Object();
            goodsItem.i = goodsId;
            goodsItem.n = num;
            _goods[_goods.length] = goodsItem;
        }


        public function updateSignInData(day:int, award_get:int):void
        {
            _sign_in_day = day;
            _sign_award_get = award_get;
        }


        public function getSignInStatus(day:int):int
        {
            var ret:int = 0;
            if (day > _sign_in_day)
            {
                return GameConst.sign_in_not_reach;
            }
            if (day <= _sign_award_get)
            {
                return GameConst.sign_in_getted;
            }

            return GameConst.sign_in_getting;
        }

        /**
         * 是否有生效的月卡
         *
         * @return
         */
        public function haveValidMonthCard():Boolean
        {
            for (var id in month_card)
            {
                if (!month_card[id].is_expired)
                {
                    return true
                }
            }
            return false
        }

    }
}
