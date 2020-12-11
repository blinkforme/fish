package view.rewardTip
{
    import laya.display.Animation;
    import laya.display.Sprite;
    import laya.maths.Point;
    import laya.ui.FontClip;
    import laya.ui.Image;
    import laya.ui.Label;
    import laya.ui.View;
    import laya.utils.Handler;
    import laya.utils.Tween;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.SpineTemplet;

    public class ReardBox
    {
        private var skin:Image;
        private var ani:Animation;
        private var _rewardView:View;
        private var countTxt:Label;
        private var clip:FontClip;
        private var spineRoot:Sprite;
        private var spine:SpineTemplet;

        public function ReardBox(url:String, point:Point, rewardview:View, count:int)
        {
            clip = new FontClip("font/shuzi.png", "+-x/.0123456789");
            clip.anchorX = 0.5;
            clip.anchorY = 0.5;
            clip.x = point.x;
            clip.y = point.y + 50
            clip.value = "x" + count;
            //countTxt = new Label();
            // countTxt.color = "#1d50c1";
            //countTxt.anchorX = 0.5;
            //countTxt.anchorY = 0.5;
            //countTxt.fontSize = 24;
            //countTxt.text = count+"";
            //countTxt.x = point.x;
            //countTxt.y = point.y+20;
            _rewardView = rewardview;
            skin = new Image(url);


            // skin.width = 80;
            // skin.height = 80;

            skin.anchorX = 0.5;
            skin.anchorY = 0.5;
            //ani = AnimalManger.instance.load("guang");
            //ani.width = 173;
            //ani.height = 173;
            //ani.pivotX = ani.width/2;
            //ani.pivotY = ani.height/2;
            skin.x = point.x;
            skin.y = point.y;
            //ani.x = point.x;
            //ani.y = point.y;
            //	ani.scaleX
            //ani.scaleY
            //ani.play(0,true);
            //ani.scaleX = 0;
            //ani.scaleY = 0;
            spineRoot = new Sprite();
            spine = new SpineTemplet("linjiang");
            spine.setPivot(spine.spineWidth / 2, spine.spineHeight / 2);
            spineRoot.addChild(spine)
            spineRoot.zOrder = 1;
            //spine.play(0,false,Handler.create(this,playComte));
            spineRoot.pos(point.x, point.y);
            skin.scaleX = 0;
            skin.zOrder = 10;
            clip.zOrder = 10;
            skin.scaleY = 0;
            clip.scaleX = 0;
            clip.scaleY = 0;
        }


        public function test():void
        {
            spine = new SpineTemplet("linjiang");
            spine.play(0, false, Handler.create(this, playComte));
            spine.setPos(500, 500);
            spine.setPivot(spine.spineWidth / 2, spine.spineHeight / 2);


        }


        private function playComte():void
        {
            spine.play(1, true);

        }

        public function start():void
        {
            //_rewardView.addChild(ani);
            _rewardView.addChild(spineRoot);
            _rewardView.addChild(skin);
            _rewardView.addChild(clip);
            spine.play(0, false, Handler.create(this, playComte));
            //Tween.to(ani,{scaleX:1.5,scaleY:1.5},150,null,Handler.create(this,playComplete));
            Tween.to(skin, {scaleX: 1.5, scaleY: 1.5}, 150, null, Handler.create(this, playComplete));
            Tween.to(clip, {scaleX: 1.5, scaleY: 1.5}, 150, null, Handler.create(this, playComplete));
        }

        private function playComplete():void
        {
            //Tween.to(ani,{scaleX:1,scaleY:1},150,null);
            Tween.to(skin, {scaleX: 1, scaleY: 1}, 150, null);
            Tween.to(clip, {scaleX: 1, scaleY: 1}, 150, null);

        }

        public function stop():void
        {
            //Tween.to(ani,{scaleX:0,scaleY:0},150,null,Handler.create(this,stopComplete));
            Tween.to(skin, {scaleX: 0, scaleY: 0}, 150, null, Handler.create(this, stopComplete));
            Tween.to(clip, {scaleX: 0, scaleY: 0}, 150, null, Handler.create(this, stopComplete));
            //_rewardView.removeChild(ani);
            //_rewardView.removeChild(skin);
            //_rewardView.removeChild(clip);
        }

        private function stopComplete():void
        {
            GameEventDispatch.instance.event(GameEvent.CloseRewadTip);
            _rewardView.removeChild(spineRoot);
            _rewardView.removeChild(skin);
            _rewardView.removeChild(clip);
        }

    }
}
