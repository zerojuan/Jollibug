package chars
{
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;

	public class Enemy extends FlxSprite{
		[Embed(source = "../assets/jolijeep_sprite.png")] private var ImgEnemy:Class;
		[Embed(source = "../assets/bullet.png")] private var ImgBullet:Class;
		[Embed(source = "../assets/BigHit.mp3")] private var SndHit:Class;
		private var _bodyParts:FlxEmitter;
		private var _bullets:Array;		
		private var _frameRate:int = 3;
		
		private var _accel:int;
		private var ACCEL_CONST:int = 100;
		
		public var respawnTimer:Number = 1;
		
		public function Enemy(xPos:int, yPos:int, Facing:uint, Bullets:Array){
			super(xPos, yPos);
			
			width = 12;
			height = 12;
			offset.x = 2;
			offset.y = 2;
			velocity.x = 0;
			velocity.y = 0;
			
			facing = Facing;
			if(facing == RIGHT){			
				_accel = 200;
			}else{				
				_accel = -200;
			}
			velocity.x = _accel;
			
			loadGraphic(ImgEnemy, true, true, 40, 36, false);
			scale.x = 1.5;
			scale.y = 1.5;
			_bullets = Bullets;
			
			addAnimation("idle", [0,1], _frameRate);
			
			
			_bodyParts = new FlxEmitter(0,0,-1.5);
			_bodyParts.setXVelocity(-150,150);
			_bodyParts.setYVelocity(-200,0);
			_bodyParts.setRotation(-720,-720);
			_bodyParts.createSprites(ImgBullet,20);
			FlxG.state.add(_bodyParts);
			play("idle");
			//reset(x,y);
		}
		
		override public function update():void{
			if(dead){
				if(finished){
					//exists = false;
					visible = false;
				}else{
					super.update();
				}
				respawnTimer -= FlxG.elapsed;				
				if(respawnTimer <= 0){					
					velocity.x = _accel;
					reset(x,y);
					respawnTimer = 1;
				}
				return;
			}
			
			acceleration.x = _accel;
			if(acceleration.x > 0 && x > 460){
				reverse();
			}else if(acceleration.x < 0 && x < (-100 - width)){
				reverse();
			}
			super.update();
		}
		
		override public function hurt(Damage:Number):void{
			flicker(0.2);
			super.hurt(Damage);
		}
		
		override public function kill():void{
			if(dead)
				return;
			super.kill();
			exists = true;
			flicker(-1);
			play("idle");
			FlxG.play(SndHit);
			_bodyParts.x = x + width/2;
			_bodyParts.y = y + height/2;
			_bodyParts.restart();
			
			FlxG.hiddenScore += 1; 
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