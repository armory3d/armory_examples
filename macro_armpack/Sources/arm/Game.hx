package arm;

import iron.math.Vec4;

@:build(arm.Macros.build())
class Game extends iron.Trait {

    function update() {
        Cube.transform.rotate( Vec4.zAxis(), 0.01 );
        Icosphere.transform.rotate( Vec4.yAxis(), 0.01 );
        Torus.transform.rotate( Vec4.xAxis(), 0.01 );
    }
}
