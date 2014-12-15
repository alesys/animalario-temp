/**
 * Created by Rolf on 11/17/14.
 */
package animales.entities {
import animales.managers.PiecesManager2D;

import starling.core.Starling;
import starling.display.Sprite;
import starling.filters.BlurFilter;
import starling.utils.AssetManager;

public class Animal {
    private static const PART_HEAD:String = '_cabeza';
    private static const PART_LEFT:String = '_izq';
    private static const PART_RIGHT:String = '_der';

    private var _layerShadow:Sprite;
    private var _layerAnimal:Sprite;

    public function Animal($_assets:AssetManager) {
        super();
        createLayers();
        createAnimal($_assets);
    }

    private function createLayers():void{
        var filter:BlurFilter;
        filter = new BlurFilter(18,18,2);

        _layerAnimal = new Sprite();
        _layerAnimal.x = Starling.current.stage.stageWidth >> 1;
        _layerAnimal.y = Starling.current.stage.stageHeight >> 1;

        _layerShadow = new Sprite();
        _layerShadow.alpha = .20;
        _layerShadow.filter = filter;
        _layerShadow.touchable = false;
        _layerShadow.x = _layerAnimal.x;
        _layerShadow.y = _layerAnimal.y;

    }
    private function createAnimal($_assets:AssetManager):void {
        var index:int = Math.floor(Math.random() * 10);
        new PiecesManager2D(index, _layerAnimal, PART_HEAD, $_assets, _layerShadow);
        new PiecesManager2D(index, _layerAnimal, PART_RIGHT, $_assets, _layerShadow);
        new PiecesManager2D(index, _layerAnimal, PART_LEFT, $_assets, _layerShadow);
    }

    public function get layerShadow():Sprite {
        return _layerShadow;
    }

    public function get layerAnimal():Sprite {
        return _layerAnimal;
    }
}
}
