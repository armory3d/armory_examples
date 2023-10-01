package arm;

#if macro

import haxe.macro.Context;
import haxe.macro.Expr;
import iron.data.SceneFormat;
import iron.system.ArmPack;
import sys.FileSystem;
import sys.io.File;

using StringTools;
using haxe.io.Path;

class Macros {

    static function build() {
        var fields = Context.getBuildFields();
        var pos = Context.currentPos();
        var target = if( Context.defined('kha_krom') ) 'krom';
        else if( Context.defined('kha_html5') ) 'html5';
        else Context.fatalError('Only krom and html5 are supported targets for this project', pos );
        var dir = Sys.getCwd() + target;
        var files = FileSystem.readDirectory(dir);
        var sceneData : TSceneFormat = null;
        var meshes = new Array<String>();
        for( file in files ) {
            if( file == 'Scene.arm' ) {
                var p = '$dir/$file';
                sceneData = ArmPack.decode( File.getBytes(p) );
                trace(sceneData);
                trace(sceneData.name);
                for( obj in sceneData.objects ) {
                    if( obj.properties != null )
                        for( p in obj.properties ) trace(p.name +' = '+ p.value);
                    if( obj.type == 'mesh_object' )
                        meshes.push(obj.name);
                }
                break;
            }
        }

        var constructorExprs = new Array<Expr>();
        constructorExprs.push(macro super() );
        constructorExprs.push(macro notifyOnInit(init) );
        fields.push({
            access: [APublic,AInline],
            name: 'new',
            pos: pos,
            kind: FFun({
                args: [],
                ret:  macro: Void,
                expr: { expr: EBlock( constructorExprs ), pos: pos }
            }),
        });

        var initExprs = new Array<Expr>();
        initExprs.push( macro trace("Init") );
        for( mesh in meshes ) {
            fields.push({
                name: mesh,
                access: [APublic],
                kind: FVar(macro: iron.object.MeshObject, macro null),
                pos: pos
            });
            initExprs.push( macro this.$mesh = iron.Scene.active.getMesh($v{mesh}) );
        }
        initExprs.push( macro notifyOnUpdate(update) );
        
        fields.push({
            name: 'init',
            access: [],
            kind: FFun({
                args: [],
                ret: macro : Void,
                expr: { expr: EBlock( initExprs ), pos: Context.currentPos() }
            }),
            pos: pos
        });

        return fields;
    }
}

#end
