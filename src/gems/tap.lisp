(def _tap element callback
  (do (callback element)
    element)) 

(mac tap element ...body
  `(_tap ,element 
     (fn it 
       (do ,...body))))

(e.g.
 (= firsName "")
 (div 
  (label "First Name"
    (bind (input) firstName))
  (button "submit")))