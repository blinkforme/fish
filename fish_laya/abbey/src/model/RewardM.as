package model
{
    import conf.cfg_goods;
    import conf.cfg_rewardDetails;

    import manager.ConfigManager;
    import manager.GameTools;

    public class RewardM
    {
        private static var _instance:RewardM;
        private var aniNames:Array = ["common", "bronze", "silver", "gold", "platina", "extreme"];
        private var idArr:Array = ["firstId", "secondId", "threeId", "fourId", "fiveId", "sixId"];
        private var commonArr:Array = ["common_1", "common_2", "common_3", "common_4", "common_5", "common_6"];
        private var reward:Object = new Object();
        private var infoList:Array;
        private var _recordArr:Array;
        private var _currentList:Array;
        private var _userNameArr:Array;
        private var _lotterIdArr:Array;


        //收藏小程序奖励
        public var _isCollect:Number;
        public var _isFristCollect:Number;


        public function RewardM()
        {

        }

        public static function get instance():RewardM
        {
            return _instance || (_instance = new RewardM());
        }

        public function setInfo():void
        {
            for (var j:int = 0; j < aniNames.length; j++)
            {
                var rewardType:Object = ConfigManager.getConfObject("cfg_rewardType", aniNames[j]);
                var arr:Array = new Array();
                for (var k:int = 0; k < idArr.length; k++)
                {
                    arr.push(rewardType[idArr[k]]);
                }
                reward[aniNames[j] + ""] = arr;
            }
        }


        public function get currentList():Array
        {
            return _currentList;
        }

        public function set currentList(arr:Array):void
        {
            _currentList = arr;
        }

        public function getlotteryRecord(id:Number, goodsId:Number, goodNum:Number, userName:String):String
        {
            userName = userName.replace(/[&<>]/g, "");
            var contentOne:String = "<span color='#e3d26a'>恭喜</span>";
            var contentTwo:String = "<span color='#FF0000'>" + userName + "</span>";
            var contentThree:String = "<span color='#e3d26a'>通过进行" + getlotteryName(id) + ",获得了&nbsp;" + "</span>"
            var contentFour:String = "<span color='#EEB422'>" + getLotteryRewardName(id, goodsId, goodNum) + "</span>"
            return contentOne + "" + contentTwo + "" + contentThree + "" + contentFour;
        }

        private function getLotteryRewardName(id:Number, goodsId:Number, goodNum:Number):String
        {
            var cfg:cfg_rewardDetails = cfg_rewardDetails.instance(id);
            if (goodsId == cfg.award[0] && goodNum == cfg.award[1])
            {
                return cfg.rewardName;
            } else if (goodsId == cfg.red_pack_activity_award[0] && goodNum == cfg.red_pack_activity_award[1])
            {
                return cfg.red_pack_activity_Name;
            }
            return cfg.rewardName;
        }

        public function rewardArr(id:int):Array
        {
            var arr:Array = [];
            var rewardArr:Array = reward[aniNames[id] + ""];
            if (ActivityM.instance.redPackTicketContinueTime)
            {
                for (var i:int = 0; i < rewardArr.length; i++)
                {
                    var c:cfg_rewardDetails = cfg_rewardDetails.instance(rewardArr[i]);
                    var goodsId:Number = c.red_pack_activity_award[0];
                    var goods:cfg_goods = cfg_goods.instance(goodsId + "");
                    if (goods.type == 7)
                    {
                        if (RoleInfoM.instance.isSkinExit(goods.typeID))
                        {
                            arr.push({id: c.id, txt: c.re_rewardName, image: c.re_rewardUrl, count: c.re_award});
                        }
                        else
                        {
                            arr.push({
                                id: c.id, txt: c.red_pack_activity_Name, image: c.red_pack_activity_rewardUrl, count: c.red_pack_activity_award
                            });
                        }
                    }
                    else
                    {
                        arr.push({id: c.id, txt: c.red_pack_activity_Name, image: c.red_pack_activity_rewardUrl, count: c.red_pack_activity_award});
                    }

                    //arr.push({txt:{text:c.rewardName},image:{skin:c.rewardUrl},count:{value:c.award}});
                }
            } else
            {
                for (var i:int = 0; i < rewardArr.length; i++)
                {
                    var c:cfg_rewardDetails = cfg_rewardDetails.instance(rewardArr[i]);
                    var goodsId:Number = c.award[0];
                    var goods:cfg_goods = cfg_goods.instance(goodsId + "");
                    if (goods.type == 7)
                    {
                        if (RoleInfoM.instance.isSkinExit(goods.typeID))
                        {
                            arr.push({id: c.id, txt: c.re_rewardName, image: c.re_rewardUrl, count: c.re_award});
                        }
                        else
                        {
                            arr.push({id: c.id, txt: c.rewardName, image: c.rewardUrl, count: c.award});
                        }
                    }
                    else
                    {
                        arr.push({id: c.id, txt: c.rewardName, image: c.rewardUrl, count: c.award});
                    }

                    //arr.push({txt:{text:c.rewardName},image:{skin:c.rewardUrl},count:{value:c.award}});
                }
            }
            return arr;
        }

        public function get sortArr():Array
        {
            var arr:Array = []
            if (_currentList != null)
            {
                arr = currentList.sort(function (a:Object, b:Object)
                {
                    var agentA:Number = Number(a.type);
                    var agentB:Number = Number(b.type);
                    if (agentA < agentB)
                    {
                        return 1;
                    } else if (agentA > agentB)
                    {
                        return -1;
                    } else
                    {
                        return 0;
                    }
                });
            }
            return arr

        }

        public function get RecordArr():Array
        {
            var arr:Array = [];
            if (currentList != null)
            {
                if (currentList.length > 4)
                {
                    for (var i:int = 0; i < 4; i++)
                    {
                        var typeId:Number = currentList[i].type;
                        var goodId:Number = currentList[i].reward[0].t;
                        var goodNum:Number = currentList[i].reward[0].v;
                        var userName:String = LoginInfoM.instance.filterName(GameTools.formatNickName(currentList[i].nickname, 10));
                        arr.push(getlotteryRecord(typeId, goodId, goodNum, userName));
                    }
                } else
                {
                    for (var j:int = 0; j < currentList.length; j++)
                    {
                        var typeId:Number = currentList[j].type;
                        var goodId:Number = currentList[j].reward[0].t;
                        var goodNum:Number = currentList[j].reward[0].v;
                        var userName:String = LoginInfoM.instance.filterName(GameTools.formatNickName(currentList[j].nickname, 10));
                        arr.push(getlotteryRecord(typeId, goodId, goodNum, userName));
                    }
                }
            }
            return arr;
        }

        public function getCurrentList():void
        {

        }

        public function rewardName(id:String):String
        {
            var c:cfg_rewardDetails = cfg_rewardDetails.instance(id);
            if (ActivityM.instance.redPackTicketContinueTime)
            {
                return c.red_pack_activity_Name;
            } else
            {
                return c.rewardName;
            }
        }

        public function conditonValue(id:int):Number
        {
            var rewardArr:Array = reward[aniNames[id] + ""];
            var c:cfg_rewardDetails = cfg_rewardDetails.instance(rewardArr[0]);
            return c.condition[1];
        }

        public function conditionShowValue(id:int):Number
        {
            var rewardArr:Array = reward[aniNames[id] + ""];
            var c:cfg_rewardDetails = cfg_rewardDetails.instance(rewardArr[0]);
            return c.com_fish_coin;
        }

        public function imageUrl(id:String):String
        {
            var c:cfg_rewardDetails = cfg_rewardDetails.instance(id);
            var goodsId:Number = 0;
            if (ActivityM.instance.redPackTicketContinueTime)
            {
                goodsId = c.red_pack_activity_goodId;
            } else
            {
                goodsId = c.goodId;
            }
            var cfg:cfg_goods = cfg_goods.instance(goodsId + "");
            return cfg.icon;
        }

        public function goodsId(id:String):Number
        {
            var c:cfg_rewardDetails = cfg_rewardDetails.instance(id);
            var goodsId:Number = 0;
            if (ActivityM.instance.redPackTicketContinueTime)
            {
                goodsId = c.red_pack_activity_goodId;
            } else
            {
                goodsId = c.goodId;
            }
            return goodsId;
        }

        public function rewardCount(id:String):Number
        {
            var c:cfg_rewardDetails = cfg_rewardDetails.instance(id);
            var awardArr:Array;
            if (ActivityM.instance.redPackTicketContinueTime)
            {
                awardArr = c.red_pack_activity_award;
            } else
            {
                awardArr = c.award;
            }

            return awardArr[1];
        }

        public function baseFishCount():Number
        {
            var c:cfg_rewardDetails = cfg_rewardDetails.instance("101");
            return c.condition[0];
        }

        public function selectTab(coin:Number):Number
        {
            if (coin >= conditonValue(0) && coin < conditonValue(1))
            {
                return 0;
            } else if (coin >= conditonValue(1) && coin < conditonValue(2))
            {
                return 1;
            } else if (coin >= conditonValue(2) && coin < conditonValue(3))
            {
                return 2
            } else if (coin >= conditonValue(3) && coin < conditonValue(4))
            {
                return 3
            } else if (coin >= conditonValue(4) && coin < conditonValue(5))
            {
                return 4
            } else if (coin >= conditonValue(5))
            {
                return 5
            } else
            {
                return 0;
            }
        }


        public function setName(coin:Number):String
        {
            if (coin >= conditonValue(0) && coin < conditonValue(1))
            {
                return "普通抽奖";
            } else if (coin >= conditonValue(1) && coin < conditonValue(2))
            {
                return "青铜抽奖";
            } else if (coin >= conditonValue(2) && coin < conditonValue(3))
            {
                return "白银抽奖"
            } else if (coin >= conditonValue(3) && coin < conditonValue(4))
            {
                return "黄金抽奖"
            } else if (coin >= conditonValue(4) && coin < conditonValue(5))
            {
                return "钻石抽奖"
            } else if (coin >= conditonValue(5))
            {
                return "至尊抽奖"
            } else
            {
                return "普通抽奖";
            }
        }

        public function getlotteryName(id:Number):String
        {
            var c:cfg_rewardDetails = cfg_rewardDetails.instance(id);
            return c.reward_type;

        }


        public function url(award:Array):String
        {
            var goodsId:Number = award[0]
            var cfg_good:cfg_goods = cfg_goods.instance(goodsId + "");
            return cfg_good.icon;
        }

        public function isCollect(value:Number):void
        {
            _isCollect = value;
        }


    }
}
