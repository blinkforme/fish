package control
{
    import manager.GameTools;

    import model.LoadResM;
    import model.LoginInfoM;
    import model.LoginM;

    import laya.utils.Browser;

    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.UiManager;
    import manager.WebSocketManager;

    import model.MatchM;

    import model.RoleInfoM;

    import proto.C2s_12001;

    import struct.QuitTipInfo;

    public class LoginC
    {
        private static var _instance:LoginC;
        public static var isCanExit:Boolean = true

        public function LoginC()
        {
            GameEventDispatch.instance.on(GameEvent.StartLoad, this, startLoad);
            GameEventDispatch.instance.on(GameEvent.RestInRoom, this, resetRoom);
            GameEventDispatch.instance.on(GameEvent.ExitsGame, this, start);
            GameEventDispatch.instance.on(GameEvent.AndroidReturnKey, this, gameReturn);
            returnMain();

            //身份认证
            GameEventDispatch.instance.on(String(60000), this, syncCertificationEnd);
            GameEventDispatch.instance.on(String(60002), this, syncCertificationSuccess);
            GameEventDispatch.instance.on(String(60006), this, syncNovicePlayer);
        }

        private function syncNovicePlayer(res:*):void
        {
            if (res)
            {
                LoginM.instance.isNovicePlayer = res.new_player;
            }
        }

        private function syncCertificationEnd(res:*):void
        {
            if (res)
            {
                LoginM.instance.popupCertificationTimes = res.popup_times;
                LoginM.instance.isCompleteCertification = res.certification;
                if (JSON.stringify(res.ageType))
                {
                    LoginInfoM.instance.ageType = res.ageType;
                }
                GameEventDispatch.instance.event(GameEvent.SyncCertificationInfo)
            }
        }


        private function syncCertificationSuccess(res:*):void
        {
            if (res.code == 0)
            {
                if (res.is_quick_reg == 1)
                {
                    var aInfo = res.jjhaccount;
                    if (aInfo)
                    {
                        RoleInfoM.instance.jjhNumber = aInfo.jjhaccounts
                        RoleInfoM.instance.jjhId = aInfo.jjhuserid
                        RoleInfoM.instance.jjhPass = aInfo.logonpass
                        RoleInfoM.instance.bankPass = aInfo.bankpass
                        RoleInfoM.instance.tel = aInfo.phone
                    }
                    RoleInfoM.instance.reenter = res.reenter;

                    GameEventDispatch.instance.event(GameEvent.UpdateJJHAcInfo)

                } else
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "身份认证成功")
                    GameEventDispatch.instance.event(GameEvent.BindInfoTel)
                }
            } else if (res.code == 1)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "真实姓名或身份证输入错误")
            } else if (res.code == 2)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "重复认证")
            } else if (res.code == 3)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "身份证号不符合规范")
            } else if (res.code == 4)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "姓名不符合规范")
            } else if (res.code == 5)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "系统错误，请重试")
            } else if (res.code == 6)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "网络错误，请重试")
            } else if (res.code == "custom_err")
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, res.tips)
            } else
            {
                GameTools.dealCode(res.code)
            }
        }

        private function gameReturn():void
        {
            if (LoginM.instance.pageId == GameConst.FISH_PAGE)
            {
                tip();
            } else if (LoginM.instance.pageId == GameConst.MAIN_PAGE)
            {
                tipTwo();
            }
        }

        private function start():void
        {
            if (WxC.isInMiniGame())
            {
                WxC.exitGame();
            }
            else if (LoginInfoM.instance.fromAndroid())
            {
                __JS__("AndroidInterface.exitApp()");
            }
            else
            {
                Browser.window.top.postMessage("close", "*");
            }
        }

        private function resetRoom():void
        {
            if (LoginM.instance.getContestId() > 0)
            {
                if (LoginM.instance.sceneId == GameConst.contest_match_scene_id && LoginM.instance.roomId > 0)
                {
                    WebSocketManager.instance.send(12051, {roomNumber: LoginM.instance.roomId});
                } else
                {
                    WebSocketManager.instance.send(12051, MatchM.instance.storageData)
                }

            }
            else
            {
                var c2s:C2s_12001 = new C2s_12001();
                c2s.scene_id = LoginM.instance.sceneId;
                WebSocketManager.instance.send(12001, c2s);
            }
        }


        private function returnMain():void
        {
            if (!WxC.isInMiniGame())
            {
                Browser.window.addEventListener('message', function (event)
                {
                    if (event.data == 'exit_game')
                    {
                        if (LoginC.isCanExit)
                        {
                            gameReturn();
                        }
                        LoginC.isCanExit = true
                    }
                });
            }
        }

        public function tip():void
        {
            var info:QuitTipInfo = new QuitTipInfo();
            info.state = GameConst.quit_state_left_cancel_right_confirm;
            info.content = "是否退出房间？";
            info.confirmMsg = GameEvent.ReturnConfirm;
            info.autoCloseTime = 10;
            GameEventDispatch.instance.event(GameEvent.QuitTip, info);
        }

        public function tipTwo():void
        {
            var info:QuitTipInfo = new QuitTipInfo();
            info.state = GameConst.quit_state_left_cancel_right_confirm;
            info.content = "真的要退出游戏吗";
            info.confirmMsg = GameEvent.ExitsGame;
            info.autoCloseTime = 10;
            GameEventDispatch.instance.event(GameEvent.QuitTip, info);
        }


        private function startLoad(data:*):void
        {
            if (data == GameConst.loadMainState)
            {

                LoginM.instance.resArr = LoadResM.instance.firstArr;
                LoginM.instance.loginState = GameConst.loadMainState;
                LoginM.instance.spineArr = LoadResM.instance.firstSpineArr;
            } else if (data == GameConst.loadFishState)
            {
                LoginM.instance.loginState = GameConst.loadFishState;
                if (LoginM.instance.sceneId == 1)
                {
                    LoginM.instance.resArr = LoadResM.instance.firstSceneArr;
                    LoginM.instance.spineArr = LoadResM.instance.firstSceneSpineArr;
                } else if (LoginM.instance.sceneId == 2)
                {
                    LoginM.instance.resArr = LoadResM.instance.secondScene;
                    LoginM.instance.spineArr = LoadResM.instance.secondScnenSpineArr;
                } else if (LoginM.instance.sceneId == 3)
                {
                    LoginM.instance.resArr = LoadResM.instance.threeScnen;
                    LoginM.instance.spineArr = LoadResM.instance.threeSceneSpineArr;
                } else if (LoginM.instance.sceneId == 4)
                {
                    LoginM.instance.resArr = LoadResM.instance.fourScene;
                    LoginM.instance.spineArr = LoadResM.instance.fourSceneSpineArr;
                } else if (LoginM.instance.sceneId == 5)
                {
                    LoginM.instance.resArr = LoadResM.instance.fiveScene;
                    LoginM.instance.spineArr = LoadResM.instance.fiveSceneSpineArr;
                } else if (LoginM.instance.sceneId == 6)
                {
                    LoginM.instance.resArr = LoadResM.instance.sixScene;
                    LoginM.instance.spineArr = LoadResM.instance.sixSceneSpineArr;
                } else if (LoginM.instance.sceneId == 7)
                {
                    LoginM.instance.resArr = LoadResM.instance.sevenScene;
                    LoginM.instance.spineArr = LoadResM.instance.sevenSceneSpineArr;
                } else if (LoginM.instance.sceneId == 8)
                {
                    LoginM.instance.resArr = LoadResM.instance.eightScene;
                    LoginM.instance.spineArr = LoadResM.instance.eightSceneSpineArr;
                }
            }
            UiManager.instance.loadView("Load");
        }

        public static function get instance():LoginC
        {
            return _instance || (_instance = new LoginC());
        }
    }
}
