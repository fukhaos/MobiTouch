package {
	import starling.display.Image;
	import starling.display.Sprite;

	public class Traco extends Sprite {
		[Embed(source = "images/traco.png")]
		private var img:Class;

		public function Traco () {
			addChild(Image.fromBitmap(new img()));
		}
	}
}
