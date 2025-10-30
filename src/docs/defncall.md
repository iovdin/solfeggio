## `defncall`: Define, Call, and Keep it Snappy!

Picture this: You're in the zone, writing code at the speed of light, and then BAM! You need to define a function and call it right there and then. In the regular world, you'd have to stop, define the function elsewhere, and then call it. But not in Jisp, oh no. Jisp has your back.
```clojure
(div
  (defncall badge "Email" user.emailVerified
    (span
      (if #1 ; this a second argument user.emailVerified
        (iconCheck)
        (iconCross)) 
        #0)) ; this a first argument 
  (badge "Phone" user.phoneVerified)
  (badge "Address" user.addressVerified)) 
```

Now, let’s peek under the hood and see how this baby is built:
```clojure
(mac defncall name ...args body
 `(do 
    (def ,name 
       ,body) 
    (,name ,...args)))
```

`defncall` is like that friend who can do a backflip and land with a pizza in hand, ready to party. It keeps the momentum going, keeps your code tight, and makes sure you're not flipping back and forth between defining functions and calling them.

Embrace the simplicity, enjoy the speed, and keep on coding!