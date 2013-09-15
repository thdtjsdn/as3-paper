package org.flashgate.display.gpu.paper.sprite {
public class PaperSpriteTexture {

    internal var _layer:PaperSpriteLayer;
    internal var _index:int;

    private var _left:Number = 0;
    private var _top:Number = 0;
    private var _right:Number = 0;
    private var _bottom:Number = 0;

    public function PaperSpriteTexture(left:Number, top:Number, right:Number, bottom:Number) {
        _left = left;
        _top = top;
        _right = right;
        _bottom = bottom;
    }

    public function setTexture(left:Number, top:Number, right:Number, bottom:Number):void {
    }

    public function get left():Number {
        return _left;
    }

    public function get top():Number {
        return _top;
    }

    public function get right():Number {
        return _right;
    }

    public function get bottom():Number {
        return _bottom;
    }

    public function dispose():void {
        //_layer && _layer.removeTexture(this);
    }
}
}
