package arm;

import iron.system.Input;
import armory.trait.physics.PhysicsWorld;

// This example shows how to call JavaScript after clicking on a Cube object
// Requires physics enabled and browser target

class CallJS extends iron.Trait {

	public function new() {
		super();
        var mouse = Input.getMouse();
        notifyOnUpdate(function() {

            // Check mouse button
            if (!mouse.started()) return;

            // Pick object at mouse coords
            var rb = PhysicsWorld.active.pickClosest(mouse.x, mouse.y);
            
            // Check if picked object is our Cube
            if (rb != null && rb.object.name == 'Cube') {
                // Raw JS calls
                js.Syntax.code('document.title = "Cube clicked!"');
                js.Syntax.code('console.log("Testing..");');
            }
        });
	}
}
