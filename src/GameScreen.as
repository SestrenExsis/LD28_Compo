package
{
	import org.flixel.*;
	import flash.display.StageQuality;
	import flash.utils.getTimer;
	
	public class GameScreen extends FlxState
	{
		[Embed(source="../assets/images/capsized.png")] public var imgSprites:Class;
		
		[Embed(source="assets/sounds/death01.mp3")] public static var sndDeath:Class;
		[Embed(source="assets/sounds/row01.mp3")] public static var sndRow:Class;
		[Embed(source="assets/sounds/shark01.mp3")] public static var sndShark:Class;

		private var shark:FlxSprite;
		private var boat:FlxSprite;
		private var dock:FlxSprite;
		
		private var timestamp:uint = 0;
		
		private var oarsOnLeft:Boolean = false;
		private var boatSpeed:Number = 25;
		
		private var paused:Boolean = false;
		
		private var displayText:FlxText;
		
		public function GameScreen()
		{
			super();
			FlxG.stage.quality = StageQuality.LOW;
		}
		
		override public function create():void
		{
			FlxG.bgColor = 0xff505cc0;
			
			displayText = new FlxText(0, 32, FlxG.width, "");
			shark = new FlxSprite(0, FlxG.height - 8);
			shark.loadGraphic(imgSprites, true, true, 8, 8);
			shark.addAnimation("shark",[1]);
			shark.play("shark");
			shark.velocity.x = 25;
			shark.velocity.y = 0;
			FlxG.play(sndShark);
			boat = new FlxSprite(0.5 * FlxG.width - 8, FlxG.height - 16);
			boat.loadGraphic(imgSprites, true, true, 16, 16);
			boat.addAnimation("boat_0",[10]);
			boat.addAnimation("boat_1",[11]);
			boat.addAnimation("boat_2",[12]);
			boat.addAnimation("boat_3",[13]);
			boat.addAnimation("boat_4",[14]);
			boat.addAnimation("boat_5",[15]);
			boat.addAnimation("boat_6",[16]);
			boat.addAnimation("boat_7",[17]);
			boat.play("boat_0");
			dock = new FlxSprite(0.5 * FlxG.width - 8, 0);
			dock.loadGraphic(imgSprites, true, true, 16, 16);
			dock.addAnimation("dock",[2]);
			dock.play("dock");
			
			add(shark);
			add(boat);
			add(dock);
			add(displayText);

			displayText.text = "You lost your second oar!\nMake it to the dock!\nAvoid the shark!\n Use arrow keys to switch sides and paddle!";
		}
		
		override public function update():void
		{
			super.update();
			
			if ((getTimer() > 9000 + timestamp) && !paused) displayText.text = "";
			if (!paused)
			{
				if (FlxG.keys.justPressed("LEFT")) switchOarsToLeft();
				else if (FlxG.keys.justPressed("RIGHT")) switchOarsToRight();
				
				if (FlxG.keys.justPressed("UP")) rowForward();
				else if (FlxG.keys.justPressed("DOWN")) rowBackward();
				
				FlxG.overlap(shark, boat, gameOver);
				FlxG.overlap(boat, dock, youWin);
				
				if (boat.x < 0) boat.x = 0;
				else if (boat.x + boat.width > FlxG.width) boat.x = FlxG.width - boat.width;
				
				if (boat.y < 0) boat.y = 0;
				else if (boat.y + boat.height > FlxG.height) boat.y = FlxG.height - boat.height;
				
				if (shark.x < 0) 
				{
					FlxG.play(sndShark);
					shark.x = 0;
					shark.y = (int)(FlxG.random() * 48 + boat.y - 32);
					shark.velocity.x = 25;
					shark.velocity.y = 0;
				}
				else if (shark.x + shark.width > FlxG.width) 
				{
					FlxG.play(sndShark);
					shark.x = FlxG.width - shark.width;
					shark.y = (int)(FlxG.random() * 48 + boat.y - 32);
					shark.velocity.x = -25;
					shark.velocity.y = 0;
				}
			}
			else if (FlxG.mouse.justPressed())
			{
				restartGame();
			}
		}
		
		public function restartGame():void
		{
			timestamp = getTimer();
			paused = false;
			displayText.text = "Up to row forward\nDown to row backward\nLeft and right to switch sides";
			shark.reset(0, FlxG.height - 8);
			shark.velocity.x = 25;
			shark.velocity.y = 0;
			FlxG.play(sndShark);
			boat.reset(0.5 * FlxG.width - 8, FlxG.height - 16);
			boat.angle = 0;
		}
		
		public function gameOver(Obj1:FlxObject, Obj2:FlxObject):void
		{
			FlxG.play(sndDeath);
			displayText.text = "The shark ate you!\n\nClick screen to retry.";
			boat.kill();
			paused = true;
		}
		
		public function youWin(Obj1:FlxObject, Obj2:FlxObject):void
		{
			displayText.text = "You made it to the dock safely!\n\nClick screen to play again.";
			shark.kill();
			paused = true;
		}
		
		public function switchOarsToLeft():void
		{
			oarsOnLeft = true;
		}
		
		public function switchOarsToRight():void
		{
			oarsOnLeft = false;
		}
		
		public function rowForward():void
		{
			FlxG.play(sndRow);
			var _ang:Number = (Math.PI / 180) * (boat.angle - 90);
			boat.velocity.x = boatSpeed * Math.cos(_ang);
			boat.velocity.y = boatSpeed * Math.sin(_ang);
			if (oarsOnLeft)
			{
				boat.angularVelocity = -100;
			}
			else
			{
				boat.angularVelocity = 100;
			}
			boat.drag.x = boat.drag.y = 100;
			boat.angularDrag = 200;
		}
		
		public function rowBackward():void
		{
			FlxG.play(sndRow);
			var _ang:Number = (Math.PI / 180) * (boat.angle - 90);
			boat.velocity.x = -boatSpeed * Math.cos(_ang);
			boat.velocity.y = -boatSpeed * Math.sin(_ang);
			if (oarsOnLeft)
			{
				boat.angularVelocity = 100;
			}
			else
			{
				boat.angularVelocity = -100;
			}
			boat.drag.x = boat.drag.y = 100;
			boat.angularDrag = 200;
		}
		
		override public function draw():void
		{
			super.draw();
		}
	}
}