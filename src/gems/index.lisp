
(part "public/index.html" 
 (includeSource "src/checkouts/static-html.lisp") 
 (head 
  (meta 
   (: "httpEquiv" "content-type" "content" "text/html; charset=utf-8")) 
  (meta (: "name" "viewport" "content" "width=device-width, initial-scale=1.0, user-scalable=no")) 
  (link (: rel "stylesheet" 
           href "/styles.css" 
           type "text/css")) 
  (script (: src "/index.js" 
             type "text/javascript"))))