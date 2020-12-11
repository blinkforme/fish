package view.taskNew
{

    import control.RedpointC;
    import control.TaskC;
    import control.WxC;

    import model.ActivityM;

    import model.FightM;
    import model.LoginM;
    import model.RoleInfoM;

    import conf.cfg_goods;
    import conf.cfg_scene;
    import conf.cfg_task;
    import conf.cfg_task_new;

    import laya.display.Sprite;
    import laya.events.Event;
    import laya.ui.Box;
    import laya.utils.Ease;
    import laya.utils.Handler;

    import manager.ConfigManager;
    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;
    import manager.WebSocketManager;

    import proto.C2s_19000;

    import ui.abbey.TaskNewPageUI;

    public class TaskNewPage extends TaskNewPageUI implements ResVo
    {

        private static var curTabIndex:int = 0;
        private var _startX:Number = 0;
        private var _startY:Number = 0;

        private var showOffTime:Number = 0;
        private var showOffTargets:Object = {};

        public function TaskNewPage()
        {

        }

        public function StartGames(parm:Object = null):void
        {

            tab1.selectHandler = new Handler(this, onTabChange);
            refresh_day_list()

            showOffTime = 0;
            this.hitTestPrior = false;
            bmask.on(Event.CLICK, this, null)
            _startX = this.x;
            _startY = this.y;

            for (var i = 0; i < list_day.cells.length; i++)
            {
                list_day.cells[i].getChildByName("list_reward").visible = false
                list_day.cells[i].getChildByName("reward_bg").visible = false;
            }
            quitBtn.on(Event.CLICK, this, onQuitBtnClick);

            list1.renderHandler = new Handler(this, updateItem);
            list_day.renderHandler = new Handler(this, updateDayItem);


            var day_index = RoleInfoM.instance.getDayIndex();
            day_index = day_index > 7 ? 7 : day_index;
            onTabChange(day_index - 1)

            refresh_main_p();

            showRedPoint();

            screenResize();
        }

        public function initCountDown():void
        {

            var now = new Date();
            var hoursleft = 23 - now.getHours();
            var minutesleft = 59 - now.getMinutes();
            var secondsleft = 59 - now.getSeconds();

            //format 0 prefixes
            if (minutesleft < 10) minutesleft = "0" + minutesleft;
            if (secondsleft < 10) secondsleft = "0" + secondsleft;

            countDown.text = hoursleft + ":" + minutesleft + ":" + secondsleft
        }


        private function screenResize():void
        {
            var contentWidth:int = 1100;//组件范围width
            var contentHeight:int = 700;//组件范围height
            var contentStartX:int = 90;//组件左边距
            var contentStartY:int = 10;//组件上边距
            var posXOff:Number = (Laya.stage.width - contentWidth) / 2;
            var posYOff:Number = (Laya.stage.height - contentHeight) / 2;
            this.pos(_startX + posXOff - contentStartX, _startY + posYOff - contentStartY);
            this.size(Laya.stage.width, Laya.stage.height);

            quitBtn.left = contentStartX - posXOff;
            quitBtn.top = contentStartY - posYOff;
        }


        private function refresh_main_p()
        {
            var taskDatas = RoleInfoM.instance.getTaskNew()
            var day_index = RoleInfoM.instance.getDayIndex()

            if (day_index > 7)
            {
                main_p.value = 1;
                return
            }
            var today_percent = (taskDatas[day_index - 1].rec_ids.length - 1) / (cfg_task_new.instance(day_index + "").task_ids.length)
            var is_all_finish = today_percent == 1

            if (is_all_finish)
            {
                main_p.value = (day_index - 1) / 7 + (1 / 7) * today_percent;
            } else
            {
                main_p.value = (day_index - 1) / 7 + (1 / 7) * today_percent * 0.7;
            }

        }

        private function refresh_day_list()
        {
            var taskDatas = RoleInfoM.instance.getTaskNew()
            var day_index = RoleInfoM.instance.getDayIndex()

            var list = [];

            for (var i = 1; i <= 7; i++)
            {
                var day_override = TaskC.instance.new_task_override(i)

                var is_accept = taskDatas[i - 1].a;
                var is_all_accept = day_override.is_all_accepted;
                var is_all_finish = day_override.is_all_finished;
                var is_expired = !is_all_finish && day_index > i;

                list.push({
                    is_expired: is_expired,
                    is_all_accept: is_all_accept,
                    is_accept: is_accept
                })
            }
            list_day.array = list
        }

        private function acceptNewDayReward(day_index)
        {
            WebSocketManager.instance.send(19004, {day_index: day_index});
        }

        private function updateDayItem(cell:Box, index:int):void
        {


            var d = cell.dataSource;

            var ele_gift = cell.getChildByName("img_gift");
            var ele_text_bg = cell.getChildByName("txt_bg");
            var ele_txt_day = cell.getChildByName("txt_day");
            var ele_img_status = cell.getChildByName("img_status");
            var ele_list_reward = cell.getChildByName("list_reward");
            var ele_list_reward_bg = cell.getChildByName("reward_bg");

            cell.on(Event.MOUSE_DOWN, this, function ()
            {
                for (var i = 0; i < list_day.cells.length; i++)
                {
                    if (index != i)
                    {
                        list_day.cells[i].getChildByName("list_reward").visible = false
                        list_day.cells[i].getChildByName("reward_bg").visible = false;
                    }
                }
                ele_list_reward_bg.visible = true;
                ele_list_reward.visible = true;

                ele_list_reward.renderHandler = new Handler(this, updateItemReward);
                var rewards = []
                var c = cfg_task_new.instance(index + 1 + "")
                for (var i = 0; i < c.reward_item_ids.length; i++)
                {
                    rewards.push({
                        reward_item_id: c.reward_item_ids[i],
                        reward_item_num: c.reward_item_nums[i]
                    })
                }
                ele_list_reward.array = rewards


            })
            cell.on(Event.MOUSE_UP, this, function ()
            {
                ele_list_reward_bg.visible = false;
                ele_list_reward.visible = false;
            })

            var dic = ["第一天", "第二天", "第三天", "第四天", "第五天", "第六天", "第七天"]
            ele_txt_day.text = dic[index]

            ele_gift.offAll(Event.CLICK);
            ele_gift.skin = "ui/taskNew/gift.png"
            if (index == 6)
            {
                ele_gift.skin = "ui/taskNew/gift2.png"
            }
            ele_text_bg.visible = false;
            ele_img_status.visible = false;


            if (d.is_accept)
            {
                ele_gift.skin = "ui/taskNew/liwu.png"
                ele_text_bg.visible = true;
                ele_img_status.visible = true;
                ele_img_status.skin = "ui/common_ex/t_accepted.png"
            } else if (d.is_all_accept)
            {
                showOffTargets[index + ""] = ele_gift
                ele_gift.on(Event.CLICK, this, function ()
                {
                    acceptNewDayReward(index + 1)
                    delete showOffTargets[index + ""]
                })

            } else if (d.is_expired)
            {
                ele_text_bg.visible = true;
                ele_img_status.visible = true;
                ele_img_status.skin = "ui/common_ex/t_expired.png"
            }

        }

        private function clearShowOff():void
        {
            Laya.timer.clear(this, giftShowOff)
        }

        private function startShowOff():void
        {
            Laya.timer.frameLoop(1, this, giftShowOff)
        }

        private function giftShowOff():void
        {
            var delta:Number = Laya.timer.delta;
            var distance:Number = 15;
            var origin_y:Number = 33
            var y:Number = origin_y - distance;

            var upTime:Number = 600;
            var totalTime:Number = 2000;
            var downTime:Number = totalTime - upTime;
            showOffTime += delta;


            for (var i in showOffTargets)
            {
                var target:Sprite = showOffTargets[i];
                if (showOffTime > totalTime)
                {
                    showOffTime = 0
                    target.y = origin_y
                } else
                {
                    if (showOffTime < upTime)
                    {
                        target.y = Ease.sineIn(showOffTime, origin_y, -distance, upTime)
                    } else
                    {
                        target.y = Ease.bounceOut(showOffTime - upTime, y, distance, downTime)
                    }
                }

            }

        }

        private function updateItemReward(cell:Box, index:int):void
        {
            var ele_reward_img = cell.getChildByName("reward_type");
            var ele_reward_text = cell.getChildByName("reward_text");

            var data = cell.dataSource

            ele_reward_img.skin = cfg_goods.instance(data.reward_item_id + "").icon;
            ele_reward_text.text = 'x ' + ActivityM.instance.exchangeConversion(data.reward_item_id, data.reward_item_num);
        }


        private function updateItem(cell:Box, index:int):void
        {
            var config:cfg_task = cell.dataSource;
            var taskDatas:Array = RoleInfoM.instance.getTaskNew()
            var battery:int = RoleInfoM.instance.getBattery()
            var level:int = RoleInfoM.instance.getLevel()
            var day_index:int = parseInt(RoleInfoM.instance.getDayIndex())

            var taskData:Object = taskDatas[curTabIndex - 1]
            var ele_op = cell.getChildByName("op_box").getChildByName("op");
            var ele_op_text = cell.getChildByName("op_box").getChildByName("op_text");
            var ele_p = cell.getChildByName("p1");


            //初始化控件属性
            ele_op.stateNum = 2;
            ele_op.visible = true;
            ele_op_text.visible = true;
            ele_op_text.gray = false;
            ele_op.stateNum = 2
            ele_op.offAll(Event.CLICK);
            ele_p.skin = "ui/common_ex/p2.png";

            //奖励数组
            var list_reward = cell.getChildByName("list_reward");
            list_reward.renderHandler = new Handler(this, updateItemReward);
            var rewards = []
            for (var i = 0; i < config.reward_item_ids.length; i++)
            {
                rewards.push({
                    reward_item_id: config.reward_item_ids[i],
                    reward_item_num: config.reward_item_nums[i]
                })
            }

            list_reward.array = rewards

            if (rewards.length == 1)
            {
                list_reward.pivotX = -52;
            } else
            {
                list_reward.pivotX = 0
            }


            cell.getChildByName("task_name").text = config.task_name;
            cell.getChildByName("icon").skin = config.img_url

            var is_accept = taskData.rec_ids.indexOf(config.id) > -1;
            var is_fature = curTabIndex > day_index;
            var is_today = curTabIndex == day_index;
            var is_old = curTabIndex < day_index

            var percent = TaskC.instance.taskPercent(taskData, config);

            var is_finish = percent == 1;
            ele_p.value = percent;

            ele_op.stateNum = 2;
            if (is_accept)
            {
                ele_op.skin = "ui/common_ex/btn_gray.png";
                ele_op.stateNum = 1;
                ele_op_text.skin = "ui/common_ex/t_accepted.png";

                cell.getChildByName("p1").value = 1;
            } else if (is_finish)
            {
                ele_op.skin = "ui/common_ex/btn_yellow.png";
                ele_op_text.skin = "ui/common_ex/t_accept.png";
                ele_op.on(Event.CLICK, this, onFinishTask(config.id, curTabIndex));
            } else
            {
                if (is_old)
                {
                    ele_op.skin = "ui/common_ex/btn_gray.png";
                    ele_op.stateNum = 1;
                    ele_op_text.skin = "ui/common_ex/t_expired.png";
                    ele_p.skin = "ui/common_ex/p3.png"

                } else
                {
                    ele_op.skin = "ui/common_ex/btn_blue.png";
                    ele_op_text.skin = "ui/common_ex/t_go.png";
                    if (is_today)
                    {
                        ele_op.on(Event.CLICK, this, function ()
                        {
                            GameEventDispatch.instance.event(GameEvent.ShowGuide, config);
                            onQuitBtnClick()

                            var scene_id:Number = config.scene_id;

                            if (scene_id == 0)
                            {

                            } else
                            {
                                var cfg:cfg_scene = cfg_scene.instance(scene_id);
                                var batteryLevel:Number = RoleInfoM.instance.getBattery();

                                if (batteryLevel >= cfg.unlock)
                                {
                                    if (config.scene_id > 0 && config.scene_id != FightM.instance.sceneId)
                                    {
                                        WebSocketManager.instance.send(12003, null);
                                        LoginM.instance.sceneId = config.scene_id;
                                        GameEventDispatch.instance.event(GameEvent.StartLoad, [GameConst.loadFishState]);

                                        //                                    var c2s = new C2s_12001();
                                        //                                    c2s.scene_id = cfg.id;
                                        //                                    WebSocketManager.instance.send(12001, c2s);
                                    }
                                } else
                                {
                                    GameEventDispatch.instance.event(GameEvent.MsgTip, cfg.msg_tip_id);
                                }
                            }
                        })
                    }
                }
            }


            if (is_fature)
            {
                ele_op.stateNum = 1
                ele_op.skin = "ui/common_ex/btn_gray.png";
                ele_op_text.skin = "ui/common_ex/t_go.png";
                ele_op_text.gray = true;
                ele_p.value = 0;
            }

        }

        private function onFinishTask(task_id:int, day_index:int)
        {
            return function ()
            {
                var a:C2s_19000 = new C2s_19000();
                a.task_id = task_id;
                a.day_index = day_index;

                WebSocketManager.instance.send(19000, a);
            }
        }


        private function onTabChange(index:int)
        {

            showRedPoint()
            curTabIndex = index + 1;
            var x = cfg_task_new.instance(curTabIndex + "")
            var task_ids = x.task_ids;

            tab1.selectedIndex = index;

            var taskDatas = RoleInfoM.instance.getTaskNew()
            var taskData = taskDatas[index]


            var finish_arr = [];
            var unfinish_arr = [];
            var accept_arr = []
            var cfgs = ConfigManager.filter("cfg_task", function (item:cfg_task)
            {
                return task_ids.indexOf(item.id) > -1
            })
            for (var i = 0; i < cfgs.length; i++)
            {
                var cfg = cfgs[i]
                var percent = TaskC.instance.taskPercent(taskData, cfg);
                var is_finish = percent == 1;
                var is_accept = taskData.rec_ids.indexOf(cfg.id) > -1;
                if (is_accept)
                {
                    accept_arr.push(cfg)
                } else if (is_finish)
                {
                    finish_arr.push(cfg)
                } else
                {
                    unfinish_arr.push(cfg)
                }
            }
            list1.array = finish_arr.concat(unfinish_arr, accept_arr)

            var day_index = RoleInfoM.instance.getDayIndex()
            if (curTabIndex > day_index)
            {
                Laya.timer.clear(this, initCountDown);
                countDown.text = "未开始"
            } else if (curTabIndex == day_index)
            {
                initCountDown()
                Laya.timer.loop(1000, this, initCountDown);
            } else
            {
                Laya.timer.clear(this, initCountDown);
                countDown.text = "已过期"
            }


        }

        private function onQuitBtnClick()
        {
            UiManager.instance.closePanel("TaskNew", true);
        }

        private function refresh(data:*)
        {
            onTabChange(tab1.selectedIndex)
            refresh_day_list()
            refresh_main_p()
        }

        private function showRedPoint(data:*):void
        {
            var red_points:Number = RoleInfoM.instance.getRedPoints();

            var day_index:Number = RoleInfoM.instance.getDayIndex();
            if (day_index > 7)
            {
                day_index = 7
            }
            if (GameConst.point_new_task_finish & red_points)
            {
                for (var i = 1; i <= day_index; i++)
                {
                    var target = tab1.getChildByName("item" + (i - 1)) as Sprite;
                    var day_override = TaskC.instance.new_task_override(i)

                    if (day_override.have_can_accept)
                    {
                        RedpointC.instance.removeRedPoint(target)
                        if (tab1.selectedIndex + 1 == i)
                        {
                            RedpointC.instance.addRedPointToIcon(target, 0.87, 3)
                        } else
                        {
                            RedpointC.instance.addRedPointToIcon(target, 0.78, 8)
                        }

                    } else
                    {
                        RedpointC.instance.removeRedPoint(target)
                    }
                }

            }
        }

        public function noviceGuideAccept():void
        {
            console.log(list1.cells[0].dataSource)
            onFinishTask(list1.cells[0].dataSource.id, curTabIndex)()

            console.log("noviceGuideAccept")

        }

        public function unRegister():void
        {
            GameEventDispatch.instance.off(GameEvent.RefreshTaskNew, this, refresh);
            GameEventDispatch.instance.off(GameEvent.FinishTaskNew, this, refresh);
            GameEventDispatch.instance.off(GameEvent.ShowRedPoint, this, showRedPoint);
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            clearShowOff()
            GameEventDispatch.instance.off(GameEvent.NoviceGuideAcceptTaskNew, this, noviceGuideAccept);

        }

        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.RefreshTaskNew, this, refresh);
            GameEventDispatch.instance.on(GameEvent.FinishTaskNew, this, refresh);
            GameEventDispatch.instance.on(GameEvent.ShowRedPoint, this, showRedPoint);
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            startShowOff()

            GameEventDispatch.instance.on(GameEvent.NoviceGuideAcceptTaskNew, this, noviceGuideAccept);

        }


    }
}
