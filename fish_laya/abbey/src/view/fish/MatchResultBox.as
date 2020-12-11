package view.fish
{

    import conf.cfg_goods;

    import laya.events.Event;
    import laya.ui.Box;
    import laya.ui.FontClip;
    import laya.ui.Image;
    import laya.ui.Label;
    import laya.utils.Handler;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.GameTools;
    import manager.WebSocketManager;

    import model.FightM;
    import model.LoginInfoM;
    import model.MatchM;

    import ui.fight.matchResultBoxUI;

    public class MatchResultBox
    {
        private var _view:matchResultBoxUI;

        //[{name:我是玩家,num:111,me:0}]
        private var _listInfo:Array;
        private var _count = 10;

        public function MatchResultBox()
        {
            _listInfo = [];
        }

        private static var _instance:MatchResultBox;

        public static function get instance():MatchResultBox
        {
            return _instance || (_instance = new MatchResultBox());
        }

        public function init(view:matchResultBoxUI)
        {
            _view = view;
            _view.visible = false;
            _view.on(Event.MOUSE_DOWN, this, downSkip);
            _view.againBtn.on(Event.CLICK, this, onAgainBtn)
            _view.list.renderHandler = new Handler(this, renderList)
        }

        public function view():matchResultBoxUI
        {
            return _view
        }

        private function onAgainBtn():void
        {
            if (FightM.instance.isMatchingGame() && MatchM.instance.isMatchSart == 0)
            {
                WebSocketManager.instance.send(12112, null);
                _view.visible = false;
            }
        }

        private function renderList(cell:Box, index:int):void
        {
            var config = cell.dataSource;
            var ele_myselfImg:Image = cell.getChildByName("myselfImg") as Image;
            var ele_firstImg:Image = cell.getChildByName("firstImg") as Image;
            var ele_name:Label = cell.getChildByName("name") as Label;
            var ele_num:Label = cell.getChildByName("num") as Label;
            var activityImg:Image = cell.getChildByName("activity") as Image;
            var activity_num:FontClip = activityImg.getChildByName("activity_num") as FontClip;

            ele_firstImg.visible = false;
            ele_myselfImg.visible = false;
            ele_name.color = "#ffffff";
            ele_num.color = "#ffffff";
            if (index == 0)
            {
                ele_firstImg.visible = true;
            }
            if (config.me == 1)
            {
                ele_myselfImg.visible = true;
                ele_name.color = "#fff36b";
                ele_num.color = "#fff36b";
            }
            ele_name.text = LoginInfoM.instance.filterName(GameTools.formatNickName(MatchM.instance.matchNameRule(config.name), 8));
            ele_num.text = config.reward[1] + "";
            var extra_award:Array = config.extra_award
            if(extra_award && extra_award.length>0){
                activityImg.visible = true
                activityImg.skin = cfg_goods.instance(extra_award[0][0]).icon
                activity_num.value ="x"+ extra_award[0][1]
            }else {
                activityImg.visible = false
            }
        }

        private function downSkip(event:Event):void
        {
            event.stopPropagation();
        }

        private function matchingSynResultMsg():void
        {
            _view.list.array = MatchM.instance.resultMsg.data;
            _view.visible = true;
            _count = 10;
            _view.againBtn.label = "再玩一场" + _count + "s";
            Laya.timer.loop(1000, this, this.update);
        }

        public function update():void
        {
            if (FightM.instance.isMatchingGame() && _view.visible == true)
            {
                if (_count == 0)
                {
                    Laya.timer.clear(this, this.update);
                    GameEventDispatch.instance.event(GameEvent.ReturnConfirm);
                } else
                {
                    _count -= 1;
                    _view.againBtn.label = "再玩一场" + _count + "s";
                }
            }
        }

        public function register():void
        {
            if (!_view)
            {
                return
            }
            GameEventDispatch.instance.on(GameEvent.MatchingSynRusultMsg, this, matchingSynResultMsg);
        }

        public function unRegister():void
        {
            if (!_view)
            {
                return
            }
            GameEventDispatch.instance.off(GameEvent.MatchingSynRusultMsg, this, matchingSynResultMsg);
        }
    }
}
