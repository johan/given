describe 'given.query', ->
  q_was = location.search
  query = (q) ->
    if location.search isnt q
      url = location.href.replace /(\?[^#]*)?(#.*)?$/, "#{q}$2"
      history.replaceState history.state, document.title, url

  it 'should be a function after the first given() call', ->
    try given()
    expect(typeof given.query).toBe 'function'

  it 'given.query() => {} for a missing query string', ->
    query ''
    expect(given.query()).toEqual {}

  it 'given.query() => {} for an empty query string ("?")', ->
    query '?'
    expect(given.query()).toEqual {}

  it 'given.query() => { a:"", x:"0" } for a query string "?a=&x=0"', ->
    query '?a=&x=0'
    expect(given.query()).toEqual
      a: ''
      x: '0'

  it 'given.query() => { ugh:undefined } for a query string "?ugh"', ->
    query '?ugh'
    result = given.query()
    expect('ugh' of result).toBe true
    expect(result).toEqual {} # FIXME - better test framework?
    expect(result.ugh).toBe `undefined`
    query q_was # reset, for good measure
