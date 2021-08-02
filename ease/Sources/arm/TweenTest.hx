package arm;

import iron.system.Tween;
#if arm_debug
import armory.trait.internal.DebugDraw;
#end

class TweenTest extends iron.Trait {

    @prop var ease : Int = 0;
    
    public function new() {

        super();

        #if arm_debug
		//DebugDraw.notifyOnRender( draw -> draw.bounds( object.transform) );
		#end

        notifyOnInit(tweenUp);
    }

    function tweenUp() {
        doTween( 15, tweenDown );
    }
    
    function tweenDown() {
        doTween( -15, tweenUp );
    }
  
    function doTween( z : Float, onDone : Void->Void ) {
        Tween.to({
            target: object.transform.loc,
            props: { z: z },
            duration: 2.0,
            delay: 0.5,
            tick: object.transform.buildMatrix,
            ease: ease,
            done: onDone
        });
    }
}
