(def _once condition body
  (interval 10
    (if (is (condition))
      (do (stop)
        (body)))))

(mac once condition ...body
 `(_once (fn ,condition) (fn (do ,...body))))

(e.g.
  ; another way to write it without _once function 
  (mac once condition body
     (interval 10
      (if (is (,condition))
        (do (stop)
          ,...body)))))
(e.g. 
  (once (is document.readyState "complete") 
    (prn "hello world"))
 ;TODO the following syntax 
  (async 
    (await once (is document.readyState "complete"))))