package proto
{
    public class ProtoFishInfo
    {
        //		public var ipath:int;
        //		public var cpath:int;
        //		public var path:Array;
        //		public var uniId:int;
        //		public var fishId:int;
        //		public var tick:int;
        //		public var segNum:int;
        //		public var isCatch:Boolean;
        //		public var x:Number;
        //		public var y:Number;
        //		public var hitStart:Boolean;
        //		public var angle:Number;
        //		public var segInit:Boolean;
        //		public var loop:int;
        //		public var tickNum:int;
        //		public var mirror:int;
        //		public var offX:Number;
        //		public var offY:Number;
        //		public var time:Number;
        //		public var ft:Number;
        //		public var cad:Number;
        public var p:Array;

        public function getUniId():int
        {
            return p[0];
        }

        public function getFishId():int
        {
            return p[1];
        }

        public function getFreezeStartTick():int
        {
            return p[2];
        }

        //		public function getCpath():int
        //		{
        //			return p[3];
        //		}
        public function getDelayTickNum():int
        {
            return p[3];
        }

        public function getPath():Array
        {
            return p[4];
        }

        public function getStartTick():int
        {
            return p[5];
        }

        public function isCatch():Boolean
        {
            return p[6] == 1
        }

        //		public function getX():Number
        //		{
        //			return p[7];
        //		}
        //		public function getY():Number
        //		{
        //			return p[8];
        //		}
        public function getOffX():Number
        {
            return p[7];
        }

        public function getOffY():Number
        {
            return p[8];
        }

        //		public function getSegNum():int
        //		{
        //			return p[11];
        //		}
        //		public function isSegInit():Boolean
        //		{
        //			return p[12] == 1;
        //		}
        //		public function isHitStart():Boolean
        //		{
        //			return p[13] == 1;
        //		}
        //		public function getLoop():int
        //		{
        //			return p[14];
        //		}
        //		public function getTickNum():int
        //		{
        //			return p[15];
        //		}
        //		public function getTime():Number
        //		{
        //			return p[16];
        //		}
        //		public function getAngle():Number
        //		{
        //			return p[17];
        //		}
        public function getMirror():int
        {
            return p[9];
        }

        //		public function getFt():Number
        //		{
        //			return p[10];
        //		}
        public function getExtraTick():int
        {
            return p[10];
        }

        //		public function getCad():Number
        //		{
        //			return p[11];
        //		}
        public function getcalldelayTickNum():int
        {
            return p[11];
        }

        public function getDelayDie():Number
        {
            return p[12];
        }

        //calldelay

        //		public var showDelay:Number;
        //		public var runTime:Number;
        //		public var isCatch:Boolean;
        //		public var smallGroupGuide:Boolean;
        //		public var beginSwimTime:Number;
        //		public var swimOut:Boolean;
        //		public var desReducePercent:Number;
        //		public var desReduceTime:Number;
        //		public var desReduceCastTime:Number;
        //		public var desResetBase:Number;
        //		public var desReduceRatio:Number;
        //		public var desReset:Boolean;
        //		public var reduceRatio:Number;
        //		public var reduceTime:Number;
        //		public var reduceLastTime:Number;
        //		public var reducePercent:Number;
        //		public var hitStart:Boolean;
        //		public var x:Number;
        //		public var y:Number;
        //		public var angle:Number;
        //		public var switchCount:int;
        //		public var beginChange:Boolean;
        //		public var swimTime:Number;
        //		public var swimTotalTime:Number;
        //		public var bpx:Number;
        //		public var bpy:Number;
        //		public var bezierChangeSpeedRate:Number;
        //		public var bezierChangeSpeedTime:Number;
        //		public var desX:Number;
        //		public var desY:Number;
        //		public var scrX:Number;
        //		public var scrY:Number;
        //		public var speed:Number;
        //		public var uniId:int;
        //		public var fishId:int;
        //		public var isLineSwim:Boolean;
        //		public var ucount:int;
    }
}
