package org.flashgate.display.gpu.paper {
import flash.display.Stage3D;
import flash.display3D.Context3D;
import flash.display3D.Context3DBlendFactor;
import flash.display3D.Context3DCompareMode;
import flash.display3D.Context3DProgramType;
import flash.display3D.Context3DTriangleFace;
import flash.events.Event;

public class PaperView {

    private const MIN_SIZE:int = 50;

    private const UPDATE_CONTEXT:int = 1;
    private const UPDATE_BUFFER:int = 2;

    private var _stage:Stage3D;
    private var _items:Vector.<IPaperRendererComponent> = new Vector.<IPaperRendererComponent>();

    private var _width:int = 320;
    private var _height:int = 240;

    protected var _update:int;

    public function PaperView(stage:Stage3D) {
        _stage = stage;
        _stage && initStage();
    }

    public function setVisible(value:Boolean):void {
        _stage.visible = value;
    }

    public function setPosition(x:int, y:int):void {
        _stage.x = x;
        _stage.y = y;
    }

    public function setSize(width:int, height:int):void {
        if (width < MIN_SIZE) {
            width = MIN_SIZE;
        }
        if (height < MIN_SIZE) {
            height = MIN_SIZE;
        }
        if (_width != width || _height != height) {
            _width = width;
            _height = height;
            invalidateBackBuffer();
        }
    }

    public function addComponent(item:IPaperRendererComponent):void {
        item && _items.push(item);
    }

    public function removeComponent(item:IPaperRendererComponent):void {
        var index:int = _items.indexOf(item);
        index == -1 || _items.splice(index, 1);
    }

    public function render():void {
        var context:Context3D = _stage ? _stage.context3D : null;

        if (context) {
            _update && update(context);
            context.clear();
            upload(context);
            context.present();
        }
    }

    protected function update(context:Context3D):void {
        _update & UPDATE_CONTEXT && updateContext(context);
        _update & UPDATE_BUFFER && updateBackBuffer(context);
        _update = 0;
    }

    protected function upload(context:Context3D):void {
        for each(var item:IPaperRendererComponent in _items) {
            item.upload(context);
        }
    }

    public function dispose():void {
        _stage && disposeStage();
    }

    protected function initStage():void {
        try {
            _stage.addEventListener(Event.CONTEXT3D_CREATE, onContext);
            _stage.requestContext3D(renderMode, renderProfile);
        } catch (e:*) {
            _stage.requestContext3D();
        }
    }

    protected function disposeStage():void {
        try {
            var stage:Stage3D = _stage;
            _stage = null;
            stage.removeEventListener(Event.CONTEXT3D_CREATE, onContext);
            stage.context3D.dispose();
        } catch (e:*) {
        }
    }

    protected function get renderMode():String {
        return "auto";
    }

    protected function get renderProfile():String {
        return "constrained";
    }

    protected function invalidateContext():void {
        _update |= UPDATE_CONTEXT;
    }

    protected function invalidateBackBuffer():void {
        _update |= UPDATE_BUFFER;
    }

    protected function updateContext(context:Context3D):void {
        context.enableErrorChecking = true;
        context.setDepthTest(false, Context3DCompareMode.ALWAYS);
        context.setCulling(Context3DTriangleFace.NONE);
        context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
        context.setRenderToBackBuffer();

        new PaperShader().upload(context);
    }

    protected function updateBackBuffer(context:Context3D):void {
        context.configureBackBuffer(_width, _height, 0, false);
        context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, new <Number>[_width / 2, _height / 2, 1, 1]);
    }

    private function onContext(event:Event):void {
        invalidateContext();
        invalidateBackBuffer();
    }

}
}
