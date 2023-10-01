package arm;

import iron.data.Data;
import iron.data.Wasm;

class MyTrait extends iron.Trait {

	public function new() {
		super();
		notifyOnInit(init);
	}

	function init() {
		// Load wasm blob
		Data.getBlob("main.wasm", blob -> {
			// Create wasm module
			var wasm = Wasm.instance(blob);
			var rot = 0.0;
			notifyOnUpdate(function() {
				// Call function from wasm module
				rot += wasm.exports.test();
				object.transform.setRotation(0, 0, rot);
			});
		});
	}
}
