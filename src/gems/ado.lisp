(mac ado ...body
  `(let it ,body[0] 
    (do 
      ,...(do body 
            (.slice 1)
            (.map 
              (fn line
                `(= it ,line))))
      it)))

(e.g.
 (ado 
   (new DataView result 0 (Math.min result.byteLength 131072))
   (do (new TextDecoder "utf-8") 
       (.decode it))
   (parseBuf it)))