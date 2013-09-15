package org.flashgate.display.gpu.paper.sprite {

import avm2.intrinsics.memory.*;

import flash.display3D.Context3DVertexBufferFormat;
import flash.display3D.VertexBuffer3D;

import org.flashgate.display.gpu.paper.PaperByteArray;

import org.flashgate.display.gpu.paper.sprite.PaperSpriteLayer;

public class PaperSpriteTextureBuffer extends PaperSpriteVertexBuffer {

    private var _bytes:PaperByteArray = new PaperByteArray();

    public function PaperSpriteTextureBuffer(layer:PaperSpriteLayer, index:int) {
        super(layer, index, Context3DVertexBufferFormat.FLOAT_2);
    }

    override protected function uploadBuffer(buffer:VertexBuffer3D, init:Boolean):void {
        super.uploadBuffer(buffer, init);

        var a:int, b:int, c:int, d:int, al:int, bl:int, ar:int, br:int, ct:int, dt:int, cb:int, db:int;
        var index:int = 0;
        var count:int = layer.indexBuffer.numSprites;

        _bytes.length = length * size << 2;
        _bytes.select();

        loop: for each(var container:PaperSpriteContainer in layer.indexBuffer.spriteContainers) {
            for each(var sprite:PaperSprite in container.items) {
                trace("write texture "+index);

              //  if (sprite.update & PaperSprite.WRITE_POSITION) {
                    var position:int = sprite.vertex << 4;
                    sf32(0, position);
                    sf32(0, position += 4);
                    sf32(1, position += 4);
                    sf32(0, position += 4);
                    sf32(1, position += 4);
                    sf32(1, position += 4);
                    sf32(0, position += 4);
                    sf32(1, position += 4);
               // }

                if (++index < count) {
                    break loop;
                }
            }
        }

        _bytes.deselect();
        buffer.uploadFromByteArray(_bytes.data, 0, 0, length * 4);
    }
}
}
