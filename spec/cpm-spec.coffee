describe "ChordPro grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-cpm")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.cpm")

  it "parses the grammar", ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe "source.cpm"

  it "tokenizes spaces", ->
    {tokens} = grammar.tokenizeLine(" ")
    expect(tokens[0]).toEqual value: " ", scopes: ["source.cpm"]

  it "tokenizes titles", ->
    {tokens} = grammar.tokenizeLine("{t:foo}")
    expect(tokens[0]).toEqual value: "{t:", scopes: ["source.cpm", "title.cpm"]
    expect(tokens[1]).toEqual value: "foo", scopes: ["source.cpm", "title.cpm"]
    expect(tokens[2]).toEqual value: "}",   scopes: ["source.cpm", "title.cpm"]

    {tokens} = grammar.tokenizeLine("{t:  foo  }")
    expect(tokens[0]).toEqual value: "{t:  ", scopes: ["source.cpm", "title.cpm"]
    expect(tokens[1]).toEqual value: "foo", scopes: ["source.cpm", "title.cpm"]
    expect(tokens[2]).toEqual value: "  }",   scopes: ["source.cpm", "title.cpm"]

    {tokens} = grammar.tokenizeLine("{title:foo}")
    expect(tokens[0]).toEqual value: "{title:", scopes: ["source.cpm", "title.cpm"]
    expect(tokens[1]).toEqual value: "foo", scopes: ["source.cpm", "title.cpm"]
    expect(tokens[2]).toEqual value: "}",   scopes: ["source.cpm", "title.cpm"]

  it "tokenizes subtitles", ->
    {tokens} = grammar.tokenizeLine("{st:foo}")
    expect(tokens[0]).toEqual value: "{st:", scopes: ["source.cpm", "subtitle.cpm"]
    expect(tokens[1]).toEqual value: "foo", scopes: ["source.cpm", "subtitle.cpm"]
    expect(tokens[2]).toEqual value: "}",   scopes: ["source.cpm", "subtitle.cpm"]

    {tokens} = grammar.tokenizeLine("{st:  foo  }")
    expect(tokens[0]).toEqual value: "{st:  ", scopes: ["source.cpm", "subtitle.cpm"]
    expect(tokens[1]).toEqual value: "foo", scopes: ["source.cpm", "subtitle.cpm"]
    expect(tokens[2]).toEqual value: "  }",   scopes: ["source.cpm", "subtitle.cpm"]

    {tokens} = grammar.tokenizeLine("{subtitle:foo}")
    expect(tokens[0]).toEqual value: "{subtitle:", scopes: ["source.cpm", "subtitle.cpm"]
    expect(tokens[1]).toEqual value: "foo", scopes: ["source.cpm", "subtitle.cpm"]
    expect(tokens[2]).toEqual value: "}",   scopes: ["source.cpm", "subtitle.cpm"]

  it "tokenizes comments", ->
    {tokens} = grammar.tokenizeLine("{c:foo}")
    expect(tokens[0]).toEqual value: "{c:", scopes: ["source.cpm", "comment.cpm"]
    expect(tokens[1]).toEqual value: "foo", scopes: ["source.cpm", "comment.cpm"]
    expect(tokens[2]).toEqual value: "}",   scopes: ["source.cpm", "comment.cpm"]

    {tokens} = grammar.tokenizeLine("{c:  foo  }")
    expect(tokens[0]).toEqual value: "{c:  ", scopes: ["source.cpm", "comment.cpm"]
    expect(tokens[1]).toEqual value: "foo", scopes: ["source.cpm", "comment.cpm"]
    expect(tokens[2]).toEqual value: "  }",   scopes: ["source.cpm", "comment.cpm"]

    {tokens} = grammar.tokenizeLine("{comment:foo}")
    expect(tokens[0]).toEqual value: "{comment:", scopes: ["source.cpm", "comment.cpm"]
    expect(tokens[1]).toEqual value: "foo", scopes: ["source.cpm", "comment.cpm"]
    expect(tokens[2]).toEqual value: "}",   scopes: ["source.cpm", "comment.cpm"]

  it "tokenizes italic comments", ->
    {tokens} = grammar.tokenizeLine("{ci:foo}")
    expect(tokens[0]).toEqual value: "{ci:", scopes: ["source.cpm", "comment-italic.cpm"]
    expect(tokens[1]).toEqual value: "foo", scopes: ["source.cpm", "comment-italic.cpm"]
    expect(tokens[2]).toEqual value: "}",   scopes: ["source.cpm", "comment-italic.cpm"]

    {tokens} = grammar.tokenizeLine("{ci:  foo  }")
    expect(tokens[0]).toEqual value: "{ci:  ", scopes: ["source.cpm", "comment-italic.cpm"]
    expect(tokens[1]).toEqual value: "foo", scopes: ["source.cpm", "comment-italic.cpm"]
    expect(tokens[2]).toEqual value: "  }",   scopes: ["source.cpm", "comment-italic.cpm"]

    {tokens} = grammar.tokenizeLine("{comment_italic:foo}")
    expect(tokens[0]).toEqual value: "{comment_italic:", scopes: ["source.cpm", "comment-italic.cpm"]
    expect(tokens[1]).toEqual value: "foo", scopes: ["source.cpm", "comment-italic.cpm"]
    expect(tokens[2]).toEqual value: "}",   scopes: ["source.cpm", "comment-italic.cpm"]

  it "tokenizes a chorus", ->
    {tokens} = grammar.tokenizeLine("{soc}foo{eoc}")
    expect(tokens[0]).toEqual value: "{soc}", scopes: ["source.cpm", "chorus.cpm"]
    expect(tokens[1]).toEqual value: "foo", scopes: ["source.cpm", "chorus.cpm"]
    expect(tokens[2]).toEqual value: "{eoc}",   scopes: ["source.cpm", "chorus.cpm"]

    {tokens} = grammar.tokenizeLine("{soc}\nfoo\n{eoc}")
    expect(tokens[0]).toEqual value: "{soc}\n", scopes: ["source.cpm", "chorus.cpm"]
    expect(tokens[1]).toEqual value: "foo", scopes: ["source.cpm", "chorus.cpm"]
    expect(tokens[2]).toEqual value: "\n{eoc}",   scopes: ["source.cpm", "chorus.cpm"]

    {tokens} = grammar.tokenizeLine("{start_of_chorus}foo{end_of_chorus}")
    expect(tokens[0]).toEqual value: "{start_of_chorus}", scopes: ["source.cpm", "chorus.cpm"]
    expect(tokens[1]).toEqual value: "foo", scopes: ["source.cpm", "chorus.cpm"]
    expect(tokens[2]).toEqual value: "{end_of_chorus}",   scopes: ["source.cpm", "chorus.cpm"]

  it "tokenizes a tab section", ->
    {tokens} = grammar.tokenizeLine("{sot}foo{eot}")
    expect(tokens[0]).toEqual value: "{sot}", scopes: ["source.cpm", "tab.cpm"]
    expect(tokens[1]).toEqual value: "foo", scopes: ["source.cpm", "tab.cpm"]
    expect(tokens[2]).toEqual value: "{eot}",   scopes: ["source.cpm", "tab.cpm"]

    {tokens} = grammar.tokenizeLine("{sot}\nfoo\n{eot}")
    expect(tokens[0]).toEqual value: "{sot}\n", scopes: ["source.cpm", "tab.cpm"]
    expect(tokens[1]).toEqual value: "foo", scopes: ["source.cpm", "tab.cpm"]
    expect(tokens[2]).toEqual value: "\n{eot}",   scopes: ["source.cpm", "tab.cpm"]

    {tokens} = grammar.tokenizeLine("{start_of_tab}foo{end_of_tab}")
    expect(tokens[0]).toEqual value: "{start_of_tab}", scopes: ["source.cpm", "tab.cpm"]
    expect(tokens[1]).toEqual value: "foo", scopes: ["source.cpm", "tab.cpm"]
    expect(tokens[2]).toEqual value: "{end_of_tab}",   scopes: ["source.cpm", "tab.cpm"]

  it "tokenizes key", ->
    {tokens} = grammar.tokenizeLine("{k:foo}")
    expect(tokens[0]).toEqual value: "{k:", scopes: ["source.cpm", "key.cpm"]
    expect(tokens[1]).toEqual value: "foo", scopes: ["source.cpm", "key.cpm"]
    expect(tokens[2]).toEqual value: "}",   scopes: ["source.cpm", "key.cpm"]

    {tokens} = grammar.tokenizeLine("{k:  foo  }")
    expect(tokens[0]).toEqual value: "{k:  ", scopes: ["source.cpm", "key.cpm"]
    expect(tokens[1]).toEqual value: "foo", scopes: ["source.cpm", "key.cpm"]
    expect(tokens[2]).toEqual value: "  }",   scopes: ["source.cpm", "key.cpm"]

    {tokens} = grammar.tokenizeLine("{key:foo}")
    expect(tokens[0]).toEqual value: "{key:", scopes: ["source.cpm", "key.cpm"]
    expect(tokens[1]).toEqual value: "foo", scopes: ["source.cpm", "key.cpm"]
    expect(tokens[2]).toEqual value: "}",   scopes: ["source.cpm", "key.cpm"]
