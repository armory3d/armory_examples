package arm;

class MyTrait extends iron.Trait {
	public function new() {
		super();
		armory.system.Event.add("move_box", onEvent);
	}

	function onEvent() {
        trace("move_box");
		var loc = object.transform.loc;
		loc.y += 1;
		if (loc.y > 4) loc.y -= 8;
		object.transform.buildMatrix();
	}
}
