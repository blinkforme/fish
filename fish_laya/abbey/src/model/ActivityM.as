package model
{
    import control.WxC;

    import conf.cfg_goods;

    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.GameTools;

    public class ActivityM
    {

        public var activity_data:Array = [];
        public var activity_status:Object = {};

        //        是否在世界杯抽奖中
        public var is_in_worldcup_lottery:Boolean = false
        private static var _instance:ActivityM;

        public var is_reward:Number;
        public var is_receive:Number;
        public var bet_teams:Array = [];//下注列表

        //{football_total:1000000gold_total:100000win_team_id:8}
        public var worldcup_info:Object = {};

        //-----------------公共活动界面--------------------

        private var _loginShowActivityPannel:Boolean = false;
        private var _loginNew:Boolean = false;

        private var _activityMoneyConfig:Object;//活动券图片
        private var _activityPictureConfig:Array;//活动界面图片4+2红点类型图标
        private var _activityExplainConfig:Array;//活动说明图片

        private var _firstRankList:Object = {score: 0, rank: 0, rank_arr: []};
        private var _secondRankList:Object = {score: 0, rank: 0, rank_arr: []};
        private var _thirdRankList:Object = {score: 0, rank: 0, rank_arr: []};
        private var _airBalloonRank:Array;
        private var _rankRewards:Array;

        public var betData:Array = [];
        public var actRegister_data:Array;
        public var actRegister_time:Number;
        public var actCurrency_data:Array;
        public var sub_activity_status:Object = {};
        public var exchange_times:Array = [];
        public var is_exchange:Number;
        public var cdkeys_id:String;

        private var hitBalloonArr_81:Array;
        private var hitBalloonArr_82:Array;
        private var hitBalloonArr_83:Array;

        //兑换界面
        private var _countDownTimes:Number = 10;//单位s
        private var _countDownArr:Object = {};
        private var _isRefresh:Boolean = false;
        //每日礼包
        private var _fesDailyGiftInfo:Object = {};

        //福利商城购买间隔
        public var exchangeInterval = 0;

        public function ActivityM()
        {

        }

        public static function get instance():ActivityM
        {
            return _instance || (_instance = new ActivityM());
        }

        public function countDownLoop():void
        {
            _isRefresh = false;
            for (var i in ActivityM.instance.countDownArr)
            {
                if (ActivityM.instance.countDownArr[i] > 0)
                {
                    ActivityM.instance.countDownArr[i]--;
                    _isRefresh = true;
                }
            }
            if (_isRefresh)
            {
                GameEventDispatch.instance.event(GameEvent.RefreshVirtualList);
            }
        }

        public function exchangeConversion(id:Number, num:Number):Number
        {
            var endNum:Number = num;
//            if (id == GameConst.currency_exchange)
//            {
//                endNum = (num / 100).toFixed(2) as Number;
//            }
            return endNum;
        }

        public function getExchangeConversionDesc(id:Number, num:Number):String
        {
            var val:Number = this.exchangeConversion(id, num);
            var ret:String = GameTools.getItemCoinStr(val);
            return ret;
        }

        public function _getCommonActivityConfig(module:Number):Object
        {
            if (_getActivityData(GameConst.activity_common))
            {
                var typeArr:Array = _getActivityData(GameConst.activity_common)["sub_activity"];
                if (typeArr)
                {
                    for (var i = 0; i < typeArr.length; i++)
                    {
                        if (typeArr[i]["id"] == module)
                        {
                            return typeArr[i]["config"]
                        }
                    }
                }
            }
            return null;
        }

        public function getRewardPageExtra(id:Number):Array
        {
            if (_getCommonActivityConfig(GameConst.activity_common_rew))
            {
                return _getCommonActivityConfig(GameConst.activity_common_rew)["lottery_extra"][id];
            }
            return null;
        }

        public function actCurrency(coin_type):Number
        {
            for (var i = 0; i < actCurrency_data.length; i++)
            {
                if (actCurrency_data[i].coin_type == coin_type)
                {
                    return actCurrency_data[i].value;
                }
            }
            return 0;
        }

        public function getGoodsNum(id:Number):Number
        {
            if (id == GameConst.currency_coin)
            {
                return RoleInfoM.instance.getCoin()
            } else if (id == GameConst.currency_diamond)
            {
                return RoleInfoM.instance.getDiamond();
            }else if (id == GameConst.currency_exchange)
            {
                return RoleInfoM.instance.getExchange();
            } else
            {
                return ActivityM.instance.actCurrency(id);
            }
        }

        public function get actRegisterDate():Array
        {
            return actRegister_data;
        }

        public function set actRegisterDate(arr:Array):void
        {
            actRegister_data = arr;
        }

        public function get actRegisterTime():Number
        {
            return actRegister_time;
        }

        public function set actRegisterTime(day:Number):void
        {
            actRegister_time = day;
        }

        public function activeImg():Array
        {
            var active_img:Array = [];
            if (isShowShopRebate)
            {
                active_img.push(
                        {img: {skin: _activityExplainConfig[0]}, view: "shop"}
                )
            }
            if (isShowShareRebate)
            {
                if (WxC.isInMiniGame())
                {
                    active_img.push(
                            {img: {skin: _activityExplainConfig[1]}, view: "Share"}
                    )
                }
            }
            if (isShowSinceRebate)
            {
                active_img.push(
                        {img: {skin: _activityExplainConfig[2]}, view: "Match"}
                )
            }
            if (isShowDailyGift)
            {
                active_img.push(
                        {img: {skin: _activityExplainConfig[3]}, view: "Lottery"}
                )
            }

            if(isShowMatchActivity)
            {
                active_img.push(
                        {img: {skin: _activityExplainConfig[4]}, view: "MatchGame"}
                )
            }

            if (isShowDirectChanges)
            {
                active_img.push(
                        {img: {skin: _activityExplainConfig[6]}, view: "Rank"}
                )
            }

            return active_img;
        }

        public function set exchangeTimes(arr:Array):void
        {
            exchange_times = arr;
        }

        public function get exchangeTimes():Array
        {
            return exchange_times
        }

        public function set exchange(re:Number):void
        {
            is_exchange = re;
        }

        public function get exchange():Number
        {
            return is_exchange;
        }

        public function set giftCdk(data:String):void
        {
            cdkeys_id = data;
        }

        public function get giftCdk():String
        {
            return cdkeys_id;
        }

        public function _getActivityData(activity_type:String):Object
        {
            if (activity_data == null)
            {
                return null
            }
            for (var i = 0; i < activity_data.length; i++)
            {
                if (activity_data[i]["type"] == activity_type)
                {
                    return activity_data[i]
                }
            }
            return null
        }

        public function getActivityData(activity_type:String):Object
        {
            if (GameConst.activity_bonus == activity_type)
            {
                return _getActivityData(GameConst.activity_bonus)
            } else if (GameConst.activity_bomb == activity_type)
            {
                return _getActivityData(GameConst.activity_bomb)

            } else if (GameConst.activity_worldcup == activity_type)
            {
                return _getActivityData(GameConst.activity_worldcup)
            } else if (GameConst.activity_wheel == activity_type)
            {
                return _getActivityData(GameConst.activity_wheel)
            } else if (GameConst.activity_common == activity_type)
            {
                return _getActivityData(GameConst.activity_common)
            } else if (GameConst.activity_rank == activity_type)
            {
                return _getActivityData(GameConst.activity_rank)
            } else if (GameConst.activity_red_pack == activity_type)
            {
                return _getActivityData(GameConst.activity_red_pack)
            } else
            {
                return null
            }
        }

        public function worldCupActivityBatteryCanBuy():Boolean
        {
            //            世界杯炮台是否可以购买
            return ActivityM.instance.activityIsExtraTime(GameConst.activity_worldcup)
        }

        public function getShopExtraArrByShopId(commodity_id:Number, activity_type:String)
        {
            var activityData:Object = getActivityData(activity_type)
            if (!activityData)
            {
                return null
            }

            if (activityData)
            {
                if (activity_type == GameConst.activity_common)
                {
                    var shop_extra:Object = _getCommonActivityConfig(GameConst.activity_common_shop)["shop_buy_extra"];
                } else
                {
                    var shop_extra:Object = activityData["config"]["shop_extra"]
                }
                if (!shop_extra)
                {
                    return null
                }
                var bomb_gift:Array = shop_extra[commodity_id + ""]
                if (bomb_gift)
                {
                    return bomb_gift
                } else
                {
                    return null
                }
            } else
            {
                return null
            }
        }

        public function getActivityExtraTime(activity_type:String):Number
        {
            var activityData:Object = getActivityData(activity_type)
            if (activityData)
            {
                var finish_time:Number = activityData["extra_time"]
                return finish_time
            } else
            {
                return 0;
            }
        }

        public function getActivityEndTime(activity_type:String):Number
        {
            var activityData:Object = getActivityData(activity_type)
            if (activityData)
            {
                var finish_time:Number = activityData["finish_time"]
                return finish_time
            } else
            {
                return 0;
            }
        }


        public function showActivityIcon(activity_type:String):Boolean
        {
            var activityData:Object = getActivityData(activity_type)
            if (!activityData)
            {
                return false
            }

            if (activityData)
            {
                var activity_id:Number = activityData.id;
                var activity_status_data:Array = activity_status[activity_id + ""]
                if (activity_status_data)
                {
                    return activity_status_data[0] && !activity_status_data[2]
                } else
                {
                    return false
                }
            } else
            {
                return false
            }
        }

        public function getWinTeamId():Number
        {
            var winTeamId = ActivityM.instance.worldcup_info['win_team_id']
            if (winTeamId)
            {
                return winTeamId
            }
            return 0
        }

        public function worldCupRewardCanAccept():Boolean
        {
            var winTeamId:Number = getWinTeamId()
            return winTeamId > 0
        }


        public function activityIsActive(activity_type:String):Boolean
        {
            var activityData:Object = getActivityData(activity_type)

            if (activityData)
            {
                var activity_id:Number = activityData.id;
                var activity_status_data:Array = activity_status[activity_id + ""]
                if (activity_status_data)
                {
                    return activity_status_data[0] && !activity_status_data[1]
                } else
                {
                    return false
                }
            } else
            {
                return false
            }
        }


        public function activityIsEnd(activity_type:String):Boolean
        {
            var activityData:Object = getActivityData(activity_type)

            if (activityData)
            {
                var activity_id:Number = activityData.id;
                var activity_status_data:Array = activity_status[activity_id + ""]

                if (activity_status_data)
                {
                    return activity_status_data[1]
                } else
                {
                    return false
                }
            } else
            {
                return false
            }

        }

        public function activityIsExtraTime(activity_type:String):Boolean
        {
            var activityData:Object = getActivityData(activity_type)

            if (activityData)
            {
                var activity_id:Number = activityData.id;
                var activity_status_data:Array = activity_status[activity_id + ""]

                if (activity_status_data)
                {
                    return activity_status_data[1] && !activity_status_data[2]
                } else
                {
                    return false
                }
            } else
            {
                return false
            }
        }


        public function activityIsDown(activity_type:String):Boolean
        {
            var activityData:Object = getActivityData(activity_type)

            if (activityData)
            {
                var activity_id:Number = activityData.id;
                var activity_status_data:Array = activity_status[activity_id + ""]

                if (activity_status_data)
                {
                    return activity_status_data[2]
                } else
                {
                    return false
                }
            } else
            {
                return false
            }
        }

        //活动是否在进行中
        public function activityIsProceed(activity_type:String):Boolean
        {
            var activityData:Object = getActivityData(activity_type)

            if (activityData)
            {
                var activity_id:Number = activityData.id;
                var activity_status_data:Array = activity_status[activity_id + ""]

                if (activity_status_data)
                {
                    return activity_status_data[0] && !activity_status_data[2];
                } else
                {
                    return false
                }
            } else
            {
                return false
            }
        }

        private function commonActivityOnOff(module:Number):Boolean
        {
            var activityData:Object = getActivityData(GameConst.activity_common);

            if (activityData)
            {
                var activity_id:Number = activityData.id;
                var sub_activity_status_data:Object = sub_activity_status[activity_id + ""];
                if (sub_activity_status_data)
                {
                    var isStart:Number = sub_activity_status_data[module];
                    if (isStart)
                    {
                        return true;
                    }
                }
            }
            return false;
        }

        public function getHitBalloonArr(grade:Number):Array
        {
            switch (grade)
            {
                case 1:
                    return hitBalloonArr_81;
                case 2:
                    return hitBalloonArr_82;
                case 3:
                    return hitBalloonArr_83;
                default:
                    return null;
            }
        }

        public function setHitBalloonArr(res:*):void
        {
            if (res[GameConst.activity_currency_one].length > 0)
            {
                hitBalloonArr_81 = res[GameConst.activity_currency_one]
            } else
            {
                hitBalloonArr_81 = new Array();
            }

            if (res[GameConst.activity_currency_two].length > 0)
            {
                hitBalloonArr_82 = res[GameConst.activity_currency_two]
            } else
            {
                hitBalloonArr_82 = new Array();
            }

            if (res[GameConst.activity_currency_three].length > 0)
            {
                hitBalloonArr_83 = res[GameConst.activity_currency_three]
            } else
            {
                hitBalloonArr_83 = new Array();
            }

        }

        public function getChooseFlyRankList(grade:Number):Object
        {
            switch (grade)
            {
                case 1:
                    return firstRankList;
                case 2:
                    return secondRankList;
                case 3:
                    return thirdRankList;
                default:
                    return null;
            }
        }

        public function unifiedBalloonRanking(rank:Number):String
        {
            var str:String;
            if (rank == 0)
            {
                str = "暂未排名"
            } else if (rank > 100)
            {
                str = "排名100之外"
            } else
            {
                str = "" + rank;
            }
            return str;
        }

        //单个转换系统是否显示
        //直接兑换
        public function get isShowDirectChanges():Boolean
        {
            return commonActivityOnOff(GameConst.activity_common_directchanges);
        }

        //分享礼盒
        public function get isShowGiftBox():Boolean
        {
            return commonActivityOnOff(GameConst.activity_common_giftbox);
        }

        //排行榜活动 扎气球
        public function get isShowRankActivity():Boolean
        {
            return commonActivityOnOff(GameConst.activity_common_rankactivity);
        }

        //单个产出系统是否显示
        //商场返利（充值）
        public function get isShowShopRebate():Boolean
        {
            return commonActivityOnOff(GameConst.activity_common_shop);
        }

        //渔场内抽奖页面
        public function get isShowRewRebate():Boolean
        {
            return commonActivityOnOff(GameConst.activity_common_rew);
        }

        //活动日常赛
        public function get isShowDayMatchRebate():Boolean
        {
            return commonActivityOnOff(GameConst.activity_common_daymatch);
        }

        //签到奖励
        public function get isShowRegisterRebate():Boolean
        {
            return commonActivityOnOff(GameConst.activity_common_register);
        }

        //分享奖励
        public function get isShowShareRebate():Boolean
        {
            return commonActivityOnOff(GameConst.activity_common_share);
        }

        //第四关奖金池
        public function get isShowSinceRebate():Boolean
        {
            return commonActivityOnOff(GameConst.activity_common_since);
        }

        //每日礼包
        public function get isShowDailyGift():Boolean
        {
            return commonActivityOnOff(GameConst.activity_common_main_daily_gift);
        }

        //主界面排行榜是否开启发送兑换券
        public function get isShowMainRank():Boolean
        {
            return commonActivityOnOff(GameConst.activity_common_main_rank);
        }

        //比赛场活动是否开启
        public function get isShowMatchActivity():Boolean
        {
            return commonActivityOnOff(GameConst.activity_common_main_match);
        }

        //活动是否在进行中
        public function get activityTicketContinueTime():Boolean
        {
            return activityIsProceed(GameConst.activity_common);
        }

        //积分活动（兑换的喇叭送福，渔场免费抽奖，积分兑换）是否在进行中
        public function get redPackTicketContinueTime():Boolean
        {
            return activityIsProceed(GameConst.activity_red_pack);
        }

        public function getBalloonConsume(consumeType:Number):Number
        {
            return ActivityM.instance._getCommonActivityConfig(GameConst.activity_common_rankactivity)["consume"][consumeType + ""];
        }

        public function get firstRankList():Object
        {
            return _firstRankList;
        }

        public function get secondRankList():Object
        {
            return _secondRankList;
        }

        public function get thirdRankList():Object
        {
            return _thirdRankList;
        }

        public function set airBalloonRank(value:Array):void
        {
            _airBalloonRank = value;
            if (_airBalloonRank[GameConst.activity_currency_one])
            {
                _firstRankList["score"] = _airBalloonRank[GameConst.activity_currency_one].score;
                _firstRankList["rank"] = _airBalloonRank[GameConst.activity_currency_one].rank;
                if (_airBalloonRank[GameConst.activity_currency_one].rank_arr)
                {
                    _firstRankList["rank_arr"] = _airBalloonRank[GameConst.activity_currency_one].rank_arr;
                }

            }

            if (_airBalloonRank[GameConst.activity_currency_two])
            {
                _secondRankList["score"] = _airBalloonRank[GameConst.activity_currency_two].score;
                _secondRankList["rank"] = _airBalloonRank[GameConst.activity_currency_two].rank;
                if (_airBalloonRank[GameConst.activity_currency_two].rank_arr)
                {
                    _secondRankList["rank_arr"] = _airBalloonRank[GameConst.activity_currency_two].rank_arr;
                }
            }

            if (_airBalloonRank[GameConst.activity_currency_three])
            {
                _thirdRankList["score"] = _airBalloonRank[GameConst.activity_currency_three].score;
                _thirdRankList["rank"] = _airBalloonRank[GameConst.activity_currency_three].rank;
                if (_airBalloonRank[GameConst.activity_currency_three].rank_arr)
                {
                    _thirdRankList["rank_arr"] = _airBalloonRank[GameConst.activity_currency_three].rank_arr;
                }
            }

        }

        public function get rankRewards():Array
        {
            return _rankRewards;
        }

        public function set rankRewards(value:Array):void
        {
            _rankRewards = value;
        }

        public function get activityPictureConfig():Array
        {
            return _activityPictureConfig;
        }

        public function setCommonImage():void
        {
            if (_getActivityData(GameConst.activity_common))
            {
                if (_getActivityData(GameConst.activity_common)["config"] && _getActivityData(GameConst.activity_common)["config"]["upload_img"])
                {
                    var typeArr:Array = _getActivityData(GameConst.activity_common)["config"]["upload_img"];
                    _activityMoneyConfig = {81: typeArr["volume_img_1"], 82: typeArr["volume_img_2"], 83: typeArr["volume_img_3"]};
                    _activityPictureConfig = [typeArr["items_img_1"], typeArr["items_img_2"], typeArr["items_img_3"],
                        typeArr["items_img_4"], typeArr["items_img_5"], typeArr["items_img_6"]];
                    _activityExplainConfig = [typeArr["propaganda_img_1"], typeArr["propaganda_img_2"], typeArr["propaganda_img_3"],
                        typeArr["propaganda_img_4"], typeArr["propaganda_img_5"], typeArr["propaganda_img_6"], typeArr["propaganda_img_7"]];
                    cfg_goods.instance(81).icon = _activityMoneyConfig[81]
                    cfg_goods.instance(82).icon = _activityMoneyConfig[82]
                    cfg_goods.instance(83).icon = _activityMoneyConfig[83]
                } else
                {
                    _activityMoneyConfig = [];
                    _activityPictureConfig = [null, null, null, null, null, null];
                    _activityExplainConfig = [];
                }
            } else
            {
                _activityMoneyConfig = [];
                _activityPictureConfig = [null, null, null, null, null, null];
                _activityExplainConfig = [];
            }
        }


        public function get loginShowActivityPannel():Boolean
        {
            return _loginShowActivityPannel;
        }

        public function set loginShowActivityPannel(value:Boolean):void
        {
            _loginShowActivityPannel = value;
        }

        public function get loginNew():Boolean
        {
            return _loginNew;
        }

        public function set loginNew(value:Boolean):void
        {
            _loginNew = value;
        }

        public function get countDownTimes():Number
        {
            return _countDownTimes;
        }

        public function set countDownTimes(value:Number):void
        {
            _countDownTimes = value;
        }

        public function get countDownArr():Object
        {
            return _countDownArr;
        }

        public function set countDownArr(value:Object):void
        {
            _countDownArr = value;
        }

        public function getFesDailyGiftInfo(activityCommonId:int):Object
        {
            return this._fesDailyGiftInfo[activityCommonId]
        }

        public function updFesDailyGiftInfo(value:Object):void
        {
            // TODO 调试的时候活动类型强制写成106
            value.multi_at_id = GameConst.activity_common_main_daily_gift;
            var info:Object = this.getFesDailyGiftInfo(value.multi_at_id);
            if (!info)
            {
                this._fesDailyGiftInfo[value.multi_at_id] = value;
            } else
            {
                info.is_exchange = value.is_exchange;
                info.gift_pack_stage = value.gift_pack_stage;
            }
        }

        public function isFesDailyGiftExchanged(activityCommonId:int):Boolean
        {
            var info:Object = this.getFesDailyGiftInfo(activityCommonId);
            return !!(info && info.is_exchange);
        }

        public function getFesDailyGiftStage(activityCommonId:int):int
        {
            var info:Object = this.getFesDailyGiftInfo(activityCommonId);
            var ret:int = 1;
            if (info)
            {
                ret = info.gift_pack_stage || 1;
                var isFesDailyGiftExchanged:Boolean = this.isFesDailyGiftExchanged(activityCommonId);
                var gifts:Array = ActivityM.instance._getCommonActivityConfig(activityCommonId) as Array;
                // 所有的礼包购买结束后，界面显示第一个礼包
                // 暂时认为数组里的数据按照阶段从小到大判断,阶段为1-数组的长度
                if (isFesDailyGiftExchanged && gifts && ret >= gifts.length)
                {
                    ret = 1;
                }
            }
            return ret;
        }

        public function getFesDailyGiftStageConfig(activityCommonId:int, stageId:int):Object
        {
            var gifts:Array = ActivityM.instance._getCommonActivityConfig(activityCommonId) as Array;
            var ret:Object = null;
            // 暂时认为数组里的数据按照阶段从小到大判断,阶段为1-数组的长度
            if (gifts && gifts.length >= stageId)
            {
                ret = gifts[stageId - 1];
            }
            return ret;
        }

        public function getCurDailyGiftStageConfig(activityCommonId:int):Object
        {
            var curStage:int = this.getFesDailyGiftStage(activityCommonId);
            return this.getFesDailyGiftStageConfig(activityCommonId, curStage);
        }

        public function isDailyGiftAllBuyed(activityCommonId:int):Boolean
        {
            // is_exchange字段为true即是买完了所有的礼包
            return this.isFesDailyGiftExchanged(activityCommonId);
        }
    }
}
