Rigid body set to:
- Active dynamic
- Axis and rotation locked (linear and angular factor)
- Trigger/Ghost checked making this a trigger instead of a collision object
- Force deactivation unchecked to make sure physics engine keep the rigid body active
- Trigger script checks for overlapping rigid bodies on each update

## How to test
Move the box around using WASD+QE.  
When box is overlapping sphere the icoshpere object is visible, otherwise it's hidden.
