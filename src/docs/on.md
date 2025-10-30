## `on`: Jisp’s Answer to Event Handling (and Life’s Boredom)


Let’s talk about `on`, the macro in Jisp that has the power to turn event handling from a chore into... well, a slightly less annoying chore.

Here’s how we party in jisp
```clojure
(div 
 (label "First Name"
   (input))
 (on (button "submit") "click"
   (console.log "submit")))
```
Look at that! It's like we've put the event listener on a diet. No more bloated code, just pure, unadulterated event handling bliss.


Meanwhile, in the javascript jungle
```javascript
div(
  label("First Name", input()),
  button("submit").addEventListener("click", function(event) {
    console.log("submit")
  })
)
```
Here we are, drowning in a sea of parentheses and callbacks. It's like JavaScript wants us to suffer.

Oh, did I mention? `addEventListener` has the social skills of a rock. It just does its thing and returns `undefined`. Thanks a lot, buddy. We still need to render the button, you know!

```javascript
function on(button, event, callback) {
  button.addEventListener(event, callback)
  return button;
}

div(
  label("First Name", input()),
  on(button("submit"), "click", function(event) {
    console.log("submit")
  }))
```

The Jisp Wizardry to the Rescue
```clojure
(def _on button event callback
  (do 
    (button.addEventListener event callback)
    (return button)))

(mac on button event body
  `(_on ,button ,event (fn event ,body)))
``` 
And just like that, we've transformed a tedious task into a one-liner masterpiece. The `on` macro: because life’s too short for boring code.

In the magical world of Jisp, event handling is not a necessary evil; it’s an art form. And with the `on` macro, we’ve just painted our masterpiece. Take that, JavaScript.