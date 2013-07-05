describe 'given()', ->
  it 'should throw an error on no input', ->
    try given() catch e then err = e
    expect(err).toNotBe undefined

  it 'should expose an given.dom function after the first call', ->
    expect(typeof given.dom).toBe 'function'

  it 'should expose an given.query function after the first call', ->
    expect(typeof given.query).toBe 'function'

  it 'should expose an given.path_re function after the first call', ->
    expect(typeof given.path_re).toBe 'function'

  it 'should accept an object with "path_re", "dom", and/or "query" specs', ->
    what = given ready: (->), path_re: '/', dom: 'css *', query: true
    expect(what).toEqual jasmine.any Array
    expect(what.length).toBeGreaterThan 2



describe 'given.dom(dom spec – see below for the three types of dom spec)', ->
  it 'should be a function after the first on() call', ->
    try given() catch e then err = e
    expect(err).toNotBe undefined

  it 'should expose given.dom.* functions once given.dom() has run once', ->
    try
      given.dom()
    fns = Object.keys(given.dom).join(',')
    expect(fns).toBe 'css*,css+,css?,css,xpath*,xpath+,xpath?,xpath!,xpath'



describe 'given.dom(dom spec type 1: a selector string)', ->
  root = document.documentElement
  assertion = it

  describe 'given.dom("css… selection"): Array/Node, optional/not?', ->
    describe 'Array of Node:s (0+ occurrences):', ->
      assertion 'given.dom("css* NotFound") => []', ->
        expect(given.dom('css* NotFound')).toEqual []

      assertion 'given.dom("css* html") => [root element]', ->
        expect(given.dom('css* html')).toEqual [root]

      assertion 'given.dom("css* *") => document.all (but as a proper Array)', ->
        what = given.dom("css* *")
        dall = [].slice.call document.getElementsByTagName('*'), 0
        expect(what).toEqual dall


    describe 'Array of Node:s (1+ occurrences):', ->
      assertion 'given.dom("css+ html") => [root element]', ->
        expect(given.dom('css+ html')).toEqual [root]

      assertion 'given.dom("css+ NotFound") => undefined', ->
        expect(given.dom('css+ NotFound')).toBe undefined


    describe 'single optional Node, or null if not found:', ->
      assertion 'given.dom("css? *") => root element (= first match)', ->
        expect(given.dom('css? *')).toBe root

      assertion 'given.dom("css? NotFound") => null (not found)', ->
        expect(given.dom('css? NotFound')).toBe null


    describe 'single mandatory Node:', ->
      assertion 'given.dom("css *") => the root element', ->
        expect(given.dom('css *')).toBe root

      assertion 'given.dom("css NotFound") => undefined (unsatisfied)', ->
        expect(given.dom('css NotFound')).toBe undefined



  describe 'given.dom("xpath… selection"): Array/Node, optional/not?', ->
    describe 'xpath* => Array of Node:s (0+ occurrences):', ->
      assertion 'given.dom("xpath* /*") => [root element]', ->
        expect(given.dom('xpath* /*')).toEqual [root]

      assertion 'given.dom("xpath* /NotFound") => []', ->
        expect(given.dom('xpath* /NotFound')).toEqual []


    describe 'xpath+ => Array of Node:s (1+ occurrences):', ->
      assertion 'given.dom("xpath+ /*") => [root element]', ->
        expect(given.dom('xpath+ /*')).toEqual [root]

      assertion 'given.dom("xpath+ /NotFound") => undefined', ->
        expect(given.dom('xpath+ /NotFound')).toBe undefined


    describe 'xpath? => single optional Node, or null if missing:', ->
      assertion 'given.dom("xpath? /NotFound") => null', ->
        expect(given.dom('xpath? /NotFound')).toBe null

      assertion 'given.dom("xpath? /*") => the root element', ->
        expect(given.dom('xpath? /*')).toBe root


    describe 'xpath => single mandatory Node:', ->
      assertion 'given.dom("xpath /*") => the root element', ->
        expect(given.dom('xpath /*')).toBe root

      assertion 'given.dom("xpath /NotFound") => undefined', ->
        expect(given.dom('xpath /NotFound')).toBe undefined

      assertion 'given.dom("xpath .") => the current document', ->
        expect(given.dom('xpath .')).toBe document


    describe '…or queries yielding Number/String/Boolean answers:', ->
      assertion 'given.dom("xpath count(/)") => 1', ->
        expect(given.dom('xpath count(/)')).toBe 1

      assertion 'given.dom("xpath count(/NotFound)") => 0', ->
        expect(given.dom('xpath count(/NotFound)')).toBe 0

      assertion 'given.dom("xpath name(/*)") => "html" or "HTML"', ->
        expect(given.dom('xpath name(/*)')).toMatch /^(html|HTML)$/

      assertion 'given.dom("xpath name(/)") => ""', ->
        expect(given.dom('xpath name(/)')).toBe ''

      assertion 'given.dom("xpath count(/*) = 1") => true', ->
        expect(given.dom('xpath count(/*) = 1')).toBe true

      assertion 'given.dom("xpath name(/*) = \'nope\'") => false', ->
        expect(given.dom('xpath name(/*) = \'nope\'')).toBe false


    describe 'xpath! makes assertions, requiring truthy answers:', ->
      assertion 'given.dom("xpath! count(/)") => 1', ->
        expect(given.dom('xpath count(/)')).toBe 1

      assertion 'given.dom("xpath! count(/NotFound)") => undefined', ->
        expect(given.dom('xpath! count(/NotFound)')).toBe undefined

      assertion 'given.dom("xpath! name(/*)") => "html"', ->
        expect(given.dom('xpath! name(/*)')).toMatch /^(html|HTML)$/

      assertion 'given.dom("xpath! name(/)") => undefined', ->
        expect(given.dom('xpath! name(/)')).toBe undefined

      assertion 'given.dom("xpath! count(/*) = 1") => true', ->
        expect(given.dom('xpath! count(/*) = 1')).toBe true

      assertion 'given.dom("xpath! name(/*) = \'nope\'") => undefined', ->
        expect(given.dom('xpath! name(/*) = \'nope\'')).toBe undefined



describe 'given.dom(dom spec type 2: an object showing the structure you want)', ->
  html = document.documentElement
  head = document.querySelector 'head'
  try given() # ensures there's an given.dom to call
  assertion = it

  pluralize = (n, noun) -> "#{n} #{noun}#{if n is 1 then '' else 's'}"

  assertion 'given.dom({}) => {} (fairly useless, but minimal, test case)', ->
    expect(given.dom({})).toEqual {}

  assertion 'given.dom({ h:"css head", H:"css html" }) => { h:head, H:html }', ->
    expect(given.dom({ h:"css head", H:"css html" })).toEqual { h:head, H:html }

  assertion 'given.dom({ h:"css head", f:"css? foot" }) => { h:head, f:null }', ->
    expect(given.dom({ h:"css head", f:"css? foot" })).toEqual { h:head, f:null }

  assertion 'given.dom({ h:"css head", f:"css foot" }) => undefined (no foot!)', ->
    expect(given.dom({ h:"css head", f:"css foot" })).toEqual undefined

  assertion 'given.dom({ x:"css* frame" }) => { x:[] } (frames optional here)', ->
    expect(given.dom({ x:"css* frame" })).toEqual { x:[] }

  assertion 'given.dom({ x:"css+ frame" }) => undefined (but mandatory here!)', ->
    expect(given.dom({ x:"css+ frame" })).toBe undefined

  assertion 'given.dom({ x:"css* script" }) => { x:[…all (>=0) script tags…] }', ->
    what = given.dom({ x:"css* script" })
    expect(what.x).toEqual jasmine.any Array
    expect(what.x.every (s) -> s.nodeName is 'script')

  assertion 'given.dom({ x:"css+ script" }) => { x:[…all (>0) script tags…] }', ->
    what = given.dom({ x:"css+ script" })
    expect(what.x).toEqual jasmine.any Array
    expect(what.x.length).toBeGreaterThan 0
    expect(what.x.every (s) -> s.nodeName.toLowerCase() is 'script').toBe true

  assertion 'given.dom({ c:"xpath count(//script)" }) => {c:N} (any N is okay)', ->
    what = given.dom({ c:"xpath count(//script)" })
    expect(what).toEqual jasmine.any Object
    expect(N = what.c).toEqual jasmine.any Number
    # console.log "given.dom({ c: count(…) }) found #{pluralize N, 'script'}"
    delete what.c
    expect(what).toEqual {}

  assertion 'given.dom({ c:"xpath! count(//script)" }) => {c:N} (only N!=0 ok)', ->
    what = given.dom({ c:"xpath! count(//script)" })
    expect(what.c).toBeGreaterThan 0
    delete what.c
    expect(what).toEqual {}

  assertion 'given.dom({ c:"xpath! count(//missing)" }) => undefined (as N==0)', ->
    expect(given.dom({ c:"xpath! count(//missing)" })).toBe undefined

  assertion 'given.dom({ c:"xpath! count(//*) and /html" }) => { c:true }', ->
    expect(given.dom({ c:"xpath! count(//*) > 5 and /html" })).toEqual c: true



describe 'given.dom(dom spec type 3: [context_spec, per_match_spec])', ->
  html = document.documentElement
  head = document.querySelector 'head'
  try given() # ensures there's an given.dom to call
  assertion = it

  assertion 'given.dom(["css* script[src]", "xpath string(@src)"]) => ["url"…]', ->
    what = given.dom(["css* script[src]", "xpath string(@src)"])
    expect(what).toEqual jasmine.any Array
    expect(what.every (s) -> typeof s is 'string').toBe true

  assertion 'given.dom(["css? script:not([src])", "xpath string(.)"]) => "js…"', ->
    what = given.dom(["css? script:not([src])", "xpath string(.)"])
    expect(typeof what).toBe 'string'
    desc = 'Code of first inline script tag'
    #console.log "#{desc}:\n#{what}\n(#{desc} ends.)"

  assertion '''given.dom(["css? script:not([src])", "xpath! string(@src)"])
               => undefined (empty string is not truthy => not a match)''', ->
    what = given.dom(["css? script:not([src])", "xpath! string(@src)"])
    expect(what).toBe undefined

  assertion 'given.dom(["xpath /svg", "css* *"]) => undefined (not an svg doc)', ->
    expect(given.dom(["xpath /svg", "css* *"])).toBe undefined

  assertion 'given.dom([html, "xpath ."]) => html', ->
    expect(given.dom([html, "xpath ."])).toBe html

  assertion 'given.dom([[head, html], "xpath ."]) => [head, html]', ->
    expect(given.dom([[head, html], "xpath ."])).toEqual [head, html]


describe 'given.dom plugins:', ->
  html = document.documentElement
  assertion = it

  assertion '''given( { dom: "my_plugin", ready: ready = (x) -> }
                    , { dom: "my_plugin": -> document.body }
                    ) => ready(document.body)''', ->
    given(
      { dom: "my_plugin", ready: ready = jasmine.createSpy 'ready' }
      { dom: "my_plugin": -> document.body }
    )
    expect(ready).toHaveBeenCalledWith(document.body)

  assertion 'given.dom(["my_plugin", "xpath ."]) => body', ->
    expect(given.dom(["my_plugin", "xpath ."])).toBe document.body

  assertion 'given.dom(["my_plugin", "xpath .."]) => html', ->
    expect(given.dom(["my_plugin", "xpath .."])).toBe html

  assertion 'given.dom("xpath .") => document', ->
    expect(given.dom("xpath .")).toBe document

###
  assertion '''given( { dom: ["my_plugin", "xpath ."], ready: ready = (x) -> }
                    , { dom: my_plugin: -> document.body })
               => ready(body)''', ->
    ready = jasmine.createSpy 'ready'
    fn( { dom: ["my_plugin", "xpath ."], ready: ready }
      , { dom: my_plugin: -> document.body })
    expect(ready).toHaveBeenCalledWith(document.body)
###
