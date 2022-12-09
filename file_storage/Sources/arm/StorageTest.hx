package arm;

import iron.system.Storage;

class StorageTest extends iron.Trait {

	public function new() {
		super();
		notifyOnInit(() -> {

			// Retrieve storage
			var data = Storage.data;
			if (data == null)
                return;

			// First run - init integer variable named 'count'
			var count: Dynamic = data.mycount;
			if (count == null) {
				data.mycount = 0;
				// Init more variables as needed
				// data.test1 = "String";
				// data.test2 = 1.23;
				// data.test3 = true;
				// data.test4 = [3, 5, 7];
				// data.test5 = {a: 3, b: "value"};
			}

			trace("Count is " + data.mycount);
			
			// Increase count on every run
			data.mycount++;

			Storage.save();

            var d = 10;
            var s = 1;
            var ox = 0;
            var oy = 0;
            notifyOnRender2D(g -> {
                g.end();
                g.color = 0xff101010;
                ox = oy = 0;
                for(i in 0...data.mycount) {
                    g.fillRect(d+ox, d+oy, d, d);
                    ox += (d+1);
                    if(ox+d > kha.System.windowWidth()) {
                        ox = 0;
                        oy += d+1;
                    }
                }
                g.begin(false);
            });
		});
	}
}
