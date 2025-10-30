## `once`: Because Patience is So Last Century

Who has time to wait for conditions to be met? Not us, that's for sure. Here's what we want to do:
```clojure
(once (=== document.readyState "complete") 
  (console.log "now we can render html"))
```
You know, just casually checking if the document is ready and then BAM, "Let's paint the town red... or at least this HTML page!"

But how do we get there? Well, Javascript likes to play hard to get:
```javascript
interval = setInterval(function() {
  if (document.readyState === "complete") {
    clearInterval(interval)
    console.log("now we can render html")
  }
}, 10)
```
It's like watching paint dry, but with more code.



But wait, we’re not cavemen! We can make a function:
```javascript
function once(condition, body) {
  const interval = setInterval(function() {
    if (!!condition()) {
      clearInterval(interval)
      body()
    }
  }, 10)
}

once(() => (document.readyState === "complete"), 
     () => { console.log("now we can render html") })
```
"Hey document, you ready yet? How about now? Now?"

But we're Jisp users, we live life on the edge:
```clojure
(def _once condition body
  (do
    (= interval (setInterval
                  (fn 
                    (if (is (condition))
                      (do 
                        (clearInterval interval)
                        (body)))) 10)))) 
(mac once condition body
 `(_once (fn ,condition) (fn ,body)))

(once (=== document.readyState "complete") 
  (console.log "now we can render html"))
```
Bam! Who knew waiting for conditions could be so cool? Now go, render that HTML like the cool developer you are!

