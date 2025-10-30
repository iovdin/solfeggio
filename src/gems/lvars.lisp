
(def _lget name value
  (let res (try (JSON.parse (localStorage.getItem name)))
       (if (and (or (is res null) (?! res))
                (? value))
           (JSON.parse (JSON.stringify value)) 
           (elif (and (isnt res null) (? res))
              res))))

(mac lvar ...args
  (args.reduce
    (fn memo item index
        (if (% index 2)
            memo
            (let varname item
                 value (get args (+ index 1))
               (memo.concat
                (if value
                    `(,varname (_lget ``,varname ,value))
                    `(,varname (_lget ``,varname)))))))
      `(=)))

  ;TODO multiple lset
(def _lset name value
  (localStorage.setItem name (JSON.stringify value)))

(mac l= ...args
  (args.reduce
    (fn memo item index
        (if (% index 2)
            memo
            (let varname item 
                 savename (car (item.split /\.|\[/))
                 value (get args (+ index 1))
               (memo.concat
                `((= ,varname ,value) 
                  (_lset ``,savename ,savename))))))
      `(do)))
