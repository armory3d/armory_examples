package arm;

import iron.math.Vec4;
import iron.object.Object;
import iron.object.Uniforms;
import iron.data.Data;
import iron.data.MaterialData;
import iron.system.Time;

class MyTrait extends iron.Trait {

	var tex1:kha.Image = null;
	var tex2:kha.Image = null;

	public function new() {
		super();
		notifyOnInit(() -> {
			// Register link callbacks
			Uniforms.externalVec3Links.push(vec3Link);
			Uniforms.externalFloatLinks.push(floatLink);
			Uniforms.externalTextureLinks.push(textureLink);
		});
		Data.getImage("tex1.png", img -> tex1 = img );
		Data.getImage("tex2.png", img -> tex2 = img );
	}

	function vec3Link(object:Object, mat:MaterialData, link:String):Vec4 {
		// object - currently bound object
		// mat - currently bound material
		// link - material node name
		if (link == "RGB") {
			var t = Time.time();
			return new Vec4(Math.sin(t) * 0.5 + 0.5, Math.cos(t) * 0.5 + 0.5, Math.sin(t + 0.5) * 0.5 + 0.5);
		}
		return null;
	}

	function floatLink(object:Object, mat:MaterialData, link:String):Null<kha.FastFloat> {
		if (link == "Value") {
			var t = Time.time();
			return Math.floor(t);
		}
		return null;
	}

	function textureLink(object:Object, mat:MaterialData, link:String):kha.Image {
		if (link == "Image Texture") {
			var t = Time.time();
			return Math.sin(t) > 0 ? tex1 : tex2;
		}
		return null;
	}
}
