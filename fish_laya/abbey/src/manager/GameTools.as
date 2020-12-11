package manager
{
    import conf.cfg_code;

    import control.WxC;

    import engine.tool.StartParam;

    import laya.display.Sprite;
    import laya.maths.Point;
    import laya.ui.FontClip;
    import laya.utils.Browser;
    import laya.utils.Handler;
    import laya.utils.Tween;

    public class GameTools
    {

        private static var _designPosDivideScreenPosWidth:Number = 1;
        private static var _designPosDivideScreenPosHeight:Number = 1;
        private static var _screenPosDivideDesignPosWidth:Number = 1;
        private static var _screenPosDivideDesignPosHeight:Number = 1;

        public static var iphoneXOffset:Number = 70;

        public static function screenResize():void
        {
            _screenPosDivideDesignPosWidth = Laya.stage.width / GameConst.design_width;
            _screenPosDivideDesignPosHeight = Laya.stage.height / GameConst.design_height;
            _designPosDivideScreenPosWidth = GameConst.design_width / Laya.stage.width;
            _designPosDivideScreenPosHeight = GameConst.design_height / Laya.stage.height;
        }

        public static function sendHideKeyboard():void
        {
            Browser.window.top.postMessage("hide_keyboard", "*");
        }

        //设置图字
        public static function clipTxt(fontClip:FontClip, txt:String, color:String):void
        {
            if (color == GameConst.font_red)
            {
                fontClip.skin = "font/word_red.png"
                fontClip.sheet = GameConst.font_red_sheet
            } else if (color == GameConst.font_green)
            {
                fontClip.skin = "font/word_green.png"
                fontClip.sheet = GameConst.font_green_sheet
            }
            fontClip.align = "center"
            fontClip.value = txt
        }

        public static function copyText(txt:String):void
        {
            if (WxC.isInMiniGame())
            {
                WxC.wx_set_clipboard_data(txt);
            } else
            {
                var oInput = Browser.document.createElement('input');
                oInput.setAttribute("readonly", "readonly");
                oInput.value = txt;
                Browser.document.body.appendChild(oInput);
                oInput.select(); // 选择对象
                if (Browser.document.execCommand("Copy"))
                {
                    Browser.document.execCommand("Copy");
                }
                oInput.style.display = 'none'; // 将input隐藏
                oInput.remove(); // 将input销毁
            }
        }

        public static function showTip(txt:String):void
        {
            GameEventDispatch.instance.event(GameEvent.MsgTipContent, txt);
        }

        public static function getCurTs():Number
        {
            var now:Number = new Date().getTime() as Number

            var now_time:Number = Math.floor((now / 1000));
            return now_time
        }

        public static function copyToClipboard(text:String):void
        {
            __JS__("copyToClipboard")(text)
        }

        public static function designPosMapScreenPos(pos:Point):void
        {
            pos.x = _screenPosDivideDesignPosWidth * pos.x;
            pos.y = _screenPosDivideDesignPosHeight * pos.y;
        }

        public static function designPosXMapScreenPosX(x:Number):Number
        {
            return _screenPosDivideDesignPosWidth * x;
        }

        public static function designPosYMapScreenPosY(y:Number):Number
        {
            return _screenPosDivideDesignPosHeight * y;
        }

        public static function screenPosXMapDesignPosX(x:Number):Number
        {
            return _designPosDivideScreenPosWidth * x;
        }

        public static function screenPosYMapDesignPosY(y:Number):Number
        {
            return _designPosDivideScreenPosHeight * y;
        }

        public static function getRandomNumber(min:int, max:int):int
        {
            var ret:int = min + Math.floor(Math.random() * (max - min + 1));

            if (ret > max)
            {
                return max;
            }
            return ret;
        }

        public static function getMinus1_1():Number
        {
            return Math.random() * 2 - 1;
        }

        private static var _sqrtDic:Array = [];
        private static var _acosAngleDic:Array = [];
        private static var _sinAngleDic:Array = [];
        private static var _cosAngleDic:Array = [];

        public static function CalSinCosSheet():void
        {
            for (var i:int = 0; i < 36000; i++)
            {
                _sinAngleDic[i] = Math.sin((i / 100) * Math.PI / 180);
                _cosAngleDic[i] = Math.cos((i / 100) * Math.PI / 180)
            }
        }

        public static function CalSinBySheet(angle:Number):Number
        {
            if (angle < 0)
            {
                angle += 360;
            } else if (angle >= 360)
            {
                angle -= 360;
            }
            angle = Math.ceil(angle * 100);
            return _sinAngleDic[angle];
        }

        public static function CalCosBySheet(angle:Number):Number
        {
            if (angle < 0)
            {
                angle += 360;
            } else if (angle >= 360)
            {
                angle -= 360;
            }
            angle = Math.ceil(angle * 100);
            return _cosAngleDic[angle];
        }

        public static function CalAcosSheet():void
        {
            for (var i:int = -10000; i <= 10000; i++)
            {
                _acosAngleDic[i + 10000] = Math.acos(i / 10000) * (180 / Math.PI);
            }
        }

        public static function CalAngleByAcos(acos:Number):Number
        {
            var tmp:int = Math.floor(acos * 10000 + 10000);
            return _acosAngleDic[tmp];
        }

        public static function CalSqrtSheet():void
        {
            for (var i:int = 0; i <= 2000000; i++)
            {
                _sqrtDic[i] = Math.sqrt(i);
            }
        }

        public static function CalSqrtBySheet(deltaX:Number, deltaY:Number):Number
        {
            var powLen:Number = deltaX * deltaX + deltaY * deltaY;
            var rate:Number = 1;
            if (powLen <= 0)
            {
                return 0;
            }
            if (powLen < 1)
            {
                rate = 2000000;
            } else if (powLen < 10)
            {
                rate = 200000;
            } else if (powLen < 100)
            {
                rate = 20000;
            } else if (powLen < 1000)
            {
                rate = 2000;
            } else if (powLen < 10000)
            {
                rate = 200;
            } else if (powLen < 100000)
            {
                rate = 20;
            }

            powLen = Math.floor(powLen * rate);

            if (_sqrtDic[powLen])
            {
                return _sqrtDic[powLen] / _sqrtDic[rate];
            }

            return Math.sqrt(powLen);
        }

        public static function CalAngleByDelta(deltaX:Number, deltaY:Number):Number
        {
            var length:Number = CalSqrtBySheet(deltaX, deltaY);
            if (length < 0)
            {
                return 0;
            }
            var cos:Number = deltaX / length;

            return 0;
        }

        public static function CalLineAngle(startPos:Point, endPos:Point):Number
        {
            //        var deltaX:Number = endPos.x - startPos.x;
            //        var deltaY:Number = endPos.y - startPos.y;
            //        var length:Number = Math.sqrt(deltaX * deltaX + deltaY * deltaY);
            //        if (length <= 0) {
            //            return 0;
            //        }
            //        var cos:Number = deltaX / length;
            //        var radian:Number = Math.acos(cos);
            //        var angle:Number = radian * (180 / Math.PI);
            //        if (deltaY < 0) {
            //            angle = 360 - angle;
            //        }
            //        else if ((deltaY === 0) && (deltaX < 0)) {
            //            angle = 180;
            //        }

            var deltaX:Number = endPos.x - startPos.x;
            var deltaY:Number = endPos.y - startPos.y;
            if ((deltaY === 0) && (deltaX < 0))
            {
                return 180;
            }

            var length:Number = CalSqrtBySheet(deltaX, deltaY);//Math.sqrt(deltaX * deltaX + deltaY * deltaY);//CalSqrtBySheet(deltaX, deltaY);
            if (length <= 0)
            {
                return 0;
            }
            var cos:Number = deltaX / length;

            if (cos < -1)
            {
                cos = -1;
            } else if (cos > 1)
            {
                cos = 1;
            }
            var angle:Number = CalAngleByAcos(cos);

            if (deltaY < 0)
            {
                angle = 360 - angle;
            }

            return angle;
        }

        public static function CalLineAngleP4(startX:Number, startY:Number, endX:Number, endY:Number):Number
        {
            //		var deltaX:Number = endX - startX;
            //		var deltaY:Number = endY - startY;
            //		var length:Number = Math.sqrt(deltaX * deltaX + deltaY * deltaY);
            //		if (length <= 0) {
            //			return 0;
            //		}
            //		var cos:Number = deltaX / length;
            //		var radian:Number = Math.acos(cos);
            //		var angle:Number = radian * (180 / Math.PI);
            //		if (deltaY < 0) {
            //			angle = 360 - angle;
            //		}
            //		else if ((deltaY === 0) && (deltaX < 0)) {
            //			angle = 180;
            //		}

            var deltaX:Number = endX - startX;
            var deltaY:Number = endY - startY;
            if ((deltaY === 0) && (deltaX < 0))
            {
                return 180;
            }
            var length:Number = CalSqrtBySheet(deltaX, deltaY);//Math.sqrt(deltaX * deltaX + deltaY * deltaY);//CalSqrtBySheet(deltaX, deltaY);
            if (length <= 0)
            {
                return 0;
            }
            var cos:Number = deltaX / length;

            var angle:Number = CalAngleByAcos(cos);
            if (deltaY < 0)
            {
                angle = 360 - angle;
            }

            return angle;
        }

        public static function CalPointLen(startPos:Point, endPos:Point):Number
        {
            //        var deltaX:Number = endPos.x - startPos.x;
            //        var deltaY:Number = endPos.y - startPos.y;
            //        return Math.sqrt(deltaX * deltaX + deltaY * deltaY);
            return CalSqrtBySheet(endPos.x - startPos.x, endPos.y - startPos.y);
        }

        public static function CalPointLenP4(startX:Number, startY:Number, endX:Number, endY:Number):Number
        {
            //		var deltaX:Number = endX - startX;
            //		var deltaY:Number = endY - startY;
            //		return Math.sqrt(deltaX * deltaX + deltaY * deltaY);
            return CalSqrtBySheet(endX - startX, endY - startY);
        }

        public static function CalRotatePos4(center:Point, p1:Point, p3:Point, angle:Number, radius:Number):void
        {
            //        var radian:Number;
            //        if (angle < 0) {
            //            angle += 360;
            //        }
            //        else if (angle >= 360) {
            //            angle -= 360;
            //        }
            //
            //        radian = angle * 3.14159 / 180;
            //        p1.x = Math.cos(radian) * radius;
            //        p1.y = Math.sin(radian) * radius;

            p1.x = CalCosBySheet(angle) * radius;
            p1.y = CalSinBySheet(angle) * radius;

            p3.x = -p1.x;
            p3.y = -p1.y;
            p1.x += center.x;
            p1.y += center.y;
            p3.x += center.x;
            p3.y += center.y;
        }

        private static var _calRotatePosOut:Point = new Point();

        public static function CalRotatePos(angle:Number, radius:Number):Point
        {
            var out:Point = _calRotatePosOut;//new Point();
            //        if (angle > 360) {
            //			trace("angle = " + angle);
            //            angle -= 360;
            //        }
            //        var radian:Number = angle * 3.14159 / 180;
            //        out.x = Math.cos(radian) * radius;
            //        out.y = Math.sin(radian) * radius;

            out.x = CalCosBySheet(angle) * radius;
            out.y = CalSinBySheet(angle) * radius;

            return out;
        }

        public static function CalAngleSinCos(angle:Number, outSin:Number, outCos:Number):void
        {
            var radian:Number = angle * 3.14159 / 180;
            var fishCos:Number = Math.abs(Math.cos(radian));
            var fishSin:Number = Math.abs(Math.sin(radian));
            if (angle > 360)
            {
                fishSin = -fishSin;
            } else if (angle <= 0 || angle >= 270)
            {
            } else if (angle >= 180)
            {
                fishCos = -fishCos;
            } else if (angle >= 90)
            {
                fishCos = -fishCos;
                fishSin = -fishSin;
            } else
            {
                fishSin = -fishSin;
            }
            outSin = fishSin;
            outCos = fishCos;
        }

        public static function calLinePathInitInfoLikeBoss(pos:Point):Number
        {
            var sideRand:Number = Math.random();
            var posRand:Number = Math.random();
            var desRand:Number = Math.random();
            var des_x:Number = 0;
            var des_y:Number = 0;
            var ret:Number = 0;
            var halfHeight:Number = Laya.stage.height / 2;
            pos.y = posRand * Laya.stage.height;
            if (sideRand <= 0.5)
            {
                des_x = Laya.stage.width;
            } else
            {
                pos.x = Laya.stage.width;
            }
            if (posRand <= 0.5)
            {
                des_y = halfHeight + desRand * halfHeight;
            } else
            {
                des_y = desRand * halfHeight;
            }
            ret = GameTools.CalLineAngle(pos, new Point(des_x, des_y));
            return ret;
        }

        public static function calLinePathInitInfoLikeBossP3(pos:Point, minY:Number, maxY:Number):Number
        {
            var sideRand:Number = Math.random();
            var posRand:Number = Math.random();
            var desRand:Number = Math.random();
            var des_x:Number = 0;
            var des_y:Number = 0;
            var ret:Number = 0;
            var height:Number = maxY - minY;
            var halfHeight:Number = height / 2;
            pos.y = posRand * height + minY;
            if (sideRand <= 0.5)
            {
                des_x = Laya.stage.width;
            } else
            {
                pos.x = Laya.stage.width;
            }
            if (posRand <= 0.5)
            {
                des_y = minY + halfHeight + desRand * halfHeight;
            } else
            {
                des_y = desRand * halfHeight + minY;
            }
            ret = GameTools.CalLineAngle(pos, new Point(des_x, des_y));
            return ret;
        }

        public static function GetMirrorPoint(refPos:Point, Pos:Point):void
        {
            Pos.x = refPos.x - (Pos.x - refPos.x);
            Pos.y = refPos.y - (Pos.y - refPos.y);
        }

        public static function IsPointInScreen(pos:Point):Boolean
        {
            var maxX:Number = Laya.stage.width;
            var maxY:Number = Laya.stage.height;

            if (pos.x > maxX || pos.x < 0 || pos.y < 0 || pos.y > maxY)
            {
                return false;
            }
            return true;
        }

        public static function getItemCoinStr(coin:Number):String
        {
            var a:String = "" + coin;
            if (coin > 100000)
            {
                a = coin / 10000 + "万";
            }
            return a;
        }

        public static function getCoinStr(coin:Number):String
        {
            var a:String = "";
            if (coin >= 10000)
            {
                a = coin / 10000 + "万";
            } else if (coin > 1000)
            {
                a = coin / 1000 + "千";
            }
            return a;
        }

        public static function getRedTaskCoinStr(coin:Number):String
        {
            var a:String = "";
            if (coin > 10000)
            {
                a = ((coin - coin % 10000) / 10000) + "万";
            } else if (coin > 1000)
            {
                a = (coin / 1000).toFixed(0) + "千";
            }
            if (coin == 0)
            {
                a = "0";
            }
            return a;
        }

        public static function formatCurrency(amount:int):String
        {
            return amount + ""
        }

        public static function dealCode(code:Number):void
        {
            var codeCfg:cfg_code = cfg_code.instance(code);
            if (codeCfg)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, codeCfg.txtContent);
            } else
            {
                console.log("code:", code, "不明错误")
            }
        }


        public static function formatNickName(nickname:String, str_len:Number = 14):String
        {
            if (null == nickname)
            {
                return "";
            }
            if (getStringTrueLength(nickname) > str_len)
            {
                var length:Number = Math.floor(str_len / 2);

                while (getStringTrueLength(nickname.substr(0, length)) < str_len)
                {
                    length++
                }
                if (getStringTrueLength(nickname.substr(0, length)) >= str_len)
                {
                    return nickname.substr(0, length - 1) + "..."
                } else
                {
                    return nickname.substr(0, length) + "..."
                }

            } else
            {
                return nickname
            }
        }

        public static function getVisibleChildNumber(root:Sprite):int
        {
            var ret:int = 0;
            var index:int = 0;
            var child:Sprite;
            while (1)
            {
                child = root.getChildAt(index++) as Sprite;
                if (!child)
                {
                    break;
                }
            }

            return ret;
        }

        public static function traceLayaStageChildInfo():void
        {
            var index:int = 0;
            var child:Sprite;
            var root:Sprite = Laya.stage;
            while (1)
            {
                child = root.getChildAt(index) as Sprite;
                if (!child)
                {
                    break;
                } else
                {
                    var num:int = getVisibleChildNumber(child);
                    trace("traceLayaStageChildInfo: index = " + index + " num = " + num);
                }
                index++;
            }
        }

        public static var curScreenWidth:int = 0;
        public static var curScreenHeight:int = 0;

        //public static function ca


        //判断是否横屏
        public static function isCrossScreen():Boolean
        {
            return Browser.clientWidth > Browser.clientHeight
        }

        public static function getStringTrueLength(str:String):Number
        {
            var l:Number = str.length;
            var blen:Number = 0;
            for (var i = 0; i < l; i++)
            {
                if ((str.charCodeAt(i) & 0xff00) != 0)
                {
                    blen++;
                }
                blen++;
            }
            return blen
        }

        public static function closeAllPanel():void
        {
            var num:Number = Laya.stage.numChildren;
            for (var i:int = 0; i < num; i++)
            {
                var obj:Sprite = Laya.stage.getChildAt(i) as Sprite;
                if (obj)
                {
                    obj.removeSelf();
                }
            }
            if (Laya.stage.numChildren > 0)
            {
                closeAllPanel()
            }
        }

        private static function replaceUrlParam(url, paramName, paramValue)
        {
            if (paramValue == null)
            {
                paramValue = '';
            }
            var pattern = new RegExp('\\b(' + paramName + '=).*?(&|#|$)');
            if (url.search(pattern) >= 0)
            {
                return url.replace(pattern, '$1' + paramValue + '$2');
            }
            url = url.replace(/[?#]$/, '');
            return url + (url.indexOf('?') > 0 ? '&' : '?') + paramName + '=' + paramValue;
        }

        public static function replaceParam(key, value)
        {
            var search = window.location.search
            var param = replaceUrlParam(search, key, value)
            __JS__("window.history").pushState({}, null, param)
        }


        public static function showInfoFromJava(code:String):void
        {
            GameEventDispatch.instance.event(GameEvent.MsgTipContent, "code = " + code);
            //__JS__("AndroidInterface.wxResp(code)");
        }

        public static function nameSkip(name:String):String
        {
            return name.replace(/[&<>]/g, "");
        }

        public static function getUrlParamValue(name:String):*
        {
            if (!WxC.isInMiniGame())
            {
                var url:String = __JS__("window.document.location.href.toString()");
                var u:* = url.split("?");
                if (u[1] is String)
                {
                    u = u[1].split("&");
                    var gets:Object = {};
                    for (var i:String in u)
                    {
                        var j:String = u[i].split("=");
                        gets[j[0]] = j[1];
                    }
                    return gets[name];
                }
            }
            return null
        }

        public static function notch():String
        {
            if (WxC.isInMiniGame())
            {
                return WxC.get_notch();
            } else
            {
                var _notch:String = 'left';
                var tmpwindow:* = __JS__('window');
                var tmpscreen:* = __JS__('screen');
                if ('orientation' in tmpwindow)
                {
                    // Mobile
                    if (tmpwindow.orientation == 90)
                    {
                        _notch = 'left';
                    } else if (tmpwindow.orientation == -90)
                    {
                        _notch = 'right';
                    }
                } else if ('orientation' in tmpwindow.screen)
                {
                    // Webkit
                    if (tmpwindow.screen.orientation.type === 'landscape-primary')
                    {
                        _notch = 'left';
                    } else if (tmpwindow.screen.orientation.type === 'landscape-secondary')
                    {
                        _notch = 'right';
                    }
                } else if ('mozOrientation' in tmpwindow.screen)
                {
                    // Firefox
                    if (tmpwindow.screen.mozOrientation === 'landscape-primary')
                    {
                        _notch = 'left';
                    } else if (tmpwindow.screen.mozOrientation === 'landscape-secondary')
                    {
                        _notch = 'right';
                    }
                }
                return _notch;
            }
            return "left";
        }

        public static function isIphoneXCrossScreen():Boolean
        {
            var isIphoneXCrossScreen:Boolean = isCrossScreen() && Browser.clientWidth == 812 && Browser.onIOS;
            return isIphoneXCrossScreen
        }

        public static function buttonEffect(target:Object, timesX:Number = 0.2, timesY:Number = 0.2):void
        {
            Tween.to(target, {
                scaleX: timesX,
                scaleY: timesY
            }, 100, null, Handler.create(GameTools, effectComplete, [target]));
        }

        private static function effectComplete(target:Object):void
        {
            Tween.to(target, {scaleX: 1, scaleY: 1}, 100);

        }

        public static function QuitGame():void{
			WebSocketManager.instance.closeNoEvent()
            var token = StartParam.instance.getParam("access_token")
            Laya.timer.callLater(this,function(){
                ApiManager.instance.exitGame(token, new Handler(this, completeHandle), new Handler(this, error))
            })
		}

		private function completeHandle(data):void
        {
            if(data.code== "success"){
                console.log("退出成功")
            }else{
				Laya.timer.once(3000,this,QuitGame)
            }
        }

        private function error():void
        {
            Laya.timer.once(3000,this,QuitGame)
            console.log("退出失败")
        }

    }
}
