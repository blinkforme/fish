
package conf
{
    import manager.ConfigManager
	public class cfg_anicollision
	{
        public static function init(sheet:Object):cfg_anicollision
        {
            var a:cfg_anicollision = new cfg_anicollision();

            
            a.id=sheet[0];
            a.name=sheet[1];
            a.colliOffsetX1=sheet[2];
            a.colliOffsetY1=sheet[3];
            a.colliWidth1=sheet[4];
            a.colliHeight1=sheet[5];
            a.colliOffsetX2=sheet[6];
            a.colliOffsetY2=sheet[7];
            a.colliWidth2=sheet[8];
            a.colliHeight2=sheet[9];
            a.colliOffsetX3=sheet[10];
            a.colliOffsetY3=sheet[11];
            a.colliWidth3=sheet[12];
            a.colliHeight3=sheet[13];
            a.colliOffsetX4=sheet[14];
            a.colliOffsetY4=sheet[15];
            a.colliWidth4=sheet[16];
            a.colliHeight4=sheet[17];
            a.colliOffsetX5=sheet[18];
            a.colliOffsetY5=sheet[19];
            a.colliWidth5=sheet[20];
            a.colliHeight5=sheet[21];
            a.pivotX=sheet[22];
            a.pivotY=sheet[23];
            a.deviationX=sheet[24];
            a.deviationY=sheet[25];
            a.aniSpeed=sheet[26];
            a.change=sheet[27];
            a.refL=sheet[28];
            a.colliOffsetX6=sheet[29];
            a.colliOffsetY6=sheet[30];
            a.colliWidth6=sheet[31];
            a.colliHeight6=sheet[32];
            a.aniPath=sheet[33];
            a.aniType=sheet[34];
            a.anilength=sheet[35];
            a.scale=sheet[36];
            a.spinePath=sheet[37];
            a.calMax=sheet[38];

            return a;
        }

        public static function instance(key:Object):cfg_anicollision
		{
            return ConfigManager.getConfObject("cfg_anicollision",key) as cfg_anicollision;
		}


        
        public var id:String;
        public var name:String;
        public var colliOffsetX1:Number;
        public var colliOffsetY1:Number;
        public var colliWidth1:Number;
        public var colliHeight1:Number;
        public var colliOffsetX2:Number;
        public var colliOffsetY2:Number;
        public var colliWidth2:Number;
        public var colliHeight2:Number;
        public var colliOffsetX3:Number;
        public var colliOffsetY3:Number;
        public var colliWidth3:Number;
        public var colliHeight3:Number;
        public var colliOffsetX4:Number;
        public var colliOffsetY4:Number;
        public var colliWidth4:Number;
        public var colliHeight4:Number;
        public var colliOffsetX5:Number;
        public var colliOffsetY5:Number;
        public var colliWidth5:Number;
        public var colliHeight5:Number;
        public var pivotX:Number;
        public var pivotY:Number;
        public var deviationX:Number;
        public var deviationY:Number;
        public var aniSpeed:Number;
        public var change:int;
        public var refL:Number;
        public var colliOffsetX6:Number;
        public var colliOffsetY6:Number;
        public var colliWidth6:Number;
        public var colliHeight6:Number;
        public var aniPath:String;
        public var aniType:int;
        public var anilength:Number;
        public var scale:Number;
        public var spinePath:String;
        public var calMax:Number;


	}
}