package arm;

import iron.math.Vec4;
import iron.math.Quat;
import iron.object.BoneAnimation;
import iron.math.Mat4;

// Moving a bone - forward kinematics
class MoveBoneFK extends iron.Trait {

	public function new() {
		super();

		notifyOnInit(function() {
			// Fetch armature animation
			var anim = cast(object.children[0].animation, BoneAnimation);
			// Fetch bone
			var bone = anim.getBone("mixamorig:RightArm");
			
			// Manipulating bone in local space
			//var m = anim.getBoneMat(bone);
			// anim.notifyOnUpdate(function() {
			//	var offset = new Quat().fromEuler(0, Math.sin(iron.system.Time.time()), 0);
			//	m.applyQuat(offset);
			//});

			// Manipulating bone in world space	
			anim.notifyOnUpdate(function() {
				// Get bone mat in world space
				var m = anim.getAbsWorldMat(bone);
				// Decompose transform
				var loc = new Vec4();
				var scl = new Vec4();
				var rot = new Quat();
				m.decompose(loc, rot, scl);
				// Apply rotation
				var offset = new Quat().fromEuler(Math.sin(iron.system.Time.time()), 0, 0);
				rot.multquats(offset, rot);
				// Compose world matrix
				m.compose(loc, rot, scl);
				// Set bone matrix from world matrix
				anim.setBoneMatFromWorldMat(m, bone);
			});
		});
	}
}
