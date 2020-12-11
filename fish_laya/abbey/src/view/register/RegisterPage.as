package view.register
{
    import model.RegiM;
    import model.RoleInfoM;

    import laya.events.Event;
    import laya.ui.Box;

    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;
    import manager.WebSocketManager;

    import proto.C2s_20002;

    import ui.abbey.RegisterPageUI;

    public class RegisterPage extends RegisterPageUI implements ResVo
    {
        private var box:Box;
        private var c2s:C2s_20002;
        private var arr:Array;
        private var imageUrl:String;
        private var goodsId:Number;
        private var count:Number;
        private var _startX:Number = 0;
        private var _startY:Number = 0;

        public function RegisterPage()
        {
            super();
        }

        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;
            _startX = this.x;
            _startY = this.y;
            m_list.array = RegiM.instance.infoList;
            //m_list.mouseHandler = new Handler(this,onSelect);
            this.on(Event.CLICK, this, clickPanel);
            closeBtn.on(Event.CLICK, this, clickClose);
            c2s = new C2s_20002();
            screenResize();
            bmask.on(Event.CLICK, this, clickMask);


        }

        private function clickMask():void
        {


        }

        private function screenResize():void
        {
            bmask.width = Laya.stage.width * 2;
            bmask.height = Laya.stage.height * 2;
            closeBtn.left = 5;
            closeBtn.top = 5;
            this.size(Laya.stage.width, Laya.stage.height);
        }

        private function clickPanel():void
        {
            arr = RegiM.instance.idArr;
            for (var i:int = 0; i < arr.length; i++)
            {
                if (RoleInfoM.instance.getSignInStatus(arr[i]) == GameConst.sign_in_getting)
                {
                    //imageUrl = RegiM.instance.url(index+1);
                    c2s.day = parseInt(arr[i]);
                    WebSocketManager.instance.send(20002, c2s);
                    break;
                }
            }
            if (ENV.isNeedCertification())
            {
                GameEventDispatch.instance.event(GameEvent.CloseRegisterPage);
            }
    }

    private function roleCreateRet(data:*):void
    {
        if (data.code == 0)
        {
            goodsId = data.goods
            count = data.num

            //imageUrl = RegiM.instance.url(data.day);
            Laya.timer.once(200, this, start);
        } else if (data.code == 1)
        {
            GameEventDispatch.instance.event(GameEvent.MsgTip, 29);
        } else if (data.code == 2)
        {
            GameEventDispatch.instance.event(GameEvent.MsgTip, 30);
        } else if (data.code == 3)
        {
            GameEventDispatch.instance.event(GameEvent.MsgTip, 31);
        }

    }

    private function signUpdate(data:*):void
    {
        m_list.array = RegiM.instance.infoList;
        //Laya.timer.once(200,this,start);

    }

    private function start():void
    {
        if (RegiM.instance.isGet)
        {

        } else
        {
            UiManager.instance.closePanel("Register", true);
            GameEventDispatch.instance.event(GameEvent.RewardTip, [[goodsId], [count]]);
            GameEventDispatch.instance.event(GameEvent.Regic);
        }
    }

    private function clickClose():void
    {
        UiManager.instance.closePanel("Register", true)
    }

    private function onSelect(e:Event, index:int):void
    {
        if (e.type == Event.CLICK)
        {
            //var box:Box = m_list.getItem(index) as Box;
            //box.getChildByName("");
            arr = RegiM.instance.idArr;
            if (RoleInfoM.instance.getSignInStatus(arr[index]) == GameConst.sign_in_getting)
            {
                //imageUrl = RegiM.instance.url(index+1);
                c2s.day = index + 1;
                WebSocketManager.instance.send(20002, c2s);
            }
            //GameEventDispatch.instance.on(String(20002),this,reveice);
        }

    }


    private function reveice(data:*):void
    {


    }

    public function get infoList():Array
    {
        var arr:Array = [];
        for (var i:int = 0; i < 50; i++)
        {
            arr.push({txt: {text: i}});
        }
        return arr;
    }

    public function register():void
    {
        GameEventDispatch.instance.on(GameEvent.SignInUpdate, this, signUpdate);
        GameEventDispatch.instance.on(String(20003), this, roleCreateRet);
        GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
    }

    public function unRegister():void
    {
        GameEventDispatch.instance.off(GameEvent.SignInUpdate, this, signUpdate);
        GameEventDispatch.instance.off(String(20003), this, roleCreateRet);
        GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
    }
}
}
