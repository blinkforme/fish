package proto
{
    public class C2s_shootBullet
    {
        public var startX:Number;
        public var startY:Number;
        public var endX:int;
        public var endY:int;
        public var sk:int; //皮肤
        public var bt:int; //炮台等级
        public var sr:Number;
        public var index:int;
        public var lock:int; //是否锁定释放子弹
        public var fuid:int; //锁定的鱼目标
        public var uid:int; //子弹唯一id
        public var m:int;//是否主子弹
        public var tick:int;
    }
}
