## `tap`: The Unsung Hero of Inline Magic

So, you've noticed a bit of a recurring theme with on and bind, right? These two macros have a quirky habit; they love to work inline, but they also love to hog the spotlight and leave you hanging without returning the DOM element they've been flirting with. Enter tap, our macro knight in shining parentheses, ready to abstract all that mess away and keep the inline party going.

How `tap` wants to tango:
```clojure
(= firstName "")
(div 
  (div 
    (label "First Name")
    (tap (input)
      (= it.value firstName)
      (it.addEventListener "change"
        (fn event
          (= firstName it.value))))) 
  (div 
    (tap (button "submit") 
      (it.addEventListener "click"
        (fn (console.log "do submit"))))))
```
Look at that! `tap` just waltzed in, did its thing, and left, all while returning the DOM element. Smooth.

If we were to translate this gracefulness to JavaScript, it’d look a bit like this:
```javascript
function tap(element, callback) {
  callback(element);
  return element
}
```
Elegant, isn't it? It's like JavaScript finally learned how to dance.

But we’re not here to dance with JavaScript, we’re here for Jisp. And in Jisp, `tap` gets even smoother:
```clojure
(def _tap element callback
  (do (callback element)
    element)) 
    
(mac tap element ...body
  `(_tap ,element 
    (fn it 
      (do ,...body))))
```
Notice that? `...body` means `tap` can take a whole dance troupe of expressions. And when you've got multiple moves to bust out in sequence, just wrap them up with `do`.

So there you have it, `tap` in all its glory, turning complicated dance routines into a graceful ballet of code. Bravo!