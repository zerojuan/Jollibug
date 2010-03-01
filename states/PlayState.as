package states
{
	import chars.Bullet;
	import chars.Enemy;
	import chars.People;
	import chars.Player;
	
	import flash.geom.Point;
	
	import org.flixel.FlxBlock;
	import org.flixel.FlxG;
	import org.flixel.FlxLayer;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;

	public class PlayState extends FlxState
	{
		[Embed(source = "../assets/grass.png")] private var ImgGrass:Class;
		[Embed(source = "../assets/skyblue.png")] private var ImgBg:Class;
		[Embed(source = "../assets/gold_3.png")] private var ImgCoin:Class;
		[Embed(source = "../assets/gold_1.png")] private var ImgHp:Class;
		[Embed(source = "../assets/hills.png")] private var ImgHills:Class;
		[Embed(source = "../assets/far_hills.png")] private var ImgFarHills:Class;
		
		private var _player:Player;
		
		private var _blocks:Array;	
		private var _bullets:Array;
		private var _hps:Array;
		
		private var _enemies:Array;
		private var _peoples:Array;
		
		private var _enemyWatcher:int = 0;
		
		private var _bgLayer:FlxLayer;
		private var _midLayer:FlxLayer;
		private var _hudLayer:FlxLayer;
		
		private var _scoreText:FlxText;
		private var _miscText:FlxText;
					
		
		public function PlayState():void{
			this.add(new FlxText(50,50, 300, "This is a text"));
			
			FlxG.hiddenScore = 0;			
			
			_bullets = new Array();
			_blocks = new Array();
			_enemies = new Array();
			_peoples = new Array();
			_hps = new Array();
			
			_bgLayer = new FlxLayer();
			_midLayer = new FlxLayer();
			_hudLayer = new FlxLayer();
			
			var bg:FlxSprite = new FlxSprite(-100,0);
			bg.loadGraphic(ImgBg, false);
			bg.scrollFactor.x = 0;
			bg.scrollFactor.y = 0;
			_bgLayer.add(bg);
			
			
			var farHills:FlxSprite = new FlxSprite(0,0,ImgFarHills);
			farHills.x = 0;
			farHills.y = -20;
			farHills.scrollFactor.x = .1;
			farHills.scrollFactor.y = .3;
			_bgLayer.add(farHills);
			
			var hills:FlxSprite = new FlxSprite(0,0, ImgHills);
			hills.x = -200;
			hills.y = 20;
			hills.scrollFactor.x = .2;
			hills.scrollFactor.y = .5;
			_bgLayer.add(hills);
			
			
			
			
			
			this.add(_bgLayer);
			this.add(_midLayer);
			for(var i:int = 0; i < 10; i++){
				_bullets.push(this.add(new Bullet()));
			}
			
			
			
			_player = new Player(40,40,_bullets);
			for(i = 0; i < 10; i++){
				_peoples.push(_midLayer.add(new People(Math.random()*350, 280, _player)));
			}
			
			for(i = 0; i < 3; i++){
				_enemies.push(this.add(new Enemy(100,Math.random()*200, FlxSprite.RIGHT,_bullets)));
			}
			
			
			
			
			this.add(_player);
			
			FlxG.follow(_player);
			
			//FlxG.followAdjust(5,5);
			FlxG.followBounds(-100,-1000, 360+100, 300+13);
			FlxG.followLead = new Point(0,.5);
			//FlxG.followMin.y = -1000;
			var b:FlxBlock;
			
			b = new FlxBlock(0,300, 360, 13); 
			b.loadGraphic(ImgGrass);
			_blocks.push(this.add(b));
			
			_hudLayer.scrollFactor.x = 0;
			_hudLayer.scrollFactor.y = 0;
			
			for(i = 0; i < 5; i++){
				var gem:FlxSprite = new FlxSprite(230+(i*16), 3);
				gem.loadGraphic(ImgHp,false, false, 15,16);
				gem.addAnimation("idle", [4,3], 20);
				gem.play("idle");
				_hps.push(gem);
				_hudLayer.add(gem,true);
			}
			
		
			_scoreText = new FlxText(25,0,200, "0");
			_scoreText.scrollFactor.x = 0;
			_scoreText.scrollFactor.y = 0;
			_scoreText.color = 0xFF0000;
			_scoreText.size = 15;
			var coin:FlxSprite = new FlxSprite(10,7);
			coin.loadGraphic(ImgCoin, true, false, 8,8);
			coin.addAnimation("idle",[0,1,2,3], 3);
			coin.play("idle");
			coin.scale.x = 2;
			coin.scale.y = 2;
			coin.scrollFactor.x = 0;
			coin.scrollFactor.y = 0;
			
			_hudLayer.add(_scoreText);
			_hudLayer.add(coin);
			this.add(_hudLayer);
		}
		
		override public function update():void{
			super.update();
			
			//collision detection
			FlxG.collideArray(_blocks, _player);
			FlxG.collideArrays(_blocks, _peoples);
			
			
			FlxG.overlapArrays(_bullets, _enemies, bulletHitEnemy); 
			FlxG.overlapArray(_peoples, _player, peoplesHitPlayer);
			FlxG.overlapArray(_enemies, _player, enemyHitPlayer);
			
			_scoreText.text = FlxG.score+"!";		
			for(var i:int = 0; i < 5; i++){
				var hp:int = Math.floor(_player.health);
				if(i < hp){
					_hps[i].visible = true;
				}else{
					_hps[i].visible = false;
				}
			}
			
		}
		
		private function bulletHitEnemy(Bullet:FlxSprite,Bot:FlxSprite):void
		{
			Bullet.hurt(0);
			Bot.hurt(1);
		}
		
		private function peoplesHitPlayer(Peoples:FlxSprite, Player:FlxSprite ):void{
			Peoples.hurt(1);
			
		}
		
		private function enemyHitPlayer(Enemy:FlxSprite, Player:FlxSprite):void{
			if(!Player.flickering()){
				Player.hurt(1);
				//FlxG.quake(.05,0.5);
			}
			
		}
	}
}