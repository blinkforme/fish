package view.userBan
{
	import emurs.UiType;
	
	import manager.BaseView;
	import manager.PanelVo;
	

	public class UserBan extends BaseView implements PanelVo
	{
		public function UserBan()
		{
		}
		public function get pngNum():int
		{
			return 0;
		}
		public function get uiType():String
		{
			return UiType.UI_TYPE_MSG_TIP;
		}
		public function startGame(parm:Object = null, name:String = null):void
		{
			creatPanel(UserBanView, parm, name);
		}
	}
}