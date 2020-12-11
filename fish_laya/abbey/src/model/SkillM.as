package model
{
    import conf.cfg_goods;
    import conf.cfg_scene;
    import conf.cfg_skill;

    import laya.display.Animation;

    import proto.ProtoSeatInfo;

    public class SkillM
    {
        private static var _instance:SkillM;
        public var sceneId:int;
        private var _ani:Animation
        private var _pointArr:Array;
        private var _blooenArr:Array;
        private var _clollectArr:Array;

        public function SkillM()
        {

        }

        public static function get instance():SkillM
        {
            return _instance || (_instance = new SkillM());
        }

        public function get skillArr():Array
        {
            var scene:cfg_scene = cfg_scene.instance(FightM.instance.sceneId + "");
            if (scene == null)
            {
                return null
            } else
            {
                return scene.skills
            }
        }

        public function get scaleNum():Number
        {
            var c:int = 0;
            for (var i:int = 0; i < 6; i++)
            {
                if (skillArr[i] > 0)
                {
                    c++
                }
            }
            return c / 6;
        }


        public function skillInfo(id:int):String
        {
            var skill:cfg_skill = cfg_skill.instance(id + "");
            var icon:String = skill.icon;
            var num:Number = RoleInfoM.instance.getGoodsItemNum(skill.need_prop);
            var object:Object = {img: icon, skillNum: num};
            return null;
        }

        //技能图标的素材
        public function skillUrl(id:int):String
        {
            if (!skillArr || skillArr[id] == -1)
            {
                return null
            } else
            {
                return "0"
            }

        }


        public function isConsumeEnough(skillIndex:int):Boolean
        {
            if (skillCount(skillIndex) <= 0)
            {
                var needDiamond:int = diamondCount(skillIndex);
                return RoleInfoM.instance.getDiamond() >= needDiamond;
            }
            return true;
        }

        public function skillCount(id:int, isFishPage:Boolean = true):int
        {
            var skillArray:Array = []
            if (isFishPage)
            {
                skillArray = skillArr
            } else
            {
                var scene:cfg_scene = cfg_scene.instance(1 + "");
                skillArray = scene.skills
            }
            if (id < skillArray.length)
            {

                var skill:cfg_skill = cfg_skill.instance(skillArray[id]);
                var seatInfo:ProtoSeatInfo;
                var seatId:int;
                var unreachNum:int = 0;
                seatId = FightM.instance.getSeatIdByShowSeatId(1);
                seatInfo = FightM.instance.getSeatInfo(seatId);
                if (seatInfo)
                {
                    unreachNum = FightM.instance.getGoodsUnreachNum(seatInfo.agent, skill.need_prop);
                }

                return RoleInfoM.instance.getGoodsItemNum(skill.need_prop) - unreachNum;
            } else
            {
                return 0;
            }
        }

        public function skillDiamondCount(skillId:int):int
        {
            var skill:cfg_skill = cfg_skill.instance(String(skillId));
            var goods:cfg_goods = cfg_goods.instance(skill.need_prop + "");
            var arr:Array = goods.replace_res;
            return arr[1];
        }

        public function diamondCount(id:int):int
        {
            if (id < skillArr.length)
            {
                var skill:cfg_skill = cfg_skill.instance(skillArr[id]);
                var goods:cfg_goods = cfg_goods.instance(skill.need_prop + "");
                var arr:Array = goods.replace_res;
                return arr[1];
            } else
            {
                return 0;
            }
        }


        public function skillTime(id:int):Number
        {
            if (skillArr != null)
            {
                if (skillArr[id] != -1)
                {
                    var skill:cfg_skill = cfg_skill.instance(skillArr[id]);
                    var time:Number = skill.cd
                    return time * 1000;
                } else
                {
                    return 0;
                }
            } else
            {
                return 0;
            }
        }
    }
}
