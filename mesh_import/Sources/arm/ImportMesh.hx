package arm;

import iron.Scene;
import iron.data.SceneFormat;
import iron.data.Data;
import iron.data.MeshData;
import iron.data.MaterialData;
import iron.system.Input;

class ImportMesh extends iron.Trait {

	var meshData:MeshData;
	var materials:haxe.ds.Vector<MaterialData>;

	public function new() {
		super();

		// Get raw blob
		Data.getBlob("cube.obj", function(blob:kha.Blob) {

			// Parse obj file
			var mesh = new ObjParser(blob);

			// Positions, normals and indices
			var pos:TVertexArray = { attrib: "pos", values: mesh.posa, data: "short4norm" };
			var nor:TVertexArray = { attrib: "nor", values: mesh.nora, data: "short2norm" };
			var ind:TIndexArray = { material: 0, values: mesh.inda };

			var rawmeshData:TMeshData = {
				name: "BoxMesh",
				vertex_arrays: [pos, nor],
				index_arrays: [ind],
				// Usable to scale positions over the (-1, 1) range
				scale_pos: mesh.scalePos
			};

			// Construct new mesh
			new MeshData(rawmeshData, function(data:MeshData) {
				meshData = data;
				meshData.geom.calculateAABB();

				// Fetch material from scene data
				Data.getMaterial("Scene", "Material", function(data:MaterialData) {
					// Material loaded
					materials = haxe.ds.Vector.fromData([data]);
					notifyOnUpdate(update);
				});
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
