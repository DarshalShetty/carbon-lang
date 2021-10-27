// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#ifndef EXECUTABLE_SEMANTICS_AST_UNIMPLEMENTED_H_
#define EXECUTABLE_SEMANTICS_AST_UNIMPLEMENTED_H_

#include <string>
#include <vector>

#include "common/ostream.h"
#include "executable_semantics/ast/source_location.h"
#include "executable_semantics/common/any_printable_ptr.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/StringExtras.h"

namespace Carbon {

// AST node type representing an unimplemented syntax. NodeBase must be
// one of the base AST node types (Expression, Statement, Pattern, or
// Declaration).
template <typename NodeBase>
class Unimplemented : public NodeBase {
 public:
  // Constructs an Unimplemented node standing in for a future node type named
  // `kind`, with the given children.
  explicit Unimplemented(std::string kind,
                         std::vector<AnyPrintablePtr> children,
                         SourceLocation source_loc)
      : NodeBase(NodeBase::Kind::Unimplemented, source_loc),
        kind_str_(std::move(kind)),
        children_(std::move(children)) {}

  static auto classof(const NodeBase* exp) -> bool {
    return exp->kind() == NodeBase::Kind::Unimplemented;
  }

  auto children() const -> llvm::ArrayRef<AnyPrintablePtr> { return children_; }

  // Prints an unambiguous representation of this node to `out`. Equivalent
  // to `Print`, but with a separate name to avoid colliding with
  // NodeBase::Print. Note that unlike other AST node types, the printed form
  // of Unimplemented cannot be re-parsed.
  void PrintImpl(llvm::raw_ostream& out) const {
    llvm::ListSeparator sep;
    out << "Unimplemented " << kind_str_ << "(";
    for (const AnyPrintablePtr& child : children()) {
      out << sep << child;
    }
    out << ")";
  }

 private:
  std::string kind_str_;
  std::vector<AnyPrintablePtr> children_;
};

}  // namespace Carbon

#endif  // EXECUTABLE_SEMANTICS_AST_UNIMPLEMENTED_H_
