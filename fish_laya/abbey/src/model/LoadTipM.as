package model
{
    import control.WxC;

    import conf.cfg_loadtip;
    import conf.cfg_loadtip_weixin;

    import manager.ConfigManager;

    public class LoadTipM
    {
        private static var _instance:LoadTipM;
        private var _idArr:Array;
        private var _contentArr:Array;
        private var _getInRoomFailCount:Number = 0;
        //进入房间失败的次数
        public function LoadTipM()
        {

        }

        public static function get instance():LoadTipM
        {
            return _instance || (_instance = new LoadTipM());
        }


        public function get idArr():Array
        {
            if (!_idArr)
            {
                _idArr = new Array();
                var items;
                var i:int;
                if (WxC.isInMiniGame())
                {
                    items = ConfigManager.getConfBySheet("cfg_loadtip_weixin");
                    for (i in items)
                    {
                        _idArr.push(i)
                    }
                }
                else
                {
                    items = ConfigManager.getConfBySheet("cfg_loadtip");
                    for (i in items)
                    {
                        _idArr.push(i)
                    }
                }
            }
            return _idArr
        }

        public function get getInRoomFailCount():Number
        {
            return _getInRoomFailCount;
        }

        public function set getInRoomFailCount(count:Number):void
        {
            _getInRoomFailCount = count;
        }

        public function get contentArr():Array
        {
            if (!_contentArr)
            {
                _contentArr = new Array();
                for (var j:int = 0; j < idArr.length; j++)
                {
                    var cfg:*;
                    if (WxC.isInMiniGame())
                    {
                        cfg = cfg_loadtip_weixin.instance(idArr[j] + "");
                        _contentArr.push(cfg.txtContent);
                    }
                    else
                    {
                        cfg = cfg_loadtip.instance(idArr[j] + "");
                        _contentArr.push(cfg.txtContent);
                    }

                }
            }
            return _contentArr;
        }

        public function get showContent():String
        {
            var id:Number = getIndex(idArr.length);
            var content:String = contentArr[id];
            return content;
        }

        public function getIndex(len:Number):Number
        {
            var index:Number = Math.floor(Math.random() * len);
            return index;
        }
    }
}
