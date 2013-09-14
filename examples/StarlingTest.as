package {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;

import org.flashgate.display.gpu.paper.PaperPerformanceMonitor;

import starling.core.Starling;
import starling.textures.Texture;

public class StarlingTest extends Sprite {
    private var _starling:Starling;

    public function StarlingTest() {
        initStage();

        _starling = new Starling(Test, stage);
        _starling.start();

        addChild(new PaperPerformanceMonitor());
    }

    private function initStage():void {
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.frameRate = 60;
    }
}
}

import flash.display.Bitmap;
import flash.display.BitmapData;

import starling.display.Image;

import starling.display.Image;

import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;

class Test extends Sprite {
    private var _bitmap:BitmapData;
    private var _texture:Texture;

    public function Test() {
        addEventListener(Event.ADDED_TO_STAGE, onInit);
        addEventListener(Event.ENTER_FRAME, onFrame);
    }

    private function onInit(event:Event):void {
        _bitmap = new BitmapData(16, 16, false, 0x44ff11);
        _bitmap.noise(0, 100, 255, 7, true);
        _texture = Texture.fromBitmap(new Bitmap(_bitmap));
    }

    private function onFrame(event:Event):void {
        if (_texture) {
            for (var i:int = 0; i < 100; i++) {
                addChild(new TestImage(_texture)).x = Math.random()*800;
            }
            i = numChildren;
            while(i-->0){
                var sprite:TestImage = getChildAt(i) as TestImage;
                sprite.render2();
            }
        }
    }

}

class TestImage extends Image {
    private var _dx:Number;
    private var _dy:Number;
    private var _alpha:Number = 1;

    public function TestImage(texture:starling.textures.Texture) {
        super(texture);
        rotation = Math.random() * 628;
        _dx = Math.cos(rotation) * 0.5;
        _dy = Math.sin(rotation) * 0.5;
        y = 200;
    }

    public function render2():void {
        x += _dx;
        y += _dy;
        _alpha -= 0.001;

        if (_alpha < 0) {
            parent.removeChild(this);
        } else {
            alpha = _alpha;
        }
    }
}