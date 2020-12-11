package proto
{
    public class ProtoBulletHitInfo
    {
        //		public var x:Number;
        //		public var y:Number;
        //		public var cx:Number;
        //		public var cy:Number;
        //		public var uniId:int;
        //		public var lc:int; //left count
        public var p:Array;

        public function getCx():Number
        {
            return p[0];
        }

        public function getCy():Number
        {
            return p[1];
        }

        public function getUniId():int
        {
            return p[2];
        }

        public function getLc():int
        {
            return p[3];
        }

        public function getFishUid():int
        {
            return p[4];
        }
    }
}
