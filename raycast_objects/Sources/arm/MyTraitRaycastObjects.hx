package arm;

import iron.system.Input;
import iron.math.Vec4;
import iron.math.RayCaster;
import iron.object.Object;
import iron.object.CameraObject;

class MyTraitRaycastObjects extends iron.Trait {

	var v = new Vec4();
	var mouse = Input.getMouse();
	var objects: Array<Object>;
	var o: Object;

	public function new() {
		super();

		notifyOnInit(function() {
		 
		 objects = [object, iron.Scene.active.getChild('Sphere'), iron.Scene.active.getChild('Suzanne')];
		 
		 });

		notifyOnUpdate(function() {
		
 
		if(mouse.started('left')){
			v = RayCaster.boxIntersectObject(object, mouse.x, mouse.y,  iron.Scene.active.camera);
			if(v != null)
				trace('Raycast object at position: '+v);
			
			o = RayCaster.closestBoxIntersectObject(objects, mouse.x, mouse.y, iron.Scene.active.camera);
			if (o != null){
				v = RayCaster.boxIntersectObject(o, mouse.x, mouse.y, iron.Scene.active.camera);
				trace('Raycast object: '+o.name+' at position: '+v);
			}			
		}
 
		});

		// notifyOnRemove(function() {
		// });
	}
}
