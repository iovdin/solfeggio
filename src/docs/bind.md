## `bind`: Tying the Knot, the Lisp Way

Let’s talk about `bind`, the macro that binds an input element tighter to a variable than a cat to your favorite armchair. Here’s how you’d whisper sweet nothings to it in Jisp:
```clojure
(= firsName "")
(div 
 (label "First Name"
   (bind (input) firstName))
 (button "submit"))
```

Now, if we were to flirt with Javascript to get the same thing, it’d look something like this:
```javascript
let firstName = "";
div(
  label("First Name",
    input().addEventListener("change", function(event) {
      firstName = event.target.value
    })
  ), 
  button("submit")
)
```
Ah, but wait—there’s a catch! The `addEventListener` is playing hard to get and doesn’t return the input. So, we play smarter.

```javascript
function bind(input) {
  //set initial value
  input.value = firstName; 
  input.addEventListener("change", function() {
    firstName = input.value;
  })
  return input;
}
```

But hold your horses—`firstName` is playing the field, hardcoded in there. We need to up our game and bring in the big guns: abstraction.

```javascript
function bind(input, getter, setter) {
  //set initial value
  input.value = getter(); 
  input.addEventListener("change", function() {
    setter(input.value)
  })
  return input;
}

let firstName = "";
div(
  label("First Name",
    bind(input(), () => firstName, (value) => { firstName = value})
  ), 
  button("submit")
)
```
There we go, smooth as butter.


Jisp: the heartbreaker
```clojure
(def _bind input getter setter
  (do
   (= input (getter))
   (input.addEventListener "change"
     (fn event (setter input.value)))
   (return input)))

(mac bind input variable
  `(_bind ,input 
    (fn ,variable) 
    (fn value (= ,variable value))))

(= firsName "")
(div 
 (label "First Name"
   (bind (input) firstName))
 (button "submit"))
```
Jisp just waltzes in, all suave and sophisticated, and does it in half the time. And just like that, `input` and `variable` are bound together in holy matrimony. Cheers to that!