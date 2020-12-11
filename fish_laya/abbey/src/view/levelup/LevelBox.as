package view.levelup
{
    import laya.maths.Point;
    import laya.ui.FontClip;
    import laya.ui.Image;
    import laya.ui.View;

    public class LevelBox
    {
        private var skin:Image;
        private var _rewardView:View;
        private var _url:String;
        private var beiImg:Image;
        private var _count:int;
        private var _countClip:FontClip;

        public function LevelBox(url:String, point:Point, rewardview:View, count:int)
        {
            _count = count;
            beiImg = new Image("ui/common_ex/bei.png");
            beiImg.anchorX = 0.5;
            beiImg.anchorY = 0.5;
            beiImg.width = 120;
            beiImg.height = 120;
            beiImg.sizeGrid = "26,24,36,24,1"
            beiImg.x = point.x;
            beiImg.y = point.y + 5;
            _rewardView = rewardview;
            skin = new Image(url);
            skin.anchorX = 0.5;
            skin.anchorY = 0.5;
            skin.scaleX = 0.9;
            skin.scaleY = 0.9;
            skin.x = point.x;
            skin.y = point.y;
            _countClip = new FontClip("ui/common_ex/nums.png", "0123456789");
            _countClip.value = _count + "";
            _countClip.anchorX = 0.5;
            _countClip.anchorY = 0.5;
            _countClip.x = point.x;
            _countClip.y = point.y + 40;
        }

        public function start():void
        {
            _rewardView.addChild(beiImg);
            _rewardView.addChild(skin);
            _rewardView.addChild(_countClip);
        }

        public function stop():void
        {
            _rewardView.removeChild(beiImg);
            _rewardView.removeChild(skin);
            _rewardView.removeChild(_countClip);
        }
    }
}
