package fight
{
    import control.WxC;

    import model.FightM;

    import laya.display.Animation;
    import laya.display.Sprite;
    import laya.maths.Point;
    import laya.media.SoundManager;

    import manager.AnimalManger;
    import manager.ConfigManager;
    import manager.GameConst;
    import manager.GameSoundManager;
    import manager.GameTools;
    import manager.SpineTemplet;

    import proto.ProtoBulletHitInfo;

    public class Bullet
    {
        private var _uniId:int;
        private var _isValid:Boolean;
        private var _isLifeOver:Boolean;
        private var _p1:Point = new Point();
        private var _p2:Point = new Point();
        private var _p3:Point = new Point();
        private var _p4:Point = new Point();
        private var _collisionCenter:Point = new Point();
        private var _radius:Number;
        private var _showTime:Number;
        private var _offsetX:Number;
        private var _offsetY:Number;
        private var _width:Number;
        private var _height:Number;
        private var _scrWidth:Number;
        private var _scrHeight:Number;
        private var _bombScaleWidth:Number;
        private var _bombScaleHeight:Number;
        private var _speed:Number;
        private var _hitTarget:Boolean;
        private var _bullet:Animation;
        private var _lineTest:Sprite;
        private var _catchMainTarget:Boolean;
        private var _bombCollisionCount:int;
        private var _bombCurCollisionCount:int;
        private var _deltaX:Number;
        private var _deltaY:Number;
        private var _frameDeltaX:Number;
        private var _frameDeltaY:Number;
        private var _angleP1:Number;
        private var _angleP2:Number;
        private var _collisionCenterBulletPosAngle:Number;
        private var _collisionCenterBulletPosLength:Number;
        private var _hurt:int;
        private var _parent:Sprite;
        private var _updateTime:Number;
        private var _fuid:int;
        private var _hitEffectArray:Array;
        private var _shootSeatId:int;
        private var _sk:int;
        public var _isCollision:Boolean = false;
        public var _useTotalTime:Number = 0;
        private var _lockReach:Boolean = false;
        private var _endX:Number = 0;
        private var _endY:Number = 0;
        private var _collisionFishInfo:Object;
        private var _hitCount:int = 0;
        private var _runTick:int = 0;
        private var _startTick:int = 0;
        private var _agent:int = 0;
        private var _delayCollision:Array;
        private var _updateFailNum:int = 0;
        private var _designPosX:Number = 0;
        private var _designPosY:Number = 0;
        public static var _cacheObject:Object = null;

        public static function create(info:BulletInfo, parent:Sprite, useCache:Boolean = true):Bullet
        {
            if (!_cacheObject)
            {
                _cacheObject = new Object();
            }
            var ret:Bullet = null;
            if (useCache && _cacheObject[String(info.sk)])
            {
                var tmpArray:Array = _cacheObject[String(info.sk)] as Array;
                if (tmpArray.length > 0)
                {
                    ret = tmpArray[0] as Bullet;
                    ret.dataInit(info);
                    tmpArray.splice(0, 1);
                }
            }
            if (!ret)
            {
                ret = new Bullet(info, parent);
            }
            var fightTick:int = FightManager.instance.getCurTick();

            ret.update(GameConst.fixed_update_time, true);


            return ret;
        }

        public function Bullet(info:BulletInfo, parent:Sprite)
        {
            _catchMainTarget = false;
            init(info, parent);
        }

        public function getUniId():int
        {
            return _uniId;
        }

        public function destroy():void
        {
            _bullet.visible = false;
            var hitEffect:SpineTemplet;
            for (var i:int = 0; i < _hitEffectArray.length; i++)
            {
                hitEffect = _hitEffectArray[i] as SpineTemplet;
                hitEffect.visible = false;
		hitEffect.stop();
            }
            if (!_cacheObject[String(_sk)])
            {
                _cacheObject[String(_sk)] = new Array();
            }
            var tmpArray:Array = _cacheObject[String(_sk)] as Array;
            tmpArray.push(this);
        }

        public function dataInit(info:BulletInfo):void
        {
            _useTotalTime = 0;
            _updateTime = 0;
            _uniId = info.uniId;
            _fuid = info.fuid;
            _shootSeatId = info.index;
            _showTime = info.showDelay;
            _collisionFishInfo = new Object();
            _hitTarget = false;
            _isLifeOver = false;
            _bullet.visible = true;
            _hitCount = info.count;
            _agent = info.agent;
            _startTick = info.tick;
            _runTick = 0;
            _updateFailNum = 0;
            _delayCollision = [];
            _bullet.play(0, true);
            _speed = (ConfigManager.getConfValue("cfg_battery_skin", info.sk, "speed") as Number);// * info.sr;
            var startX:Number = FightM.instance.getMirrorPosXByOwnSeat(info.startX);
            var endX:Number = FightM.instance.getMirrorPosXByOwnSeat(info.endX);
            var startY:Number = FightM.instance.getMirrorPosYByOwnSeat(info.startY);
            var endY:Number = FightM.instance.getMirrorPosYByOwnSeat(info.endY);
            if (_fuid && _fuid > 0)
            {
                var refPoint:Point = FightManager.instance.getFishPosition(_fuid);
                if (refPoint)
                {
                    endX = refPoint.x;
                    endY = refPoint.y;
                }
            }
            _endX = endX;
            _endY = endY;
            _designPosX = startX;
            _designPosY = startY;
            _bullet.pos(GameTools.designPosXMapScreenPosX(_designPosX), GameTools.designPosYMapScreenPosY(_designPosY));
            var angle:Number = GameTools.CalLineAngle(new Point(startX, startY), new Point(endX, endY));
            _bullet.rotation = angle;
            _deltaX = Math.cos(angle * Math.PI / 180);
            _deltaY = Math.sin(angle * Math.PI / 180);
            _frameDeltaX = GameConst.fixed_update_time * _speed * _deltaX;
            _frameDeltaY = GameConst.fixed_update_time * _speed * _deltaY;
            _lockReach = false;
        }


        private function init(info:BulletInfo, parent:Sprite):void
        {
            var bulletName:String = ConfigManager.getConfValue("cfg_battery_skin", info.sk, "name") as String;
            _sk = info.sk;
            _hitEffectArray = [];
            _parent = parent;
            _offsetX = ConfigManager.getConfValue("cfg_anicollision", bulletName, "colliOffsetX1") as Number;
            _offsetY = ConfigManager.getConfValue("cfg_anicollision", bulletName, "colliOffsetY1") as Number;
            _width = ConfigManager.getConfValue("cfg_anicollision", bulletName, "colliWidth1") as Number;
            _height = ConfigManager.getConfValue("cfg_anicollision", bulletName, "colliHeight1") as Number;
            _bombScaleWidth = ConfigManager.getConfValue("cfg_bulletmodel", bulletName, "bulletBombWidthScale") as Number;
            _bombScaleHeight = ConfigManager.getConfValue("cfg_bulletmodel", bulletName, "bulletBombHeightScale") as Number;

            _bullet = AnimalManger.instance.load(bulletName);
            _collisionCenterBulletPosAngle = GameTools.CalLineAngle(new Point(), new Point(_offsetX, _offsetY));
            _collisionCenterBulletPosLength = GameTools.CalPointLen(new Point(), new Point(_offsetX, _offsetY));
            _bullet.pivot(ConfigManager.getConfValue("cfg_anicollision", bulletName, "pivotX") as int,
                    ConfigManager.getConfValue("cfg_anicollision", bulletName, "pivotY") as int);
            parent.addChild(_bullet);


            if (GameConst.draw_collision_rect)
            {
                var sprite:Sprite = new Sprite();
                parent.addChild(sprite);
                sprite.graphics.drawRect(Laya.stage.width / 2 - 2, Laya.stage.height / 2 - 2, 4, 4, "#ff0000");

                _lineTest = new Sprite();
                parent.addChild(_lineTest);
            }

            dataInit(info);
            _scrWidth = _width;
            _scrHeight = _height;
            _radius = Math.sqrt(_width * _width + _height * _height);

            _angleP1 = -Math.cos(_width / _radius) / Math.PI * 180;//todo:可以在配置表里面配置
            _angleP2 = -_angleP1;//可以在配置表里面配置

            calCollisionInfo();
        }

        private function lockUpdate(delta:Number):void
        {
            if (_fuid && _fuid > 0)
            {
                var scrX:Number = _designPosX;//_bullet.x;
                var scrY:Number = _designPosY;//_bullet.y;
                var refPoint:Point = FightManager.instance.getFishPosition(_fuid);

                if (refPoint)
                {
                    refPoint.x = GameTools.screenPosXMapDesignPosX(refPoint.x);
                    refPoint.y = GameTools.screenPosYMapDesignPosY(refPoint.y);
                    var startX:Number = _designPosX;//_bullet.x;
                    var startY:Number = _designPosY;//_bullet.y;
                    _endX = refPoint.x;
                    _endY = refPoint.y;
                    var angle:Number = GameTools.CalLineAngle(new Point(startX, startY), new Point(_endX, _endY));
                    _bullet.rotation = angle;
                    _deltaX = Math.cos(angle * Math.PI / 180);
                    _deltaY = Math.sin(angle * Math.PI / 180);
                    _frameDeltaX = GameConst.fixed_update_time * _speed * _deltaX;
                    _frameDeltaY = GameConst.fixed_update_time * _speed * _deltaY;
                }
                else
                {
                    _lockReach = true;
                    _bullet.visible = false;
                }
                var desX:Number = scrX + _frameDeltaX;//_speed * delta * _deltaX;
                var desY:Number = scrY + _frameDeltaY;//_speed * delta * _deltaY;

                if ((desX - scrX) * (_endX - desX) >= 0 &&
                        (desY - scrY) * (_endY - desY) >= 0)
                {
                    //					_bullet.pos(desX, desY);

                    _designPosX = desX;
                    _designPosY = desY;
                    _bullet.pos(GameTools.designPosXMapScreenPosX(_designPosX), GameTools.designPosYMapScreenPosY(_designPosY));

                }
                else
                {
                    _lockReach = true;
                    _bullet.visible = false;
                }
            }
        }

        public function getDelayCollision():Array
        {
            if (_delayCollision.length > 0)
            {
                var tmpCollision:Array = _delayCollision;
                _delayCollision = [];
                return _delayCollision;
            }
            return null;
        }

        public function addDelayCollision(fuid):void
        {
            _delayCollision.push(fuid);
        }

        public function isUncollisionFish(fuid:int):Boolean
        {
            if (_collisionFishInfo["" + fuid])
            {
                return false;
            }
            return true;
        }

        public function addCollisionFishInfo(fuid:int):void
        {
            _collisionFishInfo["" + fuid] = 1;
        }

        public function uncollisionFish(fuid:int):void
        {
            _collisionFishInfo["" + fuid] = null;
        }

        public function isAlive():Boolean
        {
            return !_hitTarget;
        }

        public function getAgent():int
        {
            return _agent;
        }

        public function clientHitTarget(fuid:int):void
        {
            if (_hitTarget)// || _hitCount <= 0)
            {
                return;
            }
            _hitCount--;
            var webName:String = ConfigManager.getConfValue("cfg_battery_skin", _sk, "web") as String;
            var action:String = ConfigManager.getConfValue("cfg_battery_skin", _sk, "action") as String;
            var follow:int = ConfigManager.getConfValue("cfg_battery_skin", _sk, "follow") as int;
            var x:Number = _bullet.x;
            var y:Number = _bullet.y;
            if (_hitCount <= 0)
            {
                _catchMainTarget = true;
                _hitTarget = true;
                _bullet.stop();
                _bullet.visible = false;
            }
            var hitEffect:SpineTemplet = null;
            for (var i:int = 0; i < _hitEffectArray.length; i++)
            {
                var effect:SpineTemplet = _hitEffectArray[i] as SpineTemplet;
                if (!effect.visible)
                {
                    hitEffect = effect;
                }
            }

            if (!hitEffect)
            {
                hitEffect = new SpineTemplet(webName); //AnimalManger.instance.load(webName);
                _hitEffectArray.push(hitEffect);
                _parent.addChild(hitEffect);
                hitEffect.pivot(ConfigManager.getConfValue("cfg_anicollision", webName, "pivotX") as int,
                        ConfigManager.getConfValue("cfg_anicollision", webName, "pivotY") as int);
            }

            hitEffect.visible = true;
            hitEffect.play(0, false);

            var is_own:Boolean = (_agent == FightM.instance.getOwnAgent());
            FightManager.instance.fishHitStart(fuid, !is_own);

            hitEffect.pos(x, y);

            hitEffect.scale(FightManager.instance.getWebScale(), FightManager.instance.getWebScale(), true);
            if (1 == follow)
            {
                hitEffect.rotation = _bullet.rotation + 90;
            }
            if (_agent == FightM.instance.getOwnAgent())
            {
//                var soundPath:String;
//                soundPath = ConfigManager.getConfValue("cfg_global", 1, "hit_sound") as String;
//
//                if (WxC.isInMiniGame())
//                {
//					soundPath = "wxlocal/hit.mp3";
//                    //SoundManager.stopEarListSound(soundPath);
//                }
//                GameSoundManager.playSound(soundPath);
            }
        }

        public function onlineHitTarget(hitInfo:ProtoBulletHitInfo):void
        {
            if (_hitTarget)
            {
                return;
            }

            if (hitInfo.getLc() >= _hitCount)
            {
                return;
            }

            _hitCount = hitInfo.getLc();
            var webName:String = ConfigManager.getConfValue("cfg_battery_skin", _sk, "web") as String;
            var action:String = ConfigManager.getConfValue("cfg_battery_skin", _sk, "action") as String;
            var follow:int = ConfigManager.getConfValue("cfg_battery_skin", _sk, "follow") as int;
            var x:Number = _bullet.x;
            var y:Number = _bullet.y;
            if (hitInfo.getLc() <= 0)
            {
                _catchMainTarget = true;
                _hitTarget = true;
                _bullet.stop();
                _bullet.visible = false;
            }
            var hitEffect:SpineTemplet = null;
            for (var i:int = 0; i < _hitEffectArray.length; i++)
            {
                var effect:SpineTemplet = _hitEffectArray[i] as SpineTemplet;
                if (!effect.visible)
                {
                    hitEffect = effect;
                }
            }

            if (!hitEffect)
            {
                hitEffect = new SpineTemplet(webName); //AnimalManger.instance.load(webName);
                _hitEffectArray.push(hitEffect);
                _parent.addChild(hitEffect);
                hitEffect.pivot(ConfigManager.getConfValue("cfg_anicollision", webName, "pivotX") as int,
                        ConfigManager.getConfValue("cfg_anicollision", webName, "pivotY") as int);
            }

            hitEffect.visible = true;
            hitEffect.play(0, false);
            var cx:Number = FightM.instance.getMirrorPosXByOwnSeat(hitInfo.getCx());
            var cy:Number = FightM.instance.getMirrorPosYByOwnSeat(hitInfo.getCy());

            var is_own:Boolean = (_agent == FightM.instance.getOwnAgent());
            FightManager.instance.fishHitStart(hitInfo.getFishUid(), !is_own);

            hitEffect.scale(FightManager.instance.getWebScale(), FightManager.instance.getWebScale(), true);
            hitEffect.pos(x, y);
            if (1 == follow)
            {
                hitEffect.rotation = _bullet.rotation + 90;
            }

            if (_agent == FightM.instance.getOwnAgent())
            {
//                var soundPath:String;
//                soundPath = ConfigManager.getConfValue("cfg_global", 1, "hit_sound") as String;
//                if (WxC.isInMiniGame())
//                {
//					soundPath = "wxlocal/hit.mp3";
//                    //SoundManager.stopEarListSound(soundPath);
//                }
//                GameSoundManager.playSound(soundPath);
            }
        }

        //		private function onBulletOver():void
        //		{
        //			_isLifeOver = true;
        //		}

        //		public function isPowerReduce():Boolean
        //		{
        //			return _catchMainTarget;
        //		}

        public function lockFish():Boolean
        {
            return _fuid > 0;
        }

        public function getFuid():int
        {
            return _fuid;
        }

        public function canCatchFish():Boolean
        {
            if (_hitTarget)
            {
                return false;
            }
            if (_fuid > 0)
            {
                return _lockReach;
            }

            return true;
        }

        public function isBulletValid():Boolean
        {
            var effectAllUnVisible:Boolean = true;
            for (var i:int = 0; i < _hitEffectArray.length; i++)
            {
                var effect:SpineTemplet = _hitEffectArray[i] as SpineTemplet;
                if (effect.visible)
                {
                    effectAllUnVisible = false;
                    break;
                }
            }
            return !(_hitTarget && effectAllUnVisible);
        }

        public function calCollisionInfo():void
        {
            var collisionRef:Point;
            var color:String;
            collisionRef = GameTools.CalRotatePos(_bullet.rotation + _collisionCenterBulletPosAngle, _collisionCenterBulletPosLength);
            _collisionCenter.x = _bullet.x + collisionRef.x;
            _collisionCenter.y = _bullet.y + collisionRef.y;
            GameTools.CalRotatePos4(_collisionCenter, _p1, _p3, _bullet.rotation + _angleP1, _radius);
            GameTools.CalRotatePos4(_collisionCenter, _p2, _p4, _bullet.rotation + _angleP2, _radius);
            if (GameConst.draw_collision_rect)
            {
                if (_isCollision)
                {
                    color = "#ff0000";
                }
                else
                {
                    color = "#ffffff";
                }
                _lineTest.graphics.clear();
                _lineTest.graphics.drawLine(_p1.x, _p1.y, _p2.x, _p2.y, "#ffffff", 4);
                _lineTest.graphics.drawLine(_p2.x, _p2.y, _p3.x, _p3.y, "#ffffff", 4);
                _lineTest.graphics.drawLine(_p3.x, _p3.y, _p4.x, _p4.y, "#ffffff", 4);
                _lineTest.graphics.drawLine(_p4.x, _p4.y, _p1.x, _p1.y, "#ffffff", 4);
            }
        }


        private function hideHitEffect():void
        {
            var invalidEffect:Array = [];
            for (var i:int = 0; i < _hitEffectArray.length; i++)
            {
                var aEffect:SpineTemplet = _hitEffectArray[i] as SpineTemplet;
                if (!aEffect.isPlaying())
                {
			aEffect.stop();
                    aEffect.visible = false;
                }
            }
        }

        private function pointInTriangle(ax, ay, bx, by, cx, cy, px, py):Boolean
        {
            var ret:Boolean = false;
            var crossOne:Number = (bx - ax) * (py - ay) - (by - ay) * (px - ax);
            var crossTwo:Number = (cx - bx) * (py - by) - (cy - by) * (px - bx);
            var crossThree:Number = (ax - cx) * (py - cy) - (ay - cy) * (px - cx);
            if (crossOne > 0 && crossTwo > 0 && crossThree > 0)
            {
                return true;
            }
            if (crossOne < 0 && crossTwo < 0 && crossThree < 0)
            {
                return true;
            }
            return ret;
        }

        //4个角度反射
        private function reflect(angle:Number):void
        {
            //4个角反射
            var len:int = 50;
            var refAngle:Number = 0;
            var doReflect:Boolean = false;
            //if(_bullet.x > 0 && _bullet.x <= len)
            if (_designPosX > 0 && _designPosX <= len)
            {
                //if(_bullet.y <= len)
                if (_designPosY <= len)
                {
                    //左上角
                    //if(pointInTriangle(0, 0, 0, len, len, 0, _bullet.x, _bullet.y))
                    if (pointInTriangle(0, 0, 0, len, len, 0, _designPosX, _designPosY))
                    {
                        if (angle > 135 && angle <= 225)
                        {
                            angle = 45 + 225 - angle;
                            doReflect = true;
                        }
                        else if (angle > 225 && angle < 315)
                        {
                            angle = 45 - (angle - 225);
                            if (angle < 0)
                            {
                                angle += 360;
                            }
                            doReflect = true;
                        }
                    }
                }
                //if(_bullet.y >= (Laya.stage.height - len))
                if (_designPosY >= (GameConst.design_height - len))
                {
                    //refAngle = GameTools.CalLineAngle(new Point(len, Laya.stage.height), new Point(_bullet.x, _bullet.y));
                    //左下角
                    //if(refAngle >= 180 && refAngle <= 225)
                    //if(pointInTriangle(0, Laya.stage.height, len, Laya.stage.height, 0, Laya.stage.height - len, _bullet.x, _bullet.y))
                    if (pointInTriangle(0, GameConst.design_height, len, GameConst.design_height, 0, GameConst.design_height - len, _designPosX, _designPosY))
                    {
                        if (angle > 45 && angle <= 135)
                        {
                            angle = 315 + 135 - angle;
                            if (angle > 360)
                            {
                                angle = angle - 360;
                            }
                            doReflect = true;
                        }
                        else if (angle > 135 && angle < 225)
                        {
                            angle = 315 - (angle - 135);
                            doReflect = true;
                        }
                    }
                }
            }
            //else if(_bullet.x >= (Laya.stage.width - len) && _bullet.x < Laya.stage.width)
            else if (_designPosX >= (GameConst.design_width - len) && _designPosX < GameConst.design_width)
            {
                //if(_bullet.y <= len)
                if (_designPosY <= len)
                {
                    //右上角
                    //if(pointInTriangle(Laya.stage.width - len, 0, Laya.stage.width, len, Laya.stage.width, 0, _bullet.x, _bullet.y))
                    if (pointInTriangle(GameConst.design_width - len, 0, GameConst.design_width, len, GameConst.design_width, 0, _designPosX, _designPosY))
                    {
                        if (angle >= 315)
                        {
                            angle = 135 - (angle - 315);
                        }
                        if (angle < 45)
                        {
                            angle = 45 + (45 - angle);
                        }
                        if (angle > 225 && angle < 315)
                        {
                            angle = 135 + (315 - angle);
                        }
                        doReflect = true;
                    }
                }
                //if(_bullet.y >= (Laya.stage.height - len))
                if (_designPosY >= (GameConst.design_height - len))
                {
                    //右下角
                    //refAngle = GameTools.CalLineAngle(new Point(Laya.stage.width - len, Laya.stage.height), new Point(_bullet.x, _bullet.y));
                    //if(refAngle >= 315 && refAngle < 360)
                    //if(pointInTriangle(Laya.stage.width - len, Laya.stage.height, Laya.stage.width, Laya.stage.height, Laya.stage.width, Laya.stage.height - len, _bullet.x, _bullet.y))
                    if (pointInTriangle(GameConst.design_width - len, GameConst.design_height, GameConst.design_width, GameConst.design_height, GameConst.design_width,
                                    GameConst.design_height - len, _designPosX, _designPosY))
                    {
                        if (angle > 315)
                        {
                            angle = 225 + (360 - angle + 45);
                        }
                        if (angle < 45)
                        {
                            angle = 225 + (45 - angle);
                        }
                        if (angle >= 45 && angle < 135)
                        {
                            angle = 135 + (135 - angle);
                        }
                        doReflect = true;
                    }
                }
            }
            if (doReflect)
            {
                _deltaX = Math.cos(angle * Math.PI / 180);
                _deltaY = Math.sin(angle * Math.PI / 180);
                _frameDeltaY = GameConst.fixed_update_time * _speed * _deltaY;
                _frameDeltaX = GameConst.fixed_update_time * _speed * _deltaX;
                _bullet.rotation = angle;
            }
            //			_bullet.rotation = angle;
            //			if(_bullet.rotation != angle)
            //			{
            //				_deltaX = Math.cos(angle * Math.PI / 180);
            //				_deltaY = Math.sin(angle * Math.PI / 180);
            //			}
        }

        private function fixUpdate(delta):void
        {
            hideHitEffect();
            if (_hitTarget)
            {
                return;
            }
            _useTotalTime += delta;
            if (_useTotalTime > 30)
            {
                //trace("bullet time over");
                //trace(_hitTarget, _fuid, _lockReach,_hitCount);
            }
            if (_showTime > 0)
            {
                _showTime -= delta;
            }

            if (_fuid && _fuid > 0)
            {
                lockUpdate(delta);
            }
            else
            {
                var scrX:Number = _designPosX;//_bullet.x;
                var scrY:Number = _designPosY;//_bullet.y;
                //				_bullet.pos(scrX + _speed * delta * _deltaX, scrY + _speed * delta * _deltaY);

                _designPosX = scrX + _frameDeltaX;//_speed * delta * _deltaX;
                _designPosY = scrY + _frameDeltaY;//_speed * delta * _deltaY;
                _bullet.pos(GameTools.designPosXMapScreenPosX(_designPosX), GameTools.designPosYMapScreenPosY(_designPosY));
                var change:Boolean = false;
                //if(_bullet.x <= 0)
                if (_designPosX <= 0)
                {
                    _deltaX = -_deltaX;//Math.abs(_deltaX);
                    _frameDeltaX = GameConst.fixed_update_time * _speed * _deltaX;
                    if (_deltaY > 0)
                    {
                        _bullet.rotation = 180 - _bullet.rotation;
                    }
                    else
                    {
                        _bullet.rotation = 360 - (_bullet.rotation - 180);
                    }
                    change = true;
                }
                //else if(_bullet.x >= Laya.stage.width)
                else if (_designPosX >= GameConst.design_width)
                {
                    _deltaX = -_deltaX;//-Math.abs(_deltaX);
                    _frameDeltaX = GameConst.fixed_update_time * _speed * _deltaX;
                    if (_deltaY > 0)
                    {
                        _bullet.rotation = 180 - _bullet.rotation;
                    }
                    else
                    {
                        _bullet.rotation = 180 + (360 - _bullet.rotation);
                    }
                    change = true;
                }
                //if(_bullet.y <= 0)
                if (_designPosY <= 0)
                {
                    _deltaY = -_deltaY;//Math.abs(_deltaY);
                    _frameDeltaY = GameConst.fixed_update_time * _speed * _deltaY;
                    if (_deltaX > 0)
                    {
                        _bullet.rotation = 360 - _bullet.rotation;
                    }
                    else
                    {
                        _bullet.rotation = 180 - (_bullet.rotation - 180);
                    }
                    change = true;
                }
                //else if(_bullet.y >= Laya.stage.height)
                else if (_designPosY >= GameConst.design_height)
                {
                    _deltaY = -_deltaY;//-Math.abs(_deltaY);
                    _frameDeltaY = GameConst.fixed_update_time * _speed * _deltaY;
                    change = true;
                    if (_deltaX > 0)
                    {
                        _bullet.rotation = 360 - _bullet.rotation;
                    }
                    else
                    {
                        _bullet.rotation = 180 + (180 - _bullet.rotation);
                    }

                }

                reflect(_bullet.rotation);
            }
        }


        public function update(delta:Number, start:Boolean = false):void
        {
            var fightTick:int = FightManager.instance.getCurTick();
            var maxTick:int = FightManager.instance.getMaxTick();
            //			var runTick:int = FightManager.instance.getRunTick(_startTick);
            //			if(!start)
            //			{
            //				runTick = _runTick + 1;
            //			}
            //			if((runTick - _runTick) > 20)
            //			{
            //			}
            //			var runTick:int = 1;
            //			for(var i:int = _runTick; i < runTick; i++)
            //			{
            //				_updateFailNum = 0;
            //				_runTick++;
            fixUpdate(GameConst.fixed_update_time);
            //			}
        }

        public function isBulletLifeOver():Boolean
        {
            return _isLifeOver;
        }

        public function getP1():Point
        {
            return _p1;
        }

        public function getP2():Point
        {
            return _p2;
        }

        public function getP3():Point
        {
            return _p3;
        }

        public function getP4():Point
        {
            return _p4;
        }

        public function getRadius():Number
        {
            return _radius;
        }

        public function getCenter():Point
        {
            return _collisionCenter;
        }

        public function getPosX():Number
        {
            //return _bullet.x;
            return _designPosX
        }

        public function getPosY():Number
        {
            //return _bullet.y;
            return _designPosY;
        }

        public function getHurt():int
        {
            return _hurt;
        }

        public function getSeatId():int
        {
            return _shootSeatId;
        }

        public function drawCollisionRect():void
        {

        }
    }
}

