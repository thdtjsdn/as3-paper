package {
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

import org.flashgate.display.gpu.paper.PaperView;
import org.flashgate.display.gpu.paper.sprite.PaperSpriteLayer;

public class PaperExample extends Sprite {
    private var _renderer:PaperView;
    private var _layer:PaperSpriteLayer;
    private var _bitmap:BitmapData;

    public function PaperExample() {
        initStage();

        //addChild(new PaperPerformanceMonitor());
        //_bitmap = new BitmapData(8, 8, false, 0x44ff11);
        //_bitmap.noise(0, 100, 255, 7, true);

        _renderer = new PaperView(stage.stage3Ds[0]);
        //_renderer.addComponent(new PaperTextureAtlas(_bitmap));
        //_renderer.addComponent(_layer = new PaperSpriteLayer());

        updateSize();
    }

    private function initStage():void {
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.addEventListener(Event.ENTER_FRAME, onFrame);
        stage.addEventListener(Event.RESIZE, onResize);
        stage.frameRate = 60;
    }

    private function onLoad(event:Event):void {
    }

    private function updateSize():void {
        _renderer.setSize(stage.stageWidth, stage.stageHeight);
    }

    private function onFrame(event:Event):void {
        try {
            //var container:PaperSpriteContainer = _layer;
            //for (var i:int = 0; i < 10; i++) {
            //  container.addChild(new PaperParticle()).x = Math.random()*800-400;
            //}
            _renderer.render();
        } catch (throwable:Error) {
            trace(throwable.getStackTrace());
            stage.removeEventListener(Event.ENTER_FRAME, onFrame);
        }
    }

    private function onResize(event:Event):void {
        updateSize();
    }

}
}