/**
 * Created by Rolf on 11/20/14.
 */
package animales.managers {
import animales.data.Coord;
import animales.data.GameState;
import animales.entities.Piece2D;

import starling.core.Starling;

import starling.display.Sprite;
import starling.utils.AssetManager;

public class PiecesManager2D {
    public function PiecesManager2D($_index:int, $_pieceLayer:Sprite, $_type:String, $_assets:AssetManager, $_shadowLayer:Sprite) {
        _assets = $_assets;
        _layerPiece = $_pieceLayer;
        _layerShadow = $_shadowLayer;
        _type = $_type;
        _index = $_index;

        setPieces();
    }

    private function setPieces():void {
        pieces = new Vector.<Piece2D>(2);

        pieces[0] = createPiece(_index, _type);
        pieces[0].touchable = true;
        pieces[0].view.alpha = 1;
        inc();
        pieces[1] = createPiece(_index, _type);
        pieces[1].touchable = false;
        pieces[1].view.alpha = 0;

        _layerPiece.addChild(pieces[1].view);
        _layerPiece.addChild(pieces[0].view);
        // Shadows
        if(pieces[0].hasShadow)_layerShadow.addChild(pieces[0].shadowView);
        if(pieces[1].hasShadow)_layerShadow.addChild(pieces[1].shadowView);

    }
    private var _type:String;
    private var _layerPiece:Sprite;
    private var _layerShadow:Sprite;
    private var _index:int;
    private var pieces:Vector.<Piece2D>;
    private var _assets:AssetManager;

    private function createPiece(index:int, $_type:String):Piece2D {
        var piece:Piece2D;
        var animalname:String;
        var partname:String;
        var offset:Object;
        animalname = GameState.names[index];
        partname = animalname + $_type;
        offset = _assets.getObject('offsets')[partname];
        piece = new Piece2D(partname, offset,_assets);
        piece.type = $_type;
        piece.index = index;
        piece.moved.add(pieceMoved);
        piece.ended.add(pieceEnded);
        piece.began.add(pieceBegan);

        return piece;
    }

    private function pieceBegan():void {
        _layerPiece.setChildIndex(pieces[1].view, _layerPiece.numChildren - 1);
        _layerPiece.setChildIndex(pieces[0].view, _layerPiece.numChildren - 1);
    }

    private function pieceMoved(c:Coord):void {
        var alpha:Number = c.distance / 300;
        alpha = alpha < 1 ? alpha : 1;
        pieces[1].moveTo(
                c.x * .66,
                c.y * .66,
                -c.distance * .66,
                alpha
        );
    }

    private function pieceEnded(c:Coord):void {
        // If distance is more than 400, then create a new piece and dispose [0]
        // Else move everything to 0,0
        if (c.distance > 400) {
            pieces[0].moveTo(pieces[0].view.x * 1.5, pieces[0].view.y * 1.5, 0, .5);
            pieces[1].moveTo(0, 0, 1, .25);

            pieces[0].touchable = false;

            Starling.juggler.delayCall(function(piece:Piece2D):void{
                piece.dispose();
            },1,pieces[0]);

            pieces.shift();

            inc();
            _layerPiece.addChildAt( (pieces[1] =createPiece(_index, _type)).view, _layerPiece.getChildIndex(pieces[0].view)-1 );

            pieces[1].view.alpha = 0;
            pieces[1].touchable = false;
            if(pieces[1].hasShadow)_layerShadow.addChild(pieces[1].shadowView);

            pieces[0].touchable = true;

        }
        else {
            pieces[0].moveTo(0, 0, 1, .25);
            pieces[1].moveTo(0, 0, 0, .25);
        }
    }

    private function inc():void {
        _index++;
        if (_index == 10)_index = 0;
    }

    public function get index():int {
        return _index;
    }

    public function get type():String {
        return _type;
    }
}
}
