package arm.node;

@:access(armory.logicnode.LogicNode)@:keep class ReceiveEvent extends armory.logicnode.LogicTree {

	var functionNodes:Map<String, armory.logicnode.FunctionNode>;

	var functionOutputNodes:Map<String, armory.logicnode.FunctionOutputNode>;

	public function new() {
		super();
		this.functionNodes = new Map();
		this.functionOutputNodes = new Map();
		notifyOnAdd(add);
	}

	override public function add() {
		var _TranslateObject = new armory.logicnode.TranslateObjectNode(this);
		_TranslateObject.preallocInputs(4);
		_TranslateObject.preallocOutputs(1);
		var _OnEvent_001 = new armory.logicnode.OnEventNode(this);
		_OnEvent_001.property1 = "init";
		_OnEvent_001.preallocInputs(1);
		_OnEvent_001.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.StringNode(this, "my_event"), _OnEvent_001, 0, 0);
		armory.logicnode.LogicNode.addLink(_OnEvent_001, _TranslateObject, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, ""), _TranslateObject, 0, 1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.VectorNode(this, 0.0,0.0,0.20000000298023224), _TranslateObject, 0, 2);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, false), _TranslateObject, 0, 3);
		armory.logicnode.LogicNode.addLink(_TranslateObject, new armory.logicnode.NullNode(this), 0, 0);
	}
}