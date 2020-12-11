package control
{


    import manager.GameTools;

    import model.ActivityM;
    import model.RoleInfoM;

    import conf.cfg_task;
    import conf.cfg_task_new;

    import manager.ConfigManager;
    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.WebSocketManager;

    import proto.C2s_19007;

    public class TaskC
    {
        private static var _instance:TaskC;

        private var is_bind = false;

        public function TaskC()
        {
            GameEventDispatch.instance.on("10004", this, init);
            GameEventDispatch.instance.on("19006", this, syncRedPoint);
            GameEventDispatch.instance.on(GameEvent.ClearRedPoint, this, clearRedPoint);
        }

        private function init()
        {

            if (!is_bind)
            {
                GameEventDispatch.instance.on("19001", this, finishTask);
                GameEventDispatch.instance.on("19003", this, sync);
                GameEventDispatch.instance.on("19005", this, finishTaskNewDay);
                is_bind = true;
            }
        }

        private function clearRedPoint(point_value)
        {

            var a:C2s_19007 = new C2s_19007();
            a.point_value = point_value;
            WebSocketManager.instance.send(19007, a);
        }

        private function syncRedPoint(data:*)
        {
            var red_points = data["red_points"]
            RoleInfoM.instance.setRedPoints(red_points)

            GameEventDispatch.instance.event(GameEvent.ShowRedPoint)
        }

        //领取当天的奖励
        private function finishTaskNewDay(data:*)
        {
            if (0 == data["code"])
            {
                var day_index = data["day_index"]
                var cfg = cfg_task_new.instance(day_index + "")
                GameEventDispatch.instance.event(GameEvent.RewardTip, [cfg.reward_item_ids, cfg.reward_item_nums]);
                sync(data)
            }
        }

        private function finishTask(data:*)
        {
            var code:Number = data["code"];

            if (0 == code)
            {
                var task = cfg_task.instance(data["finish_task_id"] + "")

                if (ActivityM.instance.activityIsActive(GameConst.activity_bonus))
                {
                    GameEventDispatch.instance.event(GameEvent.RewardTip, [task.activity_item_ids, task.activity_item_nums]);
                }
//                else if (ActivityM.instance.activityIsActive(GameConst.activity_worldcup))
//                {
//                    GameEventDispatch.instance.event(GameEvent.RewardTip, [task.worldcup_item_ids, task.worldcup_item_nums]);
//                }
                else
                {
                    GameEventDispatch.instance.event(GameEvent.RewardTip, [task.reward_item_ids, task.reward_item_nums]);
                }

                sync(data)
            } else if (1 == code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "无法领取任务奖励");
            } else if (2 == code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "重复领取任务奖励");
            } else if (3 == code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "无法领取任务奖励");
            } else
            {
                GameTools.dealCode(code)
            }

        }

        private function sync(data:*)
        {
            if (!data)
            {
                return;
            }
            if (data['task_new'])
            {
                RoleInfoM.instance.updateTaskNew(data['task_new'])
                GameEventDispatch.instance.event(GameEvent.RefreshTaskNew);
            }

            if (data['task_daily'])
            {
                RoleInfoM.instance.updateTaskDaily(data['task_daily'])
                GameEventDispatch.instance.event(GameEvent.RefreshTaskDaily);
            }

            if (data['day_index'])
            {
                if (data['day_index'] > RoleInfoM.instance.getDayIndex())
                {
                    RoleInfoM.instance.setDayIndex(data['day_index'])
                    GameEventDispatch.instance.event(GameEvent.RefreshTaskNew);
                }
            }
            if (data["task_daily_ids"])
            {
                RoleInfoM.instance.setTaskDailyIds(data['task_daily_ids'])
                GameEventDispatch.instance.event(GameEvent.RefreshTaskDailyTotal);
            }
        }

        public function new_task_override(day_index)
        {
            var taskDatas = RoleInfoM.instance.getTaskNew()
            var taskData = taskDatas[day_index - 1]

            var task_ids = cfg_task_new.instance(day_index + "").task_ids;
            var cfgs = ConfigManager.filter("cfg_task", function (item:cfg_task)
            {
                return task_ids.indexOf(item.id) > -1
            })

            var is_all_accepted = taskData.rec_ids.length - 1 == task_ids.length
            var have_can_accept = false
            var is_all_finished = true

            for (var i = 0; i < cfgs.length; i++)
            {
                var cfg = cfgs[i]

                var is_accept = taskData.rec_ids.indexOf(cfg.id) > -1;
                var percent = TaskC.instance.taskPercent(taskData, cfg);
                var is_finish = percent == 1;


                if (!is_finish)
                {
                    is_all_finished = false
                }
                if (is_finish && !is_accept)
                {
                    have_can_accept = true
                }
            }
            return {
                is_all_accepted: is_all_accepted,
                is_all_finished: is_all_finished,
                have_can_accept: have_can_accept
            }

        }

        public function getCurTaskValue(taskData, taskConfig)
        {
            var value = 0;
            switch (taskConfig.task_type)
            {
                case 1:
                    if (taskConfig.task_value_f == 0)
                    {
                        value = taskData.f["total"]
                    } else
                    {
                        value = taskData.f[taskConfig.task_value_f + ""] || 0
                    }
                    break;
                case 2:
                    value = taskData.l;
                    break;
                case 3:
                    value = taskData.lg;
                    break;
                case 4:
                    var useNum = taskData.goods[taskConfig.task_value_f];
                    if (!useNum)
                    {
                        value = 0
                    } else
                    {
                        value = useNum;
                    }
                    break;
                case 5:
                    value = taskData.b;
                    break;
                case 6:
                    value = taskData.lv;
                    break;
                case 7:
                    value = taskData.g;
                    break;
                case 8:
                    value = taskData.rec_ids.length - 1
            }
            return value

        }

        public function taskPercent(taskData, taskConfig)
        {
            var percent = 0;
            switch (taskConfig.task_type)
            {
                case 1:
                    var value:int = 0;
                    if (taskConfig.task_value_f == 0)
                    {
                        value = taskData.f["total"]
                    } else
                    {
                        value = taskData.f[taskConfig.task_value_f + ""] || 0
                    }
                    percent = value / taskConfig.task_value_n > 1 ? 1 : value / taskConfig.task_value_n;
                    break;
                case 2:
                    percent = taskData.l / taskConfig.task_value_n > 1 ? 1 : taskData.l / taskConfig.task_value_n;
                    break;
                case 3:
                    percent = taskData.lg / taskConfig.task_value_n > 1 ? 1 : taskData.lg / taskConfig.task_value_n;
                    break;
                case 4:
                    var useNum:int = taskData.goods[taskConfig.task_value_f + ""];
                    if (!useNum)
                    {
                        percent = 0
                    } else
                    {
                        percent = useNum / taskConfig.task_value_n > 1 ? 1 : useNum / taskConfig.task_value_n;
                    }
                    break;
                case 5:
                    percent = taskData.b / taskConfig.task_value_n > 1 ? 1 : taskData.b / taskConfig.task_value_n;
                    break;
                case 6:
                    percent = taskData.lv / taskConfig.task_value_n > 1 ? 1 : taskData.lv / taskConfig.task_value_n;
                    break;
                case 7:
                    percent = taskData.g / taskConfig.task_value_n > 1 ? 1 : taskData.g / taskConfig.task_value_n;
                    break;
                case 8:
                    percent = (taskData.rec_ids.length - 1) / taskConfig.task_value_n > 1 ? 1 : (taskData.rec_ids.length - 1) / taskConfig.task_value_n;
                    break;
            }
            return percent

        }


        public static function get instance():TaskC
        {
            return _instance || (_instance = new TaskC());
        }
    }
}
