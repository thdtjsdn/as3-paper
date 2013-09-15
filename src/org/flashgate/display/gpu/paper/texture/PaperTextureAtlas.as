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
            _context = context;
            _texture && disposeTexture();
        }
        if (_context) {
            uploadTexture(_texture || (_texture = createTexture(context)));
        }
    }

    public function dispose():void {
        _texture && disposeTexture();
        _context = null;
    }

    protected function createBitmap():BitmapData {
        return _bitmap;
    }

    protected function disposeBitmap(bitmap:BitmapData):void {
    }

    protected function createTexture(context:Context3D):Texture {
        var bitmap:BitmapData = createBitmap();
        var result:Texture = context.createTexture(bitmap.width, bitmap.height, Context3DTextureFormat.BGRA, false);
        result.uploadFromBitmapData(bitmap);
        disposeBitmap(bitmap);
        return result;
    }

    protected function uploadTexture(texture:Texture):void {
        trace("upload texture at 0");
        _context.setTextureAt(0, texture);
    }

    protected function disposeTexture():void {
        _texture.dispose();
        _texture = null;
    }
}
}
