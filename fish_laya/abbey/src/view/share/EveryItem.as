package view.share
{
    import model.ActivityM;
    import model.OnLineM;

    import conf.cfg_shareLottery;

    import laya.ui.Box;
    import laya.ui.Image;
    import laya.ui.Label;

    public class EveryItem
    {
        private var _img:Image;
        private var _countTxt:Label;
        private var _box:Box;
        private var _imgUrl:String;
        private var _count:Number;

        public function EveryItem(box:Box)
        {
            _box = box;
            _img = box.getChildByName("icon") as Image;
            _countTxt = box.getChildByName("count") as Label;
        }


        public function setItemInfo(obj:cfg_shareLottery, type:Number):void
        {
            if (type == 1)
            {
                _imgUrl = OnLineM.instance.imageUrl(obj.rewardId_Junior);
                _count = obj.rewardCount_Junior;
                _img.skin = _imgUrl;
                _countTxt.text =ActivityM.instance.exchangeConversion(obj.rewardId_Junior, _count) + "";
            } else if (type == 2)
            {
                _imgUrl = OnLineM.instance.imageUrl(obj.rewardId_Medium);
                _count = obj.rewardCount_Medium;
                _img.skin = _imgUrl;
                _countTxt.text = ActivityM.instance.exchangeConversion(obj.rewardId_Medium, _count) + "";
            }
        }
    }
}
