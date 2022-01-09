package arm;

import iron.Scene;
import iron.math.Vec4;
import iron.data.MaterialData;
import iron.object.MeshObject;
import iron.object.Object;
import iron.object.Uniforms;

class MyTrait extends iron.Trait {

	public function new() {
		super();
		notifyOnInit(() -> {
			Uniforms.externalFloatLinks.push(floatLink);
		});
	}

	function floatLink(object:Object, mat:MaterialData, link:String):Null<kha.FastFloat> {
		if (link == "myParam") {
			var mouse = iron.system.Input.getMouse();
			return (iron.App.h() - mouse.y) / 100;
		}
		return null;
	}
}
