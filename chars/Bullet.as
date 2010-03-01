package chars
{
	import org.flixel.FlxCore;
	import org.flixel.FlxSprite;

	public class Bullet extends FlxSprite
	{
		[Embed(source = "../assets/bullet_sprite.png")] private var ImgBullet:Class;
		
		public function Bullet()
		{
			super();
			width = 12;
			height = 9;
			exists = false;
			
			loadGraphic(ImgBullet,true, true, 12, 9);
			addAnimation("travel", [0,1], 12);
			addAnimation("poof", [2,3], 10, false);
			
		}
		
		override public function  update():void{
			if(dead && finished) exists = false;
			else super.update();
		}
		
		override public function hitWall(Contact:FlxCore = null):Boolean{
			hurt(0);
			return true;
		}
		override public function hitCeiling(Contact:FlxCore = null):Boolean{
			hurt(0);
			return true;
		}
		override public function hitFloor(Contact:FlxCore = null):Boolean{
			hurt(0);
			return true;
		}
		
		override public function hurt(Damage:Number):void{
			if(dead) return;
			velocity.x = 0;
			velocity.y = 0;
			//if(onScreen())
			dead = true;
			play("poof");
		}
		
		public function shoot(X:int, Y:int, VelocityX:int, VelocityY:int):void{
			super.reset(X, Y);
			velocity.x = VelocityX;
			velocity.y = VelocityY;
			
		}
		
	}
}