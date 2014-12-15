/**
 * Created by Rolf on 11/20/14.
 */
package animales.entities {
import animales.data.Coord;

import flash.geom.Point;

import org.osflash.signals.Signal;

import starling.animation.Transitions;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.filters.BlurFilter;
import starling.textures.Texture;
import starling.utils.AssetManager;

public class Piece2D {
    public function Piece2D($_name:String, $_offset:Object, $_assets:AssetManager) {
        _name = $_name;
        createView();
        createImg($_assets.getTexture($_name), $_offset);
        createArea($_offset, $_assets.getTexture('spacer'));
        createBright();
        _hasShadow = $_offset.shadowTexture != undefined;
        if (hasShadow) {
            createShadow($_assets.getTexture($_offset.shadowTexture), $_offset.shadowX, $_offset.shadowY);
        }
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

    private var _view:Sprite;

    public function get view():Sprite {
        return _view;
    }

    private var _name:String;

    public function get name():String {
        return _name;
    }

    private var _hasShadow:Boolean;

    public function get hasShadow():Boolean {
        return _hasShadow;
    }

    private var _shadowView:Image;

    public function get shadowView():Image {
        return _shadowView;
    }

    public function dispose():void {
        if (_view.parent)_view.removeFromParent(true);
        if (_hasShadow && _shadowView.parent) _shadowView.removeFromParent(true);
        else _view.dispose();
        _began.removeAll();
        _began = null;
        _moved.removeAll();
        _moved = null;
        _ended.removeAll();
        _ended = null;
    }

    public function moveTo($_x:Number, $_y:Number, $_alpha:Number = 1, $_time:Number = .25 >> 1):void {
        Starling.juggler.removeTweens(_view);
        Starling.juggler.tween(
                _view,
                $_time,
                {
                    x: $_x,
                    y: $_y,
                    alpha: $_alpha,
                    transition: Transitions.EASE_OUT
                }
        );
    }

    public function createShadow($_shadowTexture:Texture, shadowX:int, shadowY:int):void {
        _shadowView = new Image($_shadowTexture);
        _shadowView.pivotX = shadowX;
        _shadowView.pivotY = shadowY;
    }

    private function createView():void {
        _view = new Sprite();
        _view.addEventListener(EnterFrameEvent.ENTER_FRAME, update);
    }

    private function createArea($_offset:Object,$_spacerTexture:Texture):void {
//        var area:Quad = new Quad($_offset.areaW, $_offset.areaH, 0xff0000);
        var area:Image = new Image($_spacerTexture);
        area.width = $_offset.areaW;
        area.height = $_offset.areaH;
        area.alpha = 0;
        area.pivotX = $_offset.areaX / area.scaleX;
        area.pivotY = $_offset.areaY / area.scaleY;
        area.addEventListener(TouchEvent.TOUCH, handleTouch);
        _view.addChild(area);
    }
    private var _img:Image;
    private function createImg($_texture:Texture, $_offset:Object):void {
        _img = new Image($_texture);
        _img.pivotX = $_offset.x;
        _img.pivotY = $_offset.y;
        _img.touchable = false;
        _view.addChild(_img);
    }

    private function handleTouch(event:TouchEvent):void {
        var began:Touch = event.getTouch(event.currentTarget as DisplayObject, TouchPhase.BEGAN);
        var moved:Touch = event.getTouch(event.currentTarget as DisplayObject, TouchPhase.MOVED);
        var ended:Touch = event.getTouch(event.currentTarget as DisplayObject, TouchPhase.ENDED);

        if (began) {
            pointA.x = began.globalX;
            pointA.y = began.globalY;
            applyBright();
            _began.dispatch();
        }
        else if (moved) {
            pointB.x = moved.globalX;
            pointB.y = moved.globalY;

            coord.x = pointB.x - pointA.x;
            coord.y = pointB.y - pointA.y;
            coord.distance = Point.distance(pointA, pointB);

            moveTo(coord.x, coord.y);

            _moved.dispatch(coord);

        }
        else if (ended) {
            pointB.x = ended.globalX;
            pointB.y = ended.globalY;

            cancelBright();

            coord.x = pointB.x - pointA.x;
            coord.y = pointB.y - pointA.y;
            coord.distance = Point.distance(pointA, pointB);

            _ended.dispatch(coord);

        }
    }

    private function applyBright():void {
        _img.filter = _filterBright;
    }
    private function cancelBright():void {
        _img.filter = null;
    }
    private var _filterBright:BlurFilter;
    private function createBright():void {
        _filterBright = BlurFilter.createGlow(0xffef7a,1,15,.5);
    }

    private function update(event:EnterFrameEvent):void {
        if (_view){
            _view.visible = _view.alpha>0.1;
            if(_shadowView){
                _shadowView.visible = _view.visible;
                if(_shadowView.visible){
                    _shadowView.alpha = _view.alpha;
                    _shadowView.x = _view.x;
                    _shadowView.y = _view.y;
                }
            }
        }
    }
}
}
