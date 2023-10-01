package arm;

import iron.math.Vec4;
import iron.system.Input;

class LockTrait extends iron.Trait {

	public function new() {

		super();

		var mouse = Input.getMouse();
		var kb = Input.getKeyboard();

		notifyOnUpdate(() -> {
			if (mouse.started("left")) {
				mouse.lock();
			} else if (kb.started("escape")) {
				mouse.unlock();
			}
			var cube = iron.Scene.active.getChild("Cube");
			if (cube != null) {
				cube.transform.rotate(Vec4.zAxis(), mouse.movementX * 0.002);
				cube.transform.rotate(Vec4.xAxis(), mouse.movementY * 0.002);
			}
		});
	}
}
