# Roadmap

## Product Direction

The roadmap for Voxa should prioritize a reliable, emotionally safe MVP first. More advanced voice training dimensions can be added once live pitch training, recording and progress tracking work well.

## Phase 0 – Foundation

Goals:
- define brand, design system and product scope
- choose pitch detection strategy
- set up app architecture and localization foundation

Deliverables:
- design concept
- feature definition
- architecture decision record
- Flutter project setup
- localization files for German and English

## Phase 1 – MVP Core

Goal:
Ship the first usable voice training version with live pitch practice and recording analysis.

Scope:
- onboarding / first start basics
- language selection
- goal setting mode
- practice mode with live pitch gauge
- record & analyse mode
- history list with saved sessions
- settings with data reset
- local persistence

Success criteria:
- users can set a target range easily
- live pitch feedback feels responsive and understandable
- recorded sessions save reliably
- history allows basic review of progress

## Phase 2 – Better Analysis & Comparison

Goal:
Make progress tracking more meaningful.

Scope:
- richer session detail view
- improved pitch chart
- side-by-side session comparison
- better insights and trend summaries
- more nuanced feedback copy

Success criteria:
- users can understand improvement over time
- comparisons feel useful, not confusing

## Phase 3 – Guided Practice Expansion

Goal:
Move from a tool to a more structured training companion.

Scope:
- predefined practice texts by difficulty or focus
- guided routines
- daily check-in flow
- reminders or streak concepts if they feel supportive
- adaptive practice suggestions

Success criteria:
- users return regularly
- practice feels more guided without becoming rigid

## Phase 4 – Advanced Voice Training

Goal:
Expand beyond pitch.

Scope:
- resonance training
- intonation training
- sustained note mode
- expressive / emotion practice

Success criteria:
- Voxa supports broader voice work, not only pitch
- advanced features remain understandable for non-expert users

## Phase 5 – Long-Term Platform Growth

Possible future directions:
- cloud backup or account sync
- optional data export
- session tags / notes
- clinician / coach sharing features only if privacy model is strong
- richer onboarding with educational content

## Suggested Delivery Order Inside MVP

1. project setup and theme foundation
2. localization and settings shell
3. goal setting
4. live practice mode
5. recording pipeline
6. analysis summary
7. history and persistence
8. polish, accessibility and copy refinement

## Risks to Watch

- microphone / pitch detection inconsistency across devices
- overcomplicated live UI
- too much reliance on pitch alone in user messaging
- performance issues from real-time charts or audio processing
- accessibility gaps in color-based feedback
