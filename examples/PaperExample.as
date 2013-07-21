package {
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

import org.flashgate.display.gpu.paper.PaperLayer;
import org.flashgate.display.gpu.paper.PaperRenderer;
import org.flashgate.display.gpu.paper.PaperSprite;
import org.flashgate.display.gpu.paper.PaperTexture;
import org.flashgate.display.gpu.paper.PaperTextureAtlas;

public class PaperExample extends Sprite {
    private var _renderer:PaperRenderer;
    private var _layer:PaperLayer;
    private var _sprite:PaperSprite;

    public function PaperExample() {
        _renderer = new PaperRenderer(stage.stage3Ds[0]);
        _renderer.addComponent(new PaperTextureAtlas(new BitmapData(128, 128, false, 0xff4411)));
        _renderer.addComponent(_layer = new PaperLayer());

        _sprite = new PaperSprite();
        _sprite.texture = new PaperTexture(0, 0, 1, 1, 100, 100);
        _layer.addSprite(_sprite);

        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.addEventListener(Event.ENTER_FRAME, onFrame);
        stage.addEventListener(Event.RESIZE, onResize);
        updateSize();
    }

    private function updateSize():void {
        _renderer.setSize(stage.stageWidth, stage.stageHeight);
    }

    private function onFrame(event:Event):void {
        _renderer.render();
    }

    private function onResize(event:Event):void {
        updateSize();
    }

}
}
