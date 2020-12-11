package proto
{
    public class ProtoCatchFish
    {
        //		public var u:int; //uniId
        //		public var ag:int; //agent
        //		public var aw:Array; //award
        //		public var b:int; //1:子弹击中 0:其他连带(一网打尽等)
        public var p:Array;
        public var seat_info:ProtoSeatInfo; //延时显示时的位置
        public function getU():int
        {
            return p[0];
        }

        public function getAw():Array
        {
            return p[1]
        }

        public function getAg():int
        {
            return p[2]
        }

        public function getB():int
        {
            return p[3];
        }
    }
}
