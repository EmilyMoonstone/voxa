# Architecture

## Goals

The technical architecture for Voxa should support:
- real-time audio processing
- responsive live UI
- local-first persistence
- bilingual content
- modular growth into additional training modes

## Recommended Architectural Style

A pragmatic feature-first architecture with clear domain boundaries.

Recommended layers:
- **Presentation** – screens, widgets, state handling
- **Application / Controllers** – orchestration of flows and UI state
- **Domain** – entities, business logic, analysis models
- **Data** – repositories, local storage, audio integrations

## Suggested Module Split

### Core
Shared infrastructure:
- theme
- localization
- routing
- error handling
- logging
- shared utilities

### Features
#### Goal Setting
- target range editor
- presets
- auto-detect flow

#### Practice
- live microphone session
- pitch stream processing
- gauge UI
- tips / coaching hints

#### Record & Analyse
- recording session lifecycle
- optional practice texts
- waveform / pitch curve capture
- metrics calculation

#### History
- session list
- session detail
- comparison view

#### Settings
- locale selection
- reset data
- analysis preferences

## Domain Model Suggestions

### Entities

#### VoiceTarget
Represents the current practice target.

Fields:
- id
- minHz
- maxHz
- presetType
- createdAt
- updatedAt

#### PracticeSession
Represents a live or recorded training session.

Fields:
- id
- startedAt
- endedAt
- mode
- targetRangeSnapshot
- averagePitchHz
- minPitchHz
- maxPitchHz
- timeInRangeMs
- totalVoicedTimeMs
- notesText (optional, future)

#### PitchSample
Represents a time-based pitch data point.

Fields:
- timestampMs
- frequencyHz
- confidence
- isVoiced
- stateCategory

#### PracticeText
Represents predefined reading content.

Fields:
- id
- locale
- title
- body
- category
- difficulty

## State Management

Recommended:
- **Riverpod** for dependency injection and state management

Why:
- strong modularity
- testability
- async handling is straightforward
- good fit for feature-first Flutter apps

Potential provider groups:
- app settings provider
- current target provider
- live pitch session controller
- recording controller
- analysis controller
- history repository provider

## Data Storage

### Initial Recommendation
Local-first persistence.

Suggested storage split:
- **Isar** or **Drift** for structured local data
- file storage for audio recordings
- lightweight key-value storage for preferences if desired

A practical MVP approach:
- session metadata in database
- pitch samples stored either compactly in the DB or as serialized blobs depending on size/performance needs
- recordings stored in app documents directory with file path references in database

## Audio Pipeline

## Input
- microphone capture
- frame-based audio processing

## Processing Steps
1. capture audio frames
2. run pitch detection
3. smooth / stabilize values for UI
4. classify pitch relative to current target range
5. emit stream to live UI and optional recording buffer

## Output
- live current pitch
- state category: low / in-range / high / unvoiced
- buffered samples for charts and session summaries

## Pitch Detection Considerations

Important requirements:
- low latency
- spoken-voice robustness
- ability to handle noisy / breathy samples reasonably
- clear strategy for uncertain / low-confidence data

Design implication:
Unvoiced segments should not be treated as “wrong pitch”. They should be handled as neutral or excluded depending on metric.

## Analysis Pipeline

After recording:
- filter invalid samples
- calculate average pitch over voiced frames
- compute min and max values
- compute time-in-range against target snapshot
- prepare downsampled chart series for display if needed

## Localization

The app should be internationalized from the beginning.

Suggested approach:
- ARB-based localization
- all user-facing strings in localization files
- practice texts per locale as structured content entries

Supported locales at launch:
- `de`
- `en`

## Navigation

Suggested route areas:
- home
- goal setting
- practice
- record
- history
- session detail
- compare
- settings

A typed router approach is recommended.

## Testing Strategy

### Unit Tests
- range classification
- statistics calculation
- analysis aggregation
- preset mapping

### Widget Tests
- practice gauge state rendering
- settings locale switching
- history list rendering

### Integration Tests
- start practice session
- record and save session
- compare two sessions

## Performance Notes

Watch closely:
- rebuild frequency in live pitch screen
- chart rendering cost
- pitch sample storage size
- audio processing on lower-end devices

Strategies:
- isolate heavy computations when necessary
- decouple UI update rate from raw processing rate
- store downsampled chart data for history views if useful

## Privacy and Data Handling

Initial principle:
- local-first by default
- no cloud requirement for MVP
- transparent handling of microphone and recordings

The user should be able to:
- understand what is stored
- delete sessions
- reset all saved data

## Future Architecture Extensions

Potential future modules:
- resonance analysis
- guided programs
- reminders / check-ins
- export / backup
- optional cloud sync

To support future growth, keep:
- training modes modular
- session schema extensible
- analysis pipeline separated from UI logic
