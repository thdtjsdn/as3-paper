package org.flashgate.display.gpu.paper {
public class PaperSprite {
    // Parent
    private var _parent:PaperSprite;
    private var _items:Vector<PaperSprite>;
    // Layer
    private var _layer:PaperLayer;
    private var _vertex:int;
    private var _index:int;
    // Global transformation matrix
    private var _a:Number;
    private var _b:Number;
    private var _c:Number;
    private var _d:Number;
    private var _e:Number;
    private var _f:Number;
    // Position
    private var _x:Number;
    private var _y:Number;
    private var _z:Number;
    // Size
    private var _width:Number;
    private var _height:Number;
    // Scale
    private var _sx:Number;
    private var _sy:Number;
    // Rotation
    private var _r:Number;
    private var _ry:Number;
    private var _rx:Number;
    // Texture
    private var _alpha:Number;
    private var _tl:Number = 0;
    private var _tt:Number = 0;
    private var _tr:Number = 0;
    private var _tb:Number = 0;
    // Points
    private var _cx:Number;
    private var _cy:Number;
    // Flags
    private var _updateTick:int;
    private var _updateTransform:Boolean;
    private var _updateCoords:Boolean;
    private var _updateBounds:Boolean;
    private var _updateTexture:Boolean;
    private var _updateRotation:Boolean;
    private var _updateAlpha:Boolean;
    private var _updateDepth:Boolean;
    private var _uploadVertex:Boolean;

    public function PaperSprite() {
    }

    public function addSprite( item:PaperSprite ):void {
    }

    public function removeSprite( item:PaperSprite ):void {
    }

    public function dispose() {

    }
}
}
