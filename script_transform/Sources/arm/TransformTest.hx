package arm;

class TransformTest extends iron.Trait {
    public function new() {
        super();

        notifyOnInit(function() {

            trace('Testing 2 cubes, parent cube at (1, 0, 0), child cube at (5, 0, 0)');

            trace('Parent location: ' + object.parent.transform.loc);
            // (1, 0, 0)

            trace('Child location: ' +  object.transform.loc);
            // (5, 0, 0)

            trace('Child location in world space: ' + object.transform.world.getLoc());
            // (6, 0, 0)

            trace('Setting child to parent location …');
            object.transform.loc.set(0, 0, 0);
            object.transform.buildMatrix();
            
            trace('Child location: ' + object.transform.loc);
            // (0, 0, 0)

            trace('Child location in world space: ' + object.transform.world.getLoc());
            // (1, 0, 0)

            trace('Moving parent …');
            object.parent.transform.loc.set(0, 3, 0);
            object.parent.transform.buildMatrix();

            trace('Child location: ' + object.transform.loc);
            // (0, 0, 0)

            trace('Child location in world space: ' + object.transform.world.getLoc());
            // (0, 3, 0)

            // Note: In Blender, you may need to:
            // - Clear Parent - Clear Parent Inverse
            // - To get local transform
        });
    }
}
