package arm;

import armory.system.Event;

class SendEvent extends iron.Trait {

	public function new() {

		super();

		var mouse = iron.system.Input.getMouse();
		
		notifyOnUpdate(function() {
			if (mouse.started("left")) {
				Event.send("my_event");
			}
		});
	}
}
