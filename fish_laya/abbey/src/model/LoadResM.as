package model
{
    import control.WxC;

    import laya.net.Loader;

    import manager.ConfigManager;

    public class LoadResM{
			
		private static var _instance:LoadResM;
        private var _firstArr:Array;
        private var _configSecondLoad:Boolean;
    	private var _firstSpineArr:Array;
		private var _secondSpineArr:Array;
        private var _firstSceneArr:Array;//第一个场景
        private var _secondSceneArr:Array; //第二个场景
        private var _threeSceneArr:Array; //第三个场景
        private var _fourSceneArr:Array;//第四个场景
        private var _fiveSceneArr:Array; //第五个场景
        private var _sixSceneArr:Array; //第六个场景
        private var _sevenSceneArr:Array; //第七个场景
        private var _eightSceneArr:Array; //第八个场景

    	private var _breakFirstScnen:Array;
    	private var _breakSecondScene:Array;
    	private var _breakThreeScene:Array;
    	private var _breakFourScene:Array;


		private var _firstSceneSpineArr:Array;
        private var _secondSceneSpineArr:Array;
        private var _threeSceneSpineArr:Array;
        private var _fourSceneSpineArr:Array;
        private var _fiveSceneSpineArr:Array;
        private var _sixSceneSpineArr:Array;
        private var _sevenSceneSpineArr:Array;
        private var _eightSceneSpineArr:Array;		
		
        private var _backgroundResArr:Array;

        public function LoadResM()
        {
        }

		public static function get instance():LoadResM
		{
			return _instance || (_instance = new LoadResM());
		}

       //进入场景的所需的骨骼动画
        public function get firstSpineArr():Array
        {
            if (_firstSceneSpineArr)
            {
                return _firstSceneSpineArr;
            }
            _firstSpineArr = new Array();
            _firstSpineArr.push("spine/jixieyuwang/H5_jixieyuwang.sk");
            _firstSpineArr.push("spine/wannianjue/H5_wannianjue.sk");
            _firstSpineArr.push("spine/tieqianxiewang/H5_tieqianxiewang.sk");
            _firstSpineArr.push("spine/shenhaijujing/H5_shenhaijujing.sk");
            _firstSpineArr.push("spine/guang/25xuanzhuanguangxiao.sk");
            return _firstSpineArr;
        }
			
        public function get secondSpineArr():Array
        {
            if (_secondSpineArr)
            {
                return _secondSpineArr;
            }
            _secondSpineArr = new Array();

            _secondSpineArr.push("spine/pao/H5_pao.sk");

            _secondSpineArr.push("spine/chuantoupao1/chuantoupao_01.sk");
            _secondSpineArr.push("spine/chujipao1/chujipao_01.sk");
            _secondSpineArr.push("spine/sandanpao1/sandanpao_01.sk");
            _secondSpineArr.push("spine/sushepao1/sushepao_01.sk");
            _secondSpineArr.push("spine/chuantoupao2/chuantoupao_02.sk");
            _secondSpineArr.push("spine/chujipao2/chujipao_02.sk");
            _secondSpineArr.push("spine/sandanpao2/sandanpao_02.sk");
            _secondSpineArr.push("spine/sushepao2/sushepao_02.sk");
            // _secondSpineArr.push("spine/zhuanpan/H5_zhuanpan.sk");
            // _secondSpineArr.push("spine/suoding/H5_suoding.sk");
            // _secondSpineArr.push("spine/ankangyu/ankangyu.sk");
            // _secondSpineArr.push("spine/qiyu/qiyu.sk");
            // _secondSpineArr.push("spine/eyu/eyu.sk");
            // _secondSpineArr.push("spine/pangxie/pangxie.sk");
            // _secondSpineArr.push("spine/qiyu/qiyu.sk");
            // _secondSpineArr.push("spine/baozha2/H5_baozha.sk");
            // _secondSpineArr.push("spine/ankangyu/ankangyu.sk");
            // _secondSpineArr.push("spine/dujiaojing/dujiaojing.sk");
            // _secondSpineArr.push("spine/bossbaozha/H5_bossbaozha.sk");
            _secondSpineArr.push("spine/shushepaoEffect/H5_shushepao.sk");
            // _secondSpineArr.push("spine/facaile/facaile.sk");
            // _secondSpineArr.push("spine/baozha/H5_baozha.sk");
            _secondSpineArr.push("spine/chuantoupaoEffect/H5_chuantoupao.sk");
            // _secondSpineArr.push("spine/shengji/ShengJi.sk");
            // //_secondSpineArr.push("spine/zhaohuan/H5_zhaohuan.sk");
            // _secondSpineArr.push("spine/shayu/shayu.sk");
            // _secondSpineArr.push("spine/haitun/haitun.sk");
            // _secondSpineArr.push("spine/qiandai/H5_qiandai.sk");
            _secondSpineArr.push("spine/shanshepaoEffect/H5_shanshepao.sk");
            // _secondSpineArr.push("spine/haigui/haigui.sk");
            // _secondSpineArr.push("spine/heidong/H5_heidong.sk");
            _secondSpineArr.push("spine/chujipao1/chujipao_01.sk");
            _secondSpineArr.push("spine/shijiebei/shijiebei.sk");
            _secondSpineArr.push("spine/shijiebeiEffect/H5_shijiebei.sk");
            return _secondSpineArr;
        }

        public function get configSecondLoad():Boolean {
            return _configSecondLoad;
        }
        public function set configSecondLoad(val:Boolean):void
        {
            _configSecondLoad = val;
        }

        public function get firstArr():Array
        {
            if (_firstArr)
            {
                return _firstArr;
            }
            _firstArr = new Array();
            _firstArr.push({url: "res/atlas/ui/common.atlas", type: Loader.ATLAS});
            _firstArr.push({url: "res/atlas/ui/common_ex.atlas", type: Loader.ATLAS});
            _firstArr.push({url: "res/atlas/ui/mainPage.atlas", type: Loader.ATLAS});
            // _firstArr.push({url: "res/atlas/ui/matchSettle.atlas", type: Loader.ATLAS});
            _firstArr.push({url: "ui/mainPage/bg.png", type: Loader.IMAGE});
            // _firstArr.push({url: "res/atlas/ui/prize.atlas", type: Loader.ATLAS});
            // _firstArr.push({url: "spine/jixieyuwang/H5_jixieyuwang.sk", type: Loader.BUFFER});
            // _firstArr.push({url: "spine/jixieyuwang/H5_jixieyuwang.png", type: Loader.IMAGE});
            // _firstArr.push({url: "spine/shenhaijujing/H5_shenhaijujing.sk", type: Loader.BUFFER});
            // _firstArr.push({url: "spine/shenhaijujing/H5_shenhaijujing.png", type: Loader.IMAGE});
            // _firstArr.push({url: "spine/tieqianxiewang/H5_tieqianxiewang.sk", type: Loader.BUFFER});
            // _firstArr.push({url: "spine/tieqianxiewang/H5_tieqianxiewang.png", type: Loader.IMAGE});
            // _firstArr.push({url: "scene/scene_1_1_1.png", type: Loader.IMAGE});
            // _firstArr.push({url: "scene/scene_1_1_2.png", type: Loader.IMAGE});
            // _firstArr.push({url: "scene/scene_1_2.png", type: Loader.IMAGE});
            // _firstArr.push({url: "scene/scene_1_3.png", type: Loader.IMAGE});
            // _firstArr.push({url: "spine/wannianjue/H5_wannianjue.sk", type: Loader.BUFFER});
            // _firstArr.push({url: "spine/wannianjue/H5_wannianjue.png", type: Loader.IMAGE});
            // _firstArr.push({url: "spine/guang/25xuanzhuanguangxiao.sk", type: Loader.BUFFER});
            // _firstArr.push({url: "spine/guang/25xuanzhuanguangxiao.png", type: Loader.IMAGE});
            // _firstArr.push({url: "spine/tishi/H5_tishi.sk", type: Loader.BUFFER});
            // _firstArr.push({url: "spine/tishi/H5_tishi.png", type: Loader.IMAGE});
            // _firstArr.push({url: "abbey/H5_loading1.part", type: Loader.JSON});
            // //_firstArr.push({url: "abbey/guang.part", type: Loader.JSON});
            // _firstArr.push({url: "res/atlas/font.atlas", type: Loader.ATLAS});

            //            预加载界面
            // _firstArr.push({url: "res/atlas/ui/load.atlas", type: Loader.ATLAS});
            // _firstArr.push({url: "res/atlas/ui/firstCharge.atlas", type: Loader.ATLAS});
            // _firstArr.push({url: "res/atlas/ui/fishType.atlas", type: Loader.ATLAS});
            // _firstArr.push({url: "res/atlas/ui/rewardPage.atlas", type: Loader.ATLAS});
            // _firstArr.push({url: "res/atlas/ui/setting.atlas", type: Loader.ATLAS});
            // _firstArr.push({url: "res/atlas/ui/monthCard.atlas", type: Loader.ATLAS});
            // _firstArr.push({url: "res/atlas/ui/rank.atlas", type: Loader.ATLAS});
            // _firstArr.push({url: "res/atlas/ui/bank.atlas", type: Loader.ATLAS});
            // _firstArr.push({url: "res/atlas/ui/share.atlas", type: Loader.ATLAS});
            // _firstArr.push({url: "res/atlas/ui/shop.atlas", type: Loader.ATLAS});
            // _firstArr.push({url: "res/atlas/ui/register.atlas", type: Loader.ATLAS});
            // _firstArr.push({url: "res/atlas/ui/rewardTip.atlas", type: Loader.ATLAS});
            // _firstArr.push({url: "res/atlas/ui/taskDaily.atlas", type: Loader.ATLAS});
            // _firstArr.push({url: "res/atlas/ui/exchange.atlas", type: Loader.ATLAS});
            // _firstArr.push({url: "res/atlas/ui/pack.atlas", type: Loader.ATLAS});
            // _firstArr.push({url: "res/atlas/ui/changeSkin.atlas", type: Loader.ATLAS});
            // _firstArr.push({url: "res/atlas/ui/subscription.atlas", type: Loader.ATLAS});
            // _firstArr.push({url: "res/atlas/ui/match.atlas", type: Loader.ATLAS});

            _firstArr.push({url: "res/atlas/ui/fish.atlas", type: Loader.ATLAS});

            if (!WxC.isInMiniGame())
            {
                _firstArr.push({url: "spine/loading/YX_Loading.sk", type: Loader.BUFFER});
                _firstArr.push({url: "spine/loading/YX_Loading.png", type: Loader.IMAGE});
            }
            return _firstArr;
        }
		public function commonSceneArr():Array
        {
            return  [
                {url: ConfigManager.getSecondConfigPath(), type: Loader.JSON},
                // {url: "res/atlas/ani/shuimu.atlas", type: Loader.ATLAS},
                // {url: "res/atlas/ani/bullet.atlas", type: Loader.ATLAS},
                // {url: "res/atlas/ani/paotai.atlas", type: Loader.ATLAS},
                // {url: "res/atlas/ani/paosheng.atlas", type: Loader.ATLAS},
                // {url: "res/atlas/ani/guide.atlas", type: Loader.ATLAS},
                // {url: "res/atlas/ani/coin.atlas", type: Loader.ATLAS},
                // {url: "res/atlas/ani/coin1.atlas", type: Loader.ATLAS},
                // {url: "res/atlas/ani/cd.atlas", type: Loader.ATLAS},
                // {url: "res/atlas/ani/fish20.atlas", type: Loader.ATLAS},
                // {url: "res/atlas/ani/shiziyu.atlas", type: Loader.ATLAS},
                // {url: "res/atlas/ani/fish22.atlas", type: Loader.ATLAS},
                // {url: "res/atlas/ani/fish23.atlas", type: Loader.ATLAS},
                // {url: "res/atlas/ani/fengweiyu.atlas", type: Loader.ATLAS},
                // {url: "res/atlas/ani/hetun.atlas", type: Loader.ATLAS},
                // {url: "res/atlas/ani/jinyu.atlas", type: Loader.ATLAS},
                // {url: "res/atlas/ani/fish28.atlas", type: Loader.ATLAS},
                // {url: "res/atlas/ani/fish29.atlas", type: Loader.ATLAS},
                // {url: "res/atlas/ani/fish25.atlas", type: Loader.ATLAS},
                // {url: "res/atlas/ani/fish24.atlas", type: Loader.ATLAS},
                // {url: "res/atlas/ani/fish26.atlas", type: Loader.ATLAS},
                // {url: "res/atlas/ani/haigui.atlas", type: Loader.ATLAS},
                // {url: "res/atlas/ani/fish30.atlas", type: Loader.ATLAS},
                // {url: "res/atlas/ani/fish31.atlas", type: Loader.ATLAS},
                // {url: "res/atlas/ani/kedou.atlas", type: Loader.ATLAS},
                // {url: "res/atlas/ani/haima.atlas", type: Loader.ATLAS},
                // {url: "res/atlas/ani/zhangyu.atlas", type: Loader.ATLAS},
                // {url: "scene/scene_1_1_1.png", type: Loader.IMAGE},
                // {url: "scene/scene_1_1_2.png", type: Loader.IMAGE},
                // {url: "scene/scene_1_2.png", type: Loader.IMAGE},
                // {url: "scene/scene_1_3.png", type: Loader.IMAGE},
                {url: "scene/freeze.png", type: Loader.IMAGE},
                // {url: "res/atlas/ui/fight.atlas", type: Loader.ATLAS},
                // {url: "res/atlas/ui/fish.atlas", type: Loader.ATLAS},

                    //骨骼
                // {url: "spine/sanguanpao/sanguanpao.sk", type: Loader.BUFFER},
                // {url: "spine/chuantoupao1/chuantoupao_01.sk", type: Loader.BUFFER},
                // {url: "spine/chujipao1/chujipao_01.sk", type: Loader.BUFFER},
                // {url: "spine/sandanpao1/sandanpao_01.sk", type: Loader.BUFFER},
                // {url: "spine/sushepao1/sushepao_01.sk", type: Loader.BUFFER},
                // {url: "spine/chuantoupao2/chuantoupao_02.sk", type: Loader.BUFFER},
                // {url: "spine/chujipao2/chujipao_02.sk", type: Loader.BUFFER},
                // {url: "spine/sandanpao2/sandanpao_02.sk", type: Loader.BUFFER},
                // {url: "spine/sushepao2/sushepao_02.sk", type: Loader.BUFFER},
                // {url: "spine/chuantoupaoEffect/H5_chuantoupao.sk", type: Loader.BUFFER},
                // {url: "spine/putongpaoEffect/H5_putongpao.sk", type: Loader.BUFFER},
                // {url: "spine/shanshepaoEffect/H5_shanshepao.sk", type: Loader.BUFFER},
                // {url: "spine/shushepaoEffect/H5_shushepao.sk", type: Loader.BUFFER},
                // {url: "spine/zhuanfanle/zhuanfanle.sk", type: Loader.BUFFER},
                // {url: "spine/facaile/facaile.sk", type: Loader.BUFFER},
                // {url: "spine/zhuanpan/H5_zhuanpan.sk", type: Loader.BUFFER},
                // {url: "spine/suoding/H5_suoding.sk", type: Loader.BUFFER},
                // {url: "spine/baozha2/H5_baozha.sk", type: Loader.BUFFER},
                // {url: "spine/bossbaozha/H5_bossbaozha.sk", type: Loader.BUFFER},
                // {url: "spine/shengji/ShengJi.sk", type: Loader.BUFFER},
                // {url: "spine/dujiaojing/dujiaojing.sk", type: Loader.BUFFER},
                // {url: "spine/shijiebeiEffect/H5_shijiebei.sk", type: Loader.BUFFER},
                // {url: "spine/shijiebei/shijiebei.sk", type: Loader.BUFFER},

                // {url: "spine/sanguanpao/sanguanpao.png", type: Loader.IMAGE},
                // {url: "spine/chuantoupao1/chuantoupao_01.png", type: Loader.IMAGE},
                // {url: "spine/chujipao1/chujipao_01.png", type: Loader.IMAGE},
                // {url: "spine/sandanpao1/sandanpao_01.png", type: Loader.IMAGE},
                // {url: "spine/sushepao1/sushepao_01.png", type: Loader.IMAGE},
                // {url: "spine/chuantoupao2/chuantoupao_02.png", type: Loader.IMAGE},
                // {url: "spine/chujipao2/chujipao_02.png", type: Loader.IMAGE},
                // {url: "spine/sandanpao2/sandanpao_02.png", type: Loader.IMAGE},
                // {url: "spine/sushepao2/sushepao_02.png", type: Loader.IMAGE},
                // {url: "spine/chuantoupaoEffect/H5_chuantoupao.png", type: Loader.IMAGE},
                // {url: "spine/putongpaoEffect/H5_putongpao.png", type: Loader.IMAGE},
                // {url: "spine/shanshepaoEffect/H5_shanshepao.png", type: Loader.IMAGE},
                // {url: "spine/shushepaoEffect/H5_shushepao.png", type: Loader.IMAGE},
                // {url: "spine/zhuanfanle/zhuanfanle.png", type: Loader.IMAGE},
                // {url: "spine/facaile/facaile.png", type: Loader.IMAGE},
                // {url: "spine/zhuanpan/H5_zhuanpan.png", type: Loader.IMAGE},
                // {url: "spine/suoding/H5_suoding.png", type: Loader.IMAGE},
                // {url: "spine/baozha2/H5_baozha.png", type: Loader.IMAGE},
                // {url: "spine/bossbaozha/H5_bossbaozha.png", type: Loader.IMAGE},
                // {url: "spine/shengji/ShengJi.png", type: Loader.IMAGE},
                // {url: "spine/dujiaojing/dujiaojing.png", type: Loader.IMAGE},
                // {url: "spine/shijiebeiEffect/H5_shijiebei.png", type: Loader.IMAGE},
                // {url: "spine/shijiebei/shijiebei.png", type: Loader.IMAGE},
            ]
        }
        public function commonSceneSpineArr():Array
        {
            return [
                "spine/chuantoupao1/chuantoupao_01.sk",
                "spine/chujipao1/chujipao_01.sk",
                "spine/sandanpao1/sandanpao_01.sk",
                "spine/sushepao1/sushepao_01.sk",
                "spine/chuantoupao2/chuantoupao_02.sk",
                "spine/chujipao2/chujipao_02.sk",
                "spine/sandanpao2/sandanpao_02.sk",
                "spine/sushepao2/sushepao_02.sk",
                "spine/chuantoupaoEffect/H5_chuantoupao.sk",
                "spine/putongpaoEffect/H5_putongpao.sk",
                "spine/shanshepaoEffect/H5_shanshepao.sk",
                "spine/shushepaoEffect/H5_shushepao.sk",
                "spine/zhuanfanle/zhuanfanle.sk",
                "spine/facaile/facaile.sk",
                "spine/zhuanpan/H5_zhuanpan.sk",
                "spine/suoding/H5_suoding.sk",
                "spine/baozha2/H5_baozha.sk",
                "spine/bossbaozha/H5_bossbaozha.sk",
                "spine/shengji/ShengJi.sk",
                "spine/dujiaojing/dujiaojing.sk",
                "spine/shijiebeiEffect/H5_shijiebei.sk",
                "spine/shijiebei/shijiebei.sk",
            ]
        }

        private function loadSkeleton(skName:String, imgName:String, resArr:Array, spineArr:Array):void
        {
            resArr.push({url: skName, type: Loader.BUFFER});
            resArr.push({url: imgName, type: Loader.IMAGE});
            spineArr.push(skName);
        }

        //第一个场景的资源
        public function get firstSceneArr():Array
        {
            if (_firstSceneArr)
            {
                return _firstSceneArr;
            }
            _firstSceneArr = commonSceneArr();
            _firstSceneSpineArr = commonSceneSpineArr();

            _firstSceneArr.push({url: "ui/fish/boss_1.png", type: Loader.IMAGE});

            return _firstSceneArr;
        }

        //第一个场景要解析的骨骼动画资源
        public function get firstSceneSpineArr():Array
        {
            return _firstSceneSpineArr;
        }


        //第二个场景资源
        public function get secondScene():Array
        {
            if (_secondSceneArr)
            {
                return _secondSceneArr;
            }
            _secondSceneArr = commonSceneArr();
            _secondSceneSpineArr = commonSceneSpineArr()
            _secondSceneArr.push({url: "ui/fish/boss_2.png", type: Loader.IMAGE});
            _secondSceneArr.push({url: "res/atlas/ani/chutousha.atlas", type: Loader.ATLAS});


            loadSkeleton("spine/heidong/H5_heidong.sk", "spine/heidong/H5_heidong.png", _secondSceneArr, _secondSceneSpineArr);
            return _secondSceneArr;
        }

        //第二个场景解析骨骼动画资源
        public function get secondScnenSpineArr():Array
        {
            return _secondSceneSpineArr;
        }


        //第三个场景资源
        public function get threeScnen():Array
        {
            if (_threeSceneArr)
            {
                return _threeSceneArr;
            }
            _threeSceneArr = commonSceneArr();
            _threeSceneSpineArr = commonSceneSpineArr();
            _threeSceneArr.push({url: "ui/fish/boss_3.png", type: Loader.IMAGE});
            _threeSceneArr.push({url: "res/atlas/ani/fish21.atlas", type: Loader.ATLAS});
            _threeSceneArr.push({url: "res/atlas/ani/fish27.atlas", type: Loader.ATLAS});

            loadSkeleton("spine/qiandai/H5_qiandai.sk", "spine/qiandai/H5_qiandai.png", _threeSceneArr, _threeSceneSpineArr);

            return _threeSceneArr;
        }

        //第三个场景解析骨骼动画资源
        public function get threeSceneSpineArr():Array
        {
            return _threeSceneSpineArr;
        }


        //第四个场景资源
        public function get fourScene():Array
        {
            if (_fourSceneArr)
            {
                return _fourSceneArr;
            }
            _fourSceneArr = commonSceneArr();
            _fourSceneSpineArr = commonSceneSpineArr();
            _fourSceneArr.push({url: "ui/fish/boss_4.png", type: Loader.IMAGE});
            _fourSceneArr.push({url: "res/atlas/ani/fish21.atlas", type: Loader.ATLAS});

            return _fourSceneArr;
        }

        //第四个场景解析骨骼动画资源
        public function get fourSceneSpineArr():Array
        {
            return _fourSceneSpineArr;
        }


        //第五个场景资源
        public function get fiveScene():Array
        {
            if (_fiveSceneArr)
            {
                return _fiveSceneArr;
            }
            _fiveSceneArr = commonSceneArr();
            _fiveSceneSpineArr = commonSceneSpineArr();

            _fiveSceneArr.push({url: "ui/fish/boss_4.png", type: Loader.IMAGE});
            _fiveSceneArr.push({url: "res/atlas/ui/matchSettle.atlas", type: Loader.ATLAS});

            return _fiveSceneArr;
        }

        //第五个场景的骨骼动画资源
        public function get fiveSceneSpineArr():Array
        {
            return _fiveSceneSpineArr;
        }


        //第六个场景资源
        public function get sixScene():Array
        {
            if (_sixSceneArr)
            {
                return _sixSceneArr;
            }
            _sixSceneArr = commonSceneArr();
            _sixSceneSpineArr = commonSceneSpineArr();

            _sixSceneArr.push({url: "ui/fish/boss_4.png", type: Loader.IMAGE});
            _sixSceneArr.push({url: "res/atlas/ui/matchSettle.atlas", type: Loader.ATLAS});


            return _sixSceneArr;
        }

        //第六个场景的骨骼动画资源
        public function get sixSceneSpineArr():Array
        {
            return _sixSceneSpineArr;
        }


        //第七个场景资源
        public function get sevenScene():Array
        {
            if (_sevenSceneArr)
            {
                return _sevenSceneArr;
            }
            _sevenSceneArr = commonSceneArr();
            _sevenSceneSpineArr = commonSceneSpineArr()

            _sevenSceneArr.push({url: "ui/fish/boss_4.png", type: Loader.IMAGE});
            _sevenSceneArr.push({url: "res/atlas/ui/matchSettle.atlas", type: Loader.ATLAS});


            return _sevenSceneArr;
        }

        //第七个场景的骨骼动画资源
        public function get sevenSceneSpineArr():Array
        {
            return _sevenSceneSpineArr;
        }


        //第八个场景动画资源
        public function get eightScene():Array
        {
            if (_eightSceneArr)
            {
                return _eightSceneArr;
            }
            _eightSceneArr = commonSceneArr();
            _eightSceneSpineArr = commonSceneSpineArr();

            _eightSceneArr.push({url: "ui/fish/boss_4.png", type: Loader.IMAGE});
            _eightSceneArr.push({url: "res/atlas/ui/matchSettle.atlas", type: Loader.ATLAS});
            loadSkeleton("spine/eyu/eyu.sk", "spine/eyu/eyu.png", _eightSceneArr, _eightSceneSpineArr);
            return _eightSceneArr;
        }

        //第八个骨骼动画资源
        public function get eightSceneSpineArr():Array
        {
            return _eightSceneSpineArr;
        }


		//断线重连进入第一场景
        public function get brokeFirstScnenArr():Array
        {
            _breakFirstScnen = new Array();
            for (var i:int = 0; i < firstArr.length; i++)
            {
                _breakFirstScnen.push(firstArr[i]);
            }
            for (var j:int = 0; j < firstSceneArr.length; j++)
            {
                _breakFirstScnen.push(firstSceneArr[j]);
            }
            return _breakFirstScnen;
        }

        //断线重连进入第二个场景
        public function get brokeSecondSceneArr():Array
        {
            _breakSecondScene = new Array();
            for (var i:int = 0; i < firstArr.length; i++)
            {
                _breakFirstScnen.push(firstArr[i]);
            }
            for (var j:int = 0; j < secondScene.length; j++)
            {
                _breakFirstScnen.push(secondScene[j]);
            }
            return _breakSecondScene;
        }

        //断线重连进入第三个场景
        public function get brokeThreeSceneArr():Array
        {
            _breakThreeScene = new Array();
            for (var i:int = 0; i < firstArr.length; i++)
            {
                _breakThreeScene.push(firstArr[i]);
            }
            for (var j:int = 0; j < threeScnen.length; j++)
            {
                _breakThreeScene.push(threeScnen[j]);
            }
            return _breakThreeScene;
        }

        //断线重连进入第四个场景
        public function get brokeFourSceneArr():Array
        {
            _breakFourScene = new Array();
            for (var i:int = 0; i < firstArr.length; i++)
            {
                _breakFourScene.push(firstArr[i]);
            }
            for (var j:int = 0; j < fourScene.length; j++)
            {
                _breakFourScene.push(fourScene[j]);
            }
            return _breakFourScene;
        }

        //后台加载的资源
        public function get backgroundResArr():Array
        {
            _backgroundResArr = new Array();
            _backgroundResArr.push({url: "spine/zhuanpan/H5_zhuanpan.sk", type: Loader.BUFFER});
            _backgroundResArr.push({url: "spine/suoding/H5_suoding.sk", type: Loader.BUFFER});
            _backgroundResArr.push({url: "spine/ankangyu/ankangyu.sk", type: Loader.BUFFER});
            // _backgroundResArr.push({url: "spine/qiyu/qiyu.sk", type: Loader.BUFFER});
            _backgroundResArr.push({url: "spine/eyu/eyu.sk", type: Loader.BUFFER});
            _backgroundResArr.push({url: "spine/pangxie/pangxie.sk", type: Loader.BUFFER});
            _backgroundResArr.push({url: "spine/baozha2/H5_baozha.sk", type: Loader.BUFFER});
            _backgroundResArr.push({url: "spine/ankangyu/ankangyu.sk", type: Loader.BUFFER});
            _backgroundResArr.push({url: "spine/dujiaojing/dujiaojing.sk", type: Loader.BUFFER});
            _backgroundResArr.push({url: "spine/bossbaozha/H5_bossbaozha.sk", type: Loader.BUFFER});
            _backgroundResArr.push({url: "spine/facaile/facaile.sk", type: Loader.BUFFER});
            _backgroundResArr.push({url: "spine/baozha/H5_baozha.sk", type: Loader.BUFFER});
            _backgroundResArr.push({url: "spine/shengji/ShengJi.sk", type: Loader.BUFFER});
            // _backgroundResArr.push({url: "spine/zhaohuan/H5_zhaohuan.sk", type: Loader.BUFFER});
            // _backgroundResArr.push({url: "spine/shayu/shayu.sk", type: Loader.BUFFER});
            // _backgroundResArr.push({url: "spine/haitun/haitun.sk", type: Loader.BUFFER});
            // _backgroundResArr.push({url: "spine/qiandai/H5_qiandai.sk", type: Loader.BUFFER});
            // _backgroundResArr.push({url: "spine/haigui/haigui.sk", type: Loader.BUFFER});
            _backgroundResArr.push({url: "spine/heidong/H5_heidong.sk", type: Loader.BUFFER});
            _backgroundResArr.push({url: "scene/scene_1_1_1.png", type: Loader.IMAGE});
            _backgroundResArr.push({url: "scene/scene_1_1_2.png", type: Loader.IMAGE});
            _backgroundResArr.push({url: "scene/scene_1_2.png", type: Loader.IMAGE});
            _backgroundResArr.push({url: "scene/scene_1_3.png", type: Loader.IMAGE});
            _backgroundResArr.push({url: "res/atlas/ani/shuimu.atlas", type: Loader.ATLAS});
            _backgroundResArr.push({url: "res/atlas/ani/bullet.atlas", type: Loader.ATLAS});
            _backgroundResArr.push({url: "res/atlas/ani/paotai.atlas", type: Loader.ATLAS});
            _backgroundResArr.push({url: "res/atlas/ani/paosheng.atlas", type: Loader.ATLAS});
            _backgroundResArr.push({url: "res/atlas/ani/guide.atlas", type: Loader.ATLAS});
            _backgroundResArr.push({url: "res/atlas/ani/coin.atlas", type: Loader.ATLAS});
            _backgroundResArr.push({url: "res/atlas/ani/coin1.atlas", type: Loader.ATLAS});
            _backgroundResArr.push({url: "res/atlas/ani/cd.atlas", type: Loader.ATLAS});
            _backgroundResArr.push({url: "res/atlas/ani/fish20.atlas", type: Loader.ATLAS});
            _backgroundResArr.push({url: "res/atlas/ani/shiziyu.atlas", type: Loader.ATLAS});
            _backgroundResArr.push({url: "res/atlas/ani/fish22.atlas", type: Loader.ATLAS});
            _backgroundResArr.push({url: "res/atlas/ani/fish23.atlas", type: Loader.ATLAS});
            _backgroundResArr.push({url: "res/atlas/ani/fengweiyu.atlas", type: Loader.ATLAS});
            _backgroundResArr.push({url: "res/atlas/ani/hetun.atlas", type: Loader.ATLAS});
            _backgroundResArr.push({url: "res/atlas/ani/jinyu.atlas", type: Loader.ATLAS});
            _backgroundResArr.push({url: "res/atlas/ani/fish28.atlas", type: Loader.ATLAS});
            _backgroundResArr.push({url: "res/atlas/ani/fish29.atlas", type: Loader.ATLAS});
            _backgroundResArr.push({url: "res/atlas/ani/fish25.atlas", type: Loader.ATLAS});
            _backgroundResArr.push({url: "res/atlas/ani/fish24.atlas", type: Loader.ATLAS});
            _backgroundResArr.push({url: "res/atlas/ani/fish26.atlas", type: Loader.ATLAS});
            _backgroundResArr.push({url: "res/atlas/ani/haigui.atlas", type: Loader.ATLAS});
            _backgroundResArr.push({url: "res/atlas/ani/fish30.atlas", type: Loader.ATLAS});
            _backgroundResArr.push({url: "res/atlas/ani/fish31.atlas", type: Loader.ATLAS});
            _backgroundResArr.push({url: "res/atlas/ani/kedou.atlas", type: Loader.ATLAS});
            _backgroundResArr.push({url: "res/atlas/ani/haima.atlas", type: Loader.ATLAS});
            _backgroundResArr.push({url: "res/atlas/ani/zhangyu.atlas", type: Loader.ATLAS});
            return _backgroundResArr;
        }
	}

}
