package view.rewardTip
{
    import model.RTipM;

    import laya.display.Animation;
    import laya.events.Event;
    import laya.media.SoundManager;

    import manager.ConfigManager;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.GameSoundManager;
    import manager.ResVo;
    import manager.UiManager;

    import ui.abbey.RewardTipUI;

    public class RewardTipView extends RewardTipUI implements ResVo
    {
        private var ani:Animation;
        private var _imageArr:Array;
        private var _pointArr:Array;
        private var boxArr:Array;
        private var _countArr:Array;
        private var soundPath:String;
        private var _startX:Number = 0;
        private var _startY:Number = 0;

        public function RewardTipView()
        {
            super();
        }

        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;
            _startX = this.x;
            _startY = this.y;
            _imageArr = RTipM.instance.ImageArr;
            _pointArr = RTipM.instance.pointList;
            _countArr = RTipM.instance.countArr;
            denImg.visible = RTipM.instance.isShow;
            updateData();
            start();
            soundPath = ConfigManager.getConfValue("cfg_global", 1, "get_sound") as String;
            confirmBtn.on(Event.CLICK, this, stop);
            //	this.on(Event.CLICK,this,click);
            playSound();
            screenResize();
        }


        public function playSound():void
        {

            //SoundManager.playSound(soundPath);
            GameSoundManager.playSound(soundPath);
        }

        private function click(event:Event):void
        {
            event.stopPropagation();
            stop();

        }

        private function screenResize():void
        {
            confirmBtn.width = Laya.stage.width * 2;
            confirmBtn.height = Laya.stage.height * 2;
            this.size(Laya.stage.width, Laya.stage.height);
        }

        private function start():void
        {
            for (var i:int = 0; i < boxArr.length; i++)
            {
                ReardBox(boxArr[i]).start();
            }
        }

        public function updateData():void
        {
            boxArr = new Array();
            for (var i:int = 0; i < _imageArr.length; i++)
            {
                var rewardBox:ReardBox = new ReardBox(_imageArr[i], _pointArr[i], this, _countArr[i]);
                boxArr.push(rewardBox);
            }
        }


        private function stop():void
        {
            //			this.removeChild(ani);
            //			oldIconOne.skin = "";
            for (var i:int = 0; i < boxArr.length; i++)
            {
                ReardBox(boxArr[i]).stop();
            }


        }

        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.CloseRewadTip, this, closePanel);
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
        }

        private function closePanel():void
        {
            UiManager.instance.closePanel("RewardTip", false);

        }

        public function unRegister():void
        {
            this.x = _startX;
            this.y = _startY;
            SoundManager.stopSound(soundPath);
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
        }
    }
}
