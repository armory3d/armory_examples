package arm;

import armory.renderpath.HosekWilkie;
import armory.renderpath.Nishita;
import iron.Scene;
import iron.math.Vec4;
import iron.system.Input;

class MyTrait extends iron.Trait {
	public function new() {
		super();
		notifyOnInit(function() {
			
			var world = Scene.active.world;
			var center = Scene.active.getEmpty('Center');
			var light = Scene.active.lights[0];
			var keyboard = Input.getKeyboard();
			var model = 'hosekwilkie';
			notifyOnUpdate(function() {
				
				if (keyboard.started("1")) Scene.setActive('Scene_'+(model = 'hosekwilkie'));
				if (keyboard.started("2")) Scene.setActive('Scene_'+(model = 'nishita'));

				center.transform.rotate(Vec4.xAxis(),0.02);

				// Sync sun direction
				var v = light.look();
				world.raw.sun_direction[0] = v.x;
				world.raw.sun_direction[1] = v.y;
				world.raw.sun_direction[2] = v.z;

				switch model {
				case 'hosekwilkie': HosekWilkie.recompute(world);
				case 'nishita': Nishita.recompute(world);
				}
	
				// Set world strength
				// world.getGlobalProbe().raw.strength = 1.0;
			});
		});
	}
}
