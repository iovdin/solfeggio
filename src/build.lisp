(= jisp (require 'jisp')
   fs (require 'fs')
   vm (require "vm"))

(def use ...gems
  (gems.reduce
   (fn memo gem
       (memo.concat
        (jisp.parse
         (do (fs.readFileSync (+ "src/gems/" gem ".lisp"))
           (.toString "utf8")))))
   `("do")))

(jisp.importMacros (: use use
                      "e.g." (fn (Array "do"))))

(= defaultPart "public/index.js"
   filename "src/index.clj"
   dstDir "./"
   parts (:)
   parts[defaultPart] (list))

(= code ((fs.readFileSync filename).toString "utf8"))
(= parsed (jisp.parse code))
(prn filename "parsed")
(= parsed (jisp.macroexpand parsed))
(prn "macros expanded")

(def extractFiles expr
 (do
   (if (not (Array.isArray expr))
       return)
   (if (is (car expr) "e.g.")
       return)
   (if (is (car expr) "part")
     (do
       (= _filename (JSON.parse expr[1])
         parts[_filename] (or parts[_filename] (list))
         file parts[_filename])
      (file.push ...(expr.slice 2))
      (expr.splice 0 expr.length))
      (expr.forEach extractFiles))))

(extractFiles parsed)

(= parts[defaultPart] parsed)

(over part key parts
 (do
   (= compiled (jisp.compile part (topScope: no wrap: no))
      data (if (is (key.lastIndexOf ".js") (- key.length 3))
               compiled
               (vm.runInNewContext compiled (: require require))))
   (prn key "built")
   (fs.writeFileSync (+ dstDir "/" key) data)))


;copy css


