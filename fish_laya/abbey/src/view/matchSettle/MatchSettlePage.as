package view.matchSettle
{

    import control.WxC;

    import model.ActivityM;

    import model.FightM;

    import model.LoginM;
    import model.MatchM;
    import model.RoleInfoM;

    import conf.cfg_goods;

    import laya.events.Event;
    import laya.ui.Box;
    import laya.ui.Image;
    import laya.ui.Label;
    import laya.utils.Handler;

    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;
    import manager.WebSocketManager;

    import struct.QuitTipInfo;

    import ui.abbey.MatchSettlePageUI;

    public class MatchSettlePage extends MatchSettlePageUI implements ResVo
    {

        private var _startX:Number = 0;
        private var _startY:Number = 0;
        private var _maxWin:Number = 0;
        private var match_data:Object = null;

        public function MatchSettlePage()
        {

        }


        public function StartGames(param:Object = null):void
        {
            this.hitTestPrior = false;
            _startX = this.x;
            _startY = this.y;
            match_data = param;
            _maxWin = param.maxWin;
            screenResize();
            daily_box.visible = false
            challenge_box.visible = false
            matchResultBox.visible = false;
            list_reward.renderHandler = new Handler(this, updateItemReward);
            if (param['isWin'])
            {
                roundTxt.text = (param["winCount"]) + '/' + _maxWin;
            } else
            {
                roundTxt.text = (param["winCount"] + 1) + '/' + _maxWin;
            }

            if (param['type'] == 'daily')
            {
                daily_box.visible = true
                rank_label.text = param['rank'] + "/" + param['total_num']
                score.value = param['score']
                max_score.text = "本场比赛最高得分：" + param['max_score']

            } else if (param['type'] == 'challenge')
            {
                list_reward.visible = true
                challenge_box.visible = true
                reward_bg.visible = true

                var winCount:Number = match_data['winCount']
                if (param['isWin'])
                {
                    win_title.skin = 'ui/matchSettle/shengli.png'
                    win_fight_box.visible = true
                    fail_fight_box.visible = false
                    if (WxC.isInMiniGame())
                    {
                        //					challenge_btn.visible = false;
                        //					challenge_btn_mid.visible = true;
                        //					btn_share.visible = false;
                    }
                    if (winCount < _maxWin)
                    {
                        list_reward.visible = false
                        reward_bg.visible = false
                        win_rount_txt1.visible = true
                        win_txt1.visible = false
                        win_txt2.visible = false
                    } else
                    {
                        list_reward.visible = true
                        reward_bg.visible = true
                        var rewards_arr = match_data["award"]
                        var rewards_item = rewards_arr[winCount - 1]
                        var rewards = []
                        for (var i = 0; i < rewards_item.length; i = i + 2)
                        {
                            rewards.push({
                                reward_item_id: rewards_item[i],
                                reward_item_num: rewards_item[i + 1]
                            })
                        }
                        list_reward.array = rewards
                        win_rount_txt1.visible = false
                        win_txt1.visible = true
                        win_txt2.visible = true
                    }
                } else
                {
                    var rewards_arr = match_data["award"]
                    if (winCount == 0)
                    {
                        list_reward.visible = false
                        reward_bg.visible = false
                    } else
                    {
                        list_reward.visible = true
                        reward_bg.visible = true
                        var rewards_item = rewards_arr[winCount - 1]
                        var rewards = []
                        for (var i = 0; i < rewards_item.length; i = i + 2)
                        {
                            rewards.push({
                                reward_item_id: rewards_item[i],
                                reward_item_num: rewards_item[i + 1]
                            })
                        }
                        list_reward.array = rewards
                    }

                    if (WxC.isInMiniGame())
                    {
                        //					if(match_data["failCount"] == 1)
                        //					{
                        //						challenge_btn.visible = true;
                        //						challenge_btn_mid.visible = false;
                        //						btn_share.visible = true;
                        //					}
                        //					else
                        //					{
                        //						challenge_btn.visible = false;
                        //						challenge_btn_mid.visible = true;
                        //						btn_share.visible = false;
                        //					}
                        //
                    }

                    win_title.skin = 'ui/matchSettle/shib.png'
                    win_fight_box.visible = false
                    fail_fight_box.visible = true
                }


            } else if (param['type'] == 'match')
            {
                cancelMatchBtn.on(Event.CLICK, this, onCancelMatchBtn);
                againBtn.on(Event.CLICK, this, onAgainBtn);
                matchingSynRusultMsg();
            }
            challenge_btn.on(Event.CLICK, this, onChallengeClick)
            if (WxC.isInMiniGame())
            {
                //			challenge_btn_mid.on(Event.CLICK, this, onChallengeClick)
                //			btn_share.on(Event.CLICK, this, onShareClick);
            }
            confirm_btn.on(Event.CLICK, this, onClickConfirm)


            //        if (match_data.free_times > 0) {
            //            coin_box.visible = false
            //        } else {
            //            coin_box.visible = true
            //        }


            retry_coin.text = match_data['consume_gold'] + ""
            retry_btn.offAll(Event.CLICK)
            if (match_data.free_times <= 0 && RoleInfoM.instance.getCoin() < match_data.consume_gold)
            {
                retry_btn.gray = true
                retry_text.gray = true
                retry_btn.on(Event.CLICK, this, function (event:Event)
                {
                    event.stopPropagation();
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "金币不足");
                })
            } else
            {
                retry_btn.gray = false
                retry_text.gray = false
                retry_btn.on(Event.CLICK, this, onClickRetry)
            }


        }

        private function onCancelMatchBtn(event:Event):void
        {
            if (LoginM.instance.pageId == GameConst.MAIN_PAGE)
            {
                closeMatchSettlePanel();
            } else
            {
                event.stopPropagation();
                tip();
            }
        }

        public function tip():void
        {
            var info:QuitTipInfo = new QuitTipInfo();
            info.state = GameConst.quit_state_left_cancel_right_confirm;
            info.content = "是否退出房间？";
            info.confirmCallback = Handler.create(this, closeMatchSettlePanel);
            info.confirmMsg = GameEvent.ReturnConfirm;
            info.autoCloseTime = 10;
            GameEventDispatch.instance.event(GameEvent.QuitTip, info);
        }

        private function closeMatchSettlePanel():void
        {
            UiManager.instance.closePanel('MatchSettle', false)
        }

        private function onAgainBtn():void
        {
            if (LoginM.instance.pageId == GameConst.MAIN_PAGE)
            {
                var info:QuitTipInfo = new QuitTipInfo();
                info.state = GameConst.quit_state_left_cancel_right_confirm;
                info.content = "确认报名？";
                info.confirmCallback = Handler.create(this, function ()
                {
                    UiManager.instance.closePanel('MatchSettle', false)
                    MatchM.instance.initMatchimgGameData();
                    if ('match' == MatchM.instance.resultMsg.type)
                    {
                        match_sign(MatchM.instance.resultMsg.contest_id, 5)
                    }
                });
                info.conFirmArgs = MatchM.instance.resultMsg;
                info.autoCloseTime = 10;
                GameEventDispatch.instance.event(GameEvent.QuitTip, info);
            } else
            {
                if (FightM.instance.isMatchingGame() && MatchM.instance.isMatchSart == 1)
                {
                    WebSocketManager.instance.send(12112, null);
                    UiManager.instance.closePanel('MatchSettle', false)
                }
            }
        }

        private function matchingSynRusultMsg():void
        {
            matchResultBox.visible = true;
            matchWinBox.visible = false;
            matchFallBox.visible = false;
            resultTimeBox.visible = false;
            var msg:Object = MatchM.instance.resultMsg;
            if (msg.rank == 1)
            {
                var rew:Array = [];
                for (var i:int = 0; i < msg.reward_item_ids.length; i++)
                {
                    rew.push({
                        reward_num: "x" +ActivityM.instance.exchangeConversion(msg.reward_item_ids[i],msg.reward_item_nums[i]) ,
                        reward_id: cfg_goods.instance("" + msg.reward_item_ids[i]).icon
                    });
                }
                matchRewardList.renderHandler = new Handler(this, updateItemMatchReward);
                matchWinBox.visible = true;
                rewardListBg.width = 110 * rew.length;
                matchRewardList.width = 80 * rew.length + (rew.length - 1) * 20;
                matchRewardList.array = rew;
            } else
            {
                matchFallBox.visible = true;
                matchRankLabel.text = msg.rank + "/" + msg.player_nums;
                matchMaxLabel.text = "本场比赛最高得分：" + msg.score;
            }
            if (msg.is_free)
            {
                matchCostImage.skin = cfg_goods.instance(msg.consume_ids[0] + "").icon;
                matchCostLabel.text = "免费";
            } else
            {
                matchCostImage.skin = cfg_goods.instance(msg.consume_ids[0] + "").icon;
                matchCostLabel.text = msg.consume_nums[0] + "";
            }
        }

        private function updateItemMatchReward(cell:Box, index:int):void
        {
            var config = cell.dataSource;
            var reward_type:Image = cell.getChildByName("reward_type") as Image;
            var reward_text:Label = cell.getChildByName("reward_text") as Label;
            reward_type.skin = config.reward_id;
            reward_text.text = config.reward_num;
        }

        private function updateItemReward(cell:Box, index:int):void
        {
            var ele_reward_img:Image = cell.getChildByName("reward_type") as Image;
            var ele_reward_text:Label = cell.getChildByName("reward_text") as Label;
            var data:Object = cell.dataSource;

            ele_reward_img.skin = cfg_goods.instance(data.reward_item_id + "").icon;
            ele_reward_text.text = 'x ' + ActivityM.instance.exchangeConversion(data.reward_item_id,data.reward_item_num);
        }

        private function onClickConfirm():void
        {
            WebSocketManager.instance.send(12003, null);
            UiManager.instance.closePanel('MatchSettle', false)
        }

        private function onShareClick():void
        {
            WxC.area_share();
        }

        private function areaShareSuccess():void
        {
            WebSocketManager.instance.send(12003, null);
            WebSocketManager.instance.send(12051, {id: match_data.contest_id, replay: true});
            UiManager.instance.closePanel('MatchSettle', false);
        }

        private function onChallengeClick():void
        {
            if (match_data['isWin'])
            {
                if (match_data['winCount'] == _maxWin)
                {
                    WebSocketManager.instance.send(35002, {id: match_data.contest_id})
                } else
                {
                    WebSocketManager.instance.send(12003, null);
                    if (match_data["failCount"] == 1)
                    {
                        WebSocketManager.instance.send(12051, {id: match_data.contest_id, replay: true})
                    }
                    else
                    {
                        WebSocketManager.instance.send(12051, {id: match_data.contest_id, replay: false})
                    }


                    UiManager.instance.closePanel('MatchSettle', false)
                }
            } else
            {
                WebSocketManager.instance.send(35002, {id: match_data.contest_id})
                WebSocketManager.instance.send(12003, null);
                UiManager.instance.closePanel('MatchSettle', false)

            }
        }


        private function match_sign(contest_id:Number, scene_id:Number)
        {
            LoginM.instance.setContestId(contest_id, scene_id);
            GameEventDispatch.instance.event(GameEvent.StartLoad, [GameConst.loadFishState]);
        }

        private function onClickRetry(event:Event):void
        {

            event.stopPropagation();


            var info:QuitTipInfo = new QuitTipInfo();
            info.state = GameConst.quit_state_left_cancel_right_confirm;
            info.content = "确认报名？";
            info.confirmCallback = Handler.create(this, function ()
            {
                UiManager.instance.closePanel('MatchSettle', false)
                WebSocketManager.instance.send(12003, null);

                if ('daily' == match_data.type)
                {
                    match_sign(match_data.contest_id, 5)
                }
            });
            info.conFirmArgs = match_data;
            info.autoCloseTime = 10;
            GameEventDispatch.instance.event(GameEvent.QuitTip, info);
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
        }

        private function endChallengeAcceptReward():void
        {
            UiManager.instance.closePanel('MatchSettle', false)
            WebSocketManager.instance.send(12003, null);
        }


        public function unRegister():void
        {
            this.x = _startX;
            this.y = _startY;
            GameEventDispatch.instance.off(GameEvent.EndAcceptChallengeMatchReward, this, endChallengeAcceptReward);
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.off(GameEvent.AreaShareSucess, this, areaShareSuccess);
        }


        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.EndAcceptChallengeMatchReward, this, endChallengeAcceptReward);
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.on(GameEvent.AreaShareSucess, this, areaShareSuccess);
        }


    }
}
