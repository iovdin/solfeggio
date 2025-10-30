(use interval prnv once html on)

(= notes `())
(for octave (range 4 5)
     (for note ("C C# D D# E F F# G G# A A# B".split " ")
          (notes.push (+ note octave))))

(def randint from to
  (+ from 
     (Math.round 
      (* (Math.random) 
         (- to from)))))

(= samples 
   (do "A7 A1 A2 A3 A4 A5 A6 A#7 A#1 A#2 A#3 A#4 A#5 A#6 B7 B1 B2 B3 B4 B5 B6 C7 C1 C2 C3 C4 C5 C6 C7 C#7 C#1 C#2 C#3 C#4 C#5 C#6 D7 D1 D2 D3 D4 D5 D6 D#7 D#1 D#2 D#3 D#4 D#5 D#6 E7 E1 E2 E3 E4 E5 E6 F7 F1 F2 F3 F4 F5 F6 F#7 F#1 F#2 F#3 F#4 F#5 F#6 G7 G1 G2 G3 G4 G5 G6 G#7 G#1 G#2 G#3 G#4 G#5 G#6"
     (.split " ")
     (.reduce
       (fn memo note
           (do
             (= memo[note] (+ (note.replace "#" "s")))
             memo))
      (:))))
(prnv samples)

(once (is document.readyState "complete")
  (= sampler (do (new Tone.Sampler 
                  (: urls (A1: "A1.mp3" A2: "A2.mp3")
                     baseUrl "https://tonejs.github.io/audio/casio/"))
               (.toDestination)))
  (renderTo "body"
    (div (id: "note"))
    (on (button "start") "click"
        (= interval 2 ;(randint 1 12) 
           start (randint 0 (- notes.length interval 1))
           note1 notes[start] 
           note2 notes[(+ start interval)]
           synth (do (new Tone.PolySynth)
                    (.toDestination))
            now (Tone.now))
        (sampler.triggerAttack note1)
        (sampler.triggerAttack note2 (+ now 1)) 
        (sampler.triggerRelease (list note1 note2) (+ now 2))
        (renderTo "#note" note1 " " note2 " " interval)
        )))


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
  (body))

(part "server.js"
  (= express (require "express")
     app (express))
  (app.use (express.static "public"))
  (app.listen 8080))