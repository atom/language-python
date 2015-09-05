describe "Python grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-python")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.python")

  it "parses the grammar", ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe "source.python"

  it "tokenizes multi-line strings", ->
    tokens = grammar.tokenizeLines '''
      "1\\
      2"
    '''

    expect(tokens[0][0]).toEqual value: '"', scopes: ['source.python', 'string.quoted.double.single-line.python', 'punctuation.definition.string.begin.python']
    expect(tokens[0][1]).toEqual value: '1', scopes: ['source.python', 'string.quoted.double.single-line.python']
    expect(tokens[0][2]).toEqual value: '\\', scopes: ['source.python', 'string.quoted.double.single-line.python', 'constant.character.escape.newline.python']
    expect(tokens[1][0]).toEqual value: '2', scopes: ['source.python', 'string.quoted.double.single-line.python']
    expect(tokens[1][1]).toEqual value: '"', scopes: ['source.python', 'string.quoted.double.single-line.python', 'punctuation.definition.string.end.python']

  it "terminates a raw string containing opening parenthesis at closing quote", ->
    delimsByScope =
      "string.quoted.single.single-line.raw-regex.python": "'"
      "string.quoted.double.single-line.raw-regex.python": '"'

    for scope, delim of delimsByScope
      {tokens} = grammar.tokenizeLine("r" + delim + "%d(" + delim + " #foo")

      expect(tokens[0]).toEqual value: 'r', scopes: ['source.python', scope, 'storage.type.string.python']
      expect(tokens[1]).toEqual value: delim, scopes: ['source.python', scope, 'punctuation.definition.string.begin.python']
      expect(tokens[2]).toEqual value: '%d', scopes: ['source.python', scope, 'constant.other.placeholder.python']
      expect(tokens[3]).toEqual value: '(', scopes: ['source.python', scope, 'meta.group.regexp', 'punctuation.definition.group.regexp']
      expect(tokens[4]).toEqual value: delim, scopes: ['source.python', scope, 'punctuation.definition.string.end.python']
      expect(tokens[5]).toEqual value: ' ', scopes: ['source.python']
      expect(tokens[6]).toEqual value: '#', scopes: ['source.python', 'comment.line.number-sign.python', 'punctuation.definition.comment.python']
      expect(tokens[7]).toEqual value: 'foo', scopes: ['source.python', 'comment.line.number-sign.python']

  it "terminates a raw string containing opening bracket at closing quote", ->
    delimsByScope =
      "string.quoted.single.single-line.raw-regex.python": "'"
      "string.quoted.double.single-line.raw-regex.python": '"'

    for scope, delim of delimsByScope
      {tokens} = grammar.tokenizeLine("r" + delim + "%d[" + delim + " #foo")

      expect(tokens[0]).toEqual value: 'r', scopes: ['source.python', scope, 'storage.type.string.python']
      expect(tokens[1]).toEqual value: delim, scopes: ['source.python', scope, 'punctuation.definition.string.begin.python']
      expect(tokens[2]).toEqual value: '%d', scopes: ['source.python', scope, 'constant.other.placeholder.python']
      expect(tokens[3]).toEqual value: '[', scopes: ['source.python', scope, 'constant.other.character-class.set.regexp', 'punctuation.definition.character-class.regexp']
      expect(tokens[4]).toEqual value: delim, scopes: ['source.python', scope, 'punctuation.definition.string.end.python']
      expect(tokens[5]).toEqual value: ' ', scopes: ['source.python']
      expect(tokens[6]).toEqual value: '#', scopes: ['source.python', 'comment.line.number-sign.python', 'punctuation.definition.comment.python']
      expect(tokens[7]).toEqual value: 'foo', scopes: ['source.python', 'comment.line.number-sign.python']

  it "terminates a unicode raw string containing opening parenthesis at closing quote", ->
    delimsByScope =
      "string.quoted.single.single-line.unicode-raw-regex.python": "'"
      "string.quoted.double.single-line.unicode-raw-regex.python": '"'

    for scope, delim of delimsByScope
      {tokens} = grammar.tokenizeLine("ur" + delim + "%d(" + delim + " #foo")

      expect(tokens[0]).toEqual value: 'ur', scopes: ['source.python', scope, 'storage.type.string.python']
      expect(tokens[1]).toEqual value: delim, scopes: ['source.python', scope, 'punctuation.definition.string.begin.python']
      expect(tokens[2]).toEqual value: '%d', scopes: ['source.python', scope, 'constant.other.placeholder.python']
      expect(tokens[3]).toEqual value: '(', scopes: ['source.python', scope, 'meta.group.regexp', 'punctuation.definition.group.regexp']
      expect(tokens[4]).toEqual value: delim, scopes: ['source.python', scope, 'punctuation.definition.string.end.python']
      expect(tokens[5]).toEqual value: ' ', scopes: ['source.python']
      expect(tokens[6]).toEqual value: '#', scopes: ['source.python', 'comment.line.number-sign.python', 'punctuation.definition.comment.python']
      expect(tokens[7]).toEqual value: 'foo', scopes: ['source.python', 'comment.line.number-sign.python']

  it "terminates a unicode raw string containing opening bracket at closing quote", ->
    delimsByScope =
      "string.quoted.single.single-line.unicode-raw-regex.python": "'"
      "string.quoted.double.single-line.unicode-raw-regex.python": '"'

    for scope, delim of delimsByScope
      {tokens} = grammar.tokenizeLine("ur" + delim + "%d[" + delim + " #foo")

      expect(tokens[0]).toEqual value: 'ur', scopes: ['source.python', scope, 'storage.type.string.python']
      expect(tokens[1]).toEqual value: delim, scopes: ['source.python', scope, 'punctuation.definition.string.begin.python']
      expect(tokens[2]).toEqual value: '%d', scopes: ['source.python', scope, 'constant.other.placeholder.python']
      expect(tokens[3]).toEqual value: '[', scopes: ['source.python', scope, 'constant.other.character-class.set.regexp', 'punctuation.definition.character-class.regexp']
      expect(tokens[4]).toEqual value: delim, scopes: ['source.python', scope, 'punctuation.definition.string.end.python']
      expect(tokens[5]).toEqual value: ' ', scopes: ['source.python']
      expect(tokens[6]).toEqual value: '#', scopes: ['source.python', 'comment.line.number-sign.python', 'punctuation.definition.comment.python']
      expect(tokens[7]).toEqual value: 'foo', scopes: ['source.python', 'comment.line.number-sign.python']

  it "terminates referencing an item in a list variable after a sequence of a closing and opening bracket", ->
    {tokens} = grammar.tokenizeLine('foo[i[0]][j[0]]')

    expect(tokens[0]).toEqual value: 'foo', scopes: ['source.python', 'meta.item-access.python']
    expect(tokens[1]).toEqual value: '[', scopes: ['source.python', 'meta.item-access.python', 'punctuation.definition.arguments.begin.python']
    expect(tokens[2]).toEqual value: 'i', scopes: ['source.python', 'meta.item-access.python', 'meta.item-access.arguments.python', 'meta.item-access.python']
    expect(tokens[3]).toEqual value: '[', scopes: ['source.python', 'meta.item-access.python', 'meta.item-access.arguments.python', 'meta.item-access.python', 'punctuation.definition.arguments.begin.python']
    expect(tokens[4]).toEqual value: '0', scopes: ['source.python', 'meta.item-access.python', 'meta.item-access.arguments.python', 'meta.item-access.python', 'meta.item-access.arguments.python', 'constant.numeric.integer.decimal.python']
    expect(tokens[5]).toEqual value: ']', scopes: ['source.python', 'meta.item-access.python', 'meta.item-access.arguments.python', 'meta.item-access.python', 'punctuation.definition.arguments.end.python']
    expect(tokens[6]).toEqual value: ']', scopes: ['source.python', 'meta.item-access.python', 'punctuation.definition.arguments.end.python']
    expect(tokens[7]).toEqual value: '[', scopes: ['source.python', 'meta.structure.list.python', 'punctuation.definition.list.begin.python']
    expect(tokens[8]).toEqual value: 'j', scopes: ['source.python', 'meta.structure.list.python', 'meta.structure.list.item.python', 'meta.item-access.python']
    expect(tokens[9]).toEqual value: '[', scopes: ['source.python', 'meta.structure.list.python', 'meta.structure.list.item.python', 'meta.item-access.python', 'punctuation.definition.arguments.begin.python']
    expect(tokens[10]).toEqual value: '0', scopes: ['source.python', 'meta.structure.list.python', 'meta.structure.list.item.python', 'meta.item-access.python', 'meta.item-access.arguments.python', 'constant.numeric.integer.decimal.python']
    expect(tokens[11]).toEqual value: ']', scopes: ['source.python', 'meta.structure.list.python', 'meta.structure.list.item.python', 'meta.item-access.python', 'punctuation.definition.arguments.end.python']
    expect(tokens[12]).toEqual value: ']', scopes: ['source.python', 'meta.structure.list.python', 'punctuation.definition.list.end.python']

  it "tokenizes properties of self as variables", ->
    {tokens} = grammar.tokenizeLine('self.foo')

    expect(tokens[0]).toEqual value: 'self', scopes: ['source.python', 'variable.language.python']
    expect(tokens[1]).toEqual value: '.', scopes: ['source.python']
    expect(tokens[2]).toEqual value: 'foo', scopes: ['source.python']

  it "tokenizes properties of a variable as variables", ->
    {tokens} = grammar.tokenizeLine('bar.foo')

    expect(tokens[0]).toEqual value: 'bar', scopes: ['source.python']
    expect(tokens[1]).toEqual value: '.', scopes: ['source.python']
    expect(tokens[2]).toEqual value: 'foo', scopes: ['source.python']

  it "tokenizes comments inside function parameters", ->
    {tokens} = grammar.tokenizeLine('def test(arg, # comment')

    expect(tokens[0]).toEqual value: 'def', scopes: ['source.python', 'meta.function.python', 'storage.type.function.python']
    expect(tokens[2]).toEqual value: 'test', scopes: ['source.python', 'meta.function.python', 'entity.name.function.python']
    expect(tokens[3]).toEqual value: '(', scopes: ['source.python', 'meta.function.python', 'punctuation.definition.parameters.begin.python']
    expect(tokens[4]).toEqual value: 'arg', scopes: ['source.python', 'meta.function.python', 'meta.function.parameters.python', 'variable.parameter.function.python']
    expect(tokens[5]).toEqual value: ',', scopes: ['source.python', 'meta.function.python', 'meta.function.parameters.python', 'punctuation.separator.parameters.python']
    expect(tokens[7]).toEqual value: '#', scopes: ['source.python', 'meta.function.python', 'meta.function.parameters.python', 'comment.line.number-sign.python', 'punctuation.definition.comment.python']
    expect(tokens[8]).toEqual value: ' comment', scopes: ['source.python', 'meta.function.python', 'meta.function.parameters.python', 'comment.line.number-sign.python']

    tokens = grammar.tokenizeLines """
      def __init__(
        self,
        codec, # comment
        config
      ):
    """

    expect(tokens[0][0]).toEqual value: 'def', scopes: ['source.python', 'meta.function.python', 'storage.type.function.python']
    expect(tokens[0][2]).toEqual value: '__init__', scopes: ['source.python', 'meta.function.python', 'entity.name.function.python', 'support.function.magic.python']
    expect(tokens[0][3]).toEqual value: '(', scopes: ['source.python', 'meta.function.python', 'punctuation.definition.parameters.begin.python']
    expect(tokens[1][1]).toEqual value: 'self', scopes: ['source.python', 'meta.function.python', 'meta.function.parameters.python', 'variable.parameter.function.python']
    expect(tokens[1][2]).toEqual value: ',', scopes: ['source.python', 'meta.function.python', 'meta.function.parameters.python', 'punctuation.separator.parameters.python']
    expect(tokens[2][1]).toEqual value: 'codec', scopes: ['source.python', 'meta.function.python', 'meta.function.parameters.python', 'variable.parameter.function.python']
    expect(tokens[2][2]).toEqual value: ',', scopes: ['source.python', 'meta.function.python', 'meta.function.parameters.python', 'punctuation.separator.parameters.python']
    expect(tokens[2][4]).toEqual value: '#', scopes: ['source.python', 'meta.function.python', 'meta.function.parameters.python', 'comment.line.number-sign.python', 'punctuation.definition.comment.python']
    expect(tokens[2][5]).toEqual value: ' comment', scopes: ['source.python', 'meta.function.python', 'meta.function.parameters.python', 'comment.line.number-sign.python']
    expect(tokens[3][1]).toEqual value: 'config', scopes: ['source.python', 'meta.function.python', 'meta.function.parameters.python', 'variable.parameter.function.python']
    expect(tokens[4][0]).toEqual value: ')', scopes: ['source.python', 'meta.function.python', 'punctuation.definition.parameters.end.python']
    expect(tokens[4][1]).toEqual value: ':', scopes: ['source.python', 'meta.function.python', 'punctuation.section.function.begin.python']

  it "tokenizes SQL inline highlighting on blocks", ->
    delimsByScope =
      "string.quoted.double.block.sql.python": '"""'
      "string.quoted.single.block.sql.python": "'''"

    for scope, delim in delimsByScope
      tokens = grammar.tokenizeLines(
        delim +
        'SELECT bar
        FROM foo'
        + delim
      )

      expect(tokens[0][0]).toEqual value: delim, scopes: ['source.python', scope, 'punctuation.definition.string.begin.python']
      expect(tokens[1][0]).toEqual value: 'SELECT bar', scopes: ['source.python', scope]
      expect(tokens[2][0]).toEqual value: 'FROM foo', scopes: ['source.python', scope]
      expect(tokens[3][0]).toEqual value: delim, scopes: ['source.python', scope, 'punctuation.definition.string.end.python']
