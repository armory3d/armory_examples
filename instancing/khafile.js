// Auto-generated
let project = new Project('inst');

project.addSources('Sources');
project.addLibrary("C:/Users/lubos/Downloads/Armory/armsdk/armory");
project.addLibrary("C:/Users/lubos/Downloads/Armory/armsdk/iron");
project.addParameter('armory.trait.WalkNavigation');
project.addParameter("--macro keep('armory.trait.WalkNavigation')");
project.addShaders("build_inst/compiled/Shaders/*.glsl");
project.addShaders("build_inst/compiled/Hlsl/*.glsl", { noprocessing: true });
project.addAssets("build_inst/compiled/Assets/**", { notinlist: true });
project.addAssets("build_inst/compiled/Shaders/*.arm", { notinlist: true });
project.addAssets("C:/Users/lubos/Downloads/Armory/armsdk/armory/Assets/brdf.png", { notinlist: true });
project.addAssets("C:/Users/lubos/Downloads/Armory/armsdk/armory/Assets/hosek/hosek_radiance.hdr", { notinlist: true });
project.addAssets("C:/Users/lubos/Downloads/Armory/armsdk/armory/Assets/hosek/hosek_radiance_0.hdr", { notinlist: true });
project.addAssets("C:/Users/lubos/Downloads/Armory/armsdk/armory/Assets/hosek/hosek_radiance_1.hdr", { notinlist: true });
project.addAssets("C:/Users/lubos/Downloads/Armory/armsdk/armory/Assets/hosek/hosek_radiance_2.hdr", { notinlist: true });
project.addAssets("C:/Users/lubos/Downloads/Armory/armsdk/armory/Assets/hosek/hosek_radiance_3.hdr", { notinlist: true });
project.addAssets("C:/Users/lubos/Downloads/Armory/armsdk/armory/Assets/hosek/hosek_radiance_4.hdr", { notinlist: true });
project.addAssets("C:/Users/lubos/Downloads/Armory/armsdk/armory/Assets/hosek/hosek_radiance_5.hdr", { notinlist: true });
project.addAssets("C:/Users/lubos/Downloads/Armory/armsdk/armory/Assets/hosek/hosek_radiance_6.hdr", { notinlist: true });
project.addAssets("C:/Users/lubos/Downloads/Armory/armsdk/armory/Assets/hosek/hosek_radiance_7.hdr", { notinlist: true });
project.addAssets("C:/Users/lubos/Downloads/Armory/armsdk/armory/Assets/smaa_area.png", { notinlist: true });
project.addAssets("C:/Users/lubos/Downloads/Armory/armsdk/armory/Assets/smaa_search.png", { notinlist: true });
project.addDefine('arm_hosek');
project.addDefine('arm_deferred');
project.addDefine('arm_csm');
project.addDefine('rp_hdr');
project.addDefine('rp_renderer=Deferred');
project.addDefine('rp_depthprepass');
project.addDefine('rp_shadowmap');
project.addDefine('rp_shadowmap_cascade=1024');
project.addDefine('rp_shadowmap_cube=512');
project.addDefine('rp_background=World');
project.addDefine('rp_render_to_texture');
project.addDefine('rp_compositornodes');
project.addDefine('rp_antialiasing=SMAA');
project.addDefine('rp_supersampling=1');
project.addDefine('rp_ssgi=SSAO');
project.addDefine('rp_gi=Off');
project.addDefine('arm_shaderload');
project.addDefine('arm_soundcompress');
project.addDefine('arm_skin');
project.addDefine('arm_particles_gpu');
project.addDefine('arm_particles');


resolve(project);
