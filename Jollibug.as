package{
	import org.flixel.FlxGame;
	import states.PlayState;
	import states.GameOver;
	import states.MenuState;
	
	[SWF(width="640", height="480", backgroundColor="#FFFFFF")]
	public class Jollibug extends FlxGame{
		public function Jollibug():void{
			super(320, 240, MenuState, 2);
			this.showLogo = false;			
		}
	}
}