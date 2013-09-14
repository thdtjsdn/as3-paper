package {
import flash.utils.getTimer;

import org.flashgate.display.gpu.paper.sprite.PaperSprite;
import org.flashgate.display.gpu.paper.PaperSpriteTexture;

public class PaperParticle extends PaperSprite {

    private var _dx:Number;
    private var _dy:Number;
    private var _alpha:Number = 1;

    public function PaperParticle() {
        texture = new PaperSpriteTexture(0, 0, 1, 1, 32, 32);
        rotation = Math.random() * 628;
        _dx = Math.cos(rotation) * 0.5;
        _dy = Math.sin(rotation) * 0.5;
        _alpha = Math.random();
    }

    override public function render():void {
        x += _dx;
        y += _dy;
        _alpha -= 0.001;

        if (_alpha < 0) {
            dispose();
        } else {
            alpha = _alpha;
            super.render();
        }
    }
}
}
