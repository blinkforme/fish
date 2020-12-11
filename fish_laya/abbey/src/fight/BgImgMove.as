package fight
{
    import model.FightM;

    import laya.display.Sprite;

    import manager.GameConst;
    import manager.SpineTemplet;

    public class BgImgMove
    {

        private var speedBg:Number = 0;
        private var speedMBg:Number = 0;
        private var speedFBg:Number = 0;
        private var bgSpriteL:Sprite = null;
        private var bgSpriteLChild:Sprite = null;
        private var bgSpriteR:Sprite = null;
        private var bgSpriteRChild:Sprite = null;
        private var mbgSpriteL:Sprite = null;
        private var mbgSpriteLChild:Sprite = null;
        private var mbgSpriteR:Sprite = null;
        private var mbgSpriteRChild:Sprite = null;
        private var fbgSpriteL:Sprite = null;
        private var fbgSpriteLChild:Sprite = null;
        private var fbgSpriteR:Sprite = null;
        private var fbgSpriteRChild:Sprite = null;

        public function BgImgMove()
        {

        }

        public function setBgInfo(spriteL:Sprite, spriteR:Sprite):void
        {
            bgSpriteL = spriteL;
            bgSpriteR = spriteR;
            bgSpriteL.y = -20;
            bgSpriteR.y = -20;
            bgSpriteLChild = new Sprite();
            bgSpriteLChild.loadImage("scene/scene_1_1_2.png");
            bgSpriteLChild.x = bgSpriteL.x + 960 * bgSpriteL.scaleX;
            bgSpriteLChild.y = -20;
            bgSpriteL.parent.addChild(bgSpriteLChild);
            bgSpriteRChild = new Sprite();
            bgSpriteRChild.loadImage("scene/scene_1_1_2.png");
            bgSpriteRChild.y = -20;
            bgSpriteR.parent.addChild(bgSpriteRChild);
            bgSpriteRChild.x = bgSpriteR.x + 960 * bgSpriteR.scaleX;
            speedBg = 4;
        }

        public function setMbgInfo(spriteL:Sprite, spriteR:Sprite):void
        {
            var spine:SpineTemplet = null;
            mbgSpriteL = spriteL;
            mbgSpriteR = spriteR;

            mbgSpriteL.y = Laya.stage.height - 522;
            mbgSpriteR.y = Laya.stage.height - 522;
            //			mbgSpriteLChild = new myShaderSprite();
            //			mbgSpriteLChild.loadImage("scene/scene_1_2_2.png");
            //			mbgSpriteLChild.x = mbgSpriteL.x + 960 * mbgSpriteL.scaleX;
            //
            //			mbgSpriteL.parent.addChild(mbgSpriteLChild);
            //			mbgSpriteRChild = new myShaderSprite();
            //			mbgSpriteRChild.loadImage("scene/scene_1_2_2.png");
            //			mbgSpriteR.parent.addChild(mbgSpriteRChild);
            //			mbgSpriteRChild.x = mbgSpriteR.x + 960 * mbgSpriteR.scaleX;


            //			spine = new SpineTemplet("shuicao5");
            //			spine.pos(1040 - 960, 580 - 199);
            //			spine.scale(0.9,0.9,true);
            //			mbgSpriteLChild.addChild(spine);
            //			spine = new SpineTemplet("shuicao3");
            //			spine.pos(1000 - 960, 585 - 199);
            //			mbgSpriteLChild.addChild(spine);
            //
            //			spine.scale(0.9,0.9,true);
            //			spine = new SpineTemplet("shuicao5");
            //			spine.pos(1040 - 960, 580 - 199);
            //			mbgSpriteRChild.addChild(spine);
            //			spine = new SpineTemplet("shuicao3");
            //			spine.pos(1000 - 960, 585 - 199);
            //			mbgSpriteRChild.addChild(spine);

            speedMBg = 3;
        }

        public function setFbgInfo(spriteL:Sprite, spriteR:Sprite):void
        {
            var spine:SpineTemplet = null;
            fbgSpriteL = spriteL;
            fbgSpriteR = spriteR;
            fbgSpriteL.y = Laya.stage.height - 127;
            fbgSpriteR.y = Laya.stage.height - 127;
            //			fbgSpriteLChild = new myShaderSprite();
            //			fbgSpriteLChild.loadImage("scene/scene_1_3_2.png");
            //			fbgSpriteLChild.x = fbgSpriteL.x + 960 * fbgSpriteL.scaleX;
            //			fbgSpriteL.parent.addChild(fbgSpriteLChild);
            //			fbgSpriteRChild = new myShaderSprite();
            //			fbgSpriteRChild.loadImage("scene/scene_1_3_2.png");
            //			fbgSpriteR.parent.addChild(fbgSpriteRChild);
            //			fbgSpriteRChild.x = fbgSpriteRChild.x + 960 + fbgSpriteRChild.scaleX;


            //			spine = new SpineTemplet("shuicao3");
            //			spine.pos(480, 227);
            //			fbgSpriteL.addChild(spine);
            //			spine = new SpineTemplet("shuicao5");
            //			spine.pos(1250 - 960, 227);
            //			fbgSpriteLChild.addChild(spine);
            //
            //
            //			spine = new SpineTemplet("shuicao3");
            //			spine.pos(480, 227);
            //			fbgSpriteR.addChild(spine);
            //			spine = new SpineTemplet("shuicao5");
            //			spine.pos(1250 - 960, 227);
            //			fbgSpriteRChild.addChild(spine);

            speedFBg = 2;
        }

        public function reset():void
        {
            bgSpriteL.x = -450 - Math.ceil(200 * Math.random());
            bgSpriteR.x = bgSpriteL.x + 1920 * bgSpriteL.scaleX;
            mbgSpriteL.x = -450 - Math.ceil(200 * Math.random());
            mbgSpriteR.x = mbgSpriteL.x + 1920 * mbgSpriteL.scaleX;
            fbgSpriteL.x = -450 - Math.ceil(200 * Math.random());
            fbgSpriteR.x = fbgSpriteL.x + 1920 * fbgSpriteL.scaleX;

            //bgSpriteL.y = -20;
            //bgSpriteR.y = -20;

            bgSpriteLChild.x = bgSpriteL.x + 960 * bgSpriteL.scaleX;
            bgSpriteRChild.x = bgSpriteR.x + 960 * bgSpriteR.scaleX;
            //			mbgSpriteLChild.x = mbgSpriteL.x + 960 * mbgSpriteL.scaleX;
            //			mbgSpriteRChild.x = mbgSpriteR.x + 960 * mbgSpriteR.scaleX;
            //			fbgSpriteRChild.x = fbgSpriteR.x + 960 + fbgSpriteR.scaleX;
            //			fbgSpriteLChild.x = fbgSpriteL.x + 960 * fbgSpriteL.scaleX;
            //
            mbgSpriteL.y = Laya.stage.height - mbgSpriteL.scaleY * 522;
            //			mbgSpriteLChild.y = mbgSpriteL.y;
            mbgSpriteR.y = Laya.stage.height - mbgSpriteR.scaleY * 522;
            //			mbgSpriteRChild.y = mbgSpriteR.y;
            fbgSpriteL.y = Laya.stage.height - fbgSpriteL.scaleY * 127;
            //			fbgSpriteLChild.y = fbgSpriteL.y;
            fbgSpriteR.y = Laya.stage.height - fbgSpriteR.scaleY * 127;
            //			fbgSpriteRChild.y = fbgSpriteR.y;

            bgSpriteL.visible = true;
            bgSpriteLChild.visible = true;
            bgSpriteR.visible = true;
            bgSpriteRChild.visible = true;

            mbgSpriteL.visible = true;
            //			mbgSpriteLChild.visible = true;
            mbgSpriteR.visible = true;
            //			mbgSpriteRChild.visible = true;
            fbgSpriteL.visible = true;
            //			fbgSpriteLChild.visible = true;
            fbgSpriteR.visible = true;
            //			fbgSpriteRChild.visible = true;

            update(0);

        }

		private var _preLayaStageHeight:Number = 0;
        public function screenResize():void
        {
			if(_preLayaStageHeight == Laya.stage.height)
			{
				return;
			}
			_preLayaStageHeight = Laya.stage.height;
            var scale:Number = (Laya.stage.height + 40) / GameConst.design_height;
            bgSpriteL.scale(scale, scale, true);
            bgSpriteLChild.scale(scale, scale, true);
            bgSpriteR.scale(scale, scale, true);
            bgSpriteRChild.scale(scale, scale, true);
            mbgSpriteL.scale(scale, scale, true);
            //			mbgSpriteLChild.scale(scale, scale, true);
            mbgSpriteR.scale(scale, scale, true);
            //			mbgSpriteRChild.scale(scale, scale, true);
            fbgSpriteL.scale(scale, scale, true);
            //			fbgSpriteLChild.scale(scale, scale, true);
            fbgSpriteR.scale(scale, scale, true);
            //			fbgSpriteRChild.scale(scale, scale, true);


            if (FightM.instance.seatId > 0)
            {
                reset();
            }
        }

        public function hide():void
        {
            bgSpriteL.visible = false;
            bgSpriteLChild.visible = false;
            bgSpriteR.visible = false;
            bgSpriteRChild.visible = false;
            mbgSpriteL.visible = false;
            //			mbgSpriteLChild.visible = false;
            mbgSpriteR.visible = false;
            //			mbgSpriteRChild.visible = false;
            fbgSpriteL.visible = false;
            //			fbgSpriteLChild.visible = false;
            fbgSpriteR.visible = false;
            //			fbgSpriteRChild.visible = false;
        }

        private function updateVisible(tmpSprite:Sprite):void
        {
            if (tmpSprite.x > Laya.stage.width)
            {
                tmpSprite.visible = false;
            }
            else if (tmpSprite.x < -960 * bgSpriteL.scaleX)
            {
                tmpSprite.visible = false;
            }
            else
            {
                tmpSprite.visible = true;
                //				tmpSprite.visible = false;
            }
        }


        public function update(delta:Number):void
        {
            var tmp:Sprite = null;
            bgSpriteL.x = bgSpriteL.x - delta * speedBg;
            bgSpriteR.x = bgSpriteR.x - delta * speedBg;

            if (bgSpriteL.x < -1920 * bgSpriteL.scaleX)
            {
                bgSpriteL.x = bgSpriteL.x + 1920 * 2 * bgSpriteL.scaleX;
                tmp = bgSpriteL;
                bgSpriteL = bgSpriteR;
                bgSpriteR = tmp;
            }

            mbgSpriteL.x = mbgSpriteL.x - delta * speedMBg;
            mbgSpriteR.x = mbgSpriteR.x - delta * speedMBg;
            if (mbgSpriteL.x < -1920 * mbgSpriteL.scaleX)
            {

                mbgSpriteL.x = mbgSpriteL.x + 1920 * 2 * mbgSpriteL.scaleX;
                tmp = mbgSpriteL;
                mbgSpriteL = mbgSpriteR;
                mbgSpriteR = tmp;
            }

            fbgSpriteL.x = fbgSpriteL.x - delta * speedFBg;
            fbgSpriteR.x = fbgSpriteR.x - delta * speedFBg;

            if (fbgSpriteL.x < -1920 * fbgSpriteL.scaleX)
            {
                fbgSpriteL.x = fbgSpriteL.x + 1920 * 2 * fbgSpriteL.scaleX;
                tmp = fbgSpriteL;
                fbgSpriteL = fbgSpriteR;
                fbgSpriteR = tmp;
            }

            bgSpriteLChild.x = bgSpriteL.x + 960 * bgSpriteL.scaleX;
            bgSpriteRChild.x = bgSpriteR.x + 960 * bgSpriteR.scaleX;
            //			mbgSpriteLChild.x = mbgSpriteL.x + 960 * mbgSpriteL.scaleX;
            //			mbgSpriteRChild.x = mbgSpriteR.x + 960 * mbgSpriteR.scaleX;
            //			fbgSpriteRChild.x = fbgSpriteR.x + 960 + fbgSpriteR.scaleX;
            //			fbgSpriteLChild.x = fbgSpriteL.x + 960 * fbgSpriteL.scaleX;
            //

            updateVisible(bgSpriteL);
            updateVisible(bgSpriteLChild);
            updateVisible(bgSpriteR);
            updateVisible(bgSpriteRChild);

            //			updateVisible(mbgSpriteL);
            //			updateVisible(mbgSpriteLChild);
            //			updateVisible(mbgSpriteR);
            //			updateVisible(mbgSpriteRChild);
            //			updateVisible(fbgSpriteL);
            //			updateVisible(fbgSpriteLChild);
            //			updateVisible(fbgSpriteR);
            //			updateVisible(fbgSpriteRChild);
        }

    }
}
