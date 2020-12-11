package view.item
{
    import ui.item.FesDailyGiftItemUI;

    public class FesDailyGiftItem extends FesDailyGiftItemUI
    {

        public function FesDailyGiftItem()
        {

        }

        public function init(itemImg:String, itemName:String):void
        {
            this.itemImg.skin = itemImg
            this.itemName.text = itemName;
        }

    }
}
