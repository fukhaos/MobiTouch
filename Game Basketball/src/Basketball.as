package {
	import starling.display.Image;
	import starling.display.Sprite;

	public class Basketball extends Sprite {
		[Embed(source = "images/basketball.png")]
		private var img:Class;

		public function Basketball () {
			addChild(Image.fromBitmap(new img()));
			this.pivotX = this.width >> 1 //this.width / -2 ;
			this.pivotY = this.height >> 1;
		}
	}
}
