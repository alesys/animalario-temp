/**
 * Created by Rolf on 11/18/14.
 */
package animales.entities {
import animales.data.GameState;

import feathers.controls.Screen;

import starling.animation.Juggler;
import starling.animation.Transitions;
import starling.core.Starling;

import starling.utils.AssetManager;
import starling.utils.deg2rad;

public class Elementos extends Screen {
    public function Elementos($_assets:AssetManager) {
        super();
        _assets = $_assets;
    }

    private var _assets:AssetManager;
    private var left:Elemento;
    private var right:Elemento;
    private const MAX:int = 10;
    override protected function initialize():void {
        super.initialize();

        var index:int = Math.floor(Math.random() * GameState.elementos.length);


        left = new Elemento(
                _assets,
                index,
                Elemento.LEFT
        );
        addChild(left.view);

        right = new Elemento(
                _assets,
                index,
                Elemento.RIGHT
        );

        addChild(right.view);

    }

    public function switchLeft():void {
        if(!leftCanTransition) return;
        trace('Elementos.switchLeft');
        var newLeft:Elemento;
        var newIndex:int = left.index+1;
        if(newIndex==MAX){
            newIndex = 0;
        }
        newLeft = new Elemento(
                _assets,
                newIndex,
                Elemento.LEFT
        );
        newLeft.view.rotationY = deg2rad(-90);
        newLeft.view.alpha = 0;

        addChild(newLeft.view);
        /**
         * Transitions of both
         */
        const DURATION:Number = .5;

        Starling.juggler.removeTweens(left.view);
        Starling.juggler.removeTweens(newLeft.view);

        Starling.juggler.tween(left.view,DURATION,{alpha:0,rotationY:deg2rad(90),transition:Transitions.EASE_IN_OUT,onCompleteArgs:[left],onComplete:function($_target:Elemento):void{$_target.kill();}});
        Starling.juggler.tween(newLeft.view,DURATION,{alpha:1,rotationY:0,transition:Transitions.EASE_OUT_BACK,onComplete:function():void{leftCanTransition=true}});

        left = newLeft;
        leftCanTransition = false;
    }
    private var leftCanTransition:Boolean = true;
    private var rightCanTransition:Boolean = true;

    public function switchRight():void {
        if(!rightCanTransition)return;
        trace('Elementos.switchRight');
        var newRight:Elemento;
        var newIndex:int = right.index+1;
        if(newIndex==MAX) newIndex=0;
        newRight = new Elemento(
                _assets,
                newIndex,
                Elemento.RIGHT);
        newRight.view.rotationY = deg2rad(-90);
        newRight.view.alpha = 0;
        addChild(newRight.view);
        /**
         * Transitions of both
         */
        const DURATION:Number = .5;

        Starling.juggler.removeTweens(right.view);

        Starling.juggler.tween(right.view,DURATION,{alpha:0,rotationY:deg2rad(90),transition:Transitions.EASE_IN_OUT,onCompleteArgs:[right],onComplete:function($_target:Elemento):void{$_target.kill();}});
        Starling.juggler.tween(newRight.view,DURATION,{alpha:1,rotationY:0,transition:Transitions.EASE_OUT_BACK,onComplete:function():void{rightCanTransition=true}});

        right = newRight;
        rightCanTransition = false;
    }
}
}
