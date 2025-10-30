## `prnv`: A Debugging Marvel

Ever found yourself knee-deep in code, scratching your head at some bizarre output, while reaching for your debugging lifeline, `console.log`?

```javascript 
console.log("vname", vname);
```
But, what if we could streamline this process to something even more straightforward, such as:

```clojure 
(prnv vname) 
```
Enter the realm of macros, the special forces of the coding world, operating at compile time. In simpler terms, they take your code, perform some backstage magic, and voila, you’ve got transformed code.

Did you know? In the world of Jisp, your code gets to live its best life as arrays within arrays of JavaScript. For instance,
```clojure
(console.log "vname" vname)
```
transforms into:

```javascript
["console.log", "\"vname\"", "vname"]
```

With this array-nesting game strong, our Jisp macro flexes its muscles, taking an array and molding it into something new.
  
```javascript
function prnv(vname) {
  return ["console.log", '"' + vname + '"', vname];
}
```
But in Jisp, it's all about style:

```clojure
(mac prnv vname
  (Array "console.log" (+ '"' vname '"') vname))
```

Fancy a cleaner look? Embrace the template-style for your macro:

```clojure
(mac prnv vname
  `(console.log ,(+ '"' vname '"') ,vname))
``` 
Note: This templating mojo works wonders for arrays of arrays in Jisp.

For the JavaScript purists out there:
```javascript
function prnv(vname) {
  // code is shown as a string
  // for the sake of clarity.
  return `console.log("${vname}", ${vname})`; 
}
```
And there you have it, a nifty macro to sprinkle some style and efficiency on your debugging adventures.

