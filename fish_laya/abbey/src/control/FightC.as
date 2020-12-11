package control
{
    import emurs.ShowType;

    import model.FightM;
    import model.LoadTipM;
    import model.LoginM;
    import model.MatchM;
    import model.RoleInfoM;
    import model.SkillM;

    import manager.ConfigManager;
    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.GameSoundManager;
    import manager.UiManager;
    import manager.WebSocketManager;

    import proto.C2s_30002;
    import proto.ProtoFightEatCoinRet;
    import proto.ProtoFightPlayerCoint;
    import proto.ProtoSeatInfo;
    import proto.S2c_12015;
    import proto.S2c_12026;
    import proto.S2c_12027;
    import proto.S2c_12030;
    import proto.S2c_12033;
    import proto.S2c_13002;
    import proto.S2c_17002;
    import proto.S2c_17003;
    import proto.S2c_roomGetIn;

    import struct.QuitTipInfo;

    public class FightC
    {
        private static var _instance:FightC;

        public function FightC()
        {
            GameEventDispatch.instance.on(String(12002), this, roomGetInRet);
            GameEventDispatch.instance.on(String(12052), this, roomGetInRet);
            GameEventDispatch.instance.on(String(12013), this, fightGetIn);
            GameEventDispatch.instance.on(String(12015), this, multiShootBulletRet);
            GameEventDispatch.instance.on(String(12050), this, addAwardScore);
            GameEventDispatch.instance.on(String(12018), this, exitFight);
            GameEventDispatch.instance.on(String(12021), this, fightGetOut);
            GameEventDispatch.instance.on(String(12022), this, syncOtherPlayers);
            GameEventDispatch.instance.on(String(12019), this, syncPlayerCoin);
            GameEventDispatch.instance.on(String(12049), this, fightEatCoinRet);
            GameEventDispatch.instance.on(String(12027), this, seatConfigChange);
            GameEventDispatch.instance.on(String(12026), this, roomGetIn);
            GameEventDispatch.instance.on(String(12030), this, syncViolent);
            GameEventDispatch.instance.on(String(12033), this, syncLock);
            GameEventDispatch.instance.on(String(12034), this, syncLevel);
            GameEventDispatch.instance.on(String(13002), this, buyBattery);
            GameEventDispatch.instance.on(String(17003), this, syncSkills);
            GameEventDispatch.instance.on(String(17002), this, useSkillRet);
            GameEventDispatch.instance.on(String(12041), this, useSkill);
            GameEventDispatch.instance.on(String(12042), this, callSkillReqFail);
            GameEventDispatch.instance.on(String(12046), this, dayComsumeTooMuch);
            GameEventDispatch.instance.on(String(12048), this, syncAutoShootTime);
            GameEventDispatch.instance.on(String(12055), this, contestStart);
            GameEventDispatch.instance.on(String(12056), this, exitNewPlayerScene);

            GameEventDispatch.instance.on(String(30000), this, getGoldPoolAward);
            GameEventDispatch.instance.on(String(30001), this, gold_pool_all_value_update);
            GameEventDispatch.instance.on(String(30004), this, syncGoldPoolAward);
            GameEventDispatch.instance.on(String(60008), this, deleteCompleteHandle);

            GameEventDispatch.instance.on(GameEvent.UseGoodsConfirmAndJumpToShop, this, useGoodsConfirmAndJumpToShop);
            GameEventDispatch.instance.on(GameEvent.ScreenShare, this, screenShare);
            Laya.timer.frameLoop(1, this, this.onLoop);
        }


        private function deleteCompleteHandle(res:*):void
        {
            if (res.code == 0)
            {
                if (WxC.isInMiniGame())
                {
                    WxC.refreshGame();
                } else
                {
                    window.document.location.reload()
                }
            } else if (res.code == 1)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "每个账号30天内限制3次,已超过注销次数")
            } else if (res.code == 2)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "未知错误")
            } else if (res.code == 999)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "网络错误")
            }
        }

        private function screenShare():void
        {
            if (WxC.isInMiniGame())
            {
                if (NoviceC.instance.isInGuide)
                {
                    return;
                }
                //UiManager.instance.loadView("BossShare");//wx:BossShare
            }
        }

        private function startContestMatch(data:*):void
        {
            var tmpInfo:QuitTipInfo = new QuitTipInfo();
            tmpInfo.isHaveTime = true;
            tmpInfo.autoCloseTime = 50;
            tmpInfo.state = GameConst.quit_state_left_cancel_right_confirm;
            tmpInfo.content = "xxx";
            GameEventDispatch.instance.event(GameEvent.QuitTip, tmpInfo);
        }

        private function exitNewPlayerScene():void
        {
            GameEventDispatch.instance.event(GameEvent.MsgTip, 70);
        }

        private function contestStart(data:*):void
        {
            if (FightM.instance.isMatchingGame())
            {
                MatchM.instance.isMatchSart = 1;
                FightM.instance.setContestEndTime(data.end_time);
                GameEventDispatch.instance.event(GameEvent.MatchingGameSynState);
            } else
            {
                UiManager.instance.closePanel("Mate", false);
                FightM.instance.setContestEndTime(data.end_time);
                GameEventDispatch.instance.event(GameEvent.ContestFightStart, null);
            }
        }

        private function syncAutoShootTime(data:*):void
        {
            FightM.instance.setAutoTime(data.time);
        }

        private function dayComsumeTooMuch(data:*):void
        {
            GameEventDispatch.instance.event(GameEvent.MsgTip, 32);
            GameEventDispatch.instance.event(GameEvent.ExitLoginView, null);
        }

        //通知前端有奖金可领
        private function syncGoldPoolAward(data:*):void
        {
            RoleInfoM.instance.setAwardValue(data.value);
            var goldPoolAwardMsg:C2s_30002 = new C2s_30002();
            goldPoolAwardMsg.value = RoleInfoM.instance.getAwardValue();
            WebSocketManager.instance.send(30002, goldPoolAwardMsg);
        }

        //获得奖金
        private function getGoldPoolAward(data:*):void
        {
            RoleInfoM.instance.setAwardScore(0);
            //			RoleInfoM.instance.setAwardValue(0);
            if (data.value > 0)
            {
                GameEventDispatch.instance.event(GameEvent.GetGoldPoolAward, data);
            }
            GameEventDispatch.instance.event(GameEvent.UpdateProfile);
        }

        //总的奖金
        private function gold_pool_all_value_update(data:*):void
        {
            FightM.instance.setGoldPoolTotalValue(data.value);
            GameEventDispatch.instance.event(GameEvent.UpdateGoldPoolInfo);
        }

        private function useGoodsConfirmAndJumpToShop(data:*):void
        {
            WebSocketManager.instance.send(10012, null);
            GameEventDispatch.instance.event(GameEvent.QuitTip, data);
        }

        private function onLoop():void
        {
            FightM.instance.agentGetInfoUpdate(Laya.timer.delta / 1000);
        }


        public static function get instance():FightC
        {
            return _instance || (_instance = new FightC());
        }

        private function syncLevel(data:*):void
        {
            FightM.instance.setLevel(data.seat_id, data.level);
            //			RoleInfoM.instance.setLevel(data.level)
            GameEventDispatch.instance.event(GameEvent.FightPlayerUpdate);
        }

        //更新锁定技能
        private function syncLock(data:*):void
        {
            var protoData:S2c_12033 = data as S2c_12033;
            var seatInfo:ProtoSeatInfo = FightM.instance.getSeatInfo(protoData.seat_id);
            if (seatInfo)
            {
                seatInfo.lock_et = protoData.lock_et;
                seatInfo.lock_sid = protoData.lock_sid;
                seatInfo.lock_uid = protoData.lock_uid;
                if (protoData.seat_id == FightM.instance.seatId)
                {
                    GameEventDispatch.instance.event(GameEvent.lockStart);
                    FightM.instance._lockUid = protoData.lock_uid;
                }
            }

        }

        //更新狂暴信息
        private function syncViolent(data:*):void
        {
            var protoData:S2c_12030 = data as S2c_12030;
            var seatInfo:ProtoSeatInfo = FightM.instance.getSeatInfo(protoData.seat_id);
            if (seatInfo)
            {
                seatInfo.lvet = protoData.lvet;
                seatInfo.vsid = protoData.sid;
                GameEventDispatch.instance.event(GameEvent.ViolentUpdate);
            }
        }


        private function syncSkills(data:*):void
        {
            var protoData:S2c_17003 = data as S2c_17003;
            for (var i:int = 0; i < protoData.info.length; i++)
            {
                FightM.instance.updateSkillCdLeftTime(protoData.info[i]);
            }
            GameEventDispatch.instance.event(GameEvent.SkillUpdate);
        }

        private function callSkillReqFail(data:*):void
        {
            GameEventDispatch.instance.event(GameEvent.MsgTip, 23);
        }

        private function useSkill(data:*):void
        {
            var musicPath:String = ConfigManager.getConfValue("cfg_skill", data.skill, "sound") as String;
            if (musicPath.length > 0)
            {
                GameSoundManager.playSound(musicPath);
            }
        }

        private function useSkillRet(data:*):void
        {
            var protoData:S2c_17002 = data as S2c_17002;
            if (0 == protoData.code)
            {
                var skillInfo:Object = new Object;
                skillInfo.id = protoData.id;
                skillInfo.cd = ConfigManager.getConfValue("cfg_skill", protoData.id, "cd") as Number;
                var skillType:int = ConfigManager.getConfValue("cfg_skill", protoData.id, "skill_type") as int;
                if (skillType == GameConst.skill_type_lock)
                {
                    FightM.instance._lockUid = 0;
                }
                FightM.instance.updateSkillCdLeftTime(skillInfo);
                GameEventDispatch.instance.event(GameEvent.SkillUpdate);
            } else if (1 == protoData.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTip, 1);
            } else if (2 == protoData.code)
            {
            } else if (10 == protoData.code)
            {

            } else if (5 == protoData.code)
            {
                if (protoData.code == GameConst.use_res_release_skill)
                {
                    var tmpType:int = ConfigManager.getConfValue("cfg_skill", protoData.id, "skill_type") as int;
                    if (tmpType == GameConst.skill_type_boom)
                    {
                        GameEventDispatch.instance.event(GameEvent.MsgTip, 2);
                    } else
                    {
                        var info:QuitTipInfo = new QuitTipInfo();
                        var diamondNum:int = SkillM.instance.skillDiamondCount(protoData.id);
                        info.state = GameConst.quit_state_left_cancel_right_confirm;
                        info.content = "道具不足，是否花费" + diamondNum + "钻石释放该技能";
                        info.confirmMsg = GameEvent.ConfirmUseSkill;
                        info.conFirmArgs = protoData.id;
                        info.autoCloseTime = 10;
                        GameEventDispatch.instance.event(GameEvent.QuitTip, info);
                    }

                }
            } else
            {
                //跳转商城
                GameEventDispatch.instance.event(GameEvent.Shop, GameConst.shop_tab_diamond);
            }
        }

        private function buyBattery(data:*):void
        {
            var protoData:S2c_13002 = data as S2c_13002;
            if (0 == protoData.code)
            {
                RoleInfoM.instance.setBattery(protoData.battery);
                GameEventDispatch.instance.event(GameEvent.BatteryBuyRet, data);
                var soundPath:String = ConfigManager.getConfValue("cfg_global", 1, "battery_unlock_sound") as String;
                GameSoundManager.playSound(soundPath);
            } else if (1 == protoData.code)
            {
                GameEventDispatch.instance.event(GameEvent.Shop, GameConst.shop_tab_diamond);
            }
        }

        private function addAwardScore(data:*):void
        {
            RoleInfoM.instance.setAwardScore(data.score);
            FightM.instance.goldPoolTotalValueAdd(data.prize);
            //			GameEventDispatch.instance.event(GameEvent.UpdateProfile);
            GameEventDispatch.instance.event(GameEvent.UpdateGoldPoolInfo);
            GameEventDispatch.instance.event(GameEvent.UpdateProfile);
        }

        private function multiShootBulletRet(data:*):void
        {

            var ret:S2c_12015 = data as S2c_12015;
            if (ret.code === 0)
            {
                if (!FightM.instance.coinShootScene())
                {
                    RoleInfoM.instance.setContestCoin(ret.ccoin);
                } else
                {
                    RoleInfoM.instance.setCoin(ret.coin);
                    RoleInfoM.instance.setBindCoin(ret.bcoin);
                }
                //				if(ret.awardScore)
                //				{
                //					RoleInfoM.instance.setAwardScore(ret.awardScore);
                //				}
                //				if(ret.prize)
                //				{
                //					FightM.instance.goldPoolTotalValueAdd(ret.prize);
                //					GameEventDispatch.instance.event(GameEvent.UpdateGoldPoolInfo);
                //				}

                GameEventDispatch.instance.event(GameEvent.UpdateProfile);
            } else if (5 == ret.code)
            {

            } else
            {
                if (GameConst.shoot_bullet_fail_action_sub_allow == ret.ac)
                {
                    //					GameEventDispatch.instance.event(GameEvent.ShowSubAllow, data);
                } else if (GameConst.shoot_bullet_fail_action_open_shop == ret.ac)
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTip, 3);
                    GameEventDispatch.instance.event(GameEvent.Shop, GameConst.shop_tab_coin);
                }
                GameEventDispatch.instance.event(GameEvent.ShootError, null);
            }
        }

        private function roomGetIn(data:*):void
        {
            var protoData:S2c_12026 = data as S2c_12026;
            if (protoData)
            {
                FightM.instance.seatId = protoData.seat_id;
                FightM.instance.setSceneId(protoData.scene_id);

                if (!FightM.instance.coinShootScene())
                {
                    RoleInfoM.instance.setContestCoin(protoData.ccoin);
                    RoleInfoM.instance.setContestScore(protoData.cscore);
                    FightM.instance.setContestEndTime(protoData.end_time);
                }
                GameEventDispatch.instance.event(GameEvent.ParseFishData, FightM.instance.sceneId);
                GameEventDispatch.instance.event(GameEvent.FightStart);

                if (FightM.instance.getSceneId() == GameConst.contest_tz_scene_id)
                {
                    if (!protoData.closeRoom)
                        UiManager.instance.loadView("Mate");
                }

                UiManager.instance.loadView("Fish");

                if (protoData.scene_id == 1)
                {
                    YylyC.EnterFirstScene();
                }
                GameEventDispatch.instance.event(GameEvent.UpdateProfile);
            }
        }

        private function roomGetInRet(data:*):void
        {
            var getIn:S2c_roomGetIn = data as S2c_roomGetIn;
            if (getIn.code == GameConst.fight_get_in_ok)
            {
                //GameEventDispatch.instance.event(GameEvent.StartLoad,[GameConst.loadFishState]);
                LoadTipM.instance.getInRoomFailCount = 0;
                UiManager.instance.closePanel("MainPage", false);
                UiManager.instance.closePanel("Load", false);
            } else
            {
                LoginM.instance.roomId = -1;
                GameEventDispatch.instance.event(GameEvent.MsgTip, getIn.code + 52);
                LoadTipM.instance.getInRoomFailCount = LoadTipM.instance.getInRoomFailCount + 1;
                UiManager.instance.closePanel("Load", false);
            }

        }

        private function exitFight(data:*):void
        {
            GameEventDispatch.instance.event(GameEvent.FightStop);
            UiManager.instance.loadView("MainPage");
            if (LoginM.instance.sceneId == GameConst.contest_match_scene_id)
            {
                UiManager.instance.loadView("NewMatch", {}, ShowType.Normal);
            }

            if (data.type && data.type == 1)
            {
                var info:QuitTipInfo = new QuitTipInfo();
                info.state = GameConst.quit_state_mid_confirm;
                info.content = "由于您长时间没参加比赛，已经被强制退出比赛。";
                GameEventDispatch.instance.event(GameEvent.QuitTip, info);
            } else
            {
                var value = data['pearl_num']
                if (value && value > 0)
                {
                    UiManager.instance.loadView("CiFu", {num: value}, ShowType.SMALL_TO_BIG);
                }
            }
        }

        private function fightGetIn(data:*):void
        {
            var seatInfo:ProtoSeatInfo = data as ProtoSeatInfo;
            FightM.instance.inSeatInfo(seatInfo.seat_id, seatInfo);
            GameEventDispatch.instance.event(GameEvent.FightPlayerUpdate);
        }

        private function fightGetOut(data:*):void
        {
            //data={seat_id:2,type:0}
            var seatInfo:ProtoSeatInfo = data as ProtoSeatInfo;
            if (FightM.instance.isMatchingGame())
            {
                if (data.type && data.type == 1)
                {
                    MatchM.instance.setOffLineSeatIndex(seatInfo.seat_id);
                }
            }
            FightM.instance.outSeatInfo(seatInfo.seat_id, seatInfo);
            GameEventDispatch.instance.event(GameEvent.FightPlayerUpdate);
            GameEventDispatch.instance.event(GameEvent.ViolentUpdate);
        }

        private function syncOtherPlayers(data:*):void
        {
            var arr:Array = data["players"] as Array;
            var bUid:Array = data["buid"] as Array;
            var seatInfo:ProtoSeatInfo;
            if (arr)
            {
                for (var i:int = 0; i < arr.length; i++)
                {
                    seatInfo = arr[i] as ProtoSeatInfo;
                    FightM.instance.inSeatInfo(seatInfo.seat_id, seatInfo);
                }
            }
            FightM.instance.setBulletUidInfo(bUid);
            GameEventDispatch.instance.event(GameEvent.FightPlayerUpdate);
        }

        private function syncPlayerCoin(data:*):void
        {
            var info:ProtoFightPlayerCoint = data as ProtoFightPlayerCoint;
            FightM.instance.seatAddCoin(info.seat_id, info.agent, info.coin);
            GameEventDispatch.instance.event(GameEvent.FightCoinUpdate, info);
        }


        private function fightEatCoinRet(data:*):void
        {

            var info:ProtoFightEatCoinRet = data as ProtoFightEatCoinRet;


            if (!FightM.instance.coinShootScene())
            {
                FightM.instance.seatAddContestCoin(info.seat_id, info.agent, info.coin);
                RoleInfoM.instance.setContestCoin(RoleInfoM.instance.getContestCoin() + info.coin);
            } else
            {
                FightM.instance.seatAddCoin(info.seat_id, info.agent, info.coin);
            }


            GameEventDispatch.instance.event(GameEvent.FightCoinUpdate, info);
        }


        private function seatConfigChange(data:*):void
        {
            var protoData:S2c_12027 = data as S2c_12027;
            FightM.instance.seatConfigChange(protoData);
            GameEventDispatch.instance.event(GameEvent.FightPlayerUpdate, null);

        }

    }
}
