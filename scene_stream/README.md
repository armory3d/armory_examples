- Scene contains 3000+ unique, non-linked meshes, first build may take over 30 sec
- Far plane is set to 100 to visualize streaming
- Object is streamed at camera distance less than (far_plane * 1.1), and unloaded at distance over (far_plane * 1.5)
- Check debug console to see amount of objects loaded
- Mobile render path is set to focus on stream performance

- Only HTML5 streaming is multi-threaded currently
- Materials (and associated textures) are preloaded at scene startup
