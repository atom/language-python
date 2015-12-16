describe "Python3 grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-python")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.python3")

  it "parses the grammar", ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe "source.python3"

  it "tokenizes multi-line strings", ->
    tokens = grammar.tokenizeLines('"1\\\n2"')

    # Line 0
    expect(tokens[0][0].value).toBe '"'
    expect(tokens[0][0].scopes).toEqual ['source.python3', 'string.quoted.double.single-line.unicode.python3', 'punctuation.definition.string.begin.python3']

    expect(tokens[0][1].value).toBe '1'
    expect(tokens[0][1].scopes).toEqual ['source.python3', 'string.quoted.double.single-line.unicode.python3']

    expect(tokens[0][2].value).toBe '\\'
    expect(tokens[0][2].scopes).toEqual ['source.python3', 'string.quoted.double.single-line.unicode.python3', 'constant.character.escape.newline.python3']

    expect(tokens[0][3]).not.toBeDefined()

    # Line 1
    expect(tokens[1][0].value).toBe '2'
    expect(tokens[1][0].scopes).toEqual ['source.python3', 'string.quoted.double.single-line.unicode.python3']

    expect(tokens[1][1].value).toBe '"'
    expect(tokens[1][1].scopes).toEqual ['source.python3', 'string.quoted.double.single-line.unicode.python3', 'punctuation.definition.string.end.python3']

    expect(tokens[1][2]).not.toBeDefined()

  it "terminates a single-quoted raw string containing opening parenthesis at closing quote", ->
    tokens = grammar.tokenizeLines("r'%d(' #foo")

    expect(tokens[0][0].value).toBe 'r'
    expect(tokens[0][0].scopes).toEqual ['source.python3', 'string.quoted.single.single-line.raw-unicode.python3', 'storage.type.string.python3']
    expect(tokens[0][1].value).toBe "'"
    expect(tokens[0][1].scopes).toEqual ['source.python3', 'string.quoted.single.single-line.raw-unicode.python3', 'punctuation.definition.string.begin.python3']
    expect(tokens[0][2].value).toBe '%d'
    expect(tokens[0][2].scopes).toEqual ['source.python3', 'string.quoted.single.single-line.raw-unicode.python3', 'constant.other.placeholder.printf.python3']
    expect(tokens[0][3].value).toBe '('
    expect(tokens[0][3].scopes).toEqual ['source.python3', 'string.quoted.single.single-line.raw-unicode.python3', 'meta.group.regexp', 'punctuation.definition.group.regexp']
    expect(tokens[0][4].value).toBe "'"
    expect(tokens[0][4].scopes).toEqual ['source.python3', 'string.quoted.single.single-line.raw-unicode.python3', 'punctuation.definition.string.end.python3']
    expect(tokens[0][5].value).toBe ' '
    expect(tokens[0][5].scopes).toEqual ['source.python3']
    expect(tokens[0][6].value).toBe '#'
    expect(tokens[0][6].scopes).toEqual ['source.python3', 'comment.line.number-sign.python3', 'punctuation.definition.comment.python3']
    expect(tokens[0][7].value).toBe 'foo'
    expect(tokens[0][7].scopes).toEqual ['source.python3', 'comment.line.number-sign.python3']

  it "terminates a single-quoted raw string containing opening bracket at closing quote", ->
    tokens = grammar.tokenizeLines("r'%d[' #foo")

    expect(tokens[0][0].value).toBe 'r'
    expect(tokens[0][0].scopes).toEqual ['source.python3', 'string.quoted.single.single-line.raw-unicode.python3', 'storage.type.string.python3']
    expect(tokens[0][1].value).toBe "'"
    expect(tokens[0][1].scopes).toEqual ['source.python3', 'string.quoted.single.single-line.raw-unicode.python3', 'punctuation.definition.string.begin.python3']
    expect(tokens[0][2].value).toBe '%d'
    expect(tokens[0][2].scopes).toEqual ['source.python3', 'string.quoted.single.single-line.raw-unicode.python3', 'constant.other.placeholder.printf.python3']
    expect(tokens[0][3].value).toBe '['
    expect(tokens[0][3].scopes).toEqual ['source.python3', 'string.quoted.single.single-line.raw-unicode.python3', 'constant.other.character-class.set.regexp', 'punctuation.definition.character-class.regexp']
    expect(tokens[0][4].value).toBe "'"
    expect(tokens[0][4].scopes).toEqual ['source.python3', 'string.quoted.single.single-line.raw-unicode.python3', 'punctuation.definition.string.end.python3']
    expect(tokens[0][5].value).toBe ' '
    expect(tokens[0][5].scopes).toEqual ['source.python3']
    expect(tokens[0][6].value).toBe '#'
    expect(tokens[0][6].scopes).toEqual ['source.python3', 'comment.line.number-sign.python3', 'punctuation.definition.comment.python3']
    expect(tokens[0][7].value).toBe 'foo'
    expect(tokens[0][7].scopes).toEqual ['source.python3', 'comment.line.number-sign.python3']

  it "terminates a double-quoted raw string containing opening parenthesis at closing quote", ->
    tokens = grammar.tokenizeLines('r"%d(" #foo')

    expect(tokens[0][0].value).toBe 'r'
    expect(tokens[0][0].scopes).toEqual ['source.python3', 'string.quoted.double.single-line.raw-unicode.python3', 'storage.type.string.python3']
    expect(tokens[0][1].value).toBe '"'
    expect(tokens[0][1].scopes).toEqual ['source.python3', 'string.quoted.double.single-line.raw-unicode.python3', 'punctuation.definition.string.begin.python3']
    expect(tokens[0][2].value).toBe '%d'
    expect(tokens[0][2].scopes).toEqual ['source.python3', 'string.quoted.double.single-line.raw-unicode.python3', 'constant.other.placeholder.printf.python3']
    expect(tokens[0][3].value).toBe '('
    expect(tokens[0][3].scopes).toEqual ['source.python3', 'string.quoted.double.single-line.raw-unicode.python3', 'meta.group.regexp', 'punctuation.definition.group.regexp']
    expect(tokens[0][4].value).toBe '"'
    expect(tokens[0][4].scopes).toEqual ['source.python3', 'string.quoted.double.single-line.raw-unicode.python3', 'punctuation.definition.string.end.python3']
    expect(tokens[0][5].value).toBe ' '
    expect(tokens[0][5].scopes).toEqual ['source.python3']
    expect(tokens[0][6].value).toBe '#'
    expect(tokens[0][6].scopes).toEqual ['source.python3', 'comment.line.number-sign.python3', 'punctuation.definition.comment.python3']
    expect(tokens[0][7].value).toBe 'foo'
    expect(tokens[0][7].scopes).toEqual ['source.python3', 'comment.line.number-sign.python3']

  it "terminates a double-quoted raw string containing opening bracket at closing quote", ->
    tokens = grammar.tokenizeLines('r"%d[" #foo')

    expect(tokens[0][0].value).toBe 'r'
    expect(tokens[0][0].scopes).toEqual ['source.python3', 'string.quoted.double.single-line.raw-unicode.python3', 'storage.type.string.python3']
    expect(tokens[0][1].value).toBe '"'
    expect(tokens[0][1].scopes).toEqual ['source.python3', 'string.quoted.double.single-line.raw-unicode.python3', 'punctuation.definition.string.begin.python3']
    expect(tokens[0][2].value).toBe '%d'
    expect(tokens[0][2].scopes).toEqual ['source.python3', 'string.quoted.double.single-line.raw-unicode.python3', 'constant.other.placeholder.printf.python3']
    expect(tokens[0][3].value).toBe '['
    expect(tokens[0][3].scopes).toEqual ['source.python3', 'string.quoted.double.single-line.raw-unicode.python3', 'constant.other.character-class.set.regexp', 'punctuation.definition.character-class.regexp']
    expect(tokens[0][4].value).toBe '"'
    expect(tokens[0][4].scopes).toEqual ['source.python3', 'string.quoted.double.single-line.raw-unicode.python3', 'punctuation.definition.string.end.python3']
    expect(tokens[0][5].value).toBe ' '
    expect(tokens[0][5].scopes).toEqual ['source.python3']
    expect(tokens[0][6].value).toBe '#'
    expect(tokens[0][6].scopes).toEqual ['source.python3', 'comment.line.number-sign.python3', 'punctuation.definition.comment.python3']
    expect(tokens[0][7].value).toBe 'foo'
    expect(tokens[0][7].scopes).toEqual ['source.python3', 'comment.line.number-sign.python3']

  it "terminates a bytes single-quoted raw string containing opening parenthesis at closing quote", ->
    tokens = grammar.tokenizeLines("br'%d(' #foo")

    expect(tokens[0][0].value).toBe 'br'
    expect(tokens[0][0].scopes).toEqual ['source.python3', 'string.quoted.single.single-line.raw-bytes.python3', 'storage.type.string.python3']
    expect(tokens[0][1].value).toBe "'"
    expect(tokens[0][1].scopes).toEqual ['source.python3', 'string.quoted.single.single-line.raw-bytes.python3', 'punctuation.definition.string.begin.python3']
    expect(tokens[0][2].value).toBe '%d'
    expect(tokens[0][2].scopes).toEqual ['source.python3', 'string.quoted.single.single-line.raw-bytes.python3', 'constant.other.placeholder.printf.python3']
    expect(tokens[0][3].value).toBe '('
    expect(tokens[0][3].scopes).toEqual ['source.python3', 'string.quoted.single.single-line.raw-bytes.python3', 'meta.group.regexp', 'punctuation.definition.group.regexp']
    expect(tokens[0][4].value).toBe "'"
    expect(tokens[0][4].scopes).toEqual ['source.python3', 'string.quoted.single.single-line.raw-bytes.python3', 'punctuation.definition.string.end.python3']
    expect(tokens[0][5].value).toBe ' '
    expect(tokens[0][5].scopes).toEqual ['source.python3']
    expect(tokens[0][6].value).toBe '#'
    expect(tokens[0][6].scopes).toEqual ['source.python3', 'comment.line.number-sign.python3', 'punctuation.definition.comment.python3']
    expect(tokens[0][7].value).toBe 'foo'
    expect(tokens[0][7].scopes).toEqual ['source.python3', 'comment.line.number-sign.python3']

  it "terminates a bytes single-quoted raw string containing opening bracket at closing quote", ->
    tokens = grammar.tokenizeLines("br'%d[' #foo")

    expect(tokens[0][0].value).toBe 'br'
    expect(tokens[0][0].scopes).toEqual ['source.python3', 'string.quoted.single.single-line.raw-bytes.python3', 'storage.type.string.python3']
    expect(tokens[0][1].value).toBe "'"
    expect(tokens[0][1].scopes).toEqual ['source.python3', 'string.quoted.single.single-line.raw-bytes.python3', 'punctuation.definition.string.begin.python3']
    expect(tokens[0][2].value).toBe '%d'
    expect(tokens[0][2].scopes).toEqual ['source.python3', 'string.quoted.single.single-line.raw-bytes.python3', 'constant.other.placeholder.printf.python3']
    expect(tokens[0][3].value).toBe '['
    expect(tokens[0][3].scopes).toEqual ['source.python3', 'string.quoted.single.single-line.raw-bytes.python3', 'constant.other.character-class.set.regexp', 'punctuation.definition.character-class.regexp']
    expect(tokens[0][4].value).toBe "'"
    expect(tokens[0][4].scopes).toEqual ['source.python3', 'string.quoted.single.single-line.raw-bytes.python3', 'punctuation.definition.string.end.python3']
    expect(tokens[0][5].value).toBe ' '
    expect(tokens[0][5].scopes).toEqual ['source.python3']
    expect(tokens[0][6].value).toBe '#'
    expect(tokens[0][6].scopes).toEqual ['source.python3', 'comment.line.number-sign.python3', 'punctuation.definition.comment.python3']
    expect(tokens[0][7].value).toBe 'foo'
    expect(tokens[0][7].scopes).toEqual ['source.python3', 'comment.line.number-sign.python3']

  it "terminates a bytes double-quoted raw string containing opening parenthesis at closing quote", ->
    tokens = grammar.tokenizeLines('br"%d(" #foo')

    expect(tokens[0][0].value).toBe 'br'
    expect(tokens[0][0].scopes).toEqual ['source.python3', 'string.quoted.double.single-line.raw-bytes.python3', 'storage.type.string.python3']
    expect(tokens[0][1].value).toBe '"'
    expect(tokens[0][1].scopes).toEqual ['source.python3', 'string.quoted.double.single-line.raw-bytes.python3', 'punctuation.definition.string.begin.python3']
    expect(tokens[0][2].value).toBe '%d'
    expect(tokens[0][2].scopes).toEqual ['source.python3', 'string.quoted.double.single-line.raw-bytes.python3', 'constant.other.placeholder.printf.python3']
    expect(tokens[0][3].value).toBe '('
    expect(tokens[0][3].scopes).toEqual ['source.python3', 'string.quoted.double.single-line.raw-bytes.python3', 'meta.group.regexp', 'punctuation.definition.group.regexp']
    expect(tokens[0][4].value).toBe '"'
    expect(tokens[0][4].scopes).toEqual ['source.python3', 'string.quoted.double.single-line.raw-bytes.python3', 'punctuation.definition.string.end.python3']
    expect(tokens[0][5].value).toBe ' '
    expect(tokens[0][5].scopes).toEqual ['source.python3']
    expect(tokens[0][6].value).toBe '#'
    expect(tokens[0][6].scopes).toEqual ['source.python3', 'comment.line.number-sign.python3', 'punctuation.definition.comment.python3']
    expect(tokens[0][7].value).toBe 'foo'
    expect(tokens[0][7].scopes).toEqual ['source.python3', 'comment.line.number-sign.python3']

  it "terminates a bytes double-quoted raw string containing opening bracket at closing quote", ->
    tokens = grammar.tokenizeLines('br"%d[" #foo')

    expect(tokens[0][0].value).toBe 'br'
    expect(tokens[0][0].scopes).toEqual ['source.python3', 'string.quoted.double.single-line.raw-bytes.python3', 'storage.type.string.python3']
    expect(tokens[0][1].value).toBe '"'
    expect(tokens[0][1].scopes).toEqual ['source.python3', 'string.quoted.double.single-line.raw-bytes.python3', 'punctuation.definition.string.begin.python3']
    expect(tokens[0][2].value).toBe '%d'
    expect(tokens[0][2].scopes).toEqual ['source.python3', 'string.quoted.double.single-line.raw-bytes.python3', 'constant.other.placeholder.printf.python3']
    expect(tokens[0][3].value).toBe '['
    expect(tokens[0][3].scopes).toEqual ['source.python3', 'string.quoted.double.single-line.raw-bytes.python3', 'constant.other.character-class.set.regexp', 'punctuation.definition.character-class.regexp']
    expect(tokens[0][4].value).toBe '"'
    expect(tokens[0][4].scopes).toEqual ['source.python3', 'string.quoted.double.single-line.raw-bytes.python3', 'punctuation.definition.string.end.python3']
    expect(tokens[0][5].value).toBe ' '
    expect(tokens[0][5].scopes).toEqual ['source.python3']
    expect(tokens[0][6].value).toBe '#'
    expect(tokens[0][6].scopes).toEqual ['source.python3', 'comment.line.number-sign.python3', 'punctuation.definition.comment.python3']
    expect(tokens[0][7].value).toBe 'foo'
    expect(tokens[0][7].scopes).toEqual ['source.python3', 'comment.line.number-sign.python3']

  it "terminates referencing an item in a list variable after a sequence of a closing and opening bracket", ->
    tokens = grammar.tokenizeLines('foo[i[0]][j[0]]')

    expect(tokens[0][0].value).toBe 'foo'
    expect(tokens[0][0].scopes).toEqual ['source.python3', 'meta.item-access.python3']
    expect(tokens[0][1].value).toBe '['
    expect(tokens[0][1].scopes).toEqual ['source.python3', 'meta.item-access.python3', 'punctuation.definition.arguments.begin.python3']
    expect(tokens[0][2].value).toBe 'i'
    expect(tokens[0][2].scopes).toEqual ['source.python3', 'meta.item-access.python3', 'meta.item-access.arguments.python3', 'meta.item-access.python3']
    expect(tokens[0][3].value).toBe '['
    expect(tokens[0][3].scopes).toEqual ['source.python3', 'meta.item-access.python3', 'meta.item-access.arguments.python3', 'meta.item-access.python3', 'punctuation.definition.arguments.begin.python3']
    expect(tokens[0][4].value).toBe '0'
    expect(tokens[0][4].scopes).toEqual ['source.python3', 'meta.item-access.python3', 'meta.item-access.arguments.python3', 'meta.item-access.python3', 'meta.item-access.arguments.python3', 'constant.numeric.integer.decimal.python3']
    expect(tokens[0][5].value).toBe ']'
    expect(tokens[0][5].scopes).toEqual ['source.python3', 'meta.item-access.python3', 'meta.item-access.arguments.python3', 'meta.item-access.python3', 'punctuation.definition.arguments.end.python3']
    expect(tokens[0][6].value).toBe ']'
    expect(tokens[0][6].scopes).toEqual ['source.python3', 'meta.item-access.python3', 'punctuation.definition.arguments.end.python3']
    expect(tokens[0][7].value).toBe '['
    expect(tokens[0][7].scopes).toEqual ['source.python3', 'meta.structure.list.python3', 'punctuation.definition.list.begin.python3']
    expect(tokens[0][8].value).toBe 'j'
    expect(tokens[0][8].scopes).toEqual ['source.python3', 'meta.structure.list.python3', 'meta.structure.list.item.python3', 'meta.item-access.python3']
    expect(tokens[0][9].value).toBe '['
    expect(tokens[0][9].scopes).toEqual ['source.python3', 'meta.structure.list.python3', 'meta.structure.list.item.python3', 'meta.item-access.python3', 'punctuation.definition.arguments.begin.python3']
    expect(tokens[0][10].value).toBe '0'
    expect(tokens[0][10].scopes).toEqual ['source.python3', 'meta.structure.list.python3', 'meta.structure.list.item.python3', 'meta.item-access.python3', 'meta.item-access.arguments.python3', 'constant.numeric.integer.decimal.python3']
    expect(tokens[0][11].value).toBe ']'
    expect(tokens[0][11].scopes).toEqual ['source.python3', 'meta.structure.list.python3', 'meta.structure.list.item.python3', 'meta.item-access.python3', 'punctuation.definition.arguments.end.python3']
    expect(tokens[0][12].value).toBe ']'
    expect(tokens[0][12].scopes).toEqual ['source.python3', 'meta.structure.list.python3', 'punctuation.definition.list.end.python3']

  it "tokenizes properties of self as variables", ->
    tokens = grammar.tokenizeLines('self.foo')

    expect(tokens[0][0].value).toBe 'self'
    expect(tokens[0][0].scopes).toEqual ['source.python3', 'variable.language.python3']
    expect(tokens[0][1].value).toBe '.'
    expect(tokens[0][1].scopes).toEqual ['source.python3']
    expect(tokens[0][2].value).toBe 'foo'
    expect(tokens[0][2].scopes).toEqual ['source.python3']

  it "tokenizes properties of a variable as variables", ->
    tokens = grammar.tokenizeLines('bar.foo')

    expect(tokens[0][0].value).toBe 'bar'
    expect(tokens[0][0].scopes).toEqual ['source.python3']
    expect(tokens[0][1].value).toBe '.'
    expect(tokens[0][1].scopes).toEqual ['source.python3']
    expect(tokens[0][2].value).toBe 'foo'
    expect(tokens[0][2].scopes).toEqual ['source.python3']

  it "tokenizes comments inside function parameters", ->
    {tokens} = grammar.tokenizeLine('def test(arg, # comment')

    expect(tokens[0]).toEqual value: 'def', scopes: ['source.python3', 'meta.function.python3', 'storage.type.function.python3']
    expect(tokens[2]).toEqual value: 'test', scopes: ['source.python3', 'meta.function.python3', 'entity.name.function.python3']
    expect(tokens[3]).toEqual value: '(', scopes: ['source.python3', 'meta.function.python3', 'punctuation.definition.parameters.begin.python3']
    expect(tokens[4]).toEqual value: 'arg', scopes: ['source.python3', 'meta.function.python3', 'meta.function.parameters.python3', 'variable.parameter.function.python3']
    expect(tokens[5]).toEqual value: ',', scopes: ['source.python3', 'meta.function.python3', 'meta.function.parameters.python3', 'punctuation.separator.parameters.python3']
    expect(tokens[7]).toEqual value: '#', scopes: ['source.python3', 'meta.function.python3', 'meta.function.parameters.python3', 'comment.line.number-sign.python3', 'punctuation.definition.comment.python3']
    expect(tokens[8]).toEqual value: ' comment', scopes: ['source.python3', 'meta.function.python3', 'meta.function.parameters.python3', 'comment.line.number-sign.python3']

    tokens = grammar.tokenizeLines("""
      def __init__(
        self,
        codec, # comment
        config
      ):
    """)

    expect(tokens[0][0]).toEqual value: 'def', scopes: ['source.python3', 'meta.function.python3', 'storage.type.function.python3']
    expect(tokens[0][2]).toEqual value: '__init__', scopes: ['source.python3', 'meta.function.python3', 'entity.name.function.python3', 'support.function.magic.python3']
    expect(tokens[0][3]).toEqual value: '(', scopes: ['source.python3', 'meta.function.python3', 'punctuation.definition.parameters.begin.python3']
    expect(tokens[1][1]).toEqual value: 'self', scopes: ['source.python3', 'meta.function.python3', 'meta.function.parameters.python3', 'variable.parameter.function.python3']
    expect(tokens[1][2]).toEqual value: ',', scopes: ['source.python3', 'meta.function.python3', 'meta.function.parameters.python3', 'punctuation.separator.parameters.python3']
    expect(tokens[2][1]).toEqual value: 'codec', scopes: ['source.python3', 'meta.function.python3', 'meta.function.parameters.python3', 'variable.parameter.function.python3']
    expect(tokens[2][2]).toEqual value: ',', scopes: ['source.python3', 'meta.function.python3', 'meta.function.parameters.python3', 'punctuation.separator.parameters.python3']
    expect(tokens[2][4]).toEqual value: '#', scopes: ['source.python3', 'meta.function.python3', 'meta.function.parameters.python3', 'comment.line.number-sign.python3', 'punctuation.definition.comment.python3']
    expect(tokens[2][5]).toEqual value: ' comment', scopes: ['source.python3', 'meta.function.python3', 'meta.function.parameters.python3', 'comment.line.number-sign.python3']
    expect(tokens[3][1]).toEqual value: 'config', scopes: ['source.python3', 'meta.function.python3', 'meta.function.parameters.python3', 'variable.parameter.function.python3']
    expect(tokens[4][0]).toEqual value: ')', scopes: ['source.python3', 'meta.function.python3', 'punctuation.definition.parameters.end.python3']
    expect(tokens[4][1]).toEqual value: ':', scopes: ['source.python3', 'meta.function.python3', 'punctuation.section.function.begin.python3']


  # it "tokenizes SQL inline highlighting on blocks", ->
  #   delimsByScope =
  #     "string.quoted.double.block.sql.python3": '"""'
  #     "string.quoted.single.block.sql.python3": "'''"
  #
  #   for scope, delim in delimsByScope
  #     tokens = grammar.tokenizeLines(
  #       delim +
  #       'SELECT bar
  #       FROM foo'
  #       + delim
  #     )
  #
  #     expect(tokens[0][0]).toEqual value: delim, scopes: ['source.python3', scope, 'punctuation.definition.string.begin.python3']
  #     expect(tokens[1][0]).toEqual value: 'SELECT bar', scopes: ['source.python3', scope]
  #     expect(tokens[2][0]).toEqual value: 'FROM foo', scopes: ['source.python3', scope]
  #     expect(tokens[3][0]).toEqual value: delim, scopes: ['source.python3', scope, 'punctuation.definition.string.end.python3']
  #
  # it "tokenizes SQL inline highlighting on blocks with a CTE", ->
  #   delimsByScope =
  #     "string.quoted.double.block.sql.python3": '"""'
  #     "string.quoted.single.block.sql.python3": "'''"
  #
  #   for scope, delim of delimsByScope
  #     tokens = grammar.tokenizeLines("""
  #       #{delim}
  #       WITH example_cte AS (
  #       SELECT bar
  #       FROM foo
  #       GROUP BY bar
  #       )
  #
  #       SELECT COUNT(*)
  #       FROM example_cte
  #       #{delim}
  #     """)
  #
  #     expect(tokens[0][0]).toEqual value: delim, scopes: ['source.python3', scope, 'punctuation.definition.string.begin.python3']
  #     expect(tokens[1][0]).toEqual value: 'WITH example_cte AS (', scopes: ['source.python3', scope]
  #     expect(tokens[2][0]).toEqual value: 'SELECT bar', scopes: ['source.python3', scope]
  #     expect(tokens[3][0]).toEqual value: 'FROM foo', scopes: ['source.python3', scope]
  #     expect(tokens[4][0]).toEqual value: 'GROUP BY bar', scopes: ['source.python3', scope]
  #     expect(tokens[5][0]).toEqual value: ')', scopes: ['source.python3', scope]
  #     expect(tokens[6][0]).toEqual value: '', scopes: ['source.python3', scope]
  #     expect(tokens[7][0]).toEqual value: 'SELECT COUNT(*)', scopes: ['source.python3', scope]
  #     expect(tokens[8][0]).toEqual value: 'FROM example_cte', scopes: ['source.python3', scope]
  #     expect(tokens[9][0]).toEqual value: delim, scopes: ['source.python3', scope, 'punctuation.definition.string.end.python3']
  #
  # it "tokenizes SQL inline highlighting on single line with a CTE", ->
  #
  #   {tokens} = grammar.tokenizeLine('\'WITH example_cte AS (SELECT bar FROM foo) SELECT COUNT(*) FROM example_cte\'')
  #
  #   expect(tokens[0]).toEqual value: '\'', scopes: ['source.python3', 'string.quoted.single.single-line.python3', 'punctuation.definition.string.begin.python3']
  #   expect(tokens[1]).toEqual value: 'WITH example_cte AS (SELECT bar FROM foo) SELECT COUNT(*) FROM example_cte', scopes: ['source.python3', 'string.quoted.single.single-line.python3']
  #   expect(tokens[2]).toEqual value: '\'', scopes: ['source.python3', 'string.quoted.single.single-line.python3', 'punctuation.definition.string.end.python3']
