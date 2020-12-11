package model
{
    import conf.cfg_scene;

    import fight.AgentGetInfo;

    import manager.ConfigManager;
    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;

    import proto.ProtoSeatInfo;
    import proto.S2c_12027;

    public class FightM
    {
        public var seatId:int = 0;
        public var sceneId:int = 0;//当前所在场景
        public var _lockUid:int = 0; //自身瞄准的鱼的id
        public var _seatOneInfo:ProtoSeatInfo;
        public var _seatTwoInfo:ProtoSeatInfo;
        public var _seatThreeInfo:ProtoSeatInfo;
        public var _seatFourInfo:ProtoSeatInfo;
        public var _skillList:Array;
        public var _agentGetArray:Array;//位置获得信息
        private var _minBulletUid:int;
        private var _maxBulletUid:int;
        private var _curBulletUid:int;
        private var _goldPoolTotalValue:Number;
        private var _autoTime:Number; //自动发炮剩余时间
        private var _contestEndTime:Number;
        //public var
        private static var _instance:FightM;

        public function FightM()
        {
            _seatOneInfo = null;
            _seatTwoInfo = null;
            _seatThreeInfo = null;
            _seatFourInfo = null;
            _goldPoolTotalValue = 0;
            _autoTime = 0;
            _skillList = [];
            _agentGetArray = [];
        }

        public static function get instance():FightM
        {
            return _instance || (_instance = new FightM());
        }

        public function dataReset():void
        {
            _seatOneInfo = null;
            _seatTwoInfo = null;
            _seatThreeInfo = null;
            _seatFourInfo = null;
            seatId = 0;
            sceneId = 0;
            _contestEndTime = 0;
        }

        public function setContestEndTime(time:Number):void
        {
            _contestEndTime = time;
        }

        public function getContestEndTime():Number
        {
            return _contestEndTime;
        }

        public function contestEndTimeSub():void
        {
            if (_contestEndTime > 0)
            {
                _contestEndTime -= 1;
                if (_contestEndTime < 0)
                {
                    _contestEndTime = 0;
                }
            }
        }

        public function getyuleiItems():Array
        {
            var goods:Array = ConfigManager.filter("cfg_goods", function (cfg)
            {
                if (cfg.packed == 1)
                {
                    if (cfg.can_use == 0 && cfg.type == 6 && cfg.name.indexOf("鱼雷") >= 0)
                    {
                        return true;
                    }
                }
                return false;
            }) as Array
            goods.sort(function (a, b)
            {
                return a.pack_index - b.pack_index;
            })
            return goods;
        }

        /**
         * 是否是匹配赛
         */
        public function isMatchingGame():Boolean
        {
            if (FightM.instance.getSceneId() == GameConst.contest_match_scene_id)
            {
                return true;
            }
            return false;
        }


        public function coinShootScene():Boolean
        {
            if (sceneId > 0)
            {
                return (ConfigManager.getConfValue("cfg_scene", sceneId, "resource") as Number) == GameConst.scene_resource_coin;
            }
            return false;
        }

        public function isShowRankAni():Boolean
        {
            if (sceneId > 1 && sceneId <= 4)
            {
                return true;
            }
            return false;
        }

        public function setAutoTime(time:Number):void
        {
            _autoTime = time;
            if (_autoTime <= 0)
            {
                GameEventDispatch.instance.event(GameEvent.AutoShootTimeOut, null);
            }
        }

        public function getAutoTime():Number
        {
            return _autoTime;
        }

        public function getAutoTimeStr():String
        {
            var ret:String = "";
            var Hour:int = Math.floor(_autoTime / (60 * 60));
            var minute:int = Math.floor((_autoTime - Hour * 60 * 60) / 60);
            var second:int = Math.floor(_autoTime - Hour * 60 * 60 - minute * 60);
            if (Hour < 10)
            {
                ret = ret + "0" + Hour;
            } else
            {
                ret = ret + Hour;
            }
            if (minute < 10)
            {
                ret = ret + ":0" + minute;
            } else
            {
                ret = ret + ":" + minute;
            }
            if (second < 10)
            {
                ret = ret + ":0" + second;
            } else
            {
                ret = ret + ":" + second;
            }
            return ret;
        }

        public function setGoldPoolTotalValue(value:Number):void
        {
            _goldPoolTotalValue = value;
        }

        public function getGoldPoolTotalValue():int
        {
            return Math.floor(_goldPoolTotalValue);
        }

        public function goldPoolTotalValueAdd(value:Number):void
        {
            _goldPoolTotalValue += value;
        }

        public function setBulletUidInfo(info:Array):void
        {
            _minBulletUid = info[0];
            _maxBulletUid = info[1];
            _curBulletUid = info[2];
        }

        public function getBulletUid():int
        {
            if (_curBulletUid > _maxBulletUid)
            {
                _curBulletUid = _minBulletUid;
            }
            _curBulletUid = _curBulletUid + 1;
            return _curBulletUid;
        }

        public function getSeatInfo(seatId:int):ProtoSeatInfo
        {
            switch (seatId)
            {
                case 1:
                {
                    return _seatOneInfo;
                    break;
                }
                case 2:
                {
                    return _seatTwoInfo;
                    break;
                }
                case 3:
                {
                    return _seatThreeInfo;
                    break;
                }
                case 4:
                {
                    return _seatFourInfo;
                    break;
                }
            }
            return null;
        }

        public function getOwnAgent():int
        {
            var ret:int = -1;
            var seatInfo:ProtoSeatInfo = getSeatInfo(seatId);

            if (seatInfo)
            {
                return seatInfo.agent;
            }

            return ret;
        }

        //获取子弹碰撞检测的最佳玩家id
        public function isOwnBestBulletOwner(agent:int):Boolean
        {
            var seatInfo:ProtoSeatInfo = getSeatInfoByAgent(agent);
            if (seatInfo && agent >= 0)
            {
                return seatInfo.seat_id == seatId;
            }
            if (_seatOneInfo)
            {
                return _seatOneInfo.seat_id == seatId;
            }
            if (_seatTwoInfo)
            {
                return _seatTwoInfo.seat_id == seatId;
            }
            if (_seatThreeInfo)
            {
                return _seatThreeInfo.seat_id == seatId;
            }
            if (_seatFourInfo)
            {
                return _seatFourInfo.seat_id == seatId;
            }
            return false;
        }

        //获取
        public function getOwnUseBattery():int
        {
            var seatInfo:ProtoSeatInfo = getSeatInfo(seatId);
            if (seatInfo)
            {
                return seatInfo.battery;
            }
            return 0;
        }

        //通过自己位置获取镜像x坐标
        public function getMirrorPosXByOwnSeat(x:Number):Number
        {
            if (GameConst.fix_left_down_pos)
            {
                if (2 == seatId)
                {
                    //x = Laya.stage.width - x;
                    x = GameConst.design_width - x;
                } else if (3 == seatId)
                {
                    //x = Laya.stage.width - x;
                    x = GameConst.design_width - x;
                }
            }
            return x;
        }

        public function getOwnSeatMirrorType():int
        {
            var ret:int = GameConst.fish_path_mirror_none;
            if (2 == seatId)
            {
                ret = GameConst.fish_path_mirror_x;
            } else if (3 == seatId)
            {
                ret = GameConst.fish_path_mirror_xy;
            } else if (4 == seatId)
            {
                ret = GameConst.fish_path_mirror_y;
            }
            return ret;
        }

        //通过自己位置获取镜像y坐标
        public function getMirrorPosYByOwnSeat(y:Number):Number
        {
            if (GameConst.fix_left_down_pos)
            {
                if (3 == seatId)
                {
                    //y = Laya.stage.height - y;
                    y = GameConst.design_height - y;
                } else if (4 == seatId)
                {
                    //y = Laya.stage.height - y;
                    y = GameConst.design_height - y;
                }
            }
            return y;
        }

        //通过显示炮台位置获取真实炮台位置
        public function getSeatIdByShowSeatId(showSeatId:int):int
        {
            if (!GameConst.fix_left_down_pos)
            {
                return showSeatId;
            }
            if (2 == seatId)
            {
                if (1 == showSeatId)
                {
                    return 2;
                } else if (2 == showSeatId)
                {
                    return 1;
                } else if (3 == showSeatId)
                {
                    return 4;
                } else if (4 == showSeatId)
                {
                    return 3;
                }
            }
            if (3 == seatId)
            {
                if (1 == showSeatId)
                {
                    return 3;
                } else if (2 == showSeatId)
                {
                    return 4;
                } else if (3 == showSeatId)
                {
                    return 1;
                } else if (4 == showSeatId)
                {
                    return 2;
                }
            }
            if (4 == seatId)
            {
                if (1 == showSeatId)
                {
                    return 4;
                } else if (2 == showSeatId)
                {
                    return 3;
                } else if (3 == showSeatId)
                {
                    return 2;
                } else if (4 == showSeatId)
                {
                    return 1;
                }
            }
            return showSeatId;
        }

        //通过实际位置获取镜像位置
        public function getShowSeatId(rSeatId:int):int
        {
            if (!GameConst.fix_left_down_pos)
            {
                return rSeatId;
            }
            if (2 == seatId)
            {
                if (1 == rSeatId)
                {
                    return 2;
                } else if (2 == rSeatId)
                {
                    return 1;
                } else if (3 == rSeatId)
                {
                    return 4;
                } else if (4 == rSeatId)
                {
                    return 3;
                }
            }
            if (3 == seatId)
            {
                if (1 == rSeatId)
                {
                    return 3;
                } else if (2 == rSeatId)
                {
                    return 4;
                } else if (3 == rSeatId)
                {
                    return 1;
                } else if (4 == rSeatId)
                {
                    return 2;
                }
            }
            if (4 == seatId)
            {
                if (1 == rSeatId)
                {
                    return 4;
                } else if (2 == rSeatId)
                {
                    return 3;
                } else if (3 == rSeatId)
                {
                    return 2;
                } else if (4 == rSeatId)
                {
                    return 1;
                }
            }
            return rSeatId;
        }

        public function seatConfigChange(data:S2c_12027):void
        {
            var seatInfo:ProtoSeatInfo = getSeatInfo(data.seat_id);
            if (seatInfo)
            {
                seatInfo.cskin = data.cskin;
                seatInfo.battery = data.battery;
            }
        }

        public function getSeatInfoByAgent(agent:int):ProtoSeatInfo
        {
            if (_seatOneInfo && _seatOneInfo.agent === agent)
            {
                return _seatOneInfo;
            }
            if (_seatTwoInfo && _seatTwoInfo.agent === agent)
            {
                return _seatTwoInfo;
            }
            if (_seatThreeInfo && _seatThreeInfo.agent === agent)
            {
                return _seatThreeInfo;
            }
            if (_seatFourInfo && _seatFourInfo.agent === agent)
            {
                return _seatFourInfo;
            }
            return null;
        }

        public function inSeatInfo(seatId:int, seatInfo:ProtoSeatInfo):void
        {
            switch (seatId)
            {
                case 1:
                {
                    _seatOneInfo = seatInfo;
                    _seatOneInfo.skipCoin = 0;
                    break;
                }
                case 2:
                {
                    _seatTwoInfo = seatInfo;
                    _seatTwoInfo.skipCoin = 0;
                    break;
                }
                case 3:
                {
                    _seatThreeInfo = seatInfo;
                    _seatThreeInfo.skipCoin = 0;
                    break;
                }
                case 4:
                {
                    _seatFourInfo = seatInfo;
                    _seatFourInfo.skipCoin = 0;
                    break;
                }
            }
        }

        public function setLevel(seat_id:int, level:int):void
        {
            var seatInfo:ProtoSeatInfo = getSeatInfo(seat_id);
            if (seatInfo)
            {
                seatInfo.level = level;
            }
        }

        public function outSeatInfo(seatId:int, seatInfo:ProtoSeatInfo):void
        {
            switch (seatId)
            {
                case 1:
                {
                    _seatOneInfo = null;
                    break;
                }
                case 2:
                {
                    _seatTwoInfo = null;
                    break;
                }
                case 3:
                {
                    _seatThreeInfo = null;
                    break;
                }
                case 4:
                {
                    _seatFourInfo = null;
                    break;
                }
            }
        }

        public function setSkipCoin(sId:int, skipCoin:int):void
        {
            var seatInfo:ProtoSeatInfo = getSeatInfo(sId);
            if (seatInfo)
            {
                seatInfo.skipCoin = skipCoin;
                GameEventDispatch.instance.event(GameEvent.PlayerCoinChange, null);
            }
        }

        public function seatAddCoin(sId:int, agent:int, addCoin:int, skipCoinClear:Boolean = false):void
        {
            var seatInfo:ProtoSeatInfo = getSeatInfo(sId);
            if (seatInfo && seatInfo.seat_id == sId && seatInfo.agent == agent)
            {
                seatInfo.coin += addCoin;
                if (skipCoinClear)
                {
                    seatInfo.skipCoin = 0;
                }
                if (sId == this.seatId)
                {
                    GameEventDispatch.instance.event(GameEvent.PlayerCoinChange, null);
                }
            }
        }

        public function seatAddContestCoin(sId:int, agent:int, addCoin:int):void
        {
            var seatInfo:ProtoSeatInfo = getSeatInfo(sId);
            if (seatInfo && seatInfo.seat_id == sId && seatInfo.agent == agent)
            {
                seatInfo.contestCoin += addCoin;
                if (sId == this.seatId)
                {
                    GameEventDispatch.instance.event(GameEvent.PlayerCoinChange, null);
                }
            }
        }

        public function seatAddContestScore(sId:int, agent:int, addScore:int):void
        {
            var seatInfo:ProtoSeatInfo = getSeatInfo(sId);
            if (seatInfo && seatInfo.seat_id == sId && seatInfo.agent == agent)
            {
                seatInfo.contestScore += addScore;
                if (sId == this.seatId)
                {
                    GameEventDispatch.instance.event(GameEvent.PlayerCoinChange, null);
                }
            }
        }

        public function seatAddContestScoreByAgent(agent:int, addScore:int):void
        {
            var seatInfo:ProtoSeatInfo = getSeatInfoByAgent(agent);
            if (seatInfo)
            {
                seatInfo.contestScore += addScore;
                if (seatInfo.seat_id == this.seatId)
                {
                    GameEventDispatch.instance.event(GameEvent.PlayerCoinChange, null);
                }
            }
        }

        public function seatAddContestCoinByAgent(agent:int, addCoin:int):void
        {
            var seatInfo:ProtoSeatInfo = getSeatInfoByAgent(agent);
            if (seatInfo)
            {
                seatInfo.contestCoin += addCoin;
                if (seatInfo.seat_id == this.seatId)
                {
                    GameEventDispatch.instance.event(GameEvent.PlayerCoinChange, null);
                }
            }
        }

        public function seatAddCoinByAgent(agent:int, addCoin:int):void
        {
            var seatInfo:ProtoSeatInfo = getSeatInfoByAgent(agent);
            if (seatInfo)
            {
                seatInfo.coin += addCoin;
                if (seatInfo.seat_id == this.seatId)
                {
                    GameEventDispatch.instance.event(GameEvent.PlayerCoinChange, null);
                }
            }
        }

        public function getSceneId():int
        {
            return sceneId;
        }

        public function setSceneId(id:int):void
        {
            sceneId = id;
        }

        public function isGoldPoolScene():Boolean
        {
            if (sceneId > 0)
            {
                var playId:int = ConfigManager.getConfValue("cfg_scene", sceneId, "play_id") as int;
                return playId == GameConst.scene_play_award_pool;
            }
            return false;
        }

        public function getSkillId(skillIndex:int):int
        {
            if (FightM.instance.sceneId > 0)
            {
                var skills:Array = ConfigManager.getConfValue("cfg_scene", FightM.instance.sceneId, "skills") as Array;
                if (skills)
                {
                    return skills[skillIndex];
                }
            }
            return 0;
        }

        //cd剩余时间
        public function getSkillCdLeftTime(skillId:int):Number
        {
            var skillInfo:Object
            for (var i:int = 0; i < _skillList.length; i++)
            {
                skillInfo = _skillList[i] as Object;
                if (skillInfo.id == skillId)
                {

                    return skillInfo.cd;
                }
            }
            return 0;
        }

        //更新技能cd时间
        public function updateSkillCdLeftTime(skillData:Object):void
        {

            var skillInfo:Object
            for (var i:int = 0; i < _skillList.length; i++)
            {
                skillInfo = _skillList[i] as Object;
                if (skillInfo.id == skillData.id)
                {

                    skillInfo.cd = skillData.cd;
                    //skillList[i] = skillInfo;
                    return;
                }
            }
            _skillList[_skillList.length] = skillData;
        }

        public function resetSkillCd():void
        {
            var skillInfo:Object;
            for (var i:int = 0; i < _skillList.length; i++)
            {
                skillInfo = _skillList[i] as Object;
                skillInfo.cd = 0;
            }
        }

        //cd时间tick
        public function updateSkill(delta:Number):void
        {
            var skillInfo:Object
            for (var i:int = 0; i < _skillList.length; i++)
            {
                skillInfo = _skillList[i] as Object;
                if (skillInfo.cd > 0)
                {
                    skillInfo.cd -= delta;
                }
            }
        }

        //获取连续射击间隔时间
        public function getShootInterval():Number
        {
            var seatInfo:ProtoSeatInfo = getSeatInfo(seatId);
            var ret:Number = ConfigManager.getConfValue("cfg_battery_skin", RoleInfoM.instance.getCurSkin(), "shootInterval") as Number;
            if (seatInfo)
            {
                if (seatInfo.lvet > 0)
                {
                    var firing_rate:Number = ConfigManager.getConfValue("cfg_skill", seatInfo.vsid, "firing_rate") as Number;
                    ret = ret / firing_rate;
                }
            }
            return ret;
        }

        public function isShowSeatViolent(showIndex:int):Boolean
        {
            var ret:Boolean = false;
            var seatInfo:ProtoSeatInfo = FightM.instance.getSeatInfo(FightM.instance.getSeatIdByShowSeatId(showIndex));
            if (seatInfo && seatInfo.lvet > 0)
            {
                ret = true;
            }
            return ret;
        }

        public function getBulletSpeedRate():Number
        {
            var seatInfo:ProtoSeatInfo = getSeatInfo(seatId);
            var ret:Number = 1;
            if (seatInfo)
            {
                if (seatInfo.lvet > 0)
                {
                    ret = ConfigManager.getConfValue("cfg_skill", seatInfo.vsid, "speed_rate") as Number;
                }
            }
            return ret;
        }

        //狂暴时间更新
        public function updateViolent(delta:Number):void
        {
            var violentUpdate:Boolean = false;
            if (_seatOneInfo)
            {
                if (_seatOneInfo.lvet > 0)
                {
                    _seatOneInfo.lvet -= delta;
                    if (_seatOneInfo.lvet <= 0)
                    {
                        violentUpdate = true;
                    }
                }
            }
            if (_seatTwoInfo)
            {
                if (_seatTwoInfo.lvet > 0)
                {
                    _seatTwoInfo.lvet -= delta;
                    if (_seatTwoInfo.lvet <= 0)
                    {
                        violentUpdate = true;
                    }
                }
            }
            if (_seatThreeInfo)
            {
                if (_seatThreeInfo.lvet > 0)
                {
                    _seatThreeInfo.lvet -= delta;
                    if (_seatThreeInfo.lvet <= 0)
                    {
                        violentUpdate = true;
                    }
                }
            }
            if (_seatFourInfo)
            {
                if (_seatFourInfo.lvet > 0)
                {
                    _seatFourInfo.lvet -= delta;
                    if (_seatFourInfo.lvet <= 0)
                    {
                        violentUpdate = true;
                    }
                }
            }
            if (violentUpdate)
            {
                GameEventDispatch.instance.event(GameEvent.ViolentUpdate);
            }
        }

        public function isOwnLock():Boolean
        {
            if (seatId == 1)
            {
                if (_seatOneInfo)
                {
                    return _seatOneInfo.lock_et > 0;
                }
            } else if (seatId == 2)
            {
                if (_seatTwoInfo)
                {
                    return _seatTwoInfo.lock_et > 0;
                }
            } else if (seatId == 3)
            {
                if (_seatThreeInfo)
                {
                    return _seatThreeInfo.lock_et > 0;
                }
            } else if (seatId == 4)
            {
                if (_seatFourInfo)
                {
                    return _seatFourInfo.lock_et > 0;
                }
            }
            return false;
        }

        public function updateLock(delta:Number):void
        {
            if (_seatOneInfo)
            {
                if (_seatOneInfo.lock_et > 0)
                {
                    _seatOneInfo.lock_et -= delta;
                    if (_seatOneInfo.lock_et <= 0 && FightM.instance.seatId == 1)
                    {
                        GameEventDispatch.instance.event(GameEvent.stopLock);
                    }
                }
            }
            if (_seatTwoInfo)
            {
                if (_seatTwoInfo.lock_et > 0)
                {
                    _seatTwoInfo.lock_et -= delta;
                    if (_seatTwoInfo.lock_et <= 0 && FightM.instance.seatId == 2)
                    {
                        GameEventDispatch.instance.event(GameEvent.stopLock);
                    }
                }
            }
            if (_seatThreeInfo)
            {
                if (_seatThreeInfo.lock_et > 0)
                {
                    _seatThreeInfo.lock_et -= delta;
                    if (_seatThreeInfo.lock_et <= 0 && FightM.instance.seatId == 3)
                    {
                        GameEventDispatch.instance.event(GameEvent.stopLock);
                    }
                }
            }
            if (_seatFourInfo)
            {
                if (_seatFourInfo.lock_et > 0)
                {
                    _seatFourInfo.lock_et -= delta;
                    if (_seatFourInfo.lock_et <= 0 && FightM.instance.seatId == 4)
                    {
                        GameEventDispatch.instance.event(GameEvent.stopLock);
                    }
                }
            }
        }

        public function update(delta:Number):void
        {
            updateSkill(delta);
            updateViolent(delta);
            updateLock(delta);
        }

        public function reset():void
        {
            if (_seatOneInfo)
            {
                _seatOneInfo.lock_et = 0;
                _seatOneInfo.lvet = 0;
            }
            if (_seatTwoInfo)
            {
                _seatTwoInfo.lock_et = 0;
                _seatOneInfo.lvet = 0;
            }
            if (_seatThreeInfo)
            {
                _seatThreeInfo.lock_et = 0;
                _seatOneInfo.lvet = 0;
            }
            if (_seatFourInfo)
            {
                _seatFourInfo.lock_et = 0;
                _seatOneInfo.lvet = 0;
            }
            var skillInfo:Object
            for (var i:int = 0; i < _skillList.length; i++)
            {
                skillInfo = _skillList[i] as Object;
                skillInfo.cd = 0;
            }
            GameEventDispatch.instance.event(GameEvent.ViolentUpdate);
        }

        public function addAgentGetInfo(data:AgentGetInfo):void
        {
            _agentGetArray.push(data);
        }

        public function getGoodsUnreachNum(ag:int, goodsId:int):int
        {
            var ret:int = 0;
            var info:AgentGetInfo;
            for (var i:int = 0; i < _agentGetArray.length; i++)
            {
                info = _agentGetArray[i] as AgentGetInfo;
                if (info.ag == ag && info.t == goodsId)
                {
                    ret += info.v;
                }
            }

            return ret;
        }

        public function agentGetInfoUpdate(delta:Number):void
        {
            var info:AgentGetInfo;
            var removeArray:Array = [];
            var coinUpdate:Boolean = false;
            var goodsUpdate:Boolean = false;
            for (var i:int = 0; i < _agentGetArray.length; i++)
            {
                info = _agentGetArray[i] as AgentGetInfo;
                info.leftTime -= delta;
                if (info.leftTime <= 0)
                {
                    if (info.t == GameConst.currency_coin)
                    {
                        coinUpdate = true;
                        FightM.instance.seatAddCoinByAgent(info.ag, info.v);
                    } else if (info.t == GameConst.currency_contest_score)
                    {
                        goodsUpdate = true;
                        FightM.instance.seatAddContestScoreByAgent(info.ag, info.v);
                    } else
                    {
                        goodsUpdate = true;
                    }
                    removeArray.push(info);
                }
            }
            for (var j:int = 0; j < removeArray.length; j++)
            {
                var removeInfo:AgentGetInfo = removeArray[j] as AgentGetInfo;
                for (var k:int = 0; k < _agentGetArray.length; k++)
                {
                    if (_agentGetArray[k] == removeInfo)
                    {
                        _agentGetArray.splice(k, 1);
                        break;
                    }
                }
            }
            if (coinUpdate)
            {
                GameEventDispatch.instance.event(GameEvent.FightCoinUpdate, null);
            }
            if (goodsUpdate)
            {
                GameEventDispatch.instance.event(GameEvent.UpdateProfile, null);
                GameEventDispatch.instance.event(GameEvent.GoodsUpdate, null);
            }

            if (_autoTime > 0)
            {
                _autoTime = _autoTime - delta;
                if (_autoTime <= 0)
                {
                    GameEventDispatch.instance.event(GameEvent.AutoShootTimeOut, null);
                }
            }

        }

        public function getCoinRate():Number
        {
            var cfg:cfg_scene = cfg_scene.instance(FightM.instance.sceneId + "")
            if (cfg.doubleRate[0] == 1)
            {
                return RoleInfoM.instance.coin_rate
            } else
            {
                return 1;
            }
        }

        public function getChangeRate():Number
        {
            var cfg:cfg_scene = cfg_scene.instance(FightM.instance.sceneId + "")
            if (cfg.doubleRate[1] == 1)
            {
                return RoleInfoM.instance.chance_rate
            } else
            {
                return 1;
            }
        }

        public function initCountDown(end_time:Number, element:Object):void
        {

            var now:Number = new Date().getTime() as Number

            var now_time:Number = Math.floor((now / 1000));

            var diff_time:Number = end_time;//end_time - now_time

            if (diff_time < 0)
            {
                diff_time = 0
            }


            var minutesleft:* = Math.floor(((diff_time) % 3600) / 60)

            var secondsleft:* = (diff_time) % 60;

            //format 0 prefixes
            if (minutesleft < 10) minutesleft = "0" + minutesleft;
            if (secondsleft < 10) secondsleft = "0" + secondsleft;

            if (FightM.instance.isMatchingGame())
            {
                element.text = "" + minutesleft + ":" + secondsleft;
            } else
            {
                element.text = "本局倒计时：" + minutesleft + ":" + secondsleft;
            }
        }

    }
}
