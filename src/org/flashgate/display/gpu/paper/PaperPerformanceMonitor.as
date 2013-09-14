package org.flashgate.display.gpu.paper {
import flash.display.Sprite;
import flash.events.Event;
import flash.system.System;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.utils.getTimer;

public class PaperPerformanceMonitor extends Sprite {

    private var _time:int;
    private var _field:TextField;

    public function PaperPerformanceMonitor() {
        addEventListener(Event.ENTER_FRAME, onFrame);

        _field = new TextField();
        _field.autoSize = TextFieldAutoSize.LEFT;
        _field.defaultTextFormat = new TextFormat("_typewriter", 12, 0);
        _field.opaqueBackground = 0xffffff;
        _field.mouseEnabled = false;
        addChild(_field);
    }

    private function onFrame(event:Event):void {
        var time:int = getTimer();
        var fps:int = 1000 / (time - _time);

        _time = time;
        _field.text = "";
        _field.width = 1;
        _field.text = "FPS: " + fps + "\nMEM:" + System.privateMemory + "\nCPU:" + System.processCPUUsage;
    }
}
}
