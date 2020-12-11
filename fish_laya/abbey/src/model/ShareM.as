package model
{
    import conf.cfg_shareLottery;

    import manager.ConfigManager;

    import proto.SharePro;

    public class ShareM
    {
        private static var _instance:ShareM;
        private var _idArr:Array;


        public function ShareM()
        {
            _idArr = new Array();
            var items = ConfigManager.getConfBySheet("cfg_shareLottery");
            for (var i in items)
            {
                _idArr.push(parseInt(i))
            }
        }

        public static function get instance():ShareM
        {
            return _instance || (_instance = new ShareM());
        }

        public function get shareInfo():SharePro
        {
            var sharePro:SharePro = new SharePro();

            return sharePro;
            ;
        }


        public function get shareInfoArr():Array
        {
            var arr:Array = new Array();
            for (var i:int = 0; i < _idArr.length; i++)
            {
                var cfg:cfg_shareLottery = cfg_shareLottery.instance(_idArr[i]);
                arr.push(cfg);
            }
            return arr;
        }

        public function getGoodsId(prizeId:Number):Number
        {
            var cfg:cfg_shareLottery = cfg_shareLottery.instance(prizeId);
            if (ActivityM.instance.isShowShareRebate)
            {
                return cfg.activity_rewardId
            } else
            {
                return cfg.rewardId
            }
        }

        public function count(prizeId:Number):Number
        {
            var cfg:cfg_shareLottery = cfg_shareLottery.instance(prizeId);
            if (ActivityM.instance.isShowShareRebate)
            {
                return cfg.activity_rewardCount
            } else
            {
                return cfg.rewardCount
            }
        }


    }
}
