package org.flashgate.display.gpu.paper.texture {
import org.flashgate.display.gpu.paper.*;

import flash.display.BitmapData;
import flash.display3D.Context3D;
import flash.display3D.Context3DTextureFormat;
import flash.display3D.textures.Texture;

public class PaperTextureAtlas implements IPaperComponent {
    private var _bitmap:BitmapData;
    private var _context:Context3D;
    private var _texture:Texture;

    public function PaperTextureAtlas(bitmap:BitmapData = null) {
        _bitmap = bitmap;
    }

    public function upload(context:Context3D):void {
        if (_context != context) {
            _texture && disposeTexture();
            _context = context;
        }
        if (context) {
            _texture || (_texture = initTexture(context));
            _context.setTextureAt(0, _texture);
        }
    }

    public function dispose():void {
        _texture && disposeTexture();
        _context = null;
    }

    protected function initBitmap():BitmapData {
        return _bitmap;
    }

    protected function releaseBitmap(bitmap:BitmapData):void {
    }

    protected function initTexture(context:Context3D):Texture {
        var bitmap:BitmapData = initBitmap();
        var result:Texture = context.createTexture(bitmap.width, bitmap.height, Context3DTextureFormat.BGRA, false);
        result.uploadFromBitmapData(bitmap);
        releaseBitmap(bitmap);
        return result;
    }

    protected function disposeTexture():void {
        _texture.dispose();
        _texture = null;
    }
}
}
