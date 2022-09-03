package arm.node;

@:access(armory.logicnode.LogicNode)@:keep class SelectGamepad extends armory.logicnode.LogicTree {

	var functionNodes:Map<String, armory.logicnode.FunctionNode>;

	var functionOutputNodes:Map<String, armory.logicnode.FunctionOutputNode>;

	public function new() {
		super();
		name = "SelectGamepad";
		this.functionNodes = new Map();
		this.functionOutputNodes = new Map();
		notifyOnAdd(add);
	}

	override public function add() {
		var _RemoveTrait = new armory.logicnode.RemoveTraitNode(this);
		_RemoveTrait.preallocInputs(2);
		_RemoveTrait.preallocOutputs(1);
		var _IsNotNull = new armory.logicnode.IsNotNoneNode(this);
		_IsNotNull.preallocInputs(2);
		_IsNotNull.preallocOutputs(1);
		var _Branch = new armory.logicnode.BranchNode(this);
		_Branch.preallocInputs(2);
		_Branch.preallocOutputs(2);
		var _OnUpdate = new armory.logicnode.OnUpdateNode(this);
		_OnUpdate.property0 = "Update";
		_OnUpdate.preallocInputs(0);
		_OnUpdate.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(_OnUpdate, _Branch, 0, 0);
		var _GetCanvasCheckbox = new armory.logicnode.CanvasGetCheckboxNode(this);
		_GetCanvasCheckbox.preallocInputs(1);
		_GetCanvasCheckbox.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.StringNode(this, "VGamepad"), _GetCanvasCheckbox, 0, 0);
		armory.logicnode.LogicNode.addLink(_GetCanvasCheckbox, _Branch, 0, 1);
		armory.logicnode.LogicNode.addLink(_Branch, _IsNotNull, 1, 0);
		var _GetObjectTrait = new armory.logicnode.GetTraitNode(this);
		_GetObjectTrait.preallocInputs(2);
		_GetObjectTrait.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, ""), _GetObjectTrait, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.StringNode(this, "VirtualGamepad"), _GetObjectTrait, 0, 1);
		armory.logicnode.LogicNode.addLink(_GetObjectTrait, _IsNotNull, 0, 1);
		armory.logicnode.LogicNode.addLink(_IsNotNull, _RemoveTrait, 0, 0);
		armory.logicnode.LogicNode.addLink(_GetObjectTrait, _RemoveTrait, 0, 1);
		armory.logicnode.LogicNode.addLink(_RemoveTrait, new armory.logicnode.NullNode(this), 0, 0);
		var _AddTraittoObject = new armory.logicnode.AddTraitNode(this);
		_AddTraittoObject.preallocInputs(3);
		_AddTraittoObject.preallocOutputs(1);
		var _IsNull = new armory.logicnode.IsNoneNode(this);
		_IsNull.preallocInputs(2);
		_IsNull.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(_Branch, _IsNull, 0, 0);
		var _GetObjectTrait_001 = new armory.logicnode.GetTraitNode(this);
		_GetObjectTrait_001.preallocInputs(2);
		_GetObjectTrait_001.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, ""), _GetObjectTrait_001, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.StringNode(this, "VirtualGamepad"), _GetObjectTrait_001, 0, 1);
		armory.logicnode.LogicNode.addLink(_GetObjectTrait_001, _IsNull, 0, 1);
		armory.logicnode.LogicNode.addLink(_IsNull, _AddTraittoObject, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, ""), _AddTraittoObject, 0, 1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.StringNode(this, "VirtualGamepad"), _AddTraittoObject, 0, 2);
		armory.logicnode.LogicNode.addLink(_AddTraittoObject, new armory.logicnode.NullNode(this), 0, 0);
	}
}