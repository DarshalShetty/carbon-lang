public enum TokenKind: String, CaseIterable {
  case AND =                   "and"
  case ARROW =                 "->"
  case AUTO =                  "auto"
  case BOOL =                  "bool"
  case BREAK =                 "break"
  case CASE =                  "case"
  case CHOICE =                "choice"
  case CONTINUE =              "continue"
  case DBLARROW =              "=>"
  case DEFAULT =               "default"
  case ELSE =                  "else"
  case EQUAL_EQUAL =           "=="
  case FALSE =                 "false"
  case FN =                    "fn"
  case FNTY =                  "fnty"
  case IF =                    "if"
  case INT =                   "int"
  case MATCH =                 "match"
  case NOT =                   "not"
  case OR =                    "or"
  case RETURN =                "return"
  case STRUCT =                "struct"
  case TRUE =                  "true"
  case TYPE =                  "type"
  case VAR =                   "var"
  case WHILE =                 "while"
  case EQUAL =                 "="
  case MINUS =                 "-"
  case PLUS =                  "+"
  case STAR =                  "*"
  case SLASH =                 "/"
  case LEFT_PARENTHESIS =      "("
  case RIGHT_PARENTHESIS =     ")"
  case LEFT_CURLY_BRACE =      "{"
  case RIGHT_CURLY_BRACE =     "}"
  case LEFT_SQUARE_BRACKET =   "["
  case RIGHT_SQUARE_BRACKET =  "]"
  case PERIOD =                "."
  case COMMA =                 ","
  case SEMICOLON =             ";"
  case COLON =                 ":"
  
  case one_line_comment_ =      #"//[^\n]*"#
  case identifier_ =            #"[A-Za-z_][A-Za-z0-9_]*"#
  case integer_literal_ =       #"[0-9]+"#
  case whitespace_ =            #"[ \t\r\n]+"#
}

typealias TokenData = (token: Parser.CitronToken, code: Parser.CitronTokenCode)

fileprivate rules = TokenKind.allCases.map { (k: TokenKind) -> LexingRule in
  let name = String(describing: k)
  return name.last! == "_" ? .regexPattern(k.rawValue, 
}
typealias Lexer = CitronLexer<(token: Int, code: CarbonParser.CitronTokenCode)>

 [

                    // Numbers

                    .regexPattern("[0-9]+", { str in
                                              if let number = Int(str) {
                                                return (number, .Integer)
                                              }
                                              return nil
                                            }),

                    // Operators

                    .string("+", (0, .Add)),
                    .string("-", (0, .Subtract)),
                    .string("*", (0, .Multiply)),
                    .string("/", (0, .Divide)),

                    // Brackets

                    .string("(", (0, .OpenBracket)),
                    .string(")", (0, .CloseBracket)),

                    // Whitespace

                    .regexPattern("\\s", { _ in nil })
                  ])


 
/// The SwiLex description of the tokens we can match.
public enum Terminal: String {

  // Keywords must precede identifiers.
  case AND =                   #"and"#
  case ARROW =                 #"->"#
  case AUTO =                  #"auto"#
  case BOOL =                  #"bool"#
  case BREAK =                 #"break"#
  case CASE =                  #"case"#
  case CHOICE =                #"choice"#
  case CONTINUE =              #"continue"#
  case DBLARROW =              #"=>"#
  case DEFAULT =               #"default"#
  case ELSE =                  #"else"#
  case EQUAL_EQUAL =           #"=="#
  case FALSE =                 #"false"#
  case FN =                    #"fn"#
  case FNTY =                  #"fnty"#
  case IF =                    #"if"#
  case INT =                   #"int"#
  case MATCH =                 #"match"#
  case NOT =                   #"not"#
  case OR =                    #"or"#
  case RETURN =                #"return"#
  case STRUCT =                #"struct"#
  case TRUE =                  #"true"#
  case TYPE =                  #"type"#
  case VAR =                   #"var"#
  case WHILE =                 #"while"#
  case EQUAL =                 #"=    "#
  case MINUS =                 #"-"#
  case PLUS =                  #"\+"#
  case STAR =                  #"\*"#
  case SLASH =                 #"/"#
  case LEFT_PARENTHESIS =      #"\("#
  case RIGHT_PARENTHESIS =     #"\)"#
  case LEFT_CURLY_BRACE =      #"\{"#
  case RIGHT_CURLY_BRACE =     #"\}"#
  case LEFT_SQUARE_BRACKET =   #"\["#
  case RIGHT_SQUARE_BRACKET =  #"]"#
  case PERIOD =                #"\."#
  case COMMA =                 #","#
  case SEMICOLON =             #";"#
  case COLON =                 #":"#
  
  case one_line_comment =      #"//[^\n]*"#
  case identifier =            #"[A-Za-z_][A-Za-z0-9_]*"#
  case integer_literal =       #"[0-9]+"#
  case horizontal_whitespace = #"[ \t\r]+"#
  case newlines =              #"\n+"#
  case illegal =               #"."#
  
  case eof
  case none
}

/// A unit of source text to be sent to the parser.
public struct Token: Hashable {
  /// The parser symbol of `self`.
  public let kind: Terminal
  /// The actual text recognized as `self`.
  public let text: Substring
  /// The region of the source file covered by this text.
  public let location: RangeOfSourceFile
}

/// Returns a `Token` for each lexically significant unit in `sourceText`.
func tokenize(sourceText: String) -> [Token] {
  var r: [Token] = []
  var tokenStart = PositionInSourceFile(line: 1, column: 1)
  var scanner = SwiLex<Terminal>()
  
  for t in try! scanner.lex(input: sourceText) {
    switch t.type {
    case .one_line_comment, .eof, .none:
      () // ignored
    case .horizontal_whitespace:
      tokenStart.column += t.value.count
    case .newlines:
      tokenStart.column = 1
      tokenStart.line += t.value.utf8.count
    default:
      var tokenEnd = tokenStart
      tokenEnd.column += t.value.count
      r.append(
        Token(kind: t.type, text: t.value, location: tokenStart..<tokenEnd))
    }
  }
  return r 
}
