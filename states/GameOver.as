package states
{
	import org.flixel.FlxG;
	import org.flixel.FlxLayer;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class GameOver extends FlxState
	{
		[Embed(source = "../assets/jolijeep_sprite.png")] private var ImgEnemy:Class;
		[Embed(source = "../assets/bg.png")] private var ImgBg:Class;
		
		
		private var _bgLayer:FlxLayer;
		
		private var enemy:FlxSprite;
		
		private var score:FlxText;
		private var tryAgain:FlxText; 
		private var message:FlxText;
		
		public function GameOver()
		{
			_bgLayer = new FlxLayer();
			var bg:FlxSprite = new FlxSprite(0,0);
			bg.loadGraphic(ImgBg, false);
			_bgLayer.add(bg);
			bg.scale.x = 2;
			bg.scale.y = 2;
			this.add(_bgLayer);
			
			enemy = new FlxSprite(100,100);
			enemy.loadGraphic(ImgEnemy,true, false, 40,36);
			enemy.addAnimation("play", [0,1], 20);
			enemy.play("play");
			
			score = new FlxText(150,100,200);
			score.text = "x " + FlxG.hiddenScore;
			score.size = 25;
			score.color = 0xFF0000;
			
			message = new FlxText(75, 20, 250, "Congratulations! You are a gifted!");
			
			if(FlxG.hiddenScore < 4){
				message.text = "Zomg! You were decept. You should not..";
				message.x -= 15;
			}else if(FlxG.hiddenScore >= 4 && FlxG.hiddenScore < 10){
				message.text = "Oh yeah you are a gift to me. Hero is the taste!";
				message.x -= 35;
			}else{
				message.text = "WTF! You really like to eat there do you!";
				message.x -= 15;
			}
			
			
			tryAgain = new FlxText(200, 200, 200);
			tryAgain.text ="Try again! Press Z";
			tryAgain.flicker(20);
			tryAgain.color = 0x00000;
			this.add(message);
			this.add(tryAgain);
			this.add(score);
			this.add(enemy);
		}
		
		override public function update():void{
			super.update();
			if(FlxG.keys.Z){
				FlxG.switchState(MenuState);
			}
		}
	}
}