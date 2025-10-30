## `ado`: few ways to chain


Here is the way to chain in javascript:
```javascript
classNames
  .trim()
  .split(/\s+/)
  .map(className => 
    console.log(className))
```

In jisp:
```clojure
(do classNames
  (.trim)
  (.split /\s+/)
  (.map 
    (fn className 
      (console.log className))))
```

Yes `do` does both chaining and run in sequence and return last

This way of chaining fails if returning result does not have a method you need to call.
Yet the process still fills like pipeline or chaining 

```clojure
; every line's result is saved into `it` variable
; and `it` is available in the next line
(ado 
  (new DataView result 0 (Math.min result.byteLength 131072))
  (do (new TextDecoder "utf-8") 
      (.decode it))
  (parseBuf it))
```

Lets try to code it first the way it could work:
```clojure
(do 
  (= it (new DataView result 0 (Math.min result.byteLength 131072)))
  (= it (do (new TextDecoder "utf-8") 
          (.decode it)))
  (= it (parseBuf it))
  it)
```

Lets scope the `it` variable so it does not interfere with any upper scope variable
we'll use `let` for it:

```clojure
(let it (new DataView result 0 (Math.min result.byteLength 131072))
  (do 
    (= it (do (new TextDecoder "utf-8") 
            (.decode it)))
    (= it (parseBuf it))
    it))
```

Now we're ready to write a macro
```clojure
(mac ado ...body
  `(let it ,body[0] 
    (do 
      ,...(do body 
            (.slice 1)
            (.map 
              (fn line
                `(= it ,line))))
      it)))
```