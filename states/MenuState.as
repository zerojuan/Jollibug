package states
{
	import org.flixel.FlxG;
	import org.flixel.FlxLayer;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;

	public class MenuState extends FlxState
	{
		[Embed(source="../assets/menu-cover.png")] private var ImgCover:Class;
		
		private var _bgLayer:FlxLayer;
		
		public function MenuState():void{
			_bgLayer = new FlxLayer();
			
			var bg:FlxSprite = new FlxSprite(0,0, ImgCover);
			_bgLayer.add(bg);
								
			this.add(_bgLayer);
			
			var text:FlxText = new FlxText(100,200,200, "Press Z+X to adventure!");
			this.add(text);
		}
		
		override public function update():void{
			super.update();
			
			if(FlxG.keys.Z && FlxG.keys.X){
				FlxG.flash(0xff000000, 1, goPlay);
				
			}
		}
		
		public function goPlay():void{
			FlxG.switchState(PlayState);
		}
	}
}