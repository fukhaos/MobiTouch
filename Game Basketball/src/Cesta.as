package {
	import starling.display.Image;
	import starling.display.Sprite;

	public class Cesta extends Sprite {
		[Embed(source = "images/cesta.fw.png")]
		private var img:Class;

		public function Cesta () {
			addChild(Image.fromBitmap(new img()));
		}
	}
}
