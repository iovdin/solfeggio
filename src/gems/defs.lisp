(part "server.js"
  (def _defs name getParams doBody
    (app.post (+ "/api/" name)
      (fn req res 
        (do 
          (doBody ...(getParams req.body))
          (res.send (value: "ok")))))))

(mac defs name ...args body
  `(do
    ; client side function definition
    (def ,name ,...args
        (axios.post ,(+ "\"" "/api/" name "\"") 
          ,(args.reduce 
             (fn memo arg
               (memo.concat `(,arg ,arg)))
             (Array ":"))))
    ; server side
    (part "server.js"
      (_defs ``,name 
        (fn params
          (Array ,...(for arg args 
                       (+ "params." arg))))
        (fn ,...args
          ,body)))))