package {
	import flash.display.Sprite;
	import starling.core.Starling;

	[SWF(frameRate = 60, width = 1024, height = 768, backgroundColor = 0x000000)]
	public class StarlingNape extends Sprite {
		public function StarlingNape () {

			Starling.handleLostContext = false;

			var star:Starling = new Starling(Main, stage);
			star.start();
		}
	}
}
