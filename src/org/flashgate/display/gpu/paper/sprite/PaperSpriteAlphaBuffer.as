package org.flashgate.display.gpu.paper.sprite {
import flash.display3D.Context3D;
import flash.display3D.Context3DVertexBufferFormat;
import flash.display3D.VertexBuffer3D;

import org.flashgate.display.gpu.paper.PaperByteArray;

public class PaperSpriteAlphaBuffer extends PaperSpriteVertexBuffer {

    private static const WRITE_ALPHA_DONE:int = ~PaperSprite.WRITE_ALPHA;

    private static var _bytes:PaperByteArray;
    private var _updateBuffer:Boolean;

    public function PaperSpriteAlphaBuffer(layer:PaperSpriteLayer, index:int) {
        super(layer, index, Context3DVertexBufferFormat.FLOAT_1);
        _bytes || initBytes();
    }

    protected function initBytes():void {
        var count:int = 128;
        var alpha:Number = 0;
        var step:Number = 1 / count;
        var position:int = 0;

        _bytes = new PaperByteArray();
        _bytes.length = (count + 1) << 2;
        _bytes.select();

        for (var i:int = 0; i <= count; i++, alpha += step) {
            sf32(alpha, position += 4);
            sf32(alpha, position += 4);
            sf32(alpha, position += 4);
            sf32(alpha, position += 4);
        }

        _bytes.deselect();
    }

    override protected function createBuffer(context:Context3D):VertexBuffer3D {
        _updateBuffer = true;
        return super.createBuffer(context);
    }

    override protected function uploadBuffer(buffer:VertexBuffer3D):void {
        super.uploadBuffer(buffer);

        var index:int = 0;
        var count:int = layer.indexBuffer.numSprites;
        var update:Boolean = _updateBuffer;

        loop: for each(var container:PaperSpriteContainer in layer.indexBuffer.spriteContainers) {
            for each(var sprite:PaperSprite in container) {
                if (++index < count) {
                    break loop;
                }
                if (sprite.update & PaperSprite.WRITE_ALPHA || update) {
                    sprite.update &= WRITE_ALPHA_DONE;
                    buffer.uploadFromByteArray(_bytes.data, int(sprite.alpha * 128) << 2, sprite.vertex << 2, 4);
                }
            }
        }

        _updateBuffer = false;
    }

    override public function dispose():void {
        super.dispose();
    }
}
}
