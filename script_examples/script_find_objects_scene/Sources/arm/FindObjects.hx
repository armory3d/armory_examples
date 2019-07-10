package arm;

import iron.Scene;
import iron.object.Object;

class FindObjects extends iron.Trait {
	public function new() {
		super();

		 notifyOnInit(init);

		 notifyOnUpdate(update);
	}

	function init(){
		// if we want to find an object in the scene and we know the name
		var myLight = Scene.active.getChild("my light");
		if (myLight != null) trace("found my light");
		
		// to get a Group (Collection in Blender) we can do so by their name
		var propsGroup = Scene.active.getGroup("props");
		if (propsGroup != null) trace("found Group props with " + propsGroup.length + " props");
		
		var sceneParent = Scene.active.sceneParent;

		var sceneObjs = sceneParent.children;
		if (sceneObjs != null) trace("total objects in scene: " + sceneObjs.length);

		var array = [];

		for(obj in sceneObjs) if(!obj.visible) array.push(obj);
		trace("invisible objects: " + array.length);
	}
	
	function update(){
		var array = [];
		var sceneParent = Scene.active.sceneParent;
		var objsNotVisibleToCam = objsNotVisibleToCamera(sceneParent,array);
		trace("objects not visible to camera: " + objsNotVisibleToCam.length);
	}

	function objsNotVisible(obj:Object, group:Array<Object>, ignoreRoot=true):Array<Object>{
		if (!obj.visible && !ignoreRoot) group.push(obj);
		for (ch in obj.children) {
			if (ch.children.length > 0) objsNotVisible(ch, group, false);
			else if (!ch.visible) group.push(ch);
		}
		return group;
	}

	function objsNotVisibleToCamera(obj:Object, group:Array<Object>, ignoreRoot=true):Array<Object>{
		if (obj.culledMesh && !ignoreRoot) group.push(obj);
		for (ch in obj.children) {
			if (ch.children.length > 0) objsNotVisibleToCamera(ch, group, false);
			else if (ch.culledMesh) group.push(ch);
		}
		return group;
	}

	function objsWithTrait(t:Class<iron.Trait>, obj:Object, group:Array<Object>, ignoreRoot=true):Array<Object>{
		if (obj.getTrait(t) != null && !ignoreRoot) group.push(obj);
		for (ch in obj.children) {
			if (ch.children.length > 0) objsWithTrait(t,ch,group,false);
			else if (ch.getTrait(t) != null) group.push(ch);
		}
		return group;
	}
	// this is a more lengthier one. We allow the choice for case sensitive search
	function objsNameContains(string:String, obj:Object, group:Array<Object>, caseSensitive=false, ignoreRoot=true):Array<Object>{
		if(!ignoreRoot){
			if(!caseSensitive)
				if(obj.name.toLowerCase().lastIndexOf(string.toLowerCase()) != -1) group.push(obj);
			else
				if(obj.name.lastIndexOf(string) != -1) group.push(obj);
		}
		
		for (ch in obj.children) {
			if(ch.children.length > 0) objsNameContains(string,ch,group,caseSensitive,false);
			else {
				if(!caseSensitive)
					if(ch.name.toLowerCase().lastIndexOf(string.toLowerCase()) != -1) group.push(ch);
				else
					if(ch.name.lastIndexOf(string) != -1) group.push(ch);
			}
		}
		return group;
	}
}
