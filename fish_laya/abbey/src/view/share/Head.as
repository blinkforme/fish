package view.share
{
    import control.WxC;

    import laya.display.Sprite;
    import laya.events.Event;
    import laya.ui.Box;
    import laya.ui.Image;
    import laya.ui.Label;

    public class Head
    {
        private var _headDiImg:Image;
        private var _headImg:Image;
        private var _yaoImg:Image;
        private var _diTxt:Label;
        private var _imgUrl:String;
        private var _box:Box;

        public function Head(box:Box)
        {
            _box = box;
            _headDiImg = box.getChildByName("di") as Image;
            _headImg = box.getChildByName("head") as Image;
            _yaoImg = box.getChildByName("yao") as Image;
            _diTxt = box.getChildByName("lottery") as Label;
            _headDiImg.visible = false;
            _headImg.visible = false;
            _yaoImg.visible = true;
            _diTxt.text = "点击邀请"
            _yaoImg.on(Event.CLICK, this, clickShare);
        }

        private function clickShare():void
        {
            WxC.wx_share();
        }

        public function setHeadInfo(obj:Object):void
        {
            if (obj == null)
            {
                Caninvited();
            } else
            {
                noinvited();
                var url:String = obj["avatar"]
                drawMask(20, _headImg, url);
            }
        }

        //可以邀请
        private function Caninvited():void
        {
            _diTxt.text = "点击邀请"
            _headDiImg.visible = false;
            _headImg.visible = false;
            _yaoImg.visible = true;
        }

        //不可以邀请
        private function noinvited():void
        {
            _diTxt.text = "可以抽奖"
            _headDiImg.visible = true;
            _headImg.visible = true;
            _yaoImg.visible = false;
        }

        public function haveLottery():void
        {
            _box.gray = true;
            _diTxt.text = "已经抽奖"
            _headDiImg.visible = true;
            _headImg.visible = true;
            _yaoImg.visible = false;

        }


        private function drawMask(r:Number, img:Image, url:String):void
        {
			if(url.length > 0)
			{
            	img.skin = url;
			}
			else
			{
				img.skin = "ui/common/nan.png";
			}
        }


    }
}
