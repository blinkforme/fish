package view.wdlogin
{
	import emurs.UiType;
	
	import manager.BaseView;
	import manager.PanelVo;
	
	public class Wdlogin extends BaseView implements PanelVo
	{
		public function Wdlogin()
		{
		}
		
		public function get pngNum():int
		{
			return 0;
		}
		
		public function startGame(parm:Object = null, name:String = null):void
		{
			creatPanel(WdloginPageView, parm, name);
		}
		
		public function get uiType():String
		{
			return UiType.UI_TYPE_DLG;
		}
	}
}