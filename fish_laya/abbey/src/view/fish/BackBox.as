package view.fish
{
    import control.RedpointC;

    import emurs.ShowType;

    import laya.events.Event;
    import laya.utils.Tween;

    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.GameTools;
    import manager.ScreenAdaptManager;
    import manager.UiManager;
    import manager.WebSocketManager;


    import model.FightM;
    import model.MatchM;
    import model.RoleInfoM;
    import model.RuleM;

    import proto.C2s_19002;

    import struct.QuitTipInfo;

    import ui.fight.backBoxUI;

    public class BackBox
    {

        private var _view:backBoxUI
        private var reEndX:Number = -359;
        private var reStartX:Number = -100;

        public function BackBox()
        {
        }

        private static var _instance:BackBox;

        public static function get instance():BackBox
        {
            return _instance || (_instance = new BackBox());
        }

        public function init(view:backBoxUI)
        {
            _view = view;
            _view.on(Event.MOUSE_DOWN, this, downSkip);
            _view.checkBtn.on(Event.MOUSE_DOWN, this, downSkip);
            _view.settingBtn.on(Event.MOUSE_DOWN, this, downSkip);
            _view.returnBtn.on(Event.MOUSE_DOWN, this, downSkip);
            _view.taskNewBtn.on(Event.MOUSE_DOWN, this, downSkip);
            _view.fanBtn.on(Event.MOUSE_DOWN, this, downSkip);
            _view.zhenBtn.on(Event.MOUSE_DOWN, this, downSkip);

            _view.barBox.on(Event.CLICK, this, clickBar);
            _view.checkBtn.on(Event.CLICK, this, clickCheck);
            _view.settingBtn.on(Event.CLICK, this, onChangeSettingBtn);
            _view.returnBtn.on(Event.CLICK, this, clickClose);
            _view.taskNewBtn.on(Event.CLICK, this, taskNew);

            _view.zhenBtn.visible = false;
            _view.fanBtn.visible = true;
            showTaskNewIcon()
        }

        private function downSkip(event:Event):void
        {
            event.stopPropagation();
        }

        public function tip():void
        {
            var info:QuitTipInfo = new QuitTipInfo();
            info.state = GameConst.quit_state_left_cancel_right_confirm;
            if (FightM.instance.isMatchingGame() && (MatchM.instance.isMatchSart == 1 && MatchResultBox.instance.view().visible == false))
            {
                info.content = "现在退出比赛，系统将扣除报名费的60%作为惩罚";
            } else
            {
                info.content = "是否退出房间？";
            }
            info.confirmMsg = GameEvent.ReturnConfirm;
            info.autoCloseTime = 10;
            GameEventDispatch.instance.event(GameEvent.QuitTip, info);
        }

        private function clickClose(event:Event):void
        {
            event.stopPropagation();
            tip();
        }

        public function onChangeSettingBtn(event:Event):void
        {
            if (!_view)
            {
                return;
            }
            if (_view.left == -359 + GameTools.iphoneXOffset)
            {

            } else
            {
                // paoCollect();
                //collcet();
                GameEventDispatch.instance.event(GameEvent.CloseOtherBar);
                UiManager.instance.loadView("Setting", null, ShowType.SMALL_TO_BIG);
            }
        }

        public function taskNew(event:Event):void
        {
            var a:C2s_19002 = new C2s_19002();
            WebSocketManager.instance.send(19002, a);
            UiManager.instance.loadView("TaskNew", null, ShowType.SMALL_TO_BIG);
        }

        public function clickBar():void
        {
            if (!_view)
            {
                return
            }
            if (_view.zhenBtn.visible == true && _view.fanBtn.visible == false)
            {
                _view.zhenBtn.visible = false;
                _view.fanBtn.visible = true;
                barInFunc();
            } else if (_view.zhenBtn.visible == false && _view.fanBtn.visible == true)
            {
                _view.zhenBtn.visible = true;
                _view.fanBtn.visible = false;
                barGoFunc();
            }
        }

        public function clickCheck():void
        {
            if (!_view)
            {
                return
            }
            GameTools.buttonEffect(_view.checkBtn);
            GameEventDispatch.instance.event(GameEvent.FishTypeC);

        }


        public function barInFunc():void
        {
            if (!_view)
            {
                return
            }
            var endLeftX:Number = -359;
            if (GameTools.isIphoneXCrossScreen() && ScreenAdaptManager.instance.notch == "left")
            {
                endLeftX += GameTools.iphoneXOffset;
            }
            Tween.to(_view, {left: endLeftX}, 300, null);
        }

        public function barGoFunc():void
        {
            if (!_view)
            {
                return
            }
            showTaskNewIcon();
            var startLeftX:Number = -20;
            if (GameTools.isIphoneXCrossScreen() && ScreenAdaptManager.instance.notch == "left")
            {
                startLeftX += GameTools.iphoneXOffset
            }
            if (_view.taskNewBtn.visible == false)
            {
                _view.checkBtn.pos(134, 16)
                startLeftX = -100;
                if (GameTools.isIphoneXCrossScreen() && ScreenAdaptManager.instance.notch == "left")
                {
                    startLeftX += GameTools.iphoneXOffset
                }

            } else
            {
                _view.checkBtn.pos(53, 17)
            }
            Tween.to(_view, {left: startLeftX}, 300, null);
        }

        public function showTaskNewIcon():void
        {
            if (!_view)
            {
                return
            }
            var day_index:int = RoleInfoM.instance.getDayIndex()
            var red_points:int = RoleInfoM.instance.getRedPoints()
            if (!FightM.instance.coinShootScene())
            {
                reEndX = -180;
                reStartX = -359;
                _view.taskNewBtn.visible = false;
            } else if (RuleM.instance.isShowScene)
            {
                _view.taskNewBtn.visible = false;
            } else
            {
                if (day_index > 7)
                {
                    if (GameConst.point_new_task_finish & red_points)
                    {
                        reEndX = -95;
                        reStartX = -359;
                        _view.taskNewBtn.visible = false;
                    } else
                    {
                        reEndX = -180;
                        reStartX = -359;
                        _view.taskNewBtn.visible = false;
                    }
                } else
                {
                    reEndX = -95;
                    reStartX = -359;
                    _view.taskNewBtn.visible = false;
                }
            }
        }

        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.NoviceGuideClickBar, this, clickBar);
        }

        public function unRegister():void
        {
            if (!_view)
            {
                return
            }
            if (_view.zhenBtn.visible == true && _view.fanBtn.visible == false)
            {
                _view.zhenBtn.visible = false;
                _view.fanBtn.visible = true;
                BackBox.instance.barInFunc()
            }
            GameEventDispatch.instance.off(GameEvent.NoviceGuideClickBar, this, clickBar);
        }

        public function resetUi():void
        {
            if (_view)
            {
                _view.checkBtn.visible = FightM.instance.coinShootScene();
            }
        }

        public function showRedPoint():void
        {
            if (!_view)
            {
                return;
            }
            var red_points:int = RoleInfoM.instance.getRedPoints();
            if (GameConst.point_new_task_finish & red_points)
            {
                RedpointC.instance.removeRedPoint(_view.taskNewBtn)
                RedpointC.instance.addRedPointToIcon(_view.taskNewBtn, 0.75, 6)
            } else
            {
                RedpointC.instance.removeRedPoint(_view.taskNewBtn)
            }
            var scene_arr:Array = [1, 2, 3];
            if (scene_arr.indexOf(FightM.instance.getSceneId()) > -1)
            {
                if ((GameConst.point_new_task_finish & red_points) || (GameConst.point_online_reward & red_points))
                {
                    RedpointC.instance.removeRedPoint(_view.pull_box_bg)
                    RedpointC.instance.addRedPointToIcon(_view.pull_box_bg, 0.97, 4)
                } else
                {
                    RedpointC.instance.removeRedPoint(_view.pull_box_bg)
                }
            } else
            {
                if ((GameConst.point_online_reward & red_points))
                {
                    RedpointC.instance.removeRedPoint(_view.pull_box_bg)
                    RedpointC.instance.addRedPointToIcon(_view.pull_box_bg, 0.97, 4)
                } else
                {
                    RedpointC.instance.removeRedPoint(_view.pull_box_bg)
                }
            }
        }
    }
}
