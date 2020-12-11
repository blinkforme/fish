package view.compenstate
{
    import manager.GameConst;
    import manager.GameTools;

    import model.CompenM;

    import laya.events.Event;
    import laya.maths.Point;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;

    import ui.abbey.CompensateUI;

    public class CompenstateView extends CompensateUI implements ResVo
    {
        private var _rewardCount:Number;
        private var _list:Array;
        private var _point:Point;
        private var _startX:Number = 0;
        private var _startY:Number = 0;

        private var content:Array = [[1, 1000], [2, 4000], [4, 5000], [5, 7000], [21, 9000], [22, 10000], [23, 3000], [24, 4000], [25, 4000]];

        public function CompenstateView()
        {
            super();
        }

        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;
            _startX = this.x;
            _startY = this.y;
            if (CompenM.instance.rewardFrom && CompenM.instance.rewardFrom == GameConst.contest_match_scene_id)
            {
                _list = CompenM.instance.compenList;
                rewardlist.array = CompenM.instance.compenList;
            } else
            {
                _list = CompenM.instance.showRefeshList;
                rewardlist.array = CompenM.instance.showRefeshList;
            }
            makeName.text = CompenM.instance.rewardName;

            rewardlist.repeatX = _list.length;
            _point = CompenM.instance.point(_list.length);
            rewardlist.x = _point.x;
            rewardlist.y = _point.y;
            //_list = [{icon:{skin:"ui/common/diamond1.png"},count:{text:"60000"}}]

            screenResize();
            bmask.on(Event.CLICK, this, clickMask);
            receiveBtn.on(Event.CLICK, this, receive);
            //rewardlist.array = _list;
        }

        private function clickMask():void
        {


        }

        private function screenResize():void
        {
            var contentWidth:int = 700;//组件范围width
            var contentHeight:int = 450;//组件范围height
            var contentStartX:int = 290;//组件左边距
            var contentStartY:int = 155;//组件上边距
            var posXOff:Number = (Laya.stage.width - contentWidth) / 2;
            var posYOff:Number = (Laya.stage.height - contentHeight) / 2;
            this.pos(_startX + posXOff - contentStartX, _startY + posYOff - contentStartY);
            this.size(Laya.stage.width, Laya.stage.height);
        }

        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            //receiveBtn.on(Event.CLICK,this,receive);
        }

        private function receive():void
        {

            if (!CompenM.instance.rewardFrom || CompenM.instance.rewardFrom == GameConst.contest_match_scene_id)
            {
                CompenM.instance.currentTimes = CompenM.instance.currentTimes + 1;
            }
            UiManager.instance.closePanel("Compenstate", false);

        }

        public function unRegister():void
        {
            if(!CompenM.instance.rewardFrom || CompenM.instance.rewardFrom == GameConst.contest_match_scene_id)
            {
                GameEventDispatch.instance.event(GameEvent.OpenMakeUp, [content]);
            }
            CompenM.instance.rewardFrom = -1;
            this.x = _startX
            this.y = _startY;
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            //receiveBtn.off(Event.CLICK,this,receive);
        }
    }
}
