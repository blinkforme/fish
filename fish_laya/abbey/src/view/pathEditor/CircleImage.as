package view.pathEditor
{
    import laya.display.Sprite;
    import laya.events.Event;
    import laya.maths.Point;
    import laya.ui.Image;

    public class CircleImage
    {
        private var _image:Image;
        private var _isMovie:Boolean = false;

        public function CircleImage(sp:Sprite, url:String, point:Point)
        {
            _image = new Image(url);
            _image.width = 10;
            _image.height = 10;
            _image.x = point.x - 5;
            _image.y = point.y - 5;
            sp.addChild(_image);
            initEvent();

        }

        private function initEvent():void
        {
            _image.on(Event.MOUSE_DOWN, this, downImage);
            _image.on(Event.MOUSE_UP, this, upImage);
        }

        private function upImage(event:Event):void
        {
            _isMovie = false;
            event.stopPropagation();


        }

        private function movieImage(event:Event):void
        {
            event.stopPropagation();
            if (_isMovie)
            {
                _image.x = event.stageX - 5;
                _image.y = event.stageY - 5;
            }

        }

        private function downImage(event:Event):void
        {
            _isMovie = true;
            _image.on(Event.MOUSE_MOVE, this, movieImage);
            event.stopPropagation();

        }

        public function get mX():Number
        {
            return _image.x;
        }

        public function get mY():Number
        {
            return _image.y;
        }


    }
}
