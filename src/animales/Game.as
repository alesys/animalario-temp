/**
 * Created by Rolf on 11/17/14.
 */
package animales {
import feathers.controls.Screen;
import feathers.controls.ScreenNavigator;
import feathers.controls.ScreenNavigatorItem;

import flash.display3D.Context3DTextureFormat;

import flash.filesystem.File;

import starling.display.DisplayObject;

import starling.utils.AssetManager;


public class Game extends Screen {
    public function Game() {
        super();
    }
    private var _assets:AssetManager;
    private var _navigation:ScreenNavigator;

    public static const SCREEN_HOME:String = 'home';
    public static const SCREEN_LEVEL:String = 'level';

    override protected function initialize():void {
        super.initialize();
        alpha = 0.999;
        _assets = new AssetManager(.5);
        _assets.enqueue(File.applicationDirectory.resolvePath('assets/data'));
//        _assets.textureFormat = Context3DTextureFormat.BGRA_PACKED;
        _assets.textureFormat = Context3DTextureFormat.BGRA;
        _assets.enqueue(File.applicationDirectory.resolvePath('assets/animales'));
//        _assets.enqueue(File.applicationDirectory.resolvePath('assets/elementos'));
        _assets.textureFormat = Context3DTextureFormat.BGR_PACKED;
        _assets.enqueue(File.applicationDirectory.resolvePath('assets/fondos'));
        _assets.loadQueue(function(r:Number):void{
            if(r==1){
                assetsLoaded();
            }
        });

    }

    private function assetsLoaded():void {
        _navigation = new ScreenNavigator();
        _navigation.addScreen(
                SCREEN_LEVEL,
                new ScreenNavigatorItem(
                        new Level(this)
                )
        );
        addChild(_navigation);
        showScreen(SCREEN_LEVEL);
    }

    public function get assets():AssetManager {
        return _assets;
    }

    public function showScreen(id:String, transition:Function = null):DisplayObject {
        return _navigation.showScreen(id, transition);
    }

    public function clearScreen(transition:Function = null):void {
        _navigation.clearScreen(transition);
    }
}
}
