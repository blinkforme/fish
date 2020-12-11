package model
{
	/**
	 * ...
	 * @author ...
	 */
	public class SubscriptionM 
	{
		private static var _instance:SubscriptionM;
		
		private var _giftcode:String = "";//玩家活动积分
				
		public function SubscriptionM() 
		{
			
		}
		
        public static function get instance():SubscriptionM
        {
            return _instance || (_instance = new SubscriptionM());
        }
		
		
		public function getGiftcode():String
		{
			return _giftcode;
		}
		public function setGiftcode(_str:String):void
		{
			_giftcode = _str;
		}
	}

}