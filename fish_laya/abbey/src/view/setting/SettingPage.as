package view.setting
{

    import control.LoginC;
    import control.WxC;

    import engine.tool.StartParam;

    import emurs.ShowType;

    import laya.events.Event;
    import laya.media.SoundManager;
    import laya.net.HttpRequest;
    import laya.utils.Browser;
    import laya.utils.Handler;

    import manager.ApiManager;

    import manager.GameConst;
    import manager.GameEvent;
    import manager.GameEventDispatch;
    import manager.ResVo;
    import manager.UiManager;
    import manager.WebSocketManager;

    import model.ExchangeM;

    import model.RoleInfoM;

    import struct.QuitTipInfo;

    import ui.abbey.SettingPageUI;
    import laya.ui.Label;
    import laya.utils.Utils;
    import manager.GameTools;

    public class SettingPage extends SettingPageUI implements ResVo
    {
        private var _startX:Number = 0;
        private var _startY:Number = 0;

        private var _code:String;

        public function SettingPage()
        {

        }

        public function StartGames(parm:Object = null):void
        {
            this.hitTestPrior = false;
            bmask.on(Event.CLICK, this, null)
            _startX = this.x;
            _startY = this.y;
            logoutBox.visible = false;
            setting_img.height = 400;
            logoutBtn.visible = false
            wxlogoutBox.visible = false
            quitWxlogoutBox.visible = false
            if (RoleInfoM.instance.is_bind_tel)
            {
                logoutBtn.visible = true
                setting_img.height = 428;
            }
            quitBtn.on(Event.CLICK, this, onQuitBtnClick);
            bgmBar.changeHandler = new Handler(this, onBgmChange);
            musicBar.changeHandler = new Handler(this, onMucicChange);
            feedBtn.on(Event.CLICK, this, clickFeed);
            muteBtn.on(Event.CLICK, this, onMuteBtnClick);
            logoutBtn.on(Event.CLICK, this, onLogOutBtn)
            quitWxlogoutBox.on(Event.CLICK, this, onQuitWxlogoutBox)
            logoutCheck.on(Event.CLICK, this, onLogOutCheck)
            logoutReturn.on(Event.CLICK, this, onLogOutReturn)
            startLogOutBtn.on(Event.CLICK, this, onStartLogOutBtn)
            copyLineBtn.on(Event.CLICK, this, onCopyLineBtn)
            quitGame.on(Event.CLICK, this, onExitBtn);
            if (WxC.isInMiniGame())
            {
                exitGame.visible = true
                exitGame.on(Event.CLICK, this, onExitGame)
                //                feedBtn.x = 244;
                //                giftcodeBtn.x = 418;
            }
            else
            {
                exitGame.visible = false
                //                feedBtn.x = 131;
                //                giftcodeBtn.x = 350;
            }
            provider_tel.text = StartParam.instance.getParam("provider_tel") + "";
            giftcodeBtn.on(Event.CLICK, this, showWriteGiftCode);
            //user_id.text = (RoleInfoM.instance.puuid + "").split(":")[1]
            screenResize();
        }

        private function onLogOutReturn():void
        {
            logoutBox.visible = false;
        }

        private function onLogOutCheck():void
        {
            if (logoutCheck.selected)
            {
                startLogOutBtn.disabled = false;
            } else
            {
                startLogOutBtn.disabled = true;
            }
        }

        private function onQuitWxlogoutBox():void
        {
            wxlogoutBox.visible = false
            quitWxlogoutBox.visible = false
        }

        private function onLogOutBtn():void
        {
            if (ExchangeM.instance._platform == GameConst.platform_not_wx)
            {
                if (!Browser.onPC)
                {
                    LoginC.isCanExit = false
                }
                Browser.window.open("https://www.jjhgame.com/logoff/apply")
            } else
            {
                wxlogoutBox.visible = true
                quitWxlogoutBox.visible = true
            }
        }

        private function onCopyLineBtn():void
        {
            WxC.wx_set_clipboard_data("https://www.jjhgame.com/logoff/apply");
        }

        private function onStartLogOutBtn():void
        {
            if (logoutCheck.selected)
            {
                WebSocketManager.instance.send(60007, null);
            }
        }

        private function showWriteGiftCode():void
        {
            writegiftcode.visible = true;
            codequiteBtn.visible = true
            codeconfirmBtn.on(Event.CLICK, this, onCodeConfirmClick);
            codequiteBtn.on(Event.CLICK, this, onCodeQuiteClick);
        }

        private function onExitBtn():void
        {
            var info:QuitTipInfo = new QuitTipInfo();
            info.state = GameConst.quit_state_left_cancel_right_confirm;
            info.content = "是否要退出游戏？";
            info.confirmCallback = Handler.create(this, QuitGame);
            info.autoCloseTime = 10;
            GameEventDispatch.instance.event(GameEvent.QuitTip, info);
        }

        private function QuitGame():void
        {
           GameTools.QuitGame();
        }


        private var canbeCode:Boolean = true;

        private function onCodeConfirmClick():void
        {
            _code = writegiftInput.text;
            if (_code.length == 0)
            {
                GameEventDispatch.instance.event(GameEvent.MsgTipContent, "礼包码不能为空");
            }
            else if (_code.length > 0 && canbeCode)
            {
                canbeCode = false;
                WebSocketManager.instance.send(39000, {key: _code});
                Laya.timer.once(2000, this, function ()
                {
                    canbeCode = true;
                });
            }
        }

        private function onCodeQuiteClick():void
        {
            writegiftInput.text = "";
            writegiftcode.visible = false;
            codequiteBtn.visible = false

        }

        private function clickFeed():void
        {
            UiManager.instance.loadView("FeedBack", null, ShowType.SMALL_TO_BIG);

        }

        private function onExitGame():void
        {
            WxC.exitGame();
        }


        private function screenResize():void
        {
            var contentWidth:int = 600;//组件范围widthGameEventDispatch.instance.off(GameEvent.ScreenResize,this,screenResize);
            var contentHeight:int = 450;//组件范围height
            var contentStartX:int = 340;//组件左边距
            var contentStartY:int = 100;//组件上边距
            var posXOff:Number = (Laya.stage.width - contentWidth) / 2;
            var posYOff:Number = (Laya.stage.height - contentHeight) / 2;
            this.pos(_startX + posXOff - contentStartX, _startY + posYOff - contentStartY);

            quitBtn.left = contentStartX - posXOff;
            quitBtn.top = contentStartY - posYOff;
            quitWxlogoutBox.left = contentStartX - posXOff;
            quitWxlogoutBox.top = contentStartY - posYOff;
            logoutReturn.left = contentStartX - posXOff;
            logoutReturn.top = contentStartY - posYOff;
            codequiteBtn.left = contentStartX - posXOff;
            codequiteBtn.top = contentStartY - posYOff;

        }


        private function onQuitBtnClick()
        {
            UiManager.instance.closePanel("Setting", true);
        }

        private function anchorPoint()
        {
            var soundVolume:Number = SoundManager.soundVolume;
            var musicVolume:Number = SoundManager.musicVolume;
            if (soundVolume > GameConst.default_sound)
            {
                //__JS__('_czc.push(["_trackEvent","音效","提高","",soundVolume,""]);')
            } else if (soundVolume < GameConst.default_sound)
            {
                //__JS__('_czc.push(["_trackEvent","音效","降低","",soundVolume,""]);')
            }

            if (musicVolume > GameConst.default_bgm_music)
            {
                //__JS__('_czc.push(["_trackEvent","背景音乐","提高","",musicVolume,""]);')
            } else if (musicVolume < GameConst.default_bgm_music)
            {
                //__JS__('_czc.push(["_trackEvent","背景音乐","降低","",musicVolume,""]);')
            }


        }

        public function unRegister():void
        {
            this.x = _startX;
            this.y = _startY;

            GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
            anchorPoint();
            if (ENV.isShowBannerAndAD())
            {
                if (WxC.isInMiniGame())
                {

                    WxC.instance.hideBannerAD()
                }
            }
        }


        public function register():void
        {
            GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);

            if (ENV.isShowBannerAndAD() && WxC.compareVersion(WxC.wxSDKVersion, GameConst.wxSDKVersion) >= 0)
            {
                if (WxC.isInMiniGame() && WxC.compareVersion(WxC.wxSDKVersion, GameConst.wxSDKVersion) >= 0)
                {
                    setting_img.y = 70
                    WxC.instance.showBannerAD()
                } else
                {
                    setting_img.y = 160
                }
            } else
            {
                setting_img.y = 160
            }
        }

        public function isMute():Boolean
        {
            return !bgmBar.value && !musicBar.value;
        }


        private function setDefault():void
        {
            SoundManager.setMusicVolume(GameConst.default_bgm_music)
            SoundManager.setSoundVolume(GameConst.default_sound)
            bgmBar.value = GameConst.default_bgm_music * 100;
            musicBar.value = GameConst.default_sound * 100;
        }

        private function setMute():void
        {
            SoundManager.setMusicVolume(0)
            SoundManager.setSoundVolume(0)
            bgmBar.value = 0;
            musicBar.value = 0;
        }

        private function onMuteBtnClick():void
        {
            if (isMute())
            {
                setDefault()
            } else
            {
                setMute()
            }
            setMuteBtn()
        }

        private function setMuteBtn():void
        {
            if (isMute())
            {
                muteBtn.skin = "ui/setting/close.png";
            } else
            {
                muteBtn.skin = "ui/setting/open.png";
            }
        }

        private function onBgmChange(value:Number):void
        {
            SoundManager.setMusicVolume(value / 100)
            setMuteBtn()
        }

        private function onMucicChange(value:Number):void
        {
            SoundManager.setSoundVolume(value / 100)
            setMuteBtn()
        }

    }
}
