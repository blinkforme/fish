package view.fish
{
	import laya.display.Sprite;

	public class BatteryImgAction extends Sprite
	{
		private static var _born:Array = [[-1,0],[-2,0],[1,0],[2,0]];
		private static var _stand:Array = [[-0.5,0],[-0.5,0],[-0.5,0],[0.5,0],[0.5,0],[0.5,0]];
		private static var _attack:Array = [[-5,0],[-10,0],[5,0],[10,0]];
		private var _playIndex:Number = 0;
		private var _playName:String = "";
		private var _runTime:Number = 0;
		private var _frameInterval:Number = 80;
		public function BatteryImgAction()
		{
			this.pivotX = 50;
			this.pivotY = 90;
		}
		
		public function play(name:String, loop:Boolean = true):void
		{
			_playName = name;
			_playIndex = 0;
			_runTime = 0;
		}
		
		public function isPlaying():Boolean
		{
			if(_playName == "born")
			{
				return _playIndex < _born.length;
			}
			else if(_playName == "attack")
			{
				return _playIndex < _attack.length;
			}
			return true;
		}
		
		public function update():void
		{
			_runTime = _runTime + Laya.timer.delta;
			if(_runTime >= _frameInterval)
			{
				if(_playName == "born")
				{
					if(_playIndex < _born.length)
					{
						this.pos(_born[_playIndex][0], _born[_playIndex][1]);
					}
				}
				else if(_playName == "stand")
				{
					if(_playIndex >= _stand.length)
					{
						_playIndex = 0;
					}
					if(_playIndex < _stand.length)
					{
						this.pos(_stand[_playIndex][0], _stand[_playIndex][1]);
					}
				}
				else if(_playName == "attack")
				{
					if(_playIndex < _attack.length)
					{
						this.pos(_attack[_playIndex][0], _attack[_playIndex][1]);
					}
				}
				_runTime -= _frameInterval;
				_playIndex++;
			}
		}
		
	}
}