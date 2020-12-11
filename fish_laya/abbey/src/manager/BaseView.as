package manager
{

	
    import emurs.ShowType;

    import laya.utils.Handler;
    import laya.utils.Tween;

    public class BaseView
    {
        private var _panel:*;
        private var _caches:Object;
        private var _name:String;
        private var isShow:Boolean = false;
        private var _type:String;

        public function BaseView()
        {
            _caches = new Object();
        }


        public function creatPanel(panel:Class, parm:Object, name:String):void
        {

            var arr:Array = panel.prototype.constructor["name"].split('.');
            _name = arr[arr.length - 1];

            var uiShowing:Boolean = false;
            _panel = (_caches[_name] || new panel());
            _caches[_name] = _panel;
            if (_panel.parent)
            {
                uiShowing = _panel.visible;
                _panel.visible = true;
            } else
            {
                _panel.name = name;
                Laya.stage.addChild(_panel);
            }
            if (!uiShowing)
            {
                showEffenct(EffectType);
                _panel.StartGames(parm);
                _panel.register();
            }
            else
            {
                GameEventDispatch.instance.event(GameEvent.RightWait);
            }
            //Laya.timer.once(300,this,start);

            //GameEventDispatch.instance.event(GameEvent.CloseWait);

        }

        private function start():void
        {
            GameEventDispatch.instance.event(GameEvent.CloseWait);
        }

        private function showEffenct(type:String):void
        {
            if (_panel != null)
            {
                if (type == ShowType.SMALL_TO_BIG)
                {
                    _panel.pivotX = Laya.stage.mouseX
                    _panel.pivotY = Laya.stage.mouseY;
                    _panel.x = Laya.stage.mouseX;
                    _panel.y = Laya.stage.mouseY;
                    _panel.scaleX = 0;
                    _panel.scaleY = 0;
                    GameEventDispatch.instance.event(GameEvent.CloseWait);
                    Tween.to(_panel, {scaleX: 1.05, scaleY: 1.05}, 300, null, Handler.create(this, showComplete));
                } else if(type == ShowType.Normal)
                {
                    _panel.pivotX = Laya.stage.mouseX
                    _panel.pivotY = Laya.stage.mouseY;
                    _panel.x = Laya.stage.mouseX;
                    _panel.y = Laya.stage.mouseY;
                    _panel.scaleX = 1;
                    _panel.scaleY = 1;
                    GameEventDispatch.instance.event(GameEvent.CloseWait);

                }else
                {
                    GameEventDispatch.instance.event(GameEvent.RightWait);
                }
            }

        }

        private function showComplete():void
        {
            Tween.to(_panel, {scaleX: 1, scaleY: 1}, 250);

        }

        //隐藏界面
        public function hide():void
        {
            if (_panel != null)
            {
                if (_panel.visible == true)
                {
                    _panel.visible = false;
                    _panel.unRegister();
                }
            }
        }

        private function showUi():void
        {
            if (_panel != null)
            {
                Tween.to(_panel, {scaleX: 1, scaleY: 1}, 300);

            }
        }

        //移除界面
        public function removie():void
        {
            if (_panel != null)
            {
                _panel.removeSelf();
                _panel.unRegister();

            }
        }

        public function set EffectType(type:String):void
        {
            _type = type;
        }

        public function get EffectType():String
        {
            return _type;
        }

        //调整该界面的层级
        public function setPanelBaseDepth(depth:int):void
        {
            if (_panel != null)
            {

                _panel.zOrder = depth;
            }

        }


    }
}
