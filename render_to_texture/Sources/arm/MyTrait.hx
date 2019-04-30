package arm;

class MyTrait extends iron.Trait {
	public function new() {
		super();

		notifyOnInit(function() {
			// Retrieve camera object
			var cam = cast(iron.Scene.active.getChild("Camera.001"), iron.object.CameraObject);

			// Create render target for camera
			cam.renderTarget = kha.Image.createRenderTarget(
				640,
				360,
				kha.graphics4.TextureFormat.RGBA32,
				kha.graphics4.DepthStencilFormat.NoDepthAndStencil
			);

			// Display camera output on this plane
			var o = cast(object, iron.object.MeshObject);
			o.materials[0].contexts[0].textures[0] = cam.renderTarget; // Override base color texture

			notifyOnRender(function(g:kha.graphics4.Graphics) {
				// Set as scene camera
				var activeCamera = iron.Scene.active.camera;
				iron.Scene.active.camera = cam;

				// Update camera output
				cam.renderFrame(g);
				
				// Restore original camera
				iron.Scene.active.camera = activeCamera;
			});
		});
	}
}
