package control
{
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.GameTools;
    import manager.UiManager;

    import model.FightM;
    import model.LoginM;

    import model.MatchM;

    public class MatchC
    {
        private static var _instance:MatchC;

        public function MatchC()
        {
            GameEventDispatch.instance.on(String(12052), this, end_daily_sign);
            GameEventDispatch.instance.on(String(12053), this, end_snatch_sign);
            GameEventDispatch.instance.on(String(35000), this, daily_match_settle);
            GameEventDispatch.instance.on(String(35001), this, challenge_match_settle);
            GameEventDispatch.instance.on(String(35004), this, end_accept_match_reward);
            GameEventDispatch.instance.on(String(35006), this, end_accept_daily_match_reward);

            //匹配赛
            GameEventDispatch.instance.on(String(12102), this, synRoomPrepareState);
            GameEventDispatch.instance.on(String(12108), this, synMatchGameRoomNum);
            GameEventDispatch.instance.on(String(12109), this, synMatchGameRuseltMsg);
            GameEventDispatch.instance.on(String(12113), this, synMatchGameAgainMsg);

            //新的比赛场
            GameEventDispatch.instance.on(String(12115), this, matchDataSync)
            GameEventDispatch.instance.on(String(12111), this, findMatchGameDataFromRoomNum);
        }

        private function matchDataSync(value):void
        {
            MatchM.instance.matchData = value
            GameEventDispatch.instance.event(GameEvent.RefreshMatchData)
        }

        private function findMatchGameDataFromRoomNum(res:*):void
        {
            if (res.code == 0)
            {
                GameEventDispatch.instance.event(GameEvent.GetIntoMatchRoom)
            } else if (res.code == 1)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "比赛不存在")
            } else if (res.code == 2)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "比赛已开始")
            } else if (res.code == 3)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "人数已满")
            } else if (res.code == 4)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "报名费不足")
            }
        }

        private function synMatchGameAgainMsg(res:*):void
        {
            if (res.code == 0)
            {
                GameEventDispatch.instance.event(GameEvent.MatchingGameAgainStart);
            } else if (res.code == 1)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "没有此类型比赛")
            } else if (res.code == 2)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "没有比赛信息")
            } else if (res.code == 3)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "不在比赛时间内")
            } else if (res.code == 4)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "道具不足")
            } else
            {
                GameTools.dealCode(res.code)
            }
        }

        private function synMatchGameRuseltMsg(res:*):void
        {
            if (res.data)
            {
                MatchM.instance.isMatchSart = 0;
                MatchM.instance.resultMsg = res;
                GameEventDispatch.instance.event(GameEvent.MatchingSynRusultMsg);
            }
        }

        private function synMatchGameRoomNum(res:*):void
        {
            if (res.playerNum)
            {
                MatchM.instance.theRoomNumber = res.playerNum;
                GameEventDispatch.instance.event(GameEvent.MatchingGameSynState);
            }
        }

        private function synRoomPrepareState(res:*):void
        {
            if (res.prepare_status)
            {
                MatchM.instance.setPrepareState(res.prepare_status);
                GameEventDispatch.instance.event(GameEvent.MatchingGameSynState);
            }
        }

        public function end_snatch_sign(data:*):void
        {
            if (0 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.EndSnatchMatchSign);
            }
        }

        public function end_accept_daily_match_reward(data:*):void
        {
            if (0 == data.code)
            {
                console.log("end_accept_match_reward")
                console.log(data)
                GameEventDispatch.instance.event(GameEvent.RewardTip, [data.reward_item_ids, data.reward_item_nums]);
                GameEventDispatch.instance.event(GameEvent.EndAcceptDailyMatchReward);
            } else
            {
                console.log("领取比赛错误")
                console.log(data)
            }
        }

        public function end_accept_match_reward(data:*):void
        {
            if (0 == data.code)
            {
                console.log("end_accept_match_reward")
                console.log(data)


                var reward_item_ids:Array = []
                var reward_item_nums:Array = []

                for (var i = 0; i < data.award.length; i = i + 2)
                {
                    reward_item_ids.push(data.award[i])
                    reward_item_nums.push(data.award[i + 1])
                }
                GameEventDispatch.instance.event(GameEvent.RewardTip, [reward_item_ids, reward_item_nums]);
                GameEventDispatch.instance.event(GameEvent.EndAcceptChallengeMatchReward);


            } else
            {
                GameTools.dealCode(data.code)
            }
        }

        public function daily_match_settle(data:*):void
        {
            data['type'] = 'daily'
            UiManager.instance.loadView("MatchSettle", data);
        }

        public function challenge_match_settle(data:*):void
        {
            data['type'] = 'challenge'
            UiManager.instance.loadView("MatchSettle", data);
        }

        public function end_daily_sign(data:*):void
        {
            if (0 == data.code)
            {
                if (data.homeowner)
                {
                    MatchM.instance.roomName = data.homeowner;
                    MatchM.instance.roomTime = data.time;
                    MatchM.instance.contestFee = data.contest_fee;
                    GameEventDispatch.instance.event(GameEvent.MatchingSynRoomData);
                }
                GameEventDispatch.instance.event(GameEvent.EndDailyMatchSign);
            } else if (data.code == 21)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "房间进入失败")
            } else if (data.code == 22)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "房间进入失败")
            } else if (data.code == 23)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "房间进入失败")
            } else
            {
                GameTools.dealCode(data.code)
            }
        }


        public static function get instance():MatchC
        {
            return _instance || (_instance = new MatchC());
        }
    }
}
