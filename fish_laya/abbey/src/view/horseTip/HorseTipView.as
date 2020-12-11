package view.horseTip
{
    import model.HorseM;

    import laya.html.dom.HTMLDivElement;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;

    import ui.abbey.HoureTipUI;

    public class HorseTipView extends HoureTipUI implements ResVo
    {
        private var htmlDiv:HTMLDivElement = null;
        private var colorOne:String = '#d26ae3';
        private var _horseCount:int = 0;

        public function HorseTipView()
        {
            super();
        }

        public function StartGames(parm:Object = null):void
        {
            this.mouseThrough = true;
            this.mouseEnabled = false;
            initData()
            screenResize();

        }

        private function showHorse():void
        {
            if (!htmlDiv)
            {
                htmlDiv = new HTMLDivElement();
                htmlDiv.autoSize = false;
                htmlDiv.x = panel.width + 10;
                htmlDiv.style.width = 300;
                htmlDiv.style.height = 100;
                htmlDiv.style.align = "center";
                htmlDiv.style.wordWrap = false;
                htmlDiv.style.fontSize = 19;
                //htmlDiv.style.font = "SimHei"
                panel.addChild(htmlDiv);
                panel.centerX = 0;
            }
            if (_horseCount <= 0 && HorseM.instance.getHorseTipNum() > 0)
            {
                htmlDiv.innerHTML = HorseM.instance.getHtml();
                htmlDiv.x = panel.width + 10;
                _horseCount = HorseM.instance.repeatNum;
            }
        }

        private function screenResize():void
        {
            this.size(Laya.stage.width, Laya.stage.height);
        }

        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);

            //GameEventDispatch.instance.on(GameEvent.HorseTipUpdate,this,showHorse);
        }

        public function unRegister():void
        {
            htmlDiv = null;
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            //GameEventDispatch.instance.off(GameEvent.HorseTipUpdate,this,showHorse);
        }

        private function initData():void
        {
            Laya.timer.loop(100, this, start);
        }

        private function start():void
        {
            if (htmlDiv)
            {
                htmlDiv.x = htmlDiv.x - 3;
                if ((htmlDiv.contextWidth + htmlDiv.x) < -10)
                {
                    htmlDiv.x = panel.width + 10;
                    _horseCount--;
                    if (_horseCount > 0)
                    {
                        htmlDiv.x = panel.width + 10;
                    }
                    else
                    {
                        if (HorseM.instance.getHorseTipNum() > 0)
                        {
                            showHorse();
                        } else
                        {
                            Laya.timer.clear(this, start);
                            HorseM.instance.isIn = false;
                            UiManager.instance.closePanel("HorseTip", false);
                        }

                    }
                }
            } else
            {
                showHorse();
            }
        }
    }
}
