package org.flashgate.display.gpu.paper.sprite {
import flash.display3D.Context3DVertexBufferFormat;

public class PaperSpriteAlphaBuffer extends PaperSpriteVertexBuffer {
    public function PaperSpriteAlphaBuffer(index:int) {
        super(index, Context3DVertexBufferFormat.FLOAT_1);
    }
}
}
