package control
{
    import engine.tool.StartParam;

    import manager.GameTools;

    import model.LoginInfoM;
    import model.LoginM;
    import model.RoleInfoM;

    import conf.cfg_battery;
    import conf.cfg_novice_guide;
    import conf.cfg_task;

    import emurs.ShowType;

    import fight.FightManager;

    import manager.ConfigManager;
    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.UiManager;
    import manager.WebSocketManager;

    import proto.C2s_19000;

    public class NoviceC
    {
        private static var _instance:NoviceC;
        public var curData:cfg_novice_guide;
        public var curIndex:Number = 0;

        public var shootCost:Number = 0;
        public var isInGuide:Boolean = false;// 是否在引导中

        public var stepArr:Array = []//新手流程数据
        public var stepName:String = ""//新手流程名称

        public var stepPosData = {}

        public function NoviceC()
        {
            GameEventDispatch.instance.on(GameEvent.StartNoviceGuide, this, startNoviceGuide);
            GameEventDispatch.instance.on(GameEvent.FinishNoviceGuideStep, this, doFinishGuide);


            GameEventDispatch.instance.on(GameEvent.NoviceGuideShoot, this, shootCostUpdate);
            GameEventDispatch.instance.on(GameEvent.SystemReset, this, closeNoviceGuide);
            GameEventDispatch.instance.on(GameEvent.CloseNovice, this, closeNoviceGuide);
            GameEventDispatch.instance.on("37001", this, endFinishNovice);
//            GameEventDispatch.instance.on(GameEvent.BatteryBuyRet, this, endUpgradeBattery);
            GameEventDispatch.instance.on(GameEvent.NoviceListFinish, this, endScrollList);

//            GameEventDispatch.instance.on(GameEvent.LoadUi, this, loadUi);
//            GameEventDispatch.instance.on(GameEvent.CloseUi, this, closeUi);
        }

//        public function isTopPage(pageName:String):Boolean
//        {
//            var pageObj:Object = Laya.stage.getChildByName(pageName);
//            if (!pageObj || pageObj.visible == false)
//            {
//                return false;
//            }
//            var num:Number = Laya.stage.numChildren;
//            for (var i:int = 0; i < num; i++)
//            {
//                var onePage:Object = Laya.stage.getChildAt(i);
//                if (onePage.visible && onePage['name'] && onePage['name'].length > 0)
//                {
//                    if (onePage.name != "Mask" && onePage.name != pageName)
//                    {
//                        onePage.zOrder > pageObj.zOrder;
//                        return false;
//                    }
//                }
//            }
//            if (num != Laya.stage.numChildren)
//            {
//                isTopPage(pageName);
//            }
//            return true;
//        }
//
//        public function loadUi(data:*):void
//        {
//            var name:String = data as String;
//            if (name == "NoviceGuide")
//            {
//                return;
//            }
//            checkSteps3(name);
//        }
//
//        public function closeUi(data:*):void
//        {
//            var name:String = data as String;
//            if (name == "NoviceGuide")
//            {
//                return;
//            }
//            Laya.timer.once(200, this, checkSteps3);
//        }
//
//
//        public function checkSteps3(name:String = "MainPage"):void
//        {
//            if (name != "MainPage")
//            {
//                return;
//            }
//            if (isTopPage("MainPage") && LoginM.instance.isNovicePlayer == 0)
//            {
//                var step_data:Object;
//                if (stepName && stepName != 'steps3')
//                {
//                    var statusName:String = stepName.slice(0, 4) + stepName.slice(5);
//                    step_data = RoleInfoM.instance.guide_status[statusName]
//                    if (step_data.status == 1)
//                    {
//                        step_data = RoleInfoM.instance.guide_status['step3']
//                        if (step_data)
//                        {
//                            if (step_data.status == 0)
//                            {
//                                startNoviceGuide("steps3");
//                            }
//                        }
//                    }
//                } else
//                {
//                    step_data = RoleInfoM.instance.guide_status['step3']
//                    if (step_data)
//                    {
//                        if (step_data.status == 0)
//                        {
//                            startNoviceGuide("steps3");
//                        }
//                    }
//                }
//            }
//        }

        public function endScrollList():void
        {
            if (curData.click_event == 'view_drag')
            {
                doFinishGuide()
            }
        }

        public function endFinishNovice(data:*):void
        {
            if (0 == data.code)
            {
                RoleInfoM.instance.guide_status = data['guide_status']
            } else
            {
                GameTools.dealCode(data.code)
            }
        }

        public function closeNoviceGuide():void
        {

            if (stepName == 'steps1')
            {
                WebSocketManager.instance.send(37000, {"is_finish": 0, "step_id": 'step1'})
            } else if (stepName == 'steps2')
            {
                WebSocketManager.instance.send(37000, {"is_finish": 0, "step_id": 'step2'})
            } else if (stepName == 'steps3')
            {
                WebSocketManager.instance.send(37000, {"is_finish": 0, "step_id": 'step3'})
            }

            UiManager.instance.closePanel("NoviceGuide", true)
            isInGuide = false
        }

        public function shootCostUpdate():void
        {
            if (curData)
            {
                if (curData.type == GameConst.novice_guide_shoot)
                {
                    shootCost += cfg_battery.instance(RoleInfoM.instance.getBattery()).comsume
                    if (shootCost > 10)
                    {
                        doFinishGuide()
                    }
                }
            }
        }

        public function doFinishGuide():void
        {
            if (curData.type == GameConst.novice_guide_click)
            {
                if (StartParam.instance.getParam("is_display_public_no_subscribe") == 1)
                {
                    //跳过公众号
                    if (curData.step_box_name == 'step_follow' && curData.step_list_name == 'step1')
                    {
                        nextGuide()
                    }
                }
            } else if (curData.type == GameConst.novice_guide_fight)
            {
                LoginM.instance.sceneId = 1;
                GameEventDispatch.instance.event(GameEvent.StartLoad, [GameConst.loadFishState]);
            } else if (curData.type == GameConst.novice_guide_slider)
            {
                GameEventDispatch.instance.event(GameEvent.NoviceGuideClickBar);
            }
            else if (curData.type == GameConst.novice_guide_new)
            {
                UiManager.instance.loadView('TaskNew')
            } else if (curData.type == GameConst.novice_guide_acceptNew)
            {
                GameEventDispatch.instance.event(GameEvent.NoviceGuideAcceptTaskNew);

            } else if (curData.type == GameConst.novice_guide_quitNew)
            {
                UiManager.instance.closePanel('TaskNew', false)
            } else if (curData.type == GameConst.novice_guide_daily)
            {
                UiManager.instance.loadView("TaskDaily", null, ShowType.SMALL_TO_BIG);
            } else if (curData.type == GameConst.novice_guide_quitDaily)
            {
                UiManager.instance.closePanel('TaskDaily', false)
            }

            else if (curData.type == GameConst.novice_guide_daily_go)
            {
                UiManager.instance.closePanel('TaskDaily', false)
                GameEventDispatch.instance.event(GameEvent.ShowGuide, cfg_task.instance(42));
            }
            else if (curData.type == GameConst.novice_guide_daily_use_prop)
            {
                FightManager.instance.useSkill(1);
            }
            else if (curData.type == GameConst.novice_guide_daily_accept)
            {
                var a:C2s_19000 = new C2s_19000();
                a.task_id = 42;
                a.is_daily = true;

                WebSocketManager.instance.send(19000, a);
            }


            else if (curData.type == GameConst.novice_guide_unlockBattery)
            {
                GameEventDispatch.instance.event(GameEvent.NoviceGuideUnlockBattery);

            } else if (curData.type == GameConst.novice_guide_changeBattery)
            {
                GameEventDispatch.instance.event(GameEvent.NoviceGuideChangeBattery);
            }

            //            以下为比赛引导
            else if (curData.type == GameConst.novice_guide_slider_contest)
            {
                GameEventDispatch.instance.event(GameEvent.NoviceSliderContest);
            } else if (curData.type == GameConst.novice_guide_open_contest_icon)
            {
                GameEventDispatch.instance.event(GameEvent.NoviceOpenContest);
            } else if (curData.type == GameConst.novice_guide_sign_contest)
            {
                GameEventDispatch.instance.event(GameEvent.NoviceSignContest);
            } else if (curData.type == GameConst.novice_guide_sign_contest_confirm)
            {
                UiManager.instance.closePanel("QuitTip", false);
                GameEventDispatch.instance.event(GameEvent.NoviceSignContestConfirm);
            } else if (curData.type == GameConst.novice_guide_rank)
            {
                UiManager.instance.loadView("Rank");
            } else if (curData.type == GameConst.novice_guide_quitRank)
            {
                if (StartParam.instance.getParam("is_display_public_no_subscribe") == 1)
                {
                    UiManager.instance.closePanel("Rank", false);
                } else
                {
                    nextGuide()
                }
            }
            else if (curData.type == GameConst.novice_guide_open_follow)
            {
                if (StartParam.instance.getParam("is_display_public_no_subscribe") == 1)
                {
                    UiManager.instance.loadView("Subscription", null, ShowType.SMALL_TO_BIG);
                } else
                {
                    nextGuide()
                }

            }

            else if (curData.type == GameConst.novice_guide_quitFight)
            {
                WebSocketManager.instance.send(12003, null);
            }

            nextGuide()
        }

        public function nextGuide():void
        {
            if (isEnd())
            {
                if (stepName == 'steps1')
                {
                    WebSocketManager.instance.send(37000, {"is_finish": 1, "step_id": "step1"})
                } else if (stepName == 'steps2')
                {
                    WebSocketManager.instance.send(37000, {"is_finish": 1, "step_id": "step2"})
                } else if (stepName == 'steps3')
                {
                    WebSocketManager.instance.send(37000, {"is_finish": 1, "step_id": "step3"})
                }

                UiManager.instance.closePanel("NoviceGuide", true)
                isInGuide = false

            } else
            {
                curIndex++;
                curData = stepArr[curIndex]
                GameEventDispatch.instance.event(GameEvent.NoviceGuideRefresh);
            }
        }

        public function isEnd():Boolean
        {
            var isEnd:Boolean = stepArr.length <= curIndex + 1
            return isEnd
        }

        public function endUpgradeBattery(data:*):void
        {
            //             解锁100倍炮
            if (RoleInfoM.instance.getBattery() == 8)
            {
                WebSocketManager.instance.send(12003, null);
                startNoviceGuide('steps2')
            }
        }

        public function startNoviceGuide(step:String):void
        {
            isInGuide = true
            stepName = step
            curIndex = 0
            stepArr = ConfigManager.filter("cfg_novice_guide", function (cfg:cfg_novice_guide)
            {
                return cfg.step_list_name == stepName
            }, function (a:cfg_novice_guide, b:cfg_novice_guide)
            {
                return a.id - b.id
            })
            curData = stepArr[0]

            UiManager.instance.loadView('NoviceGuide')
        }

        public static function get instance():NoviceC
        {
            return _instance || (_instance = new NoviceC());
        }
    }
}
