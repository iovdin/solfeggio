(= doc document)
(= htmlNS "http://www.w3.org/1999/xhtml"
  svgNS "http://www.w3.org/2000/svg")


(def element name ...children
  (do
    (= ns (if (>= (htmlTags.indexOf name) 0) htmlNS
            (elif (>= (svgTags.indexOf name) 0) svgNS)))
    (if (?! ns)
      (throw (new Error (+ "tag is not supported: " name))))
    (= result (doc.createElementNS ns name))
    (if (and (isa children[0] "object")
          (not (instanceof children[0] doc.defaultView.Element))
          (not (instanceof children[0] doc.defaultView.Node))
          (not (Array.isArray children[0]))
          (not (instanceof children[0] NodeList)))
      (attr result (children.shift)))
    (def handleChild
      (if (isa #0 "string" "number" "boolean")
        (result.appendChild (doc.createTextNode (String #0)))
        (elif (or
                (instanceof #0 doc.defaultView.Element)
                (instanceof #0 doc.defaultView.Node))
          (result.appendChild #0))
        (elif (or (Array.isArray #0) (instanceof #0 NodeList))
          ((Array.prototype.slice.call #0).forEach handleChild))
        (elif (or (isa #0 "undefined") (is #0 null))
          "")
        (throw (new Error (+ "unknown element: '" name "' with children: " #0)))))
    (handleChild children)  
    result))

(e.g. element
     (element "p")
     (element "input" (type: "range"))
     (element "p" "hello world")
     (element "p"
              "hello world"
              (element "a" (href: "http://wrte.io") "wrte.io"))
     (element "p" (list "of" "words" "expands")))



(def makeTag tag
    (fn ...params
        (element tag ...params)))

(e.g. makeTag
     (= p (makeTag "p")))

(def defTags tags scope
    (for tag tags
         (= (get scope tag) (makeTag tag))))


(e.g. defTags
     (defTags `("html" "body" "head") window))
(= svgTags ("a altGlyph altGlyphDef altGlyphItem animate animateColor animateMotion animateTransform circle clipPath color-profile cursor defs desc ellipse feBlend feColorMatrix feComponentTransfer feComposite feConvolveMatrix feDiffuseLighting feDisplacementMap feDistantLight feFlood feFuncA feFuncB feFuncG feFuncR feGaussianBlur feImage feMerge feMergeNode feMorphology feOffset fePointLight feSpecularLighting feSpotLight feTile feTurbulence filter font font-face font-face-format font-face-name font-face-src font-face-uri foreignObject g glyph glyphRef hkern image line linearGradient marker mask metadata missing-glyph mpath path pattern polygon polyline radialGradient rect script set stop style svg switch symbol text textPath title tref tspan use view vkern".split " ")
  htmlTags ("a abbr address area article aside audio b base bdi bdo big blockquote body br button canvas caption cite code col colgroup data datalist dd del details dfn dialog div dl dt em embed fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 header hr i img input ins iframe kbd keygen label legend li link main mark menu menuitem meta meter nav noscript object ol optgroup option output p param picture pre progress q rp rt ruby s samp script section select small span source strong style sub summary sup table tbody td textarea tfoot th thead time title tr track u ul var video wbr".split " "))


(defTags htmlTags window)
(defTags svgTags window)


(e.g.
 (svg (width: "100px" height: "100px")
      (circle (cx:"50" cy:"50" r:"40" stroke:"green" strokeWidth:"4" fill:"yellow")))
 (circle (cx:"50" cy:"50" r:"40" stroke:"green" strokeWidth:"4" fill:"yellow"))
 (rect (x:"50" y:"20" width:"150" height:"150" style:"fill:blue;stroke:pink;stroke-width:5;fill-opacity:0.1;stroke-opacity:0.9"))
 (ellipse (cx:"200" cy:"80" rx:"100" ry:"50" style:"fill:yellow;stroke:purple;stroke-width:2"))
 (line (x1:"0" y1:"0" x2:"200" y2:"200" style:"stroke:rgb(255,0,0);stroke-width:2"))
 (polygon (points:"200,10 250,190 160,210" style:"fill:lime;stroke:purple;stroke-width:1"))
 (polyline (points:"20,20 40,25 60,40 80,120 120,140 200,180" style:"fill:none;stroke:black;stroke-width:3"))
 (path (d:"M150 0 L75 200 L225 200 Z"))
 (g (stroke:"black" strokeWidth:"3" fill:"black")
    (circle (id:"pointA" cx:"100" cy:"350" r:"3"))
    (circle (id:"pointB" cx:"250" cy:"50" r:"3"))
    (circle (id:"pointC" cx:"400" cy:"350" r:"3")))
 (text (x:"0" y:"15" fill:"red") "I love SVG!"))


(e.g.
 (iframe (head (style "some style"))
         (body)))


(def findElements selector
    (if (isa selector "string")
      (for el (doc.querySelectorAll selector) el)
      (elif (and (isa selector "object") selector selector.appendChild) (list selector))
      (elif (instanceof selector Array)
            (((list)["concat"] ...(for el selector (findElements el))).reduce
             (fn memo el (do (if (is -1 (memo.indexOf el))
                               (memo.push el))
                           memo)) (list)))
      (list)))


(e.g. findElements
     (findElements "#content1")
     (findElements (list "#content1" ".class"))
     (is (findElements document.body) (list document.body)))



(mac $ selector ...body
    `(do
       (= #handler (fn element (do ,...body element))
        _elements (findElements ,selector)
          _result
          (for element _elements
               (do
                 (#handler element)
                 undefined)))
       (if (is _elements.length 0)
         undefined
         (elif (is _elements.length 1)
               (car _elements))
         _elements)))

(e.g. $
     ($ "#content"
        (css element (: "background-color" "#FFFFFF")))
     (= ($ "#content").style.display "none")
     (prn "is input focused" (is document.activeElement ($ "#input"))))

(mac def$ name ...params body
    `(def ,name selector ,...params
          ($ selector
             ,body)))


(e.g. def$
     (def$ css style
           (over value key style
                 (= element.style[key] value)))
     (css ".class" (: backgroundColor "#FF0000")))


(def makePairs array
    (array.reduce
      (fn prev cur index array
          (do
            (if (is (% index 2) 1)
              (prev.push (list (get array (- index 1)) array[index])))
            prev))
      (list)))

(e.g. makePairs
     (is (makePairs `(1 2 3 4)) `((1 2) (3 4))))

(= prefixable ("flex flex-direction flex-wrap justify-content align-items flex-grow flex-shrink flex-basis".split " "))


(def cssDeclaration name value prefixed
    (if prefixed
      (if (in name prefixable)
        (+ (cssDeclaration name value)
           (cssDeclaration (prefix name) value))
        (elif (in value prefixable)
              (+ (cssDeclaration name value)
                 (cssDeclaration name (prefix value))))
        (cssDeclaration name value))
      (+ "  " name ": " value ";\n")))


(def setPrefixedStyle element name value
    (if (in name prefixable)
      (do (= element.style[(dash2camel name)] value)
        (= element.style[(dash2camel (prefix name))] value))
      (elif (in value prefixable)
            (do (= element.style[(dash2camel name)] value)
              (= element.style[(dash2camel name)] (prefix value))))
      (= element.style[(dash2camel name)] value)))

(def getPrefixedStyle element name
    (if (? element.style)
      (any
        (get element.style name)
        (get element.style (dash2camel name))
        (get element.style (prefix name))
        (get element.style (dash2camel (prefix name))))))



(= _attrs (:))
(def$ attr params
 (do
  (if (isa params "string")
    (return (element.getAttribute (camel2dash key) value)))
  (over value key params
   (if (isa _attrs[key] "function")
    (_attrs[key] element value)
    (if (or (?! value) (is value no null))
     (element.removeAttribute (camel2dash key))
     (elif (is value yes)
       (element.setAttribute (camel2dash key) ""))
     (element.setAttribute (camel2dash key) value))))
  element))

(e.g.
 (attr it (class: "comment"))
 (attr it "width"))


(mac defattr name ...body
    `(= (get _attrs ,(JSON.stringify name))
        (def ,name selector value
             ($ selector
                (do ,...body element)))))
(e.g. defattr
     (defattr flexitem
              (css element (+ "flex " value)))


     (span (flexitem: "1 1 auto") "hello world")
     (flexitem (span) "1 1 auto"))


(defattr css
        (do
          (if (isa value "object")
            (over val key value
                  (= element.style[key] val))
            (elif (Array.isArray value)
                  (for pair (makePairs value)
                       (= element.style[pair[0]] pair[1])))
            (elif (isa value "string")
                  (css element (value.split /\s+/))))
          element))

(e.g.
 (css element (backgroundColor: "#FF0000"))
 (css element ("display" "flex"
               "display" "-webkit-flex"))
 (css "#content" "display flex
       display -webkit-flex"))


(e.g.
 (toggleClass element "className")
 (toggleClass element "className" yes)
 (toggleClass element "className" no))


(def$ renderTo ...elements
   (do
     (while element.firstChild
            (element.removeChild element.firstChild))
     (def handleElement elements
              (if (isa elements "string" "number")
                (element.appendChild (doc.createTextNode elements))
                (elif (or (instanceof elements doc.defaultView.Element)
                          (instanceof elements doc.defaultView.Node))
                      (element.appendChild elements))
                (elif (Array.isArray elements)
                      (elements.forEach handleElement))
                (elif (isa elements "undefined")
                      0)
                (throw (new Error (+ "unknown element: '" elements)))))
     (handleElement elements)))

(e.g.
 (renderTo "#content" (element "p" "hello world")))

(def _getComputedStyle element name
    (do
      (if (isa element "string")
        (= element (doc.querySelector element)))
      (if (? element.ownerDocument.defaultView.getComputedStyle)
        (if (= st (element.ownerDocument.defaultView.getComputedStyle element null))
          (any
            (st.getPropertyValue name)
            (st.getPropertyValue (dash2camel name))
            (st.getPropertyValue (prefix name))
            (st.getPropertyValue (dash2camel (prefix name))))))))


(e.g.
 (_getComputedStyle "#content" "display"))


(def _getSpecifiedStyle element name
    (do
      (if (isa element "string")
        (= element (doc.querySelector element)))
      (getPrefixedStyle element name)))

(e.g.
 (getSpecifiedStyle element "display")
 (getSpecifiedStyle "#content" "flex" "-webkit-flex"))


(def getStyle element name
    (any (getSpecifiedStyle element name) (_getComputedStyle element name)))

(e.g.
 (getStyle element "display")
 (getStyle "#content" "display"))


(def prefix value
    (+ "-webkit-" value))

(def deprefix value
    (if (and (isa value "string") (is (value.indexOf "-webkit-") 0))
      (value.substr 8)
      value))

(def dash2camel value
    (value.replace
      /(-\w)/g
      (fn match
          (match[1].toUpperCase))))

(def camel2dash value
    (value.replace
      /([A-Z])/g
      (fn match
          (+ "-" (match[0].toLowerCase)))))

(e.g.
 (is (deprefix "-webkit-flex") "flex")
 (is (prefix "flex") "-webkit-flex")
 (is (dash2camel "-webkit-flex") "WebkitFlex")
 (is (dash2camel "background-color") "backgroundColor"))


(= screenWidth (Math.max document.documentElement.clientWidth (or window.innerWidth 0))
  screenHeight (Math.max document.documentElement.clientHeight (or window.innerHeight 0)))