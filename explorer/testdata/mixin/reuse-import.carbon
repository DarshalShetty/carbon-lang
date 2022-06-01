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

interface IO {
  fn Read[me: Self]() -> i32;
  fn Write[me: Self](data: i32);
}

mixin Encrypt for IO {
  var key: i32;
  fn EncryptRead[me: Self]() -> i32 {
    return me.Encrypt(me.Read());
  }

  fn EncryptWrite[me: Self](data: i32) {
    me.Write(me.Encrypt(data));
  }

  fn Encrypt[me: Self](data: i32) -> i32{
    return data + me.key;
  }
}

class File {
  impl File as IO {
    fn Read[me: Self]() -> i32 {
      return me.buffer;
    }
   // fn Write[addr me: Self*](data: i32) {
   //   (*me).buffer = data;
   // }
    fn Write[me: Self](data: i32) {
      // write
    }
  }
  fn Init(key: i32) -> File {
    return {.key = key, .buffer = 0};

  }
  mix Encrypt;
  var buffer: i32;
}

class Socket {
  impl File as IO {
    fn Read[me: Self]() -> i32 {
      return me.buffer;
    }
    //fn Write[addr me: Self*](data: i32) {
    //  (*me).buffer = data;
    //}
    fn Write[me: Self](data: i32) {
      // write
    }
  }
  fn Init(key: i32) -> Socket {
    return {.key = key, .buffer = 0, .host = 127, .port = 8080};

  }
  mix Encrypt;
  var buffer: i32;
  var host: i32;
  var port: i32;
}


fn Main() -> i32 {
  let key: i32 = 23;
  var f: File = File.Init(key);
  var s: Socket = Socket.Init(key);
  let data: i32 = 42;
  f.Write(data);
  s.Write(data);
  if ((f.EncryptRead() - s.EncryptRead() == 0)) {
  } else {
    return 1;
  }
  f.EncryptWrite(data);
  s.EncryptWrite(data);
  if ((f.Read() - s.Read() == 0)) {
  } else {
    return 1;
  }
  return 0;
}
