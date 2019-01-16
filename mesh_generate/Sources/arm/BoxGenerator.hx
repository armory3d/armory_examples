package arm;

import kha.arrays.Int16Array;
import kha.arrays.Uint32Array;
import iron.Scene;
import iron.data.SceneFormat;
import iron.data.Data;
import iron.data.MeshData;
import iron.data.MaterialData;
import iron.system.Input;

class BoxGenerator extends iron.Trait {

	var meshData:MeshData;
	var materials:haxe.ds.Vector<MaterialData>;

	function toI16(toPos:Int16Array, toNor:Int16Array, fromPos:Array<Float>, fromNor:Array<Float>) {
		var numVertices = Std.int(fromPos.length / 3);
		for (i in 0...numVertices) {
			// Values are scaled to the signed short (-32768, 32767) range
			// In the shader, vertex data is normalized into (-1, 1) range
			toPos[i * 4    ] = Std.int(fromPos[i * 3    ] * 32767);
			toPos[i * 4 + 1] = Std.int(fromPos[i * 3 + 1] * 32767);
			toPos[i * 4 + 2] = Std.int(fromPos[i * 3 + 2] * 32767);
			toNor[i * 2    ] = Std.int(fromNor[i * 3    ] * 32767);
			toNor[i * 2 + 1] = Std.int(fromNor[i * 3 + 1] * 32767);
			// normal.z component is packed into position.w component
			toPos[i * 4 + 3] = Std.int(fromNor[i * 3 + 2] * 32767);
		}
	}

	function toU32(to:Uint32Array, from:Array<Int>) {
		for (i in 0...to.length) to[i] = from[i];
	}

	public function new() {
		super();

		// Raw vertex data for our box
		var positions = [1.0,1.0,-1.0,1.0,-1.0,-1.0,-1.0,-1.0,-1.0,-1.0,1.0,-1.0,1.0,1.0,1.0,-1.0,1.0,1.0,-1.0,-1.0,1.0,1.0,-1.0,1.0,1.0,1.0,-1.0,1.0,1.0,1.0,1.0,-1.0,1.0,1.0,-1.0,-1.0,1.0,-1.0,-1.0,1.0,-1.0,1.0,-1.0,-1.0,1.0,-1.0,-1.0,-1.0,-1.0,-1.0,-1.0,-1.0,-1.0,1.0,-1.0,1.0,1.0,-1.0,1.0,-1.0,1.0,1.0,1.0,1.0,1.0,-1.0,-1.0,1.0,-1.0,-1.0,1.0,1.0];
		var normals = [0.0,0.0,-1.0,0.0,0.0,-1.0,0.0,0.0,-1.0,0.0,0.0,-1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,0.0,0.0,-1.0,-0.0,0.0,-1.0,-0.0,0.0,-1.0,-0.0,0.0,-1.0,-0.0,-1.0,0.0,-0.0,-1.0,0.0,-0.0,-1.0,0.0,-0.0,-1.0,0.0,-0.0,0.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0];
		var indices = [0,1,2,0,2,3,4,5,6,4,6,7,8,9,10,8,10,11,12,13,14,12,14,15,16,17,18,16,18,19,20,21,22,20,22,23];
		var numVertices = Std.int(positions.length / 3);

		// Armory uses packed 16-bit normalized vertex data to preserve memory
		// To prevent padding and ensure 32-bit align,
		// normal.z component is packed into position.w component
		var posI16 = new Int16Array(numVertices * 4); // pos.xyz, nor.z
		var norI16 = new Int16Array(numVertices * 2); // nor.xy
		toI16(posI16, norI16, positions, normals);
		
		var indU32 = new Uint32Array(indices.length);
		toU32(indU32, indices);

		var pos:TVertexArray = { attrib: "pos", values: posI16 };
		var nor:TVertexArray = { attrib: "nor", values: norI16 };
		var ind:TIndexArray = { material: 0, values: indU32 };

		var rawmeshData:TMeshData = { 
			name: "BoxMesh",
			vertex_arrays: [pos, nor],
			index_arrays: [ind],
			// Usable to scale positions over the (-1, 1) range
			scale_pos: 1.0
		};

		new MeshData(rawmeshData, function(data:MeshData) {
			// Mesh data parsed
			meshData = data;
			meshData.geom.calculateAABB();
			
			// Fetch material from scene data
			Data.getMaterial("Scene", "Material", function(data:MaterialData) {
				// Material loaded
				materials = haxe.ds.Vector.fromData([data]);
				notifyOnUpdate(update);
			});
		});
	}

	function update() {
		// Left mouse button was pressed / display touched
		var mouse = Input.getMouse();
		if (mouse.started()) {
			// Create new object in active scene
			var object = Scene.active.addMeshObject(meshData, materials);
			
			// Just for testing, add rigid body trait
			var aabb = meshData.geom.aabb;
			object.transform.loc.set(Math.random() * 8 - 4, Math.random() * 8 - 4, 5);
			object.transform.buildMatrix();
			object.transform.dim.set(aabb.x, aabb.y, aabb.z);
			object.addTrait(new armory.trait.physics.RigidBody());
		}
	}
}
