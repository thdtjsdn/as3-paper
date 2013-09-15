package org.flashgate.display.gpu.paper.sprite {

import avm2.intrinsics.memory.*;

import flash.display3D.Context3D;
import flash.display3D.IndexBuffer3D;
import flash.display3D.IndexBuffer3D;

import org.flashgate.display.gpu.paper.*;

public class PaperSpriteIndexBuffer {

    private var _context:Context3D;
    private var _buffer:IndexBuffer3D;
    private var _layer:PaperSpriteLayer;

    private var _min:int;
    private var _max:int;

    private var _stack:Vector.<PaperSpriteContainer> = new Vector.<PaperSpriteContainer>();
    private var _iterators:Vector.<int> = new Vector.<int>();
    private var _containers:Vector.<PaperSpriteContainer> = new Vector.<PaperSpriteContainer>();

    private var _bytes:PaperByteArray = new PaperByteArray();
    private var _length:int;
    private var _count:int;

    private var _updateIndex:Boolean;

    public function PaperSpriteIndexBuffer(layer:PaperSpriteLayer) {
        super();
        _layer = layer;
    }

    [Inline]
    final public function get spriteContainers():Vector.<PaperSpriteContainer> {
        return _containers;
    }

    [Inline]
    final public function get numSprites():int {
        return _count;
    }

    public function upload(context:Context3D):void {
        if (_context != context) {
            _context = context;
            _buffer && disposeBuffer();
        }
        if (_context) {
            if (_updateIndex) {
                _updateIndex = false;
                _count = updateIndex();
            }
            if (_count) {
                if (_buffer) {
                    uploadBuffer(_buffer, false);
                } else {
                    uploadBuffer(_buffer = createBuffer(context), true);
                }
            }
        }
    }

    public function draw():void {
        trace(_count+" "+_length);
        _context.drawTriangles(_buffer, 0, _count << 1);
    }

    public function dispose():void {
        _buffer && disposeBuffer();
        _context = null;
    }

    [Inline]
    final internal function invalidateIndex():void {
        _updateIndex = true;
    }

    protected function updateIndex():int {
        var stack:Vector.<PaperSpriteContainer> = _stack;
        var containers:Vector.<PaperSpriteContainer> = _containers;
        var iterators:Vector.<int> = _iterators;
        var layer:PaperSpriteLayer = _layer;
        var index:int = 0;
        var level:int = 0;
        var min:int = -1;
        var max:int = 0;

        stack[level] = layer;
        iterators[level] = 0;
        containers.length = 0;

        _bytes.select();

        loop: while (level >= 0) {
            var i:int = iterators[level];
            var container:PaperSpriteContainer = stack[level];
            var items:Vector.<PaperSprite> = container.items;

            if (items) {
                var count:int = items.length;
                containers.push(container);

                while (i < count) {
                    var sprite:PaperSprite = items[i++];
                    if (sprite && sprite.visible) {
                        if (sprite.layer == layer || layer.attachSprite(sprite)) {
                            if (sprite.index != index) {
                                var position:int = sprite.index = index;
                                var vertex:int = sprite.vertex;
                                if (min < 0) {
                                    max = min = index;
                                } else if (max < index) {
                                    max = index;
                                }
                                si16(vertex << 2, position * 12);
                                si16(int(vertex + 1), int(position + 2));
                                si16(int(vertex + 2), position += 2);
                                si16(int(vertex + 2), position += 2);
                                si16(int(vertex + 3), position += 2);
                                si16(vertex, int(position + 2));
                            }
                            if (++index < _length || expand()) {
                                if (sprite.numChildren) {
                                    iterators[level++] = index;
                                    stack[level] = sprite;
                                    iterators[level] = 0;
                                    break;
                                }
                            } else {
                                break loop;
                            }
                        }
                    }
                }
                if (i == count) {
                    level--;
                }
            }
        }

        stack.length = 1;
        iterators.length = 1;

        _bytes.deselect();
        _max = max;
        _min = min;

        return index;
    }

    [Inline]
    final protected function get length():int {
        return _length;
    }

    protected function set length(value:int):void {
        if (_length != value) {
            _length = value;
            trace("INDEX BUFFER "+_length);
            _bytes.length = _length * 12;
            _buffer && disposeBuffer();
        }
    }

    protected function expand():Boolean {
        if (length < PaperSpriteLayer.MAX_SPRITES) {
            length = Math.min(PaperSpriteLayer.MAX_SPRITES, length ? length << 1 : 32);
            return true;
        }
        return false;
    }

    protected function createBuffer(context:Context3D):IndexBuffer3D {
        return context.createIndexBuffer(_length * 6);
    }

    protected function uploadBuffer(buffer:IndexBuffer3D, init:Boolean):void {
        if (init) {
            _buffer.uploadFromByteArray(_bytes.data, 0, 0, _length * 6);
        } else {
            _min > _max || _buffer.uploadFromByteArray(_bytes.data, _min * 12, _min * 6, (_max - _min + 1) * 6);
        }
    }

    protected function disposeBuffer():void {
        _buffer.dispose();
    }

}
}