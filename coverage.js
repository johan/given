window.onload = function() {
  var file = 'coverage-PhantomJS 1.8 (Mac)-20130704_200523.json';
  $.getJSON('coverage/'+ file, function done(coverage) {
    render('./given.js', coverage);
  });

  $(document.body).on('mouseenter mouseleave', '.b', function(e) {
    if (e.type === 'mouseenter')
      $('.'+ this.id.replace(/-\d+$/, '')).addClass('focus');
    else
      $('.focus').removeClass('focus');
  })
  .on('mouseenter mouseleave', '.f', function(e) {
    if (e.type === 'mouseleave')
      $('.f-focus:not(:hover)').removeClass('f-focus');
    else if ($('.f:hover', this).length) return;
    else
      $(this).addClass('f-focus');
  });
};

function render(path, coverage) {
  var src = files[path], file = coverage[path];
  document.body.innerHTML =
    paintStatements(src, file, ['fnMap', 'branchMap', 'statementMap']);
}

function h(text) {
  return String(text)
    .replace(/\x26/g, '&amp;')
    .replace(/\x3C/g, '&lt;')
    .replace(/\x22/g, '&quot;');
}

function paintStatements(src, file, maps) {
  function tag(id, name, count) {
    var hits = count == null ? '' : 'data-hits="'+ count +'" ';
    name = name ? 'title="'+ h(name) +'" ' : '';
    var coverage = count ? 'c c-'+ Math.ceil(Math.log(count)) : 'x'
      , type = id.charAt()
      , cls = [type, coverage];
    if (type === 'b') cls.splice(1, 0, id.replace(/-\d+$/g, ''));
    cls = cls.length ? 'class="'+ cls.join(' ') +'" ' : '';
    return '<span '+ hits + name + cls +'id="'+ id +'">';
  }
  function end() { return '</span>'; }
  function add(to) {
    var html = '';
    while (to.line > line) {
      var js = src[line-1].slice(col) + '\n';
      html += h(js);
      line += 1;
      col = 0;
    }
    return html + h(src[line-1].slice(col, col = to.column));
  }

  function sortTokens(maps) {
    var lines = [], tokens = [];

    maps.forEach(function addMap(mapName) {
      function insert(loc, n) {
        var tag = Object.create(loc.start)
          , end = Object.create(loc.end)
          , hits = file[prefix][id]
          , branch = typeof hits == 'number' ? '' : '-'+ (n + 1)
          , name = tag.tag = end.end = prefix +'-'+ id + branch
          , tagLine = lines[tag.line] = lines[tag.line] || []
          , endLine = lines[end.line] = lines[end.line] || []
          , tagCol = tagLine[tag.column] = tagLine[tag.column] || []
          , endCol = endLine[end.column] = endLine[end.column] || []
          ;
        tagCol.push(tag);
        if (tag.line == end.line && tag.column == end.column)
          endCol.push(end);
        else
          endCol.unshift(end);
        tag.name = token.name || token.type;
        tag.hits = hits.length ? hits[n] : hits;
      }

      var map = file[mapName], prefix = mapName.charAt();
      for (var id in map) {
        var token = map[id];
        (token.locations || [token.loc || token]).forEach(insert);
      }
    });

    for (var l = 1; l <= lines.length; l++) {
      var line = lines[l];
      if (!line) continue;
      for (var c = 0; c < line.length; c++) {
        var col = line[c];
        if (col) {
          tokens.push.apply(tokens, col);
        }
      }
    }
    return tokens;
  }

  var line = 1, col = 0, html = '', tokens = sortTokens(maps);

  tokens.forEach(function addToken(token) {
    html += add(token);
    if (token.tag)
      html += tag(token.tag, token.name, token.hits);
    else
      html += end();
  });

  html += add({ line: src.length, column: src[src.length-1].length });

  return html;
}
