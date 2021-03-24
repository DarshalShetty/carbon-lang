// -*- mode: lemon; -*-
// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

%class_name CarbonParser

%preface {
}                         

%token_type {(text: String, position: CitronLexerPosition)}

%nonterminal_type input {[Declaration]}
%nonterminal_type pattern Expression
%nonterminal_type expression Expression
%nonterminal_type member_designator MemberDesignator
%nonterminal_type paren_expression Expression
%nonterminal_type tuple TupleLiteral
%nonterminal_type field Expression
%nonterminal_type field_list {[Expression]}
%nonterminal_type match_clause MatchClause
%nonterminal_type match_clause_list {[MatchClause]}
%nonterminal_type statement Statement
%nonterminal_type optional_else {Statement?}
%nonterminal_type statement_list {[Statement]}
%nonterminal_type return_type TypeExpression
%nonterminal_type function_definition FunctionDefinition
%nonterminal_type function_declaration FunctionDeclaration
%nonterminal_type variable_declaration {(name: String, type: Expression)}
%nonterminal_type member Member
%nonterminal_type member_list {[Member]}
%nonterminal_type alternative Alternative
%nonterminal_type alternative_list {[Alternative]}
%nonterminal_type declaration Declaration
%nonterminal_type declaration_list {[Declaration]}

%nonassociative LEFT_CURLY_BRACE RIGHT_CURLY_BRACE.
%nonassociative COLON COMMA DBLARROW.
%left_associative OR AND.
%nonassociative EQUAL_EQUAL NOT.
%left_associative PLUS MINUS.
%left_associative PERIOD ARROW.
%nonassociative LEFT_PARENTHESIS RIGHT_PARENTHESIS.
%nonassociative LEFT_SQUARE_BRACKET RIGHT_SQUARE_BRACKET.
%start_symbol input

input ::= declaration_list.
    /* { d } */
pattern ::= expression.
expression ::= IDENTIFIER.
    {} /* { $$ = Carbon::MakeVar(yylineno, $1); } */
expression ::= expression member_designator.
    {} /* { $$ = Carbon::MakeGetField(yylineno, $1, $2); } */
expression ::= expression LEFT_SQUARE_BRACKET expression RIGHT_SQUARE_BRACKET.
    {} /* { $$ = Carbon::MakeIndex(yylineno, $1, $3); } */
expression ::= expression COLON Identifier.
    {} /* { $$ = Carbon::MakeVarPat(yylineno, $3, $1); } */
expression ::= Integer_literal.
    {} /* { $$ = Carbon::MakeInt(yylineno, $1); } */
expression ::= TRUE.
    {} /* { $$ = Carbon::MakeBool(yylineno, true); } */
expression ::= FALSE.
    {} /* { $$ = Carbon::MakeBool(yylineno, false); } */
expression ::= INT.
    {} /* { $$ = Carbon::MakeIntType(yylineno); } */
expression ::= BOOL.
    {} /* { $$ = Carbon::MakeBoolType(yylineno); } */
expression ::= TYPE.
    {} /* { $$ = Carbon::MakeTypeType(yylineno); } */
expression ::= AUTO.
    {} /* { $$ = Carbon::MakeAutoType(yylineno); } */
expression ::= paren_expression.
    {} /*{ $$ = $1; } */
expression ::= expression EQUAL_EQUAL expression.
    {} /* { $$ = Carbon::MakeBinOp(yylineno, Carbon::Operator::Eq, $1, $3); } */
expression ::= expression PLUS expression.
    {} /* { $$ = Carbon::MakeBinOp(yylineno, Carbon::Operator::Add, $1, $3); } */
expression ::= expression MINUS expression.
    {} /* { $$ = Carbon::MakeBinOp(yylineno, Carbon::Operator::Sub, $1, $3); } */
expression ::= expression AND expression.
    {} /* { $$ = Carbon::MakeBinOp(yylineno, Carbon::Operator::And, $1, $3); } */
expression ::= expression OR expression.
    {} /* { $$ = Carbon::MakeBinOp(yylineno, Carbon::Operator::Or, $1, $3); } */
expression ::= NOT expression.
    {} /* { $$ = Carbon::MakeUnOp(yylineno, Carbon::Operator::Not, $2); } */
expression ::= MINUS expression.
    {} /* { $$ = Carbon::MakeUnOp(yylineno, Carbon::Operator::Neg, $2); } */
expression ::= expression tuple.
    {} /* { $$ = Carbon::MakeCall(yylineno, $1, $2); } */
expression ::= FNTY tuple return_type.
    {} /* { $$ = Carbon::MakeFunType(yylineno, $2, $3); } */
member_designator ::= PERIOD Identifier.
    {} /* { $$ = $2; } */
paren_expression ::= LEFT_PARENTHESIS field_list RIGHT_PARENTHESIS.
    {} /* {
     if ($2->fields->size() == 1 &&
         $2->fields->front().first == "" &&
	 !$2->has_explicit_comma) {
	$$ = $2->fields->front().second;
     } else {
        auto vec = new std::vector<std::pair<std::string,Carbon::Expression*>>(
            $2->fields->begin(), $2->fields->end());
        $$ = Carbon::MakeTuple(yylineno, vec);
      }
    } */
tuple ::= LEFT_PARENTHESIS field_list RIGHT_PARENTHESIS.
    {} /* {
     auto vec = new std::vector<std::pair<std::string,Carbon::Expression*>>(
         $2->fields->begin(), $2->fields->end());
     $$ = Carbon::MakeTuple(yylineno, vec);
    } */
field ::= pattern.
    {} /* {
      auto fields =
          new std::list<std::pair<std::string, Carbon::Expression*>>();
      fields->push_back(std::make_pair("", $1));
      $$ = Carbon::MakeFieldList(fields);
    } */
field ::= member_designator EQUAL pattern.
    {} /* {
      auto fields =
          new std::list<std::pair<std::string, Carbon::Expression*>>();
      fields->push_back(std::make_pair($1, $3));
      $$ = Carbon::MakeFieldList(fields);
    } */
field_list ::= /* Empty */.
    {} /* {
      $$ = Carbon::MakeFieldList(
          new std::list<std::pair<std::string, Carbon::Expression*>>());
    } */
field_list ::= field.
    {} /* { $$ = $1; } */
field_list ::= field COMMA field_list.
    {} /* { $$ = Carbon::MakeConsField($1, $3); } */
match_clause ::= CASE pattern DBLARROW statement.
    {} /* { $$ = new std::pair<Carbon::Expression*, Carbon::Statement*>($2, $4); } */
match_clause ::= DEFAULT DBLARROW statement.
    {} /* {
      auto vp = Carbon::MakeVarPat(yylineno, "_",
                                   Carbon::MakeAutoType(yylineno));
      $$ = new std::pair<Carbon::Expression*, Carbon::Statement*>(vp, $3);
    } */
match_clause_list ::= /* Empty */.
    {} /* {
      $$ = new std::list<std::pair<Carbon::Expression*, Carbon::Statement*>>();
    } */
match_clause_list ::= match_clause match_clause_list.
    {} /* { $$ = $2; $$->push_front(*$1); } */
statement ::= expression EQUAL expression SEMICOLON.
    {} /* { $$ = Carbon::MakeAssign(yylineno, $1, $3); } */
statement ::= VAR pattern MINUS expression SEMICOLON.
    {} /* { $$ = Carbon::MakeVarDef(yylineno, $2, $4); } */
statement ::= expression SEMICOLON.
    {} /* { $$ = Carbon::MakeExpStmt(yylineno, $1); } */
statement ::= IF LEFT_PARENTHESIS expression RIGHT_PARENTHESIS statement optional_else.
    {} /* { $$ = Carbon::MakeIf(yylineno, $3, $5, $6); } */
statement ::= WHILE LEFT_PARENTHESIS expression RIGHT_PARENTHESIS statement.
    {} /* { $$ = Carbon::MakeWhile(yylineno, $3, $5); } */
statement ::= BREAK SEMICOLON.
    {} /* { $$ = Carbon::MakeBreak(yylineno); } */
statement ::= CONTINUE SEMICOLON.
    {} /* { $$ = Carbon::MakeContinue(yylineno); } */
statement ::= RETURN expression SEMICOLON.
    {} /* { $$ = Carbon::MakeReturn(yylineno, $2); } */
statement ::= LEFT_CURLY_BRACE statement_list RIGHT_CURLY_BRACE.
    {} /* { $$ = Carbon::MakeBlock(yylineno, $2); } */
statement ::= MATCH LEFT_PARENTHESIS expression RIGHT_PARENTHESIS LEFT_CURLY_BRACE match_clause_list RIGHT_CURLY_BRACE.
    {} /* { $$ = Carbon::MakeMatch(yylineno, $3, $6); } */
optional_else ::= /* Empty */.
    {} /* { $$ = 0; } */
optional_else ::= ELSE statement.
   {} /* { $$ = $2; } */
statement_list ::= /* Empty */.
    {} /* { $$ = 0; } */
statement_list ::= statement statement_list.
    {} /* { $$ = Carbon::MakeSeq(yylineno, $1, $2); } */
return_type ::= /* Empty */.
    {} /* {
      $$ = Carbon::MakeTuple(
          yylineno,
          new std::vector<std::pair<std::string, Carbon::Expression*>>());
    } */
return_type ::= ARROW expression.
    {} /* { $$ = $2; } */
function_definition ::= FN Identifier tuple return_type LEFT_CURLY_BRACE statement_list RIGHT_CURLY_BRACE.
    {} /* { $$ = MakeFunDef(yylineno, $2, $4, $3, $6); } */
function_definition ::= FN Identifier tuple DBLARROW expression SEMICOLON.
    {} /* {
      $$ = Carbon::MakeFunDef(yylineno, $2, Carbon::MakeAutoType(yylineno), $3,
                              Carbon::MakeReturn(yylineno, $5));
    } */
function_declaration ::= FN Identifier tuple return_type SEMICOLON.
    {} /* { $$ = MakeFunDef(yylineno, $2, $4, $3, 0); } */
variable_declaration ::= expression COLON Identifier.
    {} /* { $$ = MakeField(yylineno, $3, $1); } */
member ::= VAR variable_declaration SEMICOLON.
    {} /* { $$ = $2; } */
member_list ::= /* Empty */.
    {} /* { $$ = new std::list<Carbon::Member*>(); } */
member_list ::= member member_list.
    {} /* { $$ = $2; $$->push_front($1); } */
alternative ::= Identifier tuple.
    {} /* { $$ = new std::pair<std::string, Carbon::Expression*>($1, $2); } */
alternative ::= Identifier.
    {} /* {
      $$ = new std::pair<std::string, Carbon::Expression*>(
          $1, Carbon::MakeTuple(
            yylineno,
            new std::vector<std::pair<std::string, Carbon::Expression*>>()));
    } */
alternative_list ::= /* Empty */.
    {} /* { $$ = new std::list<std::pair<std::string, Carbon::Expression*>>(); } */
alternative_list ::= alternative.
    {} /* {
      $$ = new std::list<std::pair<std::string, Carbon::Expression*>>();
      $$->push_front(*$1);
    } */
alternative_list ::= alternative COMMA alternative_list.
    {} /* { $$ = $3; $$->push_front(*$1); } */
declaration ::= function_definition.
    {} /* { $$ = new Carbon::Declaration(Carbon::FunctionDeclaration{$1}); } */
declaration ::= function_declaration.
    {} /* { $$ = new Carbon::Declaration(Carbon::FunctionDeclaration{$1}); } */
declaration ::= STRUCT Identifier LEFT_CURLY_BRACE member_list RIGHT_CURLY_BRACE.
    {} /* {
      $$ = new Carbon::Declaration(
        Carbon::StructDeclaration{yylineno, $2, $4});
    } */
declaration ::= CHOICE Identifier LEFT_CURLY_BRACE alternative_list RIGHT_CURLY_BRACE.
    {} /* {
      $$ = new Carbon::Declaration(
        Carbon::ChoiceDeclaration{yylineno, $2, std::list(*$4)});
    } */
declaration ::= VAR variable_declaration EQUAL expression SEMICOLON.
    {} /* {
      $$ = new Carbon::Declaration(
        Carbon::VariableDeclaration(yylineno, *$2->u.field.name, $2->u.field.type, $4));
    } */
declaration_list ::= /* Empty */.
    {} /* { $$ = new std::list<Carbon::Declaration>(); } */
declaration_list ::= declaration declaration_list.
    {} /* {
      $$ = $2;
      $$->push_front(*$1);
    } */
