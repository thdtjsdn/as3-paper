package org.flashgate.display.gpu.paper {
import flash.geom.Point;

public class PaperMatrix {

    public var a:Number = 1;
    public var b:Number = 0;
    public var c:Number = 0;
    public var d:Number = 1;
    public var x:Number = 0;
    public var y:Number = 0;

    public function PaperMatrix() {
    }

    [Inline]
    final public function get isIdentical():Boolean {
        return a == 1 && b == 0 && c == 0 && d == 1;
    }

    [Inline]
    final public function transformPoint(matrix:PaperMatrix, result:Point = null):Point {
        result || (result = new Point());

        return result;
    }

    [Inline]
    final public function transform(matrix:PaperMatrix, result:PaperMatrix = null):PaperMatrix {
        result || (result = new PaperMatrix());

        if (isIdentical) {
            result.a = matrix.a;
            result.b = matrix.b;
            result.c = matrix.c;
            result.d = matrix.d;
            result.x = matrix.x + x;
            result.y = matrix.y + y;
        } else {
            result.a = a * matrix.a + c * matrix.b;
            result.b = b * matrix.a + d * matrix.b;
            result.c = a * matrix.c + c * matrix.d;
            result.d = b * matrix.c + d * matrix.d;
            result.x = a * matrix.x + c * matrix.y + x;
            result.y = b * matrix.x + d * matrix.y + y;
        }

        return result;
    }

}
}
