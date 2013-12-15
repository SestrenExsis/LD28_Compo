package
{
	import org.flixel.FlxGame;
	[SWF(width="576", height="480", backgroundColor="#000000")]
	
	public class LD28_Compo extends FlxGame
	{
		public function LD28_Compo()
		{
			super(192, 160, GameScreen, 3, 60, 60, true);
			forceDebugger = true;
		}
	}
}