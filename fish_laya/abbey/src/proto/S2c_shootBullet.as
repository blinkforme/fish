package proto
{
    public class S2c_shootBullet
    {
        //		public var startX:Number;
        //		public var startY:Number;
        //		public var endX:Number;
        //		public var endY:Number;
        //		public var sk:int; //皮肤
        //		public var bt:int; //炮台等级
        //		public var uniId:Number;
        //		public var index:int;//炮台位置
        //		public var coin:int;//消耗金币
        //		public var agent:int; //发射者的服务器唯一id
        //		public var sr:Number; //速度倍率
        //		public var fuid:int;
        //		public var m:int; //是否主子弹，决定炮台动作

        public var p:Array;

        public function getStartX():Number
        {
            return p[0];
        }

        public function getStartY():Number
        {
            return p[1];
        }

        public function getEndX():Number
        {
            return p[2];
        }

        public function getEndY():Number
        {
            return p[3];
        }

        public function getSk():int
        {
            return p[4];
        }

        public function getBt():int
        {
            return p[5];
        }

        public function getUniId():int
        {
            return p[6];
        }

        public function getIndex():int
        {
            return p[7];
        }

        public function getCoin():int
        {
            return p[8];
        }

        public function getAgent():int
        {
            return p[9];
        }

        public function getSr():Number
        {
            return p[10];
        }

        public function getFuid():int
        {
            return p[11];
        }

        public function getM():int
        {
            return p[12];
        }

        public function getHitCount():int
        {
            return p[13];
        }

        public function getTick():int
        {
            return p[14];
        }
    }
}
