; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -basic-aa -memcpyopt -verify-memoryssa | FileCheck %s
target datalayout = "E-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64"

declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture, i64, i1) nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i1) nounwind

; The resulting memset is only 4-byte aligned, despite containing
; a 16-byte aligned store in the middle.

define void @foo(i32* %p) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:    [[A0:%.*]] = getelementptr i32, i32* [[P:%.*]], i64 0
; CHECK-NEXT:    [[A1:%.*]] = getelementptr i32, i32* [[P]], i64 1
; CHECK-NEXT:    [[A2:%.*]] = getelementptr i32, i32* [[P]], i64 2
; CHECK-NEXT:    [[A3:%.*]] = getelementptr i32, i32* [[P]], i64 3
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32* [[A0]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 4 [[TMP1]], i8 0, i64 16, i1 false)
; CHECK-NEXT:    ret void
;
  %a0 = getelementptr i32, i32* %p, i64 0
  store i32 0, i32* %a0, align 4
  %a1 = getelementptr i32, i32* %p, i64 1
  store i32 0, i32* %a1, align 16
  %a2 = getelementptr i32, i32* %p, i64 2
  store i32 0, i32* %a2, align 4
  %a3 = getelementptr i32, i32* %p, i64 3
  store i32 0, i32* %a3, align 4
  ret void
}

; Replacing %a8 with %a4 in the memset requires boosting the alignment of %a4.

define void @bar() {
; CHECK-LABEL: @bar(
; CHECK-NEXT:    [[A4:%.*]] = alloca i32, align 8
; CHECK-NEXT:    [[A8:%.*]] = alloca i32, align 8
; CHECK-NEXT:    [[A8_CAST:%.*]] = bitcast i32* [[A8]] to i8*
; CHECK-NEXT:    [[A4_CAST:%.*]] = bitcast i32* [[A4]] to i8*
; CHECK-NEXT:    [[A41:%.*]] = bitcast i32* [[A4]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 8 [[A41]], i8 0, i64 4, i1 false)
; CHECK-NEXT:    ret void
;
  %a4 = alloca i32, align 4
  %a8 = alloca i32, align 8
  %a8.cast = bitcast i32* %a8 to i8*
  %a4.cast = bitcast i32* %a4 to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %a8.cast, i8 0, i64 4, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %a4.cast, i8* align 4 %a8.cast, i64 4, i1 false)
  ret void
}