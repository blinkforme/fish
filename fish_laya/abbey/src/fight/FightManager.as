package fight
{

    import fight.FightManager;

    import model.FightM;
    import model.RoleInfoM;

    import laya.display.Animation;
    import laya.display.Sprite;
    import laya.maths.Point;
    import laya.maths.Rectangle;

    import manager.ConfigManager;
    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.GameParticle;
    import manager.GameSoundManager;
    import manager.GameTools;
    import manager.SpineTemplet;
    import manager.UiManager;
    import manager.WebSocketManager;

    import proto.C2s_12031;
    import proto.C2s_12035;
    import proto.C2s_12043;
    import proto.C2s_17001;
    import proto.C2s_shootBullet;
    import proto.ProtoBulletHitInfo;
    import proto.ProtoBulletInfo;
    import proto.ProtoCatchAward;
    import proto.ProtoCatchFish;
    import proto.ProtoFishInfo;
    import proto.ProtoSeatInfo;
    import proto.S2c_12023;
    import proto.S2c_12028;
    import proto.S2c_12029;
    import proto.S2c_fightSync;
    import proto.S2c_shootBullet;

    import shader.myShaderSprite;

    import struct.ShowGetCoinInfo;

    public class FightManager
    {
        private var _boomAniArray:Array;
        private var _boomEffectArray:Array;
        private var _layers:Array;
        private var _fish_up_layers:Array;
        private var _fishArray:Array;
        private var _bulletArray:Array;
        private var _awardArray:Array;
        private var _catchShowEffect:Array;
        private var _smallGroupFishBornRatio:Array;
        private var _smallGroupFishIds:Array;
        private var _fishBornRatio:Array;
        private var _fishBornIds:Array;
        private var _middleFishBornRatio:Array;
        private var _middleFishIds:Array;
        private var _bigFishBornRatio:Array;
        private var _bigFishIds:Array;
        private var _bossFishBornRatio:Array;
        private var _bossFishIds:Array;
        private var _lockLineArray:Array;
        private var _waitFishSwimOut:Boolean;
        private var _fishRunTime:Number;
        private var _fishGroupRunTime:Number;
        private var _isFishGroup:Boolean;
        private var _groupFishBornType:int;
        private var _fishTideSwimSpeed:Number;
        private var _fishTideRunTime:Number;
        private var _playTypeRatio:Array;
        private var _playTypes:Array;
        private var _bossBornLeftTime:Number;
        private var _fitFishLeftTime:Number;
        private var _smallConfigGroupFishLeftTime:Number;
        private var _bossMinInterval:Number;
        private var _bossMaxInterval:Number;
        private var _fitFishMinLeftTime:Number;
        private var _fitFishMaxLeftTime:Number;
        private var _smallConfigGroupFishMinLeftTime:Number;
        private var _smallConfigGroupFishMaxLeftTime:Number;
        private var _smallFishBornRate:Number;
        private var _middleFishBornRate:Number;
        private var _bigFishBornRate:Number;
        private var _fishBornWaitTime:Number;
        private var _curFishGroupArray:Array;
        private var _curAreaId:int;
        private var _fishTime:Number;
        private var _playTypeNum:int;
        private var _fishGroupTime:Number;
        private var _bossNum:int;
        private var _groupFishIdNum:int;
        private var _fishIdNum:int;
        private var _middleFishIdNum:int;
        private var _bigFishIdNum:int;
        private var _bgSprite:Sprite;
        private var _bgSpriteR:Sprite;
        private var _bgSpriteM:myShaderSprite;
        private var _bgSpriteMR:myShaderSprite;
        private var _bgSpriteF:myShaderSprite;
        private var _bgSpriteFR:myShaderSprite;
        private var _freezeSprite:Sprite;
        private var _freezeLeftTime:Number = 0;
        private var _freezeStartTick:int = 0;
        private var _updateTime:Number;
        private var _fightRoot:Sprite;
        private var _tideFishIndex:int = 0;
        private var _tideName:String = "test4";
        private var _tideSpeed:Number = 100;
        private var _tideSwimLength:Number = 0;
        private var _clearUpAni:Animation = null;
        private var _clearUpParticles:Array = null;
        private var _clearUpDir:int = 1;
        private var _clearUpTotalTime:Number = 0;
        private var _clearUpCastTime:Number = 0;
        private var _skillBoomSelectFlag:Boolean = false;
        private var _skillBoomId:int = 0;
        private var _lockShootInterval:Number = 0;
        private var _bulletMaxTip:Boolean = false;
        private var _lockCoinTip:Boolean = false;
        private var _extraDrop:Boolean = false;
        private var _curTick:int = 0;
        private var _maxTick:int = 0;
        private var _syncTick:int = 0;
        private var _syncTickTime:Number = 0;
        private var _syncTickInterval:Number = 2000;//毫秒
        private var _syncTickStartTime:Number = 0;
        private var _fightUiUpLayer:Sprite = null;
        private var _bgImgMove:BgImgMove = null;
        private var _jellyEffect:JellyEffect = null;
        private var _boomMaskLayer:Sprite = null;
        private var _scenePlayType:int = GameConst.scene_play_money_bag;
        private var _sceneWebScale:Number = 1;
        private var _sceneWebRange:Number = 1;
        private var _lockLinePosArray:Array = [429, 687, 851, 687, 851, 33, 429, 33];
        private var _protoBulletInfo:ProtoBulletInfo = new ProtoBulletInfo();
        private var _bulletInfo:BulletInfo = new BulletInfo();
        private var _c2s_12031:C2s_12031 = new C2s_12031();
        private var _c2s_bulletShoot:C2s_shootBullet = new C2s_shootBullet();
        private static var _instance:FightManager;


        public function FightManager()
        {
            var layerNode:Sprite;
            var i:int;
            _layers = [];
            _fish_up_layers = [];
            _fishArray = [];
            _awardArray = [];
            _catchShowEffect = [];
            _boomAniArray = [];
            _boomEffectArray = [];
            _lockLineArray = [];
            _bulletArray = [];
            _clearUpAni = null;
            var fightBaseDepth:int = UiManager.instance.getFightBaseDepth();
            var fightUiBaseDepth:int = UiManager.instance.getFightUiBaseDepth();
            _bgSprite = new Sprite();
            _bgSpriteM = new myShaderSprite();
            _bgSpriteF = new myShaderSprite();
            _bgSpriteR = new Sprite();
            _bgSpriteMR = new myShaderSprite();
            _bgSpriteFR = new myShaderSprite();

            _freezeSprite = new Sprite();
            _bgImgMove = new BgImgMove();

            _bgSprite.loadImage("scene/scene_1_1_1.png");
            _bgSpriteR.loadImage("scene/scene_1_1_1.png");
            _bgSpriteM.loadImage("scene/scene_1_2.png");
            _bgSpriteMR.loadImage("scene/scene_1_2.png");
            _bgSpriteF.loadImage("scene/scene_1_3.png");
            _bgSpriteFR.loadImage("scene/scene_1_3.png");

            //			_bgSprite.setRange(0.016);
            //			_bgSpriteR.setRange(0.016);

            //中景
            var range:Number = 0.002; //x方向幅度调整
            var yrate:Number = 4.0; //y方向频率调整
            var xrate:Number = 1.0; //x方向频率调整
            range = 0.002;
            yrate = 2.0;
            xrate = 1.0;

            //		    if(!WxC.isInMiniGame())
            //		    {
            //	            _bgSpriteM.setRange(range);
            //	            _bgSpriteM.setYrate(yrate);
            //	            _bgSpriteM.setXrate(xrate);
            //	            _bgSpriteMR.setRange(range);
            //	            _bgSpriteMR.setYrate(yrate);
            //	            _bgSpriteMR.setXrate(xrate);
            //
            //	            //前景
            //
            //	            _bgSpriteF.setRange(range);
            //	            _bgSpriteF.setYrate(yrate);
            //	            _bgSpriteF.setXrate(xrate);
            //	            _bgSpriteFR.setRange(range);
            //	            _bgSpriteFR.setYrate(yrate);
            //	            _bgSpriteFR.setXrate(xrate);
            //
            //	            _bgSpriteM.setSinOff(Math.PI / 7);
            //	            _bgSpriteMR.setSinOff(Math.PI / 7);
            //
            //	            _bgSpriteF.setSinOff(Math.PI / 8);
            //	            _bgSpriteFR.setSinOff(Math.PI / 8);
            //		    }

            _freezeSprite.loadImage("scene/freeze.png");


            _freezeSprite.visible = false;
            fightBaseDepth += 1;
            _fightRoot = new Sprite();
            _fightUiUpLayer = new Sprite();
            Laya.stage.addChild(_fightRoot);
            Laya.stage.addChild(_fightUiUpLayer);
            _fightRoot.zOrder = fightBaseDepth;
            _fightUiUpLayer.zOrder = fightUiBaseDepth + 1;
            _fightRoot.addChild(_bgSprite);
            _fightRoot.addChild(_bgSpriteR);
            _bgImgMove.setBgInfo(_bgSprite, _bgSpriteR);
            for (i = 0; i < GameConst.fishmaxlayer; i++)
            {
                layerNode = new Sprite();
                _fightRoot.addChild(layerNode);
                _layers.push(layerNode);
                if (i > 3)
                {
                    layerNode.visible = false;
                }
            }
            _jellyEffect = new JellyEffect(_layers[0]);
            _fightRoot.addChild(_bgSpriteM);
            _fightRoot.addChild(_bgSpriteMR);
            _bgImgMove.setMbgInfo(_bgSpriteM, _bgSpriteMR);
            for (i = 0; i < GameConst.fishmaxlayer; i++)
            {
                layerNode = new Sprite();
                _fightRoot.addChild(layerNode);
                _layers.push(layerNode);
            }

            _boomMaskLayer = new Sprite();

            _boomMaskLayer.loadImage("ui/common_ex/jl_bg.png");
            _boomMaskLayer.scale(40, 30);
            _boomMaskLayer.pos(-50, -50);
            _boomMaskLayer.alpha = 0.7;
            layerNode = _layers[GameConst.boom_mask_layer_index];
            layerNode.addChild(_boomMaskLayer);
            _boomMaskLayer.visible = false;
            _fightRoot.addChild(_bgSpriteF);
            _fightRoot.addChild(_bgSpriteFR);
            _bgImgMove.setFbgInfo(_bgSpriteF, _bgSpriteFR);
            //子弹层
            layerNode = new Sprite();
            _fightRoot.addChild(layerNode);
            _layers.push(layerNode);

            //效果层
            for (i = 0; i < 6; i++)
            {
                layerNode = new Sprite();
                _fightRoot.addChild(layerNode);
                _fish_up_layers.push(layerNode);
            }


            _fightRoot.addChild(_freezeSprite);
            var rect:Rectangle;
            var length:int = 0;
            var lineScaleArray:Array = [0.48, 0.52, 0.56, 0.6, 0.64, 0.68, 0.72, 0.76, 0.8, 0.84, 0.88, 0.92, 0.96, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
            //锁定直线初始化
            for (i = 0; i < 4; i++)
            {
                var tmpLineArray:Array = [];
                length = 0;
                _lockLineArray.push(tmpLineArray);
                var lineRootSprit:Sprite;
                var tmpLine:Sprite = new Sprite();
                lineRootSprit = tmpLine;
                tmpLine.pos(_lockLinePosArray[i * 2], _lockLinePosArray[i * 2 + 1]);
                _fish_up_layers[0].addChild(tmpLine);
                tmpLineArray.push(tmpLine);
                for (var j:int = 0; j < 24; j++)
                {
                    tmpLine = new Sprite();
                    tmpLine.loadImage("ui/common_ex/lock_circle.png");
                    rect = tmpLine.getBounds();
                    tmpLine.pivot(rect.width / 2, rect.height / 2);
                    lineRootSprit.addChild(tmpLine);
                    tmpLine.visible = false;
                    tmpLine.x = length;
                    tmpLine.scale(lineScaleArray[j], lineScaleArray[j]);
                    tmpLineArray.push(tmpLine);
                    length += 70;
                }
            }
            GameEventDispatch.instance.on(GameEvent.FightStart, this, start);
            GameEventDispatch.instance.on(GameEvent.FightStop, this, stop);
            GameEventDispatch.instance.on(GameEvent.SystemReset, this, SystemReset);
            GameEventDispatch.instance.on(GameEvent.ParseFishData, this, parseFishData);
            GameEventDispatch.instance.on(GameEvent.NewBullet, this, newBullet);
            //			GameEventDispatch.instance.on(GameEvent.WsClose, this, wsClose);
            //			GameEventDispatch.instance.on(GameEvent.WsError, this, wsError);
            GameEventDispatch.instance.on(GameEvent.ConfirmUseSkill, this, confirmUseSkill);
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
            GameEventDispatch.instance.on(String(12016), this, onlineNewBullet);
            GameEventDispatch.instance.on(String(12017), this, onlineDataSync);
            GameEventDispatch.instance.on(String(12023), this, swimOut);
            GameEventDispatch.instance.on(String(12028), this, freezeSkill);
            GameEventDispatch.instance.on(String(12029), this, boomSkill);
            GameEventDispatch.instance.on(String(12040), this, syncTick);
            GameEventDispatch.instance.on(String(12045), this, blackHoleAbsorbFish);
            GameEventDispatch.instance.on(String(12059), this, syncSkipCoin);


            //			_bgSprite.pos((Laya.stage.width - 1920) / 2, 0, true);
            //			_bgSpriteM.pos((Laya.stage.width - 1920) / 2, 0, true);
            //			_bgSpriteF.pos((Laya.stage.width - 1920) / 2, 0, true);

            //			_bgSprite.visible = false;
            //			_bgSpriteM.visible = false;
            //			_bgSpriteF.visible = false;
            _bgImgMove.hide();

            screenResize();

        }

        public static function get instance():FightManager
        {
            return _instance || (_instance = new FightManager());
        }

        public static function dispose():void
        {
            FightManager.instance.stop();
            _instance = null;
        }

        private var _ani:Animation;

        private var _c2s_17001:C2s_17001 = new C2s_17001();

        public function useSkill(skillId:int, rp:int = 0):void
        {
            var skillType:int = ConfigManager.getConfValue("cfg_skill", skillId, "skill_type") as int;
            if (skillType == GameConst.skill_type_call)
            {
                var maxCallFishNum:int = ConfigManager.getConfValue("cfg_global", 1, "max_call_num") as int;
                var curCallFishNum:int = getCallFishNum();
                if (curCallFishNum >= maxCallFishNum)
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTip, 18);
                    return;
                }
            }
            var msg:C2s_17001 = _c2s_17001;//new C2s_17001();
            msg.id = skillId;
            msg.rp = rp;
            msg.callreq = 1;
            WebSocketManager.instance.send(17001, msg);
        }

        public function confirmUseSkill(skillId:int):void
        {
            useSkill(skillId, 1);
        }

        public function getProduceNum(arr:int):int
        {
            return (Math.ceil(Math.random() * (arr)) || 1) + 50;
        }

        public function getLayers():Array
        {
            return _layers;
        }

        private function onComplete():void
        {

        }

        private function removeInvalidFish(removeAll:Boolean = false):void
        {
            var invalidFish:Array = [];
            for (var i:int = 0; i < _fishArray.length; i++)
            {
                var fish:Fish = _fishArray[i] as Fish;
                if (!fish.isValid() || removeAll)
                {
                    invalidFish.push(fish);
                }
            }
            var count:int = invalidFish.length;
            for (var j:int = 0; j < count; j++)
            {
                var removeFish:Fish = invalidFish[j] as Fish;
                removeFish.destroy();
                for (var k:int = 0; k < _fishArray.length; k++)
                {
                    if (_fishArray[k] === removeFish)
                    {
                        _fishArray.splice(k, 1);
                        break;
                    }
                }
            }
        }

        private function removeInvalidBullet(removeAll:Boolean = false):void
        {

            var invalidBullet:Array = [];
            for (var i:int = 0; i < _bulletArray.length; i++)
            {
                var bullet:Bullet = _bulletArray[i] as Bullet;
                if (!bullet.isBulletValid() || removeAll)
                {
                    invalidBullet.push(bullet);
                }
            }
            var count:int = invalidBullet.length;
            for (var j:int = 0; j < count; j++)
            {
                var removeBullet:Bullet = invalidBullet[j] as Bullet;
                removeBullet.destroy();
                for (var k:int = 0; k < _bulletArray.length; k++)
                {
                    if (_bulletArray[k] == removeBullet)
                    {
                        _bulletArray.splice(k, 1);
                        break;
                    }
                }
            }
        }

        private function removeInvalidAwardEffect(removeAll:Boolean = false):void
        {
            var invalidEffect:Array = [];
            for (var i:int = 0; i < _awardArray.length; i++)
            {
                var aEffect:AwardEffect = _awardArray[i] as AwardEffect;
                if (!aEffect.isValid() || removeAll)
                {
                    invalidEffect.push(aEffect);
                }
            }
            var count:int = invalidEffect.length;
            for (var j:int = 0; j < count; j++)
            {
                var removeEffect:AwardEffect = invalidEffect[j] as AwardEffect;
                removeEffect.destroy();
                for (var k:int = 0; k < _awardArray.length; k++)
                {
                    if (_awardArray[k] == removeEffect)
                    {
                        _awardArray.splice(k, 1);
                        break;
                    }
                }
            }
        }

        private function removeInvalidCatchShowEffect(removeAll:Boolean = false):void
        {
            var invalidEffect:Array = [];
            for (var i:int = 0; i < _catchShowEffect.length; i++)
            {
                var aEffect:CatchShowEffect = _catchShowEffect[i] as CatchShowEffect;
                if (!aEffect.isValid() || removeAll)
                {
                    invalidEffect.push(aEffect);
                }
            }
            var count:int = invalidEffect.length;
            for (var j:int = 0; j < count; j++)
            {
                var removeEffect:CatchShowEffect = invalidEffect[j] as CatchShowEffect;
                removeEffect.destroy();
                for (var k:int = 0; k < _catchShowEffect.length; k++)
                {
                    if (_catchShowEffect[k] == removeEffect)
                    {
                        _catchShowEffect.splice(k, 1);
                        break;
                    }
                }
            }
        }

        private function removeInvalidBoomEffect(removeAll:Boolean = false):void
        {
            var invalidEffect:Array = [];
            for (var i:int = 0; i < _boomEffectArray.length; i++)
            {
                var bEffect:BoomEffect = _boomEffectArray[i] as BoomEffect;
                if (!bEffect.isValid() || removeAll)
                {
                    invalidEffect.push(bEffect);
                }
            }
            var count:int = invalidEffect.length;
            for (var j:int = 0; j < count; j++)
            {
                var removeEffect:BoomEffect = invalidEffect[j] as BoomEffect;
                removeEffect.destroy();
                for (var k:int = 0; k < _boomEffectArray.length; k++)
                {
                    if (_boomEffectArray[k] == removeEffect)
                    {
                        _boomEffectArray.splice(k, 1);
                        break;
                    }
                }
            }
        }

        private function removeBoomAni(removeAll:Boolean = false):void
        {
            var invalidAni:Array = [];
            for (var i:int = 0; i < _boomAniArray.length; i++)
            {
                var ani:SpineTemplet = _boomAniArray[i] as SpineTemplet;
                if (!ani.isPlaying() || removeAll)
                {
                    invalidAni.push(ani);
                }
            }
            var count:int = invalidAni.length;
            for (var j:int = 0; j < count; j++)
            {
                var removeAni:SpineTemplet = invalidAni[j] as SpineTemplet;
                for (var k:int = 0; k < _boomAniArray.length; k++)
                {
                    if (_boomAniArray[k] == removeAni)
                    {
                        _boomAniArray.splice(k, 1);
                        break;
                    }
                }
                removeAni.removeSelf();
            }

        }

        private function removeFishGroup():void
        {

        }

        private function getBornFishId(sizeType:int):int
        {
            var rnd:Number = Math.random();
            var i:int = 0;
            switch (sizeType)
            {
                case GameConst.fish_type_size_group:
                {
                    for (i = 0; i < _smallGroupFishIds.length; i++)
                    {
                        if (rnd <= _smallGroupFishBornRatio[i])
                        {
                            return _smallGroupFishIds[i];
                        }
                    }
                    break;
                }
                case GameConst.fish_type_size_small:
                {
                    for (i = 0; i < _fishBornRatio.length; i++)
                    {
                        if (rnd <= _fishBornRatio[i])
                        {
                            return _fishBornIds[i];
                        }
                    }
                    break;
                }
                case GameConst.fish_type_size_middle:
                {
                    for (i = 0; i < _middleFishBornRatio.length; i++)
                    {
                        if (rnd <= _middleFishBornRatio[i])
                        {
                            return _middleFishIds[i];
                        }
                    }
                    break;
                }
                case GameConst.fish_type_size_big:
                {
                    for (i = 0; i < _bigFishBornRatio.length; i++)
                    {
                        if (rnd <= _bigFishBornRatio[i])
                        {
                            return _bigFishIds[i];
                        }
                    }
                    break;
                }
                case GameConst.fish_type_size_boss:
                {
                    for (i = 0; i < _bossFishBornRatio.length; i++)
                    {
                        if (rnd <= _bossFishBornRatio[i])
                        {
                            return _bossFishIds[i];
                        }
                    }
                    break;
                }

            }
            return _fishBornIds[_fishBornIds.length - 1];
        }

        private function testGroupBornFish():void
        {

        }

        private function fishTideDataInit():void
        {
            _groupFishBornType = GameTools.getRandomNumber(GameConst.fish_group_type_left_to_right, GameConst.fish_group_type_path);
            switch (_groupFishBornType)
            {
                case GameConst.fish_group_type_left_to_right:
                {
                    break;
                }
                case GameConst.fish_group_type_path:
                {
                    break;
                }
            }
            _waitFishSwimOut = true;
            _fishRunTime = 0;
            _fishGroupRunTime = 0;
            _isFishGroup = true;
            _tideFishIndex = 0;
            _tideSwimLength = 0;
            _tideSpeed = 100;
        }

        private function getFishIdByTag(tagId:int):void
        {

        }

        private function clearTagFishInfo():void
        {

        }

        private function groupFishBornLeftToRight():void
        {
            _fishGroupRunTime = 0;
            var swimLen:Number = _fishTideSwimSpeed * _fishTideRunTime;

        }

        private function groupFishBornPath():void
        {

        }

        private function bornConfigSmallGroupFish():void
        {

        }

        private function bornNormalConfigSmallGroupFish(fishId:int, fishNum:int):void
        {

        }

        private function bornContinuosConfigSmallGroupFish(smallGroupId:int):void
        {

        }


        private function getFitFishId(rndStart:int, rndRange:int, index:int, rndType:int, fitId:int, preFishId:int):int
        {
            var ret:int = preFishId;
            switch (rndType)
            {
                case GameConst.fish_fit_rnd_once:
                {
                    break;
                }
                case GameConst.fish_fit_rnd_none:
                {
                    break;
                }
                case GameConst.fish_fit_rnd_cfg_once:
                {
                    break;
                }
                case GameConst.fish_fit_rnd_cfg:
                {
                    break;
                }
            }
            return ret;
        }

        private function bornFitFishes():void
        {

        }


        public function bornBullet(info:BulletInfo):void
        {
            var bullet:Bullet = Bullet.create(info, _fish_up_layers[GameConst.bullet_layer_index]);
            _bulletArray.push(bullet);
        }

        public function getBulletLayer():Sprite
        {
            return _fish_up_layers[GameConst.bullet_layer_index];
        }

        public function getFishLayer(fisId:int):Sprite
        {
            var layerIndex:int = ConfigManager.getConfValue("cfg_fish", fisId, "layer") as int;
            return _layers[layerIndex];
        }


        private function fishUpdate(delta:Number):void
        {
            var count:int = _fishArray.length;
            for (var i:int = 0; i < count; i++)
            {
                var fish:Fish = _fishArray[i] as Fish;
                fish.update(delta);
            }
        }

        private function clearUpAniUpdate(delta:Number):void
        {
            var totalTime:Number = _clearUpTotalTime;

            //			if(_clearUpAni)
            if (_clearUpCastTime < totalTime + 1)
            {
                _clearUpCastTime += delta;
                if (_clearUpCastTime >= totalTime + 1)
                {
                    //					_clearUpAni.removeSelf();
                    //					_clearUpAni = null;
                    var particle:GameParticle;
                    if (_clearUpParticles)
                    {
                        for (var i:int = 0; i < _clearUpParticles.length; i++)
                        {
                            particle = _clearUpParticles[i] as GameParticle;
                            particle.visible = false;
                            //							particle.stop();
                        }
                    }
                    return;
                }
                if (_clearUpParticles)
                {
                    for (i = 0; i < _clearUpParticles.length; i++)
                    {
                        particle = _clearUpParticles[i] as GameParticle;
                        if (1 == _clearUpDir)
                        {
                            particle.x = _clearUpCastTime / _clearUpTotalTime * Laya.stage.width;
                        }
                        else
                        {
                            particle.x = Laya.stage.width - _clearUpCastTime / _clearUpTotalTime * Laya.stage.width;
                        }
                    }
                }
                //				else
                //				{
                //					_clearUpAni.visible = true;
                //					if(1 == _clearUpDir)
                //					{
                //						_clearUpAni.x = _clearUpCastTime / _clearUpTotalTime * Laya.stage.width;
                //					}
                //					else
                //					{
                //						_clearUpAni.x = Laya.stage.width - _clearUpCastTime / _clearUpTotalTime * Laya.stage.width;
                //					}
                //				}
            }
        }

        private function freezeUpdate(delta:Number):void
        {
            if (_freezeLeftTime > 0)
            {
                _freezeLeftTime -= delta;
                if (_freezeLeftTime <= 0)
                {
                    _freezeSprite.visible = false;
                }
            }
        }

        private function bulletUpdate(delta:Number):void
        {
            var bullet:Bullet = null;
            for (var i:int = 0; i < _bulletArray.length; i++)
            {
                bullet = _bulletArray[i];
                bullet.update(delta);
            }
        }

        private function awardEffectUpdate(delta:Number):void
        {
            var aEffect:AwardEffect = null;
            for (var i:int = 0; i < _awardArray.length; i++)
            {
                aEffect = _awardArray[i] as AwardEffect;
                aEffect.update(delta);
            }
        }

        private function catchShowEffectUpdate(delta:Number):void
        {
            var catchShowEffect:CatchShowEffect = null;
            for (var i:int = 0; i < _catchShowEffect.length; i++)
            {
                catchShowEffect = _catchShowEffect[i] as CatchShowEffect;
                catchShowEffect.update(delta);
            }
        }

        private function boomEffectUpdate(delta:Number):void
        {
            var bEffect:BoomEffect = null;
            for (var i:int = 0; i < _boomEffectArray.length; i++)
            {
                bEffect = _boomEffectArray[i] as BoomEffect;
                bEffect.update(delta);
            }
        }

        private function blackHoleAbsorbFish(data:*):void
        {
            var fishes:Array = data.fishes as Array;
            var i:int = 0;
            var j:int = 0;
            var tmpFish:Fish = null;

            for (i = 0; i < fishes.length; i++)
            {
                for (j = 0; j < _fishArray.length; j++)
                {
                    tmpFish = _fishArray[j] as Fish;
                    if (tmpFish.getUniId() == fishes[i])
                    {
                        tmpFish.absorbed(data.x, data.y);
                        break;
                    }
                }
            }
        }

        private var _c2s_12043:C2s_12043 = new C2s_12043()
        private var _blackFishP1:Point = new Point();
        private var _blackFishP2:Point = new Point();
        private var _blackFishP3:Point = new Point();
        private var _blackFishP4:Point = new Point();

        private function calBlackHoleAbsorbFish():void
        {
            var blackFish:Fish = null;
            var tmpFish:Fish = null;
            var i:int = 0;
            var msg:C2s_12043 = _c2s_12043;//new C2s_12043();
            msg.fishes = [];
            for (i = 0; i < _fishArray.length; i++)
            {
                tmpFish = _fishArray[i] as Fish;
                if (tmpFish.blackHoleActive())
                {
                    blackFish = tmpFish;
                    break;
                }
            }

            if (blackFish)
            {
                var p1:Point = _blackFishP1;//new Point();
                var p2:Point = _blackFishP2;//new Point();
                var p3:Point = _blackFishP3;//new Point();
                var p4:Point = _blackFishP4;//new Point();
                var blackPosX:Number = blackFish.getBlackHolePosX();
                var blackPosY:Number = blackFish.getBlackHolePosY();
                var catchRange:Number = blackFish.getBlackHoleRange();
                msg.x = Math.floor(FightM.instance.getMirrorPosXByOwnSeat(blackPosX));//Math.floor(rawPoint.x);
                msg.y = Math.floor(FightM.instance.getMirrorPosYByOwnSeat(blackPosY));//Math.floor(rawPoint.y);
                p1.x = blackPosX - catchRange;
                p1.y = blackPosY - catchRange;
                p2.x = p1.x + catchRange + catchRange;
                p2.y = p1.y;
                p3.x = p2.x;
                p3.y = p2.y + catchRange + catchRange;
                p4.x = p3.x - catchRange - catchRange;
                p4.y = p3.y;

                for (i = 0; i < _fishArray.length; i++)
                {
                    tmpFish = _fishArray[i] as Fish;
                    if (tmpFish != blackFish && tmpFish.collisionDetect(p1, p2, p3, p4))
                    {
                        msg.fishes.push(tmpFish.getUniId());
                    }
                }
            }

            if (msg.fishes.length > 0)
            {
                WebSocketManager.instance.send(12043, msg);
            }

        }

        private var _c2s_12035:C2s_12035 = new C2s_12035();

        //关卡3子弹碰撞
        private function blackHoleBulletHurtCal():void
        {
            var count:int = _bulletArray.length;
            var bullet:Bullet = null;
            var p1:Point = _blackFishP1;//new Point();
            var p2:Point = _blackFishP2;//new Point();
            var p3:Point = _blackFishP3;//new Point();
            var p4:Point = _blackFishP4;//new Point();
            var center:Point;
            var radius:Number;
            var j:int = 0;
            var x:Number;
            var y:Number;
            var bulletAgent:int;
            var msg:C2s_12035 = _c2s_12035;//new C2s_12035();
            var ownAgent:int = FightM.instance.getOwnAgent();
            var webNum:int = 0;
            var pointCollisionOk:Boolean = false;
            var webRadius:int = _sceneWebRange;
            msg.hit = [];
            if (GameConst.draw_collision_rect)
            {
                for (var k:int = 0; k < _fishArray.length; k++)
                {
                    var tmpFish:Fish = _fishArray[k] as Fish;
                    tmpFish._isCollision = false;
                }
            }

            for (var i:int = 0; i < count; i++)
            {
                bullet = _bulletArray[i] as Bullet;
                bulletAgent = bullet.getAgent();
                pointCollisionOk = false;
                if (bullet.canCatchFish())
                {
                    var fList:Array = [];
                    if (bullet.lockFish())
                    {
                        bullet.clientHitTarget(bullet.getFuid());
                        if ((bulletAgent == ownAgent || FightM.instance.isOwnBestBulletOwner(bulletAgent)))
                        {
                            fList.push(bullet.getFuid());
                        }
                    }
                    else
                    {
                        x = bullet.getPosX();
                        y = bullet.getPosY();
                        p1.x = x - webRadius;
                        p1.y = y - webRadius;
                        p2.x = p1.x + webRadius + webRadius;
                        p2.y = p1.y;
                        p3.x = p2.x;
                        p3.y = p2.y + webRadius + webRadius;
                        p4.x = p3.x - webRadius - webRadius;
                        p4.y = p3.y;
                        for (j = 0; j < _fishArray.length; j++)
                        {
                            var fish:Fish = _fishArray[j] as Fish;
                            if (fish.isValid())
                            {
                                if (pointCollisionOk)
                                {
                                    if (fList.length < 5 && fish.collisionDetect(p1, p2, p3, p4))
                                    {
                                        FightManager.instance.fishHitStart(fish.getUniId(), !(bulletAgent == ownAgent));
                                        if ((bulletAgent == ownAgent || FightM.instance.isOwnBestBulletOwner(bulletAgent)))
                                        {
                                            fList.push(fish.getUniId());
                                        }
                                    }
                                    else
                                    {
                                        bullet.uncollisionFish(fish.getUniId());
                                        if (!bullet.canCatchFish())
                                        {
                                            break;
                                        }
                                    }
                                }
                                else
                                {
                                    if (fish.bulletPointCollisionDetect(x, y))
                                    {
                                        if (bullet.isUncollisionFish(fish.getUniId()))
                                        {
                                            bullet.addCollisionFishInfo(fish.getUniId());
                                            bullet.clientHitTarget(fish.getUniId());
                                            bullet._isCollision = true;
                                            pointCollisionOk = true;
                                            if ((bulletAgent == ownAgent || FightM.instance.isOwnBestBulletOwner(bulletAgent)))
                                            {
                                                fList.push(fish.getUniId());
                                            }
                                        }
                                    }
                                    else
                                    {
                                        bullet.uncollisionFish(fish.getUniId());
                                    }
                                }

                            }
                        }
                    }
                    if (fList.length > 0)
                    {
                        var item:Object = new Object();
                        item.b = bullet.getUniId();
                        item.f = fList;
                        msg.hit.push(item);
                    }
                }

            }
            if (msg.hit.length > 0)
            {
                WebSocketManager.instance.send(12035, msg);
            }

        }

        private var _calInfo:Object = new Object();

        //关卡1，2子弹碰撞
        private function bulletHurtCal():void
        {
            var count:int = _bulletArray.length;
            var bullet:Bullet = null;
            var center:Point;
            var radius:Number;
            var j:int = 0;
            var x:Number;
            var y:Number;
            var bulletAgent:int;
            var msg:C2s_12035 = _c2s_12035//new C2s_12035();
            var ownAgent:int = FightM.instance.getOwnAgent();
            var pointCollisionOk:Boolean = false;
            _calInfo.hit = 0;
            msg.hit = [];
            if (GameConst.draw_collision_rect)
            {
                for (var k:int = 0; k < _fishArray.length; k++)
                {
                    var tmpFish:Fish = _fishArray[k] as Fish;
                    tmpFish._isCollision = false;
                }
            }
            for (var i:int = 0; i < count; i++)
            {
                bullet = _bulletArray[i] as Bullet;
                bulletAgent = bullet.getAgent();
                if (bullet.canCatchFish())
                {
                    var fList:Array = [];
                    bullet._isCollision = false;
                    pointCollisionOk = false;
                    if (bullet.lockFish())
                    {
                        bullet.clientHitTarget(bullet.getFuid());
                        if ((bulletAgent == ownAgent || FightM.instance.isOwnBestBulletOwner(bulletAgent)))
                        {

                            fList.push(bullet.getFuid());
                        }
                    }
                    else
                    {
                        x = bullet.getPosX();
                        y = bullet.getPosY();
                        for (j = 0; j < _fishArray.length; j++)
                        {
                            var fish:Fish = _fishArray[j] as Fish;
                            if (fish.isValid())
                            {
                                if (fish.bulletPointCollisionDetect(x, y, _calInfo))
                                {
                                    if (bullet.isUncollisionFish(fish.getUniId()))
                                    {
                                        bullet.addCollisionFishInfo(fish.getUniId());
                                        if (!pointCollisionOk)
                                        {
                                            bullet.clientHitTarget(fish.getUniId());
                                        }
                                        fish._isCollision = true;
                                        bullet._isCollision = true;
                                        pointCollisionOk = true;
                                        if ((bulletAgent == ownAgent || FightM.instance.isOwnBestBulletOwner(bulletAgent)))
                                        {
                                            fList.push(fish.getUniId());
                                        }
                                        if (!bullet.canCatchFish())
                                        {
                                            break;
                                        }
                                    }
                                }
                                else
                                {
                                    fish._isCollision = false;
                                    bullet.uncollisionFish(fish.getUniId());
                                }
                            }
                        }
                    }
                    if (fList.length > 0)
                    {
                        var item:Object = new Object();
                        item.b = bullet.getUniId();
                        item.f = fList;
                        msg.hit.push(item);
                    }
                }

            }
            if (msg.hit.length > 0)
            {
                WebSocketManager.instance.send(12035, msg);
            }
            //if(_calInfo.hit > 0)
            //trace("cal hit = " + _calInfo.hit, _bulletArray.length, _fishArray.length);
        }

        private function localBombOp():void
        {

        }

        private function screenBombOp():void
        {

        }

        private function catchFishByType():void
        {
        }

        private function catchFishByPlayType():void
        {
        }


        private function exitArea(hideBg:Boolean):void
        {
            if (hideBg)
            {
                //				_bgSprite.visible = false;
                //				_bgSpriteM.visible = false;
                //				_bgSpriteF.visible = false;
                _bgImgMove.hide();
                _jellyEffect.hide();
            }

            _freezeLeftTime = 0;
            _freezeSprite.visible = false;

            var lineTmpArray:Array;
            var rootSprite:Sprite;
            var i:int = 0;
            for (i = 0; i < 4; i++)
            {
                lineTmpArray = _lockLineArray[i] as Array;
                rootSprite = lineTmpArray[0] as Sprite;
                rootSprite.visible = false;
            }

            //			if(_clearUpAni)
            //			{
            //				_clearUpAni.removeSelf();
            //				_clearUpAni = null;
            //			}

            var particle:GameParticle;
            if (_clearUpParticles)
            {
                for (i = 0; i < _clearUpParticles.length; i++)
                {
                    particle = _clearUpParticles[i] as GameParticle;
                    particle.stop();
                    particle.visible = false;
                }
            }

            _curAreaId = -1;
            removeInvalidFish(true);
            removeInvalidBullet(true);
            removeInvalidAwardEffect(true);
            removeInvalidCatchShowEffect(true);
            removeInvalidBoomEffect(true);
            removeBoomAni(true);
            skillBoomSelectReset();
            FightM.instance.dataReset();
        }

        private function initPlayType(areaId:int):void
        {
            _playTypeNum = 0;
            var bornRatioTotal:int = 0;
            var bornRatioTmp:Array = [];
            var i:int = 0;
            _playTypes = [];
            _playTypeRatio = [];
            for (i = 1; i < GameConst.area_play_type_max_num; i++)
            {
                var key:String = "playType" + i;
                var playType:int = ConfigManager.getConfValue("cfg_scene", areaId, key) as int;
                key = "playType" + i + "Ratio";
                var bornRatio:int = ConfigManager.getConfValue("cfg_scene", areaId, key) as int;
                if (playType > 0)
                {
                    bornRatioTotal += bornRatio;
                    bornRatioTmp.push(bornRatio);
                    _playTypes[_playTypeNum++] = playType;
                }
            }
            var tmp:int = 0;
            for (i = 0; i < _playTypeNum; i++)
            {
                tmp += bornRatioTmp[i];
                _playTypeRatio[i] = tmp / bornRatioTotal;
            }
        }

        private function loadTideData(areaId:int):void
        {

        }

        public function parseFishesBornData(areaId:int):void
        {
            if (areaId === _curAreaId)
            {
                return;
            }
            var date:Date = new Date();
            var milli:Number = date.getTime();
            _updateTime = 0;
            _scenePlayType = ConfigManager.getConfValue("cfg_scene", areaId, "play_id") as int;
            _sceneWebScale = ConfigManager.getConfValue("cfg_scene", areaId, "web") as Number;
            _sceneWebRange = ConfigManager.getConfValue("cfg_scene", areaId, "range") as Number;
            _smallFishBornRate = ConfigManager.getConfValue("cfg_global", 1, "smallFishBornRate") as Number;
            _middleFishBornRate = ConfigManager.getConfValue("cfg_global", 1, "middleFishBornRate") + _smallFishBornRate;
            _bigFishBornRate = ConfigManager.getConfValue("cfg_global", 1, "middleFishBornRate") + _middleFishBornRate;
            //			initPlayType(areaId);
            var backSound:String = ConfigManager.getConfValue("cfg_scene", areaId, "backMusic") as String;

            var backImg:String = ConfigManager.getConfValue("cfg_scene", areaId, "sceneBgImg") as String;

            _waitFishSwimOut = false;
            _fishBornWaitTime = ConfigManager.getConfValue("cfg_global", 1, "fishBornDelay") as Number;
            _curFishGroupArray = null;
            _curAreaId = areaId;
            _isFishGroup = false;
            _lockCoinTip = false;
            _bulletMaxTip = false;
            _clearUpCastTime = 0;
            _clearUpTotalTime = 0;
            _syncTickTime = milli;
            _syncTickStartTime = milli;
            //			_fishBornIds = [];
            //			_fishBornRatio = [];
            //			_bigFishIds = [];
            //			_bigFishBornRatio = [];
            //			_middleFishIds = [];
            //			_middleFishBornRatio= [];

            //			_smallGroupFishIds = [];
            //			_smallGroupFishBornRatio = [];
            //			_bossFishIds = [];
            //			_bossFishBornRatio = [];
            //			_bulletArray = [];

            //            播放进场动画
            playComingSpine()
        }

        private function playComingSpine():void
        {

            GameEventDispatch.instance.event(GameEvent.WelcomeGetIn);

            //            var spineName:String;
            //            if(areaId == 1){
            //                spineName = "1_shenhaijujing"
            //            }else if(areaId == 2){
            //                spineName = "2_tieqianxiewang"
            //            }else if(areaId == 3){
            //                spineName = "3_jixieyuwang"
            //            }else if(areaId == 4){
            //                spineName = "4_wannianjue"
            //            }
            //
            //            var ani:SpineTemplet = new SpineTemplet("ruchangdonghua");
            //            var layer:Sprite = _fightUiUpLayer;
            //            ani.pos(Laya.stage.width / 2, Laya.stage.height / 2);
            //            layer.addChild(ani);
            //            ani.play(spineName, false);
            //            ani.scale(Laya.stage.width / GameConst.design_width, Laya.stage.height / GameConst.design_height, true);
            //
            //            _boomAniArray.push(ani);
        }

        private function getFishIdByModelName():int
        {
            return 1;
        }

        private function seatLockUpdate(showSeatId:int):void
        {
            var seatId:int;
            var seatInfo:ProtoSeatInfo;
            var fish:Fish;
            var fishCenter:Point;
            var i:int;
            seatId = FightM.instance.getSeatIdByShowSeatId(showSeatId);
            seatInfo = FightM.instance.getSeatInfo(seatId);

            var lineTmpArray:Array = _lockLineArray[showSeatId - 1] as Array;
            var rootSprite:Sprite = lineTmpArray[0] as Sprite;
            rootSprite.visible = false;
            if (seatInfo && seatInfo.lock_et > 0)
            {
                if (seatInfo.lock_uid)
                {
                    for (i = 0; i < _fishArray.length; i++)
                    {
                        fish = _fishArray[i] as Fish;
                        if (fish.getUniId() == seatInfo.lock_uid)
                        {
                            fish.setLock(_fish_up_layers[GameConst.lock_effect_layer_index]);
                            rootSprite.visible = true;
                            fishCenter = fish.getCenterPosition();
                            rootSprite.rotation = GameTools.CalLineAngleP4(rootSprite.x, rootSprite.y, fishCenter.x, fishCenter.y);
                            var maxLen:int = GameTools.CalPointLenP4(rootSprite.x, rootSprite.y, fishCenter.x, fishCenter.y);
                            var useLen:int = 0;
                            var tmpSprite:Sprite;
                            for (var j:int = 0; j < lineTmpArray.length; j++)
                            {
                                tmpSprite = lineTmpArray[j] as Sprite;
                                if (maxLen < useLen)
                                {
                                    tmpSprite.visible = false;
                                }
                                else
                                {
                                    tmpSprite.visible = true;
                                }
                                useLen += 70;
                            }
                            break;
                        }
                    }
                }
            }
        }

        //当前锁定的目标是否有效
        private function lockTargetAvailable(uid:int):Boolean
        {
            if (uid > 0)
            {
                var i:int;
                var fish:Fish;
                for (i = 0; i < _fishArray.length; i++)
                {
                    fish = _fishArray[i] as Fish;
                    if (fish.canLock() && fish.getUniId() == uid)
                    {
                        return true;
                    }
                }
            }
            return false;
        }

        private function getFishByUid(uid:int):Fish
        {
            var i:int;
            var fish:Fish;
            for (i = 0; i < _fishArray.length; i++)
            {
                fish = _fishArray[i] as Fish;
                if (fish.isAlive() && fish.getUniId() == uid)
                {
                    return fish;
                }
            }
            return null;
        }

        public function getFishPosition(uid:int):Point
        {
            var i:int;
            var fish:Fish;
            for (i = 0; i < _fishArray.length; i++)
            {
                fish = _fishArray[i] as Fish;
                if (fish.isAlive() && fish.getUniId() == uid)
                {
                    return fish.getCenterPosition();
                }
            }
            return null;
        }

        public function fishHitStart(uid:int, onlineSync:Boolean = false):void
        {
            var i:int;
            var fish:Fish;
            for (i = 0; i < _fishArray.length; i++)
            {
                fish = _fishArray[i] as Fish;
                if (fish.isAlive() && fish.getUniId() == uid)
                {
                    fish.hitStart(onlineSync);
                    return;
                }
            }
        }

        private function getLockFish():Fish
        {
            var i:int;
            var ret:Fish = null;
            var fish:Fish = null;
            for (i = 0; i < _fishArray.length; i++)
            {
                fish = _fishArray[i] as Fish;
                if (fish.canLock())
                {
                    if (!ret)
                    {
                        ret = fish;
                    }
                    else if (fish.getLockPri() > ret.getLockPri())
                    {
                        ret = fish;
                    }
                }
            }
            return ret;
        }

        //private
        //提示子弹数量太多
        //		public function tipBulletNumMax():void
        //		{
        //
        //		}


        //锁定技能更新
        private function lockUpdate(delta:Number):void
        {
            var i:int;
            var fish:Fish;
            seatLockUpdate(1);
            seatLockUpdate(2);
            seatLockUpdate(3);
            seatLockUpdate(4);
            //之前锁定效果取消
            for (i = 0; i < _fishArray.length; i++)
            {
                fish = _fishArray[i] as Fish;
                fish.lockClear();
            }

            //判断自身瞄准的鱼
            var seatInfo:ProtoSeatInfo = FightM.instance.getSeatInfo(FightM.instance.seatId);
            if (seatInfo && seatInfo.lock_et > 0 && !lockTargetAvailable(FightM.instance._lockUid) && !lockTargetAvailable(seatInfo.lock_uid))
            {
                //自动选中最优目标
                fish = getLockFish();
                if (fish)
                {
                    FightM.instance._lockUid = fish.getUniId();
                    //var msg:C2s_12031 = new C2s_12031();
                    _c2s_12031.uid = fish.getUniId();
                    WebSocketManager.instance.send(12031, _c2s_12031);
                }
                _lockShootInterval = 0;
            }

            //瞄准自动发射子弹
            if (seatInfo && seatInfo.lock_et > 0 && lockTargetAvailable(seatInfo.lock_uid))
            {
                _lockShootInterval -= delta;
                if (_lockShootInterval <= 0)
                {
                    _lockShootInterval = FightM.instance.getShootInterval();
                    if (!isBulletReachMaxNum())
                    {
                        if (getSkillBoomSelectFlag())
                        {
                            return;
                        }
                        var comsume:int = ConfigManager.getConfValue("cfg_battery", FightM.instance.getOwnUseBattery(), "comsume") as int;
                        var catchCount:int = ConfigManager.getConfValue("cfg_battery_skin", RoleInfoM.instance.getCurSkin(), "catch_count") as int;
                        comsume = comsume * catchCount * FightM.instance.getCoinRate() * FightM.instance.getChangeRate()
                        var totalCoin:int = RoleInfoM.instance.getCoin() + RoleInfoM.instance.getBindCoin();
                        if (!FightM.instance.coinShootScene())
                        {
                            totalCoin = RoleInfoM.instance.getContestCoin();
                        }
                        if (totalCoin >= comsume)
                        {

                            fish = getFishByUid(seatInfo.lock_uid);
                            var refPoint:Point = fish.getCenterPosition();

                            var lineTmpArray:Array = _lockLineArray[FightM.instance.getShowSeatId(FightM.instance.seatId) - 1] as Array;
                            var rootSprite:Sprite = lineTmpArray[0] as Sprite;
                            //var onlineInfo:C2s_shootBullet = new C2s_shootBullet();
                            _c2s_bulletShoot.fuid = seatInfo.lock_uid;
                            _c2s_bulletShoot.startX = GameTools.screenPosXMapDesignPosX(rootSprite.x);//rootSprite.x;
                            _c2s_bulletShoot.startY = GameTools.screenPosYMapDesignPosY(rootSprite.y);//rootSprite.y;
                            _c2s_bulletShoot.endX = GameTools.screenPosXMapDesignPosX(refPoint.x);//refPoint.x;
                            _c2s_bulletShoot.endY = GameTools.screenPosYMapDesignPosY(refPoint.y);//refPoint.y;

                            _c2s_bulletShoot.startX = FightM.instance.getMirrorPosXByOwnSeat(Math.floor(_c2s_bulletShoot.startX));
                            _c2s_bulletShoot.endX = FightM.instance.getMirrorPosXByOwnSeat(Math.floor(_c2s_bulletShoot.endX));
                            _c2s_bulletShoot.startY = FightM.instance.getMirrorPosYByOwnSeat(Math.floor(_c2s_bulletShoot.startY));
                            _c2s_bulletShoot.endY = FightM.instance.getMirrorPosYByOwnSeat(Math.floor(_c2s_bulletShoot.endY));

                            _c2s_bulletShoot.bt = FightM.instance.getOwnUseBattery();
                            _c2s_bulletShoot.sk = RoleInfoM.instance.getCurSkin();
                            _c2s_bulletShoot.sr = 1;
                            _c2s_bulletShoot.index = FightM.instance.seatId;
                            _c2s_bulletShoot.lock = 1;
                            _c2s_bulletShoot.tick = _curTick;
                            _c2s_bulletShoot.m = 1;
                            _bulletMaxTip = false;
                            _lockCoinTip = false;

                            //var info: BulletInfo = new BulletInfo();
                            _bulletInfo.sr = _c2s_bulletShoot.sr;
                            _bulletInfo.endX = _c2s_bulletShoot.endX;
                            _bulletInfo.endY = _c2s_bulletShoot.endY;
                            _bulletInfo.startX = _c2s_bulletShoot.startX;
                            _bulletInfo.startY = _c2s_bulletShoot.startY;
                            _bulletInfo.sk = _c2s_bulletShoot.sk;
                            _bulletInfo.uniId = _c2s_bulletShoot.uid;
                            _bulletInfo.fuid = _c2s_bulletShoot.fuid;
                            _bulletInfo.index = _c2s_bulletShoot.index;
                            _bulletInfo.tick = _curTick;
                            _bulletInfo.agent = FightM.instance.getOwnAgent();
                            _bulletInfo.count = ConfigManager.getConfValue("cfg_battery_skin", _bulletInfo.sk, "catch_count") as int;
                            _bulletInfo.showDelay = 0;
                            if (_bulletInfo.startX >= 0 && _bulletInfo.startX <= Laya.stage.width && _bulletInfo.startY >= 0 && _bulletInfo.startY <= Laya.stage.height)
                            {
                                _c2s_bulletShoot.uid = FightM.instance.getBulletUid();
                                _bulletInfo.uniId = _c2s_bulletShoot.uid;
                                GameEventDispatch.instance.event(GameEvent.NewBullet, _bulletInfo);
                                GameEventDispatch.instance.event(GameEvent.OnlineBullet, _bulletInfo);
                                WebSocketManager.instance.send(12014, _c2s_bulletShoot);
                            }
                            else
                            {
                                //trace("lock skip");
                            }
                        }
                        else
                        {
                            if (!_lockCoinTip)
                            {
                                //								GameEventDispatch.instance.event(GameEvent.MsgTip, 3);
                                //								GameEventDispatch.instance.event(GameEvent.Shop, GameConst.shop_tab_coin);
                                _lockCoinTip = true;
                                if (FightM.instance.coinShootScene())
                                {
                                    GameEventDispatch.instance.event(GameEvent.MsgTip, 3);
                                    GameEventDispatch.instance.event(GameEvent.Shop, GameConst.shop_tab_coin);
                                }
                                else
                                {

                                }
                            }
                        }
                    }
                    else
                    {
                        if (!_bulletMaxTip)
                        {
                            GameEventDispatch.instance.event(GameEvent.MsgTip, 19);
                            _bulletMaxTip = true;
                        }
                    }
                }
            }
            else
            {
                _lockCoinTip = false;
            }
        }


        private function onlineUpdate():void
        {
            clearUpAniUpdate(GameConst.fixed_update_time);
            freezeUpdate(GameConst.fixed_update_time);
            fishUpdate(GameConst.fixed_update_time);

            if (_scenePlayType == GameConst.scene_play_black_hole)
            {
                calBlackHoleAbsorbFish();
            }

            bulletUpdate(GameConst.fixed_update_time);
            awardEffectUpdate(GameConst.fixed_update_time);
            catchShowEffectUpdate(GameConst.fixed_update_time);
            boomEffectUpdate(GameConst.fixed_update_time);
            lockUpdate(GameConst.fixed_update_time);
            //            if (_scenePlayType == GameConst.scene_play_black_hole)
            //            {
            //                blackHoleBulletHurtCal();
            //            }
            //            else
            //            {
            //                bulletHurtCal();
            //            }
            bulletHurtCal();


            _bgImgMove.update(GameConst.fixed_update_time);
            _jellyEffect.update(GameConst.fixed_update_time);
            removeInvalidFish();
            removeInvalidBullet();
            removeInvalidAwardEffect();
            removeInvalidCatchShowEffect();
            removeInvalidBoomEffect();
            removeBoomAni();
        }

        //		private function localUpdate():void
        //		{
        //			areaStatusUpdate(GameConst.fixed_update_time);
        //			if(!_waitFishSwimOut)
        //			{
        //				if(FightM.instance.seatId <= 0)
        //				{
        //					bornFish();
        //				}
        //			}
        //			var count:int = 1;
        //			if(_waitFishSwimOut && _isFishGroup)
        //			{
        //				count = 4;
        //			}
        //			for(var i:int = 0; i < count; i++)
        //			{
        //				fishUpdate(GameConst.fixed_update_time);
        //			}
        //			bulletUpdate(GameConst.fixed_update_time);
        //			awardEffectUpdate(GameConst.fixed_update_time);
        //			fishGroupUpdate(GameConst.fixed_update_time);
        //			bulletHurtCal();
        //			removeInvalidFish();
        //			removeInvalidBullet();
        //			removeInvalidAwardEffect();
        //			removeInvalidCatchShowEffect();
        //			if(_waitFishSwimOut)
        //			{
        //				if(_fishArray.length <= 0)
        //				{
        //					_waitFishSwimOut = false;
        //				}
        //			}
        //		}
        //
        public function update(delta:Number):void
        {
            var date:Date = new Date();
            var milli:Number = date.getTime();
            if (_curAreaId > 0)
            {
                _curTick = _syncTick + Math.floor((milli - _syncTickTime) / (1000 * GameConst.fixed_update_time));
                if (_curTick > _maxTick)
                {
                    _curTick = Math.floor(_curTick % _maxTick);
                }
                _updateTime += delta;
                while (_updateTime >= GameConst.fixed_update_time)
                {
                    onlineUpdate();
                    _updateTime -= GameConst.fixed_update_time;

                }
                if (_syncTickStartTime <= _syncTickTime && (milli - _syncTickTime) >= _syncTickInterval)
                {
                    WebSocketManager.instance.send(12039, null);
                    _syncTickStartTime = milli;
                }
            }
        }

        //检查是否有炸弹目标
        public function checkBoomSelectFlag():void
        {
            if (_skillBoomSelectFlag)
            {
                var fish:Fish;
                var boomFishExit:Boolean = false;
                for (var i:int = 0; i < _fishArray.length; i++)
                {
                    fish = _fishArray[i] as Fish;
                    if (fish.getSkillBoomSelectBoomFlag())
                    {
                        boomFishExit = true;
                    }
                }
                if (!boomFishExit)
                {
                    skillBoomSelectReset();
                    GameEventDispatch.instance.event(GameEvent.MsgTip, 22);
                }
            }
        }

        //设置选中鱼
        public function setSkillBoomSelectFlag(skillId:int):void
        {
            var fish:Fish;
            var boomFishExit:Boolean = false;
            _skillBoomSelectFlag = !_skillBoomSelectFlag;
            _skillBoomId = skillId;
            for (var i:int = 0; i < _fishArray.length; i++)
            {
                fish = _fishArray[i] as Fish;
                fish.setSkillBoomSelectBoomFlag(_skillBoomSelectFlag);
                if (fish.getSkillBoomSelectBoomFlag())
                {
                    boomFishExit = true;
                }
            }
            if (!boomFishExit && _skillBoomSelectFlag)
            {
                _skillBoomSelectFlag = false;
                GameEventDispatch.instance.event(GameEvent.MsgTip, 22);
            }
            _boomMaskLayer.visible = _skillBoomSelectFlag;
            GameEventDispatch.instance.event(GameEvent.BoomSelectUpdate);
        }

        public function getSkillBoomId():int
        {
            return _skillBoomId
        }

        public function skillBoomSelectReset():void
        {
            _skillBoomSelectFlag = false;
            _boomMaskLayer.visible = _skillBoomSelectFlag;
            GameEventDispatch.instance.event(GameEvent.BoomSelectUpdate);
        }

        public function getSkillBoomSelectFlag():Boolean
        {
            return _skillBoomSelectFlag;
        }

        private function boomSkillSelectFish(x:Number, y:Number):Fish
        {
            var fish:Fish;
            var ret:Fish = null;
            for (var i:int = 0; i < _fishArray.length; i++)
            {
                fish = _fishArray[i] as Fish;
                if (fish.getSkillBoomSelectBoomFlag() && fish.pointCollisionDetect(x, y))
                {
                    if (!ret)
                    {
                        ret = fish;
                    }
                    else
                    {
                        if (ret.getFishLayer() <= fish.getFishLayer())
                        {
                            ret = fish;
                        }
                    }
                }
            }
            return ret;
        }

        private function lockSkillSelectFish(x:Number, y:Number):Fish
        {
            var fish:Fish;
            var ret:Fish = null;
            for (var i:int = 0; i < _fishArray.length; i++)
            {
                fish = _fishArray[i] as Fish;
                if (fish.pointCollisionDetect(x, y))
                {
                    if (!ret)
                    {
                        ret = fish;
                    }
                    else
                    {
                        if (fish.getLockPri() > ret.getLockPri())
                        {
                            ret = fish;
                        }
                    }
                }
            }
            return ret;
        }

        //是否已经处理过
        public function touchHandle(x:Number, y:Number):Boolean
        {
            var fish:Fish;
            x = GameTools.screenPosXMapDesignPosX(x);
            y = GameTools.screenPosYMapDesignPosY(y);
            //炸弹选择中
            if (_skillBoomSelectFlag)
            {
                fish = boomSkillSelectFish(x, y);
                if (fish)
                {
                    var point:Point = fish.getDesignPos();
                    var msg:C2s_17001 = _c2s_17001;//new C2s_17001();
                    msg.id = _skillBoomId;
                    msg.uid = fish.getUniId();
                    point.x = FightM.instance.getMirrorPosXByOwnSeat(point.x);
                    point.y = FightM.instance.getMirrorPosYByOwnSeat(point.y);
                    msg.x = Math.ceil(point.x);
                    msg.y = Math.ceil(point.y);
                    msg.index = FightM.instance.seatId;
                    WebSocketManager.instance.send(17001, msg);
                }
                else
                {
                }
                return true;
            }
            //锁定选择中
            var seatInfo:ProtoSeatInfo = FightM.instance.getSeatInfo(FightM.instance.seatId);
            if (seatInfo && seatInfo.lock_et > 0)
            {
                //自动选中最优目标
                fish = lockSkillSelectFish(x, y);
                if (fish && (fish.getUniId() != seatInfo.lock_uid))
                {
                    FightM.instance._lockUid = fish.getUniId();
                    //var lockMsg:C2s_12031 = new C2s_12031();
                    _c2s_12031.uid = fish.getUniId();
                    WebSocketManager.instance.send(12031, _c2s_12031);
                }
                _lockShootInterval = 0;
                return true;
            }
            return false;
        }

        private var _shakeTimes:int = 0;
        private var _shakeAx:Number = 0;
        private var _shakeAy:Number = 0;
        private var _shakeTime:Number = 0;
        private var _shakeCastTime:Number = 0;

        private function fightShake(ax:Number, ay:Number, duration:Number, times:int):void
        {
            if (_shakeTimes <= 0)
            {
                _shakeTimes = times;
                _shakeAx = ax;
                _shakeAy = ay;
                _shakeTime = duration;
                _shakeCastTime = 0;
            }
        }

        private function shakeUpdate():void
        {
            if (_shakeTimes > 0)
            {
                _shakeCastTime += Laya.timer.delta / 1000;
                if (_shakeCastTime >= _shakeTime)
                {
                    _shakeTimes -= 1;
                    _shakeCastTime = 0;
                    _fightRoot.pos(0, 0);
                }
                else
                {
                    var percent:Number = _shakeCastTime / _shakeTime;
                    _fightRoot.pos(_shakeAx * Math.sin(percent * 2 * Math.PI), _shakeAy * Math.cos(percent * 2 * Math.PI));
                }
            }
        }

        public function bgShaderUpdate():void
        {
            //			_bgSpriteF.update();
            //			_bgSpriteFR.update();
            //			_bgSpriteM.update();
            //			_bgSpriteMR.update();
        }

        private function onLoop():void
        {
            update(Laya.timer.delta / 1000);
            checkBoomSelectFlag();
            shakeUpdate();
            FightM.instance.update(Laya.timer.delta / 1000);
            bgShaderUpdate();
        }

        private function start():void
        {
            //			_bgSprite.visible = true;
            //			_bgSpriteM.visible = true;
            //			_bgSpriteF.visible = true;
            _bgImgMove.reset();
            _jellyEffect.reset();
            Laya.timer.frameLoop(1, this, this.onLoop);
        }

        private function stop():void
        {
            exitArea(true);
            Laya.timer.clear(this, this.onLoop);
        }

        public function reset():void
        {
            exitArea(false);
            Laya.timer.clear(this, this.onLoop);
        }

        private function parseFishData(data:*):void
        {
            parseFishesBornData(data as int);
        }

        private function newBullet(data:*):void
        {
            if (_curAreaId > 0)
            {
                bornBullet(data as BulletInfo);
            }
        }

        private var _protoBulletHitInfo:ProtoBulletHitInfo = new ProtoBulletHitInfo();

        private function syncBulletHit(bulletArray:Array):void
        {
            //var bulletHitInfo:ProtoBulletHitInfo = new ProtoBulletHitInfo();
            var bullet:Bullet;
            for (var i:int = 0; i < bulletArray.length; i++)
            {
                //bulletHitInfo = bulletArray[i] as ProtoBulletHitInfo;
                _protoBulletHitInfo.p = bulletArray[i];
                for (var j:int = 0; j < _bulletArray.length; j++)
                {
                    bullet = _bulletArray[j] as Bullet;
                    if (bullet.getUniId() == _protoBulletHitInfo.getUniId())
                    {
                        bullet.onlineHitTarget(_protoBulletHitInfo);
                        break;
                    }
                }
            }
        }

        private var _protoFishInfo:ProtoFishInfo = new ProtoFishInfo();

        private function syncFish(fishArray:Array):void
        {
            //var fishInfo:ProtoFishInfo = new ProtoFishInfo();
            var findFish:Boolean;
            var fish:Fish;
            for (var i:int = 0; i < fishArray.length; i++)
            {
                //fishInfo = fishArray[i] as ProtoFishInfo;
                _protoFishInfo.p = fishArray[i] as Array;
                findFish = false;
                for (var j:int = 0; j < _fishArray.length; j++)
                {
                    fish = _fishArray[j] as Fish;
                    if (fish.getUniId() === _protoFishInfo.getUniId())
                    {
                        fish.syncOnlineData(_protoFishInfo);
                        findFish = true;
                        break;
                    }
                }
                //				findFish = true;
                if (!findFish)
                {
                    var layerIndex:int = ConfigManager.getConfValue("cfg_fish", _protoFishInfo.getFishId(), "layer") as int;
                    var tmp:Fish = Fish.create(_protoFishInfo.getFishId(), _layers[layerIndex]);
                    tmp.setSkillBoomSelectBoomFlag(_skillBoomSelectFlag);

                    //if(_clearUpAni)
                    {
                        if (_clearUpCastTime < _clearUpTotalTime)
                        {
                            tmp.clearUp(_clearUpDir, _clearUpTotalTime, _clearUpCastTime);
                        }
                    }
                    var syncOk:Boolean = tmp.syncOnlineData(_protoFishInfo);
                    if (syncOk)
                    {
                        playCallEffect(tmp);
                        playBossComeIn(tmp);
                        _fishArray.push(tmp);
                    }
                    else
                    {
                        tmp.destroy();
                    }
                }
            }
        }

        private var _multiGetCoinArrayX:Array = [0, -20, 20, -40, 40];
        private var _multiGetCoinArrayY:Array = [0, -20, 20, -40, 40];

        //private var _agentGetInfo:AgentGetInfo = new AgentGetInfo();
        private function showNormalFishCoinGetEffect(fish:Fish, getCoinInfo:ShowGetCoinInfo, seat_id:int, delayShow:Number, refPos:Point, coinNum:int, agent:int, boomShow:Boolean = false):void
        {
            var isOwnGet:Boolean = (seat_id == FightM.instance.seatId);
            if (fish.getCatchShow() <= 0 || fish.isAlive() || boomShow)
            {
                var aEffect:AwardEffect = AwardEffect.create(coinNum, refPos, isOwnGet, _fish_up_layers[GameConst.award_effect_layer_index], delayShow);
                _awardArray.push(aEffect);
            }

            if (!FightM.instance.coinShootScene())
            {
                return;
            }

            var randArray:Array = new Array();
            var coinFly:Array = ConfigManager.getConfValue("cfg_fish", fish.getFishId(), "coin_fly") as Array;
            var count:int = Math.floor(coinFly.length / 3);
            var j:int = 0;
            for (j = 0; j < 8; j++)
            {
                randArray.push(Math.random());
            }

            getCoinInfo.useTime = 0;
            getCoinInfo.seat_id = FightM.instance.getShowSeatId(seat_id);
            getCoinInfo.goodId = GameConst.currency_coin;
            getCoinInfo.delay = delayShow;
            getCoinInfo.isOwn = (seat_id == FightM.instance.seatId);
            getCoinInfo.rnd = randArray;

            for (j = 0; j < count; j++)
            {
                getCoinInfo.pos_x = refPos.x + coinFly[j * 3];
                getCoinInfo.pos_y = refPos.y + coinFly[j * 3 + 1];
                getCoinInfo.delay = delayShow + coinFly[j * 3 + 2];
                GameEventDispatch.instance.event(GameEvent.ShowGetGoodsEffect, getCoinInfo);
            }
            var agentGetInfo:AgentGetInfo = new AgentGetInfo();
            agentGetInfo.t = GameConst.currency_coin;
            agentGetInfo.v = coinNum;
            agentGetInfo.leftTime = getCoinInfo.useTime;
            agentGetInfo.ag = agent;
            FightM.instance.addAgentGetInfo(agentGetInfo);
        }

        private var _protoCatchAward:ProtoCatchAward = new ProtoCatchAward();

        private function showNormalFishGoodsGetEffect(fish:Fish, getCoinInfo:ShowGetCoinInfo, catchInfo:ProtoCatchFish):int
        {
            var refPos:Point;
            var award:ProtoCatchAward = _protoCatchAward;//new ProtoCatchAward();
            var coinGet:Number = 0;
            var delayShow:Number = 0;
            var agentGetInfo:AgentGetInfo;
            var isOwnGet:Boolean;
            var aw:Array;
            coinGet = 0;
            refPos = fish.getCenterPosition();

            isOwnGet = false;
            var seatInfo:ProtoSeatInfo = FightM.instance.getSeatInfoByAgent(catchInfo.getAg());
            if (!seatInfo)
            {
                seatInfo = catchInfo.seat_info;
            }
            if (seatInfo)
            {
                isOwnGet = seatInfo.seat_id == FightM.instance.seatId;
            }
            else
            {

            }
            delayShow = 0;
            aw = catchInfo.getAw();
            for (var i:int = 0; i < aw.length; i++)
            {

                //				award = aw[i] as ProtoCatchAward;
                award.p = aw[i];
                if (GameConst.currency_coin == award.getT() || GameConst.currency_contest_score == award.getT())
                {
                    coinGet = award.getV();
                    showNormalFishCoinGetEffect(fish, getCoinInfo, seatInfo.seat_id, delayShow, refPos, award.getV(), catchInfo.getAg());
                    delayShow += 0.2;
                }
                if (GameConst.currency_fish_coin == award.getT())
                {
                    //鱼币获取提示:todo
                    if (isOwnGet)
                    {
                        GameEventDispatch.instance.event(GameEvent.ShowFishCoin, award.getV());
                    }
                }
                var showCount:int = 1;
                if (GameConst.currency_diamond == award.getT())
                //					|| GameConst.currency_exchange == award.getT())
                {
                    showCount = award.getV();
                }
                if (seatInfo)
                {
                    if (GameConst.currency_exp != award.getT() && GameConst.currency_fish_coin != award.getT() &&
                            GameConst.currency_coin != award.getT())
                    {
                        _extraDrop = true;
                        getCoinInfo.useTime = 0;
                        getCoinInfo.seat_id = FightM.instance.getShowSeatId(seatInfo.seat_id);// seatInfo.seat_id;
                        getCoinInfo.pos_x = refPos.x;
                        getCoinInfo.pos_y = refPos.y;
                        getCoinInfo.goodId = award.getT();
                        getCoinInfo.delay = delayShow;
                        getCoinInfo.isOwn = isOwnGet;
                        for (var l:int = 0; l < showCount; l++)
                        {
                            getCoinInfo.delay = delayShow;
                            GameEventDispatch.instance.event(GameEvent.ShowGetGoodsEffect, getCoinInfo);
                            agentGetInfo = new AgentGetInfo();
                            agentGetInfo.t = award.getT();
                            agentGetInfo.v = award.getV() / showCount;
                            agentGetInfo.leftTime = getCoinInfo.useTime;
                            agentGetInfo.ag = catchInfo.getAg();
                            FightM.instance.addAgentGetInfo(agentGetInfo);
                            delayShow += 0.2;
                        }
                    }
                }
            }
            return coinGet;
        }

        private function showBagFishGoodsGetEffect(fish:Fish, getCoinInfo:ShowGetCoinInfo, catchInfo:ProtoCatchFish):int
        {
            var refPos:Point;
            var award:ProtoCatchAward = _protoCatchAward;//new ProtoCatchAward();
            var coinGet:Number = 0;
            var delayShow:Number = 0;
            var agentGetInfo:AgentGetInfo;
            var isOwnGet:Boolean;
            var aw:Array;
            coinGet = 0;
            refPos = fish.getMoneyBagPosition();
            fish.playMoneyBagBomb();
            isOwnGet = false;
            var seatInfo:ProtoSeatInfo = FightM.instance.getSeatInfoByAgent(catchInfo.getAg());
            if (!seatInfo)
            {
                seatInfo = catchInfo.seat_info;
            }
            if (seatInfo)
            {
                isOwnGet = seatInfo.seat_id == FightM.instance.seatId;
            }
            delayShow = fish.getMoneyBagDelay();
            aw = catchInfo.getAw();
            for (var k:int = 0; k < aw.length; k++)
            {

                //				award = aw[k] as ProtoCatchAward;
                award.p = aw[k];
                if (GameConst.currency_coin == award.getT() || GameConst.currency_contest_score == award.getT())
                {
                    coinGet = award.getV();
                    var aEffect:AwardEffect = AwardEffect.create(award.getV(), refPos, isOwnGet, _fish_up_layers[GameConst.award_effect_layer_index], delayShow);
                    _awardArray.push(aEffect);
                }
                if (GameConst.currency_fish_coin == award.getT())
                {
                    //鱼币获取提示:todo
                    if (isOwnGet)
                    {
                        GameEventDispatch.instance.event(GameEvent.ShowFishCoin, award.getV());
                    }
                }
                var showCount:int = 1;
                if (GameConst.currency_diamond == award.getT())
                {
                    showCount = award.getV();
                }
                if (seatInfo && GameConst.currency_exp != award.getT())
                {
                    getCoinInfo.useTime = 0;
                    getCoinInfo.seat_id = FightM.instance.getShowSeatId(seatInfo.seat_id);
                    getCoinInfo.goodId = award.getT();
                    getCoinInfo.delay = delayShow;
                    getCoinInfo.isOwn = isOwnGet;
                    for (var x:int = 0; x < _multiGetCoinArrayX.length; x++)
                    {
                        for (var y:int = 0; y < _multiGetCoinArrayY.length; y++)
                        {
                            getCoinInfo.pos_x = refPos.x + _multiGetCoinArrayX[x];
                            getCoinInfo.pos_y = refPos.y + _multiGetCoinArrayY[y];
                            GameEventDispatch.instance.event(GameEvent.ShowGetGoodsEffect, getCoinInfo);
                        }
                    }
                    agentGetInfo = new AgentGetInfo();
                    agentGetInfo.t = award.getT();
                    agentGetInfo.v = award.getV();
                    agentGetInfo.leftTime = getCoinInfo.useTime;
                    agentGetInfo.ag = catchInfo.getAg();
                    FightM.instance.addAgentGetInfo(agentGetInfo);
                }
            }
            return coinGet;
        }

        //播放震动
        private function playShake(arr:Array):void
        {
            if (arr[0] == 0 && arr[1] == 0 && arr[2] == 0 && arr[3] == 0)
            {

            } else
            {
                fightShake(arr[0], arr[1], arr[2], arr[3]);
            }
        }

        public function showFishDieCatchInfo(fish, cInfo:Array, delayShowSeatInfo:ProtoSeatInfo):void
        {
            var cinfoArray:Array = [];
            var fishArray:Array = []
            cinfoArray.push(cInfo);
            fishArray.push(fish);
            syncCatchInfo(cinfoArray, fishArray, true, delayShowSeatInfo);
        }

        private var _protoCatchFish:ProtoCatchFish = new ProtoCatchFish();
        private var _getCoinInfo:ShowGetCoinInfo = new ShowGetCoinInfo();

        private function syncCatchInfo(cInfoArray:Array, fishArray:Array = null, fishDieCall:Boolean = false, delayShowSeatInfo:ProtoSeatInfo = null):void
        {
            //			return;
            var needShake:Boolean = false;
            var catchInfo:ProtoCatchFish = _protoCatchFish;//new ProtoCatchFish();
            var fish:Fish;
            var playSound:Boolean = false;
            var coinGet:Number = 0;
            var getCoinInfo:ShowGetCoinInfo = _getCoinInfo;//new ShowGetCoinInfo();
            _extraDrop = false;
            if (!fishArray)
            {
                fishArray = _fishArray;
            }
            for (var i:int = 0; i < cInfoArray.length; i++)
            {
                //catchInfo = cInfoArray[i] as ProtoCatchFish;
                catchInfo.p = cInfoArray[i];
                for (var j:int = 0; j < fishArray.length; j++)
                {
                    fish = fishArray[j] as Fish;
                    if (fish.getUniId() === catchInfo.getU())
                    {
                        var seatInfo:ProtoSeatInfo = FightM.instance.getSeatInfoByAgent(catchInfo.getAg());
                        catchInfo.seat_info = delayShowSeatInfo;
                        if (fish.getCatchType() == GameConst.scene_play_black_hole && !fishDieCall)
                        {
                            fish.setDieCatchInfo(cInfoArray[i], seatInfo);
                            break;
                        }

                        if (!seatInfo)
                        {
                            seatInfo = catchInfo.seat_info;
                        }
                        if (!seatInfo)
                        {
                            break;
                        }
                        if (fish.isCoinBoss())
                        {
                            coinGet = showBagFishGoodsGetEffect(fish, getCoinInfo, catchInfo);
                        }
                        else
                        {
                            coinGet = showNormalFishGoodsGetEffect(fish, getCoinInfo, catchInfo);
                        }


                        //捕获后的前端特殊表示
                        if (1 == catchInfo.getB() && fish.getCatchShow() > 0 && coinGet > 0 && !fish.isAlive())
                        {
                            var catchShowType:int = fish.getCatchShow();
                            var aniName:String = fish.getCatchShowAniName();
                            var shakeArr:Array = fish.shakeArr;
                            var aniActionName:String = fish.getCatchShowAniActionName();
                            var catchShowPos:Point = fish.getCatchShowPos(FightM.instance.getShowSeatId(seatInfo.seat_id));
                            var shareScreen:Boolean = false;
                            //发财了
                            if (!ENV.isShowDied())
                            {
                                if (seatInfo.seat_id == FightM.instance.seatId && FightM.instance.coinShootScene())
                                {
                                    var eff:FullScreenCoinEffect = FullScreenCoinEffect.create();//new FullScreenCoinEffect();
                                    eff.play(_fightUiUpLayer);
                                    //wx bossShare
                                    //if(fish.iffishBoss() && WxC.isInMiniGame()){
                                    shareScreen = true;
                                    //}
                                }
                            }
                            playShake(shakeArr);
                            if (!ENV.isShowDied())
                            {
                                var catchShowEffect:CatchShowEffect = CatchShowEffect.create(catchShowType, coinGet,//Math.floor(coinGet * fish.getCatchShowRate()),
                                        catchShowPos, _fightUiUpLayer, aniName, aniActionName, seatInfo);
                                catchShowEffect.setBossCatch(shareScreen);
                                _catchShowEffect.push(catchShowEffect);
                            }
                        }
                        if (fish.playCatchSound())
                        {
                            playSound = true;
                        }

                        if (fish.isBoss())
                        {
                            needShake = false;
                        }
                        break;
                    }
                }
            }
            if (needShake == true)
            {
                fightShake(4, 14, 0.15, 4);
            }
            var soundPath:String;
            if (playSound)
            {
                soundPath = ConfigManager.getConfValue("cfg_global", 1, "get_coin_sound") as String;
                GameSoundManager.playSound(soundPath);

            }
            if (_extraDrop)
            {
                soundPath = ConfigManager.getConfValue("cfg_global", 1, "extra_drop_sound") as String;
                GameSoundManager.playSound(soundPath);
            }
            //GameEventDispatch.instance.event(GameEvent.FightCoinUpdate, null);
        }


        private function switchState(type:int):void
        {
            switch (type)
            {
                case 1:
                {

                    break;
                }
                case 2:
                {

                    break;
                }
                default:
                {
                    break;
                }
            }
        }


        private function syncBullet(bulletArray:Array):void
        {
            var bullet:Bullet;
            //var info:ProtoBulletInfo = new ProtoBulletInfo();
            var find:Boolean;
            var bInfo:BulletInfo;
            for (var i:int = 0; i < bulletArray.length; i++)
            {
                _protoBulletInfo.p = bulletArray[i];
                find = false;
                for (var j:int = 0; j < _bulletArray.length; j++)
                {
                    bullet = _bulletArray[j] as Bullet;
                    if (bullet.getUniId() == _protoBulletInfo.getUniId())
                    {
                        find = true;
                        break;
                    }
                }
                if (!find)
                {
                    //bInfo = new BulletInfo();
                    _bulletInfo.endX = _protoBulletInfo.getEndX();
                    _bulletInfo.endY = _protoBulletInfo.getEndY();
                    _bulletInfo.startX = _protoBulletInfo.getStartX();
                    _bulletInfo.startY = _protoBulletInfo.getStartY();
                    _bulletInfo.count = _protoBulletInfo.getCount();
                    _bulletInfo.sk = _protoBulletInfo.getSk();
                    _bulletInfo.sr = _protoBulletInfo.getSr();
                    //bInfo.id = info.id;
                    _bulletInfo.uniId = _protoBulletInfo.getUniId();
                    _bulletInfo.fuid = _protoBulletInfo.getFuid();
                    _bulletInfo.index = _protoBulletInfo.getIndex();
                    _bulletInfo.showDelay = 0;
                    _bulletInfo.tick = _protoBulletInfo.getTick();
                    _bulletInfo.agent = _protoBulletInfo.getAgent();
                    bornBullet(_bulletInfo);
                }
            }
        }

        private function onlineDataSync(data:*):void
        {
            var fish:Fish;
            var syncInfo:S2c_fightSync = data as S2c_fightSync;

            if (syncInfo.maxTick)
            {
                _curTick = syncInfo.tick;
                _syncTick = syncInfo.tick;
                _maxTick = syncInfo.maxTick;
            }
            if (syncInfo.bulletH)
            {
                syncBulletHit(syncInfo.bulletH);
            }
            if (syncInfo.bullet)
            {
                syncBullet(syncInfo.bullet);
            }
            if (syncInfo.fish)
            {
                syncFish(syncInfo.fish);
            }
            if (syncInfo.cInfo)
            {
                syncCatchInfo(syncInfo.cInfo);
            }
            for (var j:int = 0; j < _fishArray.length; j++)
            {
                fish = _fishArray[j] as Fish;
                if (fish.isCoinBoss())
                {
                    fish.setMoneyBagSize(syncInfo.bac);
                    break;
                }
            }

            if (syncInfo.cut)
            {
                var useTime:Number = syncInfo.cuut / 100;
                if (useTime < syncInfo.cut)
                {
                    clearUpFish(useTime, syncInfo.cut, syncInfo.cud);
                }
            }

        }

        public function getCallFishNum():int
        {
            var ret:int = 0;
            var fish:Fish;
            for (var i:int = 0; i < _fishArray.length; i++)
            {
                fish = _fishArray[i] as Fish;
                if (fish.isCallFish())
                {
                    ret += 1;
                }
            }
            return ret;
        }


        private function boomSkill(data:*):void
        {
            var protoData:S2c_12029 = data as S2c_12029;
            var fish:Fish;
            var i:int = 0;
            for (i = 0; i < _fishArray.length; i++)
            {
                fish = _fishArray[i] as Fish;
                if (fish.getUniId() == protoData.uid)
                {
                    fish.kill();
                    break;
                }
                fish = null;
            }


            //			var ani:SpineTemplet = new SpineTemplet("baozha");
            var fishDieDelay:Number = 0;
            var layer:Sprite = _fish_up_layers[GameConst.boom_effect_layer_index] as Sprite;
            protoData.x = FightM.instance.getMirrorPosXByOwnSeat(protoData.x);
            protoData.y = FightM.instance.getMirrorPosYByOwnSeat(protoData.y);
            protoData.x = GameTools.designPosXMapScreenPosX(protoData.x);
            protoData.y = GameTools.designPosYMapScreenPosY(protoData.y);
            //			ani.pos(protoData.x, protoData.y);
            //			ani.play(0, false);
            //			layer.addChild(ani);
            //			_boomAniArray.push(ani);
            var posData:Object = new Object();
            posData.getPos = false;
            posData.seat_id = FightM.instance.getShowSeatId(protoData.seat_id);//protoData.seat_id;
            GameEventDispatch.instance.event(GameEvent.GetPaoPos, posData);
            if (posData.getPos)
            {
                var paoRotationData:Object = new Object();

                var bEffect:BoomEffect = BoomEffect.create(protoData.sid, "baozha2", new Point(posData.x, posData.y),
                        new Point(protoData.x, protoData.y), _fightUiUpLayer, layer);
                _boomEffectArray.push(bEffect);
                fishDieDelay = bEffect.getRunTime() + 0.2;
                paoRotationData.seat_id = posData.seat_id;
                paoRotationData.angle = bEffect.getAngle();
                GameEventDispatch.instance.event(GameEvent.SetPaoRotation, paoRotationData);
            }

            if (fish)
            {
                fish.addDieRunTime(fishDieDelay);

                //var getCoinInfo:ShowGetCoinInfo = new ShowGetCoinInfo();
                showNormalFishCoinGetEffect(fish, _getCoinInfo, protoData.seat_id, fishDieDelay, fish.getCenterPosition(), protoData.coin, protoData.agent, true);

            }

            if (protoData.seat_id == FightM.instance.seatId)
            {
                _skillBoomSelectFlag = false;
                _skillBoomId = 0;
                for (i = 0; i < _fishArray.length; i++)
                {
                    fish = _fishArray[i] as Fish;
                    fish.setSkillBoomSelectBoomFlag(_skillBoomSelectFlag);
                }
                skillBoomSelectReset();
            }
        }


        public function syncTick(data:*):void
        {
            if (onlineFight())
            {
                if (data && data.tick)
                {
                    var date:Date = new Date();
                    var milli:Number = date.getTime();
                    var delayTick:int = Math.floor((milli - _syncTickStartTime) / (1000 * GameConst.fixed_update_time));
                    _syncTickTime = milli;
                    _curTick = data.tick + delayTick;
                    if (_curTick > _maxTick)
                    {
                        _curTick = Math.floor(_curTick % _maxTick);
                    }
                    _syncTick = _curTick;
                }
            }
        }

        public function getCurTick():int
        {
            return _curTick;
        }

        public function getMaxTick():int
        {
            return _maxTick;
        }

        public function isBulletReachMaxNum():Boolean
        {
            var num:int = 0;
            var bullet:Bullet;
            var tmpNum:int = 0;
            for (var i:int = 0; i < _bulletArray.length; i++)
            {
                bullet = _bulletArray[i] as Bullet;
                if (bullet.getSeatId() == FightM.instance.seatId)
                {
                    if (bullet.isAlive())
                    {
                        num++;
                    }
                }
            }

            var maxBulletNum:int = ConfigManager.getConfValue("cfg_global", 1, "max_bullet_num") as int;
            return num >= maxBulletNum;
        }

        //播放招呼特效
        public function playCallEffect(fish:Fish):void
        {
            if (fish.isCall())
            {
                //				var aniName:String = "call";
                //				var ani:Animation = AnimalManger.instance.load(aniName);
                var ani:SpineTemplet = new SpineTemplet("zhaohuan");
                var refPoint:Point = fish.getCenterPosition();
                var layer:Sprite = _fish_up_layers[GameConst.boom_effect_layer_index] as Sprite;//_layers[0] as Sprite;//_fish_up_layers[GameConst.boom_effect_layer_index] as Sprite;
                //				ani.pivot(ConfigManager.getConfValue("cfg_anicollision", aniName, "pivotX") as Number,
                //					ConfigManager.getConfValue("cfg_anicollision", aniName, "pivotY") as Number);
                ani.pos(refPoint.x, refPoint.y);
                layer.addChild(ani);
                ani.play(0, false);
                _boomAniArray.push(ani);
            }
        }

        //播放鱼的死亡动画
        public function playFishDeadAni(aniName:String, pos:Point):void
        {
            if (aniName.length > 0)
            {
                var ani:SpineTemplet = new SpineTemplet(aniName);
                var layer:Sprite = _fish_up_layers[GameConst.boom_effect_layer_index] as Sprite;
                ani.pos(pos.x, pos.y);
                layer.addChild(ani);
                ani.play(0, false);
                _boomAniArray.push(ani);
            }
        }

        //播放boss来了特效
        public function playBossComeIn(fish:Fish):void
        {
            if (fish.isBossComeIn())
            {
                //				var ani:SpineTemplet = new SpineTemplet("warning");
                //				var layer:Sprite = _fightUiUpLayer;//_fish_up_layers[GameConst.boom_effect_layer_index] as Sprite;
                //				ani.pos(Laya.stage.width / 2, Laya.stage.height / 2);
                //				layer.addChild(ani);
                //				ani.play(fish.fishComeInActionName(), false);
                //				ani.scale(Laya.stage.width / GameConst.design_width, Laya.stage.height / GameConst.design_height, true);
                //				_boomAniArray.push(ani);
                //				fish.playComeSound();
                GameEventDispatch.instance.event(GameEvent.PlayBossComing, fish.getFishId());
            }
        }

        //播放黑洞动画
        public function playBlackHoleEffect(aniName:String, startTime:Number, x:Number, y:Number):void
        {
            var ani:SpineTemplet = new SpineTemplet(aniName);
            var layer:Sprite = _layers[GameConst.fishmaxlayer] as Sprite;//_fish_up_layers[GameConst.boom_effect_layer_index] as Sprite;
            ani.pos(x, y);
            layer.addChild(ani);
            ani.play(0, false);
            _boomAniArray.push(ani);
        }

        public function playFishFormEffect():void
        {

            GameEventDispatch.instance.event(GameEvent.FishTide);
            //			var ani:SpineTemplet = new SpineTemplet("warning");
            //			var layer:Sprite = _fightUiUpLayer;//_fish_up_layers[GameConst.boom_effect_layer_index] as Sprite;
            //			ani.pos(Laya.stage.width / 2, Laya.stage.height / 2);
            //			layer.addChild(ani);
            //			ani.play("H5_yuchaolaixi", false);
            //			_boomAniArray.push(ani);
        }

        public function showFreezeEffect(leftTime:Number):void
        {
            _freezeSprite.visible = leftTime > 0;
            _freezeLeftTime = leftTime;
        }

        public function getRunTick(startTick):int
        {
            var ret:int = 0;
            if (startTick > _curTick)
            {
                if (startTick > _maxTick / 2 && _curTick < _maxTick / 2)
                {
                    //
                    ret = _maxTick - startTick + _curTick;
                }
                else
                {
                    //客户端慢了(只能相信自己的数据，不让会错误传递)
                    //_syncTick += startTick -  _curTick;
                    return 1;
                }
            }
            else
            {
                ret = _curTick - startTick;
                //极限情况客户端比服务器慢了 如 客户端 9000 服务器1 会出问题
                if (ret > (startTick + (_maxTick - _curTick)))
                {
                    ret = (startTick + (_maxTick - _curTick));
                }
            }
            return ret;
        }

        private function freezeSkill(data:*):void
        {
            var protoData:S2c_12028 = data as S2c_12028;
            var fish:Fish;
            _freezeLeftTime = protoData.time - (getRunTick(data.tick) * GameConst.fixed_update_time);
            if (!_freezeSprite.visible)
            {
                _freezeSprite.visible = true;
            }
            for (var i:int = 0; i < _fishArray.length; i++)
            {
                fish = _fishArray[i] as Fish;
                fish.setFreeze(_freezeLeftTime);
            }

        }

        private function clearUpFish(useTime:Number, totalTime:Number, dir:int):void
        {
            var fish:Fish;
            var i:int = 0;
            var particle:GameParticle;
            _clearUpCastTime = useTime;
            _clearUpTotalTime = totalTime;
            _clearUpDir = dir;

            if (FightM.instance.seatId == 2 ||
                    FightM.instance.seatId == 3)
            {
                if (1 == _clearUpDir)
                {
                    _clearUpDir = 2;
                }
                else
                {
                    _clearUpDir = 1;
                }
            }
            for (i = 0; i < _fishArray.length; i++)
            {
                fish = _fishArray[i] as Fish;
                fish.clearUp(_clearUpDir, totalTime, useTime);
            }

            if (!_clearUpParticles)
            {
                _clearUpParticles = [];

                for (i = 0; i < 25; i++)
                {
                    particle = new GameParticle("abbey/H5_loading1.part");
                    particle.rotation = -10;
                    _clearUpParticles.push(particle);
                    _fightRoot.addChild(particle);
                    particle.zOrder = GameConst.fishmaxlayer;
                    particle.y = i * 50 + 30;
                    particle.rotation = -60;
                }
            }
            var scaleX:Number = 1;
            var roate:Number = -60;
            var posX:Number = 0;
            if (2 == _clearUpDir)
            {
                roate = 60
                scaleX = -1;
                posX = Laya.stage.width;
            }
            for (i = 0; i < _clearUpParticles.length; i++)
            {
                particle = _clearUpParticles[i] as GameParticle;
                particle.rotation = roate;
                particle.scaleX = scaleX;
                particle.x = posX;
                particle.visible = true;
                particle.replay();
            }
            if (useTime <= 0)
            {
                playFishFormEffect();
            }
            clearUpAniUpdate(0);
            var soundPath:String = ConfigManager.getConfValue("cfg_global", 1, "tide_sound") as String;
            GameSoundManager.playSound(soundPath);
        }

        private function swimOut(data:*):void
        {
            var protoData:S2c_12023 = data as S2c_12023;
            clearUpFish(0, protoData.t, protoData.d);
        }

        private function wsClose(data:*):void
        {
            if (_curAreaId > 0 && FightM.instance.seatId > 0)
            {
                removeInvalidFish(true);
                removeInvalidBullet(true);
                removeInvalidAwardEffect(true);
                removeInvalidCatchShowEffect(true);
                removeInvalidBoomEffect(true)
            }
        }

        private function wsError(data:*):void
        {
            if (_curAreaId > 0 && FightM.instance.seatId > 0)
            {
                removeInvalidFish(true);
                removeInvalidBullet(true);
                removeInvalidAwardEffect(true);
                removeInvalidCatchShowEffect(true);
                removeInvalidBoomEffect(true)
            }
        }

        public function setLockLinePosArray(posArray:Array):void
        {
            var sprite:Sprite;
            var tmpArray:Array;
            _lockLinePosArray = posArray;
            for (var i:int = 0; i < 4; i++)
            {
                tmpArray = _lockLineArray[i] as Array;
                sprite = tmpArray[0] as Sprite;
                sprite.pos(_lockLinePosArray[i * 2], _lockLinePosArray[i * 2 + 1]);
            }
        }

        private function screenResize():void
        {
            var fish:Fish;
            var scale:Number = Laya.stage.width / GameConst.design_width;
            var scaleRefX:Boolean = true;
            var i:int = 0;
            if (Laya.stage.height / GameConst.design_height > scale)
            {
                scale = Laya.stage.height / GameConst.design_height;
                scaleRefX = false;
            }
            for (i = 0; i < _fishArray.length; i++)
            {
                fish = _fishArray[i] as Fish;
                fish.screenResize();
            }
            _bgImgMove.screenResize();
            _freezeSprite.scale(scale, scale, true);
            if (scaleRefX)
            {
                _freezeSprite.pos(0, -(scale * GameConst.design_height - GameConst.design_height) / 2);
            }
            else
            {
                _freezeSprite.pos(-(scale * GameConst.design_width - GameConst.design_width) / 2, 0);
            }
            var catchShowEffect:CatchShowEffect;
            for (i = 0; i < _catchShowEffect.length; i++)
            {
                catchShowEffect = _catchShowEffect[i] as CatchShowEffect;
                catchShowEffect.screenResize();
            }

            var sprite:Sprite;
            var lockArray:Array;

            for (i = 0; i < 4; i++)
            {
                lockArray = _lockLineArray[0] as Array;
                sprite = lockArray[0] as Sprite;
            }
        }

        private function SystemReset(data:*):void
        {
            reset();
        }

        private function onlineFight():Boolean
        {
            return _curAreaId > 0 && FightM.instance.seatId > 0;
        }

        public function getCurAreaId():int
        {
            return _curAreaId;
        }

        public function getWebScale():Number
        {
            return _sceneWebScale;
        }

        private function syncSkipCoin(data:*):void
        {
            FightM.instance.setSkipCoin(FightM.instance.seatId, data.coin);
            GameEventDispatch.instance.event(GameEvent.FightCoinUpdate, null);
        }

        private var _s2c_shootBullet:S2c_shootBullet = new S2c_shootBullet();

        private function onlineNewBullet(data:*):void
        {
            //新的子弹
            if (onlineFight())
            {
                var info:S2c_shootBullet = _s2c_shootBullet;//new S2c_shootBullet();
                info.p = data.p;
                //data as S2c_shootBullet;
                var bInfo:BulletInfo = _bulletInfo;//new BulletInfo();
                bInfo.endX = info.getEndX();
                bInfo.endY = info.getEndY();
                bInfo.startX = info.getStartX();
                bInfo.startY = info.getStartY();
                bInfo.sk = info.getSk();
                bInfo.sr = info.getSr();
                //bInfo.id = info.id;
                bInfo.uniId = info.getUniId();
                bInfo.fuid = info.getFuid();
                bInfo.index = info.getIndex();
                bInfo.count = info.getHitCount();
                bInfo.agent = info.getAgent();
                bInfo.showDelay = 0;
                bInfo.tick = info.getTick();

                if (FightM.instance.seatId != info.getIndex())
                {
                    bornBullet(bInfo);
                    if (FightM.instance.isGoldPoolScene())
                    {
                        FightM.instance.goldPoolTotalValueAdd(ConfigManager.getConfValue("cfg_battery", info.getBt(), "prize") as int);
                        GameEventDispatch.instance.event(GameEvent.UpdateGoldPoolInfo);
                    }
                }

                //if(FightM.instance.seatId != info.getIndex())
                {
                    if (!FightM.instance.coinShootScene())
                    {
                        FightM.instance.seatAddContestCoin(info.getIndex(), info.getAgent(), info.getCoin());
                    }
                    else
                    {
                        FightM.instance.seatAddCoin(info.getIndex(), info.getAgent(), info.getCoin(), true);
                    }

                }
                if (1 == info.getM())
                {
                    if (FightM.instance.seatId != info.getIndex())
                    {
                        GameEventDispatch.instance.event(GameEvent.OnlineBullet, bInfo);
                    }
                }

                GameEventDispatch.instance.event(GameEvent.FightCoinUpdate, info);
            }
        }

        public function initSwimPath():void
        {
            var pathSheet:Object = ConfigManager.getConfBySheet("cfg_fishgrouppath");
            for (var pathId in pathSheet)
            {
                Fish.initPathInfo(parseInt(pathId));
            }
        }

        public function preLoadAwardEffect():void
        {
            var refPos:Point = new Point(0, 0);
            for (var i:int = 0; i < 10; i++)
            {
                var aEffect:AwardEffect = AwardEffect.create(1, refPos, false, _fish_up_layers[GameConst.award_effect_layer_index], 0);
                aEffect.destroy();
            }
        }

        public function preLoadCatchShowEffect():void
        {
            var i:int = 0;
            var catchShowPos:Point = new Point();
            var coinGet:Number = 0;
            var aniName:Array = ["zhuanpan", "facaile", "zhuanfanle"];
            var aniActionName:Array = ["H5_zhuanpan", "facaile", "zhuanfanle"];
            for (i = 1; i <= 3; i++)
            {
                for (var j:int = 0; j < 5; j++)
                {
                    var catchShowEffect:CatchShowEffect = CatchShowEffect.create(i, coinGet,
                            catchShowPos, _fightUiUpLayer, aniName[i - 1], aniActionName[i - 1], null, true);
                    catchShowEffect.destroy();
                }
            }
            for (i = 0; i < 3; i++)
            {
                var fullScreenCoin:FullScreenCoinEffect = FullScreenCoinEffect.create(true);
                fullScreenCoin.play(_fightUiUpLayer);
                fullScreenCoin.stop();
            }
        }

        public function getFightUiUpLayer():Sprite
        {
            return _fightUiUpLayer;
        }

    }
}
