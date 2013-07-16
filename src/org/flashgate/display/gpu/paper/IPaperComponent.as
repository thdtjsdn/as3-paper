package org.flashgate.display.gpu.paper {
import flash.display3D.Context3D;

public interface IPaperComponent {
    function upload(context:Context3D):void;

    function dispose():void;
}
}
