(def _reactive props render
  (let curProps (props)
       curNode (render)
       newNode null
       newProps null
       interval null
       hasChanged false
    (do
      (interval 10
        (if (not (document.contains curNode))
            (return (stop)))
        (= newProps (try (props) 
                     (catch e
                        (do
                          (stop)
                          (throw e))))
           hasChanged (newProps.some
                       (fn prop index
                           (isnt prop (get curProps index)))))
        (if (not hasChanged)
            return)
       (= curProps newProps
          newNode (render))
       (curNode.parentNode.insertBefore newNode curNode)
       (curNode.parentNode.removeChild curNode)
       (= curNode newNode))
      curNode)))

(mac reactive ...props body
     `(_reactive 
       (fn (list ,...props)) 
       (fn ,body)))