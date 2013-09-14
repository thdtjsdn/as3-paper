package org.flashgate.display.gpu.paper.sprite {
public class PaperSpriteContainer {

    internal var items:Vector.<PaperSprite>;

    [Inline]
    final public function get numChildren():int {
        return items ? items.length : 0;
    }

    public function getChildAt(index:int):PaperSprite {
        return items ? items[index] : null;
    }

    public function getChildIndex(item:PaperSprite):int {
        return items ? items.indexOf(item) : -1;
    }

    public function addChild(item:PaperSprite):PaperSprite {
        if (item && item.parent != this) {
            if (items) {
                items.push(item);
            } else {
                items = new <PaperSprite>[item];
            }
            item.setParent(this);
            return item;
        }
        return null;
    }

    public function addChildAt(item:PaperSprite, index:int):PaperSprite {
        if (item && item.parent != this) {
            if (items) {
                if (index <= 0) {
                    items.unshift(item);
                } else if (index >= items.length) {
                    items.push(item);
                } else {
                    items.splice(index, 0, item);
                }
            } else {
                items = new <PaperSprite>[item];
            }
            item.setParent(this);
            return item;
        }
        return null;
    }

    public function removeChild(item:PaperSprite):PaperSprite {
        if (item && item.parent == this) {
            item.setParent(null);
            return item;
        }
        return null;
    }

    public function removeChildAt(index:int):PaperSprite {
        return removeChild(getChildAt(index));
    }

    public function dispose():void {
        if (items) {
            var list:Vector.<PaperSprite> = items;
            items = null;
            for each(var sprite:PaperSprite in list) {
                sprite.dispose();
            }
        }
    }

    // internal

    internal function attachChild(item:PaperSprite):void {
    }

    internal function detachChild(item:PaperSprite):void {
        if (items) {
            var index:int = items.indexOf(item);
            index == -1 || items.splice(index, 1);
        }
    }

}
}