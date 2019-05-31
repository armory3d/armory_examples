package arm;

import iron.Scene;
import iron.object.Object;
import iron.data.Data;
import iron.data.SceneFormat;

class MyTrait extends iron.Trait {
	public function new() {
		super();
		notifyOnInit(init);
	}

	function init() {
		Data.getSceneRaw("Scene.001", function (raw:TSceneFormat) {
			var obj = Scene.getObj(raw, "Suzanne");
			Scene.active.createObject(obj, raw, null, null, function(o:Object) {
				trace("Suzanne spawned!");
			});
		});
	}
}
