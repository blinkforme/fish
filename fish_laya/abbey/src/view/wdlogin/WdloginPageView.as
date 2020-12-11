package view.wdlogin
{
	import laya.events.Event;
	
	import manager.GameEvent;
	import manager.GameEventDispatch;
	import manager.ResVo;
	
	import ui.abbey.WDLoginPageUI;

	public class WdloginPageView extends WDLoginPageUI implements ResVo
	{
		public function WdloginPageView()
		{
			super();
		}
		
		public function StartGames(parm:Object = null):void
		{
			wxLogin.on(Event.CLICK, this, wxLoginClick);
		}
		
		private function wxLoginClick():void
		{
			__JS__("AndroidInterface.wxLogin()");
		}
		
		private function screenResize():void
		{
			
		}
		
		public function register():void
		{
			GameEventDispatch.instance.on(GameEvent.ScreenResize, this, screenResize);
		}
		
		public function unRegister():void
		{
			GameEventDispatch.instance.off(GameEvent.ScreenResize, this, screenResize);
		}
	}
}