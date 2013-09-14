package org.flashgate.display.gpu.paper.sprite {
import flash.display3D.Context3DVertexBufferFormat;

public class PaperSpriteTextureBuffer extends PaperSpriteVertexBuffer {
    public function PaperSpriteTextureBuffer(index:int) {
        super(index, Context3DVertexBufferFormat.FLOAT_2);
    }
}
}
