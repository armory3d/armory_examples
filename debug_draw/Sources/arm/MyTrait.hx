package arm;

#if arm_debug
import armory.trait.internal.DebugDraw;
#end

class MyTrait extends iron.Trait {
	
	public function new() {
		super();
		notifyOnInit( () -> {
			var plane = iron.Scene.active.getChild("Plane");
			var suzanne = iron.Scene.active.getChild("Suzanne");
			// To see debug drawing, `Armory Project - Debug Console` option has to be enabled
			#if arm_debug
			DebugDraw.notifyOnRender( (draw:DebugDraw) -> {
				if(plane != null) draw.bounds(plane.transform);
				if(suzanne != null) draw.bounds(suzanne.transform);
				// draw.line();
			});
			#end
		});
	}
}
