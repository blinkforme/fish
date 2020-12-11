package view.testImpact
{
    import conf.cfg_anicollision;

    import laya.display.Animation;
    import laya.display.Sprite;
    import laya.events.Event;
    import laya.maths.Point;
    import laya.ui.Image;

    import manager.AnimalManger;
    import manager.ConfigManager;
    import manager.GameConst;
    import manager.ResVo;
    import manager.SpineTemplet;
    import manager.UiManager;

    import model.WxM;

    import ui.abbey.testImapctUI;

    public class ImpactVIew extends testImapctUI implements ResVo
    {
        private var _sp:Sprite;
        private var _ani:Animation;
        private var _skeletonAni:SpineTemplet;
        private var _aniType:int;
        private var w:Number;
        private var h:Number;
        private var x:Number;
        private var y:Number;
        private var data:Object;
        private var sp:Sprite;
        private var dx:Number;
        private var dy:Number;
        private var i:int = 1;
        private var id:int = 1;
        private var pX:Number;
        private var pY:Number;
        private var speed:Number;
        private var s:Sprite;
        private var endAngle:Number = -90;
        private var point1:Point;
        private var point2:Point;
        private var point3:Point;
        private var spp:Sprite;
        private var _par:Array;
        private var spppp:Sprite;

        private var aniNames:Array = [
                "linjiang"
        ];

        private var aniInfo:Object = new Object();

        public function ImpactVIew()
        {
            super();
        }

        public function StartGames(parm:Object = null):void
        {
            point1 = new Point(500, 500);
            point2 = new Point(450, 450);
            point3 = new Point(400, 500);
            money.x = point1.x;
            money.y = point1.y;
            spp = new Sprite();
            this.addChild(spp);
            drawCircle(point1);
            i = 1;
            initData();
            updateData(null, i);
            var sprite:Sprite = new Sprite();
            this.addChild(sprite);
            sprite.zOrder = 100;
            sprite.graphics.drawRect(Laya.stage.width / 2 - 2, Laya.stage.height / 2 - 2, 4, 4, "#ff0000");
            initEvent();
            initView();
            skill.x = 500;
            skill.y = 500;
            skill.width = 84;
            skill.height = 84;
            skill.skin = WxM.instance.imageUrl;
            drawMask(10, skill);
            //drawRoationRect();


        }

        //测试粒子
        private function test():void
        {

        }

        private function drawCircle(pointOne:Point):void
        {
            spp.graphics.drawCurves(pointOne.x, pointOne.y, [0, 0, -100, -150, -200, 0], "#ff0000", 3);


        }


        private function drawRoationRect():void
        {
            spp = new Sprite();
            var path:Array = [
                ["moveTo", 30, 0], //画笔的起始点，
                ["arcTo", skill.width, 0, skill.width, 30, 30], //p1（500,0）为夹角B，（500,30）为端点p2
                ["arcTo", 500, 300, 470, 300, 30],//p1（500,300）为夹角C，（470,300）为端点p2
                ["arcTo", 0, 300, 0, 270, 30], //p1(0,300)为夹角D，（0,270）为端点p2
                ["arcTo", 0, 0, 30, 0, 30],//p1(0,0)为夹角A，（30,0）为端点p2
            ];
            spp.graphics.drawPath(0, 0, path, {fillStyle: "#ff0000"});
            this.addChild(spp);
            skill.mask = spp;
        }


        private function drawMask(r:Number, img:Image):void
        {
            spp = new Sprite();
            var path:Array = [
                ["moveTo", r, 0], //画笔的起始点，
                ["arcTo", img.width, 0, img.width, r, r], //p1（500,0）为夹角B，（500,30）为端点p2
                ["arcTo", img.width, img.height, img.width - r, img.height, r],//p1（500,300）为夹角C，（470,300）为端点p2
                ["arcTo", 0, img.height, 0, img.height - r, r], //p1(0,300)为夹角D，（0,270）为端点p2
                ["arcTo", 0, 0, r, 0, r],//p1(0,0)为夹角A，（30,0）为端点p2
            ];
            spp.graphics.drawPath(0, 0, path, {fillStyle: "#ff0000"});
            this.addChild(spp);
            img.mask = spp;
        }


        private function initView():void
        {
            s = new Sprite();
            //s.graphics.drawCircle(0,0,50,"#ff0000");
            s.x = zhuan.width / 2;
            s.y = zhuan.height / 2;
            //	this.addChild(s);
            zhuan.mask = s;
            Laya.timer.loop(100, this, start);


        }

        private function start():void
        {
            endAngle = endAngle + 10;
            s.graphics.clear();
            s.graphics.drawPie(0, 0, 50, endAngle, 270, "#88ee1a");
        }

        public function roate(everyTime:Number, startEngle:Number):void
        {
            Laya.timer.loop(everyTime, this, startRoate);
        }

        private function startRoate():void
        {
            endAngle = endAngle + 10;
            s.graphics.clear();
            s.graphics.drawPie(0, 0, 50, endAngle, 270, "#88ee1a");

        }


        public function get facton():Number
        {
            return null;
        }


        private function initData():void
        {
            for (var i:int = 1; i <= aniNames.length; i++)
            {
                var data:Object = ConfigManager.getConfObject("cfg_anicollision", aniNames[i - 1])
                aniInfo[i + ""] = data;
            }
        }

        private function initEvent():void
        {
            btnOne.on(Event.CLICK, this, clickOne);
            btnTwo.on(Event.CLICK, this, clickTwo);
            btnThree.on(Event.CLICK, this, clickThree);
            btnFour.on(Event.CLICK, this, clickFour);
            btnFive.on(Event.CLICK, this, clickFive);
            btnSix.on(Event.CLICK, this, clickSix);
            Laya.timer.loop(500, this, clickCarry);
            nextBtn.on(Event.CLICK, this, nextFish);
            preBtn.on(Event.CLICK, this, preFish);
            //carrayBtn.on(Event.CLICK,this,start);
            closeBtn.on(Event.CLICK, this, clickClose);
            //resetBtn.on(Event.CLICK,this,click);

        }


        private function clickClose():void
        {
            UiManager.closeView(ImpactVIew);


        }


        private function clickSix():void
        {
            id = 6;
            updateRecen(aniInfo[i].colliOffsetX6, aniInfo[i].colliOffsetY6, aniInfo[i].colliWidth6, aniInfo[i].colliHeight6, "动画区域");

        }

        private function preFish():void
        {
            i = i - 1;
            if (i == 0)
            {
                i = aniNames.length;
            }

            updateData(data, i);

        }

        private function nextFish():void
        {
            i = i + 1;
            if (i == aniNames.length + 1)
            {
                i = 1;
            }
            updateData(data, i);
        }

        private function updateData(data:Object, i:int):void
        {

            if (_sp != null)
            {
                _sp.graphics.clear();
                this.removeChild(_ani);
                this.removeChild(_sp);
                _ani = null;
                _sp = null
            }
            var cfg_ani:cfg_anicollision = cfg_anicollision.instance(aniNames[i - 1]);
            _aniType = cfg_ani.aniType;

            _sp = new Sprite();
            if (GameConst.ani_type_frame == _aniType)
            {
                _ani = AnimalManger.instance.load(aniNames[i - 1]);
                _ani.interval = aniInfo[i].aniSpeed;
                _ani.x = Laya.stage.width / 2;
                _ani.y = Laya.stage.height / 2;
                _ani.pivot(aniInfo[i].pivotX, aniInfo[i].pivotY);
                _ani.play(0, true);
            }
            else
            {
                _skeletonAni = new SpineTemplet(aniNames[i - 1]);
                _skeletonAni.pos(Laya.stage.width / 2, Laya.stage.height / 2);
                _skeletonAni.setPivot(aniInfo[i].pivotX, aniInfo[i].pivotY);
                _skeletonAni.play(0, true);
            }

            if (_ani)
            {
                _ani.visible = GameConst.ani_type_frame == _aniType
            }
            if (_skeletonAni)
            {
                _skeletonAni.visible = GameConst.ani_type_skeleton == _aniType;
            }

            //if9)
            //ColorFilter.


            //	_ani.pivot(aniInfo.get(i).pivotX,aniInfo.get(i).pivotY);
            updateAniTxt(i);
            txtw.text = aniInfo[i].colliWidth1;
            txth.text = aniInfo[i].colliHeight1;
            txtx.text = aniInfo[i].colliOffsetX1;
            txty.text = aniInfo[i].colliOffsetY1;
            txtCenterX.text = aniInfo[i].pivotX;
            txtCenterY.text = aniInfo[i].pivotY;
            aniSpeed.text = aniInfo[i].aniSpeed;
            //updateRecen(aniInfo.get(i).colliOffsetX1,aniInfo.get(i).colliOffsetY1,aniInfo.get(i).colliWidth1,aniInfo.get(i).colliHeight1,"矩形一");
            txt.text = "矩形一"
            if (GameConst.ani_type_frame == _aniType)
            {
                this.addChild(_ani);
            }
            else
            {
                this.addChild(_skeletonAni);
            }


            this.addChild(_sp);

        }

        private function clickSwitch():void
        {
            updateData(data, i);
            i = i + 1
            if (i == 4)
            {
                i = 0;
            }

        }

        private function updateAniTxt(i:int):void
        {
            aniTxt.text = aniNames[i - 1];
        }


        private function clickCarry():void
        {
            w = parseFloat(txtw.text);   //txtw.text;
            h = parseFloat(txth.text);
            x = parseFloat(txtx.text);
            y = parseFloat(txty.text);
            pX = parseFloat(txtCenterX.text);
            pY = parseFloat(txtCenterY.text);
            speed = parseFloat(aniSpeed.text);
            update(id);

            if (GameConst.ani_type_frame == _aniType)
            {
                _ani.pivot(pX, pY);
                _ani.interval = speed;
            }
            else
            {
                _skeletonAni.setPivot(pX, pY);
            }


            aniInfo[i].aniSpeed = speed;
            aniInfo[i].pivotX = pX;
            aniInfo[i].pivotY = pY;
            dx = x + stage.width / 2 - w;
            dy = y + stage.height / 2 - h;
            _sp.graphics.clear();
            _sp.graphics.drawRect(dx, dy, w * 2, h * 2, null, "#ffffff");
        }

        private function clickFive():void
        {
            id = 5;
            updateRecen(aniInfo[i].colliOffsetX5, aniInfo[i].colliOffsetY5, aniInfo[i].colliWidth5, aniInfo[i].colliHeight5, "矩形五");

        }

        private function updateRecen(x:Number, y:Number, width:Number, height:Number, name:String):void
        {
            txth.text = height + "";
            txtw.text = width + "";
            txtx.text = x + "";
            txty.text = y + "";
            txt.text = name + "";
            dx = x + stage.width / 2 - _ani.width;
            dy = y + stage.height / 2 - _ani.height;
            _sp.graphics.clear();
            _sp.graphics.drawRect(dx, dy, width * 2, height * 2, null, "#ffffff");
        }

        private function clickFour():void
        {
            id = 4;
            updateRecen(aniInfo[i].colliOffsetX4, aniInfo[i].colliOffsetY4, aniInfo[i].colliWidth4, aniInfo[i].colliHeight4, "矩形四");
        }

        private function clickThree():void
        {
            id = 3;
            updateRecen(aniInfo[i].colliOffsetX3, aniInfo[i].colliOffsetY3, aniInfo[i].colliWidth3, aniInfo[i].colliHeight3, "矩形三");
        }

        private function clickTwo():void
        {
            id = 2;
            updateRecen(aniInfo[i].colliOffsetX2, aniInfo[i].colliOffsetY2, aniInfo[i].colliWidth2, aniInfo[i].colliHeight2, "矩形二");

        }

        private function clickOne():void
        {
            Laya.Browser.window.location = "https://www.baidu.com/";
            //window.open("https://www.baidu.com///")
            __JS__("window.open('https://www.baidu.com/')");


            //id =1;
            //updateRecen(aniInfo.get(i).colliOffsetX1,aniInfo.get(i).colliOffsetY1,aniInfo.get(i).colliWidth1,aniInfo.get(i).colliHeight1,"矩形一");
        }

        private function update(id:int):void
        {
            switch (id)
            {
                case 1:
                {
                    aniInfo[i].colliOffsetX1 = x;
                    aniInfo[i].colliOffsetY1 = y;
                    aniInfo[i].colliWidth1 = w;
                    aniInfo[i].colliHeight1 = h;

                    break;
                }
                case 2:
                {
                    aniInfo[i].colliOffsetX2 = x;
                    aniInfo[i].colliOffsetY2 = y;
                    aniInfo[i].colliWidth2 = w;
                    aniInfo[i].colliHeight2 = h;
                    break;
                }
                case 3:
                {
                    aniInfo[i].colliOffsetX3 = x;
                    aniInfo[i].colliOffsetY3 = y;
                    aniInfo[i].colliWidth3 = w;
                    aniInfo[i].colliHeight3 = h;
                    break;
                }
                case 4:
                {
                    aniInfo[i].colliOffsetX4 = x;
                    aniInfo[i].colliOffsetY4 = y;
                    aniInfo[i].colliWidth4 = w;
                    aniInfo[i].colliHeight4 = h;
                    break;

                }
                case 5:
                {
                    aniInfo[i].colliOffsetX5 = x;
                    aniInfo[i].colliOffsetY5 = y;
                    aniInfo[i].colliWidth5 = w;
                    aniInfo[i].colliHeight5 = h;
                    break;
                }
                case 6:
                {
                    aniInfo[i].colliOffsetX6 = x;
                    aniInfo[i].colliOffsetY6 = y;
                    aniInfo[i].colliWidth6 = w;
                    aniInfo[i].colliHeight6 = h;
                    break;
                }

                default:
                {
                    break;
                }
            }
        }


        private function initMouseEvent():void
        {
            this.on(Event.MOUSE_OUT, this, startEvent);
        }

        private function startEvent():void
        {


        }


        public function register():void
        {

        }


        public function unRegister():void
        {

        }

    }
}
