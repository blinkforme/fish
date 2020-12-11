package view.mask
{

    import control.WxC;

    import laya.events.Event;
    import laya.media.SoundManager;

    import manager.ConfigManager;
    import manager.GameSoundManager;
    import manager.ResVo;

    import ui.abbey.MaskUI;

    public class MaskView extends MaskUI implements ResVo
    {

        public function MaskView()
        {
            super();
            Laya.stage.on(Event.CLICK, this, function ()
            {
                play();
            })
        }

        public function StartGames(parm:Object = null):void
        {

        }

        public function play()
        {
            var soundPath:String = ConfigManager.getConfValue("cfg_global", 1, "click_sound") as String;

            if (WxC.isInMiniGame())
            {
				soundPath = "wxlocal/click.mp3";
                //SoundManager.stopEarListSound(soundPath);
            }
            GameSoundManager.playSound(soundPath);
        }

        public function register():void
        {
        }

        public function unRegister():void
        {
        }
    }
}
