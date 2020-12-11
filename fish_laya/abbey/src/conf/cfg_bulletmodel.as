
package conf
{
    import manager.ConfigManager
	public class cfg_bulletmodel
	{
        public static function init(sheet:Object):cfg_bulletmodel
        {
            var a:cfg_bulletmodel = new cfg_bulletmodel();

            
            a.id=sheet[0];
            a.bulletAni=sheet[1];
            a.bulletImg=sheet[2];
            a.cannonImg=sheet[3];
            a.bulletShotSound=sheet[4];
            a.cannonAni=sheet[5];
            a.cannonWaitAni=sheet[6];
            a.cannonFireAni=sheet[7];
            a.bulletBombAni=sheet[8];
            a.bulletWidth=sheet[9];
            a.bulletHeight=sheet[10];
            a.bulletBombWidthScale=sheet[11];
            a.bulletBombHeightScale=sheet[12];
            a.bulletXOffset=sheet[13];
            a.bulletYOffset=sheet[14];

            return a;
        }

        public static function instance(key:Object):cfg_bulletmodel
		{
            return ConfigManager.getConfObject("cfg_bulletmodel",key) as cfg_bulletmodel;
		}


        
        public var id:String;
        public var bulletAni:String;
        public var bulletImg:String;
        public var cannonImg:String;
        public var bulletShotSound:String;
        public var cannonAni:String;
        public var cannonWaitAni:String;
        public var cannonFireAni:String;
        public var bulletBombAni:String;
        public var bulletWidth:Number;
        public var bulletHeight:Number;
        public var bulletBombWidthScale:Number;
        public var bulletBombHeightScale:Number;
        public var bulletXOffset:Number;
        public var bulletYOffset:Number;


	}
}