package arm.node;

@:access(armory.logicnode.LogicNode)@:keep class NodeTree extends armory.logicnode.LogicTree {

	var functionNodes:Map<String, armory.logicnode.FunctionNode>;

	var functionOutputNodes:Map<String, armory.logicnode.FunctionOutputNode>;

	public function new() {
		super();
		name = "NodeTree";
		this.functionNodes = new Map();
		this.functionOutputNodes = new Map();
		notifyOnAdd(add);
	}

	override public function add() {
		var _Vector_001 = new armory.logicnode.VectorNode(this);
		_Vector_001.preallocInputs(3);
		_Vector_001.preallocOutputs(1);
		var _Math_001 = new armory.logicnode.MathNode(this);
		_Math_001.property0 = "Multiply";
		_Math_001.property1 = false;
		_Math_001.preallocInputs(2);
		_Math_001.preallocOutputs(1);
		var _SeparateXYZ_001 = new armory.logicnode.SeparateVectorNode(this);
		_SeparateXYZ_001.preallocInputs(1);
		_SeparateXYZ_001.preallocOutputs(3);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.VectorNode(this, 0.0,0.0,0.0), _SeparateXYZ_001, 0, 0);
		armory.logicnode.LogicNode.addLink(_SeparateXYZ_001, new armory.logicnode.FloatNode(this, 0.0), 2, 0);
		armory.logicnode.LogicNode.addLink(_SeparateXYZ_001, _Math_001, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.FloatNode(this, -1.0), _Math_001, 0, 1);
		armory.logicnode.LogicNode.addLink(_Math_001, _Vector_001, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.FloatNode(this, 0.0), _Vector_001, 0, 1);
		armory.logicnode.LogicNode.addLink(_SeparateXYZ_001, _Vector_001, 1, 2);
		armory.logicnode.LogicNode.addLink(_Vector_001, new armory.logicnode.VectorNode(this, 0.0,0.0,0.0), 0, 0);
		var _SetObjectLocation = new armory.logicnode.SetLocationNode(this);
		_SetObjectLocation.preallocInputs(4);
		_SetObjectLocation.preallocOutputs(1);
		var _OnUpdate_001 = new armory.logicnode.OnUpdateNode(this);
		_OnUpdate_001.property0 = "Update";
		_OnUpdate_001.preallocInputs(0);
		_OnUpdate_001.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(_OnUpdate_001, _SetObjectLocation, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, ""), _SetObjectLocation, 0, 1);
		var _GamepadCoords_001 = new armory.logicnode.GamepadCoordsNode(this);
		_GamepadCoords_001.preallocInputs(1);
		_GamepadCoords_001.preallocOutputs(6);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.IntegerNode(this, 0), _GamepadCoords_001, 0, 0);
		armory.logicnode.LogicNode.addLink(_GamepadCoords_001, new armory.logicnode.VectorNode(this, 0.0,0.0,0.0), 2, 0);
		armory.logicnode.LogicNode.addLink(_GamepadCoords_001, new armory.logicnode.VectorNode(this, 0.0,0.0,0.0), 3, 0);
		armory.logicnode.LogicNode.addLink(_GamepadCoords_001, new armory.logicnode.FloatNode(this, 0.0), 4, 0);
		armory.logicnode.LogicNode.addLink(_GamepadCoords_001, new armory.logicnode.FloatNode(this, 0.0), 5, 0);
		armory.logicnode.LogicNode.addLink(_GamepadCoords_001, _SetObjectLocation, 0, 2);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, false), _SetObjectLocation, 0, 3);
		armory.logicnode.LogicNode.addLink(_SetObjectLocation, new armory.logicnode.NullNode(this), 0, 0);
		var _SetObjectRotation = new armory.logicnode.SetRotationNode(this);
		_SetObjectRotation.property0 = "Euler Angles";
		_SetObjectRotation.preallocInputs(3);
		_SetObjectRotation.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(_OnUpdate_001, _SetObjectRotation, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, ""), _SetObjectRotation, 0, 1);
		var _Rotation = new armory.logicnode.RotationNode(this);
		_Rotation.property0 = "EulerAngles";
		_Rotation.property1 = "Rad";
		_Rotation.property2 = "XYZ";
		_Rotation.preallocInputs(2);
		_Rotation.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(_GamepadCoords_001, _Rotation, 1, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.FloatNode(this, 0.0), _Rotation, 0, 1);
		armory.logicnode.LogicNode.addLink(_Rotation, _SetObjectRotation, 0, 2);
		armory.logicnode.LogicNode.addLink(_SetObjectRotation, new armory.logicnode.NullNode(this), 0, 0);
	}
}