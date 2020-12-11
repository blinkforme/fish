package view.goldTip
{
    import model.MsgM;

    import laya.ui.FontClip;
    import laya.ui.Image;
    import laya.ui.Label;
    import laya.utils.Handler;
    import laya.utils.Tween;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;

    import ui.abbey.goldTipUI;

    public class GoldView extends goldTipUI implements ResVo
    {
        private var fontclip:FontClip;
        private var lableOne:Label;
        private var labelTwo:Label;
        private var labelThree:Label;
        private var labelFour:Label;
        private var labelFive:Label;
        private var label:Label;
        private var labelArr:Array;
        private var imageOne:Image;
        private var imageTwo:Image;
        private var imageThree:Image;
        private var imageFour:Image;
        private var imageFive:Image;
        private var imageArr:Array;
        private var _startX:Number = 0;
        private var _startY:Number = 0;


        public function GoldView()
        {
            super();
        }


        public function StartGames(parm:Object = null):void
        {
            _startX = this.x;
            _startY = this.y;
            labelArr = new Array();
            lableOne = new Label();
            labelTwo = new Label();
            labelThree = new Label();
            labelFour = new Label();
            labelFive = new Label();

            imageOne = new Image("ui/common_ex/ku.png");
            imageTwo = new Image("ui/common_ex/ku.png");
            imageThree = new Image("ui/common_ex/ku.png");
            imageFour = new Image("ui/common_ex/ku.png");
            imageFive = new Image("ui/common_ex/ku.png");
            imageArr = new Array();
            imageOne.visible = false;
            imageTwo.visible = false;
            imageThree.visible = false;
            imageFour.visible = false;
            imageFive.visible = false;
            lableOne.visible = false;
            labelTwo.visible = false;
            labelThree.visible = false;
            labelFour.visible = false;
            labelFive.visible = false;
            imageArr.push(imageOne);
            imageArr.push(imageTwo);
            imageArr.push(imageThree);
            imageArr.push(imageFour);
            imageArr.push(imageFive);
            labelArr.push(lableOne);
            labelArr.push(labelTwo);
            labelArr.push(labelThree);
            labelArr.push(labelFour);
            labelArr.push(labelFive);

            screenResize();
            Laya.timer.loop(50, this, start);
        }

        private function start():void
        {
            if (MsgM.instance.isShow)
            {
                MsgM.instance.isShow = false;
                var label:Label = getLabel();
                label.width = 0;
                label.visible = true;
                label.color = "#ffffff"
                label.text = MsgM.instance.content;
                label.anchorX = 0.5;
                label.anchorY = 0.5;
                label.fontSize = 28;
                label.x = Laya.stage.width / 2
                label.y = Laya.stage.height / 2;
                var image:Image = getImage();
                image.visible = true;
                image.width = label.width + 50;
                image.height = 100;
                image.anchorX = 0.5;
                image.anchorY = 0.5;
                image.x = Laya.stage.width / 2;
                image.y = Laya.stage.height / 2;
                image.sizeGrid = "26,18,24,18"
                this.addChild(image);
                this.addChild(label);
                Tween.to(label, {y: label.y - 150}, MsgM.instance.speed, null, Handler.create(this, playComplete, [label]));
                Tween.to(image, {y: image.y - 150}, MsgM.instance.speed, null, Handler.create(this, imageComplete, [image]));

            }

        }


        private function screenResize():void
        {
            //			var contentWidth:int = 100;//组件范围width
            //			var contentHeight:int = 200;//组件范围height
            //			var contentStartX:int = 500;//组件左边距
            //			var contentStartY:int = 200;//组件上边距
            //			var posXOff:Number = (Laya.stage.width - contentWidth) / 2;
            //			var posYOff:Number = (Laya.stage.height - contentHeight) / 2;
            //			this.pos(_startX + posXOff - contentStartX, _startY + posYOff - contentStartY);
            this.size(Laya.stage.width, Laya.stage.height);
        }


        private function imageComplete(img:Image):void
        {
            img.visible = false;
            this.removeChild(img);
            Tween.clearAll(img);

        }

        private function playComplete(m:Label):void
        {
            m.visible = false;
            this.removeChild(m);
            Tween.clearAll(m);

        }


        private function getLabel():Label
        {
            for (var i:int = 0; i < labelArr.length; i++)
            {
                if (Label(labelArr[i]).visible == false)
                {
                    return labelArr[i];
                    break;
                }
            }
            return new Label();
        }

        private function getImage():Image
        {
            for (var i:int = 0; i < imageArr.length; i++)
            {
                if (Image(imageArr[i]).visible == false)
                {
                    return imageArr[i];
                    break;
                }
            }
            return new Image("ui/common_ex/ku.png");
        }


        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
        }

        public function unRegister():void
        {
            this.x = _startX;
            this.y = _startY;
            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
        }
    }
}
