package org.flashgate.display.gpu.paper.sprite {
import org.flashgate.display.gpu.paper.*;

import flash.display3D.Context3DVertexBufferFormat;

public class PaperSpritePositionBuffer extends PaperSpriteVertexBuffer {

    public function PaperSpritePositionBuffer(index:int) {
        super(index, Context3DVertexBufferFormat.FLOAT_2)
    }

}
}
