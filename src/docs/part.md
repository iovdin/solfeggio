## `part`: Juggling Code Like a Circus Act

So, what have we cooked up so far in this chaotic kitchen of code?
```clojure
(once (is document.readyState "complete")
  (= firstName "")
  (document.body.appendChild
    (div 
     (label "First name"
       (bind (input) firstName))
     (on (button "Save") "click"
       (prnv firstName))))) 

```
Look at that beauty! It's like watching a cat trying to type, but somehow it works.

Now, what's the next item on the agenda? Ah yes, saving the first name to a database or...something. You know, the usual shenanigans.
```clojure
(= express (require "express")
   app (express))
   
(app.listen 8080)
```
And there we have it, a web server that's probably questioning its life choices right about now.


But wait, there’s more! I know this is going to sound as crazy as a cat on a skateboard, but I want to mix client and server code in the same file. Yeah, you heard that right.
```clojure
; by default this should go to index.js for browser
(= firstName "")
(div 
 (label "First name"
   (bind (input) firstName))
 (on (button "Save") "click"
   (prnv firstName)))

; and now, for my next trick, 
; the following content will compile to server.js
(part "server.js"
  (= express (require "express")
     app (express))
     
  (app.listen 8080))
```
Now, before you throw tomatoes at me, hear me out. This circus act couldn’t be done with a macro. We need to mess with Jisp’s compilation procedure like a kid in a candy store.
```clojure
(= parts (:)
   defaultPart "index.js"
   parts[defaultPart] (Array))
   
(def extractParts expr
  (do
    (if (not (Array.isArray expr))
      return)
    (if (=== expr[0] "part")
      (do
        (= partName ,expr[1]
          parts[partName] (or parts[partName] (Array)))
        ; shove it into parts like a clown ca
        (parts[partName].push ...(expr.slice 2)) 
        ; yeet it from the default part
        (expr.splice 0 expr.length)
        ; and on to the next one
        (expr.forEach extractFiles)))))
    
(extractParts parsed)

```
And just like that, we’re compiling like madmen. Client code, server code, it’s all here in one chaotic, but strangely satisfying, mess. Welcome to the circus, my friends.