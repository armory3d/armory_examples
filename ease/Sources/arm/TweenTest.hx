package arm;

import iron.system.Tween;
#if arm_debug
import armory.trait.internal.DebugDraw;
#end

class TweenTest extends iron.Trait {

    @prop var ease : Int = 0;

    public function new() {
        super();
        notifyOnInit(() -> {
            #if arm_debug
            //DebugDraw.notifyOnRender( draw -> draw.bounds( object.transform) );
            #end
            doTween(10);
        });
    }

    function doTween( v : Float ) {
        Tween.to({
            target: object.transform.loc,
            props: { z: v },
            delay: 0.5,
            duration: 2.0,
            ease: ease,
            tick: object.transform.buildMatrix,
            done: () -> doTween(-v)
        });
    }
}
