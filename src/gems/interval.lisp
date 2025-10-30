(mac interval timeout ...body
     (let intVar (+ "interval" (this.gensym))
          `(= ,intVar 
             (setInterval 
              (fn stop (do ,...body))
              ,timeout
              (fn (clearInterval ,intVar))))))
(e.g.
 (interval 10
    (if condition
      (stop))))