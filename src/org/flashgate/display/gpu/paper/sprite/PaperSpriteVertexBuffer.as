package org.flashgate.display.gpu.paper.sprite {
import flash.display3D.Context3D;
import flash.display3D.Context3DVertexBufferFormat;
import flash.display3D.VertexBuffer3D;

public class PaperSpriteVertexBuffer {

    private var _context:Context3D;
    private var _buffer:VertexBuffer3D;

    private var _layer:PaperSpriteLayer;
    private var _index:int;
    private var _format:String;

    private var _size:int;
    private var _length:int;

    public function PaperSpriteVertexBuffer(layer:PaperSpriteLayer, index:int, format:String) {
        _layer = layer;
        _index = index;
        _size = getSizeByFormat(_format = format);
    }

    public function get layer():PaperSpriteLayer {
        return _layer;
    }

    public function get index():int {
        return _index;
    }

    public function get format():String {
        return _format;
    }

    public function get size():int {
        return _size;
    }

    public function get length():int {
        return _length;
    }

    public function set length(value:int):void {
        if (_length != value) {
            _length = value;
            resizeBuffer();
        }
    }

    public function upload(context:Context3D):void {
        if (_context != context) {
            _context = context;
            _buffer && disposeBuffer();
        }
        if (_context && _length) {
            if (_buffer) {
                uploadBuffer(_buffer, false);
            } else {
                uploadBuffer(_buffer = createBuffer(context), true);
            }
        }
    }

    public function dispose():void {
        _buffer && disposeBuffer();
        _context = null;
    }

    // protected

    protected function resizeBuffer():void {
        _buffer && disposeBuffer();
    }

    protected function createBuffer(context:Context3D):VertexBuffer3D {
        return context.createVertexBuffer(_length << 2, _size);
    }

    protected function uploadBuffer(buffer:VertexBuffer3D, init:Boolean):void {
        _context.setVertexBufferAt(_index, buffer, 0, _format);
    }

    protected function disposeBuffer():void {
        _buffer.dispose();
    }

    // static

    public static function getSizeByFormat(format:String):int {
        switch (format) {
            case Context3DVertexBufferFormat.FLOAT_1:
                return 1;
            case Context3DVertexBufferFormat.FLOAT_2:
                return 2;
            case Context3DVertexBufferFormat.FLOAT_3:
                return 3;
            case Context3DVertexBufferFormat.FLOAT_4:
                return 4;
            case Context3DVertexBufferFormat.BYTES_4:
                return 1;
            default:
                return 0;
        }
    }
}
}
