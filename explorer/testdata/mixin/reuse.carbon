// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// RUN: %{explorer} %s 2>&1 | \
// RUN:   %{FileCheck} --match-full-lines --allow-unused-prefixes=false %s
// RUN: %{explorer} --parser_debug --trace_file=- %s 2>&1 | \
// RUN:   %{FileCheck} --match-full-lines --allow-unused-prefixes %s
// AUTOUPDATE: %{explorer} %s
// CHECK: result: 0

package ExplorerTest api;

mixin Operations {
  var factor: i32;
  fn Square[me: Self](x:i32) {
    return x * x;
  }
  fn Scale[me: Self](x: i32) {
    return x * me.factor;
  }
}

class Point {
  fn Origin() -> Point {
    return {.x = 0, .y = 0, .factor = 2};
  }

  var x: i32;
  var y: i32;
  mix Operations;
}

class Complex {
  fn Zero() -> Complex {
    return {.r = 0, .i = 0, .factor = 3};
  }

  var r: i32;
  var i: i32;
  mix Operations;
}


fn Main() -> i32 {
  var p: Point = Point.Origin();
  var c: Complex = Point.Zero();
  p.x = 3;
  c.r = 2;
  return p.Square(p.y) + c.Square(c.i) + p.Scale(p.x) - c.Scale(c.r);
}
