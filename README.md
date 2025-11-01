# Musical Interval Training App

A web-based musical ear training application that plays random musical intervals to help users develop their interval recognition skills. Built with a Lisp-to-JavaScript transpiler and the Tone.js audio library.

## 🎵 [Try it now!](https://solfeggio.8try.com)

**Live Demo**: https://solfeggio.8try.com

## Features

- 🎵 Plays two notes sequentially to create a musical interval
- 🎹 Uses high-quality piano samples from the Casio library
- 🔢 Displays the notes played and the interval size
- 🎲 Randomly selects intervals for training
- 🌐 Simple web interface with a single button to start

## How It Works

The application:
1. Generates a pool of notes from octaves 4-5 (C4 through B5)
2. When the "start" button is clicked, randomly selects two notes separated by a musical interval
3. Plays the first note, then the second note one second later using Tone.js
4. Displays the notes and interval size on the screen

## Technical Stack

- **Language**: Lisp (transpiled to JavaScript)
- **Audio Library**: [Tone.js](https://tonejs.github.io/) - Web Audio framework
- **Server**: Express.js
- **Samples**: Casio piano samples from the Tone.js audio library

## Project Structure

```
.
├── src/
│   └── index.lisp         # Main application source code (Lisp)
├── public/
│   ├── index.html         # Generated HTML file
│   ├── index.js           # Generated JavaScript
│   └── style.css          # Styles
└── server.js              # Express server
```

## Setup and Installation

1. **Install dependencies**:
   ```bash
   npm install express tone
   ```

2. **Compile the Lisp source** (requires a Lisp-to-JS transpiler):
   ```bash
   # The transpilation process depends on your Lisp environment
   # This should generate public/index.html and index.js
   ```

3. **Start the server**:
   ```bash
   node server.js
   ```

4. **Open your browser**:
   Navigate to `http://localhost:8080`

## Usage

1. Click the **"start"** button
2. Listen to the two notes played in sequence
3. The interval size and note names will be displayed
4. Try to identify the interval by ear
5. Click "start" again to practice with a new interval

## Code Highlights

### Note Generation
The app generates all chromatic notes (including sharps) across specified octaves:
```lisp
(for octave (range 4 5)
     (for note ("C C# D D# E F F# G G# A A# B".split " ")
          (notes.push (+ note octave))))
```

### Sample Loading
Maps note names to audio file names (converting # to 's' for filenames):
```lisp
(= samples 
   (do "A7 A1 A2 A3 A4 A5 A6 A#7..."
     (.split " ")
     (.reduce
       (fn memo note
           (do
             (= memo[note] (+ (note.replace "#" "s")))
             memo))
      (:))))
```

### Audio Playback
Uses Tone.js for precise timing and audio sample triggering:
```lisp
(sampler.triggerAttack note1)
(sampler.triggerAttack note2 (+ now 1)) 
(sampler.triggerRelease (list note1 note2) (+ now 2))
```

## Customization

You can modify the following parameters in `src/index.lisp`:

- **Interval range**: Change the `interval` calculation to practice different interval sizes
- **Octave range**: Modify the `range 4 5` to include more or fewer octaves
- **Timing**: Adjust the delay between notes (currently 1 second)
- **Port**: Change `8080` in the server configuration

## Future Enhancements

Potential improvements could include:
- [ ] User input for interval identification
- [ ] Score tracking and statistics
- [ ] Difficulty levels (ascending/descending, harmonic intervals)
- [ ] Configurable interval range selection
- [ ] Visual piano keyboard display
- [ ] Multiple instrument sounds

## License

MIT License (or specify your preferred license)

## Acknowledgments

- Audio samples courtesy of [Tone.js](https://tonejs.github.io/)
- Built with Lisp and love for music education