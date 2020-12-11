package control
{
	import model.LoginInfoM;
	import model.RoleInfoM;
	
	import manager.GameEvent;
	import manager.GameEventDispatch;

	public class YylyC
	{
		public function YylyC()
		{
		}
		public static var yy_sid:* = null;
		public static var yylyLoginCount:Number = 0;
		public static var is_new:Number = 0;
		public static var roleId:* = null;
		public static var yylyEnable:Boolean = false;
		public static var roleName:* = null;
		public static var enterMain:Boolean = false;
		public static function config():void
		{
			yylyEnable = true;
			__JS__("WanGameH5sdk").config({
				share: {    // 分享参数配置
					success: function() {
						// 分享成功
						trace("share success")
					},
					cancel: function() {
						// 取消分享
						trace("share fail");
					}
				}
			});
			
			__JS__("WanGameH5sdk").login({
				success: function(data) {
					// 登录成功回调
					yy_sid = data.sid;
					GameEventDispatch.instance.event(GameEvent.YylyLoginComplete, null);
				}, 
				fail: function(data) {
					// 登录失败回调
				}
			});
//			__JS__("WanGameH5sdk").showShare();
//			__JS__("WanGameH5sdk").showFocus()
		}
		
		public static function ReachCreateRoleScene():void
		{
			__JS__("WanGameH5sdk").log({
				action: 'onscene', 
				actionvalue: 'createrolescene'
			});
		}
		
		public static function CreateRole(id:*, name:*):void
		{
			roleId = id;
			roleName = name;
			is_new = 1;
			__JS__("WanGameH5sdk").log({
				action: 'createrole',
				gser: '001',
				roleid: '' + id,
				rolename: '' + name
			});
		}
		
		
		
		public static function EnterGame():void
		{
			if(yylyEnable && !enterMain)
			{
				__JS__("WanGameH5sdk").log({
					action: 'access',
					gser: '001',
					roleid: '' + roleId,
					rolename: '' + roleName,
					rolelevel: '' + RoleInfoM.instance.getLevel()
				});
				enterMain = true;
			}
		}
		
		public static function EnterFirstScene():void
		{
			if(yylyEnable && 1 == is_new)
			{
				is_new = 0;
				__JS__("WanGameH5sdk").log({
					action: 'onscene',
					actionvalue: 'firstscene',
					gser: '001',
					roleid: '' + roleId,
					rolename: '' + roleName
				});
			}
		}
		
		public static function RoleLevelUp(level:*):void
		{
			if(yylyEnable)
			{
				__JS__("WanGameH5sdk").log({
					action: 'levelup',
					actionvalue: '' + level,
					gser: '001',
					roleid: '' + roleId,
					rolename: '' + roleName
				});
				
			}
		}
		
		public static function pay(data:*):void
		{
			var orderArgs:* = {
				sdkOrderId:data.data.sdkOrderId,
				amount:"" + data.data.amount,
				prodId:"" + data.data.prodId,
				prodName:data.data.prodName,
				prodDesc:data.data.prodName,
				serverId:"001",
				serverName:"服1",
				roleId:LoginInfoM.instance.uid,
				roleName:RoleInfoM.instance.getName(),
				gameName:"集结号捕鱼h5"
			}
			__JS__("WanGameH5sdk").placeOrder(orderArgs);
			
		}
		
		
	}
}