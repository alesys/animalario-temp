/**
 * Created by Rolf on 11/18/14.
 */
package animales.managers {
import animales.data.Coord;
import animales.data.GameState;
import animales.entities.Piece3D;

import starling.core.Starling;

import starling.display.Sprite;
import starling.utils.AssetManager;

public class PiecesManager3D {
    public function PiecesManager3D($_index:int, $_root:Sprite, $_type:String, $_assets:AssetManager) {
        _assets = $_assets;
        _root = $_root;
        _type = $_type;
        _index = $_index;
        pieces = new Vector.<Piece3D>(3);

        pieces[0] = createPiece(_index, $_type);
        inc();
        pieces[1] = createPiece(_index, $_type);
        inc();
        pieces[2] = createPiece(_index, $_type);

        pieces[2].touchable = false;
        pieces[1].touchable = false;
        pieces[0].touchable = true;

        _root.addChild(pieces[2].view);
        _root.addChild(pieces[1].view);
        _root.addChild(pieces[0].view);

        pieces[0].view.alpha = 1;
        pieces[1].view.alpha = 0;
        pieces[2].view.alpha = 0;

    }

    private var _type:String;
    private var _root:Sprite;
    private var _index:int;
    private var pieces:Vector.<Piece3D>;
    private var _assets:AssetManager;

    private function createPiece(index:int, $_type:String):Piece3D {
        var piece:Piece3D;
        var animalname:String;
        var partname:String;
        var offset:Object;
        animalname = GameState.names[index];
        partname = animalname + $_type;
        offset = _assets.getObject('offsets')[partname];
        piece = new Piece3D(partname, _assets.getTexture(partname), offset);
        piece.type = $_type;
        piece.index = index;
        piece.moved.add(pieceMoved);
        piece.ended.add(pieceEnded);
        piece.began.add(pieceBegan);
        return piece;
    }

    private function pieceBegan():void {
        _root.setChildIndex(pieces[2].view, _root.numChildren - 1);
        _root.setChildIndex(pieces[1].view, _root.numChildren - 1);
        _root.setChildIndex(pieces[0].view, _root.numChildren - 1);
    }

    private function pieceMoved(c:Coord):void {
        // Only piece 0 can be moved
        var alpha:Number = c.distance / 300;
        alpha = alpha < 1 ? alpha : 1;
        pieces[1].moveTo(
                c.x * .66,
                c.y * .66,
                -c.distance * .66,
                alpha
        );
        pieces[2].moveTo(
                c.x * .33,
                c.y * .33,
                -c.distance * .33,
                alpha / 2
        );
    }

    private function pieceEnded(c:Coord):void {
        if (c.distance > 400) {
            pieces[0].moveTo(pieces[0].view.x * 1.5, pieces[0].view.y * 1.5, -c.distance * 1.5, 0, .5);
            pieces[1].moveTo(0, 0, 0, 1, .25);
            pieces[2].moveTo(0, 0, 0, 0, .25);

            pieces[0].touchable = false;

            Starling.juggler.delayCall(function(piece:Piece3D):void{
                piece.dispose();
            },1,pieces[0]);

            pieces.shift();

            inc();
            _root.addChildAt( (pieces[2] =createPiece(_index, _type)).view, _root.getChildIndex(pieces[1].view)-1 );

            pieces[2].view.alpha = 0;
            pieces[2].touchable = false;

            pieces[0].touchable = true;


        }
        else {
            pieces[0].moveTo(0, 0, 0, 1, .25);
            pieces[1].moveTo(0, 0, 0, 0, .25);
            pieces[2].moveTo(0, 0, 0, 0, .25);
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
