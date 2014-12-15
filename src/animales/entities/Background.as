/**
 * Created by Rolf on 11/18/14.
 */
package animales.entities {
import org.osflash.signals.Signal;

import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;

public class Background extends Sprite {
    public function Background($_assets:AssetManager, $_hasElements:Boolean) {
        super();
        _assets = $_assets;
        _hasElements = $_hasElements;
        addEventListener(Event.ADDED_TO_STAGE, initialize)
    }

    private var _assets:AssetManager;
    private var _hasElements:Boolean;
    private var index:int;
    private var currentBG:Image;

    protected function initialize(e:Event):void {
        index = Math.floor(Math.random() * 10);
        touchable = false;
        createBG();
        if(_hasElements){
            addEventListener(TouchEvent.TOUCH, handleTouchForZones);
        }else{
            addEventListener(TouchEvent.TOUCH, handleTouch);
        }
    }

    private function createBG():void {
        var bg:Image = new Image(_assets.getTexture('fondo' + (index + 1)));
        bg.alpha = 0;
//        bg.scaleX = 2;
//        bg.scaleY = 2;
        addChild(bg);
        Starling.juggler.tween(
                bg,
                .5,
                {
                    alpha: 1,
                    onComplete: transitionCompleted,
                    onCompleteArgs: [bg]
                }
        );
    }

    private function transitionCompleted(image:Image):void {
        enableTouch();
        if (currentBG)
            currentBG.removeFromParent(true);
        currentBG = image;
    }

    private function increaseIndex():void {
        index++;
        if (index == 10) {
            index = 0;
        }
    }

    private function enableTouch():void {
        touchable = true;
    }

    private function handleTouch(event:TouchEvent):void {
        if(event.getTouch(this,TouchPhase.ENDED)){
            transitionToNewBG();
        }
    }

    private function transitionToNewBG():void {
        touchable = false;
        increaseIndex();
        createBG();
    }

    private var _touchedRight:Signal = new Signal(String);
    private var _touchedLEFT:Signal = new Signal(String);

    public function get touchedLEFT():Signal {
        return _touchedLEFT;
    }

    public function get touchedRight():Signal {
        return _touchedRight;
    }

    private function handleTouchForZones(event:TouchEvent):void{
        var ended:Touch;
        if((ended=event.getTouch(this,TouchPhase.ENDED))!=null){
            const UNIT:Number = Starling.current.stage.stageWidth / 3;
            if( ended.globalX < UNIT ){
                // left
                _touchedLEFT.dispatch(LEFT);
            }
            else if ( ended.globalX < UNIT * 2){
                // center
                transitionToNewBG();
            }
            else{
                // right
                _touchedRight.dispatch(RIGHT);
            }

        }
    }
    public static const LEFT:String = 'left';
    public static const RIGHT:String = 'right';

}
}
