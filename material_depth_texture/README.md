Wall with a material that's reading from a depth texture, which is copied from the depth buffer before drawing the wall as the last object in the scene.

#### To use this in your own projects:

1. Enable `Material Properties > Armory Props > Read Depth`
2. Make sure `Render Properties > Armory Render Path > Renderer > Depth Texture` is set to `Auto` or `On`
3. Add a `Shader Data` node with a uniform sampler2D with the name `depthtex` and separate the x value from the color output

Note that the depth values depend on the camera far/near values! Also the compositor needs to be enabled on forward render path in order to work.