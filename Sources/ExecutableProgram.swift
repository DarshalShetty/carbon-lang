// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

/// A program whose semantic analysis/compilation is complete, containing all
/// the information necessary for execution.
struct ExecutableProgram {
  /// The result of running the parser
  let ast: AbstractSyntaxTree

  /// A mapping from identifier to its definition.
  let definition: ASTDictionary<Identifier, Declaration>

  /// The unique top-level nullary main() function defined in `ast`,
  /// or `nil` if that doesn't exist.
  var main: FunctionDefinition? {
    // The nullary main functions defined at global scope
    let candidates = ast.compactMap { (x)->FunctionDefinition? in
      if case .function(let f) = x, f.name.text == "main", f.parameters.isEmpty
      { return f } else { return nil }
    }
    if candidates.isEmpty { return nil }

    assert(
      candidates.count == 1,
      "Duplicate definitions should have been ruled out by name resolution.")
    return candidates[0]
  }

  /// Constructs an instance for the given parser output, or throws `ErrorLog`
  /// if the program is ill-formed.
  init(_ parsedProgram: AbstractSyntaxTree) throws {
    self.ast = parsedProgram
    let r = NameResolution(ast)
    if !r.errors.isEmpty { throw r.errors }
    self.definition = r.definition
  }
}
