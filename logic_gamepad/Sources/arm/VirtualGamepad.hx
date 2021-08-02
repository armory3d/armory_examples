package arm;

import iron.Trait;
import iron.math.Vec2;
import iron.system.Input;

using kha.graphics2.GraphicsExtension;

@:access(iron.system.Gamepad)
class VirtualGamepad extends Trait {
	
	@prop public var gamepad : Int = 0;
	@prop public var radius : Int = 100;
	@prop public var offset : Int = 45;
	@prop public var sizeRatio : Float = 2.2;

	public var colorA : kha.Color = 0xff888888;
	public var colorB : kha.Color = 0xffcf2b43;
	
	var leftPadX = 0;
	var leftPadY = 0;
	var rightPadX = 0;
	var rightPadY = 0;
	var leftStickX = 0;
	var leftStickY = 0;
	var rightStickX = 0;
	var rightStickY = 0;
	// var leftStickXLast = 0;
	// var leftStickYLast = 0;
	// var rightStickXLast = 0;
	// var rightStickYLast = 0;
	var leftLocked = false;
	var rightLocked = false;
	var gamepad_ : Gamepad;

	public function new() {
		super();
		notifyOnInit(function() {
			gamepad_ = Input.getGamepad( gamepad );
			notifyOnUpdate(update);
			notifyOnRender2D(render2D);
		});
	}

	function update() {

		var r = radius;
		var o = offset;

		leftPadX = r + o;
		rightPadX = iron.App.w() - r - o;
		leftPadY = rightPadY = iron.App.h() - r - o;

		final mouse = Input.getMouse();
		if (mouse.started() ) {
			leftLocked = Vec2.distancef(mouse.x, mouse.y, leftPadX, leftPadY) <= r;
		} else if (mouse.released()) {
			leftLocked = false;
		}
		if (leftLocked) {
			leftStickX = Std.int(mouse.x - leftPadX);
			leftStickY = Std.int(mouse.y - leftPadY);
			if (Math.sqrt(leftStickX * leftStickX + leftStickY * leftStickY) > r) {
				leftStickX = Std.int(r * (leftStickX / Math.sqrt(leftStickX * leftStickX + leftStickY * leftStickY)));
				leftStickY = Std.int(r * (leftStickY / Math.sqrt(leftStickX * leftStickX + leftStickY * leftStickY)));
			}
		} else {
			leftStickX = leftStickY = 0;
		}
		
		if (mouse.started() ) {
			rightLocked = Vec2.distancef(mouse.x, mouse.y, rightPadX, rightPadY) <= r;
		} else if (mouse.released()) {
			rightLocked = false;
		}
		if (rightLocked) {
			rightStickX = Std.int(mouse.x - rightPadX);
			rightStickY = Std.int(mouse.y - rightPadY);
			if (Math.sqrt(rightStickX * rightStickX + rightStickY * rightStickY) > r) {
				rightStickX = Std.int(r * (rightStickX / Math.sqrt(rightStickX * rightStickX + rightStickY * rightStickY)));
				rightStickY = Std.int(r * (rightStickY / Math.sqrt(rightStickX * rightStickX + rightStickY * rightStickY)));
			}
		}
		else {
			rightStickX = rightStickY = 0;
		}

		gamepad_.axisListener(0, leftStickX / r);
		gamepad_.axisListener(1, leftStickY / r);
		gamepad_.axisListener(2, rightStickY / r);
		gamepad_.axisListener(3, rightStickX / r);

		// leftStickXLast = leftStickX;
		// leftStickYLast = leftStickY;
		// rightStickXLast = rightStickX;
		// rightStickYLast = rightStickY;
	}

	function render2D(g: kha.graphics2.Graphics) {
		
		var r = radius;
		var r2 = Std.int(r / sizeRatio);

		g.color = colorA;
		g.fillCircle(leftPadX, leftPadY, r);
		g.fillCircle(rightPadX, rightPadY, r);

		g.color = colorB;
		g.fillCircle(leftPadX + leftStickX, leftPadY + leftStickY, r2);
		g.fillCircle(rightPadX + rightStickX, rightPadY + rightStickY, r2);
	}
}
