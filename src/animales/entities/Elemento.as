/**
 * Created by Rolf on 11/18/14.
 */
package animales.entities {
import animales.data.GameState;

import starling.core.Starling;
import starling.display.BlendMode;

import starling.display.Image;
import starling.display.Sprite3D;
import starling.utils.AssetManager;
import starling.utils.HAlign;
import starling.utils.VAlign;

public class Elemento {
    public static const LEFT:String = '_left';
    public static const RIGHT:String = '_right';
    private var _position:String;
    private var _index:int;
    public function Elemento($_assets:AssetManager, $_index:int, $_position:String) {
        _position = $_position;
        _index = $_index;
        createView($_assets,$_index);
    }

    private function createView($_assets:AssetManager, $_index:int):void {
        var partname:String = GameState.elementos[$_index]+_position;
        var blending:String = $_assets.getObject('elementos')['blending'][partname];
        var img:Image = new Image($_assets.getTexture(partname));
        img.scaleX = 2;
        img.scaleY = 2;
        trace(blending);
        if(blending=='multiply'){
            img.blendMode=BlendMode.MULTIPLY;
            img.alpha=.8;
        }else{
            img.alpha=.6;
        }
        _view = new Sprite3D();
        _view.addChild(img);
        _view.touchable = false;


        /**
         * Align horizontal
         */
        switch(_position){
            case LEFT:
                _view.x = 0;
                break;
            case RIGHT:
                img.alignPivot(HAlign.RIGHT,VAlign.TOP);
                _view.x = Starling.current.stage.stageWidth;
                break;
        }
        /**
         * Align vertical
         */
        switch ($_assets.getObject('elementos')['anchor'][partname]){
            case 'top':
                _view.y = 0;
                break;
            case 'middle':
                _view.y = Starling.current.stage.stageHeight-view.height>>1;
                break;
            case 'bottom':
                _view.y = Starling.current.stage.stageHeight-view.height;
                break;
        }

    }
    private var _view:Sprite3D;
    public function get view():Sprite3D{
        return _view;
    }

    public function get position():String {
        return _position;
    }

    public function get index():int {
        return _index;
    }

    public function kill():void {
        _view.removeFromParent(true);
    }
}
}
