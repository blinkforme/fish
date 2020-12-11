package model
{
    import conf.cfg_goods;
    import conf.cfg_register;

    import manager.ConfigManager;
    import manager.GameConst;

    public class RegiM
    {
        private static var _instance:RegiM;
        private var state:String;
        private var registerDiSkin:String = "ui/register/touxiang1.png";
        private var unregisterDiSkin:String = "ui/register/touxiang.png";
        private var registerHfSkin:String = "ui/register/QDJL_board2.png";
        private var unregisterHfSkin:String = "ui/register/XSFL_board.png";
        private var _isRegic:Boolean = false;
        private var _isToday:Boolean = false;


        public function RegiM()
        {

        }

        public function get isToday():Boolean
        {
            return _isToday;
        }

        public function set isToday(today:Boolean):void
        {
            _isToday = today;
        }

        public function get isRegic():Boolean
        {
            return _isRegic;
        }

        public function set isRegic(regic:Boolean):void
        {
            _isRegic = regic;
        }

        public static function get instance():RegiM
        {
            return _instance || (_instance = new RegiM());
        }


        public function setInfo():void
        {

        }

        public function get idArr():Array
        {
            var arr:Array = new Array();
            var items = ConfigManager.getConfBySheet("cfg_register");
            for (var i in items)
            {
                if (!items[parseInt(i)].rewardID)
                {
                    break;
                }
                arr.push(parseInt(i))
            }
            return arr
        }

        public function get infoList():Array
        {
            var infoArr:Array = [];
            for (var i:int = 0; i < idArr.length; i++)
            {
                var reward:cfg_register = cfg_register.instance(idArr[i]);
                if (RoleInfoM.instance.getSignInStatus(idArr[i]) == GameConst.sign_in_getted)
                {
                    // infoArr.push({txt:{text:reward.weekName},image:{skin:imageUrl(reward.rewardID)},count:{value:reward.rewardCount}});
                    infoArr.push({
                        txt: {text: reward.weekName},
                        image: {skin: imageUrl(reward.rewardID, idArr[i])},
                        count: {text: rewardCount(reward.rewardID, idArr[i])},
                        maskBtn: {visible: true},
                        rightBtn: {visible: true},
                        diImg: {skin: unregisterDiSkin},
                        halfBtn: {skin: unregisterHfSkin},
                        vipdi: {visible: false},
                        vipbei: {visible: false},
                        twobei: {visible: false}
                    });
                } else if (RoleInfoM.instance.getSignInStatus(idArr[i]) == GameConst.sign_in_getting)
                {
                    infoArr.push({
                        txt: {text: reward.weekName},
                        image: {skin: imageUrl(reward.rewardID, idArr[i])},
                        count: {text: rewardCount(reward.rewardID, idArr[i])},
                        maskBtn: {visible: false},
                        rightBtn: {visible: false},
                        diImg: {skin: registerDiSkin},
                        halfBtn: {skin: registerHfSkin},
                        vipdi: {visible: isShowVip(reward)},
                        vipbei: {visible: isShowVip(reward), text: getVipTime(reward)},
                        twobei: {visible: isShowVip(reward)}
                    });
                } else if (RoleInfoM.instance.getSignInStatus(idArr[i]) == GameConst.sign_in_not_reach)
                {
                    infoArr.push({
                        txt: {text: reward.weekName},
                        image: {skin: imageUrl(reward.rewardID, idArr[i])},
                        count: {text: rewardCount(reward.rewardID, idArr[i])},
                        maskBtn: {visible: false},
                        rightBtn: {visible: false},
                        diImg: {skin: unregisterDiSkin},
                        halfBtn: {skin: unregisterHfSkin},
                        vipdi: {visible: isShowVip(reward)},
                        vipbei: {visible: isShowVip(reward), text: getVipTime(reward)},
                        twobei: {visible: isShowVip(reward)}
                    });
                }

            }
            return infoArr;
        }

        public function get isGet():Boolean
        {
            var isget:Boolean = false;
            for (var i:int = 0; i < idArr.length; i++)
            {
                var reward:cfg_register = cfg_register.instance(idArr[i]);
                if (RoleInfoM.instance.getSignInStatus(idArr[i]) == GameConst.sign_in_getting)
                {
                    isget = true;
                    break;
                }
            }
            return isget;
        }


        public function skinInd(rewardId:int):int
        {
            var goods:cfg_goods = cfg_goods.instance(rewardId + "");
            return goods.typeID
        }

        public function isShowVip(reward:cfg_register):Boolean
        {
            if (reward.db_vip == 0)
            {
                return false;
            } else
            {
                return true;
            }
        }


        public function getVipTime(reward:cfg_register):String
        {
            return "v" + reward.db_vip;
        }

        //得到图片地址
        public function imageUrl(goodsId:int, id:int):String
        {
            var goods:cfg_goods = cfg_goods.instance(goodsId + "");
            if (goods.type == 7)
            {
                if (RoleInfoM.instance.isSkinExit(goods.typeID))
                {
                    var m:cfg_register = cfg_register.instance(id + "");
                    var mId:int = m.replace_reward_id;
                    var n:cfg_goods = cfg_goods.instance(mId + "");
                    return n.icon
                }
            }
            return goods.icon;
        }

        //得到图片数量
        public function rewardCount(goodsId:int, id:int):Number
        {
            var goods:cfg_goods = cfg_goods.instance(goodsId + "");
            var m:cfg_register = cfg_register.instance(id + "");
            var num:Number = m.rewardCount;
            if (goods.type == 7)
            {
                if (RoleInfoM.instance.isSkinExit(goods.typeID))
                {

                    num = m.replace_reward_count;
                }
            }
            return ActivityM.instance.exchangeConversion(goodsId, num);
        }
    }
}
