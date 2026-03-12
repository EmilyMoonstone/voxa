# Features

## Product Scope

Voxa is a voice training app focused on structured, affirming practice for trans* users. The initial product focuses on pitch-oriented voice training, session analysis and progress tracking.

## MVP Features

### 1. Goal Setting Mode
Users can define the target range they want to practice against.

Includes:
- set a target pitch range manually in Hz
- choose a preset voice type:
  - Feminine
  - Masculine
  - Androgynous
- auto-detect current pitch range from a short voice sample
- save or update target range

### 2. Practice Mode
Users receive live visual feedback while speaking.

Includes:
- real-time pitch detection from microphone input
- large color-coded gauge:
  - too low
  - in range
  - too high
- current pitch value in Hz
- running statistic for percentage of time in target range
- contextual tips during practice

### 3. Record & Analyse Mode
Users can record structured practice sessions and inspect results.

Includes:
- record a voice sample
- optional predefined practice texts for reading aloud
- optional live feedback during recording
- post-recording analysis:
  - average pitch
  - minimum pitch
  - maximum pitch
  - percentage / duration in target range
- playback recorded audio
- save session locally

### 4. History
Users can review and compare past sessions.

Includes:
- list of past sessions
- expand a session for details
- chart for pitch curve over time
- select two sessions for side-by-side comparison
- delete sessions

### 5. Settings
Includes:
- switch language between German and English
- reset saved data
- analysis preferences and future audio settings

## Feature Requirements by System Area

### Audio / Pitch
- low-latency microphone input
- reliable pitch extraction for spoken voice
- smoothing suitable for live visualization
- handling of unvoiced segments

### Analysis
- calculate average, min, max and time-in-range
- persist summary and curve data
- support visual comparison between sessions

### UX
- clear explanations for presets and pitch ranges
- non-judgmental tips
- visible confidence and progress cues

## Future Features

### Resonance Training
- chest vs head resonance exercises
- resonance cues and guided practice

### Intonation Patterns
- melodic speech practice
- variation and natural speech contour exercises

### Sustained Note Training
- hold a pitch steadily over time
- stability scoring

### Daily Check-In
- short daily measurement
- lightweight progress logging

### Guided Exercise Program
- structured daily / weekly practice plans
- progressive difficulty or focus areas

### Emotion Exercises
- practice maintaining target range while expressing different emotions

## Non-Functional Product Goals

- privacy-conscious data handling
- calm and accessible interface
- bilingual from the start
- local-first storage for initial release
