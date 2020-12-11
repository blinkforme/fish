package fight
{
    import model.FightM;

    import laya.display.Sprite;
    import laya.filters.ColorFilter;
    import laya.maths.Point;
    import laya.maths.Rectangle;
    import laya.ui.FontClip;
    import laya.utils.Ease;
    import laya.utils.Handler;
    import laya.utils.Tween;

    import manager.ConfigManager;
    import manager.FishAniManager;
    import manager.GameAnimation;
    import manager.GameConst;
    import manager.GameSoundManager;
    import manager.GameTools;
    import manager.SpineTemplet;

    import proto.ProtoFishInfo;
    import proto.ProtoSeatInfo;

    public class Fish
    {

        private var _fishName:String;
        private var _fish:Sprite;
        private var _pivotX:Number;
        private var _pivotY:Number;

        private var _fishMoneyBagParent:Sprite;
        private var _fishMoneyBag:SpineTemplet;
        private var _fishMoneyBagBomb:SpineTemplet;
        private var _fishParent:Sprite;
        private var _goldFishHpRate:Number;
        private var _isMirror:Boolean;
        private var _hitColorChangeLastTime:Number;
        private var _hitColorChangeTime:Number;
        private var _bulletSpeedReduceRadio:Number;
        private var _bulletSpeedReduceTime:Number;
        private var _bulletSpeedReduceLastTime:Number;
        private var _bulletSpeedReducePercent:Number;
        private var _speed:Number;
        private var _collisionCount:int;
        private var _collisionOffsetX:Array;
        private var _collisionOffsetY:Array;
        private var _collisionRadius:Array;
        private var _collisionAngleP1:Array;
        private var _collisionAngleP2:Array;
        private var _collisionCenterFishPosAngle:Array;
        private var _collisionCenterFishPosMirrorAngle:Array;
        private var _collisionCenterFishPosLength:Array;
        private var _collisionIndex:int;
        private var _fishOffsetX:Number;
        private var _fishOffsetY:Number;
        private var _fishRadius:Number;
        private var _fishAngleP1:Number;
        private var _fishAngleP2:Number;
        private var _fishCenterFishPosAngle:Number;
        private var _fishCenterFishPosMirrorAngle:Number;
        private var _fishCenterFishPosLength:Number;

        private var _isDeadAniExist:Boolean;
        private var _collisionCenter:Point;
        private var _hitValue:Number;
        private var _hp:Number;
        private var _multiple:Number;
        private var _angleSwitchMax:Number;
        private var _angleSwitchMin:Number;
        private var _desAngle:Number;
        private var _desMidAngle:Number;
        private var _desMaxFromMid:Number;
        private var _curAngleAsMidRef:Boolean;
        private var _deltaX:Number;
        private var _deltaY:Number;
        private var _angleSwitchRate:Number;
        private var _angleSpeedEffect:Number;
        private var _isGroupReach:Boolean;
        private var _isCatch:Boolean;
        private var _isGroupFish:Boolean;
        private var _isLineSwim:Boolean;
        private var _isAppeared:Boolean;
        private var _playDeadAni:Boolean;

        //FishGroupPath* m_groupPath; //鱼群路径

        //private var _fishLength:Number;
        private var _fishRunTime:Number;
        private var _fishShowDelay:Number;
        private var _rectP1:Point;// = new Point();
        private var _rectP2:Point;// = new Point();
        private var _rectP3:Point;// = new Point();
        private var _rectP4:Point;// = new Point();
        private var _rectQ1:Point;// = new Point();
        private var _rectQ2:Point;// = new Point();
        private var _rectQ3:Point;// = new Point();
        private var _rectQ4:Point;// = new Point();
        private var _smallGroupFish:Boolean;
        private var _coinComsumption:Boolean;
        private var _bulletHurt:Boolean;
        private var _isGoldFish:Boolean;

        private var _fishScale:Number = 1;
        private var _isBoss:Boolean;
        private var _fishId:int;
        private var _pathSwimTest:Boolean;
        //		private var _bezierNum:int;
        private var _fishSizeType:int;
        private var _fishPlayType:int;
        private var _pathTestFreeSwim:Boolean;
        private var _updateTime:Number;
        private var _dieAlpha:Boolean;
        private var _dieAlphaRunTime:Number;
        private var _dieAlphaTime:Number;
        private var _fadeScale:Number;
        public var _isCollision:Boolean;
        private var _lineTest:Sprite;
        private var _isOnline:Boolean;
        private var _uniId:int;
        private var _onlineData:Array;
        private var _doubleUpdateLeft:int;
        private var _updateCount:int;
        private var _updateRate:int = 1;
        private var _segNum:int = 0;
        private var _pathId:int = 0;
        private var _ipath:int = 0;
        private var _path:Array = new Array;
        private var _group:int = 0;
        private var _segInit:Boolean = false;
        private var _loop:int = 0;
        private var _curT:Number = 0;
        private var _curSwimLen:Number = 0;
        private var _tickNum:int = -1;
        private var _preT:Number = 0;
        private var _runOver:Boolean = false;
        private var _mirror:int = 1;//镜像类型 1:x镜像 2:y镜像 3:xy镜像
        private var _clearUpDir:int = 1;
        private var _clearUpTotalTime:Number = 0;
        private var _clearUpCastTime:Number = 0;
        private var _offX:Number = 0;
        private var _offY:Number = 0;
        private var _specFlag:Number = 0;
        private var _catchShow:int = 0;
        private var _catchType:int = 0;
        private var _catchShowRate:Number = 0;
        private var _specSprite:Sprite = null;//玩法标志
        private var _boomSelectSprite:Sprite = null;//炸弹能选中的鱼
        private var _fishSwimPathIdFont:FontClip = null;
        private var _fishFrameNum:int = 1;
        private var _fishSwimRefL:Number = 1;
        private var _fishSwimSpeedBase:Number = 1;
        private var _fishAniMaxInterval:Number = 1;
        private var _freezeTime:Number = 0;
        private var _callDelay:Number = 0;
        private var _lockSprite:Sprite = null;
        private var _lockFlag:Boolean = false;
        private var _fishAniSpeedChange:Boolean = false;
        private var _calMal:Number = 0;
        private var _calRect:Boolean = false;
        private var _calRectInfo:Array = new Array;
        private var _delayDie:Number = 0;
        private var _absorbed:Boolean = false;
        private var _absorbedTotalTime:Number = 2;
        private var _absorbedRunTime:Number = 0;
        private var _absorbedDeltaX:Number = 0;
        private var _absorbedDeltaY:Number = 0;
        private var _absorbedX:Number = 0;
        private var _absorbedY:Number = 0;
        private var _absorbedAngleChange:Number = 30;
        private var _hitActionExist:Boolean = false;
        private var _dieCatchInfo:Array = null;
        private var _designPos:Point = new Point();
        private var _change_num:int = 0;
        private static var _cacheObject:Object = null;
        private var _shakeArr:Array;
        private var _boomCatch:int = 0;
        private static var pathSegTimes:Object = {};

        public static function create(id:int, parent:Sprite, useCache:Boolean = true):Fish
        {

            if (!_cacheObject)
            {
                _cacheObject = new Object();
            }
            var ret:Fish = null;
            if (useCache && _cacheObject[String(id)])
            {
                var tmpArray:Array = _cacheObject[String(id)] as Array;
                if (tmpArray.length > 0)
                {
                    ret = tmpArray[0] as Fish;
                    ret.dataInit();
                    ret.updateParent(null);
                    tmpArray.splice(0, 1);
                }
            }

            if (!ret)
            {
                ret = new Fish(id, parent);
                ret.updateParent(null);
            }
            return ret;
        }

        public function updateParent(parent:Sprite):void
        {
            var layers:Array = FightManager.instance.getLayers();
            var layerIndex:int = ConfigManager.getConfValue("cfg_fish", _fishId, "layer") as int;
            if (!parent)
            {
                parent = layers[layerIndex];
            }
            //        if (parent == _fish.parent) {
            //            return;
            //        }

            if (_specSprite && _change_num <= 0)
            {
                parent.addChild(_specSprite);
            }

            if (_fish)
            {
                parent.addChild(_fish);
            }
            if (_boomSelectSprite)
            {
                parent.addChild(_boomSelectSprite);
            }
            if (_fishMoneyBagParent)
            {
                parent.addChild(_fishMoneyBagParent);
            }
            if (_fishSwimPathIdFont)
            {
                parent.addChild(_fishSwimPathIdFont);
            }
            if (_specSprite && _change_num > 0)
            {
                parent.addChild(_specSprite);
            }
        }

        public function Fish(id:int, parent:Sprite)
        {
            //			_uniId = -1;
            //			_doubleUpdateLeft = 0;
            //			_pathInfoArray = null;
            //			_isOnline = online;
            //			_pathInfoIndex = 0;
            //			_pathBezierPathDic = pathDic;
            //			_noMirrorFishStartSwimLength = 200;
            //			_randomIndex = 0;
            //			_fishRandom = random;
            //			_onlineData = [];
            //			_updateCount = 0;
            //			_updateRate = 1;
            //			_curT = 0;
            //			_curSwimLen = 0;
            //			_tickNum = -1;
            init(id, parent);
        }

        private var _delayShowSeatInfo:ProtoSeatInfo = null;

        public function setDieCatchInfo(catchInfo:Array, seatInfo:ProtoSeatInfo):void
        {
            _dieCatchInfo = catchInfo;
            _delayShowSeatInfo = seatInfo;
        }

        public function destroy():void
        {

            if (_dieCatchInfo)
            {
                FightManager.instance.showFishDieCatchInfo(this, _dieCatchInfo, _delayShowSeatInfo);
            }
            _uniId = -1;
            if (_fish)
            {
                //				_fish.removeSelf();
                if (_fish is SpineTemplet)
                {
                    var spineAni:SpineTemplet = _fish as SpineTemplet;
                    spineAni.stop();
                }
                else
                {
                    var aniTmp:GameAnimation = _fish as GameAnimation;
                    aniTmp.stop();
                }

                _fish.visible = false;
            }
            //			if(_fishParent)
            //			{
            ////				_fishParent.removeSelf();
            //				_fishParent.visible = false;
            //			}

            if (_lineTest)
            {
                //				_lineTest.removeSelf();
                _lineTest.visible = false;
            }
            if (_specSprite)
            {
                //				_specSprite.removeSelf();
                _specSprite.visible = false;
            }
            if (_fishSwimPathIdFont)
            {
                //				_fishSwimPathIdFont.removeSelf();
                _fishSwimPathIdFont.visible = false;
            }
            if (_boomSelectSprite)
            {
                //				_boomSelectSprite.removeSelf();
                _boomSelectSprite.visible = false;
            }
            if (_lockSprite)
            {
                Tween.clearAll(_lockSprite);
                //				_lockSprite.removeSelf();
                _lockSprite.visible = false;
            }
            if (_fishMoneyBag)
            {
                //				_fishMoneyBag.removeSelf();
                _fishMoneyBag.visible = false;
            }
            if (_fishMoneyBagBomb)
            {
                _fishMoneyBagBomb.visible = false;
            }
            if (_fishMoneyBagParent)
            {
                //				_fishMoneyBagParent.removeSelf();
                _fishMoneyBagParent.visible = false;
            }
            //			_fishMoneyBagParent = null;
            //			_fishMoneyBag = null;
            //			_lineTest = null;
            //			_boomSelectSprite = null;
            //			_fish = null;
            //			_fishParent = null;
            //			_specSprite = null;
            //			_fishSwimPathIdFont = null;
            //			_lockSprite = null;
            if (!_cacheObject[String(_fishId)])
            {
                _cacheObject[String(_fishId)] = new Array();
            }
            var tmpArray:Array = _cacheObject[String(_fishId)] as Array;
            tmpArray.push(this);
        }


        public function hitJudge(hitValue:Number, powerReduce:Boolean, bulletHit:Boolean):Boolean
        {
            var isHit:Boolean = false;
            if (_isCatch)
            {
                return false;
            }

            if (bulletHit)
            {
                var rnd:Number = Math.random();

                var hitRate:Number;

                if (_isGoldFish)
                {
                    hitRate = 1 / (_multiple * _goldFishHpRate);
                }
                else
                {
                    hitRate = 1 / _multiple;
                }

                if (rnd < hitRate)
                {
                    isHit = true;
                }
            }
            else
            {
                isHit = true;
            }
            if (isHit)
            {
                _isCatch = true;
                //				if(null != _fitArray)
                //				{
                //					var count:int = _fitArray.length;
                //					for(var i:int = 0; i < count; i++)
                //					{
                //						var fish:Fish = _fitArray[i] as Fish;
                //						if(this != fish)
                //						{
                //							fish.hitJudge(hitValue, powerReduce, false);
                //						}
                //					}
                //				}


                _bulletHurt = bulletHit;

                if (_isDeadAniExist)
                {
                    //					CCArmatureAnimation* animation = m_fish->getAnimation();
                    //					animation->play("Died", -1, -1, 0);
                    //					m_fish->setOpacity(255);
                    //					m_fish->setColor(ccc3(255, 255, 255));
                }

                _hitValue = hitValue;
                if (!_coinComsumption && isValid())
                {
                    _coinComsumption = true;
                }

            }
            return isHit;
        }

        public function setHitStatus():void
        {
            if (_isCatch)
            {
                return;
            }
            if (_isDeadAniExist)
            {
                _isCatch = true;
                //				CCArmatureAnimation* animation = m_fish->getAnimation();
                //				animation->play("Died", -1, -1, 0);
                //				m_fish->setOpacity(255);
                //				m_fish->setColor(ccc3(255, 255, 255));
            }
        }


        public function dataInit():void
        {

            _pivotOffsetX = 20;
            _pivotOffsetY = 10;
            _isReverse = false;
            _playDeadAni = true;
            _curHitTime = 0;
            _curReverseHitTime = 0;
            _fish.pivotX = _pivotX;
            _fish.pivotY = _pivotY;

            _fishRunTime = 0;
            _hitValue = 0;
            _fishShowDelay = 0;
            _hitColorChangeLastTime = ConfigManager.getConfValue("cfg_fish", _fishId, "hit_time") as Number;
            _hitColorChangeTime = ConfigManager.getConfValue("cfg_fish", _fishId, "hit_time") as Number;

            _clearUpDir = 1;
            _clearUpTotalTime = 0;
            _clearUpCastTime = 0;

            _dieAlpha = false;
            _dieAlphaRunTime = 1;
            _dieAlphaTime = 1;
            _uniId = -1;
            _isCatch = false;
            _isCollision = false;
            _runOver = false;
            _fish.visible = true;
            _calRect = false;
            _fish.alpha = 1;
            _fish.filters = [];
            _fish.visible = true;
            if (_fish is SpineTemplet)
            {
                var spineAni:SpineTemplet = _fish as SpineTemplet;
                var parent:Sprite = _fish.parent as Sprite;
                _fish.removeSelf();
                _fish = new SpineTemplet(_fishName);


                parent.addChild(_fish);
                //			spineAni.paused();
                spineAni.play(0, true);
                spineAni.setScale(1, 1);
            }
            else
            {
                var aniTmp:GameAnimation = _fish as GameAnimation;
                aniTmp.play(0, true);
                _fish.scale(1, 1, true);
            }

            if (_boomSelectSprite)
            {
                _boomSelectSprite.visible = false;
            }
            if (_fishParent)
            {
                _fishParent.visible = true;
            }

            if (_lineTest)
            {
                _lineTest.visible = true;
            }
            if (_specSprite)
            {
                _specSprite.visible = true;
            }
            if (_fishSwimPathIdFont)
            {
                _fishSwimPathIdFont.visible = true;
            }
            if (_lockSprite)
            {
                _lockSprite.visible = false;
            }
            if (_fishMoneyBag)
            {
                _fishMoneyBag.visible = true;
                _fishMoneyBag.play("H5_qiandai_youdong", true);
            }
            if (_fishMoneyBagBomb)
            {
                _fishMoneyBagBomb.visible = false;
            }
            if (_fishMoneyBagParent)
            {
                _fishMoneyBagParent.visible = true;
            }

            _absorbedRunTime = 0;
            _absorbedDeltaX = 0;
            _absorbedDeltaY = 0;
            _absorbed = false;
            _dieCatchInfo = null;


        }

        public function init(id:int, parent:Sprite):void
        {
            var i:int = 0;
            var width:Number = 0;
            var height:Number = 0;
            var tmp:int = 0;
            var configName:String;

            var maxNum:int = 1;//todo:从配置表中读取，某条鱼最多出生条数
            _fishId = id;

            _collisionOffsetX = [];
            _collisionOffsetY = [];
            _collisionRadius = [];
            _collisionAngleP1 = [];
            _collisionAngleP2 = [];
            _collisionCenterFishPosAngle = [];
            _collisionCenterFishPosMirrorAngle = [];
            _collisionCenterFishPosLength = [];
            _change_num = ConfigManager.getConfValue("cfg_fish", id, "change_num") as int;
            _shakeArr = ConfigManager.getConfValue("cfg_fish", id, "shock") as Array;
            _boomCatch = ConfigManager.getConfValue("cfg_fish", id, "boom") as int;
            _fishName = ConfigManager.getConfValue("cfg_fish", id, "aniName") as String;
            _specFlag = ConfigManager.getConfValue("cfg_fish", id, "spec_flag") as int;
            _catchShow = ConfigManager.getConfValue("cfg_fish", id, "catch_show") as int;
            _catchType = ConfigManager.getConfValue("cfg_fish", id, "ctype") as int
            _catchShowRate = ConfigManager.getConfValue("cfg_fish", id, "catch_show_rate") as int;
            _catchType = ConfigManager.getConfValue("cfg_fish", id, "ctype") as int;
            _hitActionExist = (ConfigManager.getConfValue("cfg_fish", id, "hitAni") as int) == 1;

            _fishScale = ConfigManager.getConfValue("cfg_fish", id, "scale") as Number;
            _fishFrameNum = ConfigManager.getConfValue("cfg_anicollision", _fishName, "anilength") as int;
            _fishSwimRefL = ConfigManager.getConfValue("cfg_anicollision", _fishName, "refL") as Number;
            _fishSwimSpeedBase = (GameConst.fixed_update_time * 1000 * _fishSwimRefL) / _fishFrameNum;
            _calMal = ConfigManager.getConfValue("cfg_anicollision", _fishName, "calMax") as Number;
            _fishAniSpeedChange = (ConfigManager.getConfValue("cfg_anicollision", _fishName, "change") as int) == 1;
            _fishAniMaxInterval = ConfigManager.getConfValue("cfg_anicollision", _fishName, "aniSpeed") as Number;
            //			if(GameConst.draw_collision_rect)
            {
                {
                    for (i = 0; i < 5; i++)
                    {
                        tmp = i + 1;
                        configName = "colliWidth" + tmp;
                        width = _fishScale * (ConfigManager.getConfValue("cfg_anicollision", _fishName, configName) as Number);
                        if (width > 0)
                        {
                            configName = "colliHeight" + tmp;
                            height = _fishScale * (ConfigManager.getConfValue("cfg_anicollision", _fishName, configName) as Number);
                            configName = "colliOffsetX" + tmp;
                            _collisionOffsetX[i] = _fishScale * (ConfigManager.getConfValue("cfg_anicollision", _fishName, configName) as Number);
                            configName = "colliOffsetY" + tmp;
                            _collisionOffsetY[i] = _fishScale * (ConfigManager.getConfValue("cfg_anicollision", _fishName, configName) as Number);
                            _collisionRadius[i] = Math.sqrt(width * width + height * height);
                            _collisionAngleP1[i] = -Math.acos(width / _collisionRadius[i]) / Math.PI * 180;
                            _collisionAngleP2[i] = -_collisionAngleP1[i];
                            _collisionCenterFishPosAngle[i] = GameTools.CalLineAngleP4(0, 0, _collisionOffsetX[i], _collisionOffsetY[i]);
                            _collisionCenterFishPosMirrorAngle[i] = GameTools.CalLineAngleP4(0, 0, -_collisionOffsetX[i], _collisionOffsetY[i]);
                            _collisionCenterFishPosLength[i] = GameTools.CalPointLenP4(0, 0, _collisionOffsetX[i], _collisionOffsetY[i]);
                        }
                        else
                        {
                            break;
                        }
                    }
                }
                _collisionCount = i;
            }
            //第六个碰撞区域为鱼本身的区域(检测鱼是否游出屏幕)
            tmp = 6;
            configName = "colliWidth" + tmp;
            width = _fishScale * (ConfigManager.getConfValue("cfg_anicollision", _fishName, configName) as Number);
            if (width > 0)
            {
                configName = "colliHeight" + tmp;
                height = _fishScale * (ConfigManager.getConfValue("cfg_anicollision", _fishName, configName) as Number);
                configName = "colliOffsetX" + tmp;
                _fishOffsetX = _fishScale * (ConfigManager.getConfValue("cfg_anicollision", _fishName, configName) as Number);
                configName = "colliOffsetY" + tmp;
                _fishOffsetY = _fishScale * (ConfigManager.getConfValue("cfg_anicollision", _fishName, configName) as Number);
                _fishRadius = Math.sqrt(width * width + height * height);
                _fishAngleP1 = -Math.acos(width / _fishRadius) / Math.PI * 180;
                _fishAngleP2 = -_fishAngleP1;
                _fishCenterFishPosAngle = GameTools.CalLineAngleP4(0, 0, _fishOffsetX, _fishOffsetY);
                _fishCenterFishPosMirrorAngle = GameTools.CalLineAngleP4(0, 0, -_fishOffsetX, _fishOffsetY);
                _fishCenterFishPosLength = GameTools.CalPointLenP4(0, 0, _fishOffsetX, _fishOffsetY);
            }
            else
            {
            }
            var rect:Rectangle;
            if (_specFlag > 0)
            {
                _specSprite = new Sprite();
                _specSprite.loadImage("ui/fight/flag_" + _specFlag + ".png");
                rect = _specSprite.getBounds();
                _specSprite.pivot(rect.width / 2, rect.height / 2);
            }
            if (_change_num > 0)
            {
                var wagesOffsetX:Number = ConfigManager.getConfValue("cfg_fish", id, "wagesX") as int;
                var wagesOffsetY:Number = ConfigManager.getConfValue("cfg_fish", id, "wagesY") as int;
                var _specParent:Sprite = new Sprite();
                _specSprite = new Sprite();
                _specSprite.loadImage(ConfigManager.getConfValue("cfg_fish", id, "change_img") as String);//("ui/fight/exchange.png");
                rect = _specSprite.getBounds();
                _specSprite.pivot(rect.width / 2, rect.height / 2);
                _specParent.addChild(_specSprite);
                _specSprite.x = wagesOffsetX;
                _specSprite.y = wagesOffsetY;
                _specSprite = _specParent;
				
            }

            if (_specSprite && _change_num <= 0)
            {
                parent.addChild(_specSprite);
            }

            var aniType:int = ConfigManager.getConfValue("cfg_anicollision", _fishName, "aniType") as int;

            if (aniType == GameConst.ani_type_frame)
            {
                _fish = FishAniManager.instance.load(_fishName);
                _group = ConfigManager.getConfValue("cfg_fish", id, "group") as int;
                _fish.pivot(ConfigManager.getConfValue("cfg_anicollision", _fishName, "pivotX") as int,
                        ConfigManager.getConfValue("cfg_anicollision", _fishName, "pivotY") as int);
            }
            else
            {
                _fish = new SpineTemplet(_fishName);
            }


            //			if(_fish is SpineTemplet)
            //			{
            //				var spineAni:SpineTemplet = _fish as SpineTemplet;
            //				spineAni.play(0, true);
            //			}
            //			else
            //			{
            //				var aniTmp:Animation = _fish as Animation;
            //				aniTmp.play(0, true);
            //			}

            parent.addChild(_fish);


            //todo
            _fish.scale(_fishScale, _fishScale, true);

            //判断是否可作为炸弹的目标
            if (1 == _boomCatch)
            {
                var ani:SpineTemplet;
                ani = new SpineTemplet("suoding");
                _boomSelectSprite = ani;
                _boomSelectSprite.zOrder = 1;
                parent.addChild(_boomSelectSprite);
            }

            if (GameConst.fish_catch_type_boss == _catchType)
            {
                var moneyBagName:String = "qiandaiyoudong";
                _fishMoneyBagParent = new Sprite();
                _fishMoneyBag = new SpineTemplet(moneyBagName);//AnimalManger.instance.load(moneyBagName);
                _fishMoneyBag.pivot((ConfigManager.getConfValue("cfg_anicollision", moneyBagName, "pivotX") as int),
                        ConfigManager.getConfValue("cfg_anicollision", moneyBagName, "pivotY") as int);
                _fishMoneyBagParent.pivot(-250, 0);
                _fishMoneyBagParent.addChild(_fishMoneyBag);
                _fishMoneyBagParent.zOrder = 1;
                parent.addChild(_fishMoneyBagParent);
                _fishMoneyBag.play("H5_qiandai_youdong", true);
            }

            //todo
            //			_speed = ConfigManager.getConfValue("cfg_fish",id,"speed") as Number;
            //			var pos_x:Number = 0;
            //			var pos_y:Number = 0;
            //			var pos:Point = new Point();
            //			var angle:Number;
            //
            //			setFishPosition(pos.x, pos.y);
            //			setRotation(angle);


            //			calDeltaXY();

            if (GameConst.draw_collision_rect)
            {
                _lineTest = new Sprite();
                parent.addChild(_lineTest);
            }

            if (GameConst.show_fish_swim_path_id)
            {
                _fishSwimPathIdFont = new FontClip("font/font_1.png", "/.+-0123456789枚万亿");
                parent.addChild(_fishSwimPathIdFont);
                _fishSwimPathIdFont.anchorX = 0.5;
                _fishSwimPathIdFont.anchorY = 0.5;
            }

            _pivotX = _fish.pivotX;
            _pivotY = _fish.pivotY;

            if (_specSprite && _change_num > 0)
            {
                parent.addChild(_specSprite);
            }

            dataInit();


        }

        public function setFishPosition(pos_x:Number, pos_y:Number):void
        {
            _fish.pos(pos_x, pos_y, true);
            if (_specSprite)
            {
                _specSprite.pos(pos_x, pos_y, true);
                //_specSprite.zOrder = pos_y;
            }
            if (_fishMoneyBagParent)
            {
                _fishMoneyBagParent.pos(pos_x, pos_y, true);
            }
            if (_boomSelectSprite)
            {
                _boomSelectSprite.pos(pos_x, pos_y, true);
            }
            if (_lockSprite)
            {
                _lockSprite.pos(pos_x, pos_y, true);
            }
            //_fish.zOrder = pos_y;
            if (_lineTest)
            {
                //_lineTest.zOrder = pos_y + 1;
            }
            if (_fishSwimPathIdFont)
            {

                _fishSwimPathIdFont.pos(pos_x, pos_y, true);
                //_fishSwimPathIdFont.zOrder = pos_y + 2
            }
        }

        public function calDeltaXY():void
        {
            //			var angle:Number = getRotation();
            //			var radian:Number = angle * Math.PI / 180;
            //			_deltaX = Math.cos(radian);
            //			_deltaY = Math.sin(radian);
            //todo
            //_fishParent.pos(-_deltaX * _fishLength / 2, _deltaY * _fishLength  / 2);
            //			if(_fitRef)
            //			{
            //				_fishParent.zOrder = -1000;
            //			}
            //			else
            //			{
            //				_fishParent.zOrder = Math.floor(Laya.stage.height - getCenterPosition().y);
            //			}
        }

        private var _centerPos:Point = new Point();

        public function getCenterPosition():Point
        {
            _centerPos.x = _fish.x;
            _centerPos.y = _fish.y;
            return _centerPos;
        }

        private var _getDesignPos:Point = new Point();

        public function getDesignPos():Point
        {
            //var ret:Point = new Point();
            _getDesignPos.x = _designPos.x;
            _getDesignPos.y = _designPos.y;
            return _getDesignPos;
        }

        public function getBlackHolePosX():Number
        {
            return _absorbedX;
        }

        public function getBlackHolePosY():Number
        {
            return _absorbedY;
        }

        public function getRotation():Number
        {
            var angle:Number = 0;
            //			if(!_isMirror)
            //			{
            //				angle = _fish.rotation;
            //				return angle;
            //			}
            //			angle = _fish.rotation;
            //			if(_fish.scaleX < 0)
            //			{
            //				angle = 180 + angle;
            //			}
            angle = _fish.rotation;

            return angle;
        }

        //		public function SetGroupPath():void
        //		{
        //
        //		}

        public function get shakeArr():Array
        {
            return _shakeArr;
        }

        public function setRotation(angle:Number):void
        {
            if (_fish.scaleX < 0)
            {
                if (angle >= 180 && angle <= 360)
                {
                    angle -= 180;
                }
                else if (angle >= 0 && angle <= 180)
                {
                    angle += 180;
                }
            }
            _fish.rotation = angle;
            if (_fishMoneyBagParent)
            {
                _fishMoneyBagParent.rotation = angle
            }
            if (_specSprite && _change_num > 0)
            {
                _specSprite.rotation = angle;
            }
        }

        private function showRedBack():void
        {
            var redMat:Array;
            var redFilter:ColorFilter;
            var spine:SpineTemplet;
            redMat = [
                1, 0, 0, 0, 0, //R
                0, 0, 0, 0, 0, //G
                0, 0, 0, 0, 0, //B
                0, 0, 0, 1, 0, //A
            ];
            redFilter = new ColorFilter(redMat);
            if (_fish is GameAnimation)
            {
                _fish.filters = [redFilter];
            } else
            {
                spine = _fish as SpineTemplet;
                spine.setFilters([redFilter]);
            }
        }

        private var _curHitTime:Number = 0;
        private var _curReverseHitTime:Number = 0;

        private var _totalHitTime:Number = 200 / 1000;
        private var _reverseHitTime:Number = 2000 / 1000;
        private var _isReverse:Boolean = false;

        private var _pivotOffsetX:Number = 20;
        private var _pivotOffsetY:Number = 10;


        private function hitUpdate(delta:Number):void
        {
            //        var delta:Number = Laya.timer.delta;

            if (_fish is SpineTemplet)
            {
                return;
            }

            if (_hitColorChangeTime >= (_totalHitTime + _reverseHitTime))
            {
                return;
            }


            if (!_isReverse)
            {
                _curHitTime += delta;
                _fish.pivotX = Ease.backOut(_curHitTime, _pivotX, _pivotOffsetX, _totalHitTime, 0);
                _fish.pivotY = Ease.backOut(_curHitTime, _pivotY, _pivotOffsetY, _totalHitTime, 0);
                if (_curHitTime >= _totalHitTime)
                {
                    _isReverse = true
                }
            } else
            {
                _curReverseHitTime += delta
                _fish.pivotX = Ease.backOut(_curReverseHitTime, _pivotX + _pivotOffsetX, -_pivotOffsetX, _reverseHitTime, 0);
                _fish.pivotY = Ease.backOut(_curReverseHitTime, _pivotY + _pivotOffsetY, -_pivotOffsetY, _reverseHitTime, 0);

                if (_curReverseHitTime >= _reverseHitTime)
                {
                    //                Laya.timer.clear(this, hitUpdate)
                    _fish.pivotX = _pivotX;
                    _fish.pivotY = _pivotY;
                    _curHitTime = 0;
                    _curReverseHitTime = 0;
                    _isReverse = false;
                }
            }
        }

        private function showHit():void
        {
            if (_hitColorChangeTime >= _hitColorChangeLastTime)
            {
                _hitColorChangeTime = 0;
                //            Laya.timer.frameLoop(1, this, hitUpdate, []);
            }
        }

        private function clearRed():void
        {
            var spine:SpineTemplet;
            if (_fish is GameAnimation)
            {
                _fish.filters = [];
            }
            else
            {
                spine = _fish as SpineTemplet;
                spine.setFilters([]);
            }
        }


        //播放骨骼受击动画
        private function playHitSpine():void
        {
            var spine:SpineTemplet = _fish as SpineTemplet;
            if (_hitColorChangeTime >= _hitColorChangeLastTime)
            {

                _hitColorChangeTime = 0;
                spine.play(1, false, new Handler(this, function ()
                {

                    spine.play(0, true);
                    if (_freezeTime > 0)
                    {
                        spine.paused();
                    }
                }))
            }
        }


        public function updateHitState(delta:Number, hitStart:Boolean, onlineSync:Boolean):void
        {
            if (!_fish)
            {
                return;
            }
            _hitColorChangeTime += delta
            //if (_hitActionExist) {

            if (_fish is SpineTemplet)
            {
                if (hitStart)
                {
                    playHitSpine();
                }
            }
            else
            {
                if (hitStart)
                {
                    showHit();
                }
            }
        }


        public function getFishSizeType():int
        {
            return _fishSizeType;
        }

        private function udpateMirrorInfo():void
        {

            var pathMirror:int = ConfigManager.getConfValue("cfg_fishgrouppath", _pathId, "mirror") as int;
            var pathScaleX:int = 1;
            var seatScaleX:int = 1;
            if (_fishSwimPathIdFont)
            {
                _fishSwimPathIdFont.value = String(_pathId);
            }


            if ((_mirror == GameConst.fish_path_mirror_x ||
                            _mirror == GameConst.fish_path_mirror_xy))
            {
                if (1 == pathMirror)
                {
                    pathScaleX = 1;
                }
                else
                {
                    pathScaleX = -1;
                }
            }
            else
            {
                if (1 == pathMirror)
                {
                    pathScaleX = -1;
                }
                else
                {
                    pathScaleX = 1;
                }
            }

            if (FightM.instance.getOwnSeatMirrorType() == GameConst.fish_path_mirror_x ||
                    FightM.instance.getOwnSeatMirrorType() == GameConst.fish_path_mirror_xy)
            {
                seatScaleX = -1;
            }

            _fish.scaleX = pathScaleX * seatScaleX;
            if (_fishMoneyBagParent)
            {
                _fishMoneyBagParent.scaleX = pathScaleX * seatScaleX;
            }
            if (_specSprite && _change_num > 0)
            {
                _specSprite.scaleX = pathScaleX * seatScaleX;
                var realSprite:Sprite = _specSprite.getChildAt(0) as Sprite;
                if (_specSprite.scaleX < 0)
                {
                    realSprite.scaleX = -1;
                }
                else
                {
                    realSprite.scaleX = 1;
                }
            }
        }

        private var _bezierPrePos:Point = new Point();

        private function calPrePos(tickNum:int):void
        {
            _fishRunTime = GameConst.fixed_update_time * tickNum;
            _segNum = 1;
            var segsTime:Array = pathSegTimes[_pathId as String];
            var segTime:Object = segsTime[_segNum - 1];
            while (_fishRunTime > segTime.endTime)
            {
                _segNum++;
                segTime = segsTime[_segNum - 1];
            }

            var path_arr:Array = ConfigManager.getConfValue("cfg_fishgrouppath", _pathId, "path") as Array;
            var segInfo:Array = ConfigManager.getConfValue("cfg_fishgrouppath", _pathId, "segInfo") as Array;
            var t:Number = (_fishRunTime - segTime.startTime) / segTime.lastTime;
            var minusT:Number = 1 - t;
            var pointBegin:int = (_segNum - 1) * 2;
            var bezierPointBegin:int = (_segNum - 1) * 3;
            var scrX:Number = path_arr[pointBegin];
            var scrY:Number = path_arr[pointBegin + 1];
            var desX:Number = path_arr[pointBegin + 2];
            var desY:Number = path_arr[pointBegin + 3];
            var bezierX:Number = segInfo[bezierPointBegin];
            var bezierY:Number = segInfo[bezierPointBegin + 1];
            var segLen:Number = segInfo[bezierPointBegin + 2];
            var curFishPos:Point = getCenterPosition();
            var angle:Number = getRotation();
            var powMinusT:Number = minusT * minusT;
            var powT:Number = t * t;
            var tmultiMinus:Number = 2 * t * minusT;
            _bezierPrePos.x = bezierX;
            _bezierPrePos.y = bezierY;

            _bezierPrePos.x = powMinusT * scrX + tmultiMinus * bezierX + powT * desX;
            _bezierPrePos.y = powMinusT * scrY + tmultiMinus * bezierY + powT * desY;

            _bezierPrePos.x = _bezierPrePos.x + _offX;
            _bezierPrePos.y = _bezierPrePos.y + _offY;
            getMirrorData(_bezierPrePos.x, _bezierPrePos.y, _bezierPrePos);
            _designPos.x = _bezierPrePos.x;
            _designPos.y = _bezierPrePos.y;
            setFishPosition(GameTools.designPosXMapScreenPosX(_designPos.x), GameTools.designPosYMapScreenPosY(_designPos.y));
        }

        private function variableSpeedUpdate(delta:Number):void
        {
            _fishRunTime += delta;

            var segsTime:Array = pathSegTimes[_pathId as String];
            var segTime:Object = segsTime[_segNum - 1];

            if (_fishRunTime > segTime.endTime)
            {
                var maxSegNum:int = ConfigManager.getConfValue("cfg_fishgrouppath", _pathId, "segNum") as int;
                if (_segNum >= maxSegNum)
                {
                    if (_ipath < _path.length)
                    {
                        _ipath = _ipath + 1;
                        _pathId = _path[_ipath - 1];
                        _segNum = 1;
                        _loop = ConfigManager.getConfValue("cfg_fishgrouppath", _pathId, "loop") as int;
                        segsTime = pathSegTimes[_pathId as String];
                        segTime = segsTime[_segNum - 1];
                        _fishRunTime = delta;
                        udpateMirrorInfo();
                    }
                    else
                    {
                        _runOver = true;
                        return;
                    }
                }
                else
                {
                    _segNum = _segNum + 1;
                    segTime = segsTime[_segNum - 1];
                }
            }
            var path_arr:Array = ConfigManager.getConfValue("cfg_fishgrouppath", _pathId, "path") as Array;
            var segInfo:Array = ConfigManager.getConfValue("cfg_fishgrouppath", _pathId, "segInfo") as Array;
            var t:Number = (_fishRunTime - segTime.startTime) / segTime.lastTime;
            var minusT:Number = 1 - t;
            var pointBegin:int = (_segNum - 1) * 2;
            var bezierPointBegin:int = (_segNum - 1) * 3;
            var scrX:Number = path_arr[pointBegin];
            var scrY:Number = path_arr[pointBegin + 1];
            var desX:Number = path_arr[pointBegin + 2];
            var desY:Number = path_arr[pointBegin + 3];
            var bezierX:Number = segInfo[bezierPointBegin];
            var bezierY:Number = segInfo[bezierPointBegin + 1];
            var segLen:Number = segInfo[bezierPointBegin + 2];
            var curFishPos:Point = getCenterPosition();
            var angle:Number = getRotation();
            var powMinusT:Number = minusT * minusT;
            var powT:Number = t * t;
            var tmultiMinus:Number = 2 * t * minusT;
            _bezierPrePos.x = bezierX;
            _bezierPrePos.y = bezierY;
            _bezierPrePos.x = powMinusT * scrX + tmultiMinus * bezierX + powT * desX;
            _bezierPrePos.y = powMinusT * scrY + tmultiMinus * bezierY + powT * desY;

            _bezierPrePos.x = _bezierPrePos.x + _offX;
            _bezierPrePos.y = _bezierPrePos.y + _offY;
            getMirrorData(_bezierPrePos.x, _bezierPrePos.y, _bezierPrePos);

            if (_fish && _fishAniSpeedChange)
            {
                var swimLen:Number = GameTools.CalPointLen(_bezierPrePos, _designPos);
                if (swimLen > 0)
                {
                    var tmpInterval:Number = _fishSwimSpeedBase / swimLen;//(delta * 1000 * _fishSwimRefL / swimLen) / _fishFrameNum;
                    var tmpAni:GameAnimation = _fish as GameAnimation;
                    if (tmpInterval > _fishAniMaxInterval)
                    {
                        tmpInterval = _fishAniMaxInterval;
                    }
                    tmpAni.interval = tmpInterval;
                }
            }

            if (_bezierPrePos.x != _designPos.x || _bezierPrePos.y != _designPos.y)
            {
                angle = GameTools.CalLineAngle(_designPos, _bezierPrePos);
            }
            _designPos.x = _bezierPrePos.x;
            _designPos.y = _bezierPrePos.y;
            setRotation(angle);
            setFishPosition(GameTools.designPosXMapScreenPosX(_designPos.x), GameTools.designPosYMapScreenPosY(_designPos.y));
            _calRect = false;

        }

        public function fixedTimeUpdate(delta:Number):void
        {


            if (_clearUpTotalTime > 0)
            {
                _clearUpCastTime += delta;
                if (_clearUpCastTime >= _clearUpTotalTime)
                {
                    _runOver = true;
                    return;
                }
                else
                {
                    var refPoint:Point = getCenterPosition();
                    if (1 == _clearUpDir)
                    {
                        if (refPoint.x <= (_clearUpCastTime / _clearUpTotalTime * Laya.stage.width))
                        {
                            _runOver = true;
                            return;
                        }
                    }
                    else
                    {
                        if (refPoint.x >= (Laya.stage.width - _clearUpCastTime / _clearUpTotalTime * Laya.stage.width))
                        {
                            _runOver = true;
                            return;
                        }
                    }
                }
            }
            if (_runOver)
            {
                return;
            }
            if (_freezeTime > 0)
            {
                _freezeTime -= delta;
                if (_freezeTime <= 0)
                {
                    //					_fish.play(_fish.index, true);
                    if (_fish is SpineTemplet)
                    {
                        var spineAni:SpineTemplet = _fish as SpineTemplet;
                        spineAni.resume();
                    }
                    else
                    {
                        var aniTmp:GameAnimation = _fish as GameAnimation;
                        aniTmp.play(aniTmp.index, true);
                    }

                    if (_fishMoneyBag)
                    {
                        //_fishMoneyBag.play(_fishMoneyBag.index, 0);
                        _fishMoneyBag.resume();
                    }
                }
                return;
            }
            //        if (_callDelay > 0) {
            //            _callDelay -= delta;
            //            var mirrorX:int = 1;
            //            if (_fish.scaleX < 0) {
            //                mirrorX = -1;
            //            }
            //            if (_callDelay > 0) {
            //                var callDelayTotal:Number = ConfigManager.getConfValue("cfg_fish", _fishId, "callEffectTime") as Number;
            //                var tmpScale:Number = (callDelayTotal - _callDelay) * _fishScale / callDelayTotal;
            //                _fish.scale(tmpScale * mirrorX, tmpScale);
            //            }
            //            else {
            //                _fish.scale(mirrorX, 1);
            //            }
            //
            //            return;
            //        }
            _tickNum += 1;
            variableSpeedUpdate(delta);
            if (_specSprite && _change_num <= 0)
            {
                _specSprite.rotation = _specSprite.rotation + delta * 50;
            }
        }

        public function getMirrorData(x:Number, y:Number, ret:Point):void
        {
            if (_mirror == GameConst.fish_path_mirror_x)
            {
                x = GameConst.design_width - x;//Laya.stage.width - x;
            }
            else if (_mirror == GameConst.fish_path_mirror_y)
            {
                y = GameConst.design_height - y;//Laya.stage.height - y;
            }
            else if (_mirror == GameConst.fish_path_mirror_xy)
            {
                x = GameConst.design_width - x;//Laya.stage.width - x;
                y = GameConst.design_height - y;//Laya.stage.height - y;
            }

            x = FightM.instance.getMirrorPosXByOwnSeat(x);
            y = FightM.instance.getMirrorPosYByOwnSeat(y);


            ret.x = x;
            ret.y = y;
        }

        private function innerUpdate(delta:Number):void
        {
            _updateCount += 1;

            updateHitState(delta, false, false);

            if (_absorbed)
            {
                var scaleX:Number = 1;
                if (_fish.scaleX < 0)
                {
                    scaleX = -1;
                }
                _absorbedRunTime += delta;
                _fish.x = GameTools.designPosXMapScreenPosX(_designPos.x + _absorbedDeltaX * _absorbedRunTime);//_fish.x + _absorbedDeltaX * delta;
                _fish.y = GameTools.designPosYMapScreenPosY(_designPos.y + _absorbedDeltaY * _absorbedRunTime);//_fish.y + _absorbedDeltaY * delta;
                _fish.rotation = _fish.rotation + delta * _absorbedAngleChange;
                var scale:Number = (_absorbedTotalTime - _absorbedRunTime) / _absorbedTotalTime;
                _fish.scale(scaleX * scale, scale);
                if (_absorbedRunTime >= _absorbedTotalTime)
                {
                    _isCatch = true;
                    _dieAlpha = true;
                    _dieAlphaRunTime = -1;
                }
                return;
            }
            if (_dieAlpha)
            {
                _dieAlphaRunTime -= delta;
                if (_dieAlphaRunTime < 0)
                {
                    _fish.alpha = 0;
                }
                else
                {
                    _fish.alpha = _dieAlphaRunTime / _dieAlphaTime;
                }
                _delayDie -= delta;
                return;
            }

            if (_isCatch || _runOver)
            {
                return;
            }


            //for(var i:int = 0; i < _updateRate; i++)
            {
                fixedTimeUpdate(GameConst.fixed_update_time);
            }
            if (GameConst.draw_collision_rect)
            {
                //				_fish.rotation = 0;
                //				_fish.pos(Laya.stage.width / 2, Laya.stage.height / 2);
                DrawCollisionRect();
                return;
            }
        }

        public function update(delta:Number):void
        {

            innerUpdate(delta);
            hitUpdate(delta);
        }

        public static function initPathInfo(pathId:int):void
        {
            var pathInfo:Object = ConfigManager.getConfObject("cfg_fishgrouppath", pathId);
            if (!pathInfo.segTime)
            {
                pathInfo.maxTick = Math.ceil(pathInfo.time / GameConst.fixed_update_time);
                pathInfo.segNum = pathInfo.path.length / 2 - 1;
                var startTime:Number = 0;
                var endTime:Number = 0;
                var i:int = 0;
                var tmp:Array = [];
                pathSegTimes[pathId as String] = tmp;
                for (i = 0; i < pathInfo.segNum; i++)
                {
                    var tmpTime:Object = new Object();
                    tmp[i] = tmpTime;
                    endTime = pathInfo.segInfo[i * 3 + 2];
                    tmpTime.lastTime = endTime - startTime;
                    tmpTime.startTime = startTime;
                    tmpTime.endTime = endTime;
                    startTime = endTime;
                }
            }
        }

        private function getPathRunTick(pathId:int):int
        {
            var pathInfo:Object = ConfigManager.getConfObject("cfg_fishgrouppath", pathId);
            return pathInfo.maxTick;
        }

        public function kill():void
        {
            _isCatch = true;
            _playDeadAni = false;
        }

        public function addDieRunTime(addTime:Number):void
        {
            _dieAlphaRunTime += addTime;
        }

        public function syncOnlineData(info:ProtoFishInfo):Boolean
        {

            var i:int = 0;
            var createTick:int = info.getStartTick();
            var freezeStartTick:int = info.getFreezeStartTick();
            var runTick:int = 0;
            var freezeTotalTick:int = 500;
            var delayMaxTick:int = info.getDelayTickNum();
            var callMaxTick:int = info.getcalldelayTickNum();
            var pathRunTick:int = 0;
            var extraMaxTick:int = info.getExtraTick();
            runTick = FightManager.instance.getRunTick(createTick);
            _delayDie = info.getDelayDie();
            _path = info.getPath();
            _mirror = info.getMirror();
            _offX = info.getOffX();
            _offY = info.getOffY();
            _uniId = info.getUniId();

            _freezeTime = 0;
            var freezeLeftTick:int = 0;
            if (freezeStartTick > 0)
            {
                freezeLeftTick = freezeTotalTick - FightManager.instance.getRunTick(freezeStartTick);
                _freezeTime = freezeLeftTick * GameConst.fixed_update_time;
                if (freezeLeftTick < 0)
                {
                    freezeLeftTick = 0;
                }
            }

            //call
            //        if (freezeStartTick >= 0) {
            //            _callDelay = -1;
            //        }
            //        else if (callMaxTick > 0) {
            //            _callDelay = (callMaxTick - (runTick - delayMaxTick)) * GameConst.fixed_update_time;
            //        }
            //        else {
            //            _callDelay = -1;
            //        }

            var delayDieUseTick:int = 0;
            _isCatch = info.isCatch();
            if (_isCatch)
            {
                var catchSound:String = ConfigManager.getConfValue("cfg_fish", _fishId, "CatchSound") as String;
                var deadAni:String = ConfigManager.getConfValue("cfg_fish", _fishId, "dead_ani") as String;
                if (catchSound.length > 0)
                {
                    GameSoundManager.playSound(catchSound);
                }
                if (_playDeadAni)
                {
                    FightManager.instance.playFishDeadAni(deadAni, getCenterPosition());
                }
                if (_delayDie > 0)
                {
                    var totalDelayDie:Number = ConfigManager.getConfValue("cfg_fish", _fishId, "catch_time") as Number;
                    var blackHoleEffect:String = ConfigManager.getConfValue("cfg_fish", _fishId, "show_ani_name") as String;
                    var showRange:Array = ConfigManager.getConfValue("cfg_fish", _fishId, "show_ani_range") as Array;
                    _absorbedX = _designPos.x;//_fish.x;
                    _absorbedY = _designPos.y;//_fish.y;
                    if (_absorbedX < showRange[0])
                    {
                        _absorbedX = showRange[0];
                    }
                    if (_absorbedX > showRange[1])
                    {
                        _absorbedX = showRange[1];
                    }
                    if (_absorbedY < showRange[2])
                    {
                        _absorbedY = showRange[2];
                    }
                    if (_absorbedY > showRange[3])
                    {
                        _absorbedY = showRange[3];
                    }
                    //				_absorbedX = GameTools.designPosXMapScreenPosX(_absorbedX);
                    //				_absorbedY = GameTools.designPosYMapScreenPosY(_absorbedY);
                    FightManager.instance.playBlackHoleEffect(blackHoleEffect, totalDelayDie - _delayDie, GameTools.designPosXMapScreenPosX(_absorbedX), GameTools.designPosYMapScreenPosY(_absorbedY));//_absorbedX, _absorbedY);
                    delayDieUseTick = Math.ceil((totalDelayDie - _delayDie) / GameConst.fixed_update_time);
                    _dieAlphaRunTime = -1;
					if(_specSprite)
					{
						_specSprite.visible = false;
					}
                }
            }

            //path
            pathRunTick = runTick - extraMaxTick + freezeLeftTick - delayDieUseTick;
            if (pathRunTick <= 0)
            {
                pathRunTick = 1;
            }

            _tickNum = -1;
            var pathTotalTick:int = 0;

            for (i = 0; i < _path.length; i++)
            {
                pathTotalTick = getPathRunTick(_path[i]);
                if (pathRunTick > pathTotalTick)
                {
                    pathRunTick = pathRunTick - pathTotalTick;
                }
                else
                {
                    _ipath = i + 1;
                    _pathId = _path[i];
                    _tickNum = pathRunTick;
                    break;
                }
            }

            if (_tickNum < 0)
            {
                if (_isCatch)
                {
                    _ipath = _path.length;
                    _pathId = _path[_ipath - 1];
                    _tickNum = getPathRunTick(_pathId);
                }
                else
                {
                    //trace("tickNumError startTick = " + createTick);
                    //trace(FightManager.instance.getCurTick());
                    //trace(runTick - extraMaxTick + freezeLeftTick);
                    return false;
                }
            }

            udpateMirrorInfo();


            calPrePos(_tickNum);
            variableSpeedUpdate(GameConst.fixed_update_time);


            if (_freezeTime > 0)
            {
                if (_fish is SpineTemplet)
                {
                    var spineAni:SpineTemplet = _fish as SpineTemplet;
                    spineAni.paused();
                }
                else
                {
                    var aniTmp:GameAnimation = _fish as GameAnimation;
                    aniTmp.stop();
                }
                if (_fishMoneyBag)
                {
                    _fishMoneyBag.paused();
                }
                FightManager.instance.showFreezeEffect(_freezeTime);
            }

            //        if (_callDelay > 0) {
            //            var callDelayTotal:Number = ConfigManager.getConfValue("cfg_fish", _fishId, "callEffectTime") as Number;
            //            var tmpScale:Number = (callDelayTotal - _callDelay) * _fishScale / callDelayTotal;
            //            if (tmpScale <= 0) {
            //                tmpScale = 0.001;
            //            }
            //            var mirrorX:int = 1;
            //            if (_fish.scaleX < 0) {
            //                mirrorX = -1;
            //            }
            //            if (_callDelay > 0) {
            //                _fish.scale(tmpScale * mirrorX, tmpScale);
            //            }
            //            else {
            //                _fish.scale(mirrorX, 1);
            //            }
            //        }

            return true;
        }


        //黑洞是否被激活
        public function blackHoleActive():Boolean
        {
            if (_isCatch && _delayDie > 0)
            {
                var totalDelayDie:Number = ConfigManager.getConfValue("cfg_fish", _fishId, "catch_time") as Number;
                var startTime:Number = ConfigManager.getConfValue("cfg_fish", _fishId, "start_time") as Number;
                var endTime:Number = ConfigManager.getConfValue("cfg_fish", _fishId, "end_time") as Number;

                if (_delayDie > endTime && _delayDie < (totalDelayDie - startTime))
                {
                    return true;
                }

            }
            return false;
        }

        public function absorbed(x:Number, y:Number):void
        {
            if (!_absorbed)
            {
                _absorbed = true;
                _absorbedRunTime = 0;
                var rawPoint:Point = new Point();
                //getMirrorData(_designPos.x, _designPos.y, rawPoint);
                var startPoint:Point = _designPos;//new Point(_fish.x, _fish.y);
                var endPoint:Point = new Point(FightM.instance.getMirrorPosXByOwnSeat(x), FightM.instance.getMirrorPosYByOwnSeat(y));//new Point(x, y);
                var angle:Number = GameTools.CalLineAngle(startPoint, endPoint);
                var len:Number = GameTools.CalPointLen(startPoint, endPoint);
                var radian:Number = angle * Math.PI / 180;
                _absorbedDeltaX = Math.cos(radian) * len / _absorbedTotalTime;
                _absorbedDeltaY = Math.sin(radian) * len / _absorbedTotalTime;
            }
        }

        public function getBlackHoleRange():Number
        {
            return ConfigManager.getConfValue("cfg_fish", _fishId, "catch_range") as Number;
        }

        public function hitStart(onlineSync:Boolean):void
        {
            if (_hitColorChangeTime >= _hitColorChangeLastTime)
            {

                updateHitState(0, true, onlineSync);
                if (!onlineSync)
                {
                    var soundPath:String = ConfigManager.getConfValue("cfg_fish", _fishId, "hitSound") as String;
                    if (soundPath)
                    {
                        GameSoundManager.playSound(soundPath)
                    }
                }

            }
        }


        public function getUniId():int
        {
            return _uniId;
        }

        public function points_direction(PI:Point, PJ:Point, PK:Point):Number
        {
            return (PK.x - PI.x) * (PJ.y - PI.y) - (PK.y - PI.y) * (PJ.x - PI.x);
        }

        public function is_line_seg_intersect(P1:Point, P2:Point, Q1:Point, Q2:Point):Boolean
        {
            var d1:Number;
            var d2:Number;
            d1 = points_direction(P1, P2, Q1);
            d2 = points_direction(P1, P2, Q2);
            if (d1 * d2 > 0)
            {
                return false;
            }
            d1 = points_direction(Q1, Q2, P1);
            d2 = points_direction(Q1, Q2, P2);
            if (d1 * d2 > 0)
            {
                return false;
            }
            return true;
        }

        public function isRectIntersect():Boolean
        {
            var ret:Boolean;
            var contain:Boolean = true;
            var centerP:Point = new Point((_rectP1.x + _rectP3.x) / 2, (_rectP1.y + _rectP3.y) / 2);
            var centerQ:Point = new Point((_rectQ1.x + _rectQ3.x) / 2, (_rectQ1.y + _rectQ3.y) / 2);


            ret = is_line_seg_intersect(centerP, centerQ, _rectQ1, _rectQ2);
            if (ret)
            {
                contain = false;
            }
            ret = is_line_seg_intersect(centerP, centerQ, _rectQ2, _rectQ3);
            if (ret)
            {
                contain = false;
            }
            ret = is_line_seg_intersect(centerP, centerQ, _rectQ3, _rectQ4);
            if (ret)
            {
                contain = false;
            }
            ret = is_line_seg_intersect(centerP, centerQ, _rectQ4, _rectQ1);
            if (ret)
            {
                contain = false;
            }
            if (contain)
            {
                return true;
            }

            ret = is_line_seg_intersect(_rectP1, _rectP2, _rectQ1, _rectQ2);
            if (ret)
            {
                return true;
            }
            ret = is_line_seg_intersect(_rectP2, _rectP3, _rectQ1, _rectQ2);
            if (ret)
            {
                return true;
            }
            ret = is_line_seg_intersect(_rectP3, _rectP4, _rectQ1, _rectQ2);
            if (ret)
            {
                return true;
            }
            ret = is_line_seg_intersect(_rectP4, _rectP1, _rectQ1, _rectQ2);
            if (ret)
            {
                return true;
            }

            ret = is_line_seg_intersect(_rectP1, _rectP2, _rectQ2, _rectQ3);
            if (ret)
            {
                return true;
            }
            ret = is_line_seg_intersect(_rectP2, _rectP3, _rectQ2, _rectQ3);
            if (ret)
            {
                return true;
            }
            ret = is_line_seg_intersect(_rectP3, _rectP4, _rectQ2, _rectQ3);
            if (ret)
            {
                return true;
            }
            ret = is_line_seg_intersect(_rectP4, _rectP1, _rectQ2, _rectQ3);
            if (ret)
            {
                return true;
            }

            ret = is_line_seg_intersect(_rectP1, _rectP2, _rectQ3, _rectQ4);
            if (ret)
            {
                return true;
            }
            ret = is_line_seg_intersect(_rectP2, _rectP3, _rectQ3, _rectQ4);
            if (ret)
            {
                return true;
            }
            ret = is_line_seg_intersect(_rectP3, _rectP4, _rectQ3, _rectQ4);
            if (ret)
            {
                return true;
            }
            ret = is_line_seg_intersect(_rectP4, _rectP1, _rectQ3, _rectQ4);
            if (ret)
            {
                return true;
            }

            ret = is_line_seg_intersect(_rectP1, _rectP2, _rectQ4, _rectQ1);
            if (ret)
            {
                return true;
            }
            ret = is_line_seg_intersect(_rectP2, _rectP3, _rectQ4, _rectQ1);
            if (ret)
            {
                return true;
            }
            ret = is_line_seg_intersect(_rectP3, _rectP4, _rectQ4, _rectQ1);
            if (ret)
            {
                return true;
            }
            ret = is_line_seg_intersect(_rectP4, _rectP1, _rectQ4, _rectQ1);
            if (ret)
            {
                return true;
            }

            return false;
        }

        public function isValid():Boolean
        {
            var pathTime:Number = ConfigManager.getConfValue("cfg_fishgrouppath", _pathId, "time") as Number;
            if (_isCatch)
            {
                var dieComplete:Boolean = false;
                _dieAlpha = true;
                if (_delayDie > 0)
                {
                    return true;
                }
                if (_fishMoneyBagBomb && _fishMoneyBagBomb.visible)
                {
                    return _dieAlphaRunTime > 0 || _fishMoneyBagBomb.isPlaying();
                }
                else
                {
                    return _dieAlphaRunTime > 0;
                }

            }
            if (_runOver)
            {
                return false;
            }
            return true;
        }

        public function getRefPoint():Point
        {
            var collisionCenter:Point = getCenterPosition();
            var fishRotation:Number = getRotation();
            var collisionRef:Point;
            if (_fish.scaleX < 0)
            {
                //fishRotation = fishRotation - 180;
                collisionRef = GameTools.CalRotatePos(fishRotation + _fishCenterFishPosMirrorAngle, _fishCenterFishPosLength);
            }
            else
            {
                collisionRef = GameTools.CalRotatePos(fishRotation + _fishCenterFishPosAngle, _fishCenterFishPosLength);
            }
            collisionCenter.x += collisionRef.x;
            collisionCenter.y += collisionRef.y;
            return collisionCenter;
        }


        public function isCollisionDetect(id:int):Boolean
        {
            //			var count:int = _bulletCollision.length;
            //			var integer:int = 0;
            //			for(var i:int = 0; i < count; i++)
            //			{
            //				integer = _bulletCollision[i] as int;
            //				if(integer === id)
            //				{
            //					return true;
            //				}
            //			}
            return false;
        }


        public function collisionDetect(q1:Point, q2:Point, q3:Point, q4:Point):Boolean
        {
            if (_fishShowDelay > 0)
            {
                return false;
            }
            if (_isCatch)
            {
                return false;
            }
            if (_absorbed)
            {
                return false;
            }
            calCollisionRect();
            _rectQ1 = q1;
            _rectQ2 = q2;
            _rectQ3 = q3;
            _rectQ4 = q4;
            var i:int;
            for (i = 0; i < _collisionCount; i++)
            {
                _rectP1 = _calRectInfo[i][0];
                _rectP2 = _calRectInfo[i][1];
                _rectP3 = _calRectInfo[i][2];
                _rectP4 = _calRectInfo[i][3];

                if (isRectIntersect())
                {
                    return true;
                }
            }
            return false;
        }

        private static var _collisionCenterPos:Point = new Point();

        public function calCollisionRect():void
        {
            if (!_calRect)
            {
                var fishRadius:Number;
                var angleP1:Number;
                var angleP2:Number;
                var collisionCenter:Point = _collisionCenterPos;//new Point();
                var collisionRef:Point;
                var fishRotation:Number = getRotation();
                _calRect = true;
                for (var i:int = 0; i < _collisionCount; i++)
                {
                    if (!_calRectInfo[i])
                    {
                        _calRectInfo[i] = new Array();
                        _calRectInfo[i][0] = new Point(); //p1
                        _calRectInfo[i][1] = new Point(); //p2
                        _calRectInfo[i][2] = new Point(); //p3
                        _calRectInfo[i][3] = new Point(); //p4
                    }

                    fishRadius = _collisionRadius[i];
                    angleP1 = _collisionAngleP1[i];
                    angleP2 = _collisionAngleP2[i];

                    collisionCenter.x = _designPos.x;//getCenterPosition();
                    collisionCenter.y = _designPos.y;
                    if (_fish.scaleX < 0)
                    {
                        collisionRef = GameTools.CalRotatePos(fishRotation + _collisionCenterFishPosMirrorAngle[i], _collisionCenterFishPosLength[i]);
                    }
                    else
                    {
                        collisionRef = GameTools.CalRotatePos(fishRotation + _collisionCenterFishPosAngle[i], _collisionCenterFishPosLength[i]);
                    }

                    collisionCenter.x += collisionRef.x;
                    collisionCenter.y += collisionRef.y;

                    GameTools.CalRotatePos4(collisionCenter, _calRectInfo[i][0], _calRectInfo[i][2], fishRotation + angleP1, fishRadius);
                    GameTools.CalRotatePos4(collisionCenter, _calRectInfo[i][1], _calRectInfo[i][3], fishRotation + angleP2, fishRadius);
                }

            }
        }

        private function getCross(p1:Point, p2:Point, px:Number, py:Number):Number
        {
            return (p2.x - p1.x) * (py - p1.y) - (px - p1.x) * (p2.y - p1.y);
        }

        //子弹点碰撞
        public function bulletPointCollisionDetect(x:Number, y:Number, colInfo:Object = null):Boolean//(center:Point):Boolean
        {
            if (_fishShowDelay > 0)
            {
                return false;
            }
            if (_isCatch)
            {
                return false;
            }
            if (_absorbed)
            {
                return false;
            }
            var collisionCenter:Point = _designPos;//getCenterPosition();
            if ((x - _calMal > collisionCenter.x) ||
                    (x + _calMal) < collisionCenter.x ||
                    (y - _calMal) > collisionCenter.y ||
                    (y + _calMal) < collisionCenter.y)
            {
                return false;
            }
            if (colInfo)
            {
                colInfo.hit += 1;
            }
            calCollisionRect();
            for (var i:int = 0; i < _collisionCount; i++)
            {
                var calRectInfo:Array = _calRectInfo[i];
                if (getCross(calRectInfo[0], calRectInfo[1], x, y) * getCross(calRectInfo[2], calRectInfo[3], x, y) >= 0)
                {
                    if (getCross(calRectInfo[1], calRectInfo[2], x, y) * getCross(calRectInfo[3], calRectInfo[0], x, y) >= 0)
                    {
                        return true;
                    }
                }
            }

            return false;
        }

        //点是否在鱼上面
        public function pointCollisionDetect(x:Number, y:Number):Boolean
        {
            //        var collisionCenter:Point = getCenterPosition();
            //        var collisionRef:Point;
            //        var fishRotation:Number = getRotation();
            //        var tmPoint:Point = new Point(x, y);
            //        if (_fish.scaleX < 0) {
            //            collisionRef = GameTools.CalRotatePos(fishRotation + _fishCenterFishPosMirrorAngle, _fishCenterFishPosLength);
            //        }
            //        else {
            //            collisionRef = GameTools.CalRotatePos(fishRotation + _fishCenterFishPosAngle, _fishCenterFishPosLength);
            //        }
            //        collisionCenter.x += collisionRef.x;
            //        collisionCenter.y += collisionRef.y;
            //        GameTools.CalRotatePos4(collisionCenter, _rectP1, _rectP3, fishRotation + _fishAngleP1, _fishRadius);
            //        GameTools.CalRotatePos4(collisionCenter, _rectP2, _rectP4, fishRotation + _fishAngleP2, _fishRadius);
            //
            //        if (is_line_seg_intersect(_rectP1, _rectP2, collisionCenter, tmPoint)) {
            //            return false;
            //        }
            //        if (is_line_seg_intersect(_rectP2, _rectP3, collisionCenter, tmPoint)) {
            //            return false;
            //        }
            //        if (is_line_seg_intersect(_rectP3, _rectP4, collisionCenter, tmPoint)) {
            //            return false;
            //        }
            //        if (is_line_seg_intersect(_rectP4, _rectP1, collisionCenter, tmPoint)) {
            //            return false;
            //        }
            //        return true;
            if (_fishShowDelay > 0)
            {
                return false;
            }
            if (_isCatch)
            {
                return false;
            }
            var collisionCenter:Point = _designPos;//getCenterPosition();
            if ((x - _calMal > collisionCenter.x) ||
                    (x + _calMal) < collisionCenter.x ||
                    (y - _calMal) > collisionCenter.y ||
                    (y + _calMal) < collisionCenter.y)
            {
                return false;
            }

            calCollisionRect();
            for (var i:int = 0; i < _collisionCount; i++)
            {
                var calRectInfo:Array = _calRectInfo[i];
                if (getCross(calRectInfo[0], calRectInfo[1], x, y) * getCross(calRectInfo[2], calRectInfo[3], x, y) >= 0)
                {
                    if (getCross(calRectInfo[1], calRectInfo[2], x, y) * getCross(calRectInfo[3], calRectInfo[0], x, y) >= 0)
                    {
                        return true;
                    }
                }
            }

            return false;
        }

        public function DrawCollisionRect():void
        {
            var p1:Point = new Point();
            var p2:Point = new Point();
            var p3:Point = new Point();
            var p4:Point = new Point();
            var angleP1:Number;
            var angleP2:Number;
            var collisionCenter:Point;
            var collisionRef:Point;
            var i:int = 0;
            var fishRadius:Number;
            var color:String;
            if (_isCollision)
            {
                color = "#ff0000";
            }
            else
            {
                color = "#ffffff";
            }
            color = "#ff0000";
            _lineTest.graphics.clear();
            var fishRotation:Number = getRotation();
            if (_fish.scaleX < 0)
            {
                //fishRotation = fishRotation - 180;
            }
            for (i = 0; i < _collisionCount; i++)
            {
                _collisionIndex = i;
                fishRadius = _collisionRadius[i];
                angleP1 = _collisionAngleP1[i];
                angleP2 = _collisionAngleP2[i];
                collisionCenter = getCenterPosition();

                if (_fish.scaleX < 0)
                {
                    collisionRef = GameTools.CalRotatePos(fishRotation + _collisionCenterFishPosMirrorAngle[i], _collisionCenterFishPosLength[i]);
                }
                else
                {
                    collisionRef = GameTools.CalRotatePos(fishRotation + _collisionCenterFishPosAngle[i], _collisionCenterFishPosLength[i]);
                }
                collisionCenter.x += collisionRef.x;
                collisionCenter.y += collisionRef.y;
                GameTools.CalRotatePos4(collisionCenter, p1, p3, _fish.rotation + angleP1, fishRadius);
                GameTools.CalRotatePos4(collisionCenter, p2, p4, _fish.rotation + angleP2, fishRadius);
                _lineTest.graphics.drawLine(p1.x, p1.y, p2.x, p2.y, color, 4);
                _lineTest.graphics.drawLine(p2.x, p2.y, p3.x, p3.y, color, 4);
                _lineTest.graphics.drawLine(p3.x, p3.y, p4.x, p4.y, color, 4);
                _lineTest.graphics.drawLine(p4.x, p4.y, p1.x, p1.y, color, 4);
            }

            if (_fish.scaleX < 0)
            {
                collisionRef = GameTools.CalRotatePos(fishRotation + _fishCenterFishPosMirrorAngle, _fishCenterFishPosLength);
            }
            else
            {
                collisionRef = GameTools.CalRotatePos(fishRotation + _fishCenterFishPosAngle, _fishCenterFishPosLength);
            }

            collisionCenter = getCenterPosition();
            //			if(_fish.scaleX < 0)
            //			{
            //
            //				collisionCenter.x -= collisionRef.x;
            //				collisionCenter.y -= collisionRef.y;
            //			}
            //			else
            //			{
            collisionCenter.x += collisionRef.x;
            collisionCenter.y += collisionRef.y;
            //			}


            GameTools.CalRotatePos4(collisionCenter, _rectP1, _rectP3, fishRotation + _fishAngleP1, _fishRadius);
            GameTools.CalRotatePos4(collisionCenter, _rectP2, _rectP4, fishRotation + _fishAngleP2, _fishRadius);
            collisionCenter = getCenterPosition();
            if (_fish.scaleX < 0)
            {
                //				GameTools.GetMirrorPoint(collisionCenter, _rectP1);
                //				GameTools.GetMirrorPoint(collisionCenter, _rectP2);
                //				GameTools.GetMirrorPoint(collisionCenter, _rectP3);
                //				GameTools.GetMirrorPoint(collisionCenter, _rectP4);
            }
            color = "#ff0000";
            //			_lineTest.graphics.drawLine(_rectP1.x, _rectP1.y, _rectP2.x, _rectP2.y, color, 4);
            //			_lineTest.graphics.drawLine(_rectP2.x, _rectP2.y, _rectP3.x, _rectP3.y, color, 4);
            //			_lineTest.graphics.drawLine(_rectP3.x, _rectP3.y, _rectP4.x, _rectP4.y, color, 4);
            //			_lineTest.graphics.drawLine(_rectP4.x, _rectP4.y, _rectP1.x, _rectP1.y, color, 4);
        }


        public function getFishPosition():Point
        {
            return new Point(_fish.x, _fish.y);
        }

        public function isBoss():Boolean
        {
            return _isBoss;
        }

        public function getCoinRate():Number
        {
            return _multiple;
        }

        public function setFreeze(time:Number):void
        {
            if (_callDelay <= 0)
            {
                //				_fish.stop();

                if (_fish is SpineTemplet)
                {
                    var spineAni:SpineTemplet = _fish as SpineTemplet;
                    //spineAni.play(0, true);
                    spineAni.paused();
                }
                else
                {
                    var aniTmp:GameAnimation = _fish as GameAnimation;
                    aniTmp.stop();
                }
                if (_fishMoneyBag)
                {
                    _fishMoneyBag.paused();
                }
                _freezeTime = time;

            }
        }

        public function clearUp(dir:int, t:Number, c:Number):void
        {
            _clearUpDir = dir;
            _clearUpTotalTime = t;
            _clearUpCastTime = c;
        }

        public function setPathTestFreeSwim():void
        {
            _pathTestFreeSwim = true;
        }

        //		public function setPathInfoArray(pathInfoArray:Array):void
        //		{
        //			_pathInfoArray = pathInfoArray;
        //		}
        public function getSpecFlag():int
        {
            return _specFlag;
        }

        public function getCatchShow():int
        {
            return _catchShow;
        }

        public function getCatchType():int
        {
            return _catchType;
        }

        public function getCatchShowRate():Number
        {
            return _catchShowRate;
        }

        public function getCatchShowPos(showSeatId:int):Point
        {
            var ret:Point = new Point();
            var arr:Array = ConfigManager.getConfValue("cfg_fish", _fishId, "catch_show_range") as Array;
            var startX:Number = arr[0];
            var endX:Number = arr[1];
            var startY:Number = arr[2];
            var endY:Number = arr[3];
            ret.x = startX + (endX - startX) * Math.random();
            ret.y = startY + (endY - startY) * Math.random();
            if (2 == showSeatId)
            {
                ret.x = GameConst.design_width - ret.x;//Laya.stage.width - ret.x;
            }
            else if (3 == showSeatId)
            {
                ret.x = GameConst.design_width - ret.x;//Laya.stage.width - ret.x;
                ret.y = GameConst.design_height - ret.y;//Laya.stage.height - ret.y;
            }
            else if (4 == showSeatId)
            {
                ret.y = GameConst.design_height - ret.y;//Laya.stage.height - ret.y;
            }
            return ret;
        }

        public function getCatchShowAniName():String
        {
            return ConfigManager.getConfValue("cfg_fish", _fishId, "ani_name") as String;
        }

        public function getCatchShowAniActionName():String
        {
            return ConfigManager.getConfValue("cfg_fish", _fishId, "action_name") as String;
        }

        public function playCatchSound():Boolean
        {
            var tmp:int = ConfigManager.getConfValue("cfg_fish", _fishId, "playCatchSound") as int;
            return tmp == 1;
        }

        public function getFishLayer():int
        {
            return ConfigManager.getConfValue("cfg_fish", _fishId, "layer") as int;
        }

        public function setSkillBoomSelectBoomFlag(isSelect:Boolean):void
        {
            if (_boomSelectSprite)
            {
                var layers:Array = FightManager.instance.getLayers();
                _boomSelectSprite.visible = isSelect;
                if (isSelect)
                {
                    updateParent(layers[GameConst.boom_mask_layer_index + 1]);
                }
                else
                {
                    updateParent(null);
                }
            }
        }

        public function getSkillBoomSelectBoomFlag():Boolean
        {
            if (_boomSelectSprite)
            {
                return _boomSelectSprite.visible;
            }
            return false;
        }

        public function setLock(parent:Sprite):void
        {
            _lockFlag = true;
            //			var ani:SpineTemplet;
            //			if(!_lockSprite)
            //			{
            //				_lockSprite = new SpineTemplet("suoding");
            //				parent.addChild(_lockSprite);
            //			}
            //			_lockSprite.pos(_fish.x, _fish.y, true);
            //			ani = _lockSprite as SpineTemplet;
            //			ani.play(0, false);

            if (!_lockSprite)
            {
                var rect:Rectangle;
                _lockSprite = new Sprite();
                _lockSprite.loadImage("ui/fight/lock.png");
                rect = _lockSprite.getBounds();
                _lockSprite.pivot(rect.width / 2, rect.height / 2);
                _lockSprite.pos(_fish.x, _fish.y, true);
                parent.addChild(_lockSprite);
                Tween.to(_lockSprite, {scaleX: 0.6, scaleY: 0.6}, 200, null, null);
            }
            else if (!_lockSprite.visible)
            {
                Tween.clearAll(_lockSprite);
                _lockSprite.pos(_fish.x, _fish.y, true);
                _lockSprite.visible = true;
                _lockSprite.scale(1, 1, true);
                Tween.to(_lockSprite, {scaleX: 0.6, scaleY: 0.6}, 200, null, null);
            }
        }

        public function lockClear():void
        {
            //			if(!_lockFlag && _lockSprite)
            if (!_lockFlag && _lockSprite && _lockSprite.visible)
            {
                Tween.clearAll(_lockSprite);
                _lockSprite.visible = false;
                //				_lockSprite.removeSelf();
                //				_lockSprite = null;
            }
            _lockFlag = false;
        }

        public function isAlive():Boolean
        {
            return !_isCatch;
        }

        public function getLockPri():int
        {
            return ConfigManager.getConfValue("cfg_fish", _fishId, "lock_pri") as int;
        }

        public function isCall():Boolean
        {
            return _callDelay > 0;
        }

        public function isBossComeIn():Boolean
        {
            var ret:Boolean = false;
            if (_catchType == GameConst.fish_catch_type_boss ||
                    _catchType == GameConst.fish_catch_type_extra_drop ||
                    _catchType == GameConst.fish_catch_type_black_hole ||
                    _catchType == GameConst.fish_catch_type_award_pool)
            {
                if (_ipath == 1 && _segNum == 1 && _fishRunTime < 4)
                {
                    ret = true;
                }
            }
            return ret;
        }

        //播放出生音效
        public function playComeSound():void
        {
            var comeSound:String = ConfigManager.getConfValue("cfg_fish", _fishId, "comeSound") as String;
            if (comeSound.length > 0)
            {
                GameSoundManager.playSound(comeSound);
            }
        }

        public function fishComeInActionName():String
        {
            return ConfigManager.getConfValue("cfg_fish", _fishId, "come_action_name") as String;
        }

        public function isCallFish():Boolean
        {
            var call:int = ConfigManager.getConfValue("cfg_fish", _fishId, "call") as int;
            return 1 == call;
        }
		//wx:bossShare
		public function iffishBoss():Boolean
		{
            if (_catchType == GameConst.fish_catch_type_boss ||
                    _catchType == GameConst.fish_catch_type_extra_drop ||
                    _catchType == GameConst.fish_catch_type_black_hole ||
                    _catchType == GameConst.fish_catch_type_award_pool)
            {
				return true;
            }
            return false;
		}
		
		
        public function isCoinBoss():Boolean
        {
            return _catchType == GameConst.fish_catch_type_boss;
        }

        public function canLock():Boolean
        {

            return (!_isCatch) && (_fish.x > 0 && _fish.x < Laya.stage.width) && (_fish.y > 0 && _fish.y < Laya.stage.height);
        }

        public function setMoneyBagSize(money:int):void
        {

            if (_fishMoneyBag)
            {
                var scale:Number = money / 300000 * 0.1 + 0.5;

                if (scale > 1)
                {
                    scale = 1;
                }
                if (_fishMoneyBag.scaleX < 0)
                {
                    _fishMoneyBag.scaleX = -scale;
                }
                else
                {
                    _fishMoneyBag.scaleX = scale;
                }
                _fishMoneyBag.scaleY = scale;
            }
        }

        public function screenResize():void
        {
            setFishPosition(GameTools.designPosXMapScreenPosX(_designPos.x), GameTools.designPosYMapScreenPosY(_designPos.y));
        }

        public function getMoneyBagPosition():Point
        {
            if (_fishMoneyBagParent)
            {
                var ret:Point = new Point();
                var len:Number = Math.abs(_fishMoneyBagParent.pivotX);

                var angle:Number = _fishMoneyBagParent.rotation;
                var radian:Number = angle * Math.PI / 180;
                var deltaX:Number = Math.cos(radian);
                var deltaY:Number = Math.sin(radian);
                deltaX = len * deltaX * _fishMoneyBagParent.scaleX;
                deltaY = len * deltaY * _fishMoneyBagParent.scaleX;
                ret.x = _fish.x + deltaX;
                ret.y = _fish.y + deltaY;
                return ret;
            }
            return getCenterPosition();
        }

        public function getFishId():int
        {
            return _fishId;
        }

        public function getMoneyBagDelay():Number
        {
            return (17 / 60) / (ConfigManager.getConfValue("cfg_anicollision", "qiandai", "aniSpeed") as Number);
        }

        public function playMoneyBagBomb():void
        {
            if (_fishMoneyBag)
            {
                var scaleX:Number = _fishMoneyBag.scaleX;
                var scaleY:Number = _fishMoneyBag.scaleY;
                var bombName:String = "qiandai";
                _fishMoneyBag.visible = false;
                //				_fishMoneyBag.removeSelf();
                if (!_fishMoneyBagBomb)
                {
                    _fishMoneyBagBomb = new SpineTemplet(bombName);//AnimalManger.instance.load(bombName);
                    _fishMoneyBagBomb.pivot((ConfigManager.getConfValue("cfg_anicollision", bombName, "pivotX") as int),
                            ConfigManager.getConfValue("cfg_anicollision", bombName, "pivotY") as int);
                    _fishMoneyBagParent.addChild(_fishMoneyBagBomb);
                    _fishMoneyBagBomb.play("H5_qiandai_baozha", false);
                }
                else
                {
                    _fishMoneyBagBomb.visible = true;
                    _fishMoneyBagBomb.play("H5_qiandai_baozha", false);
                }
            }
        }

    }
}
