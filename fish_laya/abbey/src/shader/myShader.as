package shader
{
	import laya.webgl.shader.Shader;
	
	/**
	 * 自定义着色器
	 *
	 */
	public class myShader extends Shader
	{
		/**
		 * 当前着色器的一个实例对象。
		 */
		public static var shader:myShader = new myShader();
		
		public function myShader()
		{
			//__INCLUDESTR__ ：包含一个文本文件到程序代码里。识别一个文本，并转换为字符串。
			//通过__INCLUDESTR__ 方法引入顶点着色器程序和片元着色器程序。
			var vs:String = __INCLUDESTR__("myShader.vs");
			var ps:String = __INCLUDESTR__("myShader.ps");
			super(vs, ps, "myShader");
		}
	}
}