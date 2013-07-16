package org.flashgate.display.gpu.paper {
import flash.display3D.Context3D;
import flash.display3D.Context3DVertexBufferFormat;
import flash.display3D.IndexBuffer3D;
import flash.display3D.VertexBuffer3D;
import flash.utils.ByteArray;
import flash.utils.Endian;

public class PaperLayer implements IPaperComponent {

    private static const VERTEX_ATTRIBUTES : int = 6;

    private static const SPRITE_VERTICES : int = 4;
    private static const SPRITE_INDICES : int = 6;
    private static const SPRITE_TRIANGLES : int = 2;

    private var _context:Context3D;
    private var _vertexBuffer : VertexBuffer3D;
    private var _indexBuffer : IndexBuffer3D;

    private var _vertices : ByteArray = new ByteArray();
    private var _indices : ByteArray = new ByteArray();

    private var _sprites : Array = [];
    private var _limit : int;

    public function PaperLayer() {
        _indices.endian = _vertices.endian = Endian.LITTLE_ENDIAN;
    }

    public function addSprite( item:PaperSprite ):void {
    }

    public function removeSprite( item:PaperSprite ):void {
    }

    public function upload(context:Context3D):void {
        if (_context != context) {
            _vertexBuffer && disposeVertexBuffer();
            _indexBuffer && disposeIndexBuffer();
            _context = context;
        }
        if (context) {
            uploadVertexBuffer(context);
            uploadIndexBuffer(context);
            draw(context);
        }
    }

    protected function uploadVertexBuffer(context : Context3D) : void {
        if (_vertexBuffer) {
            _vertexBuffer.uploadFromByteArray(_vertices, 0, 0, _limit * SPRITE_VERTICES);
        } else {
            _vertexBuffer = context.createVertexBuffer(_sprites.length * SPRITE_VERTICES, VERTEX_ATTRIBUTES);
            _vertexBuffer.uploadFromByteArray(_vertices, 0, 0, _sprites.length * SPRITE_VERTICES);
        }
    }

    protected function uploadIndexBuffer(context : Context3D) : void {
        if (_indexBuffer) {
            _indexBuffer.uploadFromByteArray(_indices, 0, 0, _limit * SPRITE_INDICES);
        } else {
            _indexBuffer = context.createIndexBuffer(_sprites.length * SPRITE_INDICES);
            _indexBuffer.uploadFromByteArray(_indices, 0, 0, _sprites.length * SPRITE_INDICES);
        }
    }

    protected function disposeVertexBuffer() : void {
        _vertexBuffer.dispose();
        _vertexBuffer = null;
    }

    protected function disposeIndexBuffer() : void {
        _indexBuffer.dispose();
        _indexBuffer = null;
    }

    protected function draw(context : Context3D) : void {
        context.setVertexBufferAt(0, _vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
        context.setVertexBufferAt(1, _vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_3);
        context.drawTriangles(_indexBuffer, 0, _limit * SPRITE_TRIANGLES);
    }

    public function dispose():void {
        _vertexBuffer && disposeVertexBuffer();
        _indexBuffer && disposeIndexBuffer();
        _context = null;
    }
}
}
