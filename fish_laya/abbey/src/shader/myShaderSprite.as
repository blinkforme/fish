package shader
{
	import laya.display.Sprite;
	import laya.net.Loader;
	import laya.renders.RenderContext;
	import laya.renders.RenderSprite;
	import laya.resource.Texture;
	import laya.utils.Handler;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.utils.Buffer2D;
	import laya.webgl.utils.IndexBuffer2D;
	import laya.webgl.utils.VertexBuffer2D;
	
	import manager.GameConst;
	
	import shader.myShader;
	import shader.myShaderValue;
	
	/**
	 * 此类需继承自显示对象类。
	 * 在此类中使用了自定义的着色器程序。
	 * 注意：使用自定义着色器时，需要设置此显示对象类的渲染模式： this._renderType |= RenderSprite.CUSTOM;	并且需要重写此类的渲染处理函数。
	 *
	 */
	public class myShaderSprite extends Sprite
	{
		/** 顶点缓冲区。		 */
		private var vBuffer:VertexBuffer2D;
		/** 片元缓冲区。		 */
		private var iBuffer:IndexBuffer2D;
		private var vbData:Float32Array;
		private var ibData:Uint16Array;
		private var iNum:int = 0;
		/** 着色器变量。		 */
		private var shaderValue:myShaderValue;
		
		public function myShaderSprite()
		{
			//shaderValue = new myShaderValue();
		}
		
		/**
		 * 初始化此类。
		 * @param	texture 纹理对象。
		 * @param	vb 顶点数组。
		 * @param	ib 顶点索引数组。
		 */
		public function init(texture:Texture, vb:Array = null, ib:Array = null):void
		{
			vBuffer = VertexBuffer2D.create();
			iBuffer = IndexBuffer2D.create();
			
			ibData = new Uint16Array();
			var vbArray:Array;
			var ibArray:Array;
			
			if (vb)
			{
				vbArray = vb;
			}
			else
			{
				vbArray = [];
				var texWidth:Number = texture.width;
				var texHeight:Number = texture.height;
				
				//定义颜色值，取值范围0~1 浮点。
				var red:Number = 1;
				var greed:Number = 1;
				var blue:Number = 1;
				var alpha:Number = 1;
				
				//在顶点数组中放入4个顶点
				//每个顶点的数据：(坐标X,坐标Y,u,v,R,G,B,A)				
				vbArray.push(0, 0, 0, 0, red, greed, blue, alpha);
				vbArray.push(texWidth, 0, 1, 0, red, greed, blue, alpha);
				vbArray.push(texWidth, texHeight, 1, 1, red, greed, blue, alpha);
				vbArray.push(0, texHeight, 0, 1, red, greed, blue, alpha);
			}
			
			if (ib)
			{
				ibArray = ib;
			}
			else
			{
				ibArray = [];
				//在顶点索引数组中放入组成三角形的顶点索引。
				//三角形的顶点索引对应顶点数组vbArray 里的点索引，索引从0开始。
				ibArray.push(0, 1, 3);//第一个三角形的顶点索引。
				ibArray.push(1,2,3);
					//ibArray.push(3, 1, 2);//第二个三角形的顶点索引。			
			}
			iNum = ibArray.length;
			
			vbData = new Float32Array(vbArray);
			ibData = new Uint16Array(ibArray);
			
			
			vBuffer.append(vbData);
			iBuffer.append(ibData);
			
			//shaderValue = new myShaderValue();
			shaderValue.textureHost = texture;
			this._renderType |= RenderSprite.CUSTOM;//设置当前显示对象的渲染模式为自定义渲染模式。	
//			Laya.timer.frameLoop(1, this, timeTick);
		}
		
		private function timeTick():void
		{
			shaderValue.u_time += Laya.timer.delta;
		}
		
		private var loopUTime:Number = 0;
		
		public function update():void
		{
			shaderValue.u_time += GameConst.fixed_update_time;//Laya.timer.delta / 1000;
			if(shaderValue.u_time > loopUTime)
			{
				shaderValue.u_time -= loopUTime;
			}
		}
		
		public function setRange(range:*):void
		{
			shaderValue.range = range;
		}
		
		public function setTime(time:*):void
		{
			shaderValue.u_time = time;
		}
		
		public function setXrate(rate:*):void
		{
			shaderValue.xrate = rate;
			loopUTime = 2 * Math.PI / shaderValue.xrate;
		}
		
		public function setYrate(rate:*):void
		{
			shaderValue.yrate = rate;
		}
		
		//弧度
		public function setSinOff(off:*):void
		{
			shaderValue.sin_off = off;
		}
		
//		override public function loadImage(url:String, x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0, complete:Handler = null):Sprite 
//		{
//			var texture:Texture = Loader.getRes(url);
//			init(texture);
//			return this;
//		}
		//重写渲染函数。
//		override public function customRender(context:RenderContext, x:Number, y:Number):void
//		{
//			(context.ctx as WebGLContext2D).setIBVB(x, y, iBuffer, vBuffer, iNum, null, myShader.shader, shaderValue, 0, 0);
//		}
	}
}