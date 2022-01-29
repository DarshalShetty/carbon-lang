; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-amd-mesa3d -mcpu=gfx1010 -verify-machineinstrs < %s | FileCheck -check-prefix=GFX10 %s

define float @test_min_max_ValK0_K1_f32(float %a) #0 {
; GFX10-LABEL: test_min_max_ValK0_K1_f32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %maxnum = call nnan float @llvm.maxnum.f32(float %a, float 2.0)
  %fmed = call nnan float @llvm.minnum.f32(float %maxnum, float 4.0)
  ret float %fmed
}

define float @test_min_max_K0Val_K1_f32(float %a) #1 {
; GFX10-LABEL: test_min_max_K0Val_K1_f32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %maxnum = call nnan float @llvm.maxnum.f32(float 2.0, float %a)
  %fmed = call nnan float @llvm.minnum.f32(float %maxnum, float 4.0)
  ret float %fmed
}

; min-max patterns for ieee=true do not have to check for NaNs
; 'v_max_f16_e32 v0, v0, v0' is from fcanonicalize of the input to fmin/fmax with ieee=true
define half @test_min_K1max_ValK0_f16(half %a) #0 {
; GFX10-LABEL: test_min_K1max_ValK0_f16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_max_f16_e32 v0, v0, v0
; GFX10-NEXT:    v_med3_f16 v0, v0, 2.0, 4.0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %maxnum = call half @llvm.maxnum.f16(half %a, half 2.0)
  %fmed = call half @llvm.minnum.f16(half 4.0, half %maxnum)
  ret half %fmed
}

define half @test_min_K1max_K0Val_f16(half %a) #1 {
; GFX10-LABEL: test_min_K1max_K0Val_f16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_med3_f16 v0, v0, 2.0, 4.0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %maxnum = call nnan half @llvm.maxnum.f16(half 2.0, half %a)
  %fmed = call nnan half @llvm.minnum.f16(half 4.0, half %maxnum)
  ret half %fmed
}

; max-mix patterns work only for non-NaN inputs
define float @test_max_min_ValK1_K0_f32(float %a) #0 {
; GFX10-LABEL: test_max_min_ValK1_K0_f32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %minnum = call nnan float @llvm.minnum.f32(float %a, float 4.0)
  %fmed = call nnan float @llvm.maxnum.f32(float %minnum, float 2.0)
  ret float %fmed
}

define float @test_max_min_K1Val_K0_f32(float %a) #1 {
; GFX10-LABEL: test_max_min_K1Val_K0_f32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %minnum = call nnan float @llvm.minnum.f32(float 4.0, float %a)
  %fmed = call nnan float @llvm.maxnum.f32(float %minnum, float 2.0)
  ret float %fmed
}

define half @test_max_K0min_ValK1_f16(half %a) #0 {
; GFX10-LABEL: test_max_K0min_ValK1_f16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_med3_f16 v0, v0, 2.0, 4.0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %minnum = call nnan half @llvm.minnum.f16(half %a, half 4.0)
  %fmed = call nnan half @llvm.maxnum.f16(half 2.0, half %minnum)
  ret half %fmed
}

define half @test_max_K0min_K1Val_f16(half %a) #1 {
; GFX10-LABEL: test_max_K0min_K1Val_f16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_med3_f16 v0, v0, 2.0, 4.0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %minnum = call nnan half @llvm.minnum.f16(half 4.0, half %a)
  %fmed = call nnan half @llvm.maxnum.f16(half 2.0, half %minnum)
  ret half %fmed
}

; global nnan function attribute always forces fmed3 combine

define float @test_min_max_global_nnan(float %a) #2 {
; GFX10-LABEL: test_min_max_global_nnan:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %maxnum = call float @llvm.maxnum.f32(float %a, float 2.0)
  %fmed = call float @llvm.minnum.f32(float %maxnum, float 4.0)
  ret float %fmed
}

define float @test_max_min_global_nnan(float %a) #2 {
; GFX10-LABEL: test_max_min_global_nnan:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %minnum = call float @llvm.minnum.f32(float %a, float 4.0)
  %fmed = call float @llvm.maxnum.f32(float %minnum, float 2.0)
  ret float %fmed
}

; ------------------------------------------------------------------------------
; Negative patterns
; ------------------------------------------------------------------------------

; min(max(Val, K0), K1) K0 > K1, should be K0<=K1
define float @test_min_max_K0_gt_K1(float %a) #0 {
; GFX10-LABEL: test_min_max_K0_gt_K1:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_max_f32_e32 v0, 4.0, v0
; GFX10-NEXT:    v_min_f32_e32 v0, 2.0, v0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %maxnum = call nnan float @llvm.maxnum.f32(float %a, float 4.0)
  %fmed = call nnan float @llvm.minnum.f32(float %maxnum, float 2.0)
  ret float %fmed
}

; max(min(Val, K1), K0) K0 > K1, should be K0<=K1
define float @test_max_min_K0_gt_K1(float %a) #0 {
; GFX10-LABEL: test_max_min_K0_gt_K1:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_min_f32_e32 v0, 2.0, v0
; GFX10-NEXT:    v_max_f32_e32 v0, 4.0, v0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %minnum = call nnan float @llvm.minnum.f32(float %a, float 2.0)
  %fmed = call nnan float @llvm.maxnum.f32(float %minnum, float 4.0)
  ret float %fmed
}

; non-inline constant
define float @test_min_max_non_inline_const(float %a) #0 {
; GFX10-LABEL: test_min_max_non_inline_const:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_max_f32_e32 v0, 2.0, v0
; GFX10-NEXT:    v_min_f32_e32 v0, 0x41000000, v0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %maxnum = call nnan float @llvm.maxnum.f32(float %a, float 2.0)
  %fmed = call nnan float @llvm.minnum.f32(float %maxnum, float 8.0)
  ret float %fmed
}

; there is no fmed3 for f64 or v2f16 types

define double @test_min_max_f64(double %a) #0 {
; GFX10-LABEL: test_min_max_f64:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_max_f64 v[0:1], v[0:1], 2.0
; GFX10-NEXT:    v_min_f64 v[0:1], v[0:1], 4.0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %maxnum = call nnan double @llvm.maxnum.f64(double %a, double 2.0)
  %fmed = call nnan double @llvm.minnum.f64(double %maxnum, double 4.0)
  ret double %fmed
}

define <2 x half> @test_min_max_v2f16(<2 x half> %a) #0 {
; GFX10-LABEL: test_min_max_v2f16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_pk_max_f16 v0, v0, 2.0 op_sel_hi:[1,0]
; GFX10-NEXT:    v_pk_min_f16 v0, v0, 4.0 op_sel_hi:[1,0]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %maxnum = call nnan <2 x half> @llvm.maxnum.v2f16(<2 x half> %a, <2 x half> <half 2.0, half 2.0>)
  %fmed = call nnan <2 x half> @llvm.minnum.v2f16(<2 x half> %maxnum, <2 x half> <half 4.0, half 4.0>)
  ret <2 x half> %fmed
}

; input that can be NaN

; min-max patterns for ieee=false require known non-NaN input
define float @test_min_max_maybe_NaN_input_ieee_false(float %a) #1 {
; GFX10-LABEL: test_min_max_maybe_NaN_input_ieee_false:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_max_f32_e32 v0, 2.0, v0
; GFX10-NEXT:    v_min_f32_e32 v0, 4.0, v0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %maxnum = call float @llvm.maxnum.f32(float %a, float 2.0)
  %fmed = call float @llvm.minnum.f32(float %maxnum, float 4.0)
  ret float %fmed
}

; max-min patterns always require known non-NaN input

define float @test_max_min_maybe_NaN_input_ieee_false(float %a) #1 {
; GFX10-LABEL: test_max_min_maybe_NaN_input_ieee_false:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_min_f32_e32 v0, 4.0, v0
; GFX10-NEXT:    v_max_f32_e32 v0, 2.0, v0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %minnum = call float @llvm.minnum.f32(float %a, float 4.0)
  %fmed = call float @llvm.maxnum.f32(float %minnum, float 2.0)
  ret float %fmed
}

; 'v_max_f32_e32 v0, v0, v0' is from fcanonicalize of the input to fmin/fmax with ieee=true
define float @test_max_min_maybe_NaN_input_ieee_true(float %a) #0 {
; GFX10-LABEL: test_max_min_maybe_NaN_input_ieee_true:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_max_f32_e32 v0, v0, v0
; GFX10-NEXT:    v_min_f32_e32 v0, 4.0, v0
; GFX10-NEXT:    v_max_f32_e32 v0, 2.0, v0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %minnum = call float @llvm.minnum.f32(float %a, float 4.0)
  %fmed = call float @llvm.maxnum.f32(float %minnum, float 2.0)
  ret float %fmed
}

declare half @llvm.minnum.f16(half, half)
declare half @llvm.maxnum.f16(half, half)
declare float @llvm.minnum.f32(float, float)
declare float @llvm.maxnum.f32(float, float)
declare double @llvm.minnum.f64(double, double)
declare double @llvm.maxnum.f64(double, double)
declare <2 x half> @llvm.minnum.v2f16(<2 x half>, <2 x half>)
declare <2 x half> @llvm.maxnum.v2f16(<2 x half>, <2 x half>)
attributes #0 = {"amdgpu-ieee"="true"}
attributes #1 = {"amdgpu-ieee"="false"}
attributes #2 = {"no-nans-fp-math"="true"}