(def _binds element getter setter
  (do
    (if (is element.type "checkbox")
        (= element.checked (getter))
        (= element.value (getter)))
   
   (element.addEventListener "change"
     (fn event 
         (setter (if (is element.type "checkbox")
                     element.checked
                     element.value))))
   element))

(mac binds element variable
  `(_binds ,element 
    (fn ,variable) 
    (fn value (l= ,variable value))))

(e.g.
 (= firsName "")
 (div 
  (label "First Name"
    (binds (input) firstName))
  (button "submit")))