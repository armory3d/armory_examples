Simple Network Zui Chat Example:

- Red nodes are for system host targets
- Teal nodes are for system and html browser client targets

** If you plan on using 3rd party server / client configuration please keep in mind our nodes use bytes and buffers even for regular strings

** Once a buffer is read it is not accessible any more, meaning if a msg parser node matches the same API field the buffer will be read and converted back into its data type

** Both host nodes and client nodes are allowed on the same node tree however browser html targets are not capable of being hosts. A browser cannot create/listen to TCP/UDP ports) so any host related nodes will be ignored when targeting html browsers

** System server *targets (like hashlink C for desktop/mobile) are intended to basically turn your desktop/mobile device into a server to which you can connect to with either another client instance on desktop/mobile or with a browser instance only as a client. 

```
C targets = host / client
Browser = only client
Krom = N/A (for now)
```  

Introduction to Networking in Armory 3D | Overview of all nodes 
https://www.youtube.com/watch?t=135&v=ZmaG_JFmn0Q&feature=youtu.be
