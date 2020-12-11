package control
{
    import manager.SpineTemplet;

    import model.ActivityM;

    import laya.display.Sprite;
    import laya.events.Event;
    import laya.ui.Image;

    public class RedpointC
    {
        private static var _instance:RedpointC;
        private static var red_point_name = "name_of_red_point_uid";
        private static var activity_point_name = "name_of_activity_point_uid";
        private static var spine_rank_point_name = "tishi";

        public function RedpointC()
        {

        }

        public function addSpinePointToIcon(target:Sprite, x:Number, y:Number, click_once = false):void
        {
            var spineRoot:Sprite = new Sprite();
            var spine:SpineTemplet = new SpineTemplet(spine_rank_point_name);
            spineRoot.name = spine_rank_point_name;
            spineRoot.zOrder = 1;
            spineRoot.x = target.width * x;
            spineRoot.y = y;
            spineRoot.addChild(spine);
            removeSpinePoint(target)
            target.addChild(spineRoot);
            if (!spine.isPlaying())
            {
                spine.play("animation", true)
            }
            if (click_once)
            {
                target.once(Event.CLICK, target, removeRedPoint, [target])
            }
        }

        public function removeSpinePoint(target:Sprite):void
        {
            target.removeChildByName(spine_rank_point_name);
        }

        public function addRedPointToIcon(target:Sprite, x:Number, y:Number, skin:String = "", depth:Number = 1, click_once = false):void
        {
            var img:Image = new Image();
            img.name = red_point_name;
            if (skin.length > 0)
            {
                img.skin = skin;
            } else
            {
                img.skin = "ui/common_ex/red_point.png";
            }
            img.zOrder = depth;
            img.x = target.width * x;
            img.y = y;

            removeRedPoint(target)
            target.addChild(img);


            if (click_once)
            {
                target.once(Event.CLICK, target, removeRedPoint, [target])
            }
        }

        public function removeRedPoint(target:Sprite):void
        {
            target.removeChildByName(red_point_name);
        }

        public function addActivityPointToIcon(target:Sprite, x:Number, y:Number, click_once = false):void
        {
            if (ActivityM.instance.activityPictureConfig[4])
            {
                var img:Image = new Image();
                img.name = activity_point_name;
                img.skin = ActivityM.instance.activityPictureConfig[4];
                img.zOrder = 0;
                img.x = target.width * x;
                img.y = y;

                removeActivityPoint(target)
                target.addChild(img);


                if (click_once)
                {
                    target.once(Event.CLICK, target, removeRedPoint, [target])
                }
            }
        }

        public function removeActivityPoint(target:Sprite):void
        {
            if (!ActivityM.instance.activityTicketContinueTime || ActivityM.instance.activityPictureConfig[4])
            {
                target.removeChildByName(activity_point_name);
            }
        }

        public function addDoubleRewardPointToIcon(target:Sprite, x:Number, y:Number, click_once = false):void
        {
            var img:Image = new Image();
            img.name = activity_point_name;
            img.skin = "ui/common_ex/img_fanbei.png";
            img.zOrder = 2;
            img.x = target.width * x;
            img.y = y;

            removeDoubleRewardPoint(target)
            target.addChild(img);

            if (click_once)
            {
                target.once(Event.CLICK, target, removeRedPoint, [target])
            }
        }

        public function removeDoubleRewardPoint(target:Sprite):void
        {
            if (target.getChildByName(activity_point_name))
            {
                target.removeChildByName(activity_point_name);
            }
        }


        public static function get instance():RedpointC
        {
            return _instance || (_instance = new RedpointC());
        }
    }
}
