## The Jisp-troduction: For the Love of Parentheses

![A stick figure standing next to a huge pile of parentheses.](/img/pile_of_parentheses.png)

Alright, let's dive into this quirky world of Jisp. If you're scratching your head thinking "What the hell is Jisp?" and desperately need a guide, check [this out](https://mitranim.com/jisp/). But for now, stick with me; I'll give you the lowdown.

### Variables: Just like Javascript, but Drunk
Javascript, our old pal:
```javascript
a = 1;
b = "hello world";
c = true;
```
Jisp, after a few beers:
```clojure
(= a 1
   b "hello world"
   c true)
```
Notice anything different? Yeah, the equals sign got a promotion.

### Objects: Like Building with Lego, But They’re All Square
Javascript, playing it cool:
```javascript
{ 
  a: 1,
  b: "hello world",
  c: true 
}
```
Jisp, the abstract artist:
```clojure
(: a 1
   b "hello world"
   c true)
```
Objects in Jisp are basically a stylish way to say, "Look, I can use colons too!"

### Math: Because Numbers Need Love as Well
Javascript, your high school math teacher:
```javascript
1 + 2 + 3;
(1 + 2) * 3
```
Jisp, your drunk uncle at a party:
```clojure
(+ 1 2 3)
(* (+ 1 2) 3)
```
Yeah, it’s ugly. But so is math. We deal with it.

### Functions: Where the Magic Happens
Javascript, being all formal:
```javascript
function hello(name){
  console.log(`hello ${name}`)
}
hello("world")
```
Jisp, at a casual Friday:
```clojure
(def hello name
  (console.log (+ "hello " name)))
  
(hello "world")  
```
No ‘function’ keyword, because who has time for that?


### Conditionals: Making Decisions, Lisp Style
Javascript, the decision maker:
```javascript 
if (a === 1) {
  console.log("a is 1")
} else {
  console.log("a is not 1")
}
```

Jisp, the cool uncle:
```clojure
(if (=== a 1)
  (console.log "a is 1")
  (console.log "a is not 1"))
```
A bit more symmetrical, don't you think?


### Server Code: Because We’re Serious Developers

Javascript, the old reliable:
```javascript
var express = require("express");
app = express();
app.listen(8080);
```

Jisp, the hipster:
```clojure
(= express (require "express")
   app (express))
   
(app.listen 8080)
```

Yes, Jisp can do server stuff too. Take that, Javascript.

And there you have it, a crash course in Jisp, served with a side of sarcasm. Enjoy the parentheses, my friends, and may your code be ever quirky.