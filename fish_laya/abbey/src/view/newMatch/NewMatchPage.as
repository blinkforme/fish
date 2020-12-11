package view.newMatch
{


    import control.RedpointC;

    import engine.tool.StartParam;

    import laya.display.Sprite;
    import laya.events.Event;
    import laya.ui.Box;
    import laya.ui.Button;
    import laya.ui.Image;
    import laya.ui.Label;
    import laya.ui.ProgressBar;
    import laya.utils.Handler;

    import manager.ApiManager;

    import manager.GameConst;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;
    import manager.WebSocketManager;

    import model.ActivityM;

    import model.LoginM;

    import model.MatchM;

    import model.RoleInfoM;

    import struct.QuitTipInfo;

    import ui.abbey.NewMatchPageUI;

    public class NewMatchPage extends NewMatchPageUI implements ResVo
    {

        private var _startX:Number = 0;
        private var _startY:Number = 0;


        private var listData = []
        private var listData_two = []
        private var listData_four = []
        private var page_now = 1
        private var page_all = 1

        private var match_data:Object = {}

        public function NewMatchPage()
        {

        }

        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;
            _startX = this.x;
            _startY = this.y;
            bmask.on(Event.CLICK, this, null);
            quitBtn.on(Event.CLICK, this, onQuitBtnClick);
            list1.renderHandler = new Handler(this, updateList);
            list1.array = [];
            page_now = 1;

            WebSocketManager.instance.send(12114, {})
            getMatchList()
            initView();
            screenResize();
            dataClean();
            Laya.timer.loop(1000, this, autoRefreshData)
        }

        private function initView():void
        {
            tab1.selected = true;
            tab2.selected = false;
            maxValueTips.visible = false;
            rule_box.visible = false;
            create_box.visible = false;
            tab1.on(Event.CLICK, this, onTab1);
            tab2.on(Event.CLICK, this, onTab2);
            ruleBtn.on(Event.CLICK, this, onRuleBtn);
            ruleQuitBtn.on(Event.CLICK, this, onRuleQuitBtn);
            createBtn.on(Event.CLICK, this, onCreateBtn);
            createQuitBtn.on(Event.CLICK, this, onCreatQuitBtn);
            create_btn.on(Event.CLICK, this, onCreatMatch);
            maxValue.clickHandler = new Handler(this, onMaxValue, [], false)


            addActivityPointShow()
        }

        private function addActivityPointShow():void//当刷新开关时候 重新刷新活动图标
        {
            var vertical_h = 1
            var horizontal_percent = 0.75
            if (ActivityM.instance.isShowMatchActivity)
            {
                activityTip.visible = true
                RedpointC.instance.removeActivityPoint(tab2)
                RedpointC.instance.addActivityPointToIcon(tab2, horizontal_percent, vertical_h, false)
            } else
            {
                activityTip.visible = false
                RedpointC.instance.removeActivityPoint(tab2)
            }
        }

        private function onTab1():void
        {
            tab1.selected = true;
            tab2.selected = false;
            listPro()
        }

        private function onTab2():void
        {
            tab1.selected = false;
            tab2.selected = true;
            listPro()
        }

        private function dataClean():void
        {
            listData_two = []
            listData_four = []
            if (MatchM.instance.matchData != null)
            {
                listData = MatchM.instance.matchData["data"];

                //4人赛和2人赛数据分开
                for (var i = 0; i < listData.length; i++)
                {
                    if (listData[i].max_num == 2)
                    {
                        listData_two.push(listData[i])
                    } else if (listData[i].max_num == 4)
                    {
                        listData_four.push(listData[i])
                    }
                }

                listPro()
            }
        }

        private function listPro():void
        {
            //页码处理
            if (tab1.selected)
            {
                if (listData_two.length > 6)
                {
                    page_all = parseInt(listData_two.length / 6) + 1
                } else
                {
                    page_all = 1
                }

                page_now = page_now > page_all ? 1 : page_now;

                list1.array = listData_two.slice((page_now - 1) * 6)
            } else
            {
                if (listData_four.length > 6)
                {
                    page_all = parseInt(listData_four.length / 6) + 1
                } else
                {
                    page_all = 1
                }

                page_now = page_now > page_all ? 1 : page_now;

                list1.array = listData_four.slice((page_now - 1) * 6)
            }

            if (list1.array.length == 0)
            {
                waitTips.visible = true
            } else
            {
                waitTips.visible = false
            }
            refreshJoinBox()
        }

        private function refreshJoinBox():void
        {
            pageNum.text = page_now + "/" + page_all
            lastBtn.on(Event.CLICK, this, onLastBtn)
            nextBtn.on(Event.CLICK, this, onNextBtn)
        }

        private function onLastBtn():void
        {
            if (page_now == 1)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "当前已经在第一页")
            } else
            {
                page_now = page_now - 1
                listPro()
            }
        }

        private function onNextBtn():void
        {
            if (page_now == page_all)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "当前已经在最后一页")
            } else
            {
                page_now = page_now + 1
                listPro()
            }
        }

        private function autoRefreshData():void
        {
            WebSocketManager.instance.send(12114, {})
        }

        public function getMatchList():void
        {
            var token:String = StartParam.instance.getParam("access_token");


            ApiManager.instance.get_match_list(
                    token,
                    Handler.create(this, function (result:Object)
                    {
                        match_data = result.data
                        wait_ani.visible = false;
                    }),
                    Handler.create(this, function (result:Object)
                    {
                        console.log("获取比赛列表出错")
                        console.log(result)
                    })
            )
        }

        private function updateList(cell:Box, index:int):void
        {
            var data:Object = cell.dataSource;
            var ele_bg = cell.getChildByName("boxBg") as Image;
            var ele_pro = cell.getChildByName("pro") as ProgressBar;
            var ele_time = cell.getChildByName("time") as Label;
            var ele_name = cell.getChildByName("name") as Label;
            var ele_coinNums = cell.getChildByName("coinNums") as Label;
            var ele_playerCount = cell.getChildByName("playerCount") as Label;

            ele_coinNums.text = parseInt(data.fee / 10000) + "万"
            ele_name.text = parseInt(data.fee / 10000) + "万比赛房间";
            conversion(ele_time, data.time);
            ele_playerCount.text = data.num + "/" + data.max_num;
            ele_pro.value = data.num / data.max_num;

            ele_bg.offAll(Event.CLICK)
            if (data.running == 0)
            {
                if (data.num == data.max_num)
                {
                    ele_bg.skin = "ui/newMatch/img_di_lv.png"
                    ele_pro.skin = "ui/newMatch/bar2.png"
                } else
                {
                    ele_bg.on(Event.CLICK, this, applyMatch, [data.roomNumber]);
                    ele_bg.skin = "ui/newMatch/img_di_l.png"
                    ele_pro.skin = "ui/newMatch/bar2.png"
                }
            } else
            {
                ele_bg.skin = "ui/newMatch/img_di_h.png"
                ele_pro.skin = "ui/newMatch/bar1.png"
            }
        }

        private function conversion(table:Label, value:int):void
        {
            if (value == 30)
            {
                table.text = "时长:30秒"
            } else if (value == 180)
            {
                table.text = "时长:3分钟"
            } else if (value == 300)
            {
                table.text = "时长:5分钟"
            }
        }

        private function applyMatch(roomNumber:Number):void
        {
            var info:QuitTipInfo = new QuitTipInfo();
            info.state = GameConst.quit_state_left_cancel_right_confirm;
            info.content = "确认报名？";
            info.confirmCallback = Handler.create(this, queryRoomState, [roomNumber]);
            info.autoCloseTime = 10;
            GameEventDispatch.instance.event(GameEvent.QuitTip, info);
        }

        private function GetIntoMatchRoom():void
        {
            MatchM.instance.initMatchimgGameData();
            LoginM.instance.setContestId(match_data.match[0].id, 7)

            GameEventDispatch.instance.event(GameEvent.StartLoad, [GameConst.loadFishState]);
        }

        public function queryRoomState(roomId:Number):void
        {
            LoginM.instance.roomId = roomId
            WebSocketManager.instance.send(12110, {roomNumber: roomId})
        }


        private function onRuleBtn():void
        {
            rule_box.visible = true
        }

        private function onCreateBtn():void
        {
            initCreateBox()
            chipList.renderHandler = new Handler(this, updateChipList)
            chipList.array = [1, 10, 100, 200]
        }

        private function initCreateBox():void
        {
            create_box.visible = true;
            chipList.visible = false;
            arrowBtn.skin = "ui/newMatch/btn_xs.png"
            selectedChip.label = "1万"
            arrowBtn.on(Event.CLICK, this, onArrowBtn)
            createBg.on(Event.CLICK, this, function ()
            {
                chipList.visible = false
                arrowBtn.skin = "ui/newMatch/btn_xs.png"
            })
        }

        private function onArrowBtn():void
        {
            chipList.visible = !chipList.visible
            if (chipList.visible)
            {
                arrowBtn.skin = "ui/newMatch/btn_xx.png"
            } else
            {
                arrowBtn.skin = "ui/newMatch/btn_xs.png"
            }
        }

        private function onMaxValue():void
        {
            if (maxValue.selected)
            {
                selectedChip.label = "200万"
                chipList.visible = false;
                maxValueTips.visible = true;
                arrowBtn.disabled = true
            } else
            {
                maxValueTips.visible = false;
                arrowBtn.disabled = false
            }
        }

        private function updateChipList(cell:Box, index:int):void
        {
            var num:Object = cell.dataSource;
            var ele_btn = cell.getChildByName("btn") as Button
            ele_btn.label = num + "万"
            ele_btn.offAll(Event.CLICK)
            ele_btn.on(Event.CLICK, this, refreshCreateBox, [num])
        }

        private function refreshCreateBox(num:int):void
        {
            selectedChip.label = num + "万"
            onArrowBtn()
        }

        private function onCreatMatch():void
        {
            var times = [30, 180, 300];
            var num = [2, 4];


            var coin = RoleInfoM.instance.getCoin()
            var bindCoin = RoleInfoM.instance.getBindCoin()
            var realCoin = coin - bindCoin
            if (realCoin < 10000)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "金币不足10000无法创建比赛")
            } else
            {
                LoginM.instance.setContestId(match_data.match[0].id, 7)
                if (maxValue.selected)
                {
                    var a = {id: LoginM.instance.getContestId(), time_t: times[timeRadio.selectedIndex], num_t: num[numRadio.selectedIndex], fee_t: 0}
                } else
                {
                    var a = {
                        id: LoginM.instance.getContestId(),
                        time_t: times[timeRadio.selectedIndex],
                        num_t: num[numRadio.selectedIndex],
                        fee_t: parseInt(selectedChip.label)
                    }
                }
                MatchM.instance.storageData = a
                MatchM.instance.initMatchimgGameData();
                GameEventDispatch.instance.event(GameEvent.StartLoad, [GameConst.loadFishState]);
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
        }

        private function onRuleQuitBtn():void
        {
            rule_box.visible = false
        }

        private function onCreatQuitBtn():void
        {
            create_box.visible = false
        }

        private function onQuitBtnClick():void
        {
            UiManager.instance.closePanel("NewMatch", false);
            Laya.timer.clearAll(this)
        }

        public function unRegister():void
        {
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.off(GameEvent.RefreshMatchData, this, dataClean);
            GameEventDispatch.instance.off(GameEvent.EndDailyMatchSign, this, onQuitBtnClick);
            GameEventDispatch.instance.off(GameEvent.GetIntoMatchRoom, this, GetIntoMatchRoom);
            GameEventDispatch.instance.off(GameEvent.SyncActivityStatus, this, addActivityPointShow)
        }


        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.on(GameEvent.RefreshMatchData, this, dataClean);
            GameEventDispatch.instance.on(GameEvent.EndDailyMatchSign, this, onQuitBtnClick);
            GameEventDispatch.instance.on(GameEvent.GetIntoMatchRoom, this, GetIntoMatchRoom);
            GameEventDispatch.instance.on(GameEvent.SyncActivityStatus, this, addActivityPointShow)
        }

    }
}
