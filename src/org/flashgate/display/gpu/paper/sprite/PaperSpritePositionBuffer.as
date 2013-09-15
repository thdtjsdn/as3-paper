package org.flashgate.display.gpu.paper.sprite {

import avm2.intrinsics.memory.*;

import flash.display3D.Context3DVertexBufferFormat;
import flash.display3D.VertexBuffer3D;

import org.flashgate.display.gpu.paper.*;

public class PaperSpritePositionBuffer extends PaperSpriteVertexBuffer {

    private static const WRITE_POSITION_DONE:int = ~PaperSprite.WRITE_POSITION;

    private var _bytes:PaperByteArray = new PaperByteArray();

    public function PaperSpritePositionBuffer(layer:PaperSpriteLayer, index:int) {
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


                // if (sprite.update & PaperSprite.WRITE_POSITION) {
                var matrix:PaperMatrix = sprite.matrix;
                sprite.update &= WRITE_POSITION_DONE;

                trace("write position " + index);

                if (matrix.isIdentical) {
                    al = -sprite.transformX * sprite.width;
                    bl = 0;
                    ar = al + sprite.width;
                    br = 0;
                    ct = matrix.x;
                    dt = -sprite.transformY * sprite.height + matrix.y;
                    cb = ct;
                    db = dt + sprite.height;
                } else {
                    a = -sprite.transformX * sprite.width;
                    b = -sprite.transformY * sprite.height;
                    c = a + sprite.width;
                    d = b + sprite.height;
                    al = matrix.a * a;
                    bl = matrix.b * a;
                    ar = matrix.a * c;
                    br = matrix.b * c;
                    ct = matrix.c * b + matrix.x;
                    dt = matrix.d * b + matrix.y;
                    cb = matrix.c * d + matrix.x;
                    db = matrix.d * d + matrix.y;
                }

                var position:int = sprite.vertex << 4;
                sf32(al + cb, position);
                sf32(bl + db, position += 4);
                sf32(ar + cb, position += 4);
                sf32(br + db, position += 4);
                sf32(ar + ct, position += 4);
                sf32(br + dt, position += 4);
                sf32(al + ct, position += 4);
                sf32(bl + dt, position += 4);

                trace((al + cb) + "x" + (bl + db));
                trace((ar + cb) + "x" + (br + db));
                trace((ar + ct) + "x" + (br + dt));
                trace((al + ct) + "x" + (bl + dt));
                //  }

                if (++index < count) {
                    break loop;
                }
            }
        }

        _bytes.deselect();
        buffer.uploadFromByteArray(_bytes.data, 0, 0, length * 4);
    }

    override public function dispose():void {
        super.dispose();
        _bytes.dispose();
    }
}
}
