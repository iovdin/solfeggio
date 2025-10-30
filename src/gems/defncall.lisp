(mac defncall name ...args body
  `(do (def ,name ,body) 
     (,name ,...args)))