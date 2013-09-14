package org.flashgate.display.gpu.paper.sprite {
import flash.display3D.Context3D;
import flash.display3D.Context3DVertexBufferFormat;

import org.flashgate.display.gpu.paper.*;

public class PaperSpriteLayer extends PaperSpriteContainer implements IPaperComponent {

    MAX_SPRITES

    private var _indexBuffer:PaperSpriteIndexBuffer = new PaperSpriteIndexBuffer();
    private var _positionBuffer:PaperSpriteVertexBuffer = new PaperSpritePositionBuffer(0);
    private var _texureBuffer:PaperSpriteVertexBuffer = new PaperSpriteTextureBuffer(1);
    private var _alphaBuffer:PaperSpriteAlphaBuffer = new PaperSpriteAlphaBuffer(2);

    private var _stack:Vector.<PaperSpriteContainer> = new Vector.<PaperSpriteContainer>();
    private var _iterators:Vector.<int> = new Vector.<int>();
    private var _containers:Vector.<PaperSpriteContainer> = new Vector.<PaperSpriteContainer>();

    private var _released:Vector.<int> = new Vector.<int>();
    private var _allocate:int;
    private var _length:int;

    private var _updateIndex:Boolean;

    protected function get length():int {
        return _length;
    }

    protected function set length(value:int):void {
        if (_length != value) {
            _positionBuffer.length = _length;
            _texureBuffer.length = _length;
            _alphaBuffer.length = _length;
        }
    }

    public function upload(context:Context3D):void {
        if (_updateIndex) {
            _updateIndex = false;
            updateIndex();
        }
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

    // protected

    protected function updateIndex():void {
        var stack:Vector.<PaperSpriteContainer> = _stack;
        var containers:Vector.<PaperSpriteContainer> = _containers;
        var iterators:Vector.<int> = _iterators;
        var buffer:PaperSpriteIndexBuffer = _indexBuffer;
        var index:int = 0;
        var level:int = 0;

        stack[level] = this;
        iterators[level] = 0;
        containers.length = 0;
        buffer.select();

        loop: while (level >= 0) {
            var i:int = iterators[level];
            var container:PaperSpriteContainer = stack[level];
            var items:Vector.<PaperSprite> = container.items;

            if (items) {
                var count:int = items.length;
                containers.push(container);
                while (i < count) {
                    var sprite:PaperSprite = items[i];

                    if (sprite && sprite.visible) {
                        if (sprite.layer != this) {
                            sprite.setLayer(this);
                        }
                        if (sprite.vertex < 0) {
                            break;
                        }
                        if (sprite.index != index) {
                            sprite.index = index;
                            buffer.writeSprite(sprite.vertex, index);
                        }
                        if (++index > buffer.length) {
                            buffer.length <<= 1;
                            if (index > buffer.length) {
                                break loop;
                            }
                        }
                        if (sprite.numChildren) {
                            iterators[level++] = index;
                            stack[level] = sprite;
                            iterators[level] = 0;
                            break;
                        }
                    }
                }
                if (i == count) {
                    level--;
                }
            }
        }

        buffer.deselect();
        stack.length = 1;
        iterators.length = 1;
    }

    // internal

    [Inline]
    final internal function invalidateIndex():void {
        _updateIndex = true;
    }

    override internal function attachChild(child:PaperSprite):void {
        invalidateIndex();
    }

    override internal function detachChild(child:PaperSprite):void {
        super.detachChild(child);
        invalidateIndex();
    }


    internal function attachSprite(sprite:PaperSprite):int {
        if (_released.length) {
            sprite.vertex < _released.pop();
        } else {
            if (_allocate < _length) {
                return _allocate++;
            } else if (_length < MAX_SPRITES) {
                length <<= 1;
                return _allocate++;
            }
        }
        return -1;
    }

    internal function detachSprite(sprite:PaperSprite):void {
        if (sprite.vertex >= 0) {
            _released.push(sprite.vertex);
            invalidateIndex();
        }
    }

}
}
