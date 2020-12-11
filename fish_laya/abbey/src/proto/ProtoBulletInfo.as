package proto
{
    public class ProtoBulletInfo
    {
        //		public var startX:Number;
        //		public var startY:Number;
        //		public var endX:Number;
        //		public var endY:Number;
        //		public var sk:int; //皮肤
        //		public var uniId:Number;
        //		public var index:int;//炮台位置
        //		public var coin:int;//消耗金币
        //		public var agent:int; //发射者的服务器唯一id
        //		public var sr:Number; //速度倍率
        //		public var fuid:int;

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

        public function getFuid():int
        {
            return p[4];
        }

        public function getUniId():int
        {
            return p[5];
        }

        public function getCoin():int
        {
            return p[6];
        }

        public function getAgent():int
        {
            return p[7];
        }

        public function getIndex():int
        {
            return p[8];
        }

        public function getSk():Number
        {
            return p[9];
        }

        public function getSr():Number
        {
            return p[10];
        }

        public function getTick():int
        {
            return p[11];
        }

        public function getCount():int
        {
            return p[12];
        }
    }
}
