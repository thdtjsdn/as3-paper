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

    public function getChildIndex(child:PaperSprite):int {
        return items ? items.indexOf(child) : -1;
    }

    public function addChild(child:PaperSprite):PaperSprite {
        if (child && child.parent != this) {
            if (items) {
                items.push(child);
            } else {
                items = new <PaperSprite>[child];
            }
            child.setParent(this);
            return child;
        }
        return null;
    }

    public function addChildAt(child:PaperSprite, index:int):PaperSprite {
        if (child && child.parent != this) {
            if (items) {
                if (index <= 0) {
                    items.unshift(child);
                } else if (index >= items.length) {
                    items.push(child);
                } else {
                    items.splice(index, 0, child);
                }
            } else {
                items = new <PaperSprite>[child];
            }
            child.setParent(this);
            return child;
        }
        return null;
    }

    public function removeChild(child:PaperSprite):PaperSprite {
        if (child && child.parent == this) {
            child.setParent(null);
            return child;
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
            for each(var child:PaperSprite in list) {
                child.dispose();
            }
        }
    }

    // internal

    internal function updateChilrenMatrix():void {
        for each(var child:PaperSprite in items) {
            child.invalidateGlobalMatrix();
        }
    }

    internal function attachChild(child:PaperSprite):void {
    }

    internal function detachChild(child:PaperSprite):void {
        if (items) {
            var index:int = items.indexOf(item);
            index == -1 || items.splice(index, 1);
        }
    }

}
}