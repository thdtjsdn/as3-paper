package org.flashgate.display.gpu.paper.sprite {
import flash.display3D.Context3D;

import org.flashgate.display.gpu.paper.*;

public class PaperSpriteLayer extends PaperSpriteContainer implements IPaperComponent {

    public static const MAX_SPRITES:int = 16383;

    private var _indexBuffer:PaperSpriteIndexBuffer;
    private var _positionBuffer:PaperSpritePositionBuffer;
    private var _texureBuffer:PaperSpriteTextureBuffer;

    private var _released:Vector.<int> = new Vector.<int>();
    private var _requested:int;
    private var _length:int;

    public function PaperSpriteLayer() {
        super();
        createIndexBuffer();
        createVertexBuffers();
    }

    public function get indexBuffer():PaperSpriteIndexBuffer {
        return _indexBuffer;
    }

    public function upload(context:Context3D):void {
        uploadIndexBuffer(context);

        if (_indexBuffer.numSprites) {
            uploadVertexBuffers(context);
            draw(context);
        }
    }

    [Inline]
    final protected function get length():int {
        return _length;
    }

    protected function set length(value:int):void {
        if (_length != value) {
            _length = value;
            resizeVertexBuffers();
        }
    }

    protected function expand():Boolean {
        if (length < MAX_SPRITES) {
            length = Math.min(MAX_SPRITES, length ? length << 1 : 32);
            return true;
        }
        return false;
    }

    protected function resizeVertexBuffers():void {
        _positionBuffer.length = _length;
        _texureBuffer.length = _length;
    }

    protected function createIndexBuffer():void {
        _indexBuffer = new PaperSpriteIndexBuffer(this);
    }

    protected function uploadIndexBuffer(context:Context3D):void {
        _indexBuffer.upload(context);
    }

    protected function createVertexBuffers():void {
        _positionBuffer = new PaperSpritePositionBuffer(this, 0);
        _texureBuffer = new PaperSpriteTextureBuffer(this, 1);
    }

    protected function uploadVertexBuffers(context:Context3D):void {
        _positionBuffer.upload(context);
        _texureBuffer.upload(context);
    }

    protected function draw(context:Context3D):void {
        _indexBuffer.draw();
    }

    override public function dispose():void {
        super.dispose();

        _indexBuffer.dispose();
        _positionBuffer.dispose();
        _texureBuffer.dispose();
    }

    // internal

    [Inline]
    final internal function invalidateIndex():void {
        _indexBuffer.invalidateIndex();
    }

    override internal function attachChild(child:PaperSprite):void {
        invalidateIndex();
    }

    override internal function detachChild(child:PaperSprite):void {
        super.detachChild(child);
        invalidateIndex();
    }

    [Inline]
    final internal function attachSprite(sprite:PaperSprite):Boolean {
        if (_released.length) {
            sprite.layer = this;
            sprite.vertex = _released.pop();
            return true;

        } else if (_requested < length || expand()) {
            sprite.layer = this;
            sprite.vertex = _requested++;
            return true;
        }
        return false;
    }

    [Inline]
    final internal function detachSprite(sprite:PaperSprite):void {
        sprite.layer = null;
        sprite.vertex < 0 || _released.push(sprite.vertex);
        invalidateIndex();
    }

}
}
