
(mac async 
 (spread body) 
 (do 
  (= self this) 
  (def parse ref 
   (if 
    (or 
     (isnta ref "string") 
     (is ref "")) 
    (list) 
    (
(ref.split ".").map 
     (fn item 
      (parseInt item))))) 
  (def build refArray 
   (refArray.join ".")) 
  (def parent ref 
   (do 
    (= parsed 
     (parse 
      (any ref ""))) 
    (if 
     (isnt parsed.length 0) 
     (build 
      (parsed.slice 0 -1))))) 
  (def child ref index 
   (do 
    (= index 
     (if 
      (? index) index 0)) 
    (build 
     (
(parse ref).concat index)))) 
  (def tget ast ref 
   (do 
    (= keys 
     (parse ref)) 
    (if 
     (is keys.length 0) ast 
     (elif 
      (?! ref) undefined) 
     (elif 
      (not 
       (Array.isArray ast)) undefined) 
     (elif 
      (? ast[keys[0]]) 
      (tget ast[keys[0]] 
       (build 
        (tail keys))))))) 
  (def tset ast ref value 
   (do 
    (= keys 
     (parse ref)) 
    (if 
     (is keys.length 1) 
     (do 
      (= ast[keys[0]] value) ast) 
     (elif 
      (and 
       (> keys.length 1) 
       (? ast[keys[0]])) 
      (tset ast[keys[0]] 
       (build 
        (tail keys)) value)) (: )))) 
  (def src form 
   (tab "") 
   (if 
    (Array.isArray arguments[0]) 
    (if 
     (and 
      (is form[0] "get") 
      (isa form[2] "string") 
      (is form[2][0] ".")) 
     (+ 
      (src form[1]) form[2]) 
     (elif 
      (and 
       (is form[0] "get") 
       (isa form[1] "string") 
       (is form[1][0] ".")) 
      (src form[1])) 
     (+ "\n" tab "(" 
      (
(for item form 
 (src item 
  (+ tab " "))).join " ") ")")) 
    (elif 
     (is form null) "null") 
    (elif 
     (isa form "object") 
     (+ "(: " 
      (
(over value key form 
 (+ "\"" key "\" " 
  (src value))).join " ") ")")) 
    (elif 
     (? form) form) "")) 
  (def findAwait ast ref 
   (if 
    (Array.isArray ast) 
    (do 
     (if 
      (is ast[0] "await" "await-cb") 
      (or 
       (ast.reduce 
        (fn result val index 
         (if 
          (is index 0) undefined 
          (elif 
           (? result) result) 
          (findAwait val 
           (child ref index)))) undefined) ref) 
      (elif 
       (is ast[0] "async" "fn" "def") 
       (return)) 
      (do 
       (for f index ast 
        (do 
         (= result 
          (findAwait f 
           (child ref index))) 
         (if 
          (? result) 
          (return result)))) return))))) 
  (def lst 
   (spread body) body) 
  (def aif cond body 
   (spread rest) 
   (let bodyList 
    (if 
     (and 
      (Array.isArray body) 
      (is 
       (car body) "do")) 
     (body.slice 1 -1) 
     (list)) bodyResult 
    (if 
     (and 
      (Array.isArray body) 
      (is 
       (car body) "do")) 
     (last body) body) 
    (quote 
     (fn __cb 
      (async 
       (= __cond 
        (unquote cond)) 
       (if __cond 
        (async 
         (unquote 
          (spread bodyList)) 
         (__cb undefined 
          (unquote bodyResult))) 
        (unquote 
         (if 
          (and 
           (Array.isArray 
            (car rest)) 
           (is 
            (car 
             (car rest)) "elif")) 
          (quote 
           (
            (unquote 
             (aif.apply null 
              (concat 
               (tail 
                (car rest)) 
               (tail rest)))) __cb)) 
          (quote 
           (async 
            (__cb undefined 
             (unquote 
              (car rest))))))))))))) 
  (def replaceAwait ast vindex 
   (do 
    (if 
     (or 
      (not 
       (Array.isArray ast)) 
      (is ast.length 0)) 
     (return ast)) 
    (= h 
     (car ast) t 
     (tail ast) awaitRef 
     (findAwait h "")) 
    (if 
     (? awaitRef) 
     (do 
      (= awaitVal 
       (tget h awaitRef) await 
       (awaitVal.slice 1) variable 
       (+ "_val" 
        (self.getUniq))) 
      (if 
       (is awaitRef) 
       (tset h awaitRef variable) 
       (= h variable)) 
      (t.unshift h) 
      (= nt 
       (replaceAwait t 
        (+ vindex 1))) 
      (await.push 
       (if 
        (is 
         (car awaitVal) "await-cb") 
        (quote 
         (fn 
          (unquote variable) 
          (do 
           (unquote 
            (spread nt))))) 
        (quote 
         (fn err 
          (unquote variable) 
          (do 
           (unquote 
            (spread nt))))))) 
      (list await)) 
     (do 
      (= r 
       (replaceAwait t vindex)) 
      (r.unshift h) r)))) 
  (= result 
   (quote 
    (do 
     (unquote 
      (spread body))))) 
  (def replaceAwaitp item 
   (if 
    (Array.isArray item) 
    (if 
     (is 
      (car item) "awaitp") 
     (quote 
      (await 
       (fn cb 
        (do 
         (unquote 
          (tail item)) 
         (.then 
          (fn res 
           (cb undefined res))) 
         (.catch cb))))) 
     (item.map replaceAwaitp)) item)) 
  (= result 
   (replaceAwaitp result)) 
  (def findIf ast ref 
   (if 
    (Array.isArray ast) 
    (if 
     (and 
      (is ast[0] "if") 
      (findAwait ast "")) ref 
     (ast.reduce 
      (fn result val index 
       (if 
        (is index 0) undefined 
        (elif 
         (? result) result) 
        (findIf val 
         (child ref index)))) undefined)))) 
  (= ifRef 
   (findIf result "")) 
  (while 
   (? ifRef) 
   (do 
    (tset result ifRef 
     (list "await" 
      (aif.apply null 
       (tail 
        (tget result ifRef))))) 
    (= ifRef 
     (findIf result "")))) 
  (= result 
   (replaceAwait result 0)) result))

(e.g. 
 (def body1 callback 
  (callback undefined "body1")) 
 (def cond callback 
  (callback undefined false)) 
 (def cond2 callback 
  (callback undefined true)) 
 (async 
  (prn 
   (if 
    (await cond) 
    (await body1) 
    (elif 
     (and 
      (await cond2) true) "hello") "else"))))

(e.g. 
 (async 
  (await func) 
  (catch err 
   (prn err))))

(e.g. 
 (async 
  (= val 
   (await db.get "key")) 
  (= val2 
   (await db.get "key2")) 
  (prn "hello world" val val2)) 
 (async 
  (jisp.parse 
   (await db.get "once"))) 
 (prn 
  (async 
   (await db.put "newkey" 
    (await db.get "key")))) 
 (async 
  (prn "1") 
  (prn "2" 
   (await db.get "key2")) 
  (prn "3") 
  (if 
   (is 
    (await db.get "key4")) 
   (prn "4") 
   (async 
    (prn "5") 
    (await db.get "key5") 
    (await db.get "key6") 
    (prn "7")))) 
 (test 
  (async 
   (awaitp navigator.mediaDevices.getUserMedia arg)) 
  (async 
   (await 
    (fn cb 
     (do 
      (navigator.mediaDevices.getUserMedia arg) 
      (.then 
       (fn res 
        (cb undefined res))) 
      (.catch cb)))))) 
 (todo 
  (async 
   (try 
    (await db.get "key")))))