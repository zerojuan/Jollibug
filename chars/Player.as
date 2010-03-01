package chars
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	import states.GameOver;

	public class Player extends FlxSprite
	{
		[Embed(source = "../assets/jollibee.png")] private var ImgJolli:Class;
		[Embed(source = "../assets/AlienCollected4.mp3")] private var SndShoot:Class;
		
		
		private var _jumpPower:int;
		private var _frameRate:int = 5;
		private var _bullets:Array;
		private var _curBullet:int;
		private var _cooldown:Number = .1;
		private var _elapsedSinceFired:Number = 0;
		private var _hasShot:Boolean;
		private var _timeUnderground:Number = 0;
				
		
		public function Player(X:int, Y:int, Bullets:Array):void{
			super(X,Y);
			_bullets = Bullets;
			
			//basic player physics
			var runSpeed:uint = 80;
			drag.x = runSpeed*8;
			acceleration.y = 420;
			_jumpPower = 200;
			maxVelocity.x = runSpeed;
			maxVelocity.y = _jumpPower;
			
			health = 5;
			
			loadGraphic(ImgJolli, true, true, 36,36, true);
			addAnimation("idle", [0,2], _frameRate);
			addAnimation("run", [0,1,2,1], _frameRate);
			addAnimation("hit", [3, 4], _frameRate);			
			addAnimation("hurt", [5,6], _frameRate);
			addAnimation("jump", [7, 8], _frameRate);
			
			play("idle");
		}
		
		override public function update():void{			
			if(dead){
				FlxG.fade(0xff000000, 1, switchState);				
			}else{
				if(!flickering())
					getInput();
			}
			if(flickering()){
				play("hurt");
				
				health -= FlxG.elapsed;
			}else if(_hasShot){
				play("hit");
			}else{
				if(velocity.y != 0){
					play("jump");
				}else if(velocity.x != 0){
					play("run");
				}else{
					play("idle");
				}
			}
			//FlxG.log(health);
			
			if(!flickering()){
				if(Math.floor(health) <= 0){
					die();
				}
			}
			
			if(this.y > 0 && !onScreen()){
				//FlxG.flash(0x000000, 1, function():void{dead = true;});
				_timeUnderground += FlxG.elapsed;				
			}else{
				_timeUnderground = 0;
			}
			FlxG.log(_timeUnderground);
			if(_timeUnderground > 1){
				die();
			}
			
			
			super.update();
		}
		
		private function switchState():void{
			FlxG.switchState(GameOver);
		}
		
		private function die():void{
			dead = true;
		}
		
		private function getInput():void{
			//MOVEMENT
			acceleration.x = 0;
			
			if(FlxG.keys.LEFT){
				facing = LEFT;
				acceleration.x -= drag.x;
				_hasShot = false;
			}
			else if(FlxG.keys.RIGHT)
			{
				facing = RIGHT;
				acceleration.x += drag.x;
				_hasShot = false;
			}
			if(FlxG.keys.UP){
				velocity.y = -900;
				_hasShot = false;
			}
			
			if(FlxG.keys.X){
				if(_elapsedSinceFired<=0){
					var bYVel:int = 0;
					var bXVel:int = 300;
					var bX:int = x+(width/2);
					var bY:int = y+(height/2);
					
					if(facing == RIGHT){
						bXVel = -300;		
						bX -= 30;
					}else{
						bXVel = 300;
						bX += 20;
					}
					_bullets[_curBullet].shoot(bX,bY,bXVel,bYVel);
					if(++_curBullet >= _bullets.length)
						_curBullet = 0;
					_hasShot = true;
					_elapsedSinceFired = _cooldown;	
					FlxG.play(SndShoot);
				}
			}			
			_elapsedSinceFired -= FlxG.elapsed;
		}
		
		override public function hurt(Damage:Number):void{
			flicker(1);
		//	health -= Damage;
			velocity.y = 30;			
		}
	}
}