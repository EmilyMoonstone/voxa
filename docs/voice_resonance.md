# Analyse und Implementierung von Stimmresonanz in einer Flutter‑App für Stimmtraining

## Executive Summary

Stimmresonanz lässt sich in einer Trainings‑App nicht „direkt“ messen, sondern wird praktisch über akustische Korrelate approximiert: Resonanzen des Vokaltrakts (Formanten als Peaks der Vokaltrakt‑Transferfunktion), deren Bandbreiten (Dämpfung), sowie Maße der Quellencharakteristik (z. B. spektrale Neigung/Spectral Tilt, Harmonics‑to‑Noise Ratio) und stabilitäts-/robustheitsorientierte Deskriptoren (z. B. MFCCs, cepstrale Maße).citeturn16view0turn33view0turn31view0turn34view0turn31view2turn2view0

Für Echtzeit‑Feedback auf Mobilgeräten ist die Kernherausforderung nicht die Signalverarbeitung „an sich“, sondern deterministisches Processing unter strengen Thread‑ und Latenzbedingungen: Audio‑Callbacks laufen auf hochpriorisierten Threads; blockierende Operationen (Allokationen, Locks, Dispatch) führen zu Glitches und ruinieren Messstabilität.citeturn17view2turn23view1 Android und iOS liefern je nach Gerät unterschiedliche native Buffergrößen und Sample‑Rates; robuste Apps müssen diese dynamisch auslesen/akzeptieren und ihre Frame‑Strategie (z. B. 10 ms/20 ms Frames mit Overlap) daran ausrichten.citeturn17view1turn18view1turn26search11

Technisch ist ein zweistufiger Ansatz am praktikabelsten: (a) Audio‑Capture „nah am Gerät“ (native APIs wie AAudio/Oboe auf Android, AVAudioEngine/AudioUnits auf iOS) mit lock‑freiem Ringbuffer, (b) Feature‑Extraktion in einem separaten Worker‑Kontext (native DSP über C/C++ und Dart FFI oder über Platform Channels), und (c) UI‑Feedback in Flutter, das ausschließlich (geglättete) Feature‑Streams rendert.citeturn17view2turn23view1turn27search1turn27search16turn27search3

Empfehlung (ohne spezifische Geräte-/OS‑Constraints): Für einen schnellen Prototyp sind Flutter‑Plugins mit PCM‑Streaming (z. B. `audio_streamer`, `record`, `flutter_sound`) geeignet; für produktionsreife, latenzarme und kontrollierbare Resonanz‑Messung ist langfristig ein eigenes Plugin (Android: Oboe/AAudio; iOS: AVAudioEngine/Audio Unit) plus DSP‑Core in C/C++ (FFI) die robusteste Architektur.citeturn37search1turn7view1turn7view0turn8search0turn17view2turn23view1turn27search1

## Begriffe und akustische Korrelate von Stimmresonanz

Stimmresonanz wird in der Stimm‑ und Sprechwissenschaft typischerweise im Rahmen des Source‑Filter‑Modells verstanden: Eine Schallquelle (quasi‑periodische glottale Anregung oder turbulente Geräuschanteile) wird durch den Vokaltrakt als Filter/Resonator geformt; die „Resonanzen“ erscheinen als Formanten (F1, F2, F3 …) bzw. als Peaks der Transferfunktion.citeturn33view0turn16view0 Resonanz im physikalischen Sinn tritt auf, wenn die Anregungsfrequenz nahe an Eigenfrequenzen des Systems liegt; als Filter wirkt das System, indem es bestimmte Frequenzen verstärkt und andere dämpft.citeturn33view0

image_group{"layout":"carousel","aspect_ratio":"16:9","query":["source filter model speech production diagram","vowel formants spectrogram example F1 F2","vocal tract resonance formants diagram"],"num_per_query":1}

**Formanten und Vokaltrakt‑Transferfunktion.** In akustisch‑phonetischen Darstellungen ist die Transferfunktion eines Vokals durch die Mittenfrequenzen und Bandbreiten der Formanten charakterisiert; Bandbreiten lassen sich als Maß der Dämpfung der Resonanzen interpretieren (schmale Bandbreite ↔ geringere Dämpfung, breite Bandbreite ↔ stärkere Dämpfung).citeturn33view0turn16view0 Praat modelliert Formantkonturen als zeitabhängige Frames, in denen explizit Frequenz *und* Bandbreite pro Formant gespeichert werden; das ist für „Resonanz‑Feedback“ direkt nutzbar.citeturn30view0

**Bandbreite als Dämpfungs-/Impedanzkorrelat.** Physiologisch und modellbasiert hängen Formantfrequenzen und Bandbreiten nicht nur von der Geometrie (Länge/Querschnittsverlauf), sondern auch von Randbedingungen (Mundöffnung) und mechanischer Impedanz der Vokaltraktwände ab; diese beeinflussen die Übertragung akustischer Energie sowie Position *und* Bandbreite der Formanten.citeturn16view0

**Quellenmerkmale, spektrale Neigung und Stimmqualität.** Die spektrale Neigung (Spectral Tilt) beschreibt, wie stark die Harmonischenamplituden mit steigender Frequenz abfallen; in Source‑Filter‑Modellen reflektiert sie primär Eigenschaften der glottalen Quelle und Phonationsart.citeturn33view0turn16view0turn34view0turn34view1 In der Praxis werden Tilt‑Maße häufig aus Harmonischen‑Differenzen (z. B. H1‑H2) und Harmonisch‑zu‑Formant‑ oder Harmonisch‑zu‑Spektralband‑Distanzen abgeleitet; H1‑H2 wird in der Literatur als verbreitetes Maß diskutiert und mit Open Quotient/Phonationsart in Zusammenhang gebracht (mit bekannten Einschränkungen und Abhängigkeiten von Modellannahmen und Inversfilterung).citeturn34view0turn34view1

**Harmonic‑to‑Noise Ratio (HNR).** HNR ist ein Maß für Periodizität vs. Rauschanteil und damit ein robustheitsrelevanter Marker für „saubere“ Stimmanregung (v. a. bei Atemigkeit/Heiserkeit/Umgebungsgeräusch). Praat beschreibt HNR‑Analyse als kurzzeitige Periodizitätsschätzung auf Basis (Vorwärts‑)Kreuzkorrelation.citeturn31view0

**Singen/„Sängerformant“ als spezieller Resonanzfall.** In klassischer Gesangsanalyse ist ein spektraler Envelope‑Peak um ~3 kHz („singer’s formant“) ein bekanntes Charakteristikum professioneller Stimmen; er wird als Resonanzphänomen (Cluster höherer Formanten) interpretiert und hat nachweisbare perzeptive Effekte (u. a. Hörbarkeit/Qualität in Synthesen).citeturn35view1 (Für allgemeines Sprech‑Stimmtraining ist das optional, aber als „Resonanzziel“ für bestimmte Trainingsmodi gut operationalisierbar.)

## Messbare Features und Algorithmen

Eine App sollte Stimmresonanz als **Feature‑Set** verstehen, nicht als Einzelzahl: Formanten (F1–F4/5) + Bandbreiten, spektrale Hüllkurve/Envelopes, Tilt‑Maße, HNR, ggf. MFCC‑basierte Ähnlichkeiten zu Zielprofilen.citeturn30view0turn31view0turn31view2turn16view0turn33view0

**Kurzzeitspektren: FFT/STFT, Spektrogramm und Hüllkurve.** Spektrogramme repräsentieren Zeit‑Frequenz‑Energie; es existiert ein Trade‑off zwischen Zeit‑ und Frequenzauflösung (breitbandig: bessere Zeitauflösung; schmalbandig: bessere Frequenzauflösung).citeturn33view0 Für Resonanztraining sind typischerweise Fenster im Bereich 20–40 ms sinnvoll, weil Formantstruktur in diesem Bereich (quasi‑stationär) approximiert wird; Praat verwendet für Formantmessungen standardmäßig Time‑Steps von WindowLength/4 (≈ vierfache Überabtastung pro Analysefenster).citeturn32view0turn29view1

**Formant‑Tracking över LPC (inkl. Burg), Root‑Solving und Bandbreiten.** Praat empfiehlt für Formantmessung `Sound: To Formant (burg)` und warnt davor, rohe LPC‑Kommandos ohne passende Maximalfrequenz/Downsampling für Formantziele zu verwenden; bei 44.1 kHz Sampling müssten für „5 Formanten < 5500 Hz“ beispielsweise Downsampling auf ~11 kHz und eine passende Modellordnung gewählt werden.citeturn36view0 Die Umrechnung LPC→Formanten erfolgt, indem Wurzeln des Prädiktionspolynoms bestimmt und (nach stabilisierenden Schritten) in Frequenzen/Bandbreiten übertragen werden; Praat beschreibt z. B. das Extrahieren der Wurzeln und das Verwerfen sehr niedriger oder Nyquist‑naher Formanten.citeturn40view0 Eine konkrete, häufig zitierte Root‑basierte Umrechnung (Winkel→Hz, Radius→Bandbreite) wird u. a. in der Dokumentation von entity["company","MathWorks","matlab developer company"] gezeigt.citeturn40view2

**Zuverlässigkeit und typische Fehler.** Formantmessungen sind fehleranfällig, besonders bei hoher F0 (großer Harmonischenabstand), enger Formanten‑Clusterung und je nachdem, ob Peak‑Picking oder Root‑Solving genutzt wird. In einer systematischen Vergleichsstudie konnten LPC‑Burg‑Messungen (Praat‑Empfehlung) zwar solide Ergebnisse liefern, zeigten aber weiterhin F0‑Bias‑Effekte; Root‑Solving kann in synthetischen Tests sehr geringe Fehler erreichen, ist jedoch in natürlicher Sprache komplexer.citeturn29view1 Für eine App heißt das: Formanten müssen **geglättet**, **plausibilisiert** (z. B. Kontinuitäts‑Constraints) und ggf. mit VAD/Voicing‑Gates kombiniert werden, statt jeden Frame „roh“ an Nutzer:innen auszuspielen.citeturn29view1turn32view0

**Cepstrum und MFCCs.** MFCCs sind eine mel‑skalierte cepstrale Repräsentation, die Spektralhüllkurven-/Formant‑Informationen in kompakten Koeffizienten abbildet und robustere Distanzmaße (z. B. zur Zielvokal‑„Resonanzsignatur“) ermöglicht.citeturn2view0turn31view2turn25search5 Praat beschreibt MFCC‑Berechnung explizit als (1) Mel‑Spektrogramm (Triangular‑Filterbank im Frequenzbereich) und (2) Umrechnung in cepstrale Koeffizienten.citeturn31view2turn25search1turn25search5

**Pitchdetektion (für Voicing‑Gating, F0‑Normalisierung, LTAS‑Korrekturen).** Pitch/F0 ist für Resonanzanalyse doppelt relevant: i) Formanttracking‑Fehler hängen von Harmonischenlage ab; ii) mehrere Verfahren „korrigieren“ Resonanzmaße um F0‑Einfluss.citeturn29view1turn30view1 Für F0‑Schätzung ist YIN ein etablierter Ansatz für Sprache und Musik.citeturn5search12 Praat bietet verschiedene Pitch‑Methoden und dokumentiert Parameter wie Pitch‑Floor/‑Ceiling sowie Voicing‑Thresholds.citeturn31view1turn5search8turn32view0

**Praat‑Methoden als Referenz („Gold‑Standard“ für Implementationsziel, nicht zwingend für Echtzeit).** Für App‑Validierung ist Praat besonders nützlich, weil es nachvollziehbar dokumentierte Implementationen (Formant, HNR, MFCC, pitch‑korrigierte LTAS) bietet, die als Offline‑Baseline dienen können.citeturn5search10turn31view0turn31view2turn30view1turn36view0turn40view0 Insbesondere „pitch‑corrected LTAS“ ist konzeptionell interessant, weil es Resonanz (Vokaltraktformanten) und glottale Hüllkurve adressiert, ohne die Frequenzauflösung zu opfern.citeturn30view1

## Echtzeitverarbeitung auf Mobilgeräten

Echtzeit‑Resonanzfeedback ist eine **Latenz‑Budget‑Aufgabe**. In einer Trainings‑App gibt es typischerweise zwei Feedback‑Kanäle mit unterschiedlichen Anforderungen:

1. **Visuelles Feedback** (Formant‑Tracks, Resonanz‑Score, Spektralhüllkurve): toleriert häufig 50–150 ms End‑to‑End, solange Updates stabil (z. B. 20–60 Hz) sind.
2. **Auditives Monitoring/Processing‑Feedback** (z. B. „Resonanz‑Gate“, Echtzeit‑Filter): erfordert deutlich geringere Latenzen (typisch < 20 ms; für Musik‑Monitoring werden teils < 10 ms als Ziel diskutiert).citeturn26search5turn17view1turn17view2

Da mobile Datenpfade variieren, ist es praxisnah, **Frame‑basierte Verarbeitung** zu wählen, die sowohl STFT/LPC‑Fenster (z. B. 20–40 ms) als auch IO‑Bursts integrieren kann.

**Sample‑Rates und Buffergrößen.** Android‑Dokumentation empfiehlt, nominal mit 44.1 kHz und 48 kHz rechnen zu können; typische native Buffergrößen umfassen u. a. 96–512 Frames (geräteabhängig).citeturn17view1 Für niedrige Latenz muss man „optimal sample rate“ und „frames per buffer“ dynamisch nutzen, statt zu hardcoden.citeturn17view1 Außerdem warnt Android explizit davor, Audio‑ und System‑Clock als identisch anzunehmen (leichte Drift), und betont die Notwendigkeit von Buffer‑Synchronisation bzw. ggf. asynchroner Sample‑Rate‑Konversion in manchen Setups (z. B. Mic vs. USB‑Output).citeturn17view1

**Callback‑Thread‑Regeln.** Androids AAudio beschreibt Buffertuning zur Latenzreduktion und empfiehlt bei Low‑Latency‑Anwendungen asynchrone Callbacks in höher priorisierten Threads; wichtig ist, dass die Callback‑Funktion ohne blockierende IO/Locks arbeitet.citeturn17view2 Auf iOS betont der AVAudioEngine‑Kontext für „voice processing“ und neue Nodes explizit: In Echtzeit‑Blöcken sind keine blockierenden Calls wie Speicherallokationen, Dispatch‑Calls oder Mutex‑Waits zulässig.citeturn23view1

**Praktische Zielwerte (gerüstet für Gerätevarianz).** Ein robustes Setup für Resonanz‑Features ist häufig:

- **Capture:** 48 kHz Mono, PCM16 oder Float32 (je nach API), weil 48 kHz auf Mobilgeräten häufig „native“ ist und mehr Headroom für Formant‑Analyse (> 4 kHz) bietet.citeturn17view1turn18view1  
- **Frame‑Size:** 10 ms „Transportframes“ (wie in WebRTC‑APM‑Kontexten üblich) zur Pipeline‑Taktung; darüber aggregiert man Analysefenster (z. B. 30 ms) mit Overlap.citeturn26search11turn32view0turn29view1  
- **Analysefenster:** 25–40 ms für LPC/Formanten (mit 75 % Overlap → ~100–160 Hz Update), plus zeitliche Glättung.citeturn32view0turn29view1turn36view0  

**Warum in Flutter nicht „alles“ im Dart‑UI‑Thread?** Flutter‑Performance‑Guides empfehlen, rechenintensive Aufgaben (die UI blockieren könnten) in Isolates auszulagern.citeturn27search3turn27search14 Für Audio ist das aber nicht nur „Performance“, sondern Determinismus: Die Audio‑Callback‑Thread‑Regeln (AAudio/iOS realtime blocks) kollidieren mit GC/Allokationsmustern und Event‑Loop‑Jitter; deshalb ist ein nativer DSP‑Core (FFI) oder zumindest ein sehr dünnes Callback + Ringbuffer‑Design in der Praxis deutlich stabiler.citeturn17view2turn23view1turn27search1

## Flutter‑Stack, Plugins und DSP‑Toolkits

### Vergleichstabelle: Kandidaten für Audio‑Capture und Echtzeit‑Pipeline

| Option | PCM‑Streaming für Analyse | Plattformen | Stärken | Schwächen/Risiken | Lizenz |
|---|---:|---|---|---|---|
| `record` | Ja (Stream‑Modus) | Android/iOS/… | Weit verbreitet; nutzt native Recorder (Android AudioRecord/MediaCodec; iOS AVFoundation) und bietet Stream‑/Codec‑Optionen.citeturn7view1 | Für „DSP‑nahe“ Low‑Latency‑Kontrolle begrenzt; Stream‑Abstraktion kann zusätzliche Buffer/Resampling verbergen (geräteabhängig).citeturn7view1turn17view1 | BSD‑3‑Clause.citeturn7view1 |
| `audio_streamer` | Ja (PCM Stream) | Android/iOS | Sehr direkter Zugriff auf PCM‑Frames; Beispiel zeigt Subscription auf `audioStream` (geeignet für Feature‑Pipelines).citeturn37search1turn6search3 | Funktionsumfang bewusst klein; je nach Device/OS begrenzte Low‑Latency‑Garantien; iOS‑Recorder‑Crash‑Fixes in Changelog zeigen Wartungsbedarf.citeturn37search19 | MIT.citeturn6search3 |
| `flutter_sound` | Ja (PCM Int16/Float32 Streams) | Android/iOS/Web | Explizit auf Streaming ausgelegt (Aufnahme/Playback als Dart‑Stream, PCM16/Float32).citeturn7view0turn6search14 | Größerer Stack, mehr bewegliche Teile; Lizenz ist „weak copyleft“ (MPL‑2.0) – meist unproblematisch, aber Änderungen am Plugin bleiben MPL.citeturn7view0 | MPL‑2.0.citeturn7view0 |
| `mic_stream` | Ja (PCM 8/16‑bit) | Android/iOS/macOS | Sehr direkt: liefert `Stream<Uint8List>`; Optionen inkl. Sample‑Rate/BufferSize‑Abfrage.citeturn7view2turn38search0 | GPL‑3.0 kann proprietäre App‑Distribution praktisch ausschließen (starkes Copyleft).citeturn38search0 | GPL‑3.0.citeturn38search0 |
| `sound_stream` | Ja (Uint8List) | Android/iOS | Fokus: gleichzeitiger Recorder+Player als Streams (kann für Live‑Feedback nützlich sein).citeturn6search4turn38search16 | „Early development stage“; GPL‑3.0 Lizenzrisiko wie oben.citeturn38search16 | GPL‑3.0.citeturn6search4 |
| `flutter_webrtc` | Indirekt (für Calls/VoIP) | Android/iOS/Desktop/Web | Reife Echtzeit‑Audio/Networking‑Pipeline (VoIP, Echo Cancelling im Stack); Plugin ist MIT‑lizenziert.citeturn13search0turn13search6 | Für Resonanz‑Analyse braucht man „raw PCM“ lokal; die API ist primär auf MediaStreams/Calls ausgelegt und PCM‑Extraction ist nicht Kernfeature.citeturn13search13turn6search1 | MIT.citeturn13search0turn13search6 |
| Eigenes Plugin: Android Oboe/AAudio + iOS (AVAudioEngine/AudioUnit) | Ja (voll kontrollierbar) | Android/iOS | Maximale Kontrolle über Buffer/Latency/Format; Oboe ist für High‑Performance Low‑Latency gedacht und Open‑Source.citeturn8search0turn8search4turn17view2turn23view1 | Höherer Implementationsaufwand (JNI/NDK, CMake, Audio Session/Route Handling); mehr QA nötig.citeturn17view1turn18view1 | Oboe: Apache‑2.0.citeturn8search0 |
| Superpowered SDK | Ja | Android/iOS/… | Industrieller Fokus auf Low‑Latency Audio‑SDK.citeturn12search18turn12search2 | Proprietäre Lizenz/Vertragsbindung; Kosten/Compliance.citeturn12search2turn12search6 | Proprietär.citeturn12search2 |

### DSP‑ und Speech‑Toolkits für Feature‑Extraktion via FFI

**Dart FFI und Plugin‑Mechanik.** Dart‑Native Apps können über `dart:ffi` C‑APIs aufrufen, inkl. Native‑Memory‑Zugriff; Flutter‑Plugins kombinieren Dart‑API mit plattformspezifischen Implementierungen (Kotlin/Swift) via Platform Channels.citeturn27search1turn27search2turn27search16 Das ist die Basis, um C/C++‑DSP‑Cores (FFT/LPC/MFCC) in einer Flutter‑App deterministisch zu nutzen.citeturn27search1turn27search16

**Bibliotheken (aus der Anfrage) – Fähigkeiten und Lizenzlage:**

- `libsndfile`: sehr verbreitet für Audio‑Datei‑I/O, unter LGPL (v2.1 oder v3 wählbar) – eher für Offline‑Import/Export als für Echtzeit‑DSP.citeturn12search3turn12search7  
- `aubio`: Audio‑Annotation (u. a. Pitch, MFCC) und Live‑Processing möglich; Lizenz GNU/GPL (starkes Copyleft) – für proprietäre Apps meist problematisch.citeturn11search5turn15search6turn11search13  
- `Essentia`: umfangreiche Audioanalyse‑Algorithmen (Spektral/Temporal/High‑Level); Lizenz AGPLv3 (starkes Netzwerk‑Copyleft) plus kommerzielle Optionen.citeturn11search2turn11search10turn15search7  
- `Kaldi`: ASR‑Toolkit (C++), Apache‑2.0; enthält dokumentierte MFCC‑Feature‑Berechnung und sogar Online‑Feature‑Pipelines (mfcc/plp/fbank) – für robuste Feature‑Extraktion geeignet, aber relativ „schwer“ für Mobile, wenn nur Formanten/Tilt gebraucht werden.citeturn11search3turn15search0turn15search1  
- `librosa` (Python): sehr nützlich als Research‑Baseline; Lizenz ISC; für Flutter‑Echtzeit ungeeignet, außer man nutzt es offline (Server/Notebook) zur Validierung von Algorithmen/Parameter‑Tuning.citeturn12search5turn12search9  

**Pragmatische Konsequenz:** Für eine Mobil‑Stimmtrainings‑App ist ein kleiner, gut testbarer C/C++‑DSP‑Core (FFT/STFT + LPC/Burg + einfache Tilt/HNR‑Maße) oft effizienter als vollständige ASR‑/MIR‑Toolkits; schwere Toolkits lohnen sich vor allem, wenn man zusätzlich ML‑Modelle oder umfangreiche Feature‑Pipelines (z. B. Kaldi‑kompatible MFCC+CMVN, Online‑Pipelines) plant.citeturn15search0turn17view2turn27search1

## Referenzarchitektur für eine Flutter‑Resonanzanalyse

Die Architektur sollte explizit zwischen **Audio‑Echtzeitpfad** (hart) und **UI/Business‑Logik** (weich) trennen. AAudio und AVAudioEngine/Realtime‑Blocks betonen, dass Echtzeit‑Callbacks nicht blockieren dürfen.citeturn17view2turn23view1 Flutter wiederum empfiehlt Isolates für rechenintensive Arbeit, um UI nicht zu blockieren.citeturn27search3turn27search14

```mermaid
flowchart TD
  A[Mic / Audio Input] --> B[Native Audio Capture\nAndroid: AAudio/Oboe\niOS: AVAudioEngine/AudioUnit]
  B --> C[Lock-free Ring Buffer\nPCM16/Float32 Frames]
  C --> D[Pre-Processing\nDC remove, pre-emphasis,\noptional noise gate/VAD]
  D --> E[Feature Extraction\nSTFT/FFT -> envelope\nLPC/Burg -> formants+bandwidths\nHNR, spectral tilt, MFCC optional]
  E --> F[Temporal Smoothing & Validity Gates\nvoicing, continuity, outlier rejection]
  F --> G[Flutter Event Stream\n(features @ 20-60 Hz)]
  G --> H[Visualization\nspectrogram, formant tracks,\nresonance score]
  H --> I[Feedback Loop\ninstructions, targets,\nhaptics/audio cues]
  F --> J[(Optional) Local Storage\nsession metrics, consented audio)]
```

**Bausteine und Datenflüsse:**

- **Capture‑Layer:** native PCM‑Frames in stabilen Bursts; auf Android idealerweise an `framesPerBuffer`/Burst‑Größen angepasst.citeturn17view1turn17view2turn8search0  
- **Ringbuffer:** verhindert UI‑Backpressure; erlaubt Feature‑Worker, Frames in eigenen Ticks (z. B. 10 ms) zu ziehen. (Die Motivation folgt direkt aus den „no blocking calls“‑Regeln in AAudio/iOS real‑time contexts.)citeturn17view2turn23view1  
- **Pre‑Emphasis:** in LPC‑Pipelines üblich; Praat dokumentiert eine +6 dB/Oktave‑Pre‑Emphasis oberhalb einer Grenzfrequenz samt Formel.citeturn36view0  
- **Feature‑Extraktion:** Formanten/Bandbreiten via LPC‑Root‑Solving; MFCCs optional für robustere Zielfunktionen/Ähnlichkeitsmaße.citeturn40view0turn40view2turn31view2turn2view0  
- **Smoothing/Gating:** Praat‑artige Oversampling‑Time‑Steps (Window/4) sind ein sinnvoller Ausgangspunkt; zusätzlich sind Kontinuitäts‑Constraints wichtig, da Formanttracker in natürlicher Sprache „springen“ können.citeturn32view0turn29view1  
- **UI:** Flutter rendert Features und leitet Feedback ab; schwere DSP bleibt außerhalb des UI‑Threads.citeturn27search3turn27search14  

## Beispielalgorithmen und Pseudocode für Flutter, Platform Channels und FFI

### Echtzeit‑Spektralanalyse in Dart (Prototyp‑Pfad)

Ziel: schnelle Iteration (z. B. mit `audio_streamer`), Feature‑Update ~20–60 Hz, ohne Garantie für „Audio‑Thread‑Purismus“. Die `audio_streamer`‑Beispiele zeigen ein Subscription‑Pattern auf einen PCM‑Stream.citeturn37search1turn6search3

```dart
// PSEUDOCODE (API-Namen können je nach Package-Version variieren)
//
// Idee:
// 1) PCM16-Frames aus dem Plugin empfangen
// 2) in Float [-1,1] wandeln
// 3) Ringbuffer füllen
// 4) alle 10 ms: STFT-Fenster ziehen, FFT, Spektralhüllkurve/Peaks berechnen
// 5) geglättete Features per Stream an UI liefern

final ring = FloatRingBuffer(capacitySamples: 48000 /* ~1s @48k */);

void onAudio(Uint8List pcmBytes) {
  final int16 = pcmBytes.buffer.asInt16List();
  for (final s in int16) {
    ring.push(s / 32768.0);
  }
}

Future<void> analysisLoop({required int fs}) async {
  const hopMs = 10;
  final hop = (fs * hopMs / 1000).round();  // z.B. 480 @ 48k
  final win = (fs * 0.030).round();         // 30 ms
  final window = hamming(win);

  while (running) {
    if (ring.available >= win) {
      final frame = ring.peekLast(win);
      final x = applyWindow(frame, window);

      final spectrum = fftRealToMag(x);  // O(N log N)
      final envelope = smoothLogSpectrum(spectrum); // z.B. liftering oder cepstral smoothing

      // Beispiel-Features (Resonanz-Proxy):
      // - Peak-Frequenzen im Envelope (formantähnliche Peaks)
      // - Tilt: lineare Regression in dB über Frequenzbereiche
      // - HNR: periodicity proxy (für echten HNR besser native/Praat-like)
      final peaks = findEnvelopePeaks(envelope, fs);
      final tilt = spectralSlope(envelope, fs, fMin: 500, fMax: 4000);

      featureSink.add(Features(
        timestamp: now(),
        peakHz: peaks.take(4).toList(),
        tiltDbPerOct: tilt,
      ));

      ring.drop(hop);
    } else {
      await Future.delayed(Duration(milliseconds: hopMs));
    }
  }
}
```

**Warum das nur „Prototyp“ ist:** Dieses Muster kann funktionieren, aber die deterministische Echtzeit‑Garantie ist schwächer, weil ein Dart‑Loop (auch in Isolates) nicht mit Audio‑Callback‑Threads gleichzusetzen ist. Flutter empfiehlt Isolates für größere Rechenarbeit, aber Audio‑Callbacks auf Plattformseite verlangen zusätzlich „no blocking calls“ und priorisierte Threads.citeturn27search14turn17view2turn23view1

### Echtzeit‑Formanten via native DSP‑Core (FFI‑Pfad, produktionsnäher)

**Kernidee:** FFT/LPC, Root‑Solving und Bandbreitenberechnung laufen in C/C++; Flutter erhält nur (a) pro Frame Formanten/Bandbreiten + Qualitätsflags, (b) optional komprimierte Visual‑Daten (z. B. 64‑Band Envelope). Dart FFI ist explizit für das Aufrufen nativer C‑APIs vorgesehen.citeturn27search1turn27search12

**Algorithmische Referenz (LPC→Formanten):** Praat beschreibt das Root‑basierte Vorgehen (Wurzeln, Stabilisierung, Verwerfen <50 Hz und nahe Nyquist).citeturn40view0 Eine konkrete Umrechnung Root‑Angle→Hz und Root‑Radius→Bandbreite ist dokumentiert und weithin verwendet.citeturn40view2

```c
// C PSEUDOCODE (DSP-Core)
// Input: float* x (windowed frame), N samples, fs
// Output: formant frequencies + bandwidths

typedef struct {
  int n;              // number of detected formants (<= maxFormants)
  float f_hz[6];      // F1..F6
  float bw_hz[6];     // bandwidths
  float confidence;   // 0..1 (heuristic)
} FormantFrame;

FormantFrame lpc_formants(const float* x, int N, int fs,
                          int lpcOrder, float fMaxHz) {
  // 1) pre-emphasis (optional) and window already applied upstream
  // 2) compute LPC coefficients (e.g., Burg)
  //    Praat uses Burg and documents pre-emphasis behavior. (Conceptual alignment)
  // 3) find roots of LPC polynomial
  // 4) keep roots in upper half-plane (conjugate pairs)
  // 5) convert:
  //    freqHz = angle(root) * fs / (2*pi)
  //    bwHz   = -0.5 * (fs/(2*pi)) * log(|root|)
  // 6) discard freq < 50Hz, freq > (fMaxHz or (fs/2 - 50)) etc.
  // 7) sort by freq ascending, take first K

  ...
}
```

```dart
// Dart FFI PSEUDOCODE
//
// 1) Build native library (Android .so via NDK/CMake; iOS .a/.xcframework)
// 2) Bind via dart:ffi (optionally generate with ffigen)
// 3) Call per analysis frame; return a small struct or write into out-buffers

final dylib = DynamicLibrary.open('libresonance_dsp.so');

typedef _LpcFormantsC = FormantFrameNative Function(
  Pointer<Float> x, Int32 n, Int32 fs, Int32 order, Float fMaxHz,
);
typedef _LpcFormantsDart = FormantFrameNative Function(
  Pointer<Float> x, int n, int fs, int order, double fMaxHz,
);

final lpcFormants = dylib.lookupFunction<_LpcFormantsC, _LpcFormantsDart>('lpc_formants');

FormantFrame analyzeFrame(Float32List frame, int fs) {
  // Native memory: allocate once and reuse to avoid per-frame allocations
  copyToNative(reusablePtr, frame);
  final nativeOut = lpcFormants(reusablePtr, frame.length, fs, 10, 5500.0);
  return nativeOut.toDart();
}
```

**Wichtig:** Die „no allocation/locking“‑Regeln gelten primär für den Audio‑Callback. Der DSP‑Core kann in einem eigenen Worker‑Thread laufen, solange die Übergabe Audio→Worker lock‑frei bzw. bounded ist.citeturn17view2turn23view1

### Platform‑Channel‑Variante (wenn man ohnehin native Audio‑Graphs nutzt)

Flutter‑Plugins sind offiziell dafür gedacht, plattformspezifische APIs (Kotlin/Swift) bereitzustellen; Platform Channels ermöglichen den Datenaustausch zwischen Dart und Host‑Code.citeturn27search2turn27search16

- Android‑Seite: Oboe/AAudio Callback → Ringbuffer → native DSP → EventChannel sendet Features (z. B. JSON oder FlatBuffers).
- iOS‑Seite: AVAudioEngine/AVAudioSinkNode (realtime block) → Ringbuffer → DSP → EventChannel.

Die AVAudioEngine‑WWDC‑Session betont, dass realtime Blocks keine blockierenden Calls enthalten dürfen; deshalb ist ein Tap/Callback‑Design mit minimaler Arbeit und Ringbuffer‑Weitergabe zentral.citeturn23view1

## Evaluation, Metriken, Testverfahren sowie prioritäre Datensätze und Papers

### Evaluationsmetriken

**Genauigkeit (Offline‑Ground‑Truth / Referenz):**

- **Formantfehler:** mittlerer absoluter Fehler (Hz) pro Formant + Ausreißer‑Rate; zusätzlich „Track continuity“ (Frame‑to‑Frame Sprünge). Formanttracker‑Evaluation in Fluent Speech wurde u. a. mit VTR‑TIMIT als Referenzkorpus motiviert.citeturn14search13turn16view2turn29view1  
- **F0‑Fehler:** MAE in Cent oder Hz, Voicing‑Decision‑Fehler; PTDB‑TUG liefert Mikrofon + Laryngograph und Referenz‑Pitch‑Trajektorien.citeturn14search2turn14search16turn14search10  
- **Robustheit gegen F0‑Bias/Formant‑Harmonic‑Interaktion:** explizit messen, weil LPC‑Burg & andere Methoden systematische Bias‑Muster zeigen können.citeturn29view1  

**Echtzeit‑Qualität:**

- **End‑to‑End‑Latenz:** Input‑Timestamp → Feature‑Update in UI; zusätzlich Jitter (Std‑Abw. der Update‑Intervalle). Android dokumentiert Mess‑/Schätzregeln und betont Gerätediversität.citeturn17view1turn17view2  
- **XRuns/Underruns:** insbesondere, wenn Buffergrößen aggressiv reduziert werden (AAudio‑XRun‑Count).citeturn17view2  
- **CPU/Batterie:** Profiling pro Device‑Klasse; Ziel: stabile 60 fps UI + stabile Audio‑Callbacks.

**Nutzer:innen‑Studien (Trainingseffekt, Usability):**

- Primäroutcomes: Verbesserung in Zielübungen (z. B. Vokal‑Formant‑Zielbereiche, Stabilität von Resonanz‑Score), Retention über Zeit.
- Sekundär: subjektive Verständlichkeit und „Hilfreichkeitsrating“ des Feedbacks, Abbruchraten, Fehlalarme in Lärm.

Eine relevante Brücke zur klinischen Literatur ist, dass ambulantes Stimm‑Biofeedback als Konzept untersucht wurde (wenn auch nicht speziell „Resonanz“); dort wird u. a. diskutiert, dass Evidenz zu Feedback‑Timing/Delay in der Stimmtherapie weniger klar ist als bei Extremitäten‑Motorik.citeturn26search2

### Priorisierte Datensätze

- **VTR‑TIMIT (Vocal Tract Resonances / Formant‑Trajektorien):** speziell für quantitative Evaluation automatischer VTR/Formant‑Extraktion aufgebaut; adressiert die zuvor fehlenden Standarddaten.citeturn16view2turn14search13  
- **PTDB‑TUG (Pitch Tracking):** Referenz‑F0 aus Laryngograph plus Mikrofon; geeignet für robuste F0‑Validierung und Voicing‑Gating.citeturn14search2turn14search10turn14search16  
- **Saarbrücker Stimmdatenbank / Saarbruecken Voice Database (Deutsch):** deutschsprachige Stimmaufnahmen (auch pathologisch) – besonders wertvoll für Robustheit und realistische Varianz (Stimmqualität/HNR‑Veränderungen).citeturn14search0turn14search4  
- **LibriSpeech (großskalige, frei verfügbare englische Lesesprache):** nützlich für breite akustische Varianz und Pipeline‑Stabilitätstests; frei verfügbar, umfangreich dokumentiert.citeturn28search1turn28search9  
- **DEMAND (Umgebungsgeräusche):** zum Noise‑Mixing und Robustheitstests (SNR‑Stufen, reale Geräuschkulissen).citeturn28search19turn28search11  
- **TIMIT (klassischer Referenzkorpus):** für vergleichbare Phonetik‑/ASR‑Tests; enthält zeit‑alignierte Transkriptionen und breit genutzte Standardaufteilung (Achtung: Lizenz/Distribution via LDC).citeturn28search12turn28search0  

### Priorisierte Papers und Primärquellen

- Vokaltrakt‑Transferfunktion, Formanten/Bandbreiten, Messbarkeit und Inversfilterung: Fleischer et al. (Transferfunktion, Formanten/Bandbreiten, „nicht direkt messbar“, inverse filtering).citeturn16view0  
- Source‑Filter‑Grundlagen (inkl. Bandbreitenbegriff, Filter/Resonator‑Konzept): akustisch‑phonetische Lehrunterlagen der entity["organization","University of Oxford","oxford, uk"].citeturn33view0  
- Formant‑Messfehler & Vergleich automatischer Methoden (inkl. Praat/Burg): Shadle et al. (PMC‑Review/Study).citeturn29view1  
- YIN für F0‑Schätzung: de Cheveigné & Kawahara (2002).citeturn5search12  
- MFCC‑Grundlage: Davis & Mermelstein (1980).citeturn2view0  
- Evaluationskorpora: Deng et al. (VTR‑Datenbank).citeturn16view2  
- Praat‑Methoden als Reproduzierbarkeits‑Baseline: Formant/HNR/MFCC/Time‑Step/LPC‑Dokumentation.citeturn5search10turn31view0turn31view2turn32view0turn36view0turn40view0  
- Spektrale Tilt‑Maße (H1‑H2) und deren Interpretation: Keating (Voice Quality Talk) + Henrich et al. (Modelle/Limitierungen).citeturn34view0turn34view1  
- Gesangsresonanz/Sängerformant (optional für Trainingsmodi): Berndtsson & Sundberg.citeturn35view1  

## Datenschutz, Berechtigungen und Deployment

### Plattform‑Berechtigungen und UX

**Android (RECORD_AUDIO, Runtime Permissions).** Für Audioaufnahme muss `<uses-permission android:name="android.permission.RECORD_AUDIO" />` gesetzt werden; `RECORD_AUDIO` ist als „dangerous permission“ klassifiziert und erfordert seit Android 6 (API 23) eine Laufzeitabfrage.citeturn20view1 Die Android‑Guidelines betonen „in context“ fragen, Abbruch erlauben und bei Verweigerung graceful degradieren; zudem weisen sie darauf hin, dass ab Android 12 Privacy‑Indikatoren Zugriff auf Mikro/Kamera signalisieren.citeturn20view2

**iOS (Record Permission, Info.plist Keys).** Apple beschreibt, dass die App vor Aufnahme Nutzer:innen‑Permission einholen muss; ohne Erlaubnis wird nur Stille aufgezeichnet, und man kann die Permission explizit via `requestRecordPermission` anfragen.citeturn20view0 Zusätzlich müssen Datenschutz‑`Info.plist`‑Keys korrekt gesetzt sein (z. B. NSMicrophoneUsageDescription), andernfalls sind Zugriff und App‑Review/Runtime problematisch; Apple‑Archivdokumentation erwähnt diese Keys explizit als Voraussetzung für Mikrofonzugriff.citeturn21view0turn19search0

### GDPR‑/EU‑Datenschutz‑Einordnung (praxisrelevant für Voice‑Apps)

Stimmaufnahmen sind personenbezogene Daten. „Biometrische Daten“ sind in den GDPR‑Definitionen als Daten aus spezifischer technischer Verarbeitung definiert, die eine eindeutige Identifikation erlauben/bestätigen.citeturn22search8 „Biometrische Daten zum Zweck der eindeutigen Identifizierung“ fallen unter besondere Kategorien (Art. 9) und sind grundsätzlich verboten, außer es greifen Ausnahmen.citeturn22search1 Der entity["organization","European Data Protection Board","eu data protection board"] weist in Guidelines zu Voice Assistants darauf hin, dass Voice‑Daten inhärent biometrischer Natur sein können und bei Identifikationszwecken Art. 6‑Rechtsgrundlage plus Art. 9‑Ausnahme erforderlich wird.citeturn22search2

**Praktische Design‑Konsequenzen für eine Stimmtrainings‑App:**

- **Privacy by design:** Verarbeitung möglichst on‑device; Audio nur speichern, wenn Nutzer:innen explizit zustimmen (z. B. „Sitzung aufzeichnen“), mit klarer Löschfunktion und kurzer Aufbewahrungsdauer.
- **Datenminimierung:** Für Feedback reichen oft Feature‑Zeitreihen (Formanttracks, Tilt, HNR, Score) statt Roh‑Audio.
- **Transparenz:** Klare Zweckbeschreibung im Permission‑Prompt/Onboarding (Android „in context“; iOS Usage‑Description).citeturn20view2turn21view0turn19search0

### Deployment‑Unterschiede iOS vs. Android (audio‑technisch)

- **Gerätevarianz:** Android betont unterschiedliche native Buffergrößen und Sample‑Rates; App muss dynamisch anpassen.citeturn17view1  
- **Buffer‑/Latency‑Tuning:** AAudio erlaubt explizites Buffertuning und dokumentiert Burst‑basierte Mechanik; das kann für stabile low‑latency Analyse entscheidend sein.citeturn17view2  
- **iOS Session‑Preferences:** Apple‑Archiv‑QA erklärt, dass „preferred“ Sample‑Rate/Buffer‑Duration nur Hints sind und erst nach Aktivierung „current“ Werte zuverlässig sind; Beispiel zeigt Wunsch nach 5 ms Bufferdauer, aber mit dem Hinweis auf hardwareabhängige Realwerte.citeturn18view1  
- **Echtzeit‑Constraints in iOS‑Audio‑Graph:** In AVAudioEngine‑Realtime‑Blöcken keine blockierenden Calls; daher Ringbuffer‑Design und minimales Callback‑Work.citeturn23view1  

**Zusammenfassung für Release‑Engineering:** Für stabile Resonanz‑Messung müssen Build‑Pipelines (Android NDK/CMake, iOS static libs/xcframework), deterministisches Memory‑Management (FFI‑Buffers reuse), Device‑Matrix‑Tests (mindestens 44.1/48 kHz Pfade) und Permission‑Flows (Store‑Compliance) zusammen gedacht werden.citeturn27search2turn27search1turn17view1turn20view1turn20view0