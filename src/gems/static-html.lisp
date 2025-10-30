(def append  ...args
  (args.reduce 
    (fn memo element 
      (+ memo (if (Array.isArray element) 
                (append.apply this element) element))) ""))

(def camel2dash value 
  (value.replace /([A-Z])/g 
    (fn match 
      (+ "-" (match[0].toLowerCase)))))

(def element name ...children
  (do 
    (= attrs (:)) 
    (= _voidElements (Array "area" "base" "br" "col" "embed" "hr" "img" "input" "keygen" "link" "meta" "param" "source" "track" "wbr"))
    (if (and 
          (isa children[0] "object") 
          (not (Array.isArray children[0]))) 
      (do (= attrs 
            (car children) children 
            (tail children)))) 
    (append "<" name 
      (over value key attrs 
        (append " " 
          (camel2dash key) "=\"" 
          ((((String value).replace /&/g "&amp;").replace /\u00a0/g "&nbsp;").replace (new RegExp "\"" "g") "&quot;")
          "\"")) 
      (if (isnt -1 (_voidElements.indexOf name))
        "/>"
        (append ">" children "</" name ">")))))

(def makeTag tag 
  (fn  ...params
    (element tag ...params)))

(mac createTags  ...tags
  `(do ,...(for tag tags 
             `(= ,tag (makeTag ``,tag)))))

(createTags a abbr address area article aside audio b base bdi bdo big blockquote br button canvas caption cite code col colgroup data datalist dd del details dfn dialog div dl dt em embed fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 header hr i img input ins iframe kbd keygen label legend li link main mark menu menuitem meta meter nav noscript object ol optgroup option output p param picture pre progress q rp rt ruby s samp script section select small span strong style sub summary sup table tbody td textarea tfoot th thead time title tr track u ul video wbr)

(= _heads (list) 
  _body (element "body") 
  _htmlAttrs (:))

(def head ...items
  (do 
    (for item items 
      (if (is (_heads.indexOf item) -1) 
        (_heads.push item))) 
    (html)))

(def body ...items
  (do (= _body (element "body" items)) 
    (html)))

(def html attrs 
  (do 
    (over value key attrs 
      (= _htmlAttrs[key] value)) 
    (append "<!DOCTYPE html>\n" 
      (element "html" _htmlAttrs 
        (element "head" 
          (_heads.join "\n")) _body))))