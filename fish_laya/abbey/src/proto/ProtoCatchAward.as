package proto
{
    public class ProtoCatchAward
    {
        //		public var t:int; //type
        //		public var v:int; //value
        //		public var r:int; //rate
        //		public var b:int; //bulletHit
        public var p:Array;

        public function getT():int
        {
            return p[0];
        }

        public function getV():int
        {
            return p[1];
        }
    }
}
