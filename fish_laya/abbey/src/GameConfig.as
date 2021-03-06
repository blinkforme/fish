/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package {
	import laya.utils.ClassUtils;
	import laya.ui.View;
	import laya.webgl.WebGL;
	import laya.display.Text;
	import laya.html.dom.HTMLDivElement;
	import laya.ani.bone.Skeleton;
	import engine.ui.component.HSliderRe;
	import view.item.FesDailyGiftItem;
	import ui.fight.matchInfoBoxUI;
	import ui.fight.matchResultBoxUI;
	import ui.fight.backBoxUI;
	/**
	 * 游戏初始化配置
	 */
	public class GameConfig {
		public static var width:int = 1280;
		public static var height:int = 720;
		public static var scaleMode:String = "exactfit";
		public static var screenMode:String = "horizontal";
		public static var alignV:String = "middle";
		public static var alignH:String = "center";
		public static var startScene:* = "abbey/LoadPage.scene";
		public static var sceneRoot:String = "";
		public static var debug:Boolean = false;
		public static var stat:Boolean = false;
		public static var physicsDebug:Boolean = false;
		public static var exportSceneToJson:Boolean = true;
		
		public static function init():void {
			//注册Script或者Runtime引用
			var reg:Function = ClassUtils.regClass;
			reg("laya.display.Text",Text);
			reg("laya.html.dom.HTMLDivElement",HTMLDivElement);
			reg("laya.ani.bone.Skeleton",Skeleton);
			reg("engine.ui.component.HSliderRe",HSliderRe);
			reg("view.item.FesDailyGiftItem",FesDailyGiftItem);
			reg("ui.fight.matchInfoBoxUI",matchInfoBoxUI);
			reg("ui.fight.matchResultBoxUI",matchResultBoxUI);
			reg("ui.fight.backBoxUI",backBoxUI);
		}
		GameConfig.init();
	}
}