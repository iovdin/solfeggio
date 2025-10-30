## `dos`  inline version of defs

Is it possible to save firstName without having a function defined?

```clojure
(= firstName "")
(div 
 (label "First Name"
   (bind (input) firstName))
 (on (button "submit") "click"
   (dos firstName
     ; this is executed on server side
     ((db.collection "user").updateOne 
      (_id: req.session.user._id)
      ($set: (firstName: #0)))))
```


