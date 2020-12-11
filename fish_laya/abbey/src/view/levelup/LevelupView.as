package view.levelup
{
    import laya.display.Sprite;

    import model.RoleInfoM;
    import model.UpgradeM;

    import laya.events.Event;
    import laya.ui.FontClip;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.SpineTemplet;
    import manager.UiManager;

    import ui.abbey.LevelUpPageUI;

    public class LevelupView extends LevelUpPageUI implements ResVo
    {
        private var _spineRoot:Sprite;
        private var _spine:SpineTemplet;
        private var _imageArr:Array;
        private var _pointArr:Array;
        private var _count:Number;
        private var boxArr:Array;
        private var countClip:FontClip
        private var _countArr:Array;
        private var _len:Number;
        private var _startX:Number = 0;
        private var _startY:Number = 0;

        public function LevelupView()
        {
            super();
        }

        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;
            _startX = this.x;
            _startY = this.y;
            playSketon();
            _imageArr = UpgradeM.instance.ImageArr;
            _pointArr = UpgradeM.instance.pointList;
            _countArr = UpgradeM.instance.countArr;
            _len = _imageArr.length;
            beiImg.width = 150 * _len;
            initData();
            start();
            confimBtn.on(Event.CLICK, this, clickConfim);
            screenResize();

        }

        private function clickConfim():void
        {
            stop();

        }

        private function screenResize():void
        {
            var contentWidth:int = 840;//组件范围width
            var contentHeight:int = 515;//组件范围height
            var contentStartX:int = 220;//组件左边距
            var contentStartY:int = 102;//组件上边距
            var posXOff:Number = (Laya.stage.width - contentWidth) / 2;
            var posYOff:Number = (Laya.stage.height - contentHeight) / 2;
            this.pos(_startX + posXOff - contentStartX, _startY + posYOff - contentStartY);
            this.size(Laya.stage.width, Laya.stage.height);
        }

        private function initData():void
        {
            boxArr = new Array();
            for (var i:int = 0; i < _imageArr.length; i++)
            {
                var levelbox:LevelBox = new LevelBox(_imageArr[i], _pointArr[i], this, _countArr[i]);
                boxArr.push(levelbox);
            }
            countClip = new FontClip("font/font_3.png", "0123456789");
            countClip.anchorX = 0.5;
            countClip.anchorY = 0.5;
            countClip.x = coinImg.x;
            countClip.y = coinImg.y - 50;
            countClip.value = RoleInfoM.instance.getLevel() + "";
            this.addChild(countClip);
        }

        private function start():void
        {
            for (var i:int = 0; i < boxArr.length; i++)
            {
                LevelBox(boxArr[i]).start();
            }
        }

        private function stop():void
        {
            for (var i:int = 0; i < boxArr.length; i++)
            {
                LevelBox(boxArr[i]).stop();
            }
            UiManager.instance.closePanel("Levelup", false);
            removieSketon();
        }

        //播放骨骼动画
        private function playSketon():void
        {
            if (!_spine)
            {
                _spine = new SpineTemplet("shengji");
            }
            if (!_spineRoot)
            {
                _spineRoot = new Sprite();
            }
            _spine.setScale(1.2, 1.2);
            _spineRoot.addChild(_spine)
            _spineRoot.pos(coinImg.x, coinImg.y);
            _spine.play("H5_shengji", false);
            this.addChild(_spineRoot);
            Laya.timer.once(550, this, startPlayTwoComplete);
            //trace(_spine.width,_spine.height);
        }

        private function startPlayTwoComplete():void
        {
            _spine.play("H5_shengji_xunhuan", true);

        }

        //移除骨骼动画
        private function removieSketon():void
        {
            if (_spine != null)
            {
                this.removeChild(_spineRoot);
                _spine.destroyed;
            }
            if (countClip != null)
            {
                this.removeChild(countClip);
                countClip.destroyed;
            }
        }

        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);

        }

        public function unRegister():void
        {
            this.x = _startX;
            this.y = _startY;
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            Laya.timer.clear(this, startPlayTwoComplete);

        }

    }
}
