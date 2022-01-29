; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O0 -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:   -fast-isel -mcpu=pwr10 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN:   FileCheck %s

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [25 x i8] c"Breaking the TOC for FP\0A\00", align 1
@.str.1 = private unnamed_addr constant [25 x i8] c"Breaking the TOC for GV\0A\00", align 1
@stdout = external global %struct._IO_FILE*, align 8

; Function Attrs: noinline nounwind optnone
define internal void @loadFP(double* %d) #0 {
; CHECK-LABEL: loadFP:
; CHECK:         .localentry loadFP, 1
; CHECK-NEXT:  # %bb.0: # %entry
; CHECK-NEXT:    mflr r0
; CHECK-NEXT:    std r0, 16(r1)
; CHECK-NEXT:    stdu r1, -112(r1)
; CHECK-NEXT:    std r3, 104(r1)
; CHECK-NEXT:    paddi r3, 0, .L.str@PCREL, 1
; CHECK-NEXT:    bl printf@notoc
; CHECK-NEXT:    ld r4, 104(r1)
; CHECK-NEXT:    pli r5, 1075049922
; CHECK-NEXT:    pli r3, 2405181686
; CHECK-NEXT:    rldimi r3, r5, 32, 0
; CHECK-NEXT:    std r3, 0(r4)
; CHECK-NEXT:    addi r1, r1, 112
; CHECK-NEXT:    ld r0, 16(r1)
; CHECK-NEXT:    mtlr r0
; CHECK-NEXT:    blr
entry:
  %d.addr = alloca double*, align 8
  store double* %d, double** %d.addr, align 8
  %call = call signext i32 (i8*, ...) @printf(i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str, i64 0, i64 0))
  %0 = load double*, double** %d.addr, align 8
  store double 4.990000e+00, double* %0, align 8
  ret void
}

declare signext i32 @printf(i8*, ...)

; Function Attrs: noinline nounwind optnone
define internal void @loadGV() #0 {
; CHECK-LABEL: loadGV:
; CHECK:         .localentry loadGV, 1
; CHECK-NEXT:  # %bb.0: # %entry
; CHECK-NEXT:    mflr r0
; CHECK-NEXT:    std r0, 16(r1)
; CHECK-NEXT:    stdu r1, -96(r1)
; CHECK-NEXT:    paddi r3, 0, .L.str.1@PCREL, 1
; CHECK-NEXT:    bl printf@notoc
; CHECK-NEXT:    pld r3, stdout@got@pcrel(0), 1
; CHECK-NEXT:    ld r4, 0(r3)
; CHECK-NEXT:    li r3, 97
; CHECK-NEXT:    bl _IO_putc@notoc
; CHECK-NEXT:    addi r1, r1, 96
; CHECK-NEXT:    ld r0, 16(r1)
; CHECK-NEXT:    mtlr r0
; CHECK-NEXT:    blr
entry:
  %call = call signext i32 (i8*, ...) @printf(i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str.1, i64 0, i64 0))
  %0 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8
  %call1 = call signext i32 @_IO_putc(i32 signext 97, %struct._IO_FILE* %0)
  ret void
}

declare signext i32 @_IO_putc(i32 signext, %struct._IO_FILE*)

attributes #0 = { noinline nounwind optnone }