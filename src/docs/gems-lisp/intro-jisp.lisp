(h1 "The Jisp-troduction")

(img (src:"/img/pile_of_parentheses.png" alt:"A stick figure standing next to a huge pile of parentheses."))

(p "variables:")
(row
  (code "javascript"
    "a = 1;
    b = \"hello world\";
    c = true")
  (code "lisp"
    "(= a 1
       b \"hello world\"
       c true)"))

(p "math:")
(row
  (code "javascript"
    "1 + 2 + 3;")
  (code "lisp"
    "(+ 1 2 3)"))

(p "functions:")
(row 
  (code "javascript"
    "function hello(name){
      console.log(`hello ${name}`)
    }
    hello(\"world\")")
  (code "lisp"
    "(def hello name
      (console.log (+ \"hello \" name)))
    
    (hello \"world\")"))
    
(p "functions:")
(row 
  (code "javascript"      
    "if (a === 1) {
      console.log(\"a is 1\")
    } else {
      console.log(\"a is not 1\")
    }")    
  (code "lisp"
    "(if (=== a 1)
      (console.log \"a is 1\")
      (console.log \"a is not 1\"))"))
  
(p "some server code:")
(row 
  (code "javascript"
    "var express = require(\"express\");
    app = express();
    app.listen(8080);"))

  (code "javascript"
    "(= express (require \"express\")
       app (express))
    
    (app.listen 8080)"))
