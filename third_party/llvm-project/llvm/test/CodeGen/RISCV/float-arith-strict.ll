; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+f -verify-machineinstrs < %s \
; RUN:   -disable-strictnode-mutation -target-abi=ilp32f \
; RUN:   | FileCheck -check-prefix=RV32IF %s
; RUN: llc -mtriple=riscv64 -mattr=+f -verify-machineinstrs < %s \
; RUN:   -disable-strictnode-mutation -target-abi=lp64f \
; RUN:   | FileCheck -check-prefix=RV64IF %s
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   -disable-strictnode-mutation | FileCheck -check-prefix=RV32I %s
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   -disable-strictnode-mutation | FileCheck -check-prefix=RV64I %s

define float @fadd_s(float %a, float %b) nounwind strictfp {
; RV32IF-LABEL: fadd_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fadd.s fa0, fa0, fa1
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fadd_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fadd.s fa0, fa0, fa1
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fadd_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    call __addsf3@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fadd_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    call __addsf3@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = call float @llvm.experimental.constrained.fadd.f32(float %a, float %b, metadata !"round.dynamic", metadata !"fpexcept.strict") strictfp
  ret float %1
}
declare float @llvm.experimental.constrained.fadd.f32(float, float, metadata, metadata)

define float @fsub_s(float %a, float %b) nounwind strictfp {
; RV32IF-LABEL: fsub_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fsub.s fa0, fa0, fa1
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fsub_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fsub.s fa0, fa0, fa1
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fsub_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    call __subsf3@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fsub_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    call __subsf3@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = call float @llvm.experimental.constrained.fsub.f32(float %a, float %b, metadata !"round.dynamic", metadata !"fpexcept.strict") strictfp
  ret float %1
}
declare float @llvm.experimental.constrained.fsub.f32(float, float, metadata, metadata)

define float @fmul_s(float %a, float %b) nounwind strictfp {
; RV32IF-LABEL: fmul_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmul.s fa0, fa0, fa1
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fmul_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmul.s fa0, fa0, fa1
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fmul_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    call __mulsf3@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fmul_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    call __mulsf3@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = call float @llvm.experimental.constrained.fmul.f32(float %a, float %b, metadata !"round.dynamic", metadata !"fpexcept.strict") strictfp
  ret float %1
}
declare float @llvm.experimental.constrained.fmul.f32(float, float, metadata, metadata)

define float @fdiv_s(float %a, float %b) nounwind strictfp {
; RV32IF-LABEL: fdiv_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fdiv.s fa0, fa0, fa1
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fdiv_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fdiv.s fa0, fa0, fa1
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fdiv_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    call __divsf3@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fdiv_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    call __divsf3@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = call float @llvm.experimental.constrained.fdiv.f32(float %a, float %b, metadata !"round.dynamic", metadata !"fpexcept.strict") strictfp
  ret float %1
}
declare float @llvm.experimental.constrained.fdiv.f32(float, float, metadata, metadata)

define float @fsqrt_s(float %a) nounwind strictfp {
; RV32IF-LABEL: fsqrt_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fsqrt.s fa0, fa0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fsqrt_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fsqrt.s fa0, fa0
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fsqrt_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    call sqrtf@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fsqrt_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    call sqrtf@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = call float @llvm.experimental.constrained.sqrt.f32(float %a, metadata !"round.dynamic", metadata !"fpexcept.strict") strictfp
  ret float %1
}
declare float @llvm.experimental.constrained.sqrt.f32(float, metadata, metadata)

define float @fmin_s(float %a, float %b) nounwind strictfp {
; RV32IF-LABEL: fmin_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    addi sp, sp, -16
; RV32IF-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IF-NEXT:    call fminf@plt
; RV32IF-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IF-NEXT:    addi sp, sp, 16
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fmin_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    addi sp, sp, -16
; RV64IF-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IF-NEXT:    call fminf@plt
; RV64IF-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64IF-NEXT:    addi sp, sp, 16
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fmin_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    call fminf@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fmin_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    call fminf@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = call float @llvm.experimental.constrained.minnum.f32(float %a, float %b, metadata !"fpexcept.strict") strictfp
  ret float %1
}
declare float @llvm.experimental.constrained.minnum.f32(float, float, metadata) strictfp

define float @fmax_s(float %a, float %b) nounwind strictfp {
; RV32IF-LABEL: fmax_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    addi sp, sp, -16
; RV32IF-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IF-NEXT:    call fmaxf@plt
; RV32IF-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IF-NEXT:    addi sp, sp, 16
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fmax_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    addi sp, sp, -16
; RV64IF-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IF-NEXT:    call fmaxf@plt
; RV64IF-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64IF-NEXT:    addi sp, sp, 16
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fmax_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    call fmaxf@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fmax_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    call fmaxf@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = call float @llvm.experimental.constrained.maxnum.f32(float %a, float %b, metadata !"fpexcept.strict") strictfp
  ret float %1
}
declare float @llvm.experimental.constrained.maxnum.f32(float, float, metadata) strictfp

define float @fmadd_s(float %a, float %b, float %c) nounwind strictfp {
; RV32IF-LABEL: fmadd_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmadd.s fa0, fa0, fa1, fa2
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fmadd_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmadd.s fa0, fa0, fa1, fa2
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fmadd_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    call fmaf@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fmadd_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    call fmaf@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = call float @llvm.experimental.constrained.fma.f32(float %a, float %b, float %c, metadata !"round.dynamic", metadata !"fpexcept.strict") strictfp
  ret float %1
}
declare float @llvm.experimental.constrained.fma.f32(float, float, float, metadata, metadata) strictfp

define float @fmsub_s(float %a, float %b, float %c) nounwind strictfp {
; RV32IF-LABEL: fmsub_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, zero
; RV32IF-NEXT:    fadd.s ft0, fa2, ft0
; RV32IF-NEXT:    fmsub.s fa0, fa0, fa1, ft0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fmsub_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, zero
; RV64IF-NEXT:    fadd.s ft0, fa2, ft0
; RV64IF-NEXT:    fmsub.s fa0, fa0, fa1, ft0
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fmsub_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s1, 4(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv s0, a1
; RV32I-NEXT:    mv s1, a0
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    li a1, 0
; RV32I-NEXT:    call __addsf3@plt
; RV32I-NEXT:    lui a1, 524288
; RV32I-NEXT:    xor a2, a0, a1
; RV32I-NEXT:    mv a0, s1
; RV32I-NEXT:    mv a1, s0
; RV32I-NEXT:    call fmaf@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s1, 4(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fmsub_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -32
; RV64I-NEXT:    sd ra, 24(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 16(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s1, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv s0, a1
; RV64I-NEXT:    mv s1, a0
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:    li a1, 0
; RV64I-NEXT:    call __addsf3@plt
; RV64I-NEXT:    lui a1, 524288
; RV64I-NEXT:    xor a2, a0, a1
; RV64I-NEXT:    mv a0, s1
; RV64I-NEXT:    mv a1, s0
; RV64I-NEXT:    call fmaf@plt
; RV64I-NEXT:    ld ra, 24(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s0, 16(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s1, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 32
; RV64I-NEXT:    ret
  %c_ = fadd float 0.0, %c ; avoid negation using xor
  %negc = fneg float %c_
  %1 = call float @llvm.experimental.constrained.fma.f32(float %a, float %b, float %negc, metadata !"round.dynamic", metadata !"fpexcept.strict") strictfp
  ret float %1
}

define float @fnmadd_s(float %a, float %b, float %c) nounwind strictfp {
; RV32IF-LABEL: fnmadd_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, zero
; RV32IF-NEXT:    fadd.s ft1, fa0, ft0
; RV32IF-NEXT:    fadd.s ft0, fa2, ft0
; RV32IF-NEXT:    fnmadd.s fa0, ft1, fa1, ft0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fnmadd_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, zero
; RV64IF-NEXT:    fadd.s ft1, fa0, ft0
; RV64IF-NEXT:    fadd.s ft0, fa2, ft0
; RV64IF-NEXT:    fnmadd.s fa0, ft1, fa1, ft0
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fnmadd_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s1, 4(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s2, 0(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv s0, a2
; RV32I-NEXT:    mv s2, a1
; RV32I-NEXT:    li a1, 0
; RV32I-NEXT:    call __addsf3@plt
; RV32I-NEXT:    mv s1, a0
; RV32I-NEXT:    mv a0, s0
; RV32I-NEXT:    li a1, 0
; RV32I-NEXT:    call __addsf3@plt
; RV32I-NEXT:    lui a2, 524288
; RV32I-NEXT:    xor a1, s1, a2
; RV32I-NEXT:    xor a2, a0, a2
; RV32I-NEXT:    mv a0, a1
; RV32I-NEXT:    mv a1, s2
; RV32I-NEXT:    call fmaf@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s1, 4(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s2, 0(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fnmadd_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -32
; RV64I-NEXT:    sd ra, 24(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 16(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s1, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s2, 0(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv s0, a2
; RV64I-NEXT:    mv s2, a1
; RV64I-NEXT:    li a1, 0
; RV64I-NEXT:    call __addsf3@plt
; RV64I-NEXT:    mv s1, a0
; RV64I-NEXT:    mv a0, s0
; RV64I-NEXT:    li a1, 0
; RV64I-NEXT:    call __addsf3@plt
; RV64I-NEXT:    lui a2, 524288
; RV64I-NEXT:    xor a1, s1, a2
; RV64I-NEXT:    xor a2, a0, a2
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:    mv a1, s2
; RV64I-NEXT:    call fmaf@plt
; RV64I-NEXT:    ld ra, 24(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s0, 16(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s1, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s2, 0(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 32
; RV64I-NEXT:    ret
  %a_ = fadd float 0.0, %a
  %c_ = fadd float 0.0, %c
  %nega = fneg float %a_
  %negc = fneg float %c_
  %1 = call float @llvm.experimental.constrained.fma.f32(float %nega, float %b, float %negc, metadata !"round.dynamic", metadata !"fpexcept.strict") strictfp
  ret float %1
}

define float @fnmadd_s_2(float %a, float %b, float %c) nounwind strictfp {
; RV32IF-LABEL: fnmadd_s_2:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, zero
; RV32IF-NEXT:    fadd.s ft1, fa1, ft0
; RV32IF-NEXT:    fadd.s ft0, fa2, ft0
; RV32IF-NEXT:    fnmadd.s fa0, ft1, fa0, ft0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fnmadd_s_2:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, zero
; RV64IF-NEXT:    fadd.s ft1, fa1, ft0
; RV64IF-NEXT:    fadd.s ft0, fa2, ft0
; RV64IF-NEXT:    fnmadd.s fa0, ft1, fa0, ft0
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fnmadd_s_2:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s1, 4(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s2, 0(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv s0, a2
; RV32I-NEXT:    mv s2, a0
; RV32I-NEXT:    mv a0, a1
; RV32I-NEXT:    li a1, 0
; RV32I-NEXT:    call __addsf3@plt
; RV32I-NEXT:    mv s1, a0
; RV32I-NEXT:    mv a0, s0
; RV32I-NEXT:    li a1, 0
; RV32I-NEXT:    call __addsf3@plt
; RV32I-NEXT:    lui a2, 524288
; RV32I-NEXT:    xor a1, s1, a2
; RV32I-NEXT:    xor a2, a0, a2
; RV32I-NEXT:    mv a0, s2
; RV32I-NEXT:    call fmaf@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s1, 4(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s2, 0(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fnmadd_s_2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -32
; RV64I-NEXT:    sd ra, 24(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 16(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s1, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s2, 0(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv s0, a2
; RV64I-NEXT:    mv s2, a0
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:    li a1, 0
; RV64I-NEXT:    call __addsf3@plt
; RV64I-NEXT:    mv s1, a0
; RV64I-NEXT:    mv a0, s0
; RV64I-NEXT:    li a1, 0
; RV64I-NEXT:    call __addsf3@plt
; RV64I-NEXT:    lui a2, 524288
; RV64I-NEXT:    xor a1, s1, a2
; RV64I-NEXT:    xor a2, a0, a2
; RV64I-NEXT:    mv a0, s2
; RV64I-NEXT:    call fmaf@plt
; RV64I-NEXT:    ld ra, 24(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s0, 16(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s1, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s2, 0(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 32
; RV64I-NEXT:    ret
  %b_ = fadd float 0.0, %b
  %c_ = fadd float 0.0, %c
  %negb = fneg float %b_
  %negc = fneg float %c_
  %1 = call float @llvm.experimental.constrained.fma.f32(float %a, float %negb, float %negc, metadata !"round.dynamic", metadata !"fpexcept.strict") strictfp
  ret float %1
}

define float @fnmsub_s(float %a, float %b, float %c) nounwind strictfp {
; RV32IF-LABEL: fnmsub_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, zero
; RV32IF-NEXT:    fadd.s ft0, fa0, ft0
; RV32IF-NEXT:    fnmsub.s fa0, ft0, fa1, fa2
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fnmsub_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, zero
; RV64IF-NEXT:    fadd.s ft0, fa0, ft0
; RV64IF-NEXT:    fnmsub.s fa0, ft0, fa1, fa2
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fnmsub_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s1, 4(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv s0, a2
; RV32I-NEXT:    mv s1, a1
; RV32I-NEXT:    li a1, 0
; RV32I-NEXT:    call __addsf3@plt
; RV32I-NEXT:    lui a1, 524288
; RV32I-NEXT:    xor a0, a0, a1
; RV32I-NEXT:    mv a1, s1
; RV32I-NEXT:    mv a2, s0
; RV32I-NEXT:    call fmaf@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s1, 4(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fnmsub_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -32
; RV64I-NEXT:    sd ra, 24(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 16(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s1, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv s0, a2
; RV64I-NEXT:    mv s1, a1
; RV64I-NEXT:    li a1, 0
; RV64I-NEXT:    call __addsf3@plt
; RV64I-NEXT:    lui a1, 524288
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    mv a1, s1
; RV64I-NEXT:    mv a2, s0
; RV64I-NEXT:    call fmaf@plt
; RV64I-NEXT:    ld ra, 24(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s0, 16(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s1, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 32
; RV64I-NEXT:    ret
  %a_ = fadd float 0.0, %a
  %nega = fneg float %a_
  %1 = call float @llvm.experimental.constrained.fma.f32(float %nega, float %b, float %c, metadata !"round.dynamic", metadata !"fpexcept.strict") strictfp
  ret float %1
}

define float @fnmsub_s_2(float %a, float %b, float %c) nounwind strictfp {
; RV32IF-LABEL: fnmsub_s_2:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, zero
; RV32IF-NEXT:    fadd.s ft0, fa1, ft0
; RV32IF-NEXT:    fnmsub.s fa0, ft0, fa0, fa2
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fnmsub_s_2:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, zero
; RV64IF-NEXT:    fadd.s ft0, fa1, ft0
; RV64IF-NEXT:    fnmsub.s fa0, ft0, fa0, fa2
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fnmsub_s_2:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s1, 4(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv s0, a2
; RV32I-NEXT:    mv s1, a0
; RV32I-NEXT:    mv a0, a1
; RV32I-NEXT:    li a1, 0
; RV32I-NEXT:    call __addsf3@plt
; RV32I-NEXT:    lui a1, 524288
; RV32I-NEXT:    xor a1, a0, a1
; RV32I-NEXT:    mv a0, s1
; RV32I-NEXT:    mv a2, s0
; RV32I-NEXT:    call fmaf@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s1, 4(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fnmsub_s_2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -32
; RV64I-NEXT:    sd ra, 24(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 16(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s1, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv s0, a2
; RV64I-NEXT:    mv s1, a0
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:    li a1, 0
; RV64I-NEXT:    call __addsf3@plt
; RV64I-NEXT:    lui a1, 524288
; RV64I-NEXT:    xor a1, a0, a1
; RV64I-NEXT:    mv a0, s1
; RV64I-NEXT:    mv a2, s0
; RV64I-NEXT:    call fmaf@plt
; RV64I-NEXT:    ld ra, 24(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s0, 16(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s1, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 32
; RV64I-NEXT:    ret
  %b_ = fadd float 0.0, %b
  %negb = fneg float %b_
  %1 = call float @llvm.experimental.constrained.fma.f32(float %a, float %negb, float %c, metadata !"round.dynamic", metadata !"fpexcept.strict") strictfp
  ret float %1
}