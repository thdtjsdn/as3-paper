package org.flashgate.display.gpu.paper.sprite {
import flash.display3D.Context3D;
import flash.display3D.IndexBuffer3D;

import org.flashgate.display.gpu.paper.*;

import avm2.intrinsics.memory.*;

public class PaperSpriteIndexBuffer {

    private static const MAX_SIZE:int = 16383;

    private var _context:Context3D;
    private var _buffer:IndexBuffer3D;

    private var _min:int;
    private var _max:int;

    private var _bytes:PaperByteArray = new PaperByteArray();
    private var _length:int;

    public function PaperSpriteIndexBuffer() {
        super();
    }

    [Inline]
    final public function get length():int {
        return _length;
    }

    public function set length(value:int):void {
        if (value < 0) {
            value = 0;
        } else if (value > MAX_SIZE) {
            value = MAX_SIZE;
        }
        if (_length != value) {
            _length = value;
            _bytes.length = _length * 12;
            _buffer && disposeBuffer();
        }
    }

    public function select():void {
        _bytes.select();
        _min = _length;
        _max = 0;
    }

    [Inline]
    final public function writeSprite(vertex:int, index:int):void {
        if (vertex < _min) {
            _min = vertex;
            if (vertex > _max) {
                _max = vertex;
            }
        } else if (vertex > _max) {
            _max = vertex;
        }
        si16(vertex << 2, index * 12);
        si16(int(vertex + 1), int(index + 2));
        si16(int(vertex + 2), index += 2);
        si16(int(vertex + 2), index += 2);
        si16(int(vertex + 3), index += 2);
        si16(vertex, index + 2);
    }

    public function deselect():void {
        _bytes.deselect();
    }

    public function upload(context:Context3D):void {
        if (_context != context) {
            _context = context;
            _buffer && disposeBuffer();
        }
        if (context && _length) {
            if (_buffer) {
                _min > _max || _buffer.uploadFromByteArray(_bytes.data, _min * 12, _min * 6, (_max - _min + 1) * 6);
            } else {
                _buffer = createBuffer(context);
                _buffer.uploadFromByteArray(_bytes.data, 0, 0, _length * 6);
            }
        }
    }

    public function draw():void {
        _context.drawTriangles(_buffer, 0, _length * 2);
    }

    public function dispose():void {
        _buffer && disposeBuffer();
    }

    protected function createBuffer(context:Context3D):IndexBuffer3D {
        return context.createIndexBuffer(_length * 6);
    }

    protected function disposeBuffer():void {
        _buffer.dispose();
    }

}
}