package view.match
{


    import control.RedpointC;
    import control.WxC;

    import engine.tool.StartParam;

    import model.ActivityM;
    import model.LoginInfoM;

    import model.LoginInfoM;
    import model.LoginM;
    import model.MatchM;
    import model.RoleInfoM;

    import conf.cfg_battery;
    import conf.cfg_goods;
    import conf.cfg_scene;

    import laya.events.Event;
    import laya.ui.Box;
    import laya.ui.Button;
    import laya.ui.FontClip;
    import laya.ui.Image;
    import laya.ui.Label;
    import laya.ui.List;
    import laya.utils.Handler;

    import manager.ApiManager;
    import manager.ConfigManager;
    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;
    import manager.WebSocketManager;

    import struct.QuitTipInfo;

    import ui.abbey.MatchPageUI;

    public class MatchPage extends MatchPageUI implements ResVo
    {

        private var _startX:Number = 0;
        private var _startY:Number = 0;


        private var select_type:String = "";


        private var cache_time:Number = 5000;//接口缓存毫秒数
        private var last_time:Number = 0;

        //比赛列表数据
        private var match_data:Object = {}

        //获胜比赛列表数据
        private var win_match_data:Object = {}


        private var match_list_arr:Array = []

        private var win_match_list_arr:Array = []

        private var select_match_data:Object = {}

        public function MatchPage()
        {

        }

        //    'daily','challenge', 'match', 'snatch'
        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;
            bmask.on(Event.CLICK, this, null)
            joinBox.visible = false;
            _startX = this.x;
            _startY = this.y;
            list1.array = [];
            quitBtn.on(Event.CLICK, this, onQuitBtnClick);
            rankQuitBtn.on(Event.CLICK, this, onRankQuitBtnClick);
            ruleQuitBtn.on(Event.CLICK, this, onRuleQuitBtnClick);

            rule_btn.on(Event.CLICK, this, onClickRuleBtn)
            joinBtn.on(Event.CLICK, this, onJoinBtn);
            list1.renderHandler = new Handler(this, updateItem);
            list_rank.renderHandler = new Handler(this, updateDailyRankItem);
            list_rank2.renderHandler = new Handler(this, updateChallengeRankItem);

            tab1.on(Event.CLICK, this, onTab1Btn)
            tab2.on(Event.CLICK, this, onTab2Btn)
            tab3.on(Event.CLICK, this, onTab3Btn)
            tab4.on(Event.CLICK, this, onTab4Btn)

            screenResize();
            onTab1Btn();
            addActivityPointShow();
            rank_box.visible = false
            rule_box.visible = false
        }

        private function addActivityPointShow():void
        {
            var vertical_h = 10
            var horizontal_percent = 0.75

            if (ActivityM.instance.isShowDayMatchRebate)
            {
                RedpointC.instance.removeActivityPoint(tab1)
                RedpointC.instance.addActivityPointToIcon(tab1, horizontal_percent, vertical_h, false)
            } else
            {
                RedpointC.instance.removeActivityPoint(tab1)
            }
        }

        private function onJoinBtn():void
        {
            var value:String = roomInput.text;
            var pattern_room:RegExp = /^[0-9]*[1-9][0-9]*$/;//正整数包括零
            if (pattern_room.test(value))
            {
                MatchM.instance.initMatchimgGameData();
                var roomId:Number = parseInt(value);
                LoginM.instance.roomId = roomId;
                WebSocketManager.instance.send(12110, {roomNumber: LoginM.instance.roomId});
            } else
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请输入正确的房间号")
            }
        }

        private function synFindMatchGameData():void
        {
            if (!RoleInfoM.instance.isConsumeEnough(MatchM.instance.findRoomData.costId, MatchM.instance.findRoomData.costNum) && !MatchM.instance.findRoomData.isFree)
            {
                if (MatchM.instance.findRoomData.costId == GameConst.currency_coin)
                {

                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "金币不足");
                }
                else if (MatchM.instance.findRoomData.costId == GameConst.currency_diamond)
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "钻石不足");
                } else
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "鱼雷不足");
                }

            } else
            {
                var content:String = "确认报名？"
                if (MatchM.instance.findRoomData.isFree)
                {
                    content = "确认报名（本场比赛可免费进行)"
                } else
                {
                    if (MatchM.instance.findRoomData.costId == GameConst.currency_coin)
                    {
                        content = "确认报名（本场比赛需花费" + MatchM.instance.findRoomData.costNum + "金币)"
                    }
                    else if (MatchM.instance.findRoomData.costId == GameConst.currency_diamond)
                    {
                        content = "确认报名（本场比赛需花费" + MatchM.instance.findRoomData.costNum + "钻石)"
                    } else
                    {
                        content = "确认报名（本场比赛需花费" + MatchM.instance.findRoomData.costNum + "枚普通鱼雷)"
                    }
                }
                var info:QuitTipInfo = new QuitTipInfo();
                info.state = GameConst.quit_state_left_cancel_right_confirm;
                info.content = content;
                info.confirmCallback = Handler.create(this, joinRoomSuccess);
                info.autoCloseTime = 10;
                GameEventDispatch.instance.event(GameEvent.QuitTip, info);
            }
        }

        private function joinRoomSuccess():void
        {
            LoginM.instance.setContestId(LoginM.instance.roomId, GameConst.contest_match_scene_id);
            GameEventDispatch.instance.event(GameEvent.StartLoad, [GameConst.loadFishState]);
        }

        public function clearAllElement():void
        {
            tab1.selected = false
            tab2.selected = false
            tab3.selected = false
            tab4.selected = false
            list1.visible = false
            joinBox.visible = false;
            list1.height = 420;
        }


        public function onTab4Btn():void
        {
            clearAllElement();
            tab4.selected = true
            //            list1.scrollTo(0)
            list1.visible = true
            roomInput.text = "";
            select_type = "snatch"
            getMatchList()
            getWinMatchList()
        }

        public function onTab3Btn():void
        {
            clearAllElement()
            tab3.selected = true
            //            list1.scrollTo(0)
            list1.visible = true
            joinBox.visible = true;
            select_type = "match"
            getMatchList()
            getWinMatchList()
            list1.height = 332;
        }

        public function onTab2Btn():void
        {
            clearAllElement()
            tab2.selected = true
            //            list1.scrollTo(0)
            list1.visible = true
            roomInput.text = "";
            select_type = "challenge"
            getMatchList()
            getWinMatchList()
        }

        public function onTab1Btn():void
        {
            clearAllElement()
            tab1.selected = true
            //            list1.scrollTo(0)
            list1.visible = true
            roomInput.text = "";
            select_type = "daily"
            getMatchList()
            getWinMatchList()
        }

        public function getWinMatchList():void
        {
            var token:String = StartParam.instance.getParam("access_token");
            ApiManager.instance.get_not_receive_reward(
                    token,
                    Handler.create(this, function (result:Object)
                    {
                        win_match_data = result.data

                        setMatchListDate()
                        wait_ani.visible = false;
                    }),
                    Handler.create(this, function (result:Object)
                    {
                        console.log("获取胜利比赛列表出错")
                        console.log(result)
                    })
            )
        }

        public function getMatchList():void
        {
            var token:String = StartParam.instance.getParam("access_token");

            var cur_d:Date = new Date();
            var cur_time:Number = cur_d.getTime();

            if (((cur_time - last_time)) > cache_time)
            {
                last_time = cur_time
                wait_ani.visible = true;
                ApiManager.instance.get_match_list(
                        token,
                        Handler.create(this, function (result:Object)
                        {
                            match_data = result.data
                            setMatchListDate()
                            wait_ani.visible = false;
                        }),
                        Handler.create(this, function (result:Object)
                        {
                            console.log("获取比赛列表出错")
                            console.log(result)
                        })
                )

            } else
            {
                setMatchListDate();
            }


        }

        private function setMatchListDate():void
        {
            if (select_type)
            {
                if (match_data)
                {
                    match_list_arr = match_data[select_type] || []
                }

                if (win_match_data)
                {
                    win_match_list_arr = win_match_data[select_type] || []
                }
                for (var i = 0; i < win_match_list_arr.length; i++)
                {
                    win_match_list_arr[i].is_win = true
                    win_match_list_arr[i].name = win_match_list_arr[i].contest_name
                }
                for (var i = 0; i < match_list_arr.length; i++)
                {
                    match_list_arr[i].is_win = false
                }

                var not_start_arr:Array = []
                var start_arr:Array = []
                var end_arr:Array = []


                for (var i = 0; i < match_list_arr.length; i++)
                {
                    var execute_status:String = match_list_arr[i].execute_status
                    if (execute_status == "not_start")
                    {
                        not_start_arr.push(match_list_arr[i])
                    } else if (execute_status == "start")
                    {
                        if (match_list_arr[i].sub_type == 2)
                        {
                            start_arr.unshift(match_list_arr[i])
                        } else
                        {
                            start_arr.push(match_list_arr[i])
                        }
                    } else if (execute_status == "end")
                    {
                        end_arr.push(match_list_arr[i])
                    }
                }


                list1.array = win_match_list_arr.concat(start_arr).concat(not_start_arr).concat(end_arr);
            }
        }


        private function screenResize():void
        {
            var contentWidth:int = 850;//组件范围widthGameEventDispatch.instance.off(GameEvent.ScreenResize,this,screenResize);
            var contentHeight:int = 660;//组件范围height
            var contentStartX:int = 215;//组件左边距
            var contentStartY:int = 30;//组件上边距
            var posXOff:Number = (Laya.stage.width - contentWidth) / 2;
            var posYOff:Number = (Laya.stage.height - contentHeight) / 2;
            this.pos(_startX + posXOff - contentStartX, _startY + posYOff - contentStartY);
            this.size(Laya.stage.width, Laya.stage.height);

            quitBtn.left = contentStartX - posXOff;
            quitBtn.top = contentStartY - posYOff;
            rankQuitBtn.left = contentStartX - posXOff;
            rankQuitBtn.top = contentStartY - posYOff;

            ruleQuitBtn.left = contentStartX - posXOff;
            ruleQuitBtn.top = contentStartY - posYOff;

        }


        private function match_sign(d:Object)
        {
            MatchM.instance.initMatchimgGameData();
            LoginM.instance.setContestId(d.id, d.scene_id);
            GameEventDispatch.instance.event(GameEvent.StartLoad, [GameConst.loadFishState]);
        }


        public function getMatchRank():void
        {
            var token:String = StartParam.instance.getParam("access_token");
            var match_rank_arr:Array = [];
            var rewards_arr:Array = select_match_data.reward_set
            for (var i:Number = 0; i < rewards_arr.length; i++)
            {
                var rewards:Array = []
                for (var j:Number = 0; j < rewards_arr[i].length; j += 2)
                {
                    rewards.push({reward_item_id: rewards_arr[i][j], reward_item_num: rewards_arr[i][j + 1]})
                }
                match_rank_arr.push({rewards: rewards, rank: i + 1})
            }

            wait_ani.visible = true;
            var match_id:Number = null
            if (select_match_data['is_win'])
            {
                match_id = select_match_data.contest_id
            } else
            {
                match_id = select_match_data.id
            }


            ApiManager.instance.get_contest_daily_rank_list(
                    token,
                    match_id,
                    Handler.create(this, function (result:Object)
                    {
                        var data = result.data;

                        for (var i = 0; i < data['top'].length; i++)
                        {
                            match_rank_arr[i].avatar = data['top'][i].avatar
                            match_rank_arr[i].nickname = data['top'][i].nickname
                            match_rank_arr[i].integral = data['top'][i].integral
                        }

                        list_rank.array = match_rank_arr
                        if (data['max_place'] > 0)
                        {
                            myrank.text = data['max_place'] + ""
                        } else
                        {
                            myrank.text = "未上榜"
                        }

                        list_rank.refresh()
                        wait_ani.visible = false;
                    }),
                    Handler.create(this, function (result:Object)
                    {
                        console.log("获取比赛排名列表出错")
                        console.log(result)
                    })
            )


        }

        private function format(st)
        {
            //        return st.getFullYear() + '-' + (st.getMonth() + 1) + '-' + st.getDate() + ' ' + st.getHours() + ':' + st.getMinutes() + ':' + st.getSeconds()
            return st.getHours() + ':' + (st.getMinutes() < 10 ? "0" : "") + st.getMinutes()
        }

        private function init_rule():void
        {
            if (select_match_data)
            {
                if (select_match_data.type == 'daily')
                {
                    rule_match_type.text = "日常赛"
                } else if (select_match_data.type == 'challenge')
                {
                    rule_match_type.text = "挑战赛"
                } else if (select_match_data.type == 'match')
                {
                    rule_match_type.text = "匹配赛"
                }
                var st = new Date(select_match_data['start_time'] * 1000)
                var et = new Date(select_match_data['end_time'] * 1000)

                rule_match_time.text = format(st) + '~' + format(et)

                var time_span:Number = select_match_data['end_time'] - select_match_data['start_time']

                rule_match_long.text = select_match_data.continue_time + "秒"

                var cfg:cfg_scene = cfg_scene.instance(select_match_data.scene_id);

                rule_match_battery.text = cfg_battery.instance(cfg.unlock).comsume + "倍炮解锁"

                rule_match_desc.text = cfg.description
            }
        }

        private function onDailyMatchClick(d:Object):void
        {
            select_match_data = d
            rank_box.visible = true
            daily_box.visible = true
            challenge_box.visible = false

            match_title.text = select_match_data['name']

            updateSignBtn(rank_sign_box, select_match_data)
            init_rule()
            list_rank.scrollTo(0)
            getMatchRank()
        }

        private function onMatchMatchClick(d:Object):void
        {
            select_match_data = d
            rank_box.visible = true
            daily_box.visible = false
            challenge_box.visible = true

            match_title.text = select_match_data['name']

            updateSignBtn(rank_sign_box, select_match_data)
            init_rule()
            list_rank2.scrollTo(0)
            var arr2:Array = [];
            arr2.push(select_match_data['reward_set'][2])
            arr2.push(select_match_data['reward_set'][3])
            arr2.push(select_match_data['reward_set'][4])
            list_rank2.array = arr2;
        }

        private function onChallengeMatchClick(d:Object):void
        {
            select_match_data = d
            match_title.text = select_match_data['name']
            rank_box.visible = true
            daily_box.visible = false
            challenge_box.visible = true
            updateSignBtn(rank_sign_box, select_match_data)
            init_rule()
            list_rank2.scrollTo(0)
            var arr2:Array = select_match_data['reward_set'].slice(0)
            list_rank2.array = arr2.reverse()
        }

        private function updateChallengeRankItem(cell:Box, index:int):void
        {
            var d:Object = cell.dataSource;
            var ele_rank:Label = cell.getChildByName("rank") as Label;

            var rewardsSet:Array = [];
            if (select_match_data["type"] == "match")
            {
                ele_rank.text = (index + 2) + "人局";
                rewardsSet = d[0];
            } else
            {
                ele_rank.text = "第" + (select_match_data["max_second"] - index) + "轮";
                rewardsSet = d as Array;
            }

            var ele_list_reward:List = cell.getChildByName("list_reward") as List;
            ele_list_reward.renderHandler = new Handler(this, updateItemReward);

            var rewards:Array = []
            for (var i:Number = 0; i < rewardsSet.length; i += 2)
            {
                rewards.push({reward_item_id: rewardsSet[i], reward_item_num: rewardsSet[i + 1]})
            }

            ele_list_reward.array = rewards;
            if (rewards.length == 1)
            {
                ele_list_reward.pivotX = -100;
            } else
            {
                ele_list_reward.pivotX = 0
            }
        }

        private function updateDailyRankItem(cell:Box, index:int):void
        {
            var d:Object = cell.dataSource;

            var ele_player_name:Label = cell.getChildByName("player_name") as Label;
            var ele_level:Label = cell.getChildByName("imgBox").getChildByName("level") as Label;
            var ele_image:Image = cell.getChildByName("imgBox").getChildByName("playimg") as Image;

            var ele_point:Label = cell.getChildByName("point") as Label


            var ele_rank_icon:Image = cell.getChildByName("rank_icon") as Image;
            var ele_rank:Label = cell.getChildByName("rank") as Label;

            ele_rank_icon.visible = false;
            ele_rank.visible = false;

            if (0 == index)
            {
                ele_rank_icon.visible = true
                ele_rank_icon.skin = "ui/match/rank1.png"
            } else if (1 == index)
            {
                ele_rank_icon.visible = true
                ele_rank_icon.skin = "ui/match/rank2.png"
            } else if (2 == index)
            {
                ele_rank_icon.visible = true
                ele_rank_icon.skin = "ui/match/rank3.png"
            } else
            {
                ele_rank.visible = true;
                ele_rank.text = index + 1 + "";
            }


            ele_image.skin = "ui/common/nan.png";
            if (d.avatar)
            {
                ele_image.skin = d.avatar
            } else
            {
                ele_image.skin = "ui/common/nan.png"
            }

            if (d.nickname)
            {
                ele_player_name.text = LoginInfoM.instance.filterName(d.nickname);
            } else
            {
                ele_player_name.text = "";
            }

            if (d.integral >= 0 && d.integral != null)
            {
                ele_point.text = d.integral + "";
            } else
            {
                ele_point.text = "";

            }

            if (d.level)
            {
                ele_level.text = "lv：" + d.level;
            } else
            {

                ele_level.text = ""
            }


            var ele_list_reward:List = cell.getChildByName("list_reward") as List;
            ele_list_reward.renderHandler = new Handler(this, updateItemReward);

            var rewards:Array = d.rewards;

            ele_list_reward.array = rewards;
            if (rewards.length == 1)
            {
                ele_list_reward.pivotX = -100;
            } else
            {
                ele_list_reward.pivotX = 0
            }
        }

        private function updateSignBtn(cell:Box, d:Object):void
        {
            var ele_sign_text:Image = cell.getChildByName("sign_text") as Image;
            var ele_accept_text:Image = cell.getChildByName("accept_text") as Image;

            var ele_sign_price:FontClip = cell.getChildByName("sign_price") as FontClip;
            var ele_sign_price_unit:Image = cell.getChildByName("sign_price_unit") as Image;

            var ele_join_btn:Button = cell.getChildByName("join_btn") as Button;

            if (!d["consume_goods_id"])
            {
                d["consume_goods_id"] = GameConst.currency_coin;
            }

            ele_sign_price_unit.skin = ConfigManager.getConfValue("cfg_goods", d["consume_goods_id"], "waceIcon") as String;

            ele_sign_text.visible = false
            ele_sign_price.visible = false
            ele_sign_price_unit.visible = false
            ele_accept_text.visible = false

            ele_join_btn.gray = false
            ele_sign_price_unit.gray = false
            ele_sign_price.gray = false
            ele_sign_text.gray = false
            ele_join_btn.gray = false

            ele_join_btn.offAll(Event.CLICK)
            var cfg:cfg_scene = cfg_scene.instance(d.scene_id);

            if (d.is_win)
            {
                ele_accept_text.visible = true
                ele_join_btn.on(Event.CLICK, this, function (event:Event)
                        {
                            event.stopPropagation();
                            WebSocketManager.instance.send(35005, {contest_id: d.contest_id})
                        }
                )
            } else
            {
                ele_join_btn.gray = false
                ele_sign_price_unit.gray = false
                ele_sign_price.gray = false
                ele_sign_text.gray = false
                ele_join_btn.gray = false
                //领取 ui/common_ex/t_accept.png
                //免费报名 ui/match/mianfei.png
                //已过期  ui/common_ex/t_expired.png


                if (d.execute_status == "not_start")
                {
                    ele_sign_text.skin = "ui/match/mianfei.png"
                    ele_sign_text.visible = true
                    ele_sign_text.gray = true
                    ele_join_btn.gray = true
                    ele_join_btn.on(Event.CLICK, this, function (event:Event)
                            {
                                event.stopPropagation();
                                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "比赛未开始");
                            }
                    )
                } else if (d.execute_status == "end")
                {
                    ele_sign_text.skin = "ui/common_ex/t_expired.png"
                    ele_sign_text.visible = true
                    ele_sign_text.gray = true
                    ele_join_btn.gray = true
                    ele_join_btn.on(Event.CLICK, this, function (event:Event)
                            {
                                event.stopPropagation();
                                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "比赛已结束");
                            }
                    )

                } else if (d.execute_status == "start")
                {
                    if (d.free_times > 0)
                    {
                        ele_sign_text.skin = "ui/match/mianfei.png"
                        ele_sign_text.visible = true

                    } else
                    {
                        ele_sign_text.visible = false
                        ele_sign_price.visible = true
                        ele_sign_price_unit.visible = true
                        ele_sign_price.value = d.consume_gold
                    }

                    if (RoleInfoM.instance.getBattery() >= cfg.unlock)
                    {
                        //                    if (d.consume_gold > RoleInfoM.instance.getCoin() && d.free_times <= 0) {
                        if (!RoleInfoM.instance.isConsumeEnough(d.consume_goods_id, d.consume_gold) && d.free_times <= 0)
                        {
                            ele_sign_text.gray = true
                            ele_join_btn.gray = true
                            ele_sign_price.gray = true
                            ele_sign_price_unit.gray = true
                            ele_join_btn.on(Event.CLICK, this, function (event:Event)
                                    {
                                        event.stopPropagation();
                                        if (d.consume_goods_id == GameConst.currency_coin)
                                        {

                                            GameEventDispatch.instance.event(GameEvent.MsgTipContent, "金币不足");
                                        }
                                        else if (d.consume_goods_id == GameConst.currency_diamond)
                                        {
                                            GameEventDispatch.instance.event(GameEvent.MsgTipContent, "钻石不足");
                                        } else
                                        {
                                            GameEventDispatch.instance.event(GameEvent.MsgTipContent, "鱼雷不足");
                                        }
                                    }
                            )

                        } else
                        {

                            var content:String = "确认报名？"
                            if (d.free_times > 0)
                            {
                                content = "确认报名（本场比赛可免费进行)"
                            } else
                            {
                                if (d.consume_goods_id == GameConst.currency_coin)
                                {
                                    content = "确认报名（本场比赛需花费" + d.consume_gold + "金币)"
                                }
                                else if (d.consume_goods_id == GameConst.currency_diamond)
                                {
                                    content = "确认报名（本场比赛需花费" + d.consume_gold + "钻石)"
                                } else
                                {
                                    content = "确认报名（本场比赛需花费" + d.consume_gold + "枚普通鱼雷)"
                                }
                            }

                            ele_join_btn.on(Event.CLICK, this, function (event:Event)
                                    {
                                        event.stopPropagation();
                                        var info:QuitTipInfo = new QuitTipInfo();
                                        info.state = GameConst.quit_state_left_cancel_right_confirm;
                                        info.content = content;
                                        info.confirmCallback = Handler.create(this, match_sign, [d]);
                                        info.conFirmArgs = d;
                                        info.autoCloseTime = 10;
                                        GameEventDispatch.instance.event(GameEvent.QuitTip, info);
                                    }
                            )

                        }
                    } else
                    {
                        ele_sign_text.gray = true
                        ele_join_btn.gray = true
                        ele_sign_price.gray = true
                        ele_sign_price_unit.gray = true
                        ele_join_btn.on(Event.CLICK, this, function (event:Event)
                                {
                                    event.stopPropagation();
                                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, cfg_battery.instance(cfg.unlock).comsume + "倍炮解锁");
                                }
                        )

                    }
                }
            }

        }

        private function updateItem(cell:Box, index:int):void
        {
            var d:Object = cell.dataSource;

            var ele_match_name:Label = cell.getChildByName("match_name") as Label;

            var ele_time_label:Label = cell.getChildByName("time_label") as Label;
            var ele_clock_image:Image = cell.getChildByName("clock") as Image;
            var match_head_icon_img:Image = cell.getChildByName("match_head_icon") as Image;


            var cfg:cfg_scene = cfg_scene.instance(d.scene_id);

            var begin_time = new Date(d.start_time * 1000)
            var end_time = new Date(d.end_time * 1000)

            var begin_minutes = (begin_time.getMinutes() < 10 ? "0" : "") + begin_time.getMinutes()
            var end_minutes = (end_time.getMinutes() < 10 ? "0" : "") + end_time.getMinutes()

            ele_time_label.text = begin_time.getHours() + ":" + begin_minutes + "~" + end_time.getHours() + ":" + end_minutes

            var ele_list_reward:List = cell.getChildByName("list_reward") as List;


            cell.offAll(Event.CLICK)
            ele_list_reward.renderHandler = new Handler(this, updateItemReward);

            updateSignBtn(cell, d)
            if (d.is_win)
            {
                ele_time_label.visible = false

                ele_match_name.text = d.contest_name
                var rewards_arr = d.reward_set[0]
                var rewards = []
                for (var i = 0; i < rewards_arr.length; i = i + 2)
                {
                    rewards.push({
                        reward_item_id: rewards_arr[i],
                        reward_item_num: rewards_arr[i + 1]
                    })
                }
                ele_list_reward.array = rewards
                match_head_icon_img.skin = cfg_goods.instance(rewards_arr[0]).icon
                ele_clock_image.visible = false

                cell.on(Event.CLICK, this, onDailyMatchClick, [d])
            } else
            {
                ele_clock_image.visible = true
                ele_time_label.visible = true
                if ("daily" == d.type)
                {
                    cell.on(Event.CLICK, this, onDailyMatchClick, [d])
                } else if ("challenge" == d.type)
                {
                    cell.on(Event.CLICK, this, onChallengeMatchClick, [d])
                } else if ("match" == d.type)
                {
                    cell.on(Event.CLICK, this, onMatchMatchClick, [d])
                }


                ele_match_name.text = d.name
                var rewards_arr = d.reward_set
                var show_rewards_arr:Array = []
                if ("match" == d.type)
                {
                    show_rewards_arr = rewards_arr[4][0];
                } else if ("challenge" == d.type)
                {
                    show_rewards_arr = rewards_arr[rewards_arr.length - 1]
                } else
                {
                    show_rewards_arr = rewards_arr[0]
                }

                match_head_icon_img.skin = cfg_goods.instance(show_rewards_arr[0]).icon
                var rewards = []
                for (var i = 0; i < show_rewards_arr.length; i = i + 2)
                {
                    rewards.push({
                        reward_item_id: show_rewards_arr[i],
                        reward_item_num: show_rewards_arr[i + 1]
                    })
                }
                ele_list_reward.array = rewards
            }
        }

        private function updateItemReward(cell:Box, index:int):void
        {
            var ele_reward_img:Image = cell.getChildByName("reward_type") as Image;
            var ele_reward_text:Label = cell.getChildByName("reward_text") as Label;
            var data:Object = cell.dataSource;

            ele_reward_img.skin = cfg_goods.instance(data.reward_item_id + "").icon;
            ele_reward_text.text = 'x ' + ActivityM.instance.exchangeConversion(data.reward_item_id, data.reward_item_num);
        }


        private function onQuitBtnClick():void
        {
            UiManager.instance.closePanel("Match", true);
        }

        private function onRankQuitBtnClick():void
        {
            rank_box.visible = false
        }

        private function onRuleQuitBtnClick():void
        {
            rule_box.visible = false
        }

        private function onClickRuleBtn():void
        {
            rule_box.visible = true
        }


        //'daily', 'match', 'snatch', 'challenge'
        private function endDailyMatchSign():void
        {
            UiManager.instance.closePanel("Match", true);
        }

        private function endSnatchMatchSign():void
        {
            UiManager.instance.closePanel("Match", true);
        }

        private function endDailyAcceptReward():void
        {
            onTab1Btn()
            rank_box.visible = false
        }

        public function noviceSignContest():void
        {
            var d = list1.cells[0].dataSource
            if (d.execute_status == "start")
            {
                var content:String = "确认报名？"
                var info:QuitTipInfo = new QuitTipInfo();
                info.state = GameConst.quit_state_left_cancel_right_confirm;
                info.content = content;
                info.confirmCallback = Handler.create(this, match_sign, [d]);
                info.conFirmArgs = d;
                info.autoCloseTime = 0;
                GameEventDispatch.instance.event(GameEvent.QuitTip, info);
            } else
            {
                if (d.execute_status == "not_start")
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "比赛未开始");

                } else if (d.execute_status == "end")
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "比赛已结束");
                }
                GameEventDispatch.instance.event(GameEvent.CloseNovice, null);
            }


        }

        public function noviceSignContestConfirm():void
        {
            var d = list1.cells[0].dataSource
            match_sign(d)
        }

        public function unRegister():void
        {
            GameEventDispatch.instance.off(GameEvent.SynFindMatchGameData, this, synFindMatchGameData);
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.off(GameEvent.EndDailyMatchSign, this, endDailyMatchSign);
            GameEventDispatch.instance.off(GameEvent.EndSnatchMatchSign, this, endSnatchMatchSign);
            GameEventDispatch.instance.off(GameEvent.EndAcceptDailyMatchReward, this, endDailyAcceptReward);
            GameEventDispatch.instance.off(GameEvent.NoviceSignContest, this, noviceSignContest);
            GameEventDispatch.instance.off(GameEvent.NoviceSignContestConfirm, this, noviceSignContestConfirm);

        }


        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.SynFindMatchGameData, this, synFindMatchGameData);
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.on(GameEvent.EndDailyMatchSign, this, endDailyMatchSign);
            GameEventDispatch.instance.on(GameEvent.EndSnatchMatchSign, this, endSnatchMatchSign);
            GameEventDispatch.instance.on(GameEvent.EndAcceptDailyMatchReward, this, endDailyAcceptReward);
            GameEventDispatch.instance.on(GameEvent.NoviceSignContest, this, noviceSignContest);
            GameEventDispatch.instance.on(GameEvent.NoviceSignContestConfirm, this, noviceSignContestConfirm);


        }

    }
}
