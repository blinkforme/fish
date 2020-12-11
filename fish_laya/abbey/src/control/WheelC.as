package control
{

    import manager.GameTools;

    import model.RoleInfoM;
    import model.WheelM;

    import manager.GameEvent;
    import manager.GameEventDispatch;

    /**
     * ...
     * @author ...
     */
    public class WheelC
    {
        private static var _instance:WheelC;

        public function WheelC()
        {
            GameEventDispatch.instance.on(String(40001), this, wheeldate);
            GameEventDispatch.instance.on(String(40003), this, wheelturn);

            GameEventDispatch.instance.on(String(13006), this, sycnwheelSkin);//同步 可兑换的 皮肤id:时间
            GameEventDispatch.instance.on(String(40004), this, sycnmonthCard);//同步 可兑换的 月卡id:时间

            GameEventDispatch.instance.on(String(14070), this, usethreeDayCard);

            GameEventDispatch.instance.on(String(14009), this, sycnmonthCardMsg);//同步 可兑换的 月卡id:时间
            GameEventDispatch.instance.on(String(40005), this, sycnMidAutumnMsg);
        }

        private function sycnCoinAndDiamond(res):void
        {
            RoleInfoM.instance.setCoin(res.coin);
            RoleInfoM.instance.setDiamond(res.diamond);
            GameEventDispatch.instance.event(GameEvent.UpdateProfile);
        }

        private function sycnwheelSkin(res):void
        {
            RoleInfoM.instance.init_time_skins(res.skins_duration)
        }

        private function usethreeDayCard():void
        {

        }

        private function sycnmonthCard():void
        {
            //[id,time]
        }

        private function sycnmonthCardMsg(res):void
        {
            //begin_time =0//起始时间
            //last_time = 0//结束时间
            //card_duration=0//持续时间
        }


        public function wheeldate(res):void
        {
            if (res.code == 0)
            {
                WheelM.instance.setIct(res.ict);//前三个转盘是否可转:test
                WheelM.instance.setTimes(res.lottery_times);//各转盘已转次数
                WheelM.instance.setwheelScore(res.lottery_score_total);//各转盘已转累计值
                WheelM.instance.setcostScore(res.lottery_consume_total);//转盘当日消耗
                //WheelM.instance.setwheelToday(res.today_turntable);//前三个转盘当日累计值

                WheelM.instance.isExchange=res.is_exchange;//中秋 积分是否兑换成礼包码
                WheelM.instance.cdKey=res.cdkey;//中秋 礼包码
                WheelM.instance.midAutumnScore=res.mid_autumn_score;//中秋 兑换礼包码所需积分

                var _arr:Array = WheelM.instance.getwheelScore();
                var _playerscore:Number = 0;
                for (var i:int, max = _arr.length; i < max; i++)
                {
                    _playerscore += _arr[i];
                }
                WheelM.instance.setPlayerScore(_playerscore);

                GameEventDispatch.instance.event(GameEvent.WheeltipsUpdate);
                GameEventDispatch.instance.event(GameEvent.WheelscoreUpdate);
            }
            else if (res.code == 1)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "活动已下线");
            }
            else if (res.code == 2)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请求错误,请重试");
            }
            else if (res.code == 999)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "网络错误,请重试");
            }
        }

        public function wheelturn(res):void
        {
            //40003
            if (res.code == 0)
            {
                GameEventDispatch.instance.event(GameEvent.WheelStart, [res.t, res.r, res.c]);

                WheelM.instance.setIct(res.ict);//前三个转盘是否可转:test
                WheelM.instance.setTimes(res.lottery_times);//各转盘已转次数
                WheelM.instance.setwheelScore(res.lottery_score_total);//各转盘已转累计值
                WheelM.instance.setcostScore(res.lottery_consume_total);//转盘当日消耗

                //开始转动
            }
            else if (res.code == 1)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "不在活动内");
            }
            else if (res.code == 2)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "不满足转盘条件");
            }
            else if (res.code == 3)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "超过次数");
            }
            else
            {
                GameTools.dealCode(res.code);
            }
        }

        private function sycnMidAutumnMsg(res:*):void
        {
            if (res.code == 0) {
                WheelM.instance.isExchange=1;//中秋 积分是否兑换成礼包码
                WheelM.instance.cdKey=res.cdkey;//中秋 礼包码
                GameEventDispatch.instance.event(GameEvent.UpdataWheelMidAutumn);
            } else if (res.code == 1)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent,"积分不足");
            } else if (res.code == 2)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent,"重复兑换");
            } else if (res.code == 10)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent,"其它兑换错误");
            } else
            {
                GameTools.dealCode(res.code)
            }
        }

        public static function get instance():WheelC
        {
            return _instance || (_instance = new WheelC());
        }

    }

}
