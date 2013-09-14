package org.flashgate.display.gpu.paper.sprite {
import org.flashgate.display.gpu.paper.*;

public class PaperSprite extends PaperSpriteContainer {

    // Update flags
    public static const WRITE_VERTEX:int = 0xff;
    public static const WRITE_POSITION:int = 0x01;
    public static const WRITE_TEXTURE:int = 0x02;
    public static const WRITE_ALPHA:int = 0x04;

    public static const WRITE_INDEX:int = 0xff00;

    public static const UPDATE_GLOBAL_MATRIX:int = 0x1;
    public static const UPDATE_MATRIX:int = 0x4;
    public static const UPDATE_POSITION:int = 0x8;

    public static const UPDATE_SIZE:int = 0x2;
    public static const UPDATE_ALPHA:int = 0x2;
    public static const UPDATE_TEXTURE:int = 0x2;

    // Texture
    private static const DEFAULT_TEXTURE:PaperSpriteTexture = new PaperSpriteTexture(0, 0, 0, 0);

    // Internal
    private var _parent:PaperSpriteContainer;

    internal var layer:PaperSpriteLayer;
    internal var vertex:int = -1;
    internal var index:int = -1;

    // Local transformation matrix
    private var _local:PaperMatrix = new PaperMatrix();
    private var _global:PaperMatrix;

    // Scale
    private var _sx:Number = 1;
    private var _sy:Number = 1;

    // Rotation
    private var _r:Number = 0;
    private var _ry:Number = 0;
    private var _rx:Number = 1;

    // Size
    private var _width:Number = 0;
    private var _height:Number = 0;

    // Texture
    private var _texture:PaperSpriteTexture = DEFAULT_TEXTURE;
    private var _alpha:Number = 1;
    private var _visible:Boolean = true;

    // Transformation point
    private var _tx:Number = 0.5;
    private var _ty:Number = 0.5;

    // Flags
    private var _update:int;

    public function PaperSprite() {
        super();
    }

    override public function addChild(item:PaperSprite):PaperSprite {
        return item == this ? null : super.addChild(item);
    }

    override public function addChildAt(item:PaperSprite, index:int):PaperSprite {
        return item == this ? null : super.addChildAt(item, index);
    }

    [Inline]
    final public function get parent():PaperSpriteContainer {
        return _parent;
    }

    [Inline]
    final public function get x():Number {
        return _local.x;
    }

    [Inline]
    final public function set x(value:Number):void {
        if (_local.x != value) {
            _local.x = value;
            invalidatePosition();
        }
    }

    [Inline]
    final public function get y():Number {
        return _local.y;
    }

    [Inline]
    final public function set y(value:Number):void {
        if (_local.y != value) {
            _local.y = value;
            invalidatePosition();
        }
    }

    [Inline]
    final public function setPosition(x:Number, y:Number):void {
        if (_local.x != x || _local.y != y) {
            _local.x = x;
            _local.y = y;
            invalidatePosition();
        }
    }

    [Inline]
    final public function get scaleX():Number {
        return _sx;
    }

    [Inline]
    final public function set scaleX(value:Number):void {
        if (_sx != value) {
            _sx = value;
            invalidateMatrix();
        }
    }

    [Inline]
    final public function get scaleY():Number {
        return _sy;
    }

    [Inline]
    final public function set scaleY(value:Number):void {
        if (_sy != value) {
            _sy = value;
            invalidateMatrix();
        }
    }

    [Inline]
    final public function setScale(scaleX:Number, scaleY:Number):void {
        if (_sx != scaleX || _sy != scaleY) {
            _sx = scaleX;
            _sy = scaleY;
            invalidateMatrix();
        }
    }

    [Inline]
    final public function get alpha():Number {
        return _alpha;
    }

    [Inline]
    final public function set alpha(value:Number):void {
        if (_alpha != value) {
            _alpha = value;
            invalidateAlpha();
        }
    }

    [Inline]
    final public function get visible():Boolean {
        return _visible;
    }

    [Inline]
    final public function set visible(value:Boolean):void {
        if (_visible != value) {
            _visible = value;
            layer && layer.invalidateSorting();
        }
    }

    [Inline]
    final public function get rotation():Number {
        return _r;
    }

    [Inline]
    final public function set rotation(value:Number):void {
        if (_r != value) {
            _r = value;
            _rx = Math.cos(value);
            _ry = Math.sin(value);
            invalidateMatrix();
        }
    }

    [Inline]
    final public function get width():Number {
        return _width;
    }

    [Inline]
    final public function get height():Number {
        return _height;
    }

    [Inline]
    final public function set width(value:Number):void {
        if (_width != value) {
            _width = value;
            invalidateSize();
        }
    }

    [Inline]
    final public function set height(value:Number):void {
        if (_height != value) {
            _height = value;
            invalidateSize();
        }
    }

    [Inline]
    final public function setSize(width:Number, height:Number):void {
        if (_width != width || _height != height) {
            _width = width;
            _height = height;
            invalidateSize();
        }
    }

    [Inline]
    final public function get texture():PaperSpriteTexture {
        return _texture;
    }

    [Inline]
    final public function set texture(texture:PaperSpriteTexture):void {
        if (texture == null) {
            texture = DEFAULT_TEXTURE;
        }
        if (_texture != texture) {
            _texture = texture;
            invalidateTexture();
        }
    }

    [Inline]
    final public function get transformX():Number {
        return _tx;
    }

    [Inline]
    final public function get transformY():Number {
        return _ty;
    }

    [Inline]
    final public function setTransformationPoint(transformX:Number, transformY:Number):void {
        if (_tx != transformX || _ty != transformY) {
            _tx = transformX;
            _ty = transformY;
            invalidateGlobalMatrix();
        }
    }

    [Inline]
    final public function get matrix():PaperMatrix {
        return _global || _local;
    }

    override public function dispose():void {
        super.dispose();
        layer && layer.detachSprite(vertex);
    }

    // protected ---------------------------

    [Inline]
    final protected function invalidatePosition():void {
        _update |= UPDATE_POSITION;
    }

    [Inline]
    final protected function invalidateGlobalMatrix():void {
        _update |= UPDATE_GLOBAL_MATRIX;
    }

    [Inline]
    final protected function invalidateMatrix():void {
        _update |= UPDATE_MATRIX;
    }

    [Inline]
    final protected function invalidateAlpha():void {
        _update |= UPDATE_ALPHA;
    }

    [Inline]
    final protected function invalidateSize():void {
        _update |= UPDATE_SIZE;
    }

    [Inline]
    final protected function invalidateTexture():void {
        _update |= UPDATE_TEXTURE;
    }

    // internal ---------------------------

    internal function setParent(parent:PaperSpriteContainer):void {
        if (_parent != parent) {
            _parent && _parent.detachChild(this);
            _parent = parent;
            _parent && _parent.attachChild(this);
        }
    }

    internal function updateLocalMatrix():void {
        _local.a = _sx * _rx;
        _local.b = _sx * _ry;
        _local.c = -_sy * _ry;
        _local.d = _sy * _rx;
        invalidateGlobalMatrix();
    }

    internal function updateGlobalMatrix():void {
        var sprite:PaperSprite = _parent as PaperSprite;
        _global = sprite ? sprite.matrix.transform(_local, _global) : null;

        if (items) {
            for each(sprite in items) {
                sprite.invalidateGlobalMatrix();
            }
        }
        invalidatePosition();
    }

}
}