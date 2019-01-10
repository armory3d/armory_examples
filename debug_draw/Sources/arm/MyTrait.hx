package arm;

#if arm_debug
import armory.trait.internal.DebugDraw;
#end

class MyTrait extends iron.Trait {
	public function new() {
		super();

		// To see debug drawing, `Armory Project - Debug Console` option has to be enabled

		#if arm_debug
		DebugDraw.notifyOnRender(function(draw:DebugDraw) {
			var o = iron.Scene.active.getChild("Suzanne");
			draw.bounds(o.transform);
			// draw.line();
		});
		#end
	}
}
