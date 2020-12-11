package model
{
    import conf.cfg_hId;
    import conf.cfg_hourse;

    import manager.GameConst;

    import model.LoginInfoM;

    import proto.S2c_21000;

    public class HorseM
    {
        private static var _instance:HorseM;
        private var isI:Boolean = false;
        private var _isOpenNotice:Boolean = false;
        private var _noticeTime:Number = 30;//分钟
        private var _oneTimesNotice:Boolean = true;
        private var _oneTimes:Number = 1//分钟
        private var _horseTipArray:Array = [{id: 1, a6: 300, agent: true}, {id: 3, a6: 700, agent: true}, {
            id: 6,
            a6: 100,
            agent: true
        }, {id: 4, a6: 800, agent: false}, {id: 5, a6: 500, agent: true}, {id: 3, a6: 134, agent: false}];
        private var _resetArr:Array;
        private var _repeatNum:Number;


        public function HorseM()
        {
            _horseTipArray = [];
        }

        public static function get instance():HorseM
        {
            return _instance || (_instance = new HorseM());
        }

        public function addHorseTipItem(data:*):void
        {
            _horseTipArray.push(data);


        }

        public function get noticeTime():Number
        {
            var time:Number = _noticeTime * 60 * 1000;
            return time;
        }

        public function get isOpenNotice():Boolean
        {
            return _isOpenNotice;
        }

        public function set isOpenNotice(boo:Boolean):void
        {
            _isOpenNotice = boo;
        }

        public function setInfo():void
        {
            isI = true;
        }

        public function get isIn():Boolean
        {
            return isI;
        }

        public function set isIn(_isI:Boolean):void
        {
            isI = _isI;
        }

        public function getHorseTipNum():int
        {
            return _horseTipArray.length;
        }

        public function get repeatNum():Number
        {
            return _repeatNum;
        }

        public function set repeatNum(num:Number):void
        {
            _repeatNum = num;
        }

        public function getRepeatNum():int
        {
            if (_horseTipArray.length > 50)
            {
                return 1;
            }
            return 3;
        }

        public function getHtml():String
        {
            resetArr;
            var html:String = "";
            if (_horseTipArray.length > 0)
            {
                var tipData:S2c_21000 = _horseTipArray[0];
                if (tipData.id != 5)
                {
                    var agent:Number = Number(tipData.agent);
                    if (FightM.instance.getSeatInfoByAgent(agent) != null)
                    {
                        repeatNum = 3;
                    } else
                    {
                        repeatNum = 1;
                    }
                    if (agent < 0)
                    {
                        repeatNum = 1;
                    }
                } else
                {
                    repeatNum = 3;
                }
                _horseTipArray.splice(0, 1);
                var id:int = tipData.id;
                var cfg:cfg_hourse = cfg_hourse.instance(id + "");
                var conent:String;
                var isName:Boolean = false;
                for (var i:int = 1; i <= 7; i++)
                {
                    var idTmp:int = cfg["txt" + i] as int;
                    if (i == 1 && idTmp == 1)
                    {
                        isName = true;
                    }
                    if (idTmp > 0)
                    {

                        conent = getContent(idTmp);

                        if (1 == getType(idTmp))
                        {
                            if (isName && i == 2)
                            {
                                conent = LoginInfoM.instance.filterName(String(tipData["a" + i]));
                            } else
                            {
                                conent = String(tipData["a" + i]);
                            }
                            conent = conent.replace(/[&<>]/g, "");
                            if (ENV.channelType == GameConst.public_no_id_ljby)
                            {
                                conent = conent.replace("集结号", "联机捕鱼");
                            }
                        }
                        html += "<span color=" + "'" + getColor(idTmp) + "'" + ">" + conent + "</span>";
                    }
                }
            }
            return html;
        }

        public function set resetArr(arr:Array):void
        {
            _resetArr = arr;
        }


        //将跑马灯按照规则排序
        public function get resetArr():Array
        {
            _resetArr = new Array();
            for (var i:int = 0; i < _horseTipArray.length; i++)
            {
                if (isSystemHorse(i))
                {
                    var obj:Object = _horseTipArray[i]
                    _horseTipArray.splice(i, 1);
                    _resetArr.push(obj);
                }
            }
            _horseTipArray.sort(function (a:S2c_21000, b:S2c_21000)
            {
                var coinCountA:Number = Number(a.a6);
                var coinCountB:Number = Number(b.a6);
                var agentA:Number = Number(a.agent);
                var agnetB:Number = Number(b.agent);
                if (FightM.instance.getSeatInfoByAgent(agentA) != null || FightM.instance.getSeatInfoByAgent(agnetB) != null)
                {
                    return 1;
                } else
                {
                    if (coinCountA > coinCountB)
                    {
                        return 1;
                    }
                }
            });
            if (_resetArr.length > 0)
            {
                for (var k:int = 0; k < _resetArr.length; k++)
                {
                    _horseTipArray.unshift(_resetArr[k]);
                }
            }
            return _horseTipArray;
        }


        //获取打到boss金币个数
        public function getCoinCount(i:Number):void
        {
            var tipData:S2c_21000 = _horseTipArray[i];
        }

        //判断是否是系统公告
        public function isSystemHorse(i:Number):Boolean
        {
            var tipData:S2c_21000 = _horseTipArray[i];
            var id:int = tipData.id;
            if (id == 5)
            {
                return true
            } else
            {
                return false
            }
        }

        //是否是自己
        public function isOwn(i:Number):Boolean
        {
            var tipData:S2c_21000 = _horseTipArray[i];
            if (tipData.agent == true)
            {
                return false;
            } else
            {
                _resetArr.push(tipData);
                _horseTipArray.splice(i, 1);
                return true;
            }
        }


        public function getContent(id:int):String
        {
            var cf:cfg_hId = cfg_hId.instance(id + "");
            var content:String = cf.txtContent;
            return content;
        }

        public function getType(id:int):int
        {
            var cf:cfg_hId = cfg_hId.instance(id + "");
            return cf.txtType;
        }

        public function getColor(id:int):String
        {
            var cf:cfg_hId = cfg_hId.instance(id + "");
            var color:String = cf.txtColor;
            return color;
        }

        private function getdata():void
        {
            //			var cfg:cfg_hourse = cfg_hourse.instance(0+"");
            //			colorOne =
        }

        public function set oneTimesNotice(value:Boolean):void
        {
            _oneTimesNotice = value;
        }

        public function get oneTimesNotice():Boolean
        {
            return _oneTimesNotice;
        }

        public function get oneTimes():Number
        {
            var time:Number = _oneTimes * 60 * 1000;
            return time;
        }
    }
}
