package control
{


    import emurs.ShowType;

    import engine.tool.StartParam;

    import manager.GameConst;

    import manager.UiManager;
    import manager.WebSocketManager;

    import model.CertificationM;

    import model.CertificationM;
    import model.ExchangeM;
    import model.FriendM;
    import model.FriendM;

    import model.LoginInfoM;
    import model.LoginM;
    import model.MatchM;

    import model.RoleInfoM;

    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.GameTools;

    import struct.CertificationInfo;

    public class BankC
    {
        private static var _instance:BankC;
        private var times = 0;

        public function BankC()
        {

            GameEventDispatch.instance.on(String(33003), this, end_deposit_in);
            GameEventDispatch.instance.on(String(33005), this, end_take_out);
            GameEventDispatch.instance.on(String(33006), this, syncBankInfo);
            GameEventDispatch.instance.on(String(33013), this, sync_bank_info);
            GameEventDispatch.instance.on(String(33015), this, receive_sms_code);
            GameEventDispatch.instance.on(String(33021), this, end_bind_tel);

            GameEventDispatch.instance.on(String(10028), this, synConfigOnOff);
        }

        private function synConfigOnOff(res:*):void
        {
            if (res['bank_max_barbette'])
            {
                LoginInfoM.instance.openBankBatteryLevel = res['bank_max_barbette']
            }


            if (res['certification_switch'] || Number(res['certification_switch']) == 0)
            {
                var certification = LoginM.instance.isCompleteCertification
                LoginInfoM.instance.openCertification = res['certification_switch']
                times++

                if (res['certification_switch'] == 1 && times > 1 && certification == 0)
                {
                    if (CertificationM.instance.isOpenCertification())
                    {
                        var certInfo:CertificationInfo = new CertificationInfo();
                        certInfo.openFrom = GameConst.from_login;
                        CertificationM.instance.info = certInfo;
                        CertificationM.instance.OpenCertification()
                    }
                }
            }

            if (res["name_filter"])
            {
                LoginInfoM.instance.nameFilter = res["name_filter"]
                GameEventDispatch.instance.event(GameEvent.UpdateProfile);
            }

            if (res["redpack_cfg"])
            {
                if (res["redpack_cfg"]["wx"])
                {
                    ExchangeM.instance.wx_wxExchangeOpen = res["redpack_cfg"]["wx"]["wx_open"]
                    ExchangeM.instance.wx_alipayExchangeOpen = res["redpack_cfg"]["wx"]["ali_open"]
                }
                if (res["redpack_cfg"]["h5"])
                {
                    ExchangeM.instance.h5_wxExchangeOpen = res["redpack_cfg"]["h5"]["wx_open"]
                    ExchangeM.instance.h5_alipayExchangeOpen = res["redpack_cfg"]["h5"]["ali_open"]
                }
            }
            if (res['friend_limit_num'])
            {
                FriendM.instance.friendLimit = res['friend_limit_num']
            }

            if (res['contest_open'] || Number(res['contest_open']) == 0)
            {
                MatchM.instance.contestOpen = res['contest_open']
            }
        }

        public function receive_sms_code(data:*):void
        {
            if (0 == data.code)
            {
                GameTools.showTip("发送验证码成功")
            } else
            {
                GameTools.showTip("发送验证码失败")
            }

        }

        public function sync_bank_info(data:*):void
        {
            if (data.code == 0)
            {
                RoleInfoM.instance.is_bind_tel = data['is_bind_bank'];
                RoleInfoM.instance.isQuickRegister = data['is_quick_reg'];
                if (data['is_bind_bank'] == 1)
                {
                    RoleInfoM.instance.tel = data['tel'];
                    RoleInfoM.instance.bank_gold = data['bank_gold'];
                    RoleInfoM.instance.jjhNumber = data['jjhaccounts'];
                    RoleInfoM.instance.jjhId = data['jjhuserid'];

                    StartParam.instance.parseParam(
                            {
                                jjhid: data['jjhuserid']
                            }
                    )
                    GameEventDispatch.instance.event(GameEvent.SyncBankCoin);
                    if (CertificationM.instance.info && ENV.branchSwitch("certification"))
                    {
                        UiManager.instance.loadView("Certification", null, ShowType.SMALL_TO_BIG);
                    }
                } else
                {
                    if (CertificationM.instance.info && ENV.branchSwitch("certification"))
                    {
                        UiManager.instance.loadView("Certification", null, ShowType.SMALL_TO_BIG);
                    }
                }
            } else if ("E1" == data.code)
            {
                //提示激活账号
                if (ENV.openQuickRegister && data.is_show_tip == 1 && data.data.is_quick_reg == 1)
                {
                    RoleInfoM.instance.jjhNumber = data.data['jjhaccounts'];
                    RoleInfoM.instance.jjhId = data.data['jjhuserid'];
                    UiManager.instance.loadView("QuickRegister")
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, data.tips);
                }
            } else if ("custom_err" == data.code)
            {
                if (data.is_show_tip == 1)
                {
                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, data.tips);
                }
            } else
            {
                if (CertificationM.instance.info && CertificationM.instance.info.openFrom == GameConst.from_login)
                {
                    GameEventDispatch.instance.event(GameEvent.Regic);
                }
                if (data.is_show_tip == 1)
                {

                    GameEventDispatch.instance.event(GameEvent.MsgTipContent, "绑定信息获取失败")
                }
            }
        }

        public function end_bind_tel(data:*):void
        {
            if (0 == data.code)
            {
                RoleInfoM.instance.is_bind_tel = 1
                RoleInfoM.instance.tel = data['tel']
                RoleInfoM.instance.bank_gold = data['bank_gold']
                RoleInfoM.instance.jjhNumber = data['account']
                StartParam.instance.parseParam(
                        {
                            jjhid: data['jjhuserid']
                        }
                )
                GameEventDispatch.instance.event(GameEvent.SyncBankCoin);
                GameEventDispatch.instance.event(GameEvent.SynBankBindSuccess)
                GameTools.showTip("绑定成功")
            } else if (1 == data.code)
            {
                GameTools.showTip("未知错误")
            } else if (2 == data.code)
            {
                GameTools.showTip("此账号已被绑定")
            } else if (3 == data.code)
            {
                GameTools.showTip("此账号或ID不存在")
            } else if (4 == data.code)
            {
                GameTools.showTip("此帐号手机号不匹配")
            } else if (5 == data.code)
            {
                GameTools.showTip("此帐号登录密码有误")
            } else if (6 == data.code)
            {
                GameTools.showTip("对不起，此帐号已被禁用")
            } else if (7 == data.code)
            {
                GameTools.showTip("验证码错误")
            } else if ("custom_err" == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, data.tips);
            } else
            {
                GameTools.dealCode(data.code)
            }
        }

        public function end_deposit_in(data:*):void
        {
            if (0 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.EndBankDeposit);
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "存入成功");
            } else if (1 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "未绑定银行");
            } else if (3 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "存取失败");
            } else if (4 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "每次最少存入5万金币");
            } else if (5 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "当日存入金额已经超出上限，请降低金额或者明天再试");
            } else if (6 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "存取失败");
            } else if (10 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请退出渔场再试");
            } else if (11 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "需要月卡才可使用");
            } else if ("custom_err" == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, data.tips);
            }
            else
            {
                GameTools.dealCode(data.code)
            }
        }

        public function end_take_out(data:*):void
        {
            if (0 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.EndBankTake);
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "取出成功");
            } else if (1 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "未绑定银行");
            } else if (2 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "每次最少取出5万金币");
            } else if (3 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "当日取出金额已经超出上限，请降低金额或者明天再试");
            } else if (4 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "存取失败");
            } else if (5 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "存取失败");
            } else if (10 == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "请退出渔场再试");
            } else if ("custom_err" == data.code)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, data.tips);
            } else
            {
                GameTools.dealCode(data.code)
            }
        }

        public function syncBankInfo(data:*):void
        {
            RoleInfoM.instance.setCoin(data['gold'])
            RoleInfoM.instance.bank_gold = data['bank_gold']
            GameEventDispatch.instance.event(GameEvent.BankUpdate);
            GameEventDispatch.instance.event(GameEvent.UpdateProfile);
        }

        public static function get instance():BankC
        {
            return _instance || (_instance = new BankC());
        }
    }
}
