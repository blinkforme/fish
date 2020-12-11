package view.pathEditor
{


    import laya.display.Sprite;
    import laya.events.Event;
    import laya.maths.Point;
    import laya.ui.Image;
    import laya.utils.Dictionary;

    import manager.ConfigManager;
    import manager.GameConst;
    import manager.GameTools;
    import manager.ResVo;

    import ui.abbey.PathEditorUI;

    public class PathEditorView extends PathEditorUI implements ResVo
    {
        private var spArr:Array;
        private var _isDown:Boolean = false;
        private var namesArr:Array = ["1", "2", "3", "4", "5"];
        private var aniInfo:Dictionary = new Dictionary();
        private var pointInfo:Dictionary = new Dictionary();
        private var pInfo:Array = new Array();
        private var pArr:Array = [];
        private var k:Number = 0;
        private var imageArr:Array = new Array();
        private var _lineTest:Sprite;
        private var pointThree:Point = new Point();
        private var rectWidth:int = 4;
        private var selectPointIndex:int = -1;
        private var mirrorType:int = 0; //0:未镜像 1:x镜像 2:y镜像 3:xy镜像
        private var maxPoint:Number = 320000;
        private var drawPoint:Number = 120;

        public function PathEditorView()
        {

            super();
        }


        public function StartGames(parm:Object = null):void
        {
            _lineTest = new Sprite();
            this.addChild(_lineTest);
            initData();

            nextBtn.on(Event.CLICK, this, clickNext);
            preBtn.on(Event.CLICK, this, clickPre);

            //drawPath(0);
            //updateData(getPathLength(aniInfo.get(0).angle,k),getControlPoints(aniInfo.get(0).angle,k),aniInfo.get(0).angle);
            //Laya.timer.loop(100,this,start);

            mirrorBtn.on(Event.CLICK, this, mirrorClick);
            uniformBtn.on(Event.CLICK, this, clickUniform);
            this.on(Event.MOUSE_DOWN, this, mouseDown);
            this.on(Event.MOUSE_MOVE, this, mouseMove)
            this.on(Event.MOUSE_UP, this, mouseUp)
            drawPath(0);
            updateData(getControlPoints(aniInfo.get(k).angle, k), aniInfo.get(k).angle, aniInfo.get(k).patharg);
            Laya.timer.loop(100, this, start);


        }

        private function clickUniform():void
        {
            var Length:Number = getPathLength(aniInfo.get(k).angle, k);
            var uniformArray:Array = getTickT(Length, aniInfo.get(k).angle, k);
            cureLength.text = "" + Length;
            var str:String = "";
            for (var i:int = 0; i < uniformArray.length; i++)
            {
                if (i > 0)
                {
                    str += ", " + getNumFun(uniformArray[i], 4);
                }
                else
                {
                    str += getNumFun(uniformArray[i], 4);
                }
            }
            uniformInfo.text = str;
        }

        private function mirrorClick():void
        {
            mirrorType += 1;
            if (mirrorType > 3)
            {
                mirrorType = 0;
            }
            if (0 == mirrorType)
            {
                mirrorTip.text = "未镜像";
            }
            else if (1 == mirrorType)
            {
                mirrorTip.text = "x镜像";
            }
            else if (2 == mirrorType)
            {
                mirrorTip.text = "y镜像";
            }
            else if (3 == mirrorType)
            {
                mirrorTip.text = "xy镜像";
            }
        }

        private function mouseUp(event:Event):void
        {
            selectPointIndex = -1;
            clickUniform();
        }

        private function mouseDown(event:Event):void
        {
            var i:int = 0;
            var startX:Number = 0;
            var startY:Number = 0;
            var endX:Number = 0;
            var endY:Number = 0;
            selectPointIndex = -1;
            for (i = 0; i < pArr[k].length - 1; i++)
            {
                startX = pArr[k][i].x - rectWidth;
                startY = pArr[k][i].y - rectWidth;
                endX = pArr[k][i].x + rectWidth;
                endY = pArr[k][i].y + rectWidth;
                if (event.stageX >= startX && event.stageX <= endX &&
                        event.stageY >= startY && event.stageY <= endY)
                {
                    selectPointIndex = i;

                    if (selectPointIndex >= 0)
                    {
                        selectPointTip.text = "当前选中点(" + (selectPointIndex + 1) + ", x = " + pArr[k][selectPointIndex].x + ", y = " + pArr[k][selectPointIndex].y;
                    }
                    else
                    {
                        selectPointTip.text = "当前未选中点";
                    }
                    break;
                }
            }
        }

        private function mouseMove(event:Event):void
        {
            if (selectPointIndex >= 0)
            {
                pArr[k][selectPointIndex].x = event.stageX;
                pArr[k][selectPointIndex].y = event.stageY;

                if (selectPointIndex >= 0)
                {
                    selectPointTip.text = "当前选中点(" + (selectPointIndex + 1) + ", x = " + pArr[k][selectPointIndex].x + ", y = " + pArr[k][selectPointIndex].y;
                }
                else
                {
                    selectPointTip.text = "当前未选中点";
                }

            }
        }


        private function start():void
        {
            aniInfo.get(k).angle = parseInt(startAngle.text);
            aniInfo.get(k).patharg = parseFloat(bezierArg.text);
            drawPath(k);
            updateData(getControlPoints(aniInfo.get(k).angle, k), aniInfo.get(k).angle, aniInfo.get(k).patharg);
        }

        private function updateData(array:Array, angle:Number, arg:Number):void
        {
            var str:String = "";
            for (var i:int = 0; i < array.length; i++)
            {
                if (i > 0)
                {
                    str += ", " + getNumFun(array[i], 2);
                }
                else
                {
                    str += getNumFun(array[i], 2);
                }
            }
            var m:int = k + 1;
            //			cureLength.text = getNumFun(length,2)+"";
            beiLength.text = str;
            startAngle.text = angle + "";
            bezierArg.text = arg + "";
            pathtxt.text = "路径ID:" + namesArr[k] + "(" + m + "/" + namesArr.length + ")";
        }

        private function clickPre():void
        {
            if (k > 0)
            {
                k = k - 1
            } else
            {
                k = 14;
            }
            selectPointIndex = -1;
            selectPointTip.text = "当前未选中点";
            drawPath(k);


            updateData(getControlPoints(aniInfo.get(k).angle, k), aniInfo.get(k).angle, aniInfo.get(k).patharg);
            clickUniform();


        }

        private function clickNext():void
        {
            if (k < namesArr.length - 1)
            {
                k = k + 1;
            } else
            {
                k = 0;
            }
            selectPointIndex = -1;
            selectPointTip.text = "当前未选中点";
            drawPath(k);
            updateData(getControlPoints(aniInfo.get(k).angle, k), aniInfo.get(k).angle, aniInfo.get(k).patharg);
            clickUniform();
        }

        private function getTickT(totalLen:Number, startAngle:Number, k:int):Array
        {
            var retArray:Array = new Array();
            var time:Number = aniInfo.get(k).time;
            var totalTicks:int = Math.ceil(time / GameConst.fixed_update_time);
            var tickLen:Number = totalLen * GameConst.fixed_update_time / time;
            var varLen:Number = 0;
            var i:int = 0;
            var j:int = 0;
            var deltaX:Number = 0;
            var deltaY:Number = 0;
            var lineAngle:Number = 0;
            var lineCenterPoint:Point = new Point();
            var halfLength:Number = 0;
            var bezierPoint:Point = new Point();
            var pathArg:Number = aniInfo.get(k).patharg;
            var length:Number = 0;
            for (i = 0; i < pArr[k].length - 1; i++)
            {
                var radian:Number = startAngle * Math.PI / 180;
                deltaX = Math.cos(radian);
                deltaY = Math.sin(radian);
                lineAngle = GameTools.CalLineAngle(pArr[k][i], pArr[k][i + 1]);
                lineCenterPoint.x = (pArr[k][i].x + pArr[k][i + 1].x) / 2;
                var deltaAngle:Number = Math.abs(lineAngle - startAngle);
                halfLength = GameTools.CalPointLen(pArr[k][i], pArr[k][i + 1]) / 2;
                length = halfLength * 2 * pathArg;
                bezierPoint.x = pArr[k][i].x + deltaX * length;
                bezierPoint.y = pArr[k][i].y + deltaY * length;
                startAngle = GameTools.CalLineAngle(bezierPoint, pArr[k][i + 1]);
                var prex:Number = pArr[k][i].x;
                var prey:Number = pArr[k][i].y;
                for (j = 0; j <= maxPoint; j++)
                {
                    var x:Number = 0;
                    var y:Number = 0;
                    var t:Number = j / maxPoint;
                    var minust:Number = 1 - t;
                    x = minust * minust * pArr[k][i].x +
                            2 * t * minust * bezierPoint.x + t * t * pArr[k][i + 1].x;
                    y = minust * minust * pArr[k][i].y +
                            2 * t * minust * bezierPoint.y + t * t * pArr[k][i + 1].y;
                    varLen += GameTools.CalPointLen(new Point(x, y), new Point(prex, prey));
                    if (varLen >= tickLen)
                    {
                        varLen = 0;
                        retArray.push(t);
                    }
                    prex = x;
                    prey = y;
                }
            }
            if (varLen > 0)
            {
                retArray.push(1);
            }
            return retArray;
        }

        private function getControlPoints(startAngle:Number, k:int):Array
        {
            var retArray:Array = new Array();
            var lineAngle:Number = 0;
            var deltaX:Number = 0;
            var deltaY:Number = 0;
            var i:int = 0;
            var j:int = 0;
            var length:Number = 0;
            var halfLength:Number = 0;
            var lineCenterPoint:Point = new Point();
            var bezierPoint:Point = new Point();
            var pathArg:Number = aniInfo.get(k).patharg;
            for (i = 0; i < pArr[k].length - 1; i++)
            {

                var radian:Number = startAngle * Math.PI / 180;
                deltaX = Math.cos(radian);
                deltaY = Math.sin(radian);
                lineAngle = GameTools.CalLineAngle(pArr[k][i], pArr[k][i + 1]);
                lineCenterPoint.x = (pArr[k][i].x + pArr[k][i + 1].x) / 2;
                var deltaAngle:Number = Math.abs(lineAngle - startAngle);
                {
                    halfLength = GameTools.CalPointLen(pArr[k][i], pArr[k][i + 1]) / 2;
                    length = halfLength * 2 * pathArg;
                    bezierPoint.x = pArr[k][i].x + deltaX * length;
                    bezierPoint.y = pArr[k][i].y + deltaY * length;
                    startAngle = GameTools.CalLineAngle(bezierPoint, pArr[k][i + 1]);
                    var tmpLen:Number = 0;
                    var prex:Number = pArr[k][i].x;
                    var prey:Number = pArr[k][i].y;
                    for (j = 0; j <= drawPoint; j++)
                    {
                        var x:Number = 0;
                        var y:Number = 0;
                        var t:Number = j / drawPoint;
                        var minust:Number = 1 - t;
                        x = minust * minust * pArr[k][i].x +
                                2 * t * minust * bezierPoint.x + t * t * pArr[k][i + 1].x;
                        y = minust * minust * pArr[k][i].y +
                                2 * t * minust * bezierPoint.y + t * t * pArr[k][i + 1].y;
                        tmpLen += GameTools.CalPointLen(new Point(x, y), new Point(prex, prey));
                        prex = x;
                        prey = y;
                    }
                    retArray.push(bezierPoint.x, bezierPoint.y, tmpLen);
                }
            }

            return retArray;
        }

        private function getPathLength(startAngle:Number, k:int):Number
        {
            var lineAngle:Number = 0;
            var deltaX:Number = 0;
            var deltaY:Number = 0;
            var i:int = 0;
            var j:int = 0;
            var length:Number = 0;
            var halfLength:Number = 0;
            var lineCenterPoint:Point = new Point();
            var bezierPoint:Point = new Point();
            var tmpLen:Number = 0;
            var pathArg:Number = aniInfo.get(k).patharg;
            for (i = 0; i < pArr[k].length - 1; i++)
            {

                var radian:Number = startAngle * Math.PI / 180;
                deltaX = Math.cos(radian);
                deltaY = Math.sin(radian);
                lineAngle = GameTools.CalLineAngle(pArr[k][i], pArr[k][i + 1]);
                lineCenterPoint.x = (pArr[k][i].x + pArr[k][i + 1].x) / 2;
                var deltaAngle:Number = Math.abs(lineAngle - startAngle);
                {
                    halfLength = GameTools.CalPointLen(pArr[k][i], pArr[k][i + 1]) / 2;
                    //					length = halfLength / Math.cos(deltaAngle * Math.PI / 180);
                    //					bezierPoint.x = pArr[k][i].x + deltaX * length;
                    //					bezierPoint.y = pArr[k][i].y + deltaY * length;

                    length = halfLength * 2 * pathArg;
                    bezierPoint.x = pArr[k][i].x + deltaX * length;
                    bezierPoint.y = pArr[k][i].y + deltaY * length;

                    startAngle = GameTools.CalLineAngle(bezierPoint, pArr[k][i + 1]);

                    var prex:Number = pArr[k][i].x;
                    var prey:Number = pArr[k][i].y;
                    for (j = 0; j <= maxPoint; j++)
                    {
                        var x:Number = 0;
                        var y:Number = 0;
                        var t:Number = j / maxPoint;
                        var minust:Number = 1 - t;
                        x = minust * minust * pArr[k][i].x +
                                2 * t * minust * bezierPoint.x + t * t * pArr[k][i + 1].x;
                        y = minust * minust * pArr[k][i].y +
                                2 * t * minust * bezierPoint.y + t * t * pArr[k][i + 1].y;
                        tmpLen += GameTools.CalPointLen(new Point(x, y), new Point(prex, prey));
                        prex = x;
                        prey = y;
                    }
                }
            }


            return tmpLen;
        }

        private function drawPath(k:int):void
        {
            var drawPointNum:int = 0;
            var startAngle:Number = aniInfo.get(k).angle;
            var pathArg:Number = aniInfo.get(k).patharg;
            var lineAngle:Number = 0;
            var deltaX:Number = 0;
            var deltaY:Number = 0;
            var i:int = 0;
            var j:int = 0;
            var length:Number = 0;
            var halfLength:Number = 0;
            var lineCenterPoint:Point = new Point();
            var bezierPoint:Point = new Point();
            _lineTest.graphics.clear();
            for (i = 0; i < pArr[k].length; i++)
            {
                _lineTest.graphics.drawRect(pArr[k][i].x - 3, pArr[k][i].y - 3, 6, 6, "#ff0000");
            }
            for (i = 0; i < pArr[k].length - 1; i++)
            {
                var radian:Number = startAngle * Math.PI / 180;
                deltaX = Math.cos(radian);
                deltaY = Math.sin(radian);
                lineAngle = GameTools.CalLineAngle(pArr[k][i], pArr[k][i + 1]);
                lineCenterPoint.x = (pArr[k][i].x + pArr[k][i + 1].x) / 2;
                var deltaAngle:Number = Math.abs(lineAngle - startAngle);
                //				if(deltaAngle < 90)
                {
                    halfLength = GameTools.CalPointLen(pArr[k][i], pArr[k][i + 1]) / 2;

                    //length = halfLength / Math.cos(deltaAngle * Math.PI / 180);
                    length = halfLength * 2 * pathArg;
                    bezierPoint.x = pArr[k][i].x + deltaX * length;
                    bezierPoint.y = pArr[k][i].y + deltaY * length;

                    //					var tmpdeltaX:Number = bezierPoint.x - pArr[k][i].x;
                    //					var tmpdeltaY:Number = bezierPoint.y - pArr[k][i].y;
                    //					if(tmpdeltaX * deltaX <= 0 && tmpdeltaY * deltaY <= 0)
                    //					{
                    //						bezierPoint.x = bezierPoint.x + (lineCenterPoint.x - bezierPoint.x) * 2;
                    //						bezierPoint.y = bezierPoint.y + (lineCenterPoint.y - bezierPoint.y) * 2;
                    //					}


                    startAngle = GameTools.CalLineAngle(bezierPoint, pArr[k][i + 1]);

                    for (j = 0; j <= drawPoint; j++)
                    {
                        var x:Number = 0;
                        var y:Number = 0;
                        var t:Number = j / drawPoint;
                        var minust:Number = 1 - t;
                        x = minust * minust * pArr[k][i].x +
                                2 * t * minust * bezierPoint.x + t * t * pArr[k][i + 1].x;
                        y = minust * minust * pArr[k][i].y +
                                2 * t * minust * bezierPoint.y + t * t * pArr[k][i + 1].y;
                        if (1 === mirrorType)
                        {
                            x = x + (Laya.stage.width / 2 - x) * 2;
                        }
                        else if (2 === mirrorType)
                        {
                            y = y + (Laya.stage.height / 2 - y) * 2;
                        }
                        else if (3 === mirrorType)
                        {
                            x = x + (Laya.stage.width / 2 - x) * 2;
                            y = y + (Laya.stage.height / 2 - y) * 2;
                        }

                        if (i > 3 || j > (maxPoint / 2))
                        {
                            _lineTest.graphics.drawRect(x - rectWidth / 2, y - rectWidth / 2, rectWidth, rectWidth, "#00ff00");
                        }
                        else
                        {
                            _lineTest.graphics.drawRect(x - rectWidth / 2, y - rectWidth / 2, rectWidth, rectWidth, "#ff0000");
                        }

                    }
                }
                //				else
                //				{
                //				}
            }
            for (i = 0; i < pArr[k].length; i++)
            {
                if (i == selectPointIndex)
                {
                    _lineTest.graphics.drawRect(pArr[k][i].x - rectWidth, pArr[k][i].y - rectWidth, rectWidth * 2, rectWidth * 2, "#0000ff");
                }
                else
                {
                    _lineTest.graphics.drawRect(pArr[k][i].x - rectWidth, pArr[k][i].y - rectWidth, rectWidth * 2, rectWidth * 2, "#ff0000");
                }
            }

        }


        private function initData():void
        {
            var index:int = 0;
            var i:int = 0;
            namesArr = [];
            var sheet:Object = ConfigManager.getConfBySheet("cfg_fishgrouppath");//ConfigManager.getConfObject("cfg_fishgrouppath",namesArr[i]);
            for (var id in sheet)
            {
                namesArr[index++] = "" + parseInt(id);
            }

            for (i = 0; i < namesArr.length; i++)
            {
                var data:Object = ConfigManager.getConfObject("cfg_fishgrouppath", namesArr[i]);

                aniInfo.set(i, data);
            }

            for (i = 0; i < namesArr.length; i++)
            {
                var arr:Array = aniInfo.get(i).path;
                pInfo.push(arr);
            }

            for (var j:int = 0; j < pInfo.length; j++)
            {
                var pointArr:Array = new Array();
                for (var k:int = 0; k < pInfo[j].length; k += 2)
                {
                    var point:Point = new Point(pInfo[j][k], pInfo[j][k + 1]);
                    pointArr.push(point);
                }
                pArr.push(pointArr);
            }
        }


        public function drawCure(points:Array):void
        {
            var sp:Sprite = new Sprite();
            var len:Number = points.length;
            if (len < 3)
            {
                return
            }
            var ctrlX = 2 * points[1].x - 0.5 * (points[0].x + points[2].x);
            var ctrlY = 2 * points[1].y - 0.5 * (points[0].y + points[2].y);
            sp.graphics.drawCurves(points[0].x, points[0].y, [0, 0, ctrlX - points[0].x, ctrlY - points[0].y, points[2].x - points[0].x, points[2].y - points[0].y], "#ffffff", 3);
            if (len == 3)
            {
                return;
            }
            for (var i = 2; i < len - 1; i++)
            {
                ctrlX = 2 * points[i].x - ctrlX;
                ctrlY = 2 * points[i].y - ctrlY;
                sp.graphics.drawCurves(points[i].x, points[i].y, [0, 0, ctrlX - points[i].x, ctrlY - points[i].y, points[i + 1].x - points[i].x, points[i + 1].y - points[i].y], "#ffffff", 3);
            }
            this.addChild(sp);

        }

        private function upImage(image:Image, event:Event):void
        {
            event.stopPropagation();


        }


        private function clicksp():void
        {


        }

        private function upPanel(event:Event):void
        {


        }

        private function moviePanel():void
        {


        }

        private function getNumFun(n:Number, count:int):Number
        {
            var dis:int = Math.pow(10, count);
            n = Math.round(n * dis) / dis;
            return n;
        }


        public function register():void
        {

        }

        public function unRegister():void
        {

        }
    }
}
