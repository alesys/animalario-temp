/**
 * Created by Rolf on 11/18/14.
 */
package animales.entities {
import animales.data.Coord;

import flash.geom.Point;

import org.osflash.signals.Signal;

import starling.animation.Transitions;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite3D;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;

public class Piece3D {
    public function Piece3D($_name:String, $_texture:Texture, $_offset:Object) {
        _name = $_name;
        createView();
        createImg($_texture, $_offset);
        createArea($_offset);
    }

    public var index:int;
    public var type:String;
    private var pointA:Point = new Point();
    private var pointB:Point = new Point();
    private var coord:Coord = new Coord();

    public function get touchable():Boolean {
        return _view.touchable;
    }

    public function set touchable(value:Boolean):void {
        _view.touchable = value;
    }

    private var _moved:Signal = new Signal(Coord);

    public function get moved():Signal {
        return _moved;
    }

    private var _ended:Signal = new Signal(Coord);

    public function get ended():Signal {
        return _ended;
    }

    private var _began:Signal = new Signal();

    public function get began():Signal {
        return _began;
    }

    private var _view:Sprite3D;

    public function get view():Sprite3D {
        return _view;
    }

    private var _name:String;

    public function get name():String {
        return _name;
    }

    public function dispose():void {
        if (_view.parent)_view.removeFromParent(true);
        else _view.dispose();
        _began.removeAll();
        _began = null;
        _moved.removeAll();
        _moved = null;
        _ended.removeAll();
        _ended = null;
    }

    private function createView():void {
        _view = new Sprite3D();
    }

    private function createArea($_offset:Object):void {
        var area:Quad = new Quad($_offset.areaW, $_offset.areaH, 0xff0000);
        area.alpha = 0;
        area.pivotX = $_offset.areaX;
        area.pivotY = $_offset.areaY;
        area.addEventListener(TouchEvent.TOUCH, handleTouch);
        _view.addChild(area);
    }

    private function createImg($_texture:Texture, $_offset:Object):void {
        var img:Image = new Image($_texture);
        img.pivotX = $_offset.x;
        img.pivotY = $_offset.y;
        img.touchable = false;
        _view.addChild(img);
    }

    public function moveTo($_x:Number,$_y:Number,$_z:Number, $_alpha:Number=1, $_time:Number= .25>>1):void{
        Starling.juggler.removeTweens(_view);
        Starling.juggler.tween(
                _view,
                $_time,
                {
                    x: $_x,
                    y: $_y,
                    z: $_z,
                    alpha: $_alpha,
                    transition:Transitions.EASE_OUT
                }
        );
    }

    private function handleTouch(event:TouchEvent):void {
        var began:Touch = event.getTouch(event.currentTarget as DisplayObject, TouchPhase.BEGAN);
        var moved:Touch = event.getTouch(event.currentTarget as DisplayObject, TouchPhase.MOVED);
        var ended:Touch = event.getTouch(event.currentTarget as DisplayObject, TouchPhase.ENDED);

        if (began) {
            pointA.x = began.globalX;
            pointA.y = began.globalY;
            _began.dispatch();
        }
        else if (moved) {
            pointB.x = moved.globalX;
            pointB.y = moved.globalY;

            coord.x = pointB.x - pointA.x;
            coord.y = pointB.y - pointA.y;
            coord.distance = Point.distance(pointA, pointB);

            moveTo(coord.x,coord.y,-coord.distance);

            _moved.dispatch(coord);

        }
        else if (ended) {
            pointB.x = ended.globalX;
            pointB.y = ended.globalY;

//            moveTo(0,0,0,0.25);

            coord.x = pointB.x - pointA.x;
            coord.y = pointB.y - pointA.y;
            coord.distance = Point.distance(pointA, pointB);

            _ended.dispatch(coord);

        }
    }

}
}
