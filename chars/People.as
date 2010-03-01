package chars
{
	import org.flixel.FlxEmitter;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;

	public class People extends FlxSprite
	{
		[Embed(source = "../assets/people_sprite.png")] private var ImgPeople:Class;
		[Embed(source = "../assets/gold_3.png")] private var ImgCoin:Class;
		[Embed(source="../assets/bling.mp3")] private var SndMode:Class;
		
		private var _player:Player;
		
		private var _coins:FlxEmitter;
		
		private var _accel:int;
		private var ACCEL_CONST:int = 20;
		
		private var _timeSinceEmit:Number = 1;
		
		private var _hp:int = 10;
		
		public function People(X:int, Y:int, ThePlayer:Player):void{
			super(X,Y);
			_player = ThePlayer;
			
			
			
			acceleration.y = 250;
			loadGraphic(ImgPeople, true, true, 36,36);
			
			_coins = new FlxEmitter(0,0,-1.5);
			_coins.setXVelocity(-150,150);
			_coins.setYVelocity(-20,-300);
			_coins.createSprites(ImgCoin, 5);
			FlxG.state.add(_coins);
			
			addAnimation("idle", [0,1,2], Math.random()*10);
			addAnimation("no_money", [0]);
			play("idle");
			
			
		}
		
		override public function update():void{			
			super.update();
			if(!onScreen() && _hp <= 0 && _player.y < 250){
				_hp = 10;				
			}
			
			if(_hp <= 0){
				play("no_money");
			}else{
				play("idle");
			}
		}				
		
		override public function reset(X:Number, Y:Number):void{
			var face:uint = facing;
			super.reset(x,y);
			if(face == RIGHT){
				x = -100-width;
				y = (Math.random()*200)+50;
			}else{
				x = 460;
				y = (Math.random()*200)+50;
			}
		}
		
		override public function hurt(Damage:Number):void{
			
			_hp -= Damage;
			if(_hp > 0){
				
				FlxG.score += 10;
				_coins.x = x + width/2;
				_coins.y = y + height/2;
				_coins.restart();
				
			}
		}
		
		public function reverse():void{			
			if(facing == RIGHT){
				facing = LEFT;
				_accel = -ACCEL_CONST;
				velocity.x = 0;
			}else{
				facing = RIGHT;
				_accel = ACCEL_CONST;
				velocity.x = 0;
			}
		}
	}
}