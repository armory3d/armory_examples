package arm;

#if arm_debug
import armory.trait.internal.DebugDraw;
#end

// To see debug drawing, `Armory Project - Debug Console` option has to be enabled

class MyTrait extends iron.Trait {

	public function new() {
		super();
		notifyOnInit( () -> {
			var suzanne = iron.Scene.active.getChild("Suzanne");
			var sphere = iron.Scene.active.getChild("Sphere");
			#if arm_debug
			DebugDraw.notifyOnRender( (draw:DebugDraw) -> {
				if(suzanne != null) draw.bounds(suzanne.transform);
				if(sphere != null) draw.bounds(sphere.transform);
				// draw.line();
			});
			#end
		});
	}
}
