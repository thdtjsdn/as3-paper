package org.flashgate.display.gpu.paper {
import flash.utils.ByteArray;

public class PaperSprite extends PaperContainer {

    // Update flags
    internal static const NONE:uint = 0;

    internal static const COORDS:uint = 0x01;
    internal static const TEXTURE:uint = 0x02;
    internal static const ALPHA:uint = 0x04;
    internal static const VERTEX:uint = 0xff;

    internal static const INDEX:uint = 0x100;
    internal static const MATRIX:uint = 0x200;

    internal static const RENDER:uint = 0x10000;

    // Internal
    internal var _parent:PaperContainer;
    internal var _layer:PaperLayer;
    internal var _vertex:int;
    internal var _index:int;

    // Transformation matrix
    internal var _a:Number = 1;
    internal var _b:Number = 0;
    internal var _c:Number = 0;
    internal var _d:Number = 1;
    internal var _e:Number = 0;
    internal var _f:Number = 0;

    // Position
    internal var _x:Number = 0;
    internal var _y:Number = 0;

    // Scale
    internal var _sx:Number = 1;
    internal var _sy:Number = 1;

    // Rotation
    internal var _r:Number = 0;
    internal var _ry:Number = 0;
    internal var _rx:Number = 1;

    // Size
    private var _width:Number = 100;
    private var _height:Number = 100;

    // Texture
    internal var _alpha:Number;
    internal var _texture:PaperTexture;

    // Transformation point
    internal var _cx:Number = 0.5;
    internal var _cy:Number = 0.5;

    // Flags
    internal var _update:uint;

    public function PaperSprite() {
        super();
    }

    public function render():void {
        if (_layer) {
            _update & MATRIX && updateTransformationMatrix();
            trace("upd vertex = " +(_update & VERTEX));
            if (_update & VERTEX) {
                trace("upd vertex = " +(_update & COORDS)+ " "+(VERTEX & COORDS));
                _update & COORDS && writeCoords();
                _update & TEXTURE && writeTexture();
                _update & ALPHA && writeAlpha();
            }
            _update & INDEX && writeIndex();
            _update &= RENDER;
        }
    }

    [Inline]
    final public function get parent():PaperContainer {
        return _parent;
    }

    [Inline]
    final public function get layer():PaperLayer {
        return _layer;
    }

    [Inline]
    final public function get x():Number {
        return _x;
    }

    public function set x(value:Number):void {
        if (_x != value) {
            _x = value;
            _update |= MATRIX;
        }
    }

    [Inline]
    final public function get y():Number {
        return _y;
    }

    public function set y(value:Number):void {
        if (_y != value) {
            _y = value;
            _update |= MATRIX;
        }
    }

    [Inline]
    final public function get scaleX():Number {
        return _sx;
    }

    public function set scaleX(value:Number):void {
        if (_sx != value) {
            _sx = value;
            _update |= MATRIX;
        }
    }

    [Inline]
    final public function get scaleY():Number {
        return _sy;
    }

    public function set scaleY(value:Number):void {
        if (_sy != value) {
            _sy = value;
            _update |= MATRIX;
        }
    }

    public function set scale(value:Number):void {
        if (_sx != value || _sy != value) {
            _sx = value;
            _sy = value;
            _update |= MATRIX;
        }
    }

    [Inline]
    final public function get alpha():Number {
        return _alpha;
    }

    public function set alpha(value:Number):void {
        if (_alpha != value) {
            _alpha = value;
            _update |= ALPHA;
        }
    }

    [Inline]
    final public function get rotation():Number {
        return _r;
    }

    public function set rotation(value:Number):void {
        if (_r != value) {
            _r = value;
            _rx = Math.cos(value);
            _ry = Math.sin(value);
            _update |= MATRIX;
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

    public function set width(value:Number):void {
        if (_width != value) {
            _width = value;
            _update |= COORDS;
        }
    }

    public function set height(value:Number):void {
        if (_height != value) {
            _height = value;
            _update |= COORDS;
        }
    }

    public function setSize(width:Number, height:Number):void {
        if (_width != width || _height != height) {
            _width = width;
            _height = height;
            _update |= COORDS;
        }
    }

    [Inline]
    final public function get texture():PaperTexture {
        return _texture;
    }

    public function set texture(texture:PaperTexture):void {
        if (_texture != texture) {
            _texture = texture;
            setSize(_texture.width, _texture.height);
            _update |= TEXTURE;
        }
    }

    public function setTransformationPoint(x:Number, y:Number):void {
        if (_cx != x || _cy != y) {
            _cx = x;
            _cy = y;
            _update |= COORDS;
        }
    }

    override public function dispose():void {
        if (_parent) {
            _parent.unattachSprite(this);
            _parent = null;
        }

        _layer && _layer.releaseSprite(this);
        _texture = null;
        super.dispose();
    }

    protected function updateTransformationMatrix():void {
        _a = _sx * _rx;
        _b = _sx * _ry;
        _c = -_sy * _ry;
        _d = _sy * _rx;
        _e = _x;
        _f = _y;

        var parent:PaperSprite = _parent as PaperSprite;
        parent && multiplyTransformationMatrix(parent._a, parent._b, parent._c, parent._d, parent._e, parent._f);

        trace("updateTransformationMatrix");
    }

    protected function multiplyTransformationMatrix(a:Number, b:Number, c:Number, d:Number, e:Number, f:Number):void {
        var oa:Number = _a;
        var ob:Number = _b;
        var oc:Number = _c;
        var od:Number = _d;
        var oe:Number = _e;
        var of:Number = _f;

        _a = a * oa + c * ob;
        _b = b * oa + d * ob;
        _c = a * oc + c * od;
        _d = b * oc + d * od;
        _e = a * oe + c * of + e;
        _f = b * oe + d * of + f;
    }

    protected function writeCoords():void {
        var vertices:ByteArray = _layer.vertices;
        var offset:int = (_layer.attributes - 2) << 2;

        var left:Number = -_cx * _texture.width;
        var top:Number = -_cy * _texture.height;
        var right:Number = (1 - _cx) * _texture.width;
        var bottom:Number = (1 - _cy) * _texture.height;

        var al:Number = _a * left;
        var bl:Number = _b * left;
        var ar:Number = _a * right;
        var br:Number = _b * right;
        var ct:Number = _c * top + _e;
        var dt:Number = _d * top + _f;
        var cb:Number = _c * bottom + _e;
        var db:Number = _d * bottom + _f;

        vertices.position = _vertex;
        vertices.writeFloat(al + cb);
        vertices.writeFloat(bl + db);
        vertices.position += offset;
        vertices.writeFloat(ar + cb);
        vertices.writeFloat(br + db);
        vertices.position += offset;
        vertices.writeFloat(ar + ct);
        vertices.writeFloat(br + dt);
        vertices.position += offset;
        vertices.writeFloat(al + ct);
        vertices.writeFloat(bl + dt);

        trace("writeCoords");
    }

    protected function writeTexture():void {
        var vertices:ByteArray = _layer.vertices;
        var offset:int = (_layer.attributes - 2) << 2;

        var left:Number = _texture.left;
        var top:Number = _texture.top;
        var right:Number = _texture.right;
        var bottom:Number = _texture.bottom;

        vertices.position = _vertex + 8;
        vertices.writeFloat(left);
        vertices.writeFloat(top);
        vertices.position += offset;
        vertices.writeFloat(right);
        vertices.writeFloat(top);
        vertices.position += offset;
        vertices.writeFloat(right);
        vertices.writeFloat(bottom);
        vertices.position += offset;
        vertices.writeFloat(left);
        vertices.writeFloat(bottom);
        trace("writeTexture");
    }

    protected function writeAlpha():void {
        var vertices:ByteArray = _layer.vertices;
        var offset:int = (_layer.attributes - 1) << 2;

        vertices.position = _vertex + 16;
        vertices.writeFloat(_alpha);
        vertices.position += offset;
        vertices.writeFloat(_alpha);
        vertices.position += offset;
        vertices.writeFloat(_alpha);
        vertices.position += offset;
        vertices.writeFloat(_alpha);

        trace("writeAlpha");
    }

    protected function writeIndex():void {
        var indices:ByteArray = _layer.indices;
        var vertex:int = (_vertex / _layer.attributes) >> 2;

        indices.position = _index;
        indices.writeShort(vertex);
        indices.writeShort(vertex + 1);
        indices.writeShort(vertex + 2);
        indices.writeShort(vertex + 2);
        indices.writeShort(vertex + 3);
        indices.writeShort(vertex);

        trace("writeIndex");
    }

}
}
