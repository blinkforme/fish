package fight
{
    public class FishRandom
    {
        private var randomArray:Array;

        public function FishRandom()
        {
            randomArray = [];
        }

        public static function create():FishRandom
        {
            var ret:FishRandom = new FishRandom();
            return ret;
        }

        public function getRandom(index:int):Number
        {
            if (index < randomArray.length)
            {
                return randomArray[index];
            }
            var rnd:Number = Math.random();
            randomArray.push(rnd);
            return rnd;
        }
    }
}
