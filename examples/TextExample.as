package {
import avmplus.getQualifiedClassName;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.SpreadMethod;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.MouseEvent;
import flash.geom.ColorTransform;
import flash.text.AntiAliasType;
import flash.text.GridFitType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.utils.getQualifiedClassName;

import org.flashgate.display.gpu.paper.texture.GraphicRasterizer;
import org.flashgate.display.gpu.paper.sprite.PaperSpriteLayer;
import org.flashgate.display.gpu.paper.PaperView;

[SWF(backgroundColor="#444444")]
public class TextExample extends Sprite {
    private var layer:PaperSpriteLayer;

    public function TextExample() {
        initStage();
        initDemo();
    }

    private function initDemo():void {
        //var view:PaperView = new PaperView(stage.stage3Ds[0]);
        //view.addComponent(layer = new PaperLayer());
        stage.addEventListener(MouseEvent.RIGHT_CLICK, onClick);
    }

    private function onClick(event:MouseEvent):void {
        trace("asd");
        event.stopImmediatePropagation();
        event.stopPropagation();
    }

    private function initStage():void {
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.frameRate = 60;
    }
}
}
