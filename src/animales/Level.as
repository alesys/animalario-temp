/**
 * Created by Rolf on 11/17/14.
 */
package animales {
import animales.entities.Animal;
import animales.entities.Background;
import animales.entities.Elementos;

import feathers.controls.Screen;

import starling.utils.AssetManager;

public class Level extends Screen {
    private var _game:Game;
    private var _assets:AssetManager;
    private var _hasElements:Boolean;
    public function Level($_game:Game) {
        super();
        _game = $_game;
        _assets = _game.assets;
        _hasElements = false;
    }

    override protected function initialize():void {
        super.initialize();
        createBG();
        createAnimal();
        if(_hasElements) createElements();
    }

    private var elementos:Elementos;
    private function createElements():void {
        elementos = new Elementos(_assets);
        addChild(elementos);
    }

    private function createBG():void {
        var bg:Background;
        bg = new Background(_assets, _hasElements);
        if(_hasElements){
            bg.touchedLEFT.add(handleTouched);
            bg.touchedRight.add(handleTouched);
        }
        addChild(bg);
    }

    private function handleTouched($_type:String):void{
        switch($_type){
            case Background.LEFT:
                elementos.switchLeft();
                break;
            case Background.RIGHT:
                elementos.switchRight();
                break;
        }
    }
    private function createAnimal():void {
        var animal:Animal;
        animal = new Animal(_assets);
        addChild(animal.layerAnimal);
        addChild(animal.layerShadow);

    }
}
}
