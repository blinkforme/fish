package control
{
    import conf.cfg_task_red_reward;

    import manager.ConfigManager;
    import manager.GameTools;

    import manager.UiManager;

    import model.ActivityM;
    import model.RoleInfoM;


    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.WebSocketManager;

    import struct.QuitTipInfo;

    public class ActivityC
    {

        private static var _instance:ActivityC;


        public var is_reward:Number;
        public var teams:Array;
        public var worldcup_info:Object;

        public function ActivityC()
        {
            GameEventDispatch.instance.on(String(32000), this, syncActivityData);
            GameEventDispatch.instance.on(String(32001), this, syncActivityStatus);
            GameEventDispatch.instance.on(String(36001), this, endWorldAcceptBattery);
            GameEventDispatch.instance.on(String(36004), this, syncWorldcupCoin);

            //4-11活动添加协议
            GameEventDispatch.instance.on(String(36009), this, bettingSuccess);
            GameEventDispatch.instance.on(String(36012), this, endAcceptReward);
            GameEventDispatch.instance.on(String(36016), this, endSyncJackpotInfo);
            GameEventDispatch.instance.on(String(36007), this, endWorldCupExchange);

            //2018圣诞节活动

            GameEventDispatch.instance.on(String(40006), this, actRegister);
            GameEventDispatch.instance.on(String(40008), this, registerState);
            GameEventDispatch.instance.on(String(40009), this, exchangeTime);
            GameEventDispatch.instance.on(String(32003), this, actCurrency);
            GameEventDispatch.instance.on(String(40011), this, exchangeReturn);
            GameEventDispatch.instance.on(String(40012), this, giftData);
            GameEventDispatch.instance.on(String(40014), this, giftReturn);
            GameEventDispatch.instance.on(String(40015), this, synAirBalloonRankData);
            GameEventDispatch.instance.on(String(40019), this, synAirBalloonAccountData);
            GameEventDispatch.instance.on(String(40017), this, synAirBalloonGameData);
            GameEventDispatch.instance.on(String(40020), this, synAirBalloonGameState);
            GameEventDispatch.instance.on(String(40023), this, updFesDailyGiftInfo);
            GameEventDispatch.instance.on(String(40022), this, syncExchangeTime);

            //            Laya.timer.loop(10000, this, loopSyncActivity);
        }

        public function syncExchangeTime()
        {
            WebSocketManager.instance.send(40021, {})
        }

        public function loopSyncActivity():void
        {
            loopSyncActivityByName(GameConst.activity_worldcup)
        }

        private function loopSyncActivityByName(activity:String):void
        {
            var extraTime:Number = ActivityM.instance.getActivityExtraTime(activity)
            var now:Number = (new Date().getTime()) / 1000

            console.log("extraTime:" + extraTime)
            console.log("now:" + now)

            if (ActivityM.instance.activityIsExtraTime(activity))
            {
                if (now > extraTime)
                {
                    if (!ActivityM.instance.activityIsDown(activity))
                    {
                        console.log("sendSync")
                        WebSocketManager.instance.send(32002, {})
                    }
                }
            }

        }

        public function endWorldCupExchange(re:Object):void
        {
            if (0 == re.code)
            {
                GameEventDispatch.instance.event(GameEvent.OnEndWorldCupExchange);

            } else if (1 == re.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "兑换未开启");
            } else if (2 == re.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "足球不足");
            } else if (3 == re.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "兑换超过限额");
            } else if (10 == re.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "您已经拥有大力神炮");
            } else
            {
                GameTools.dealCode(re.code)
            }
        }

        private function syncWorldcupCoin(data:Object):void
        {
            console.log("syncWorldcupCoin")
            console.log(data)
            RoleInfoM.instance.worldcup_coin = data['worldcup_coin']
            GameEventDispatch.instance.event(GameEvent.EndSyncWorldCupCoin);
        }

        private function endWorldAcceptBattery(data:Object):void
        {
            if (0 == data.code)
            {
                RoleInfoM.instance.worldcup_battery_accepted = 1
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "领取成功");
                GameEventDispatch.instance.event(GameEvent.EndAcceptWorldCup);
            } else if (1 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "无法领取");
            } else if (2 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "已经领取");
            } else if (3 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "需要月卡");
            } else
            {
                GameTools.dealCode(data.code)
            }
        }

        private function syncActivityData(result:*):void
        {
            ActivityM.instance.activity_data = result["list"] as Array;
            ActivityM.instance.setCommonImage();
            GameEventDispatch.instance.event(GameEvent.SyncActivityData);
        }

        private function syncActivityStatus(result:*):void
        {
            ActivityM.instance.activity_status = result["activity_status"];
            ActivityM.instance.sub_activity_status = result["sub_activity_status"];

            GameEventDispatch.instance.event(GameEvent.SyncActivityStatus);
        }


        public static function get instance():ActivityC
        {
            return _instance || (_instance = new ActivityC());
        }


        //4-11

        private function bettingSuccess(re:*):void
        {
            if (0 == re.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "下注成功");
                GameEventDispatch.instance.event(GameEvent.BettingSuccess);
            } else
            {
                //                TODO:处理其他错误情况
            }


        }

        private function actRegister(re:Object):void
        {
            ActivityM.instance.actRegister_data = re["data"] as Array;
            ActivityM.instance.actRegister_time = re["day"] as Number;
            GameEventDispatch.instance.event(GameEvent.ActRegister)
        }

        private function exchangeReturn(data:*):void
        {
            if (0 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "兑换成功");
                refreshExchangeInterval()
                Laya.timer.loop(1000, this, refreshExchangeInterval)
            } else if (1 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "活动未开启或无效");
            } else if (2 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "活动币不足");
            } else if (3 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "兑换剩余次数不足");
            } else if (4 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "活动已关闭");
            } else if (5 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "参数错误");
            } else if (6 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "30s内不能再次购买");
            }else if (100 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, data.msg);
            } else
            {
                GameTools.dealCode(data.code)
            }
        }

        private function refreshExchangeInterval()
        {
            if (ActivityM.instance.exchangeInterval <= 0)
            {
                ActivityM.instance.exchangeInterval = 30
            } else
            {

                ActivityM.instance.exchangeInterval -= 1;
            }

            if (ActivityM.instance.exchangeInterval <= 0)
            {
                Laya.timer.clear(this, refreshExchangeInterval)
            }
            GameEventDispatch.instance.event(GameEvent.ExchangeInterval);
        }

        private function giftReturn(data:*):void
        {
            if (0 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "兑换成功");
            } else if (1 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "活动已关闭");
            } else if (2 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "已兑换");
            } else if (3 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "无活动数据");
            } else if (4 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "活动币不足");
            } else if (5 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "兑换错误");
            } else
            {
                GameTools.dealCode(data.code)
            }
        }


        private function actCurrency(data:Array):void
        {
            ActivityM.instance.actCurrency_data = data["user_at_coin"] as Array;
            GameEventDispatch.instance.event(GameEvent.ActCurrency)
        }

        private function exchangeTime(data:Array):void
        {
            ActivityM.instance.exchange_times = data["exchange_times"] as Array;
            GameEventDispatch.instance.event(GameEvent.ExchangeTime)
        }

        private function giftData(data:Array):void
        {
            ActivityM.instance.is_exchange = data["is_exchange"] as Number;
            ActivityM.instance.cdkeys_id = data["cdkeys"] as String;
            GameEventDispatch.instance.event(GameEvent.ActCdk)
        }

        private function registerState(data:*):void
        {
            if (0 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "签到成功");
            } else if (1 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请勿重复签到");
            } else if (2 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "签到状态错误");
            } else
            {
                GameTools.dealCode(data.code)
            }
        }

        private function endAcceptReward(re:*):void
        {
            if (0 == re.code)
            {
                WebSocketManager.instance.send(36014, {})
            } else if (1 == re.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "活动未开启");
            } else if (3 == re.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "已领奖或未中奖");
            } else if (4 == re.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "活动未结束");
            } else if (2 == re.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "无人中奖");
            } else
            {
                GameTools.dealCode(re.code)
            }
        }

        private function endSyncJackpotInfo(re:*):void
        {
            ActivityM.instance.is_reward = re['is_reward']
            ActivityM.instance.bet_teams = re['teams']
            ActivityM.instance.worldcup_info = re['worldcup_info']
            ActivityM.instance.is_receive = re['is_receive']


            GameEventDispatch.instance.event(GameEvent.OnSyncBetData);

        }

        private function synAirBalloonRankData(res:*):void
        {
            ActivityM.instance.airBalloonRank = res;
        }

        private function synAirBalloonAccountData(res:*):void
        {
            if (res.code == 0)
            {
                GameEventDispatch.instance.event(GameEvent.CloseAccount, res);
            } else if (res.code == 1)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "结算分错误");
            } else if (res.code == 2)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "有未结算的分");
            } else if (res.code == 3)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "有未结算的分");
            } else if (res.code == 10)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "其他错误");
            } else
            {
                GameTools.dealCode(res.code)
            }
        }

        private function synAirBalloonGameData(res:*):void
        {
            if (res.code == 0)
            {

            } else if (res.code == 1)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "只能扎6个");
            } else if (res.code == 2)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "活动数据错误");
            } else if (res.code == 3)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "活动已结束");
            } else if (res.code == 4)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "活动币不足");
            } else if (res.code == 10)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "参数错误");
            } else
            {
                GameTools.dealCode(res.code)
            }
        }

        private function synAirBalloonGameState(res:*):void
        {
            ActivityM.instance.setHitBalloonArr(res);
        }

        private function updFesDailyGiftInfo(res:*):void
        {
            ActivityM.instance.updFesDailyGiftInfo(res);
            GameEventDispatch.instance.event(GameEvent.UpdFesDailyGift);
        }
    }
}
