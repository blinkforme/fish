package view.taskDaily
{

    import control.TaskC;
    import control.WxC;

    import model.ActivityM;
    import model.FightM;
    import model.LoginM;
    import model.RoleInfoM;

    import conf.cfg_goods;
    import conf.cfg_task;

    import laya.events.Event;
    import laya.ui.Box;
    import laya.ui.List;
    import laya.utils.Handler;

    import manager.ConfigManager;
    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;
    import manager.WebSocketManager;

    import proto.C2s_19000;
    import proto.C2s_19002;

    import ui.abbey.TaskDailyPageUI;

    public class TaskDailyPage extends TaskDailyPageUI implements ResVo
    {

        private var _startX:Number = 0;
        private var _startY:Number = 0;

        public function TaskDailyPage()
        {
            syncTask()
        }


        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;
            bmask.on(Event.CLICK, this, null)
            _startX = this.x;
            _startY = this.y;

            quitBtn.on(Event.CLICK, this, onQuitBtnClick);
            list1.renderHandler = new Handler(this, updateItem);
            initTask()

            screenResize();
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


        private function updateItemReward(cell:Box, index:int):void
        {
            var ele_reward_img = cell.getChildByName("reward_type");
            var ele_reward_text = cell.getChildByName("reward_text");

            var data = cell.dataSource

            ele_reward_img.skin = cfg_goods.instance(data.reward_item_id + "").icon;
            ele_reward_text.text = 'x ' + data.reward_item_num;
        }

        private function updateItem(cell:Box, index:int):void
        {
            var taskConfig:cfg_task = cell.dataSource;
            var taskData = RoleInfoM.instance.getTaskDaily()
            var battery = RoleInfoM.instance.getBattery()
            var level = RoleInfoM.instance.getLevel()

            var ele_op = cell.getChildByName("op_box").getChildByName("op");
            var ele_op_text = cell.getChildByName("op_box").getChildByName("op_text");
            var ele_p = cell.getChildByName("p1");


            //初始化控件属性
            ele_op.stateNum = 2;
            ele_op.visible = true;
            ele_op_text.visible = true;
            ele_op.offAll(Event.CLICK);
            ele_p.skin = "ui/common_ex/p2.png";

            //奖励数组
            var list_reward = cell.getChildByName("list_reward") as List;
            list_reward.renderHandler = new Handler(this, updateItemReward);
            var rewards = []
            for (var i = 0; i < taskConfig.reward_item_ids.length; i++)
            {
                if (ActivityM.instance.activityIsActive(GameConst.activity_bonus))
                {
                    rewards.push({
                        reward_item_id: taskConfig.activity_item_ids[i],
                        reward_item_num: taskConfig.activity_item_nums[i]
                    })
                }
//                else if (ActivityM.instance.activityIsActive(GameConst.activity_worldcup))
//                {
//                    rewards.push({
//                        reward_item_id: taskConfig.worldcup_item_ids[i],
//                        reward_item_num: taskConfig.worldcup_item_nums[i]
//                    })
//                }
                else
                {
                    rewards.push({
                        reward_item_id: taskConfig.reward_item_ids[i],
                        reward_item_num: taskConfig.reward_item_nums[i]
                    })
                }

            }
            list_reward.array = rewards;
            if (rewards.length == 1)
            {
                list_reward.pivotX = -52;
            } else
            {
                list_reward.pivotX = 0
            }

            cell.getChildByName("task_name").text = taskConfig.task_name;
            cell.getChildByName("icon").skin = taskConfig.img_url

            var percent = TaskC.instance.taskPercent(taskData, taskConfig);

            var is_accept = taskData.rec_ids.indexOf(taskConfig.id) > -1;
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
                ele_op.on(Event.CLICK, this, onFinishTask(taskConfig.id));
            } else
            {
                ele_op.skin = "ui/common_ex/btn_blue.png";
                ele_op_text.skin = "ui/common_ex/t_go.png";
                ele_op.on(Event.CLICK, this, function ()
                {
                    GameEventDispatch.instance.event(GameEvent.ShowGuide, taskConfig);
                    onQuitBtnClick()
                    if (taskConfig.scene_id > 0 && taskConfig.scene_id != FightM.instance.sceneId)
                    {

                        WebSocketManager.instance.send(12003, null);
                        LoginM.instance.sceneId = taskConfig.scene_id;
                        GameEventDispatch.instance.event(GameEvent.StartLoad, [GameConst.loadFishState]);

                        //                    var c2s = new C2s_12001();
                        //                    c2s.scene_id = taskConfig.scene;
                        //                    WebSocketManager.instance.send(12001, c2s);
                    }
                });

            }

        }

        private function onFinishTask(task_id:int)
        {
            return function ()
            {
                var a:C2s_19000 = new C2s_19000();
                a.task_id = task_id;
                a.is_daily = true;

                WebSocketManager.instance.send(19000, a);
            }
        }

        private function syncTask()
        {
            var a:C2s_19002 = new C2s_19002();
            a.is_daily = true;
            WebSocketManager.instance.send(19002, a);
        }

        private function initTask()
        {
            var task_daily_ids = RoleInfoM.instance.getTaskDailyIds();

            var taskData = RoleInfoM.instance.getTaskDaily();
            var cfgs = ConfigManager.filter("cfg_task", function (item:cfg_task)
            {
                return task_daily_ids.indexOf(item.id) > -1
            })

            var finish_arr = [];
            var unfinish_arr = [];
            var accept_arr = []
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
        }

        private function onQuitBtnClick()
        {
            UiManager.instance.closePanel("TaskDaily", true);
        }

        private function curTask()
        {
            var task_ids = RoleInfoM.instance.getTaskDailyIds();

            var confs = ConfigManager.filter("cfg_task", function (item:cfg_task)
            {
                return task_ids.indexOf(item.id) > -1
            });
            var taskData = RoleInfoM.instance.getTaskDaily()
            for (var i = 0; i < confs.length; i++)
            {
                var percent = TaskC.instance.taskPercent(taskData, confs[i])
                var is_accept = taskData.rec_ids.indexOf(confs[i].id) > -1;
                var is_finish = percent == 1;

                var finish_arr = [];
                var unfinish_arr = [];

                var task_id = confs[i].id;
                if (is_accept)
                {
                    continue
                } else if (is_finish)
                {
                    finish_arr.push(task_id)
                } else
                {
                    unfinish_arr.push(task_id)
                }
            }
        }

        private function refresh(data:*)
        {
            curTask();
            initTask()
        }


        public function unRegister():void
        {
            GameEventDispatch.instance.off(GameEvent.RefreshTaskDaily, this, refresh);
            GameEventDispatch.instance.off(GameEvent.FinishTaskDaily, this, refresh);
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
        }


        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.RefreshTaskDaily, this, refresh);
            GameEventDispatch.instance.on(GameEvent.FinishTaskDaily, this, refresh);
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
        }


    }
}
