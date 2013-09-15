package org.flashgate.display.gpu.paper {
import flash.system.ApplicationDomain;
import flash.utils.ByteArray;
import flash.utils.Endian;

public class PaperByteArray {

    private static const MIN_SIZE:int = ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;

    private var _data:ByteArray = new ByteArray();
    private var _domain:ApplicationDomain;
    private var _previous:ByteArray;

    public function PaperByteArray() {
        _data.length = MIN_SIZE;
        _data.endian = Endian.LITTLE_ENDIAN;
        _domain = ApplicationDomain.currentDomain;
    }

    public function get data():ByteArray {
        return _data;
    }

    public function select():void {
        if (_domain.domainMemory != _data) {
            _previous = _domain.domainMemory;
            _domain.domainMemory = _data;
        }
    }

    public function deselect():void {
        if (_domain.domainMemory == _data) {
            _domain.domainMemory = _previous;
            _previous = null;
        }
    }

    public function get length():int {
        return _data.length;
    }

    public function set length(value:int):void {
        if (value < MIN_SIZE) {
            value = MIN_SIZE;
        }
        if (_data.length != value) {
            _data.length = value;
        }
    }

    public function dispose():void {
        _data.length = 0;
    }

}
}
