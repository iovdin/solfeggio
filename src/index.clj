(use interval prnv once html on async tap bind lvars binds)

(= allNotes `()
   octaveNotes ("C C# D D# E F F# G G# A A# B".split " "))
(for octave (range 1 8)
     (for note octaveNotes
          (allNotes.push (+ note octave))))

(def randint min max 
  (+ min 
     (Math.floor 
      (* (Math.random) 
         (+ 0.99 (- max min))))))

(def randChoice array exception
  (let target 
    (if (? exception)
      (array.filter (fn item (isnt item exception)))
      array)
    (get target (randint 0 (- target.length 1)))))

; returns score of how happy/sad the interval is also return level of dissonance
; direction of play is "up", "at once" and "down"

; Interval mappings for
; dissonance    0 1 2 3 4 5 6 7 8 9 10 11
(= dissonance `(0 6 5 3 3 2 4 1 3 3 5  6)
; sad /happy  0 1 2 3 4 5 6 7 8 9 10 11
   sadhappy `(0 4 4 4 3 2 4 1 3 4 4  4)
; octave adds to sadness/happiness
; the higher ocatve the more sadness the lower octave the more happier
;           1 2 3 4 5 6 7
   oct2sh `(0 1.5 1 0 0 -1 -1.5)
; octave adds to dissonance
; the further it is from the center the more dissonance
;            1 2 3 4 5 6   7
   oct2dis `(2 1 0 0 0 0.5 0.5))

(lvar octaves (: 1 yes 2 yes 3 yes 4 yes 5 yes 6 yes 7 yes)
      directions (: down yes once yes up yes)
      intervals (: 1 yes 2 yes 3 yes 4 yes 5 yes 6 yes 7 yes 8 yes 9 yes 10 yes 11 yes 12)
      notes (do octaveNotes 
              (.reduce 
               (fn memo note
                 (do
                   (= memo[note] yes)
                   memo))
               (:)))
      halfTones yes
      sayIt yes
      showIt yes
      inversion no
      ttw 3)

(def score note1 note2 direction
  (let* interval  (- (allNotes.indexOf note2) (allNotes.indexOf note1))
        octave (parseInt (last note1))
        baseInterval (% interval 12)
        sInterval (if (> baseInterval 6)
                    (- 12 baseInterval))
        (Array 
         dissonance[baseInterval])))
        
(= intervalNames `("unisono.mp3" "seconda-minore.mp3" "seconda-maggiore.mp3" "terza-minore.mp3" "terza-maggiore.mp3" "quarta-giusta.mp3" "tritono.mp3" "quinta-giusta.mp3" "sesta-minore.mp3" "sesta-maggiore.mp3" "settima-minore.mp3" "settima-maggiore.mp3" "ottava.mp3"))

(= samples 
   (do "A7 A1 A2 A3 A4 A5 A6 A#7 A#1 A#2 A#3 A#4 A#5 A#6 B7 B1 B2 B3 B4 B5 B6 C7 C1 C2 C3 C4 C5 C6 C7 C#7 C#1 C#2 C#3 C#4 C#5 C#6 D7 D1 D2 D3 D4 D5 D6 D#7 D#1 D#2 D#3 D#4 D#5 D#6 E7 E1 E2 E3 E4 E5 E6 F7 F1 F2 F3 F4 F5 F6 F#7 F#1 F#2 F#3 F#4 F#5 F#6 G7 G1 G2 G3 G4 G5 G6 G#7 G#1 G#2 G#3 G#4 G#5 G#6"
     (.split " ")
     (.reduce
       (fn memo note
           (do
             (= memo[note] (+ (note.replace "#" "s") ".mp3"))
             memo))
      (:))))

(= audio (new Audio))
(def play url callback
  (do
    (= audio.src url)
    (audio.play)
    (def onEnd
      (do (if (isa callback "function")
            (callback))
        (audio.removeEventListener "ended" onEnd)) )
    (audio.addEventListener "ended" onEnd)))

(def delay ms callback
  (setTimeout callback ms))

(= sampler (do (new Tone.Sampler 
                  (: urls samples 
                     baseUrl "/piano/"))
               (.toDestination))
   playing false
   prev undefined)

(def active obj
  (over value key obj (if value key)))


(def noteIn note interval
  (get allNotes (+ (allNotes.indexOf note) (parseInt interval))))

(def playRound callback
  (async
   (= random (: note (not prev)
                interval (not prev)
                octave (not prev)
                direction (not prev)))
   
   (if prev
     (= randomProp  (randChoice 
                     (do `("note" "interval" "octave" "direction")
                       (.filter (fn t (> (active window[(+ t "s")]).length 1)))))
        random[randomProp] yes))

   
   
   (def choose name
     (let avail (active (get window (+ name "s")))
       (if (or (and random[name] (> avail.length 1)) 
               (not prev) (not prev[name]))
         (randChoice avail (if (? prev) prev[name]))
         prev[name])))
   
   (= interval (choose "interval")
      octave (choose "octave")
      note (choose "note")
      direction (choose "direction")
      note1 (+ note octave)
      note2 (noteIn note1 interval)
      now (Tone.now)
      prev (: interval interval octave octave direction direction note note))

   (if showIt
     (renderTo "#note" interval " " note1 " " note2))
   
   (= order 
      (switch direction
        (case "once" `(0 0))
        (case "up" (do (list (Math.random) (Math.random))
                     (.sort)))
        (case "down" (do (list (Math.random) (Math.random))
                       (.sort)
                       (.reverse))))) 
   
   (prn "play round" note1 note2 interval direction)
   (sampler.triggerAttack note1 (+ now order[0]))
   (sampler.triggerAttack note2 (+ now order[1])) 
   (sampler.triggerRelease (list note1 note2) (+ now 1.5))
   (await delay (* 1000 ttw))
   
   (if (not playing)
     return)
   (if sayIt
     (await play (+ "/numbers/" 
                    (if halfTones 
                      (+ interval ".mp3")
                      intervalNames[interval]))))
   (callback)))

(once (and (is document.readyState "complete") sampler.loaded)
  (renderTo "body"
    (h1 (id: "note"))
    (div "pause for "
         (binds (input (: type "number" min 1 max 10)) ttw)
         " seconds") 
    (div "half-tones" (binds (input (type: "checkbox")) halfTones))
    (div "say it" (binds (input (type: "checkbox")) sayIt))
    (div "show it" (binds (input (type: "checkbox")) showIt))
    (div "intervals:" 
         (do (range 1 13)
           (.map 
            (fn interval
              (span " " interval
                    (binds (input (type: "checkbox")) intervals[interval])
                    " ")))))
            
    (div "notes:" 
         (do octaveNotes
           (.map 
            (fn note
              (span " " note
                    (binds (input (type: "checkbox")) notes[note])
                    " ")))))
    (div "octaves:" 
         (do (range 1 7)
           (.map 
            (fn octave
              (span " " octave
                    (binds (input (type: "checkbox")) octaves[octave])
                    " ")))))
    (div "inversion: " (binds (input (type: "checkbox")) inversion))
            
    (div "order: "
         "up " (binds (input (type: "checkbox")) directions.up) " "
         "at once " (binds (input (type: "checkbox")) directions.once) " "
         "down " (binds (input (type: "checkbox")) directions.down)) " "
    
    (tap (button "start")
       (on it "click"
         (def playNextCallback 
           (if playing
             (playRound playNextCallback)))
         (= playing (not playing))
         (if playing
           (playRound playNextCallback))
         (renderTo it
            (if playing "stop" "start"))))))


(part "public/index.html" 
  (use static-html)
  (head 
    (meta (: "httpEquiv" "content-type" "content" "text/html; charset=utf-8")) 
    (meta (: "name" "viewport" "content" "width=device-width, initial-scale=1.0, user-scalable=no"))
    (script (src: "https://unpkg.com/tone"))
    (script (src: "index.js"))
    (link (: rel "stylesheet" 
             href "style.css" 
             type "text/css")))
  (body "loading..."))

(part "server.js"
  (= express (require "express")
     app (express))
  (app.use (express.static "public"))
  (app.listen 8080))