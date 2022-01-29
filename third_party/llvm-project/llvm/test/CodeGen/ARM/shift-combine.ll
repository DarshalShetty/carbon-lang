; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=armv7-linux-gnueabihf %s -o - | FileCheck %s --check-prefixes=CHECK-COMMON,CHECK-ARM
; RUN: llc -mtriple=armv7eb-linux-gnueabihf %s -o - | FileCheck %s --check-prefixes=CHECK-BE
; RUN: llc -mtriple=thumbv7-linux-gnueabihf %s -o - | FileCheck %s --check-prefixes=CHECK-COMMON,CHECK-THUMB
; RUN: llc -mtriple=thumbv7m %s -o - | FileCheck %s --check-prefixes=CHECK-COMMON,CHECK-THUMB
; RUN: llc -mtriple=thumbv7m -mattr=+strict-align %s -o - | FileCheck %s --check-prefixes=CHECK-COMMON,CHECK-ALIGN
; RUN: llc -mtriple=thumbv6m %s -o - | FileCheck %s --check-prefix=CHECK-V6M

@array = weak global [4 x i32] zeroinitializer

define i32 @test_lshr_and1(i32 %x) {
; CHECK-COMMON-LABEL: test_lshr_and1:
; CHECK-COMMON:       @ %bb.0: @ %entry
; CHECK-COMMON-NEXT:    movw r1, :lower16:array
; CHECK-COMMON-NEXT:    and r0, r0, #12
; CHECK-COMMON-NEXT:    movt r1, :upper16:array
; CHECK-COMMON-NEXT:    ldr r0, [r1, r0]
; CHECK-COMMON-NEXT:    bx lr
;
; CHECK-BE-LABEL: test_lshr_and1:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    movw r1, :lower16:array
; CHECK-BE-NEXT:    and r0, r0, #12
; CHECK-BE-NEXT:    movt r1, :upper16:array
; CHECK-BE-NEXT:    ldr r0, [r1, r0]
; CHECK-BE-NEXT:    bx lr
;
; CHECK-V6M-LABEL: test_lshr_and1:
; CHECK-V6M:       @ %bb.0: @ %entry
; CHECK-V6M-NEXT:    movs r1, #12
; CHECK-V6M-NEXT:    ands r1, r0
; CHECK-V6M-NEXT:    ldr r0, .LCPI0_0
; CHECK-V6M-NEXT:    ldr r0, [r0, r1]
; CHECK-V6M-NEXT:    bx lr
; CHECK-V6M-NEXT:    .p2align 2
; CHECK-V6M-NEXT:  @ %bb.1:
; CHECK-V6M-NEXT:  .LCPI0_0:
; CHECK-V6M-NEXT:    .long array
entry:
  %tmp2 = lshr i32 %x, 2
  %tmp3 = and i32 %tmp2, 3
  %tmp4 = getelementptr [4 x i32], [4 x i32]* @array, i32 0, i32 %tmp3
  %tmp5 = load i32, i32* %tmp4, align 4
  ret i32 %tmp5
}
define i32 @test_lshr_and2(i32 %x) {
; CHECK-ARM-LABEL: test_lshr_and2:
; CHECK-ARM:       @ %bb.0: @ %entry
; CHECK-ARM-NEXT:    ubfx r0, r0, #1, #15
; CHECK-ARM-NEXT:    add r0, r0, r0
; CHECK-ARM-NEXT:    bx lr
;
; CHECK-BE-LABEL: test_lshr_and2:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ubfx r0, r0, #1, #15
; CHECK-BE-NEXT:    add r0, r0, r0
; CHECK-BE-NEXT:    bx lr
;
; CHECK-THUMB-LABEL: test_lshr_and2:
; CHECK-THUMB:       @ %bb.0: @ %entry
; CHECK-THUMB-NEXT:    ubfx r0, r0, #1, #15
; CHECK-THUMB-NEXT:    add r0, r0
; CHECK-THUMB-NEXT:    bx lr
;
; CHECK-ALIGN-LABEL: test_lshr_and2:
; CHECK-ALIGN:       @ %bb.0: @ %entry
; CHECK-ALIGN-NEXT:    ubfx r0, r0, #1, #15
; CHECK-ALIGN-NEXT:    add r0, r0
; CHECK-ALIGN-NEXT:    bx lr
;
; CHECK-V6M-LABEL: test_lshr_and2:
; CHECK-V6M:       @ %bb.0: @ %entry
; CHECK-V6M-NEXT:    lsls r0, r0, #16
; CHECK-V6M-NEXT:    lsrs r0, r0, #17
; CHECK-V6M-NEXT:    adds r0, r0, r0
; CHECK-V6M-NEXT:    bx lr
entry:
  %a = and i32 %x, 65534
  %b = lshr i32 %a, 1
  %c = and i32 %x, 65535
  %d = lshr i32 %c, 1
  %e = add i32 %b, %d
  ret i32 %e
}

define arm_aapcscc i32 @test_lshr_load1(i16* %a) {
; CHECK-COMMON-LABEL: test_lshr_load1:
; CHECK-COMMON:       @ %bb.0: @ %entry
; CHECK-COMMON-NEXT:    ldrb r0, [r0, #1]
; CHECK-COMMON-NEXT:    bx lr
;
; CHECK-BE-LABEL: test_lshr_load1:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldrb r0, [r0]
; CHECK-BE-NEXT:    bx lr
;
; CHECK-V6M-LABEL: test_lshr_load1:
; CHECK-V6M:       @ %bb.0: @ %entry
; CHECK-V6M-NEXT:    ldrb r0, [r0, #1]
; CHECK-V6M-NEXT:    bx lr
entry:
  %0 = load i16, i16* %a, align 2
  %conv1 = zext i16 %0 to i32
  %1 = lshr i32 %conv1, 8
  ret i32 %1
}

define arm_aapcscc i32 @test_lshr_load1_sext(i16* %a) {
; CHECK-ARM-LABEL: test_lshr_load1_sext:
; CHECK-ARM:       @ %bb.0: @ %entry
; CHECK-ARM-NEXT:    ldrsh r0, [r0]
; CHECK-ARM-NEXT:    lsr r0, r0, #8
; CHECK-ARM-NEXT:    bx lr
;
; CHECK-BE-LABEL: test_lshr_load1_sext:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldrsh r0, [r0]
; CHECK-BE-NEXT:    lsr r0, r0, #8
; CHECK-BE-NEXT:    bx lr
;
; CHECK-THUMB-LABEL: test_lshr_load1_sext:
; CHECK-THUMB:       @ %bb.0: @ %entry
; CHECK-THUMB-NEXT:    ldrsh.w r0, [r0]
; CHECK-THUMB-NEXT:    lsrs r0, r0, #8
; CHECK-THUMB-NEXT:    bx lr
;
; CHECK-ALIGN-LABEL: test_lshr_load1_sext:
; CHECK-ALIGN:       @ %bb.0: @ %entry
; CHECK-ALIGN-NEXT:    ldrsh.w r0, [r0]
; CHECK-ALIGN-NEXT:    lsrs r0, r0, #8
; CHECK-ALIGN-NEXT:    bx lr
;
; CHECK-V6M-LABEL: test_lshr_load1_sext:
; CHECK-V6M:       @ %bb.0: @ %entry
; CHECK-V6M-NEXT:    movs r1, #0
; CHECK-V6M-NEXT:    ldrsh r0, [r0, r1]
; CHECK-V6M-NEXT:    lsrs r0, r0, #8
; CHECK-V6M-NEXT:    bx lr
entry:
  %0 = load i16, i16* %a, align 2
  %conv1 = sext i16 %0 to i32
  %1 = lshr i32 %conv1, 8
  ret i32 %1
}

define arm_aapcscc i32 @test_lshr_load1_fail(i16* %a) {
; CHECK-ARM-LABEL: test_lshr_load1_fail:
; CHECK-ARM:       @ %bb.0: @ %entry
; CHECK-ARM-NEXT:    ldrh r0, [r0]
; CHECK-ARM-NEXT:    lsr r0, r0, #9
; CHECK-ARM-NEXT:    bx lr
;
; CHECK-BE-LABEL: test_lshr_load1_fail:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldrh r0, [r0]
; CHECK-BE-NEXT:    lsr r0, r0, #9
; CHECK-BE-NEXT:    bx lr
;
; CHECK-THUMB-LABEL: test_lshr_load1_fail:
; CHECK-THUMB:       @ %bb.0: @ %entry
; CHECK-THUMB-NEXT:    ldrh r0, [r0]
; CHECK-THUMB-NEXT:    lsrs r0, r0, #9
; CHECK-THUMB-NEXT:    bx lr
;
; CHECK-ALIGN-LABEL: test_lshr_load1_fail:
; CHECK-ALIGN:       @ %bb.0: @ %entry
; CHECK-ALIGN-NEXT:    ldrh r0, [r0]
; CHECK-ALIGN-NEXT:    lsrs r0, r0, #9
; CHECK-ALIGN-NEXT:    bx lr
;
; CHECK-V6M-LABEL: test_lshr_load1_fail:
; CHECK-V6M:       @ %bb.0: @ %entry
; CHECK-V6M-NEXT:    ldrh r0, [r0]
; CHECK-V6M-NEXT:    lsrs r0, r0, #9
; CHECK-V6M-NEXT:    bx lr
entry:
  %0 = load i16, i16* %a, align 2
  %conv1 = zext i16 %0 to i32
  %1 = lshr i32 %conv1, 9
  ret i32 %1
}

define arm_aapcscc i32 @test_lshr_load32(i32* %a) {
; CHECK-ARM-LABEL: test_lshr_load32:
; CHECK-ARM:       @ %bb.0: @ %entry
; CHECK-ARM-NEXT:    ldr r0, [r0]
; CHECK-ARM-NEXT:    lsr r0, r0, #8
; CHECK-ARM-NEXT:    bx lr
;
; CHECK-BE-LABEL: test_lshr_load32:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldr r0, [r0]
; CHECK-BE-NEXT:    lsr r0, r0, #8
; CHECK-BE-NEXT:    bx lr
;
; CHECK-THUMB-LABEL: test_lshr_load32:
; CHECK-THUMB:       @ %bb.0: @ %entry
; CHECK-THUMB-NEXT:    ldr r0, [r0]
; CHECK-THUMB-NEXT:    lsrs r0, r0, #8
; CHECK-THUMB-NEXT:    bx lr
;
; CHECK-ALIGN-LABEL: test_lshr_load32:
; CHECK-ALIGN:       @ %bb.0: @ %entry
; CHECK-ALIGN-NEXT:    ldr r0, [r0]
; CHECK-ALIGN-NEXT:    lsrs r0, r0, #8
; CHECK-ALIGN-NEXT:    bx lr
;
; CHECK-V6M-LABEL: test_lshr_load32:
; CHECK-V6M:       @ %bb.0: @ %entry
; CHECK-V6M-NEXT:    ldr r0, [r0]
; CHECK-V6M-NEXT:    lsrs r0, r0, #8
; CHECK-V6M-NEXT:    bx lr
entry:
  %0 = load i32, i32* %a, align 4
  %1 = lshr i32 %0, 8
  ret i32 %1
}

define arm_aapcscc i32 @test_lshr_load32_2(i32* %a) {
; CHECK-COMMON-LABEL: test_lshr_load32_2:
; CHECK-COMMON:       @ %bb.0: @ %entry
; CHECK-COMMON-NEXT:    ldrh r0, [r0, #2]
; CHECK-COMMON-NEXT:    bx lr
;
; CHECK-BE-LABEL: test_lshr_load32_2:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldrh r0, [r0]
; CHECK-BE-NEXT:    bx lr
;
; CHECK-V6M-LABEL: test_lshr_load32_2:
; CHECK-V6M:       @ %bb.0: @ %entry
; CHECK-V6M-NEXT:    ldrh r0, [r0, #2]
; CHECK-V6M-NEXT:    bx lr
entry:
  %0 = load i32, i32* %a, align 4
  %1 = lshr i32 %0, 16
  ret i32 %1
}

define arm_aapcscc i32 @test_lshr_load32_1(i32* %a) {
; CHECK-COMMON-LABEL: test_lshr_load32_1:
; CHECK-COMMON:       @ %bb.0: @ %entry
; CHECK-COMMON-NEXT:    ldrb r0, [r0, #3]
; CHECK-COMMON-NEXT:    bx lr
;
; CHECK-BE-LABEL: test_lshr_load32_1:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldrb r0, [r0]
; CHECK-BE-NEXT:    bx lr
;
; CHECK-V6M-LABEL: test_lshr_load32_1:
; CHECK-V6M:       @ %bb.0: @ %entry
; CHECK-V6M-NEXT:    ldrb r0, [r0, #3]
; CHECK-V6M-NEXT:    bx lr
entry:
  %0 = load i32, i32* %a, align 4
  %1 = lshr i32 %0, 24
  ret i32 %1
}

define arm_aapcscc i32 @test_lshr_load32_fail(i32* %a) {
; CHECK-ARM-LABEL: test_lshr_load32_fail:
; CHECK-ARM:       @ %bb.0: @ %entry
; CHECK-ARM-NEXT:    ldr r0, [r0]
; CHECK-ARM-NEXT:    lsr r0, r0, #15
; CHECK-ARM-NEXT:    bx lr
;
; CHECK-BE-LABEL: test_lshr_load32_fail:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldr r0, [r0]
; CHECK-BE-NEXT:    lsr r0, r0, #15
; CHECK-BE-NEXT:    bx lr
;
; CHECK-THUMB-LABEL: test_lshr_load32_fail:
; CHECK-THUMB:       @ %bb.0: @ %entry
; CHECK-THUMB-NEXT:    ldr r0, [r0]
; CHECK-THUMB-NEXT:    lsrs r0, r0, #15
; CHECK-THUMB-NEXT:    bx lr
;
; CHECK-ALIGN-LABEL: test_lshr_load32_fail:
; CHECK-ALIGN:       @ %bb.0: @ %entry
; CHECK-ALIGN-NEXT:    ldr r0, [r0]
; CHECK-ALIGN-NEXT:    lsrs r0, r0, #15
; CHECK-ALIGN-NEXT:    bx lr
;
; CHECK-V6M-LABEL: test_lshr_load32_fail:
; CHECK-V6M:       @ %bb.0: @ %entry
; CHECK-V6M-NEXT:    ldr r0, [r0]
; CHECK-V6M-NEXT:    lsrs r0, r0, #15
; CHECK-V6M-NEXT:    bx lr
entry:
  %0 = load i32, i32* %a, align 4
  %1 = lshr i32 %0, 15
  ret i32 %1
}

define arm_aapcscc i32 @test_lshr_load64_4_unaligned(i64* %a) {
; CHECK-ARM-LABEL: test_lshr_load64_4_unaligned:
; CHECK-ARM:       @ %bb.0: @ %entry
; CHECK-ARM-NEXT:    ldr r0, [r0, #2]
; CHECK-ARM-NEXT:    bx lr
;
; CHECK-BE-LABEL: test_lshr_load64_4_unaligned:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldr r1, [r0]
; CHECK-BE-NEXT:    ldrh r0, [r0, #4]
; CHECK-BE-NEXT:    orr r0, r0, r1, lsl #16
; CHECK-BE-NEXT:    bx lr
;
; CHECK-THUMB-LABEL: test_lshr_load64_4_unaligned:
; CHECK-THUMB:       @ %bb.0: @ %entry
; CHECK-THUMB-NEXT:    ldr.w r0, [r0, #2]
; CHECK-THUMB-NEXT:    bx lr
;
; CHECK-ALIGN-LABEL: test_lshr_load64_4_unaligned:
; CHECK-ALIGN:       @ %bb.0: @ %entry
; CHECK-ALIGN-NEXT:    ldr r1, [r0, #4]
; CHECK-ALIGN-NEXT:    ldrh r0, [r0, #2]
; CHECK-ALIGN-NEXT:    orr.w r0, r0, r1, lsl #16
; CHECK-ALIGN-NEXT:    bx lr
;
; CHECK-V6M-LABEL: test_lshr_load64_4_unaligned:
; CHECK-V6M:       @ %bb.0: @ %entry
; CHECK-V6M-NEXT:    ldrh r1, [r0, #2]
; CHECK-V6M-NEXT:    ldr r0, [r0, #4]
; CHECK-V6M-NEXT:    lsls r0, r0, #16
; CHECK-V6M-NEXT:    adds r0, r1, r0
; CHECK-V6M-NEXT:    bx lr
entry:
  %0 = load i64, i64* %a, align 8
  %1 = lshr i64 %0, 16
  %conv = trunc i64 %1 to i32
  ret i32 %conv
}

define arm_aapcscc i32 @test_lshr_load64_1_lsb(i64* %a) {
; CHECK-ARM-LABEL: test_lshr_load64_1_lsb:
; CHECK-ARM:       @ %bb.0: @ %entry
; CHECK-ARM-NEXT:    ldr r0, [r0, #3]
; CHECK-ARM-NEXT:    bx lr
;
; CHECK-BE-LABEL: test_lshr_load64_1_lsb:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldr r1, [r0]
; CHECK-BE-NEXT:    ldrb r0, [r0, #4]
; CHECK-BE-NEXT:    orr r0, r0, r1, lsl #8
; CHECK-BE-NEXT:    bx lr
;
; CHECK-THUMB-LABEL: test_lshr_load64_1_lsb:
; CHECK-THUMB:       @ %bb.0: @ %entry
; CHECK-THUMB-NEXT:    ldr.w r0, [r0, #3]
; CHECK-THUMB-NEXT:    bx lr
;
; CHECK-ALIGN-LABEL: test_lshr_load64_1_lsb:
; CHECK-ALIGN:       @ %bb.0: @ %entry
; CHECK-ALIGN-NEXT:    ldr r1, [r0, #4]
; CHECK-ALIGN-NEXT:    ldrb r0, [r0, #3]
; CHECK-ALIGN-NEXT:    orr.w r0, r0, r1, lsl #8
; CHECK-ALIGN-NEXT:    bx lr
;
; CHECK-V6M-LABEL: test_lshr_load64_1_lsb:
; CHECK-V6M:       @ %bb.0: @ %entry
; CHECK-V6M-NEXT:    ldrb r1, [r0, #3]
; CHECK-V6M-NEXT:    ldr r0, [r0, #4]
; CHECK-V6M-NEXT:    lsls r0, r0, #8
; CHECK-V6M-NEXT:    adds r0, r1, r0
; CHECK-V6M-NEXT:    bx lr
entry:
  %0 = load i64, i64* %a, align 8
  %1 = lshr i64 %0, 24
  %conv = trunc i64 %1 to i32
  ret i32 %conv
}

define arm_aapcscc i32 @test_lshr_load64_1_msb(i64* %a) {
; CHECK-COMMON-LABEL: test_lshr_load64_1_msb:
; CHECK-COMMON:       @ %bb.0: @ %entry
; CHECK-COMMON-NEXT:    ldrb r0, [r0, #7]
; CHECK-COMMON-NEXT:    bx lr
;
; CHECK-BE-LABEL: test_lshr_load64_1_msb:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldrb r0, [r0]
; CHECK-BE-NEXT:    bx lr
;
; CHECK-V6M-LABEL: test_lshr_load64_1_msb:
; CHECK-V6M:       @ %bb.0: @ %entry
; CHECK-V6M-NEXT:    ldrb r0, [r0, #7]
; CHECK-V6M-NEXT:    bx lr
entry:
  %0 = load i64, i64* %a, align 8
  %1 = lshr i64 %0, 56
  %conv = trunc i64 %1 to i32
  ret i32 %conv
}

define arm_aapcscc i32 @test_lshr_load64_4(i64* %a) {
; CHECK-COMMON-LABEL: test_lshr_load64_4:
; CHECK-COMMON:       @ %bb.0: @ %entry
; CHECK-COMMON-NEXT:    ldr r0, [r0, #4]
; CHECK-COMMON-NEXT:    bx lr
;
; CHECK-BE-LABEL: test_lshr_load64_4:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldr r0, [r0]
; CHECK-BE-NEXT:    bx lr
;
; CHECK-V6M-LABEL: test_lshr_load64_4:
; CHECK-V6M:       @ %bb.0: @ %entry
; CHECK-V6M-NEXT:    ldr r0, [r0, #4]
; CHECK-V6M-NEXT:    bx lr
entry:
  %0 = load i64, i64* %a, align 8
  %1 = lshr i64 %0, 32
  %conv = trunc i64 %1 to i32
  ret i32 %conv
}

define arm_aapcscc i32 @test_lshr_load64_2(i64* %a) {
; CHECK-COMMON-LABEL: test_lshr_load64_2:
; CHECK-COMMON:       @ %bb.0: @ %entry
; CHECK-COMMON-NEXT:    ldrh r0, [r0, #6]
; CHECK-COMMON-NEXT:    bx lr
;
; CHECK-BE-LABEL: test_lshr_load64_2:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldrh r0, [r0]
; CHECK-BE-NEXT:    bx lr
;
; CHECK-V6M-LABEL: test_lshr_load64_2:
; CHECK-V6M:       @ %bb.0: @ %entry
; CHECK-V6M-NEXT:    ldrh r0, [r0, #6]
; CHECK-V6M-NEXT:    bx lr
entry:
  %0 = load i64, i64* %a, align 8
  %1 = lshr i64 %0, 48
  %conv = trunc i64 %1 to i32
  ret i32 %conv
}

define arm_aapcscc i32 @test_lshr_load4_fail(i64* %a) {
; CHECK-ARM-LABEL: test_lshr_load4_fail:
; CHECK-ARM:       @ %bb.0: @ %entry
; CHECK-ARM-NEXT:    ldrd r0, r1, [r0]
; CHECK-ARM-NEXT:    lsr r0, r0, #8
; CHECK-ARM-NEXT:    orr r0, r0, r1, lsl #24
; CHECK-ARM-NEXT:    bx lr
;
; CHECK-BE-LABEL: test_lshr_load4_fail:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldrd r0, r1, [r0]
; CHECK-BE-NEXT:    lsr r1, r1, #8
; CHECK-BE-NEXT:    orr r0, r1, r0, lsl #24
; CHECK-BE-NEXT:    bx lr
;
; CHECK-THUMB-LABEL: test_lshr_load4_fail:
; CHECK-THUMB:       @ %bb.0: @ %entry
; CHECK-THUMB-NEXT:    ldrd r0, r1, [r0]
; CHECK-THUMB-NEXT:    lsrs r0, r0, #8
; CHECK-THUMB-NEXT:    orr.w r0, r0, r1, lsl #24
; CHECK-THUMB-NEXT:    bx lr
;
; CHECK-ALIGN-LABEL: test_lshr_load4_fail:
; CHECK-ALIGN:       @ %bb.0: @ %entry
; CHECK-ALIGN-NEXT:    ldrd r0, r1, [r0]
; CHECK-ALIGN-NEXT:    lsrs r0, r0, #8
; CHECK-ALIGN-NEXT:    orr.w r0, r0, r1, lsl #24
; CHECK-ALIGN-NEXT:    bx lr
;
; CHECK-V6M-LABEL: test_lshr_load4_fail:
; CHECK-V6M:       @ %bb.0: @ %entry
; CHECK-V6M-NEXT:    ldr r1, [r0]
; CHECK-V6M-NEXT:    ldr r0, [r0, #4]
; CHECK-V6M-NEXT:    lsls r0, r0, #24
; CHECK-V6M-NEXT:    lsrs r1, r1, #8
; CHECK-V6M-NEXT:    adds r0, r1, r0
; CHECK-V6M-NEXT:    bx lr
entry:
  %0 = load i64, i64* %a, align 8
  %1 = lshr i64 %0, 8
  %conv = trunc i64 %1 to i32
  ret i32 %conv
}

define arm_aapcscc void @test_shift7_mask8(i32* nocapture %p) {
; CHECK-COMMON-LABEL: test_shift7_mask8:
; CHECK-COMMON:       @ %bb.0: @ %entry
; CHECK-COMMON-NEXT:    ldr r1, [r0]
; CHECK-COMMON-NEXT:    ubfx r1, r1, #7, #8
; CHECK-COMMON-NEXT:    str r1, [r0]
; CHECK-COMMON-NEXT:    bx lr
;
; CHECK-BE-LABEL: test_shift7_mask8:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldr r1, [r0]
; CHECK-BE-NEXT:    ubfx r1, r1, #7, #8
; CHECK-BE-NEXT:    str r1, [r0]
; CHECK-BE-NEXT:    bx lr
;
; CHECK-V6M-LABEL: test_shift7_mask8:
; CHECK-V6M:       @ %bb.0: @ %entry
; CHECK-V6M-NEXT:    ldr r1, [r0]
; CHECK-V6M-NEXT:    lsrs r1, r1, #7
; CHECK-V6M-NEXT:    uxtb r1, r1
; CHECK-V6M-NEXT:    str r1, [r0]
; CHECK-V6M-NEXT:    bx lr
entry:
  %0 = load i32, i32* %p, align 4
  %shl = lshr i32 %0, 7
  %and = and i32 %shl, 255
  store i32 %and, i32* %p, align 4
  ret void
}

define arm_aapcscc void @test_shift8_mask8(i32* nocapture %p) {
; CHECK-COMMON-LABEL: test_shift8_mask8:
; CHECK-COMMON:       @ %bb.0: @ %entry
; CHECK-COMMON-NEXT:    ldrb r1, [r0, #1]
; CHECK-COMMON-NEXT:    str r1, [r0]
; CHECK-COMMON-NEXT:    bx lr
;
; CHECK-BE-LABEL: test_shift8_mask8:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldrb r1, [r0, #2]
; CHECK-BE-NEXT:    str r1, [r0]
; CHECK-BE-NEXT:    bx lr
;
; CHECK-V6M-LABEL: test_shift8_mask8:
; CHECK-V6M:       @ %bb.0: @ %entry
; CHECK-V6M-NEXT:    ldrb r1, [r0, #1]
; CHECK-V6M-NEXT:    str r1, [r0]
; CHECK-V6M-NEXT:    bx lr
entry:
  %0 = load i32, i32* %p, align 4
  %shl = lshr i32 %0, 8
  %and = and i32 %shl, 255
  store i32 %and, i32* %p, align 4
  ret void
}

define arm_aapcscc void @test_shift8_mask7(i32* nocapture %p) {
; CHECK-COMMON-LABEL: test_shift8_mask7:
; CHECK-COMMON:       @ %bb.0: @ %entry
; CHECK-COMMON-NEXT:    ldr r1, [r0]
; CHECK-COMMON-NEXT:    ubfx r1, r1, #8, #7
; CHECK-COMMON-NEXT:    str r1, [r0]
; CHECK-COMMON-NEXT:    bx lr
;
; CHECK-BE-LABEL: test_shift8_mask7:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldr r1, [r0]
; CHECK-BE-NEXT:    ubfx r1, r1, #8, #7
; CHECK-BE-NEXT:    str r1, [r0]
; CHECK-BE-NEXT:    bx lr
;
; CHECK-V6M-LABEL: test_shift8_mask7:
; CHECK-V6M:       @ %bb.0: @ %entry
; CHECK-V6M-NEXT:    ldr r1, [r0]
; CHECK-V6M-NEXT:    lsls r1, r1, #17
; CHECK-V6M-NEXT:    lsrs r1, r1, #25
; CHECK-V6M-NEXT:    str r1, [r0]
; CHECK-V6M-NEXT:    bx lr
entry:
  %0 = load i32, i32* %p, align 4
  %shl = lshr i32 %0, 8
  %and = and i32 %shl, 127
  store i32 %and, i32* %p, align 4
  ret void
}

define arm_aapcscc void @test_shift9_mask8(i32* nocapture %p) {
; CHECK-COMMON-LABEL: test_shift9_mask8:
; CHECK-COMMON:       @ %bb.0: @ %entry
; CHECK-COMMON-NEXT:    ldr r1, [r0]
; CHECK-COMMON-NEXT:    ubfx r1, r1, #9, #8
; CHECK-COMMON-NEXT:    str r1, [r0]
; CHECK-COMMON-NEXT:    bx lr
;
; CHECK-BE-LABEL: test_shift9_mask8:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldr r1, [r0]
; CHECK-BE-NEXT:    ubfx r1, r1, #9, #8
; CHECK-BE-NEXT:    str r1, [r0]
; CHECK-BE-NEXT:    bx lr
;
; CHECK-V6M-LABEL: test_shift9_mask8:
; CHECK-V6M:       @ %bb.0: @ %entry
; CHECK-V6M-NEXT:    ldr r1, [r0]
; CHECK-V6M-NEXT:    lsrs r1, r1, #9
; CHECK-V6M-NEXT:    uxtb r1, r1
; CHECK-V6M-NEXT:    str r1, [r0]
; CHECK-V6M-NEXT:    bx lr
entry:
  %0 = load i32, i32* %p, align 4
  %shl = lshr i32 %0, 9
  %and = and i32 %shl, 255
  store i32 %and, i32* %p, align 4
  ret void
}

define arm_aapcscc void @test_shift8_mask16(i32* nocapture %p) {
; CHECK-ARM-LABEL: test_shift8_mask16:
; CHECK-ARM:       @ %bb.0: @ %entry
; CHECK-ARM-NEXT:    ldrh r1, [r0, #1]
; CHECK-ARM-NEXT:    str r1, [r0]
; CHECK-ARM-NEXT:    bx lr
;
; CHECK-BE-LABEL: test_shift8_mask16:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldrh r1, [r0, #1]
; CHECK-BE-NEXT:    str r1, [r0]
; CHECK-BE-NEXT:    bx lr
;
; CHECK-THUMB-LABEL: test_shift8_mask16:
; CHECK-THUMB:       @ %bb.0: @ %entry
; CHECK-THUMB-NEXT:    ldrh.w r1, [r0, #1]
; CHECK-THUMB-NEXT:    str r1, [r0]
; CHECK-THUMB-NEXT:    bx lr
;
; CHECK-ALIGN-LABEL: test_shift8_mask16:
; CHECK-ALIGN:       @ %bb.0: @ %entry
; CHECK-ALIGN-NEXT:    ldr r1, [r0]
; CHECK-ALIGN-NEXT:    ubfx r1, r1, #8, #16
; CHECK-ALIGN-NEXT:    str r1, [r0]
; CHECK-ALIGN-NEXT:    bx lr
;
; CHECK-V6M-LABEL: test_shift8_mask16:
; CHECK-V6M:       @ %bb.0: @ %entry
; CHECK-V6M-NEXT:    ldr r1, [r0]
; CHECK-V6M-NEXT:    lsrs r1, r1, #8
; CHECK-V6M-NEXT:    uxth r1, r1
; CHECK-V6M-NEXT:    str r1, [r0]
; CHECK-V6M-NEXT:    bx lr
entry:
  %0 = load i32, i32* %p, align 4
  %shl = lshr i32 %0, 8
  %and = and i32 %shl, 65535
  store i32 %and, i32* %p, align 4
  ret void
}

define arm_aapcscc void @test_shift15_mask16(i32* nocapture %p) {
; CHECK-COMMON-LABEL: test_shift15_mask16:
; CHECK-COMMON:       @ %bb.0: @ %entry
; CHECK-COMMON-NEXT:    ldr r1, [r0]
; CHECK-COMMON-NEXT:    ubfx r1, r1, #15, #16
; CHECK-COMMON-NEXT:    str r1, [r0]
; CHECK-COMMON-NEXT:    bx lr
;
; CHECK-BE-LABEL: test_shift15_mask16:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldr r1, [r0]
; CHECK-BE-NEXT:    ubfx r1, r1, #15, #16
; CHECK-BE-NEXT:    str r1, [r0]
; CHECK-BE-NEXT:    bx lr
;
; CHECK-V6M-LABEL: test_shift15_mask16:
; CHECK-V6M:       @ %bb.0: @ %entry
; CHECK-V6M-NEXT:    ldr r1, [r0]
; CHECK-V6M-NEXT:    lsrs r1, r1, #15
; CHECK-V6M-NEXT:    uxth r1, r1
; CHECK-V6M-NEXT:    str r1, [r0]
; CHECK-V6M-NEXT:    bx lr
entry:
  %0 = load i32, i32* %p, align 4
  %shl = lshr i32 %0, 15
  %and = and i32 %shl, 65535
  store i32 %and, i32* %p, align 4
  ret void
}

define arm_aapcscc void @test_shift16_mask15(i32* nocapture %p) {
; CHECK-COMMON-LABEL: test_shift16_mask15:
; CHECK-COMMON:       @ %bb.0: @ %entry
; CHECK-COMMON-NEXT:    ldrh r1, [r0, #2]
; CHECK-COMMON-NEXT:    bfc r1, #15, #17
; CHECK-COMMON-NEXT:    str r1, [r0]
; CHECK-COMMON-NEXT:    bx lr
;
; CHECK-BE-LABEL: test_shift16_mask15:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldrh r1, [r0]
; CHECK-BE-NEXT:    bfc r1, #15, #17
; CHECK-BE-NEXT:    str r1, [r0]
; CHECK-BE-NEXT:    bx lr
;
; CHECK-V6M-LABEL: test_shift16_mask15:
; CHECK-V6M:       @ %bb.0: @ %entry
; CHECK-V6M-NEXT:    ldrh r1, [r0, #2]
; CHECK-V6M-NEXT:    ldr r2, .LCPI21_0
; CHECK-V6M-NEXT:    ands r2, r1
; CHECK-V6M-NEXT:    str r2, [r0]
; CHECK-V6M-NEXT:    bx lr
; CHECK-V6M-NEXT:    .p2align 2
; CHECK-V6M-NEXT:  @ %bb.1:
; CHECK-V6M-NEXT:  .LCPI21_0:
; CHECK-V6M-NEXT:    .long 32767 @ 0x7fff
entry:
  %0 = load i32, i32* %p, align 4
  %shl = lshr i32 %0, 16
  %and = and i32 %shl, 32767
  store i32 %and, i32* %p, align 4
  ret void
}

define arm_aapcscc void @test_shift8_mask24(i32* nocapture %p) {
; CHECK-ARM-LABEL: test_shift8_mask24:
; CHECK-ARM:       @ %bb.0: @ %entry
; CHECK-ARM-NEXT:    ldr r1, [r0]
; CHECK-ARM-NEXT:    lsr r1, r1, #8
; CHECK-ARM-NEXT:    str r1, [r0]
; CHECK-ARM-NEXT:    bx lr
;
; CHECK-BE-LABEL: test_shift8_mask24:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldr r1, [r0]
; CHECK-BE-NEXT:    lsr r1, r1, #8
; CHECK-BE-NEXT:    str r1, [r0]
; CHECK-BE-NEXT:    bx lr
;
; CHECK-THUMB-LABEL: test_shift8_mask24:
; CHECK-THUMB:       @ %bb.0: @ %entry
; CHECK-THUMB-NEXT:    ldr r1, [r0]
; CHECK-THUMB-NEXT:    lsrs r1, r1, #8
; CHECK-THUMB-NEXT:    str r1, [r0]
; CHECK-THUMB-NEXT:    bx lr
;
; CHECK-ALIGN-LABEL: test_shift8_mask24:
; CHECK-ALIGN:       @ %bb.0: @ %entry
; CHECK-ALIGN-NEXT:    ldr r1, [r0]
; CHECK-ALIGN-NEXT:    lsrs r1, r1, #8
; CHECK-ALIGN-NEXT:    str r1, [r0]
; CHECK-ALIGN-NEXT:    bx lr
;
; CHECK-V6M-LABEL: test_shift8_mask24:
; CHECK-V6M:       @ %bb.0: @ %entry
; CHECK-V6M-NEXT:    ldr r1, [r0]
; CHECK-V6M-NEXT:    lsrs r1, r1, #8
; CHECK-V6M-NEXT:    str r1, [r0]
; CHECK-V6M-NEXT:    bx lr
entry:
  %0 = load i32, i32* %p, align 4
  %shl = lshr i32 %0, 8
  %and = and i32 %shl, 16777215
  store i32 %and, i32* %p, align 4
  ret void
}

define arm_aapcscc void @test_shift24_mask16(i32* nocapture %p) {
; CHECK-COMMON-LABEL: test_shift24_mask16:
; CHECK-COMMON:       @ %bb.0: @ %entry
; CHECK-COMMON-NEXT:    ldrb r1, [r0, #3]
; CHECK-COMMON-NEXT:    str r1, [r0]
; CHECK-COMMON-NEXT:    bx lr
;
; CHECK-BE-LABEL: test_shift24_mask16:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldrb r1, [r0]
; CHECK-BE-NEXT:    str r1, [r0]
; CHECK-BE-NEXT:    bx lr
;
; CHECK-V6M-LABEL: test_shift24_mask16:
; CHECK-V6M:       @ %bb.0: @ %entry
; CHECK-V6M-NEXT:    ldrb r1, [r0, #3]
; CHECK-V6M-NEXT:    str r1, [r0]
; CHECK-V6M-NEXT:    bx lr
entry:
  %0 = load i32, i32* %p, align 4
  %shl = lshr i32 %0, 24
  %and = and i32 %shl, 65535
  store i32 %and, i32* %p, align 4
  ret void
}

define arm_aapcscc void @test_sext_shift8_mask8(i16* %p, i32* %q) {
; CHECK-COMMON-LABEL: test_sext_shift8_mask8:
; CHECK-COMMON:       @ %bb.0: @ %entry
; CHECK-COMMON-NEXT:    ldrb r0, [r0, #1]
; CHECK-COMMON-NEXT:    str r0, [r1]
; CHECK-COMMON-NEXT:    bx lr
;
; CHECK-BE-LABEL: test_sext_shift8_mask8:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldrb r0, [r0]
; CHECK-BE-NEXT:    str r0, [r1]
; CHECK-BE-NEXT:    bx lr
;
; CHECK-V6M-LABEL: test_sext_shift8_mask8:
; CHECK-V6M:       @ %bb.0: @ %entry
; CHECK-V6M-NEXT:    ldrb r0, [r0, #1]
; CHECK-V6M-NEXT:    str r0, [r1]
; CHECK-V6M-NEXT:    bx lr
entry:
  %0 = load i16, i16* %p, align 4
  %1 = sext i16 %0 to i32
  %shl = lshr i32 %1, 8
  %and = and i32 %shl, 255
  store i32 %and, i32* %q, align 4
  ret void
}

define arm_aapcscc void @test_sext_shift8_mask16(i16* %p, i32* %q) {
; CHECK-ARM-LABEL: test_sext_shift8_mask16:
; CHECK-ARM:       @ %bb.0: @ %entry
; CHECK-ARM-NEXT:    ldrsh r0, [r0]
; CHECK-ARM-NEXT:    ubfx r0, r0, #8, #16
; CHECK-ARM-NEXT:    str r0, [r1]
; CHECK-ARM-NEXT:    bx lr
;
; CHECK-BE-LABEL: test_sext_shift8_mask16:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldrsh r0, [r0]
; CHECK-BE-NEXT:    ubfx r0, r0, #8, #16
; CHECK-BE-NEXT:    str r0, [r1]
; CHECK-BE-NEXT:    bx lr
;
; CHECK-THUMB-LABEL: test_sext_shift8_mask16:
; CHECK-THUMB:       @ %bb.0: @ %entry
; CHECK-THUMB-NEXT:    ldrsh.w r0, [r0]
; CHECK-THUMB-NEXT:    ubfx r0, r0, #8, #16
; CHECK-THUMB-NEXT:    str r0, [r1]
; CHECK-THUMB-NEXT:    bx lr
;
; CHECK-ALIGN-LABEL: test_sext_shift8_mask16:
; CHECK-ALIGN:       @ %bb.0: @ %entry
; CHECK-ALIGN-NEXT:    ldrsh.w r0, [r0]
; CHECK-ALIGN-NEXT:    ubfx r0, r0, #8, #16
; CHECK-ALIGN-NEXT:    str r0, [r1]
; CHECK-ALIGN-NEXT:    bx lr
;
; CHECK-V6M-LABEL: test_sext_shift8_mask16:
; CHECK-V6M:       @ %bb.0: @ %entry
; CHECK-V6M-NEXT:    movs r2, #0
; CHECK-V6M-NEXT:    ldrsh r0, [r0, r2]
; CHECK-V6M-NEXT:    lsrs r0, r0, #8
; CHECK-V6M-NEXT:    uxth r0, r0
; CHECK-V6M-NEXT:    str r0, [r1]
; CHECK-V6M-NEXT:    bx lr
entry:
  %0 = load i16, i16* %p, align 4
  %1 = sext i16 %0 to i32
  %shl = lshr i32 %1, 8
  %and = and i32 %shl, 65535
  store i32 %and, i32* %q, align 4
  ret void
}

define i1 @trunc_i64_mask_srl(i32 zeroext %AttrArgNo, i64* %ptr) {
; CHECK-ARM-LABEL: trunc_i64_mask_srl:
; CHECK-ARM:       @ %bb.0: @ %entry
; CHECK-ARM-NEXT:    ldrh r2, [r1, #4]
; CHECK-ARM-NEXT:    mov r1, #0
; CHECK-ARM-NEXT:    cmp r2, r0
; CHECK-ARM-NEXT:    movwhi r1, #1
; CHECK-ARM-NEXT:    mov r0, r1
; CHECK-ARM-NEXT:    bx lr
;
; CHECK-BE-LABEL: trunc_i64_mask_srl:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldrh r2, [r1, #2]
; CHECK-BE-NEXT:    mov r1, #0
; CHECK-BE-NEXT:    cmp r2, r0
; CHECK-BE-NEXT:    movwhi r1, #1
; CHECK-BE-NEXT:    mov r0, r1
; CHECK-BE-NEXT:    bx lr
;
; CHECK-THUMB-LABEL: trunc_i64_mask_srl:
; CHECK-THUMB:       @ %bb.0: @ %entry
; CHECK-THUMB-NEXT:    ldrh r2, [r1, #4]
; CHECK-THUMB-NEXT:    movs r1, #0
; CHECK-THUMB-NEXT:    cmp r2, r0
; CHECK-THUMB-NEXT:    it hi
; CHECK-THUMB-NEXT:    movhi r1, #1
; CHECK-THUMB-NEXT:    mov r0, r1
; CHECK-THUMB-NEXT:    bx lr
;
; CHECK-ALIGN-LABEL: trunc_i64_mask_srl:
; CHECK-ALIGN:       @ %bb.0: @ %entry
; CHECK-ALIGN-NEXT:    ldrh r2, [r1, #4]
; CHECK-ALIGN-NEXT:    movs r1, #0
; CHECK-ALIGN-NEXT:    cmp r2, r0
; CHECK-ALIGN-NEXT:    it hi
; CHECK-ALIGN-NEXT:    movhi r1, #1
; CHECK-ALIGN-NEXT:    mov r0, r1
; CHECK-ALIGN-NEXT:    bx lr
;
; CHECK-V6M-LABEL: trunc_i64_mask_srl:
; CHECK-V6M:       @ %bb.0: @ %entry
; CHECK-V6M-NEXT:    ldrh r1, [r1, #4]
; CHECK-V6M-NEXT:    cmp r1, r0
; CHECK-V6M-NEXT:    bhi .LBB26_2
; CHECK-V6M-NEXT:  @ %bb.1: @ %entry
; CHECK-V6M-NEXT:    movs r0, #0
; CHECK-V6M-NEXT:    bx lr
; CHECK-V6M-NEXT:  .LBB26_2:
; CHECK-V6M-NEXT:    movs r0, #1
; CHECK-V6M-NEXT:    bx lr
entry:
  %bf.load.i = load i64, i64* %ptr, align 8
  %bf.lshr.i = lshr i64 %bf.load.i, 32
  %0 = trunc i64 %bf.lshr.i to i32
  %bf.cast.i = and i32 %0, 65535
  %cmp.i = icmp ugt i32 %bf.cast.i, %AttrArgNo
  ret i1 %cmp.i
}