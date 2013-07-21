package org.flashgate.display.gpu.paper {
import flash.display.Stage3D;
import flash.display3D.Context3D;
import flash.display3D.Context3DBlendFactor;
import flash.display3D.Context3DCompareMode;
import flash.display3D.Context3DProgramType;
import flash.display3D.Context3DTriangleFace;
import flash.events.Event;

public class PaperRenderer {

    private const MIN_SIZE:int = 50;

    private var _stage:Stage3D;
    private var _items:Vector.<IPaperComponent> = new Vector.<IPaperComponent>();

    private var _width:int = MIN_SIZE;
    private var _height:int = MIN_SIZE;

    private var _updateContext:Boolean;
    private var _updateSize:Boolean = true;

    public function PaperRenderer(stage:Stage3D) {
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
            _updateSize = true;
        }
    }

    public function addComponent(item:IPaperComponent):void {
        item && _items.push(item);
    }

    public function removeComponent(item:IPaperComponent):void {
        var index:int = _items.indexOf(item);
        index == -1 || _items.splice(index, 1);
    }

    public function render():void {
        var context:Context3D = _stage ? _stage.context3D : null;
        if (context) {
            if (_updateContext) {
                _updateContext = false;
                updateContext(context);
            }
            if (_updateSize) {
                _updateSize = false;
                updateSize(context);
            }
            context.clear();
            for each(var item:IPaperComponent in _items) {
                item.upload(context);
            }
            context.present();
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

    private function onContext(event:Event):void {
        _updateContext = true;
        _updateSize = true;
    }

    protected function updateContext(context:Context3D):void {
        context.setDepthTest(false, Context3DCompareMode.ALWAYS);
        context.setCulling(Context3DTriangleFace.NONE);
        context.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
        context.setRenderToBackBuffer();

        updateShader(context);
    }

    protected function updateSize(context:Context3D):void {
        context.configureBackBuffer(_width, _height, 0);
        context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, new <Number>[_width / 2, _height / 2, 1, 1]);
    }

    protected function updateShader(context:Context3D):void {
        new PaperShader().upload(context);
    }

}
}
