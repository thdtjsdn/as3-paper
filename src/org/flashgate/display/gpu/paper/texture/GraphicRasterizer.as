package org.flashgate.display.gpu.paper.texture {
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.IBitmapDrawable;
import flash.display.StageQuality;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Rectangle;

public class GraphicRasterizer {
    public function GraphicRasterizer() {
    }

    public function rasterize(source:DisplayObject):BitmapData {
        var rect:Rectangle = source.getBounds(source);
        var r:int = Math.ceil(rect.right);
        var b:int = Math.ceil(rect.bottom);
        rect.x = Math.floor(rect.x);
        rect.y = Math.floor(rect.y);
        rect.width = r - rect.x;
        rect.height = b - rect.y;

        var result:BitmapData = new BitmapData(rect.width, rect.height, true, 0x00000000);
        var matrix:Matrix = new Matrix();
        matrix.translate(-rect.x, -rect.y);
        result.drawWithQuality(source, matrix, new ColorTransform(), BlendMode.NORMAL, new Rectangle(0, 0, rect.width, rect.height), false, StageQuality.BEST);
        //result.drawWithQuality(source, matrix, null, null, null, true, StageQuality.BEST);
        return result;
    }
}
}
