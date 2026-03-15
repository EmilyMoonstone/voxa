# Voxa Kotlin Rewrite Plan

## Purpose

This document is a detailed migration and rebuild plan for an AI that will recreate the current **Voxa** app in **native Kotlin for Android**.

This is **not** a generic rewrite brief. It is based on the current repository structure, screens, design system, feature set, persistence model, audio pipeline, scheduling, and sync logic found in the Flutter codebase.

The goal is to preserve:
- product scope
- UX intent
- navigation and flows
- visual style
- domain model semantics
- analysis behavior
- data behavior
- important heuristics and algorithms

The goal is **not** to mechanically translate Flutter widgets to Kotlin. The Kotlin app should be a native Android implementation that is behaviorally equivalent.

---

## 1. Current Product Summary

### App identity
- App name: **Voxa**
- Purpose: voice training app for trans* users
- Primary focus: structured, affirming pitch-oriented voice training
- Secondary focus: resonance cues, recording, post-session analysis, progress tracking, reminders, and optional cloud sync

### Current technical stack in repo
- Flutter app
- Riverpod for state management and DI
- GoRouter for navigation
- Drift for structured local persistence
- SharedPreferences for lightweight settings and metadata
- `record` package for mic capture / PCM streaming
- `pitch_detector_dart` for pitch detection
- `just_audio` for playback
- `flutter_local_notifications` + timezone support for reminders
- Google Sign-In + Google Drive appData sync

### Native Kotlin target recommendation
Rebuild as:
- **Kotlin**
- **Jetpack Compose** UI
- **Navigation Compose**
- **Room** for database
- **DataStore** for preferences
- **WorkManager** for background-ish sync scheduling where useful
- **AlarmManager** or notifications scheduling abstraction for reminders
- **Kotlin Coroutines + Flow**
- **Hilt** for DI
- Android audio capture with either:
  - `AudioRecord` for PCM streaming
  - custom pitch detection implementation or a suitable DSP/native library
- Google Sign-In / Credential Manager + Drive REST integration for sync

---

## 2. Repo-Level Feature Inventory

The current app contains these feature areas under `lib/features`:

1. `onboarding`
2. `home`
3. `goal_setting`
4. `practice`
5. `record`
6. `history`
7. `settings`
8. `training`
9. `sync`
10. `shell`

Shared infrastructure under `lib/core` includes:
- theme tokens and theme creation
- reusable panels/pages/logo/chart/gauge widgets
- local database
- notifications abstraction
- audio contracts and implementations

Application wiring under `lib/app` includes:
- app bootstrap
- provider wiring
- router
- app root

---

## 3. User Flows to Preserve

### Startup flow
1. App launches.
2. SharedPreferences is opened.
3. Incompatible local data reset may run based on app model version.
4. Database and notifications are initialized.
5. App settings and training plan are loaded.
6. Reminder schedule is synchronized.
7. Current voice target is loaded.
8. Initial route:
   - if no target exists -> onboarding welcome
   - else -> home

### Onboarding flow
1. Welcome screen
2. Target setup screen
   - select preset
   - or measure from voice
   - or expand more options and enter custom Hz
3. Permissions screen
   - request mic permission
   - or skip for now
4. Then navigate to home

### Main shell flow
Bottom navigation contains:
- Home
- Practice
- History
- Settings

Back behavior:
- If not on Home, back navigates to Home instead of exiting shell.
- If on Home, app can exit shell.

### Practice flow
1. User enters practice screen.
2. If no target exists, show target setup prompt.
3. If mic permission denied, show permission UI.
4. Idle setup overlay lets user choose:
   - live mode vs record mode entry
   - tracking mode indirectly through exercise mode or settings
   - exercise mode
   - planned duration
5. Start live practice or navigate to recording.
6. During live practice:
   - real-time pitch tracking
   - volume state
   - resonance state
   - time in target
   - remaining duration
   - contextual tip text
7. On stop or timer completion:
   - analyze captured samples
   - show review
   - save / repeat / discard
8. On save -> history detail page

### Record flow
1. Setup screen:
   - choose sound vs speech mode
   - show current target label
   - optional practice text selection in speech mode
   - toggle live feedback during recording
2. Start recording
3. During recording:
   - current pitch
   - quality label
   - pause/resume
   - stop
4. On stop:
   - PCM stream saved as WAV
   - offline analysis performed
   - review screen shows metrics
   - playback available
5. Save or repeat or discard
6. On save -> history detail page

### History flow
1. Sessions list
2. Empty state if none
3. Summary metrics at top
4. Session cards
5. Session detail screen:
   - summary metrics
   - target snapshot
   - tracked time
   - mode
   - optional resonance summary
   - pitch contour chart
   - playback if audio exists
   - delete action with confirmation

### Settings flow
Subpages:
- language & appearance
- analysis
- training plan
- sync
- privacy
- data/reset

### Sync flow
1. Connect Google account
2. Save sync metadata locally
3. Immediate sync
4. Later local changes schedule debounced sync
5. On app launch, restore sign-in and sync if previously connected

---

## 4. Screens and Pages to Rebuild

### 4.1 OnboardingWelcomeScreen
Purpose:
- brand-led introduction
- calm ambient background
- logo centered
- short affirming product intro
- continue CTA

### 4.2 OnboardingTargetScreen
Purpose:
- first target setup

Elements:
- back action
- title/subtitle
- preset cards for feminine / androgynous / masculine
- measure-from-voice CTA
- expandable “more options” with custom numeric target field
- continue CTA

Behavior:
- default selected preset = androgynous
- selecting preset updates custom field
- measuring from voice fills custom field and switches to custom preset
- save creates `VoiceTarget(id = "current-target")`

### 4.3 OnboardingPermissionsScreen
Purpose:
- request mic permission

Elements:
- mic icon
- title/body
- primary request button
- secondary skip button

### 4.4 HomeScreen
Content blocks:
- header with logo, title, target badge, edit target action
- today plan card with duration and reminder chips
- custom session card with start and record CTAs
- latest result card with most recent session summary and details link

### 4.5 GoalSettingScreen
Content blocks:
- current target card
- visual target band chart
- preset chips
- measure-from-voice card
- expandable advanced section with:
  - custom target Hz field
  - target volume calibration state
  - calibrate from microphone
  - import target from audio file
- save CTA

Important logic:
- supports preset-based and custom target entry
- stores optional target volume in dBFS
- import analyzes external audio and extracts median voiced pitch
- volume calibration captures loud clear speech over ~3 seconds

### 4.6 PracticeScreen
Most complex live screen.

Visual structure:
- immersive gradient background with decorative glow orbs
- header with current target label
- session meta bar when active
- large chart panel with target band and pitch trace
- primary stats row
- tip card
- controls row
- idle overlay setup card before start
- review screen after session

Must preserve these states:
- no target
- permission denied
- idle/setup
- running
- paused
- review ready
- error

### 4.7 RecordScreen
States:
- permission denied
- setup
- active recording
- review
- error message

Features:
- practice text picker bottom sheet
- live stats during recording
- playback of recorded WAV

### 4.8 HistoryScreen
States:
- loading
- error
- empty
- populated list

Elements:
- summary metrics
- list of session cards

### 4.9 SessionDetailScreen
Elements:
- back button
- date
- hero metric card with average pitch and range
- target card
- tracked time card
- mode card
- optional resonance card
- pitch contour chart
- playback button if recording exists
- delete button with confirmation dialog

### 4.10 SettingsScreen
Top-level settings hub with link panels:
- language & appearance
- analysis
- training plan
- sync
- privacy
- reset/data

### 4.11 SettingsLanguageScreen
Features:
- locale choice chips: system / en / de
- theme mode chips: system / light / dark

### 4.12 SettingsAnalysisScreen
Features:
- smoothing window dropdown: 180 / 300 / 420 ms
- target pitch tolerance slider: 5..20 Hz
- target volume tolerance slider: 3..12 dB
- toggle for live feedback during recording

### 4.13 SettingsTrainingPlanScreen
Features:
- schedule mode segmented control:
  - same every day
  - by weekday
- for each day plan:
  - duration editor
  - exercise mode editor
  - reminders add/remove

### 4.14 SettingsSyncScreen
Features:
- availability handling
- connect/disconnect account
- sync now button
- account email display
- last synced timestamp
- error display
- note that audio is not synced like metadata? preserve exact behavior based on current sync snapshot model investigation during implementation

### 4.15 SettingsPrivacyScreen
Simple informational page.

### 4.16 SettingsDataScreen
Features:
- reset local data with confirmation dialog
- after reset: snackbar and route to onboarding

---

## 5. Visual Design System to Preserve

### General look
The app uses a calm, premium, slightly futuristic style:
- dark-first presentation
- ambient gradient backgrounds
- soft glow accents
- rounded panels/cards
- aqua/teal/iris accent palette
- large friendly typography
- spacious padding

### Core reusable visual primitives
From `lib/core/widgets` and theme tokens:
- `VoxaPage`
- `VoxaPanel`
- `VoxaLogo`
- `SessionChart`
- `PitchGauge` (exists in repo and should be inspected during implementation if used later)

### Compose translation guidance
Create a design system module with:
- color tokens
- spacing tokens
- radius tokens
- elevation / alpha tokens
- typography scale
- app gradients
- reusable composables for page, panel, badges, chips, stat cards, chart container

### Important design details
- dark background by default
- shell bottom navigation uses Material 3 style navigation bar
- cards are heavily rounded
- secondary text often uses alpha-reduced onSurface
- accent colors carry semantic meaning:
  - aqua: primary accent / good / selected target
  - coral: too low or dark resonance
  - green-ish pitch-in-range color: success / at-target
  - high-pitch accent for high state
  - iris: unclear / inactive / unvoiced
  - warning: unstable / loud

AI should inspect the Flutter theme token files and port values exactly where possible.

---

## 6. Localization Requirements

Current app is bilingual:
- English
- German

Source files:
- `lib/l10n/app_en.arb`
- `lib/l10n/app_de.arb`

Kotlin migration requirements:
- all user-facing strings must move into Android string resources
- support locale switching independent of system locale
- preserve current locale setting semantics:
  - `system`
  - explicit `en`
  - explicit `de`

Also preserve localized seeded practice texts.

---

## 7. Core Domain Models to Recreate

### 7.1 VoiceTarget
Current fields:
- `id: String`
- `targetHz: Double`
- `targetVolumeDbfs: Double?`
- `suggestionPreset: TargetPreset`
- `createdAt: DateTime`
- `updatedAt: DateTime`
- `deletedAt: DateTime?`

Behavior:
- `formatWithTolerance(toleranceHz)`
- `formatVolumeWithTolerance(toleranceDb)`

### 7.2 TargetPreset
Values:
- feminine
- androgynous
- masculine
- custom

Presets currently map to target suggestions:
- feminine -> 193 Hz
- androgynous -> 160 Hz
- masculine -> 123 Hz

Reference bands:
- masculine: 100..145 Hz
- androgynous: 145..175 Hz
- feminine: 165..220 Hz

### 7.3 PitchTrainingMode
Need to recreate enum and storage mapping.
Observed modes:
- sound
- speech

Meaning:
- sound: more direct frame-level target evaluation
- speech: uses speech-window heuristics and baseline smoothing for analysis

### 7.4 PitchSample
Represents processed live/offline pitch sample.
Observed important fields:
- `timestampMs`
- `frequencyHz`
- `rawFrequencyHz`
- `confidence`
- `rmsDbfs`
- `quality`
- `isVoiced`
- `stateCategory`
- `resonanceFeedback`

### 7.5 PitchStateCategory
Values:
- low
- atTarget
- high
- unvoiced

### 7.6 PitchQuality
Values inferred from UI usage:
- strong
- weak
- unstable
- silent

### 7.7 Resonance models
Need:
- `ResonanceState`
  - insufficientSignal
  - dark
  - balanced
  - bright
  - unstable
- `ResonanceFeedback`
  - state
  - confidence
  - brightnessRatio
  - spectralTiltDbPerOct
  - timestampMs
- `SessionResonanceAnalysis`
  - dominantState
  - balancedTrackedPercent
  - averageConfidence

### 7.8 PracticeSession
Fields:
- `id`
- `startedAt`
- `endedAt`
- `updatedAt`
- `mode` (`practice` or `recording`)
- `trackingMode`
- `targetSnapshot`
- `targetToleranceHz`
- `targetVolumeToleranceDb`
- `averagePitchHz`
- `minPitchHz`
- `maxPitchHz`
- `timeAtTargetMs`
- `totalTrackedTimeMs`
- `audioFilePath`
- `chartPoints`
- `practiceTextId`
- `resonanceState`
- `resonanceBalancedPercent`
- `resonanceAverageConfidence`

Derived behavior:
- `timeAtTargetPercent`
- `targetLabel()`

### 7.9 ChartPoint
Fields:
- `timestampMs`
- `frequencyHz?`

### 7.10 PracticeText
Need to inspect exact repository entries when implementing.
Observed fields from architecture and usage:
- `id`
- `locale`
- `title`
- `body`
- likely category/difficulty optional

### 7.11 AppSettings
Fields:
- `localeCode`
- `themeMode`
- `smoothingWindowMs`
- `targetToleranceHz`
- `targetVolumeToleranceDb`
- `lastPitchTrainingMode`
- `showLiveFeedbackDuringRecording`
- `updatedAt`

Default values:
- locale = system
- theme = system
- smoothingWindowMs = 300
- targetToleranceHz = 10
- targetVolumeToleranceDb = 6
- lastPitchTrainingMode = speech
- showLiveFeedbackDuringRecording = true

### 7.12 Training plan models
- `TrainingScheduleMode`: sameEveryDay / byWeekday
- `TrainingWeekday`
- `TrainingReminderTime(hour, minute)`
- `TrainingDayPlan(durationMinutes, exerciseMode, reminderTimes)`
- `TrainingPlan(scheduleMode, everydayPlan, weekdayPlans, updatedAt)`

Defaults:
- duration 10 min
- exercise mode general

### 7.13 TrainingExerciseMode
Values:
- general
- warmupReset
- laxVox
- strawBubbles
- lipTrills
- resonanceHum
- pitchGlides
- targetSpeech
- readingTransfer
- chestResonance
- articulationProjection

Each value may define recommended tracking mode:
- many sound-based exercises -> `sound`
- speech-based exercises -> `speech`
- general -> null

### 7.14 Sync models
Need to preserve:
- sync status model
- sync snapshot
- sync session DTOs
- tombstones
- merge result
- remote file metadata

AI should port actual model fields from sync domain files, not simplify them.

---

## 8. Persistence Model to Recreate

### 8.1 Structured database
Current Drift tables:

#### VoiceTargetEntries
Columns:
- id TEXT PK
- targetHz REAL
- targetVolumeDbfs REAL nullable
- suggestionPreset TEXT
- createdAt INT
- updatedAt INT
- deletedAt INT nullable

#### PracticeSessionEntries
Columns:
- id TEXT PK
- startedAt INT
- endedAt INT
- updatedAt INT
- mode TEXT
- trackingMode TEXT
- targetHz REAL
- targetVolumeDbfs REAL nullable
- targetToleranceHz INT
- targetVolumeToleranceDb INT
- targetSuggestionPreset TEXT
- averagePitchHz REAL nullable
- minPitchHz REAL nullable
- maxPitchHz REAL nullable
- timeAtTargetMs INT
- totalTrackedTimeMs INT
- audioFilePath TEXT nullable
- chartPointsJson TEXT
- practiceTextId TEXT nullable
- resonanceState TEXT nullable
- resonanceBalancedPercent REAL nullable
- resonanceAverageConfidence REAL nullable

### Kotlin recommendation
- Use Room entities mirroring these fields.
- Keep epoch millis timestamps.
- Store chart points as JSON with a type converter, or normalize if preferred.
- Prefer preserving schema semantics first before optimizing.

### 8.2 Preferences storage
Current SharedPreferences usage stores:
- app settings
- model version key for destructive reset
- training plan
- sync metadata

Kotlin recommendation:
- DataStore Preferences for simple values
- possibly DataStore Proto for structured plan/sync metadata if cleaner

### 8.3 Audio files
Current behavior:
- recordings saved to app documents directory `/recordings/{sessionId}.wav`
- review discard deletes temp file
- local data reset deletes entire recordings directory

Kotlin equivalent:
- use app-specific files dir, e.g. `context.filesDir/recordings/{id}.wav`

---

## 9. Audio Capture and Signal Processing Logic to Preserve

This section is critical.

### 9.1 Audio permission service
Current abstraction supports:
- check status
- request permission
- open app settings

Kotlin equivalent:
- permission manager abstraction over Android runtime permission flow

### 9.2 Live audio engine behavior
Current live engine:
- starts PCM16 mono stream at 44100 Hz
- frame window size = 2048 for live profile
- hop size = 1024
- each frame processed into a `PitchSample`
- emits latest sample to UI stream

### 9.3 Recording engine behavior
Current recording engine:
- also streams PCM while recording
- stores raw PCM bytes in memory during session
- emits `RecordingChunk(sample, bytes)` during recording
- on stop, writes WAV file to disk
- returns `RecordedAudioCapture` with:
  - filePath
  - pcmBytes
  - sampleRate
  - channelCount

### 9.4 Default audio config
Preserve these constants unless Android constraints force minor changes:
- sampleRate = 44100
- channelCount = 1
- PCM16 mono
- echo cancel = false
- auto gain = false
- noise suppression = false

### 9.5 Pitch tracking profiles
Two config profiles exist.

#### Live profile
- windowSize: 2048
- hopSize: 1024
- minimumVoicedFrequencyHz: 70
- maximumVoicedFrequencyHz: 350
- minimumRmsDbfs: -34
- minimumConfidence: 0.55
- strongRmsDbfs: -22
- strongConfidence: 0.82
- unvoicedTimeoutMs: 320
- speechBaselineWindowMs: 1200
- displaySmoothingFactor: 0.36
- maximumPitchStepHz: 14
- jumpToleranceHz: 26
- confirmedJumpFrames: 2
- speechOutlierHz: 24

#### Offline profile
- windowSize: 4096
- hopSize: 512
- minimumVoicedFrequencyHz: 70
- maximumVoicedFrequencyHz: 350
- minimumRmsDbfs: -30
- minimumConfidence: 0.62
- strongRmsDbfs: -20
- strongConfidence: 0.86
- unvoicedTimeoutMs: 280
- speechBaselineWindowMs: 1200
- displaySmoothingFactor: 0.42
- maximumPitchStepHz: 11
- jumpToleranceHz: 20
- confirmedJumpFrames: 2
- speechOutlierHz: 18

### 9.6 LivePitchSignalProcessor algorithm
This class should be reimplemented carefully, not approximated loosely.

Responsibilities:
1. accept raw detected pitch frames
2. gate invalid frames by pitch range, RMS, confidence, and pitched flag
3. suppress sudden jumps unless repeated / strongly confident
4. maintain recent accepted pitches
5. compute rolling median smoothing
6. stabilize display pitch with bounded delta and smoothing factor
7. in speech mode, maintain baseline window and filter outliers
8. classify pitch relative to target
9. hold last voiced state briefly through short unvoiced gaps
10. mark unstable/silent/weak quality states

#### Acceptance logic
Accept a frame only if:
- pitched
- raw freq not null
- within voiced freq range
- RMS >= minimumRmsDbfs
- confidence >= minimumConfidence

#### Jump suppression
If large delta from last pitch exceeds jump tolerance and confidence is not strong:
- require repeated confirmation across frames before accepting jump

#### Smoothing
- keep recent accepted pitches window sized from smoothingWindowMs
- sample count = clamp(round(windowMs / 60), 3..9)
- use rolling median

#### Display stabilization
- bounded delta using maximumPitchStepHz
- factor = displaySmoothingFactor
- if huge jump, factor may increase up to 0.52

#### Speech mode tracking
- maintain recent speech pitches for `speechBaselineWindowMs`
- compute rolling median baseline
- discard outliers beyond `speechOutlierHz`
- tracking pitch = rolling median of filtered values

#### Unvoiced hold behavior
- if recent voiced sample within timeout, continue showing last pitch/category with `isVoiced=false` and silent quality
- otherwise return unvoiced sample with null freq

### 9.7 RMS calculation
Current RMS in dBFS:
- interpret PCM16 little-endian samples
- normalize to [-1,1]
- compute RMS
- if tiny -> -120
- else `20 * log10(rms)`

### 9.8 Analysis service behavior
#### classify
- null/unvoiced -> unvoiced
- below target - tolerance -> low
- above target + tolerance -> high
- else atTarget

#### analyzeTrackedSamples
For voiced samples:
- compute average, min, max pitch
- create downsampled chart points
- compute timeAtTarget and totalTrackedTime
- compute resonance session summary

#### Sound-mode time-in-target
- iterate adjacent samples
- delta = next.timestamp - current.timestamp
- if current voiced, count delta in total
- if current atTarget, count delta in atTarget

#### Speech-mode time-in-target
Windowed heuristic:
- window = 1200 ms
- hop = 300 ms
- minimum voiced material = 400 ms
- derive typical step from median timestamp deltas
- for each window:
  - gather voiced samples in window
  - estimate voiced material = sampleCount * typicalStepMs
  - skip if below minimum
  - totalTracked += hop
  - medianPitch of window
  - if within tolerance, atTarget += hop

This is a key algorithm and should be preserved closely.

#### Downsampling for chart
- target 72 points
- bucket samples by step = ceil(total/72)
- if bucket has voiced samples, use median of voiced frequencies
- timestamp = middle sample timestamp
- else chart point with null freq

### 9.9 Imported audio target suggestion
Current behavior:
- import audio file from picker
- if WAV, parse directly
- else attempt convert-to-WAV via decoder
- analyze up to max 12 seconds
- stop after ~96 voiced samples found
- compute rolling median of voiced frequencies
- return as suggested targetHz

### 9.10 Target volume calibration
Current behavior:
- capture ~3 seconds from microphone
- collect voiced samples with `rmsDbfs > -70`
- require at least 4 samples
- sort values
- take top 40% loudest clear samples (from 60th percentile onward)
- median of that slice becomes target volume dBFS

### 9.11 Resonance heuristic analyzer
Must also be preserved, at least behaviorally.

Per-frame live behavior:
- if insufficient signal by voiced state / pitch / RMS / confidence -> insufficientSignal
- compute brightness ratio = high band energy / low band energy
- compute spectral tilt in dB per octave
- classify:
  - dark if brightnessRatio < 0.48 and tilt < -8.0
  - bright if brightnessRatio > 0.86 and tilt > -4.2
  - else balanced
- derive confidence from RMS, pitch confidence, and feature certainty
- maintain recent voiced resonance frames
- if many transitions -> unstable
- otherwise dominant recent state
- average brightness / tilt / confidence across stable frames

Session behavior:
- consider only non-insufficient frames
- dominant state by frequency count
- balancedTrackedPercent = percent of balanced frames
- average confidence = mean confidence

Important implementation note:
Current analyzer uses a very simple DFT-style band-energy approach. Kotlin rewrite may optimize implementation, but should preserve thresholds and outputs.

---

## 10. Controllers / State Machines to Rebuild

### 10.1 LivePracticeController
State fields:
- status
- currentSample
- recentSamples
- timeAtTargetPercent
- trackedTimeMs
- averagePitchHz
- selectedExerciseMode
- plannedDurationMinutes
- remainingSeconds
- review
- message

Behavior:
- initialize defaults from today training plan
- request permission on start
- auto-switch tracking mode if selected exercise recommends one
- subscribe to live pitch stream
- update UI at throttled interval ~50 ms
- maintain recent sample window ~4500 ms
- hold chart anchor briefly after voiced end using pitch hold ~1500 ms
- countdown timer every second
- on finish -> analyze tracked samples and create review
- save review as practice session
- discard review returns to idle

### 10.2 RecordSessionController
State fields:
- status
- currentSample
- selectedPracticeTextId
- averagePitchHz
- targetLabel
- timeAtTargetPercent
- review
- message

Behavior:
- request permission on start
- stream recording chunks
- throttle UI updates ~50 ms
- optionally hide live feedback while still analyzing internally
- on stop:
  - save WAV
  - run offline analysis
  - create review
- save review as recording session
- discard review deletes file

### 10.3 AppSettingsController
Must support:
- set locale
- set theme mode
- set smoothing window
- set target tolerance
- set target volume tolerance
- set last pitch mode
- set live feedback during recording
- reset all local data

### 10.4 TrainingPlanController
Must support:
- schedule mode change
- per-day duration changes
- per-day exercise mode changes
- add/remove reminders
- persist plan
- reschedule notifications
- schedule sync after save

### 10.5 SyncController
Must support:
- connect Google account
- disconnect account
- sync now
- debounced scheduled sync
- restore sign-in on launch
- invalidate/reload local data after sync
- friendly Google error mapping

---

## 11. Sync Semantics to Preserve

The current app supports local-first sync through Google Drive appData.

### Components in current architecture
- account service
- cloud sync repository
- sync metadata repository
- snapshot codec
- sync service
- merge engine

### Important merge behavior
#### Settings
- latest `updatedAt` wins

#### Current target
- choose newer target by `updatedAt`
- but tombstone delete wins if delete timestamp >= target update time

#### Sessions
- merge by session id
- choose newer by `updatedAt`
- delete tombstone wins if delete timestamp >= session update time
- final sessions sorted newest first by `startedAt`

#### Tombstones
- dedupe by `(entityType, entityId)`
- keep latest delete timestamp
- remove tombstones that are older than surviving active entities

### Migration instruction
Do not replace this with simplistic “remote wins” or “local wins”. Rebuild merge logic faithfully.

---

## 12. Notifications and Training Plan Logic

Current behavior:
- training plan loaded at startup
- notification scheduler syncs reminders immediately
- settings edits reschedule reminders

Need native implementation for:
- reminder schedule calculation
- weekday-specific schedules
- same-every-day schedules
- notification permission handling on modern Android
- timezone-aware scheduling

Potential implementation:
- Room/DataStore source of truth
- scheduler abstraction
- AlarmManager exact alarms only if necessary, otherwise WorkManager + local notifications strategy

But preserve UX:
- users can configure reminder times per day plan
- home screen displays today plan and reminder chips

---

## 13. App Reset and Data Compatibility Logic

Current startup has destructive compatibility reset:
- stored key: `app.model_version`
- current version constant = 2
- if stored version < current:
  - delete recordings directory
  - clear SharedPreferences
  - set current version

Kotlin rewrite should implement an equivalent migration/reset policy, but preferably more structured:
- app schema/data version in DataStore
- if incompatible and migration unavailable:
  - clear Room tables
  - clear DataStore values
  - delete recordings directory

### In-app reset action
Also preserve settings reset action:
- clear all local user data
- navigate to onboarding

---

## 14. Recommended Kotlin Project Structure

Suggested package layout:

- `app/`
  - `VoxaApplication`
  - navigation
  - startup/bootstrap
- `core/design/`
- `core/ui/`
- `core/audio/`
- `core/database/`
- `core/notifications/`
- `core/common/`
- `feature/onboarding/`
- `feature/home/`
- `feature/goal/`
- `feature/practice/`
- `feature/record/`
- `feature/history/`
- `feature/settings/`
- `feature/training/`
- `feature/sync/`

Per feature:
- `data/`
- `domain/`
- `presentation/`

---

## 15. Recommended Android Tech Decisions

### UI
- Jetpack Compose Material 3
- custom theme tokens matching Voxa visual system
- charts either custom Canvas-based Compose chart or small chart library if necessary

### State
- ViewModel + StateFlow
- immutable UI state data classes
- one-off events via Channel / SharedFlow

### DI
- Hilt

### Database
- Room
- TypeConverters for enums, instants, and chart point JSON

### Preferences
- DataStore

### Audio
- `AudioRecord` for live PCM capture
- WAV writer utility for recording save
- DSP layer in pure Kotlin or native bindings

### Playback
- ExoPlayer / Media3

### Sign-in and sync
- Credential Manager or Google Sign-In depending chosen API compatibility
- Drive REST client through Retrofit/OkHttp or Google API client

### Notifications
- NotificationManager + scheduler abstraction

---

## 16. Migration Phases for the Rebuild AI

### Phase 1: Product and domain parity foundation
Implement first:
- domain models
- enums
- settings storage
- Room schema
- repository interfaces
- seeded practice texts
- localization resources
- design tokens/theme

### Phase 2: Navigation and static UI shell
Implement:
- onboarding screens
- shell navigation
- home
- settings hub and subpages
- history empty/populated shell
- session detail layout without real chart/audio initially

### Phase 3: Goal target feature
Implement:
- current target persistence
- preset selection
- custom target validation
- measure/import UI stubs, then real implementations
- target band chart

### Phase 4: Audio engine and live practice
Implement:
- mic permission flow
- live PCM capture
- pitch frame detection
- `LivePitchSignalProcessor`
- live practice state machine
- chart rendering
- timer and review flow

### Phase 5: Recording and offline analysis
Implement:
- record screen state machine
- WAV writing
- offline analysis
- playback
- save session

### Phase 6: History and session detail completeness
Implement:
- session list summaries
- detailed chart
- delete flow
- practice vs recording mode presentation

### Phase 7: Training plan and reminders
Implement:
- plan editing
- schedule resolution
- notification scheduling
- home integration

### Phase 8: Sync
Implement:
- Google account connect/disconnect
- snapshot build/load/upload/download
- merge engine
- sync status UI

### Phase 9: Polish and parity validation
Validate:
- all algorithms match expected outputs
- all settings persist
- all routes behave correctly
- dark/light/theme behavior
- locale switching
- reset flows

---

## 17. Acceptance Criteria for Behavioral Parity

The Kotlin rebuild is acceptable only if all of the following are true:

1. User can complete onboarding and save a target.
2. Home shows current target, today plan, and latest result.
3. Goal settings support presets, custom Hz, measure-from-voice, audio import, and volume calibration.
4. Practice live session supports all current states and can save results.
5. Recording flow records WAV, analyzes, plays back, and saves results.
6. History shows saved sessions and detail pages.
7. Session detail includes chart and delete action.
8. Settings pages all function and persist.
9. Training reminders can be configured and scheduled.
10. Google sync works with merge semantics matching current app.
11. Localization works in English and German.
12. Audio analysis heuristics are preserved closely enough that sample outputs remain comparable.

---

## 18. High-Risk Areas Requiring Careful Porting

1. **Pitch detection pipeline**
   - most sensitive feature
   - must not become laggy or unstable

2. **Signal smoothing and speech heuristics**
   - these determine whether feedback feels trustworthy

3. **Resonance heuristic thresholds**
   - preserve exact thresholds initially

4. **Time-in-target analysis**
   - especially speech window logic

5. **Recording save/review/discard behavior**
   - avoid orphan files or missing files

6. **Sync merge logic**
   - preserve tombstones and update ordering

7. **Reminder scheduling**
   - timezone and Android permission nuances

8. **Locale override behavior in Compose**
   - must work independent of system locale

---

## 19. Files in Current Repo Most Important for the Rebuild AI

The AI performing the Kotlin rebuild should treat these files as primary source-of-truth implementation references:

### App/bootstrap/navigation
- `lib/main.dart`
- `lib/app/app.dart`
- `lib/app/app_providers.dart`
- `lib/app/router/app_router.dart`
- `lib/app/router/app_routes.dart`
- `lib/app/bootstrap/app_bootstrap.dart`

### Core audio and analysis
- `lib/core/audio/domain/audio_contracts.dart`
- `lib/core/audio/data/record_audio_services.dart`
- `lib/core/audio/data/heuristic_resonance_analyzer.dart`
- `lib/features/practice/application/live_pitch_signal_processor.dart`

### Persistence
- `lib/core/data/local/app_database.dart`
- `lib/features/record/data/drift_practice_session_repository.dart`
- `lib/features/goal_setting/data/drift_voice_target_repository.dart`

### Practice and record flows
- `lib/features/practice/application/live_practice_controller.dart`
- `lib/features/practice/presentation/practice_screen.dart`
- `lib/features/record/application/record_session_controller.dart`
- `lib/features/record/presentation/record_screen.dart`

### History
- `lib/features/history/application/session_providers.dart`
- `lib/features/history/presentation/history_screen.dart`
- `lib/features/history/presentation/session_detail_screen.dart`

### Goal setting
- `lib/features/goal_setting/domain/voice_target.dart`
- `lib/features/goal_setting/application/voice_target_use_cases.dart`
- `lib/features/goal_setting/application/voice_target_validation.dart`
- `lib/features/goal_setting/presentation/goal_setting_screen.dart`
- `lib/features/goal_setting/presentation/target_measurement.dart`

### Settings and training plan
- `lib/features/settings/domain/app_settings.dart`
- `lib/features/settings/application/app_settings_controller.dart`
- `lib/features/settings/presentation/settings_screen.dart`
- `lib/features/training/domain/training_plan.dart`
- `lib/features/training/domain/training_exercise_mode.dart`
- `lib/features/training/application/training_plan_controller.dart`

### Sync
- `lib/features/sync/application/sync_controller.dart`
- `lib/features/sync/domain/sync_merge_engine.dart`
- `lib/features/sync/domain/sync_models.dart`
- `lib/features/sync/data/default_sync_service.dart`
- `lib/features/sync/data/google_drive_app_data_cloud_sync_repository.dart`
- `lib/features/sync/data/google_sign_in_google_account_service.dart`
- `lib/features/sync/data/json_sync_snapshot_codec.dart`
- `lib/features/sync/data/shared_preferences_sync_metadata_repository.dart`

### UI system
- `lib/core/theme/voxa_theme.dart`
- `lib/core/theme/voxa_tokens.dart`
- `lib/core/widgets/*.dart`

### Product docs
- `docs/features.md`
- `docs/architecture.md`
- `docs/pages_and_flow.md`
- `docs/voice.md`
- `docs/voice_resonance.md`
- `docs/voice_exercices.md`
- brand/design docs under `docs/01_*` through `docs/04_*`

---

## 20. Rebuild Instructions for the AI

When rebuilding in Kotlin, follow these rules:

1. **Preserve behavior before improving architecture.**
2. **Port thresholds and heuristics exactly first.**
3. **Keep model names and concepts close to current code.**
4. **Do not remove features that appear incomplete; implement what exists in the repo.**
5. **Use native Android patterns, but do not change product behavior without explicit reason.**
6. **Treat Flutter docs and code together as source of truth; code wins when docs conflict.**
7. **Preserve bilingual, affirming, non-judgmental UX tone.**
8. **Preserve local-first behavior and explicit user control over data.**

---

## 21. Suggested Deliverables for the Kotlin Rebuild

The rebuild AI should produce, at minimum:
- complete Android Studio Kotlin project
- Compose UI implementation
- Room schema and repositories
- DataStore-backed settings and metadata
- audio capture/analysis pipeline
- local notifications scheduling
- Google sync implementation
- tests for key algorithms:
  - pitch classification
  - rolling median smoothing
  - speech-mode time-in-target analysis
  - downsampling
  - resonance classification
  - sync merge engine

---

## 22. Final Note

This repo is already more than a simple CRUD app. The Kotlin rewrite must preserve three layers simultaneously:
- **design language**
- **training UX**
- **signal-processing behavior**

The most important thing to keep intact is user trust:
- the app should feel calm
- the feedback should feel stable
- the metrics should feel internally consistent
- saved history and sync should be reliable

If implementation tradeoffs are necessary, prefer:
1. correctness and consistency of analysis
2. clarity of UX
3. fidelity to current design
4. internal architectural cleanliness
