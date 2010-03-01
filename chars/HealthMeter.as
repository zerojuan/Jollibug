package chars
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;

	public class HealthMeter extends FlxSprite	
	{
		
		public function HealthMeter(X:int, Y:int)
		{
			super(X,Y);			
		}
		
		override public function update():void{
			
			width = FlxG.score * 3;
			super.update();
		}
	}
}