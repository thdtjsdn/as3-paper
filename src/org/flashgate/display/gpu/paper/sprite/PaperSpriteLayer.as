package org.flashgate.display.gpu.paper.sprite {
import org.flashgate.display.gpu.paper.*;

import flash.display.IBitmapDrawable;
import flash.display3D.Context3D;
import flash.display3D.Context3DVertexBufferFormat;

public class PaperSpriteLayer extends PaperSpriteContainer implements IPaperRendererComponent {

    private static const MAX_SIZE:int = 16383;

    private var _indexBuffer:PaperSpriteIndexBuffer;
    private var _positionBuffer:PaperSpriteVertexBuffer;
    private var _texureBuffer:PaperSpriteVertexBuffer;
    private var _alphaBuffer:PaperSpriteVertexBuffer;

    private var _released:Vector.<int> = new Vector.<int>();
    private var _allocate:int;
    private var _length:int;

    public function PaperSpriteLayer() {
        super();
        _indexBuffer = new PaperSpriteIndexBuffer(this);
        _positionBuffer = new PaperSpriteVertexBuffer(0, Context3DVertexBufferFormat.FLOAT_2);
        _texureBuffer = new PaperSpriteVertexBuffer(1, Context3DVertexBufferFormat.FLOAT_2);
        _alphaBuffer = new PaperSpriteVertexBuffer(2, Context3DVertexBufferFormat.FLOAT_1);
    }

    [Inline]
    final protected function get length():int {
        return _length;
    }

    protected function set length(value:int):void {
        if (value < 0) {
            value = 0;
        } else if (value > MAX_SIZE) {
            value = MAX_SIZE;
        }
        if (_length != value) {
            _length = value;
            _indexBuffer.length = _length;
            _positionBuffer.length = _length;
            _texureBuffer.length = _length;
            _alphaBuffer.length = _length;
        }
    }

    public function upload(context:Context3D):void {
        uploadIndexBuffers(context);
        uploadVertexBuffers(context);
        draw();
    }

    protected function uploadIndexBuffers(context:Context3D):void {
        _indexBuffer.upload(context);
    }

    protected function uploadVertexBuffers(context:Context3D):void {
        _positionBuffer.upload(context);
        _texureBuffer.upload(context);
        _alphaBuffer.upload(context);
    }

    protected function draw():void {
        _indexBuffer.draw();
    }

    override public function dispose():void {
        super.dispose();

        _indexBuffer.dispose();
        _positionBuffer.dispose();
        _texureBuffer.dispose();
        _alphaBuffer.dispose();
    }

    // internal

    [Inline]
    final internal function invalidateSorting():void {
        _indexBuffer.invalidateSorting();
    }

    internal function attachSprite():int {
        if (_released.length) {
            return _released.pop();
        } else {
            if (_allocate < length) {
                return _allocate++;
            } else if (length < MAX_SIZE) {
                length <<= 1;
                return _allocate++;
            }
        }
        return -1;
    }

    internal function detachSprite(vertex:int):void {
        if (vertex >= 0) {
            _released.push(vertex);
            invalidateSorting();
        }
    }

}
}
