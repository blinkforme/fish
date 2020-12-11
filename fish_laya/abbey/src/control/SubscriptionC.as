package control 
{
	import manager.GameTools;

	import model.RoleInfoM;
	import model.SubscriptionM;
	import manager.GameEventDispatch;
	import manager.GameEvent;
    import manager.WebSocketManager;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SubscriptionC 
	{
        private static var _instance:SubscriptionC;
		
		private var mainpagedisBtn:Boolean;
		private var ifgetListArr:Boolean;
		
		public function SubscriptionC()
		{
			GameEventDispatch.instance.on(String(41001), this, checkSubscribe);//41001
            //GameEventDispatch.instance.on(String(41003), this, getFirstSubscribe);
			
			GameEventDispatch.instance.on(String(39001), this, giftCodeInfoRturn);//礼包码旧接口
		}
		
		
		
		private function giftCodeInfoRturn(re:*):void
        {
            //console.log("39001状态码2", re.code);
			if (re.code == 0){
				//RoleInfoM.instance.setFirstSubscription(false);//
				//GameEventDispatch.instance.event(GameEvent.SubDisabled);//仅关闭sub页领取按钮
			} else if (1 == re.code)
			{
				GameEventDispatch.instance.event(GameEvent.MsgTipContent, "礼包码错误");
			} else if (2 == re.code)
			{
				GameEventDispatch.instance.event(GameEvent.MsgTipContent, "礼包码错误");
			} else if (3 == re.code)
			{
				GameEventDispatch.instance.event(GameEvent.MsgTipContent, "礼包码错误");
			} else if (4 == re.code)
			{
				GameEventDispatch.instance.event(GameEvent.MsgTipContent, "礼包码错误");
			} else if (5 == re.code)
			{
				GameEventDispatch.instance.event(GameEvent.MsgTipContent, "该礼包码已过期");
			} else if (6 == re.code)
			{
				GameEventDispatch.instance.event(GameEvent.MsgTipContent, "该礼包码不可使用");
			} else if (7 == re.code)
			{
				GameEventDispatch.instance.event(GameEvent.MsgTipContent, "该礼包码不可使用");
			} else if (8 == re.code)
			{
				GameEventDispatch.instance.event(GameEvent.MsgTipContent, "该礼包码不可使用");
			} else if (9 == re.code)
			{
				GameEventDispatch.instance.event(GameEvent.MsgTipContent, "已经领取完该礼包");
			} else if (10 == re.code)
			{
				GameEventDispatch.instance.event(GameEvent.MsgTipContent, "已经使用过该礼包码");
			} else if (11 == re.code)
			{
				GameEventDispatch.instance.event(GameEvent.MsgTipContent, "该礼包码不可使用");
			} else if (12 == re.code)
			{
				GameEventDispatch.instance.event(GameEvent.MsgTipContent, "服务器繁忙，请稍后重试");
			} else if (13 == re.code)
			{
				GameEventDispatch.instance.event(GameEvent.MsgTipContent, "该礼包码不可使用");
			} else
			{
				GameTools.dealCode(re.code)
			}
        }

		private function checkSubscribe(res):void
		{
			//reward:[12,1][13,4]
			if (res.code == 0){
				//GameEventDispatch.instance.event(GameEvent.RewardTip, [res.reward[0], res.reward[1]]);//获取道具
				//GameEventDispatch.instance.event(GameEvent.MsgTipContent, "已关注,未领奖");
			}
			else if (res.code==1){
				//已关注,已领奖
				//checkgetGift();
			}
			else if (res.code==2){
				//GameEventDispatch.instance.event(GameEvent.MsgTipContent, "暂未关注公众号");
				//关闭按钮
				GameEventDispatch.instance.event(GameEvent.ResetSubBtn,[true]);
			}
			else if (res.code==3){
				//未关注,已领奖
				//checkgetGift();
			}
			else{
				GameEventDispatch.instance.event(GameEvent.MsgTipContent, "网络请求失败,请重试");
			}
			
			//updatelist
			if (!ifgetListArr){
				ifgetListArr = true;
				//GameEventDispatch.instance.event(GameEvent.UpdateGiftlist, [res.reward[0], res.reward[1]);
				GameEventDispatch.instance.event(GameEvent.UpdateGiftlist,[res.reward]);
			}
			
		}
		
		private function checkgetGift():void
		{
			if (!mainpagedisBtn){
				mainpagedisBtn = true;
				
				RoleInfoM.instance.setFirstSubscription(false);
				GameEventDispatch.instance.event(GameEvent.SyncSubscriptionIco);//关闭主页ico
			}
		}
		
		
		
		
		
		private function getFirstSubscribe(res):void
		{
			if (res.code == 0){
				//关闭页面和图标
				//GameEventDispatch.instance.event(GameEvent.MsgTipContent, "领取成功");
			}
			else if (res.code==1){
				GameEventDispatch.instance.event(GameEvent.MsgTipContent, "重复领奖");
			}
			else if (res.code==2){
				GameEventDispatch.instance.event(GameEvent.MsgTipContent, "网络请求失败,请重试");
			}
		}
		
        public static function get instance():SubscriptionC
        {
            return _instance || (_instance = new SubscriptionC());
        }
	}

}
