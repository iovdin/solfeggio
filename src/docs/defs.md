## `defs`: Bridging the Server-Client Chasm

Ever felt like the back-and-forth between client and server is a bit, well, tedious? Every time you need something from the server, it's the same old song and dance: Create an API endpoint on the backend, call it from the frontend. Rinse and repeat. But what if we could cut the middleman and just... talk directly? Enter `defs`, where we write a function in the frontend, and its body gets executed in the backend, no questions asked.
```clojure
(defs save firstName
  (= db["firstName"] firstName))
    
(= firsName "")
(div 
 (label "First Name"
   (bind (input) firstName))
 (on (button "submit") "click"
   (save firstName))
   
```
### The Client Side: A Javascript Ballet
Here's how this might play out in the browser's javascript:

```javascript
let firstName = "";
div(
  label("First Name",
    bind(input(), 
         // getter
         () => firstName,
         // setter
         (value) => { firstName = value})
  ), 
  on(button("submit"), "click", function(event) {
    save(firstName);
  }))

function save(firstName) {
    axios.post("/api/save", { firstName })
}
```

Now, back to our `defs` macro. If it's dealing with a single argument, it's relatively straightforward:
```clojure
(mac defs name arg body
 `(def ,name ,arg
      ; With ``,name we are grabbing the actual value of 'name', 
      ; which is 'save' in this case. 
      ; By wrapping it with double quotes, we transform 'save' 
      ; into a string, resulting in "\"save\"".
      (axios.post (+ "/api/" ``,name) 
        (: ,arg ,arg))))
```
And hey, you might be wondering, "Where’s the `body` in all this?" Well, we left it out on purpose! It’s meant for the server side, not here. We’re not running a charity for code lines; they’ve got to be in the right place to party!

But life's never that simple, is it? What if we want to pass multiple arguments? Well, that's where things get spicy.
```clojure
(mac defs name ...args body
 `(def ,name ,...args
      (axios.post (+ "/api/" ``,name) 
        (: ,...(for arg args
                  `(,arg ,arg)))))))
```

This little gem will transform into:
```clojure
(def save firstName lastName
   (axios.post (+ "/api" "save"))
     ; Alright, we need to kick out these parentheses, 
     ; they're ruining the party. 
     ; We're building an object here, 
     ; not hosting a reunion for brackets!
     (: (firstName firstName) 
        (lastName lastName)))
```
We're going to flatten this array of object arguments:
```clojure
(mac defs name ...args body
  `(def ,name ,...args
    (axios.post (+ "/api/" ``,name) 
      ,(args.reduce 
         (fn memo arg
           (memo.concat `(,arg ,arg)))
         (Array ":")))))
```

### The Server Side: Javascript in a Suit
Here's the traditional way to handle it in server-side javascript:
```javascript
app.post("/save", async (req, res) => {
  // auth checking is out of the scope for brievety
  const { firstName } = req.body;
  db["firstName"] = firstName
  res.send({value: 'ok'})
})
```
But we're all about abstraction here. So let's make it fancy:
```javascript
// server
function defs(name, getParams, doBody){
  app.post(`/api/${name}`, (req, res) => {
    const args = getParams(req.body);
    doBody(...args)
    res.send({value: "ok"})
  })
}
defs("save", 
     (reqBody) => [reqBody.firstName], 
     (firstName) => {
       db["firstName"] = firstName
     })
```

And now, for the grand finale, the macro for the server side:
```clojure
(def _defs name getParams doBody
  (app.post (+ "/api/" name)
    (fn req res 
      (do 
        (doBody ...(getParams))
        (res.send (value: "ok"))))))
          
(mac defs name ...args body
   `(_defs ``,name 
      (fn params
        (Array ,...(for arg args 
                      (+ "params." arg))))
      (fn ,...args
        ,body)))
```

But why stop there? Leveraging our previously crafted `part` macro, let's amalgamate all of these functionalities into a single, glorious macro:
```clojure
(part "server.js"
  (def _defs name getParams doBody
    (app.post (+ "/api/" name)
      (fn req res 
        (do 
          (doBody ...(getParams req.body))
          (res.send (value: "ok")))))))

(mac defs name ...args body
  `(do
    ; client side function definition
    (def ,name ,...args
      (axios.post (+ "/api/" ``,name) 
        ,(args.reduce 
           (fn memo arg
             (memo.concat `(,arg ,arg)))
           (Array ":"))))
    ; server side
    (part "server.js"
      (_defs ``,name 
        (fn params
          (Array ,...(for arg args 
                        (+ "params." arg))))
        (fn ,...args
          ,body)))))
```

And there you have it, `defs`: the magic wand that turns tedious back-and-forths into a seamless dance between frontend and backend. Enjoy the show!