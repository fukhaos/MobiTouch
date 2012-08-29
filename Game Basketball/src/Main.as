package {
	import flash.geom.Point;

	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.space.Space;

	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.utils.deg2rad;

	public class Main extends Sprite {
		[Embed(source = "images/back.png")]
		private var back:Class;

		[Embed(source = "images/botao.png")]
		private var botao:Class;

		private var space:Space;
		private var box:Body;
		private var ball:Body;
		private var tx:Number;
		private var ty:Number;
		private var traco:Traco;
		private var forcaX:Number;
		private var forcaY:Number;

		private var arrBolas:Array;

		public function Main () {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init (event:Event):void {
			//adiciona o background
			addChild(Image.fromBitmap(new back()));

			//cria o espaco fisico
			space = new Space(new Vec2(0, 3000));

			//cria o chão e as paredes
			var floor:Body = new Body(BodyType.STATIC);
			floor.shapes.add(new Polygon(Polygon.rect(0, 768, 1024, 20)));
			floor.shapes.add(new Polygon(Polygon.rect(1024, -5000, 200, 5768)));
			//floor.shapes.add(new Polygon(Polygon.rect(0, -20, 1024, 20)));     removido teto 
			floor.shapes.add(new Polygon(Polygon.rect(-200, -5000, 200, 5768)));
			floor.space = space;

			//adiciono o loop e evento de toque
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(TouchEvent.TOUCH, onTouch)


			//cria imagem da cesta	
			var cesta:Cesta = new Cesta()
			cesta.y = 100;
			addChild(cesta);

			//cria bordas da cesta 
			addBordas()

			//array de bolas
			arrBolas = new Array()

			//crio um botao	
			var bt:Button = new Button(Texture.fromBitmap(new botao));
			bt.x = 910;
			bt.y = 10;
			bt.addEventListener(Event.TRIGGERED, removeBolas)
			addChild(bt);
		}


		private function addBordas ():void {
			var base:Body = new Body(BodyType.STATIC);
			base.shapes.add(new Polygon(Polygon.rect(0, 220, 55, 20)))
			base.shapes.add(new Polygon(Polygon.rect(185, 220, 10, 20)))
			base.space = space;
		}

		private function onTouch (e:TouchEvent):void {
			var touch:Touch = e.getTouch(stage);

			if (touch.phase == TouchPhase.BEGAN) {
				traco = new Traco();
				traco.height = 0;
				traco.x = touch.globalX;
				traco.y = touch.globalY;
				addChild(traco);
				
				//zerar forcas
				forcaX = forcaY = 0;
				//adicionar um bola
				addBall(touch.globalX, touch.globalY);
				
			} else if (touch.phase == TouchPhase.MOVED) {
				var pontoA:Point = new Point(ball.position.x, ball.position.y);
				var pontoB:Point = new Point(touch.globalX, touch.globalY);

				var anglo:Number = findAngle(pontoA, pontoB);
				traco.rotation = deg2rad(anglo + 180);
				traco.height = distanceTwoPoints(pontoA, pontoB);

				forcaX = ball.position.x - touch.globalX;
				forcaY = ball.position.y - touch.globalY;

			} else if (touch.phase == TouchPhase.ENDED) {
				removeChild(traco);
				//lanço a bola
				ball.allowMovement = true;
				ball.applyLocalImpulse(new Vec2(70 * forcaX, 70 * forcaY));
			}
		}

		private function findAngle (point1:Point, point2:Point):Number {
			//matematica pura (trigonometria)
			var dx:Number = point2.x - point1.x;
			var dy:Number = point2.y - point1.y;
			return -Math.atan2(dx, dy) * (180 / Math.PI);
		}

		private function distanceTwoPoints (point1:Point, point2:Point):Number {
			//pitagoras
			var dx:Number = point1.x - point2.x;
			var dy:Number = point1.y - point2.y;
			return Math.sqrt(dx * dx + dy * dy);
		}

		private function onEnterFrame (event:Event):void {
			//atualiza o espaco
			space.step(1 / 60);
		}

		private function addBall (posx:Number, posy:Number):void {
			ball = new Body(BodyType.DYNAMIC, new Vec2(posx, posy));
			ball.shapes.add((new Circle(51.5, null, new Material(1.5))));
			ball.space = space;
			ball.allowMovement = false;
			ball.graphic = new Basketball();
			ball.graphicUpdate = updateGraphics;
			addChildAt(ball.graphic, 1);

			arrBolas.push(ball);
		}

		private function updateGraphics (b:Body):void {
			b.graphic.x = b.position.x;
			b.graphic.y = b.position.y;
			b.graphic.rotation = b.rotation;
		}

		private function removeBolas (e:Event):void {
			for each (var b:Body in arrBolas) {
				this.removeChild(b.graphic);
				space.bodies.remove(b);
			}

		}
	}
}
