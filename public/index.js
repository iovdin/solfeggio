function range(start, end) {
  var a, _res, _ref;
  if ((typeof end === 'undefined')) {
    end = start;
    start = 0;
  }
  _res = [];
  while (true) {
    if ((start <= end)) {
      a = start;
      ++start;
      _ref = a;
    } else {
      _ref = undefined;
      break;
    }
    if (typeof _ref !== 'undefined') _res.push(_ref);
  }
  return _res;
}
var interval = function(timeout) {
  var _i;
  var body = 2 <= arguments.length ? [].slice.call(arguments, 1, _i = arguments.length - 0) : (_i = 1, []);
  return (function(intVar) {
    return ["=", intVar, ["setInterval", ["fn", "stop", [].concat(["do"]).concat(body)], timeout, ["fn", ["clearInterval", intVar]]]];
  })("interval" + this.gensym());
};
var doc, htmlNS, svgNS, svgTags, htmlTags, prefixable, _attrs, screenWidth, screenHeight, allNotes, octaveNotes, octave, note, dissonance, sadhappy, oct2sh, oct2dis, octaves, directions, intervals, notes, halfTones, sayIt, showIt, ttw, intervalNames, samples, audio, sampler, playing, prev, _i, _ref, _len, _i0, _ref0, _len0;

function _once(condition, body) {
  var intervalghCHEn0;
  return (intervalghCHEn0 = setInterval((function(stop) {
    var _ref;
    if (!!condition()) {
      stop();
      _ref = body();
    } else {
      _ref = undefined;
    }
    return _ref;
  }), 10, (function() {
    return clearInterval(intervalghCHEn0);
  })));
}
_once;
doc = document;
htmlNS = "http://www.w3.org/1999/xhtml";
svgNS = "http://www.w3.org/2000/svg";

function element(name) {
  var ns, result, _i, _ref;
  var children = 2 <= arguments.length ? [].slice.call(arguments, 1, _i = arguments.length - 0) : (_i = 1, []);
  if ((htmlTags.indexOf(name) >= 0)) {
    _ref = htmlNS;
  } else if (svgTags.indexOf(name) >= 0) {
    _ref = svgNS;
  } else {
    _ref = undefined;
  }
  ns = _ref;
  if ((typeof ns === 'undefined')) throw new Error(("tag is not supported: " + name));
  result = doc.createElementNS(ns, name);
  if (((typeof children[0] === "object") && !(children[0] instanceof doc.defaultView.Element) && !(children[0] instanceof doc.defaultView.Node) && !Array.isArray(children[0]) && !(children[0] instanceof NodeList))) attr(result, children.shift());

  function handleChild() {
    var _ref0;
    if ((typeof arguments[0] === "string" || typeof arguments[0] === "number" || typeof arguments[0] === "boolean")) {
      _ref0 = result.appendChild(doc.createTextNode(String(arguments[0])));
    } else if ((arguments[0] instanceof doc.defaultView.Element) || (arguments[0] instanceof doc.defaultView.Node)) {
      _ref0 = result.appendChild(arguments[0]);
    } else if (Array.isArray(arguments[0]) || (arguments[0] instanceof NodeList)) {
      _ref0 = Array.prototype.slice.call(arguments[0]).forEach(handleChild);
    } else if ((typeof arguments[0] === "undefined") || (arguments[0] === null)) {
      _ref0 = "";
    } else {
      _ref0 = undefined;
      throw new Error(("unknown element: '" + name + "' with children: " + arguments[0]));
    }
    return _ref0;
  }
  handleChild;
  handleChild(children);
  return result;
}
element;

function makeTag(tag) {
  return (function() {
    var _i;
    var params = 1 <= arguments.length ? [].slice.call(arguments, 0, _i = arguments.length - 0) : (_i = 0, []);
    return element.apply(element, [].concat([tag]).concat(params));
  });
}
makeTag;

function defTags(tags, scope) {
  var tag, _i, _res, _ref, _len, _ref0;
  _res = [];
  _ref = tags;
  for (_i = 0, _len = _ref.length; _i < _len; ++_i) {
    tag = _ref[_i];
    if (typeof(_ref0 = (scope[tag] = makeTag(tag))) !== 'undefined') _res.push(_ref0);
  }
  return _res;
}
defTags;
svgTags = "a altGlyph altGlyphDef altGlyphItem animate animateColor animateMotion animateTransform circle clipPath color-profile cursor defs desc ellipse feBlend feColorMatrix feComponentTransfer feComposite feConvolveMatrix feDiffuseLighting feDisplacementMap feDistantLight feFlood feFuncA feFuncB feFuncG feFuncR feGaussianBlur feImage feMerge feMergeNode feMorphology feOffset fePointLight feSpecularLighting feSpotLight feTile feTurbulence filter font font-face font-face-format font-face-name font-face-src font-face-uri foreignObject g glyph glyphRef hkern image line linearGradient marker mask metadata missing-glyph mpath path pattern polygon polyline radialGradient rect script set stop style svg switch symbol text textPath title tref tspan use view vkern".split(" ");
htmlTags = "a abbr address area article aside audio b base bdi bdo big blockquote body br button canvas caption cite code col colgroup data datalist dd del details dfn dialog div dl dt em embed fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 header hr i img input ins iframe kbd keygen label legend li link main mark menu menuitem meta meter nav noscript object ol optgroup option output p param picture pre progress q rp rt ruby s samp script section select small span source strong style sub summary sup table tbody td textarea tfoot th thead time title tr track u ul var video wbr".split(" ");
defTags(htmlTags, window);
defTags(svgTags, window);

function findElements(selector) {
  var el, _i, _res, _ref, _len, _ref0, _i0, _res0, _ref1, _len0, _ref2;
  if ((typeof selector === "string")) {
    _res = [];
    _ref = doc.querySelectorAll(selector);
    for (_i = 0, _len = _ref.length; _i < _len; ++_i) {
      el = _ref[_i];
      if (typeof el !== 'undefined') _res.push(el);
    }
    _ref0 = _res;
  } else if ((typeof selector === "object") && selector && selector.appendChild) {
    _ref0 = [selector];
  } else if (selector instanceof Array) {
    _res0 = [];
    _ref1 = selector;
    for (_i0 = 0, _len0 = _ref1.length; _i0 < _len0; ++_i0) {
      el = _ref1[_i0];
      if (typeof findElements(el) !== 'undefined') _res0.push(findElements(el));
    }
    _ref0 = (_ref2 = [])["concat"].apply(_ref2, [].concat(_res0)).reduce((function(memo, el) {
      if ((-1 === memo.indexOf(el))) memo.push(el);
      return memo;
    }), []);
  } else {
    _ref0 = [];
  }
  return _ref0;
}
findElements;

function makePairs(array) {
  return array.reduce((function(prev, cur, index, array) {
    if (((index % 2) === 1)) prev.push([array[index - 1], array[index]]);
    return prev;
  }), []);
}
makePairs;
prefixable = "flex flex-direction flex-wrap justify-content align-items flex-grow flex-shrink flex-basis".split(" ");

function cssDeclaration(name, value, prefixed) {
  var _ref, _ref0;
  if (prefixed) {
    if (([].indexOf.call(prefixable, name) >= 0)) {
      _ref = (cssDeclaration(name, value) + cssDeclaration(prefix(name), value));
    } else if ([].indexOf.call(prefixable, value) >= 0) {
      _ref = (cssDeclaration(name, value) + cssDeclaration(name, prefix(value)));
    } else {
      _ref = cssDeclaration(name, value);
    }
    _ref0 = _ref;
  } else {
    _ref0 = ("  " + name + ": " + value + ";\n");
  }
  return _ref0;
}
cssDeclaration;

function setPrefixedStyle(element, name, value) {
  var _ref;
  if (([].indexOf.call(prefixable, name) >= 0)) {
    element.style[dash2camel(name)] = value;
    _ref = (element.style[dash2camel(prefix(name))] = value);
  } else if ([].indexOf.call(prefixable, value) >= 0) {
    element.style[dash2camel(name)] = value;
    _ref = (element.style[dash2camel(name)] = prefix(value));
  } else {
    _ref = (element.style[dash2camel(name)] = value);
  }
  return _ref;
}
setPrefixedStyle;

function getPrefixedStyle(element, name) {
  return (((typeof element !== 'undefined') && (typeof element.style !== 'undefined')) ? ((((typeof element !== 'undefined')(typeof element.style !== 'undefined') && (typeof element.style[name] !== 'undefined')) && element.style[name]) || (((typeof element !== 'undefined')(typeof element.style !== 'undefined') && (typeof element.style[dash2camel(name)] !== 'undefined')) && element.style[dash2camel(name)]) || (((typeof element !== 'undefined')(typeof element.style !== 'undefined') && (typeof element.style[prefix(name)] !== 'undefined')) && element.style[prefix(name)]) || (((typeof element !== 'undefined')(typeof element.style !== 'undefined') && (typeof element.style[dash2camel(prefix(name))] !== 'undefined')) && element.style[dash2camel(prefix(name))])) : undefined);
}
getPrefixedStyle;
_attrs = {};

function attr(selector, params) {
  var _elements, element, _result, handler, _i, _res, _ref, _len, _ref0;
  handler = (function(element) {
    var key, value, _ref, _len;
    if ((typeof params === "string")) return element.getAttribute(camel2dash(key), value);
    _ref = params;
    for (key in _ref) {
      value = _ref[key];
      if ((typeof _attrs[key] === "function")) {
        _attrs[key](element, value);
      } else {
        if (((typeof value === 'undefined') || (value === false || value === null))) {
          element.removeAttribute(camel2dash(key));
        } else if (value === true) {
          element.setAttribute(camel2dash(key), "");
        } else {
          element.setAttribute(camel2dash(key), value);
        }
      }
    }
    element;
    return element;
  });
  _elements = findElements(selector);
  _res = [];
  _ref = _elements;
  for (_i = 0, _len = _ref.length; _i < _len; ++_i) {
    element = _ref[_i];
    handler(element);
    _res.push(undefined);
  }
  _result = _res;
  if ((_elements.length === 0)) {
    _ref0 = undefined;
  } else if (_elements.length === 1) {
    _ref0 = _elements[0];
  } else {
    _ref0 = _elements;
  }
  return _ref0;
}
attr;

function css(selector, value) {
  var _elements, element, _result, handler, _i, _res, _ref, _len, _ref0;
  handler = (function(element) {
    var key, val, pair, _ref, _len, _i, _ref0, _len0;
    if ((typeof value === "object")) {
      _ref = value;
      for (key in _ref) {
        val = _ref[key];
        element.style[key] = val;
      }
    } else if (Array.isArray(value)) {
      _ref0 = makePairs(value);
      for (_i = 0, _len0 = _ref0.length; _i < _len0; ++_i) {
        pair = _ref0[_i];
        element.style[pair[0]] = pair[1];
      }
    } else if (typeof value === "string") {
      css(element, value.split(/\s+/));
    }
    element;
    element;
    return element;
  });
  _elements = findElements(selector);
  _res = [];
  _ref = _elements;
  for (_i = 0, _len = _ref.length; _i < _len; ++_i) {
    element = _ref[_i];
    handler(element);
    _res.push(undefined);
  }
  _result = _res;
  if ((_elements.length === 0)) {
    _ref0 = undefined;
  } else if (_elements.length === 1) {
    _ref0 = _elements[0];
  } else {
    _ref0 = _elements;
  }
  return _ref0;
}
_attrs["css"] = css;

function renderTo(selector) {
  var _elements, element, _result, _i, handler, _i0, _res, _ref, _len, _ref0;
  var elements = 2 <= arguments.length ? [].slice.call(arguments, 1, _i = arguments.length - 0) : (_i = 1, []);
  handler = (function(element) {
    while (element.firstChild) {
      element.removeChild(element.firstChild);
    }

    function handleElement(elements) {
      var _ref;
      if ((typeof elements === "string" || typeof elements === "number")) {
        _ref = element.appendChild(doc.createTextNode(elements));
      } else if ((elements instanceof doc.defaultView.Element) || (elements instanceof doc.defaultView.Node)) {
        _ref = element.appendChild(elements);
      } else if (Array.isArray(elements)) {
        _ref = elements.forEach(handleElement);
      } else if (typeof elements === "undefined") {
        _ref = 0;
      } else {
        _ref = undefined;
        throw new Error(("unknown element: '" + elements));
      }
      return _ref;
    }
    handleElement;
    handleElement(elements);
    return element;
  });
  _elements = findElements(selector);
  _res = [];
  _ref = _elements;
  for (_i0 = 0, _len = _ref.length; _i0 < _len; ++_i0) {
    element = _ref[_i0];
    handler(element);
    _res.push(undefined);
  }
  _result = _res;
  if ((_elements.length === 0)) {
    _ref0 = undefined;
  } else if (_elements.length === 1) {
    _ref0 = _elements[0];
  } else {
    _ref0 = _elements;
  }
  return _ref0;
}
renderTo;

function _getComputedStyle(element, name) {
  var st;
  if ((typeof element === "string")) element = doc.querySelector(element);
  return (((typeof element !== 'undefined') && (typeof element.ownerDocument !== 'undefined') && (typeof element.ownerDocument.defaultView !== 'undefined') && (typeof element.ownerDocument.defaultView.getComputedStyle !== 'undefined')) ? ((st = element.ownerDocument.defaultView.getComputedStyle(element, null)) ? (((typeof st.getPropertyValue(name) !== 'undefined') && st.getPropertyValue(name)) || ((typeof st.getPropertyValue(dash2camel(name)) !== 'undefined') && st.getPropertyValue(dash2camel(name))) || ((typeof st.getPropertyValue(prefix(name)) !== 'undefined') && st.getPropertyValue(prefix(name))) || ((typeof st.getPropertyValue(dash2camel(prefix(name))) !== 'undefined') && st.getPropertyValue(dash2camel(prefix(name))))) : undefined) : undefined);
}
_getComputedStyle;

function _getSpecifiedStyle(element, name) {
  if ((typeof element === "string")) element = doc.querySelector(element);
  return getPrefixedStyle(element, name);
}
_getSpecifiedStyle;

function getStyle(element, name) {
  return (((typeof getSpecifiedStyle(element, name) !== 'undefined') && getSpecifiedStyle(element, name)) || ((typeof _getComputedStyle(element, name) !== 'undefined') && _getComputedStyle(element, name)));
}
getStyle;

function prefix(value) {
  return ("-webkit-" + value);
}
prefix;

function deprefix(value) {
  return (((typeof value === "string") && (value.indexOf("-webkit-") === 0)) ? value.substr(8) : value);
}
deprefix;

function dash2camel(value) {
  return value.replace(/(-\w)/g, (function(match) {
    return match[1].toUpperCase();
  }));
}
dash2camel;

function camel2dash(value) {
  return value.replace(/([A-Z])/g, (function(match) {
    return ("-" + match[0].toLowerCase());
  }));
}
camel2dash;
screenWidth = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);
screenHeight = Math.max(document.documentElement.clientHeight, window.innerHeight || 0);

function _on(element, event, callback) {
  element.addEventListener(event, callback);
  return element;
}
_on;

function _tap(element, callback) {
  callback(element);
  return element;
}
_tap;

function _bind(element, getter, setter) {
  (element.type === "checkbox") ? element.checked = getter(): element.value = getter();
  element.addEventListener("change", (function(event) {
    return setter(((element.type === "checkbox") ? element.checked : element.value));
  }));
  return element;
}
_bind;

function _lget(name, value) {
  var _ref, _err;
  try {
    _ref = JSON.parse(localStorage.getItem(name));
  } catch (_err) {
    _ref = undefined;
  }
  return (function(res) {
    var _ref;
    if ((((res === null) || (typeof res === 'undefined')) && (typeof value !== 'undefined'))) {
      _ref = JSON.parse(JSON.stringify(value));
    } else if ((res !== null) && (typeof res !== 'undefined')) {
      _ref = res;
    } else {
      _ref = undefined;
    }
    return _ref;
  })(_ref);
}
_lget;

function _lset(name, value) {
  return localStorage.setItem(name, JSON.stringify(value));
}
_lset;

function _binds(element, getter, setter) {
  (element.type === "checkbox") ? element.checked = getter(): element.value = getter();
  element.addEventListener("change", (function(event) {
    return setter(((element.type === "checkbox") ? element.checked : element.value));
  }));
  return element;
}
_binds;
allNotes = [];
octaveNotes = "C C# D D# E F F# G G# A A# B".split(" ");
_ref = range(1, 8);
for (_i = 0, _len = _ref.length; _i < _len; ++_i) {
  octave = _ref[_i];
  _ref0 = octaveNotes;
  for (_i0 = 0, _len0 = _ref0.length; _i0 < _len0; ++_i0) {
    note = _ref0[_i0];
    allNotes.push(note + octave);
  }
}

function randint(min, max) {
  return (min + Math.floor(Math.random() * (0.99 + (max - min))));
}
randint;

function randChoice(array, exception) {
  return (function(target) {
    return target[randint(0, target.length - 1)];
  })(((typeof exception !== 'undefined') ? array.filter((function(item) {
    return (item !== exception);
  })) : array));
}
randChoice;
dissonance = [0, 6, 5, 3, 3, 2, 4, 1, 3, 3, 5, 6];
sadhappy = [0, 4, 4, 4, 3, 2, 4, 1, 3, 4, 4, 4];
oct2sh = [0, 1.5, 1, 0, 0, -1, -1.5];
oct2dis = [2, 1, 0, 0, 0, 0.5, 0.5];
octaves = _lget("octaves", {
  1: true,
  2: true,
  3: true,
  4: true,
  5: true,
  6: true,
  7: true
});
directions = _lget("directions", {
  down: true,
  once: true,
  up: true
});
intervals = _lget("intervals", {
  1: true,
  2: true,
  3: true,
  4: true,
  5: true,
  6: true,
  7: true,
  8: true,
  9: true,
  10: true,
  11: true,
  12: undefined
});
notes = _lget("notes", octaveNotes
  .reduce((function(memo, note) {
    memo[note] = true;
    return memo;
  }), {}));
halfTones = _lget("halfTones", true);
sayIt = _lget("sayIt", true);
showIt = _lget("showIt", true);
ttw = _lget("ttw", 3);

function score(note1, note2, direction) {
  return let * (interval, allNotes.indexOf(note2) - allNotes.indexOf(note1), octave, parseInt(note1["slice"](-1)[0]), baseInterval, interval % 12, sInterval, ((baseInterval > 6) ? (12 - baseInterval) : undefined), Array(dissonance[baseInterval]));
}
score;
intervalNames = ["unisono.mp3", "seconda-minore.mp3", "seconda-maggiore.mp3", "terza-minore.mp3", "terza-maggiore.mp3", "quarta-giusta.mp3", "tritono.mp3", "quinta-giusta.mp3", "sesta-minore.mp3", "sesta-maggiore.mp3", "settima-minore.mp3", "settima-maggiore.mp3", "ottava.mp3"];
samples = "A7 A1 A2 A3 A4 A5 A6 A#7 A#1 A#2 A#3 A#4 A#5 A#6 B7 B1 B2 B3 B4 B5 B6 C7 C1 C2 C3 C4 C5 C6 C7 C#7 C#1 C#2 C#3 C#4 C#5 C#6 D7 D1 D2 D3 D4 D5 D6 D#7 D#1 D#2 D#3 D#4 D#5 D#6 E7 E1 E2 E3 E4 E5 E6 F7 F1 F2 F3 F4 F5 F6 F#7 F#1 F#2 F#3 F#4 F#5 F#6 G7 G1 G2 G3 G4 G5 G6 G#7 G#1 G#2 G#3 G#4 G#5 G#6"
  .split(" ")
  .reduce((function(memo, note) {
    memo[note] = note.replace("#", "s") + ".mp3";
    return memo;
  }), {});
audio = new Audio();

function play(url, callback) {
  audio.src = url;
  audio.play();

  function onEnd() {
    if ((typeof callback === "function")) callback();
    return audio.removeEventListener("ended", onEnd);
  }
  onEnd;
  return audio.addEventListener("ended", onEnd);
}
play;

function delay(ms, callback) {
  return setTimeout(callback, ms);
}
delay;
sampler = new Tone.Sampler({
    urls: samples,
    baseUrl: "/piano/"
  })
  .toDestination();
playing = false;
prev = undefined;

function active(obj) {
  var key, value, _res, _ref1, _len1, _ref2;
  _res = [];
  _ref1 = obj;
  for (key in _ref1) {
    value = _ref1[key];
    if (typeof(_ref2 = (value ? key : undefined)) !== 'undefined') _res.push(_ref2);
  }
  return _res;
}
active;

function playRound(callback) {
  var random, randomProp, direction, note1, note2, now, order, _ref1;
  random = {
    note: !prev,
    interval: !prev,
    octave: !prev,
    direction: !prev
  };
  if (prev) {
    randomProp = randChoice(["note", "interval", "octave", "direction"]
      .filter((function(t) {
        return (active(window[t + "s"]).length > 1);
      })));
    random[randomProp] = true;
  }

  function choose(name) {
    return (function(avail) {
      return (((random[name] && (avail.length > 1)) || !prev || !prev[name]) ? randChoice(avail, ((typeof prev !== 'undefined') ? prev[name] : undefined)) : prev[name]);
    })(active(window[name + "s"]));
  }
  choose;
  interval = choose("interval");
  octave = choose("octave");
  note = choose("note");
  direction = choose("direction");
  note1 = note + octave;
  note2 = allNotes[allNotes.indexOf(note1) + parseInt(interval)];
  now = Tone.now();
  prev = {
    interval: interval,
    octave: octave,
    direction: direction,
    note: note
  };
  if (showIt) renderTo("#note", interval, " ", note1, " ", note2);
  switch (direction) {
    case "once":
      _ref1 = [0, 0];
      break;
    case "up":
      _ref1 = [Math.random(), Math.random()]
        .sort();
      break;
    case "down":
      _ref1 = [Math.random(), Math.random()]
        .sort()
        .reverse();
      break;
    default:
      _ref1 = undefined;
  }
  order = _ref1;
  console.log("play round", note1, note2, interval, direction);
  sampler.triggerAttack(note1, now + order[0]);
  sampler.triggerAttack(note2, now + order[1]);
  sampler.triggerRelease([note1, note2], now + 1.5);
  return delay(1000 * ttw, (function(err, _valgTTOKRE) {
    _valgTTOKRE;
    if (!playing) return;
    return (function(__cb) {
      var __cond;
      __cond = sayIt;
      return (__cond ? play("/numbers/" + (halfTones ? (interval + ".mp3") : intervalNames[interval]), (function(err, _valgcJrGLK) {
        return __cb(undefined, _valgcJrGLK);
      })) : __cb(undefined, undefined));
    })((function(err, _valgwG9mjk) {
      _valgwG9mjk;
      return callback();
    }));
  }));
}
playRound;
_once((function() {
  return ((document.readyState === "complete") && sampler.loaded);
}), (function() {
  return renderTo("body", h1({
    id: "note"
  }), div("pause for ", _binds(input({
    type: "number",
    min: 1,
    max: 10
  }), (function() {
    return ttw;
  }), (function(value) {
    ttw = value;
    return _lset("ttw", ttw);
  })), " seconds"), div("half-tones", _binds(input({
    type: "checkbox"
  }), (function() {
    return halfTones;
  }), (function(value) {
    halfTones = value;
    return _lset("halfTones", halfTones);
  }))), div("say it", _binds(input({
    type: "checkbox"
  }), (function() {
    return sayIt;
  }), (function(value) {
    sayIt = value;
    return _lset("sayIt", sayIt);
  }))), div("show it", _binds(input({
    type: "checkbox"
  }), (function() {
    return showIt;
  }), (function(value) {
    showIt = value;
    return _lset("showIt", showIt);
  }))), div("intervals:", range(1, 13)
    .map((function(interval) {
      return span(" ", interval, _binds(input({
        type: "checkbox"
      }), (function() {
        return intervals[interval];
      }), (function(value) {
        intervals[interval] = value;
        return _lset("intervals", intervals);
      })), " ");
    }))), div("notes:", octaveNotes
    .map((function(note) {
      return span(" ", note, _binds(input({
        type: "checkbox"
      }), (function() {
        return notes[note];
      }), (function(value) {
        notes[note] = value;
        return _lset("notes", notes);
      })), " ");
    }))), div("octaves:", range(1, 7)
    .map((function(octave) {
      return span(" ", octave, _binds(input({
        type: "checkbox"
      }), (function() {
        return octaves[octave];
      }), (function(value) {
        octaves[octave] = value;
        return _lset("octaves", octaves);
      })), " ");
    }))), div("order: ", "up ", _binds(input({
    type: "checkbox"
  }), (function() {
    return directions.up;
  }), (function(value) {
    directions.up = value;
    return _lset("directions", directions);
  })), " ", "at once ", _binds(input({
    type: "checkbox"
  }), (function() {
    return directions.once;
  }), (function(value) {
    directions.once = value;
    return _lset("directions", directions);
  })), " ", "down ", _binds(input({
    type: "checkbox"
  }), (function() {
    return directions.down;
  }), (function(value) {
    directions.down = value;
    return _lset("directions", directions);
  }))), " ", _tap(button("start"), (function(it) {
    return _on(it, "click", (function(event) {
      function playNextCallback() {
        return (playing ? playRound(playNextCallback) : undefined);
      }
      playNextCallback;
      playing = !playing;
      if (playing) playRound(playNextCallback);
      return renderTo(it, (playing ? "stop" : "start"));
    }));
  })));
}));