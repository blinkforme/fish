package manager
{
    import engine.tool.StartParam;

    import laya.media.SoundManager;

    public class GameSoundManager
    {
        public static var playInfo:Object = new Object();

        //声音播放间隔
        public static var soundInterval:Object =
                {
                    "music/fish1_1.mp3": 5000,
                    "music/fish1_2.mp3": 5000,
                    "music/fish1_3.mp3": 5000,
                    "music/fish1_4.mp3": 5000,
                    "music/fish1_5.mp3": 5000,
                    "music/fish2_1.mp3": 5000,
                    "music/fish2_2.mp3": 5000,
                    "music/fish2_3.mp3": 5000,
                    "music/fish2_4.mp3": 5000,
                    "music/fish2_5.mp3": 5000,
                    "music/fish2_6.mp3": 5000,
                    "music/fish2_7.mp3": 5000,
                    "music/batteryup.mp3": 2000,
                    "music/bingdong.mp3": 2000,
                    "music/bingo.mp3": 4000,
                    "music/click.mp3": 1000,
                    //"music/get.mp3":1000,
                    //"music/getcoin.mp3":1000,
                    //"music/hit.mp3":1000,
                    "music/kuangbao.mp3": 2000,
                    "music/levelup.mp3": 5000,
                    "music/reward.mp3": 3000,
                    //"music/shoot.mp3":1000,
                    "music/suoding.mp3": 4000,
                    "music/tide.mp3": 2000,
                    "music/yulei.mp3": 2000,
                    "music/zhaohuan.mp3": 2000


                };

        public static function getPlaySoundInterval(url:String):Number
        {
            //			if(soundInterval[url])
            //			{
            //				return soundInterval[url]
            //			}
            return 0;
        }

        public static function playSound(url:String):void
        {

            if(StartParam.instance.getParam("stopAllSound") == 2)
            {
                SoundManager.stopMusic();
                return;
            }

            var date:Date = new Date();
            if (!playInfo[url])
            {
                SoundManager.playSound(url);
                playInfo[url] = date.getTime();
            }
            else
            {
                if (date.getTime() - playInfo[url] >= getPlaySoundInterval(url))
                {
                    SoundManager.playSound(url);
                    playInfo[url] = date.getTime();
                }
                else
                {
                    trace("skip sound ", playInfo[url], date.getTime(), getPlaySoundInterval(url));

                }
            }
        }

    }
}
