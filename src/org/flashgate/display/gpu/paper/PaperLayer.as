package org.flashgate.display.gpu.paper {
import flash.display3D.Context3D;
import flash.display3D.Context3DVertexBufferFormat;
import flash.display3D.IndexBuffer3D;
import flash.display3D.VertexBuffer3D;
import flash.utils.ByteArray;
import flash.utils.Endian;

public class PaperLayer extends PaperContainer implements IPaperComponent {

    private var _context:Context3D;
    private var _vertexBuffer:VertexBuffer3D;
    private var _indexBuffer:IndexBuffer3D;

    private var _vertices:ByteArray = new ByteArray();
    private var _indices:ByteArray = new ByteArray();
    private var _attributes:int;
    private var _search:int;
    private var _triangles:int;

    private var _sprites:Vector.<PaperSprite>;
    private var _queue:Vector.<PaperContainer> = new Vector.<PaperContainer>();

    public function PaperLayer(size:int = 1, attributes:int = 5) {
        _attributes = attributes;
        _indices.endian = _vertices.endian = Endian.LITTLE_ENDIAN;
        _vertices.length = _attributes * 16 * size;
        _indices.length = 12 * size;
        _sprites = new Vector.<PaperSprite>(size);
    }

    public function upload(context:Context3D):void {
        if (_context != context) {
            _vertexBuffer && disposeVertexBuffer();
            _indexBuffer && disposeIndexBuffer();
            _context = context;
        }
        if (context) {
            render();
            uploadVertexBuffer(context);
            uploadIndexBuffer(context);
            draw(context);
        }
    }

    override public function dispose():void {
        super.dispose();
        _vertexBuffer && disposeVertexBuffer();
        _indexBuffer && disposeIndexBuffer();
        _context = null;
    }

    [Inline]
    final internal function get attributes():int {
        return _attributes;
    }

    [Inline]
    final internal function get indices():ByteArray {
        return _indices;
    }

    [Inline]
    final internal function get vertices():ByteArray {
        return _vertices;
    }

    internal function releaseSprite(sprite:PaperSprite):void {
        var vertex:int = sprite._vertex;
        if (vertex < _search) {
            _search = vertex;
        }
        _sprites[vertex] = null;
        sprite._layer = null;

        trace("release");
    }

    internal function attachSprite(sprite:PaperSprite):void {
        var count:int = _sprites.length;
        var i:int = _search;

        while (i < count) {
            if (_sprites[i]) {
                i++;
            } else {
                break;
            }
        }

        sprite._layer = this;
        sprite._vertex = _search = i;

        if (_search >= _sprites.length) {
            _vertexBuffer && disposeVertexBuffer();
            _indexBuffer && disposeIndexBuffer();
            _sprites.length <<= 1;
            _indices.length <<= 1;
            _vertices.length <<= 1;
        }

        trace("attach");
    }

    protected function render():void {
        var queue:Vector.<PaperContainer> = _queue;
        var container:PaperContainer;
        var list:Vector.<PaperSprite>;
        var sprite:PaperSprite;
        var update:uint;
        var index:int = 0;
        var level:int = 0;
        var count:int;
        var i:int;

        queue[level] = this;
        _iterator = 0;

        while (level >= 0) {
            container = queue[level];
            list = container._items;
            count = container.size();

            for (i = container._iterator; i < count; i++) {
                sprite = list[i];
                if (sprite) {
                    if (sprite._layer != this) {
                        attachSprite(sprite);
                        sprite._index = index;
                        sprite._update |= PaperSprite.VERTEX | PaperSprite.INDEX;

                    } else if (sprite._index != index) {
                        sprite._index = index;
                        sprite._update |= PaperSprite.INDEX;
                    }

                    // TODO: transformation update

                    if (sprite._texture) {
                        sprite._update && sprite.render();
                        index += 12;
                    }

                    if (sprite.size()) {
                        queue[++level] = sprite;
                        sprite._iterator = 0;
                        break;
                    }
                }
            }

            if (i >= count) {
                level--;
            } else {
                container._iterator = i;
            }
        }

        queue.length = 0;
        _triangles = index / 6;
    }

    protected function uploadVertexBuffer(context:Context3D):void {
        var count:int = _sprites.length << 2;
        if (_vertexBuffer) {
            // TODO: optimize upload
            _vertexBuffer.uploadFromByteArray(_vertices, 0, 0, count);
        } else {
            _vertexBuffer = context.createVertexBuffer(count, _attributes);
            _vertexBuffer.uploadFromByteArray(_vertices, 0, 0, count);
        }
    }

    protected function uploadIndexBuffer(context:Context3D):void {
        var count:int = _sprites.length * 6;
        if (_indexBuffer) {
            // TODO: optimize upload
            _indexBuffer.uploadFromByteArray(_indices, 0, 0, count);
        } else {
            _indexBuffer = context.createIndexBuffer(count);
            _indexBuffer.uploadFromByteArray(_indices, 0, 0, count);
        }
    }

    protected function draw(context:Context3D):void {
        context.setVertexBufferAt(0, _vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
        context.setVertexBufferAt(1, _vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_3);
        context.drawTriangles(_indexBuffer, 0, _triangles);
    }

    protected function disposeVertexBuffer():void {
        _vertexBuffer.dispose();
        _vertexBuffer = null;
    }

    protected function disposeIndexBuffer():void {
        _indexBuffer.dispose();
        _indexBuffer = null;
    }

}
}