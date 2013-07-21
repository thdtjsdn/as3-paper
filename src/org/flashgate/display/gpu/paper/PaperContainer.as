package org.flashgate.display.gpu.paper {
public class PaperContainer {

    internal var _dirty:Boolean;
    internal var _items:Vector.<PaperSprite>;
    internal var _iterator:int = 0;

    public function PaperContainer() {
        super();
    }

    public function size():int {
        return _items ? _dirty ? compact() : _items.length : 0;
    }

    public function addSprite(item:PaperSprite):void {
        if (item && item != this && item._parent != this) {
            item._parent && item._parent.unattachSprite(item);
            _items || (_items = new Vector.<PaperSprite>());
            _items.push(item);
            item._parent = this;
        }
    }

    public function removeSprite(item:PaperSprite):void {
        if (item && item._parent == this) {
            unattachSprite(item);
            item._parent = null;
        }
    }

    internal function unattachSprite(item:PaperSprite):void {
        var index:int = _items ? _items.indexOf(item) : -1;
        if (index == -1) {
            _items[index] = null;
            _dirty = true;
        }
    }

    public function clear():void {
        if (_items) {
            for each(var item:PaperSprite in _items) {
                if (item) {
                    item._parent = null;
                    item.dispose();
                }
            }
            _items.length = 0;
        }
    }

    public function dispose():void {
        _items && clear();
    }

    private function compact():int {
        var item:PaperSprite;
        var count:int = _items.length;
        var last:int;

        for (var i:int; i < count; i++) {
            item = _items[i];
            if (item) {
                if (last != i) {
                    _items[last] = item;
                }
                last++;
            }
        }

        _dirty = false;
        _items.length = last;
        return last;
    }
}
}
