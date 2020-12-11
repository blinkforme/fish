package fight
{

    import model.FightM;

    import conf.cfg_anicollision;

    import laya.display.Sprite;
    import laya.maths.Point;
    import laya.ui.FontClip;

    import manager.ConfigManager;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.GameSoundManager;
    import manager.GameTools;
    import manager.SpineTemplet;

    import proto.ProtoSeatInfo;

    public class CatchShowEffect
    {
        private var _numFont:FontClip;
        private var _showTime:Number = 3;
        private var _showType:int = 0;
        private var _spineAniRoot:Sprite;
        private var _spineAni:SpineTemplet;
        private var _deviationX:Number = 0;
        private var _deviationY:Number = 0;
        private static var _cacheObject:Object = null;

        private var _create_pos:Point;
        private var _seat_info:ProtoSeatInfo;
        private var _spineName:String;
        private var _actionName:String;
        private var _catchShowEffectEndPosData:Object = new Object;
        private var besideAniNames:Array = ["H5_zhuanpan"];
        public var _catchBoss:Boolean = false;

        public static function create(showType:int, value:int, pos:Point, parent:Sprite, aniName:String, actionName:String, seatInfo:ProtoSeatInfo, preLoad:Boolean = false):CatchShowEffect
        {
            if (!_cacheObject)
            {
                _cacheObject = {};
            }
            var ret:CatchShowEffect = null;
            if (!preLoad && _cacheObject[String(showType)])
            {
                var tmpArray:Array = _cacheObject[String(showType)] as Array;
                if (tmpArray.length > 0)
                {
                    ret = tmpArray[0] as CatchShowEffect;
                    ret.init(showType, value, pos, parent, aniName, actionName, seatInfo, preLoad);
                    tmpArray.splice(0, 1);
                }
            }
            if (!ret)
            {
                ret = new CatchShowEffect(showType, value, pos, parent, aniName, actionName, seatInfo, preLoad);
            }
            return ret;
        }

        public function init(showType:int, value:int, pos:Point, parent:Sprite, aniName:String, actionName:String, seatInfo:ProtoSeatInfo, preLoad:Boolean):void
        {

            _catchBoss = false;
            _showType = showType;
            _showTime = 1.5;
            _spineAniRoot.visible = true;
            _numFont.visible = true;
            _numFont.value = "+" + value;
            _spineAni.play(actionName, false);
            _spineAniRoot.pos(GameTools.designPosXMapScreenPosX(pos.x), GameTools.designPosYMapScreenPosY(pos.y));
            _spineAniRoot.zOrder = 1;
            _numFont.pos(GameTools.designPosXMapScreenPosX(pos.x) + _deviationX, GameTools.designPosYMapScreenPosY(pos.y) + _deviationY);
            _numFont.zOrder = 1;
            _create_pos = pos;
            _seat_info = seatInfo;
            _spineName = aniName;
            _actionName = actionName;
            if (!preLoad)
            {
                var soundPath:String = ConfigManager.getConfValue("cfg_global", 1, "bingo_sound") as String;
                GameSoundManager.playSound(soundPath);
            }
        }

        public function setBossCatch(catchBoss:Boolean):void
        {
            _catchBoss = catchBoss;
        }

        public function CatchShowEffect(showType:int, value:int, pos:Point, parent:Sprite, aniName:String, aniActionName:String, seatInfo:ProtoSeatInfo, preLoad:Boolean)
        {
            _deviationX = ConfigManager.getConfValue("cfg_anicollision", aniName, "deviationX") as Number;
            _deviationY = ConfigManager.getConfValue("cfg_anicollision", aniName, "deviationY") as Number;
            _spineAni = new SpineTemplet(aniName);
            _spineAniRoot = new Sprite();
            _numFont = new FontClip("font/font_1.png", "/.+-0123456789枚万亿");
            _numFont.anchorX = 0.5;
            _numFont.anchorY = 0.5;
            _numFont.scaleX = 1.6 / 2;
            _numFont.scaleY = 1.6 / 2;
            _spineAniRoot.addChild(_spineAni)
            parent.addChild(_spineAniRoot);
            parent.addChild(_numFont);
            init(showType, value, pos, parent, aniName, aniActionName, seatInfo, preLoad);
        }

        public function destroy():void
        {
            _numFont.visible = false;
            _spineAniRoot.visible = false;
            _spineAni.stop();
            if (!_cacheObject[String(_showType)])
            {
                _cacheObject[String(_showType)] = [];
            }

            var arr:Array = _cacheObject[String(_showType)] as Array;
            arr.push(this);

            var cfg:cfg_anicollision = cfg_anicollision.instance(_spineName);

            if (besideAniNames.indexOf(_spineName) < 0)
            {
                //            _spineAni.setPos(_create_pos.x, _create_pos.y);
                _spineAni.setScale(cfg.scale, cfg.scale)
            }
            //        _numFont.pos(_create_pos.x + _deviationX, _create_pos.y + _deviationY);
            _numFont.scale(1.6 / 2, 1.6 / 2)
        }

        public function isValid():Boolean
        {
            return _showTime > 0;
        }

        public function screenResize():void
        {
            if (!(besideAniNames.indexOf(_spineName) < 0 && _showTime < 0.5))
            {
                _spineAniRoot.pos(GameTools.designPosXMapScreenPosX(_create_pos.x), GameTools.designPosYMapScreenPosY(_create_pos.y));
                _numFont.pos(GameTools.designPosXMapScreenPosX(_create_pos.x) + _deviationX, GameTools.designPosYMapScreenPosY(_create_pos.y) + _deviationY);
            }
        }

        private function getPosBySeatId(seat_id):Point
        {
            if (seat_id == 1)
            {
                return new Point(40, 700)
            } else if (seat_id == 2)
            {
                return new Point(1140, 700)
            } else if (seat_id == 3)
            {
                return new Point(1140, 20)
            } else if (seat_id == 4)
            {
                return new Point(75, 20)
            }
            return new Point(75, 20);
        }

        public function update(delta:Number):void
        {
            _showTime -= delta;

            if (besideAniNames.indexOf(_spineName) < 0)
            {
                if (_showTime < 0.5)
                {

                    if (_catchBoss)
                    {
                        _catchBoss = false;
                        GameEventDispatch.instance.event(GameEvent.ScreenShare, null);
                    }

                    var startX:Number = GameTools.designPosXMapScreenPosX(_create_pos.x);
                    var startY:Number = GameTools.designPosYMapScreenPosY(_create_pos.y);

                    _catchShowEffectEndPosData.getPos = false;
                    _catchShowEffectEndPosData.seat_id = FightM.instance.getShowSeatId(_seat_info.seat_id);

                    GameEventDispatch.instance.event(GameEvent.GetCatchShowEffectEndPos, _catchShowEffectEndPosData);

                    if (_catchShowEffectEndPosData.getPos)
                    {
                        var endX:Number = _catchShowEffectEndPosData.x;
                        var endY:Number = _catchShowEffectEndPosData.y;
                        var scale_time:Number = 0.5;

                        var percent_distance:Number = (scale_time - _showTime) / scale_time;

                        var scale:Number = _showTime / 0.5;
                        _spineAni.setScale(_spineAni.scaleX * scale, _spineAni.scaleY * scale);
                        _spineAniRoot.pos(startX - (startX - endX) * percent_distance, startY - (startY - endY) * percent_distance);


                        _numFont.scale(scale / 2, scale / 2);
                        _numFont.x = startX + _deviationX - (startX + _deviationX - endX) * percent_distance;
                        _numFont.y = startY + _deviationY - (startY + _deviationY - endY) * percent_distance;
                    }
                    else
                    {
                        _showTime = 0;
                    }

                }
            }

        }
    }
}
