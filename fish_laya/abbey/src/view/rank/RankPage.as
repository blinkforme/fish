package view.rank
{
    import conf.cfg_goods;
    import conf.cfg_goods;

    import control.WxC;

    import engine.tool.StartParam;

    import laya.events.Event;
    import laya.ui.Box;
    import laya.ui.FontClip;
    import laya.ui.Image;
    import laya.ui.Label;
    import laya.utils.Handler;

    import manager.ApiManager;
    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.GameTools;
    import manager.ResVo;
    import manager.UiManager;
    import manager.WebSocketManager;

    import model.ActivityM;

    import model.LevelM;
    import model.LoginInfoM;
    import model.LoginM;
    import model.RoleInfoM;

    import struct.QuitTipInfo;

    import ui.abbey.RankPageUI;

    import model.FriendM;

    public class RankPage extends RankPageUI implements ResVo
    {
        private var select_type:int = 0;//0--财富  1--实力

        private var my_gold_rank:int;
        private var my_gold_reward:Array = [1, 0];
        private var my_strength_rank:int;
        private var my_strength_reward:Array = [1, 0];
        private var gold_rank_list:Array;
        private var strength_rank_list:Array;

        private var strengthRankDes:String = "<span style='color:white'>根据当日捕鱼消耗进行排名，排行榜每10分钟更新一次；</span><span style='color:red;font-weight:bold'>奖励只保留一天</span><span style='color:white'>，请及时领取</span>"
        private var coinRankDes:String = "<span style='color:white'>根据携带金币数量进行排名，排行榜每10分钟更新一次；</span><span style='color:red;font-weight:bold'>奖励只保留一天</span><span style='color:white'>，请及时领取</span>"

        private var last_time:Number = 0;
        private var match_data:Object = {};

        private var clickRewardBtn:Array = [0, 0];

        private var _startX:Number = 0;
        private var _startY:Number = 0;

        private var _giveAwayArr:Array;

        public function RankPage()
        {

        }


        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;
            bmask.on(Event.CLICK, this, null)
            desHTML.pos(-10, 6);
            desHTML.style.width = 776;
            desHTML.style.height = 29;
            desHTML.style.fontSize = 16;
            desHTML.style.align = "center";
            desHTML.style.valign = "middle";
            _startX = this.x;
            _startY = this.y;
            quitBtn.on(Event.CLICK, this, onQuitBtnClick);
            getRewardBtn.on(Event.CLICK, this, onGetRewardBtn);
            list1.renderHandler = new Handler(this, updateItem);

            gold_btn.on(Event.CLICK, this, onGoldBtn)
            strength_btn.on(Event.CLICK, this, onStrengthBtn)

            wait_ani.play(0, true);
            _giveAwayArr = [];
            if (ActivityM.instance.isShowMainRank)
            {
                if (WxC.isInMiniGame())
                {
                    _giveAwayArr = ActivityM.instance._getCommonActivityConfig(GameConst.activity_common_main_rank)["wx"];
                } else
                {
                    _giveAwayArr = ActivityM.instance._getCommonActivityConfig(GameConst.activity_common_main_rank)["h5"];
                }
            }
            if (LoginM.instance.pageId == GameConst.FISH_PAGE)
            {
                if (LevelM.instance.coinRankLv > 0)
                {
                    if (LevelM.instance.strengthRankLv > 0)
                    {
                        onStrengthBtn()
                    } else
                    {
                        onGoldBtn();
                    }
                } else
                {
                    onStrengthBtn()
                }
            } else
            {
                onGoldBtn();
            }
            screenResize();
        }

        private function onGetRewardBtn():void
        {
            if (clickRewardBtn[select_type] <= 0)
            {
                clickRewardBtn[select_type] = 1;
                WebSocketManager.instance.send(42001, {type: (select_type + 1)});
            } else
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "正在领取奖励，请勿频繁点击")
            }
        }

        private function synRankReward():void
        {
            getRewardBtn.visible = false;
            clickRewardBtn = [0, 0];
            var rankNum:Number = -1;
            var rankReward:Number = -1;
            if (0 == select_type)
            {
                if (LevelM.instance.coinReward.length > 0)
                {
                    getRewardBtn.visible = true;
                    rank_introduce.text = "昨日\n排名"
                    gold_introduce.text = "昨日\n奖励"
                    rankReward = LevelM.instance.coinReward[1];
                    rankNum = LevelM.instance.coinRankLv;
                } else
                {
                    rank_introduce.text = "我的\n排名"
                    gold_introduce.text = "我的\n奖励"
                    rankReward = my_gold_reward[1];
                    rankNum = my_gold_rank;

                }
                list1.array = gold_rank_list
            } else
            {
                if (LevelM.instance.strengthReward.length > 0)
                {
                    getRewardBtn.visible = true;
                    rank_introduce.text = "昨日\n排名"
                    gold_introduce.text = "昨日\n奖励"
                    rankReward = LevelM.instance.strengthReward[1];
                    rankNum = LevelM.instance.strengthRankLv;
                } else
                {
                    rank_introduce.text = "我的\n排名"
                    gold_introduce.text = "我的\n奖励"
                    rankReward = my_strength_reward[1];
                    rankNum = my_strength_rank;
                }
                list1.array = strength_rank_list
            }
            goldImg.skin = cfg_goods.instance(my_gold_reward[0] + "").waceIcon;
            goldLabel.text = rankReward + "";
            if ((rankNum > 1000) || (rankNum <= 0))
            {
                rank_num.text = "未上榜"
            } else
            {
                rank_num.text = rankNum + ""
            }
        }

        public function onGoldBtn():void
        {
            select_type = 0
            //        gold_btn.skin = "ui/rank/bg1.png"
            //        strength_btn.skin = "ui/rank/bg2.png"
            getRankList()
            desHTML.innerHTML = coinRankDes;
            list1.scrollTo(0)
            gold_btn.selected = true
            strength_btn.selected = false
        }

        public function onStrengthBtn():void
        {
            select_type = 1
            //        gold_btn.skin = "ui/rank/bg2.png"
            //        strength_btn.skin = "ui/rank/bg1.png"
            desHTML.innerHTML = strengthRankDes;
            getRankList()
            list1.scrollTo(0)
            gold_btn.selected = false
            strength_btn.selected = true
        }

        private function setDate():void
        {
            my_gold_rank = match_data["gold_top_me"];
            my_strength_rank = match_data["strength_top_me"];
            gold_rank_list = match_data["gold_top"];
            strength_rank_list = match_data["strength_top"]
            if (gold_rank_list[(my_gold_rank - 1) + ""] && gold_rank_list[(my_gold_rank - 1) + ""].reward.length > 0)
            {
                if (LevelM.instance.rankDoubleReward)
                {
                    my_gold_reward = [gold_rank_list[(my_gold_rank - 1) + ""].reward[0],
                        (parseInt(gold_rank_list[(my_gold_rank - 1) + ""].reward[1]) * 2)];
                } else
                {
                    my_gold_reward = gold_rank_list[(my_gold_rank - 1) + ""].reward;
                }
            } else
            {
                my_gold_reward = [1, 0];
            }
            if (strength_rank_list[(my_strength_rank - 1) + ""] && strength_rank_list[(my_strength_rank - 1) + ""].reward.length > 0)
            {
                if (LevelM.instance.rankDoubleReward)
                {
                    my_strength_reward = [strength_rank_list[(my_strength_rank - 1) + ""].reward[0],
                        (parseInt(strength_rank_list[(my_strength_rank - 1) + ""].reward[1]) * 2)];
                } else
                {
                    my_strength_reward = strength_rank_list[(my_strength_rank - 1) + ""].reward;
                }
            } else
            {
                my_strength_reward = [1, 0];
            }
            synRankReward();
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
        }


        public function getRankList(interval:Boolean = true):void
        {
            var token = StartParam.instance.getParam("access_token");
            var cur_d:Date = new Date();
            var cur_time:Number = cur_d.getTime();

            if (interval)
            {
                if (((cur_time - last_time) / 1000) > 3)
                {
                    last_time = cur_time
                    wait_ani.visible = true;
                    ApiManager.instance.get_rank_list(token, function (result:Object)
                    {
                        LevelM.instance.setTodayStrIsHaveReward(result);
                        match_data = result.data
                        setDate();
                        wait_ani.visible = false;
                    })

                } else
                {
                    setDate();
                }
            } else
            {
                last_time = cur_time
                wait_ani.visible = true;
                ApiManager.instance.get_rank_list(token, function (result:Object)
                {
                    match_data = result.data
                    setDate();
                    wait_ani.visible = false;
                })
            }
        }

        private function updateItem(cell:Box, index:int):void
        {
            var data:Object = cell.dataSource;
            var ele_player_name:Label = cell.getChildByName("player_name") as Label;
            var ele_rank_icon:Image = cell.getChildByName("rank_icon") as Image;
            var ele_rank:Label = cell.getChildByName("rank") as Label;
            var ele_level:Label = cell.getChildByName("level") as Label;
            var ele_bg:Image = cell.getChildByName("bg") as Image;
            var ele_image:Image = cell.getChildByName("imgBox").getChildByName("playimg") as Image;
            var goldBox:Box = cell.getChildByName("goldBox") as Box;
            var item_num:Label = goldBox.getChildByName("item_num") as Label;
            var ele_name_bg:Image = goldBox.getChildByName("name_bg") as Image;
            var item_img:Image = goldBox.getChildByName("item_img") as Image;
            var doubleImg:Image = cell.getChildByName("doubleImg") as Image;
            var giveawayBox:Box = cell.getChildByName("giveawayBox") as Box;
            giveawayBox.visible = false;
            if (ActivityM.instance.isShowMainRank)
            {
                var giveawayImg:Image = giveawayBox.getChildByName("giveawayImg") as Image;
                var giveawayLabel:FontClip = giveawayBox.getChildByName("giveawayLabel") as FontClip;
                if (select_type == 0)
                {
                    giveawayImg.skin = cfg_goods.instance(_giveAwayArr["gold"][index][0]).icon;
                    giveawayLabel.value = "" + _giveAwayArr["gold"][index][1];

                } else
                {
                    giveawayImg.skin = cfg_goods.instance(_giveAwayArr["strength"][index][0]).icon;
                    giveawayLabel.value = "" + _giveAwayArr["strength"][index][1];
                }
                giveawayBox.visible = true;
            }
            goldBox.visible = false;
            doubleImg.visible = false;
            if (data['reward'].length > 0)
            {
                item_num.text = data['reward'][1] + "";
                item_img.skin = cfg_goods.instance(data['reward'][0] + "").waceIcon;
                goldBox.visible = true;
                if (LevelM.instance.rankDoubleReward)
                {
                    doubleImg.visible = true;
                }
            }
            if (LoginM.instance.isNovicePlayer == true && data.is_hide == true)
            {
                ele_player_name.text = LoginM.instance.replaceRankName;
            } else
            {
                ele_player_name.text = LoginInfoM.instance.filterName(data["nickname"]);
            }
            if (GameTools.getStringTrueLength(data["nickname"]) > 14)
            {
                ele_player_name.fontSize = 16;
            } else
            {
                ele_player_name.fontSize = 18;
            }
            ele_rank_icon.visible = true;
            ele_rank.visible = false;
            ele_level.text = "lv." + data["level"];
            ele_image.skin = "ui/common/nan.png";
            if (data["avatar"])
            {
                ele_image.skin = data["avatar"]
            } else
            {
                ele_image.skin = "ui/common/nan.png";
            }

            ele_bg.skin = "ui/rank/paih_zk2.png"
            ele_name_bg.skin = "ui/rank/k2.png"
            if (0 == select_type && index == (my_gold_rank - 1))
            {
                ele_bg.skin = "ui/rank/paih_zk1.png"
                ele_name_bg.skin = "ui/rank/k3.png"
            }
            if (1 == select_type && index == (my_strength_rank - 1))
            {
                ele_bg.skin = "ui/rank/paih_zk1.png"
                ele_name_bg.skin = "ui/rank/k3.png"
            }

            if (0 == index)
            {
                ele_rank_icon.skin = "ui/rank/rank1.png"
            } else if (1 == index)
            {
                ele_rank_icon.skin = "ui/rank/rank2.png"
            } else if (2 == index)
            {
                ele_rank_icon.skin = "ui/rank/rank3.png"
            } else
            {
                ele_rank_icon.visible = false;
                ele_rank.visible = true;
                ele_rank.text = index + 1 + "";
            }
            cell.offAll(Event.CLICK)
            cell.on(Event.CLICK,this,function ()
            {
                FriendM.instance.searchFriend(data.user_id)
            })
        }

        private function onQuitBtnClick()
        {
            UiManager.instance.closePanel("Rank", true);
            if (LoginM.instance.pageId == GameConst.FISH_PAGE)
            {
                var info:QuitTipInfo = new QuitTipInfo();
                info.state = GameConst.quit_state_left_cancel_right_confirm_rank;
                if (LevelM.instance.todayCoinIsHaveReward || LevelM.instance.todayStrIsHaveReward)
                {
                    info.content = "保持当前排名，明日登录即可领取排名奖励！";
                } else
                {
                    info.content = "进入排行榜，明日登录即可领取排名奖励！";
                }
                if (WxC.isInMiniGame() && RoleInfoM.instance.subsState(1) == false)
                {

                    info.closeCallback = new Handler(this, comfirmHandler);
                    info.confirmCallback = new Handler(this, comfirmHandler);

                }
                info.commonMsg = GameEvent.RankAniRefesh;
                info.autoCloseTime = 10;
                GameEventDispatch.instance.event(GameEvent.QuitTip, info);
            }
        }

        private function comfirmHandler():void
        {
            if (RoleInfoM.instance.subscribeState(1) == 0)
            {
                var info:QuitTipInfo = new QuitTipInfo();
                info.state = GameConst.quit_state_mid_confirm_subscibe;
                info.commonMsg = GameEvent.OpenSubscibe;
                info.content = ""
                info.middleTxt = "订阅"
                info.isHaveTime = false;
                GameEventDispatch.instance.event(GameEvent.QuitTip, info);
            } else
            {
                GameEventDispatch.instance.event(GameEvent.OpenSubscibe);
            }
        }

        public function unRegister():void
        {
            GameEventDispatch.instance.off(String(42003), this, getRankList);
            GameEventDispatch.instance.off(GameEvent.SyncActivityStatus, this, setDate);
            GameEventDispatch.instance.off(GameEvent.SynRankReward, this, synRankReward);
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
        }


        public function register():void
        {
            GameEventDispatch.instance.on(String(42003), this, getRankList, [false]);
            GameEventDispatch.instance.on(GameEvent.SyncActivityStatus, this, setDate);
            GameEventDispatch.instance.on(GameEvent.SynRankReward, this, synRankReward);
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
        }


    }
}
