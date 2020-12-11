package view.subscription 
{
	import emurs.UiType;
	
	import manager.BaseView;
	import manager.PanelVo;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Subscription extends BaseView implements PanelVo 
	{
		
		public function Subscription() 
		{
			super();
			
		}
		
		
		/* INTERFACE manager.PanelVo */
		
		public function get pngNum():int 
		{
			return 0;
		}
		
		public function startGame(parm:Object = null, name:String = null):void 
		{
			creatPanel(SubscriptionPage, parm, name);
		}
		
		public function get uiType():String 
		{
			return UiType.UI_TYPE_DLG;
		}
		
	}

}