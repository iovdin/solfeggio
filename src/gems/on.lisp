(def _on element event callback
  (do 
    (element.addEventListener event callback)
    element))

(mac on element event ...body
  `(_on ,element ,event 
        (fn event 
            (do ,...body))))

(e.g. 
 (div 
  (label "First Name"
         (input))
  (on (button "submit") "click"
      (console.log "submit"))))

 