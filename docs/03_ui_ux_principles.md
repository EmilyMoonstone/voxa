# UI / UX Principles

## Core Principle

**Clear data, soft presentation.**

Voxa should feel technically capable without overwhelming the user emotionally.

## Product Experience Goals

- make live training instantly understandable
- reduce anxiety around performance
- show progress over time
- support different voice goals without enforcing one “correct” outcome
- keep interactions simple and focused

## UX Principles

### 1. One main task per screen
Each primary screen should center one action or one interpretation goal.

### 2. Big central feedback
In live practice and analysis, the most important metric must dominate the layout.

### 3. Guidance without overload
Helpful tips should appear when relevant, but not flood the user with text.

### 4. Progress without pressure
Statistics should motivate, not shame.

### 5. Consistency builds safety
Interactions, colors and language should remain predictable across the app.

## Key Screens

### Home
Purpose:
- orient the user quickly
- offer clear next steps
- show recent progress gently

Suggested content:
- welcome block
- quick-start actions
- last session summary
- streak or recent activity only if it feels supportive

### Goal Setting
Purpose:
- define a target range with confidence
- explain presets clearly
- allow manual control without friction

Suggested content:
- target pitch range in Hz
- presets: Feminine, Masculine, Androgynous
- auto-detect suggestion flow
- short explanatory helper text

### Practice Mode
Purpose:
- real-time pitch training
- instant clarity about current position

Suggested content:
- central gauge / live indicator
- current pitch in Hz
- target range visualization
- percentage in range
- concise contextual tip

### Record & Analyse
Purpose:
- support deliberate practice with deeper reflection

Suggested content:
- recording action
- optional practice text
- average pitch
- min / max pitch
- time in range
- playback
- save session

### History
Purpose:
- make progress visible over time
- enable reflection and comparison

Suggested content:
- session list cards
- expandable details
- chart preview
- compare two sessions
- delete action with confirmation

### Settings
Purpose:
- manage preferences simply

Suggested content:
- language switch
- reset local data
- audio / analysis options
- privacy explanations

## Interaction Patterns

### Feedback Behavior
- live values should update smoothly
- state changes should not flicker aggressively
- use color plus shape / text, never color alone

### Buttons
- one clear primary CTA per context
- secondary actions visually softer
- destructive actions clearly signaled

### Empty States
- calm and encouraging
- explain what the user can do next
- avoid sounding like failure

## Accessibility

Voxa should be designed with accessibility from the beginning.

Requirements:
- sufficient contrast in light and dark themes
- large touch targets
- scalable text
- semantic labels for assistive technology
- state communication beyond color
- visual calm for neurodivergent users

## Internationalization

The interface must support at least:
- German
- English

Implications:
- allow room for longer German strings
- avoid hard-coded text inside images
- use consistent terminology for pitch, range, recording and feedback

## Motion

Motion should be subtle and informative.

Use:
- soft transitions
- smooth gauge movement
- restrained microinteractions

Avoid:
- flashy loading effects
- aggressive pulsing
- noisy transitions during live training
