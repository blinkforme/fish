package view.noviceGuide
{
    import control.NoviceC;

    import conf.cfg_novice_guide;

    import laya.display.Sprite;
    import laya.events.Event;
    import laya.ui.Box;
    import laya.utils.Handler;
    import laya.utils.TimeLine;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;

    import ui.abbey.NoviceGuidePageUI;

    public class NoviceGuidePage extends NoviceGuidePageUI implements ResVo
    {
        private var _startX:Number = 0;
        private var _startY:Number = 0;

        private var timeLine1:TimeLine = new TimeLine();

        public function NoviceGuidePage()
        {
            super();
        }

        private function maskClick(event:Event):void
        {
            event.stopPropagation();
        }

        public function StartGames(parm:Object = null):void
        {
            _startX = this.x;
            _startY = this.y;
            screenResize();

            noviceGuideRefresh()

            mask2.on(Event.CLICK, this, maskClick)

            list1.visible = false
            list1.array = [1]
            list1.hScrollBarSkin = "";

            list1.scrollBar.on(Event.CHANGE, this, function (event:Event)
            {
                var value:Number = list1.scrollBar.value
                if (list1.scrollBar.value > 1500)
                {
                    GameEventDispatch.instance.event(GameEvent.NoviceListFinish);
                    GameEventDispatch.instance.event(GameEvent.NoviceListChange, [1780]);
                }
                GameEventDispatch.instance.event(GameEvent.NoviceListChange, [value]);
            })

            var steps1_box:Box = this.getChildByName('steps1') as Box
            var steps2_box:Box = this.getChildByName('steps2') as Box
            var steps3_box:Box = this.getChildByName('steps3') as Box
            steps1_box.visible = false
            steps2_box.visible = false
            steps3_box.visible = false
            if (NoviceC.instance.curData.step_list_name == 'steps1')
            {
                steps1_box.visible = true
            } else if (NoviceC.instance.curData.step_list_name == 'steps2')
            {
                steps2_box.visible = true

            } else if (NoviceC.instance.curData.step_list_name == 'steps3')
            {
                steps3_box.visible = true

            }

        }


        private function clickComponent(event:Event):void
        {

            event.stopPropagation()
            GameEventDispatch.instance.event(GameEvent.FinishNoviceGuideStep);
        }

        private function clickView():void
        {
            GameEventDispatch.instance.event(GameEvent.FinishNoviceGuideStep);
        }

        private function screenResize():void
        {
            var step_box:Box = this.getChildByName('steps1') as Box
            step_box.height = Laya.stage.height
            step_box.width = Laya.stage.width

            var step_box2:Box = this.getChildByName('steps2') as Box
            step_box2.height = Laya.stage.height
            step_box2.width = Laya.stage.width

            var step_box3:Box = this.getChildByName('steps3') as Box
            step_box3.height = Laya.stage.height
            step_box3.width = Laya.stage.width

            mask2.width = Laya.stage.width
            mask2.height = Laya.stage.height

            this.size(Laya.stage.width, Laya.stage.height);
        }

        public function clearAll(stepName:String):void
        {
            var steps1:Box = this.getChildByName(stepName) as Box
            var steps1_childs:Array = steps1._children;
            if (steps1_childs)
            {
                for (var i = 0; i < steps1_childs.length; i++)
                {
                    steps1_childs[i].visible = false
                }

            }
        }

        private function resetPassClick():void
        {

            var d:cfg_novice_guide = NoviceC.instance.curData


            this.off(Event.CLICK, this, clickComponent)
            this.off(Event.CLICK, this, clickView)
            this.off(Event.MOUSE_DOWN, this, onMouseDown)
            this.off(Event.MOUSE_UP, this, onMouseUp)
            this.off(Event.MOUSE_MOVE, this, onMouseMove)

            onMouseUp(null)
            mask2.alpha = 0.6
            if (d.type == 'shoot')
            {
                mask2.alpha = 0
                this.on(Event.MOUSE_DOWN, this, onMouseDown);
                this.on(Event.MOUSE_UP, this, onMouseUp);
                this.on(Event.MOUSE_MOVE, this, onMouseMove);

            } else
            {
                if (d.click_event == 'view')
                {
                    this.on(Event.CLICK, this, clickView)
                } else if (d.click_event == 'view_drag')
                {
                    list1.visible = true
                } else if (d.click_event == 'name')
                {
                    var component = this.getChildByName(d.step_list_name).getChildByName(d.step_box_name).getChildByName(d.click_name)
                    if (component)
                    {
                        component.offAll(Event.CLICK)
                        component.on(Event.CLICK, this, clickComponent)
                    }
                }
            }

        }

        private function onMouseDown(event:Event):void
        {
            GameEventDispatch.instance.event(GameEvent.NoviceShoot, [event]);
        }

        private function onMouseUp(event:Event):void
        {
            GameEventDispatch.instance.event(GameEvent.NoviceShootUp, [event]);
        }

        private function onMouseMove(event:Event):void
        {
            GameEventDispatch.instance.event(GameEvent.NoviceShootMove, [event]);
        }


        private function addEffect1(ele:Sprite):void
        {
            ele.anchorX = 0.5
            ele.anchorY = 0.5
            ele.x = ele.x + ele.width / 2
            ele.y = ele.y + ele.height / 2
            timeLine1.reset()

            timeLine1.to(ele, {
                scaleX: 1.05,
                scaleY: 0.95
            }, 500).to(ele, {
                scaleX: 1,
                scaleY: 1
            }, 500).to(ele, {
                scaleX: 0.95,
                scaleY: 1.05
            }, 500).to(ele, {
                scaleX: 1,
                scaleY: 1
            }, 500)
            timeLine1.play(0, true);
        }

        private function noviceGuideRefresh():void
        {
            clearAll("steps1")
            clearAll("steps2")
            clearAll("steps3")

            var d:cfg_novice_guide = NoviceC.instance.curData
            if (d.click_event == 'view_drag')
            {
                list1.visible = true
            } else
            {
                list1.visible = false
            }

            if (d.step_box_name && d.step_list_name)
            {
                var box_step:Box = this.getChildByName(d.step_list_name).getChildByName(d.step_box_name) as Box
                box_step.visible = true

                var posData = NoviceC.instance.stepPosData[d.type]
                if (posData)
                {
                    box_step.right = posData.right - 50
                    box_step.bottom = posData.bottom - 40
                }

                if (d.effect_name1)
                {
                    addEffect1(box_step.getChildByName(d.effect_name1) as Sprite)
                }
            }

            resetPassClick()
        }

        public function paoOneReset(x:Number, y:Number):void
        {
            var steps1:Box = this.getChildByName('steps1') as Box
            var show1:Box = steps1.getChildByName('step_click1') as Box
            var show2:Box = steps1.getChildByName('step_click2') as Box
            var show3:Box = steps1.getChildByName('step_change') as Box

            var steps2:Box = this.getChildByName('steps2') as Box
            var show2_1:Box = steps2.getChildByName('step_click4') as Box

            //            显示活动金币
            show2_1.x = x - 330
            show2_1.y = y - 170

            show1.x = x - 70
            show1.y = y - 170

            //            显示您的金币和钻石
            show2.x = x - 330
            show2.y = y - 170

            show3.x = x - 190
            show3.y = y - 100
        }

        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.NoviceGuideRefresh, this, noviceGuideRefresh);
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.on(GameEvent.PaoOneReset, this, paoOneReset);
        }


        public function unRegister():void
        {
            clearAll("steps1")
            clearAll("steps2")
            clearAll("steps3")
            GameEventDispatch.instance.off(GameEvent.NoviceGuideRefresh, this, noviceGuideRefresh);
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.off(GameEvent.PaoOneReset, this, paoOneReset);

        }
    }
}
