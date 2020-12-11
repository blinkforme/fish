package shader
{
	import laya.webgl.WebGLContext;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.utils.CONST3D2D;
	public class WaveShaderValue extends Value2D
	{
		public var texcoord:*;
		public function WaveShaderValue()
		{
			super(0, 0);
			var _vlen:int = 8 * CONST3D2D.BYTES_PE;
			//设置在shader程序文件里定义的属性的相关描述：[属性长度, 属性类型,false, 属性起始位置索引 * CONST3D2D.BYTES_PE];
			this.position = [2, WebGLContext.FLOAT, false, _vlen, 0];
			this.texcoord = [2, WebGLContext.FLOAT, false, _vlen, 2 * CONST3D2D.BYTES_PE];
			
			this.color = [4, WebGLContext.FLOAT, false, _vlen, 4 * CONST3D2D.BYTES_PE];
		}
	}
}