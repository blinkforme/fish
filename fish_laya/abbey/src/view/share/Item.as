package view.share
{
    import model.ActivityM;
    import model.OnLineM;

    import conf.cfg_shareLottery;

    import laya.ui.Box;
    import laya.ui.Image;
    import laya.ui.Label;

    public class Item
    {
        private var _img:Image;
        private var _countTxt:Label;
        private var _imgUrl:String;
        private var _count:Number;
        private var _box:Box;
        public var id:Number = -1;

        public function Item(box:Box)
        {
            _box = box;
            _img = box.getChildByName("icon") as Image;
            _countTxt = box.getChildByName("count") as Label;
        }


        public function setItemInfo(obj:cfg_shareLottery):void
        {
            id = obj.id;
            if (ActivityM.instance.isShowShareRebate)
            {
                _count =ActivityM.instance.exchangeConversion(obj.activity_rewardId,  obj.activity_rewardCount);
                _imgUrl = OnLineM.instance.imageUrl(obj.activity_rewardId);
            } else
            {
                _count =ActivityM.instance.exchangeConversion(obj.rewardId, obj.rewardCount);
                _imgUrl = OnLineM.instance.imageUrl(obj.rewardId);
            }
            _countTxt.text = _count + "";
            _img.skin = _imgUrl;
        }


        public function isDray():void
        {
            _box.gray = true;
        }
    }
}
