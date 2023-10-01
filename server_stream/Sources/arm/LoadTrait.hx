package arm;

import haxe.io.Bytes;
import iron.object.MeshObject;
import iron.data.MeshData;
import iron.data.SceneFormat;
import iron.Scene;

class LoadTrait extends iron.Trait {

	function getFormat(asset:Dynamic, format:String):Dynamic {
		var fs:Array<Dynamic> = asset.formats;
		for (i in 0...fs.length) if (fs[i].formatType == format) return fs[i];
		return null;
	}

	public function new() {
		super();

		notifyOnInit(function() {
			// Load Future Car mesh by Dennis Haupt from poly.google.com
			// See https://developers.google.com/poly/develop/web
			var url = "https://poly.googleapis.com/v1/assets/0XrQdpjc4Vk/?key=AIzaSyAME8tuXn8gIaPcxmVaz0qbar0DkR4Kw6Q";
			var http = new haxe.Http(url);
			http.onData = function(data:String) {
				var format = getFormat(haxe.Json.parse(data), "OBJ");
				if (format != null) {
					var root = format.root;
					http = new haxe.Http(root.url);
					http.onData = makeMesh;
					http.request();
				}
			}
			http.request();
		});
	}

	function makeMesh(data:String) {
		// Parse received .obj data
		var mesh = new ObjParser(kha.Blob.fromBytes(Bytes.ofString(data)));
		var posaAr: TVertexArray = { attrib: "pos", values: mesh.posa, data: "short4norm"};
		var noraAr: TVertexArray = { attrib: "nor", values: mesh.nora, data: "short2norm"};
		var raw:TMeshData = {
			name: "Mesh",
			vertex_arrays: [posaAr, noraAr],
			index_arrays: [
				{ values: mesh.inda, material: 0 }
			],
			scale_pos: mesh.scalePos
		};

		// Set as a new mesh for cube object
		new MeshData(raw, function(md:MeshData) {
			var cube = cast(Scene.active.getChild("Cube"), MeshObject);
			cube.data.delete();
			cube.setData(md);
		});
	}
}
