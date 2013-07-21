package org.flashgate.display.gpu.paper {
import flash.display3D.Context3D;
import flash.display3D.Program3D;

import org.flashgate.display.gpu.assembler.GpuAssembler;
import org.flashgate.display.gpu.assembler.GpuRegister;

public class PaperShader extends GpuAssembler implements IPaperComponent {

    private var _context:Context3D;
    private var _program:Program3D;

    public function upload(context:Context3D):void {
        if (_context != context) {
            _program && disposeProgram();
            _context = context;
        }
        if (context) {
            _program || (_program = initProgram(context));
            context.setProgram(_program);
        }
    }

    public function dispose():void {
        _program && disposeProgram();
        _context = null;
    }

    override protected function vertex(va:GpuRegister, vc:GpuRegister, vt:GpuRegister, v:GpuRegister, op:GpuRegister):void {
        mov(v, va[1]);
        div(op, va, vc);
    }

    override protected function fragment(v:GpuRegister, fc:GpuRegister, ft:GpuRegister, fs:GpuRegister, od:GpuRegister, oc:GpuRegister):void {
        tex(oc, v, fs, LINEAR);
    }

    protected function initProgram(context:Context3D):Program3D {
        var result:Program3D = context.createProgram();
        result.upload(vertexProgram, fragmentProgram);
        return result;
    }

    protected function disposeProgram():void {
        _program.dispose();
        _program = null;
    }
}
}
