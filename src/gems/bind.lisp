(def _bind element getter setter
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

(mac bind element variable
  `(_bind ,element 
    (fn ,variable) 
    (fn value 
       (= ,variable value) )))

(e.g.
 (= firsName "")
 (div 
  (label "First Name"
    (bind (input) firstName))
  (button "submit")))