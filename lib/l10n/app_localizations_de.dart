// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Voxa';

  @override
  String get navHome => 'Start';

  @override
  String get navGoal => 'Ziel';

  @override
  String get navPractice => 'Training';

  @override
  String get navRecord => 'Aufnahme';

  @override
  String get navHistory => 'Verlauf';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get homeEyebrow => 'Geschlechtsbejahendes Stimmtraining';

  @override
  String get homeTitle =>
      'Ruhiges Training. Klares Feedback. Deine Stimme, dein Ziel.';

  @override
  String get homeSubtitle =>
      'Verfolge Training lokal, definiere deine Zieltonhöhe und arbeite mit sanftem Live-Feedback.';

  @override
  String get homeReadyTitle => 'Bereit für deine nächste Session?';

  @override
  String get homeReadySubtitle =>
      'Dein Ziel, der Plan für heute und ein klarer nächster Schritt.';

  @override
  String get homePrimaryCta => 'Training starten';

  @override
  String get homeSecondaryCta => 'Ziel festlegen';

  @override
  String get homeCurrentTarget => 'Aktuelles Ziel';

  @override
  String get homeNoTarget => 'Noch kein Ziel gespeichert';

  @override
  String get homeTargetHintMissing =>
      'Wähle zuerst ein Startziel, bevor du beginnst.';

  @override
  String get homeTargetHintSaved =>
      'Du kannst das Ziel jederzeit anpassen, ohne frühere Sessions zu verlieren.';

  @override
  String get homeEditTarget => 'Ziel bearbeiten';

  @override
  String get homeTodayPlan => 'Plan für heute';

  @override
  String get homePlannedSessionCta => 'Heutige Session starten';

  @override
  String get homeCustomSessionTitle => 'Eigene Session';

  @override
  String get homeCustomSessionBody =>
      'Nutze das Live-Setup, um Modus, Fokus und Dauer vor dem Start anzupassen.';

  @override
  String get homeCustomSessionCta => 'Eigene Session einrichten';

  @override
  String homePlanDuration(int value) {
    return '$value Min Session';
  }

  @override
  String get homeNoReminderHint =>
      'Noch keine Erinnerung. Füge in den Einstellungen eine hinzu, wenn du einen sanften Anstoß willst.';

  @override
  String homeNextReminder(String value) {
    return 'Nächste Erinnerung $value';
  }

  @override
  String get homeStartNow => 'Jetzt starten';

  @override
  String get homeRecordSample => 'Probe aufnehmen';

  @override
  String get homeLastSession => 'Letzte Session';

  @override
  String get homeNoSessions => 'Noch keine Sessions';

  @override
  String get homeLatestResult => 'Letztes Ergebnis';

  @override
  String homeLatestInRange(int value) {
    return '$value% im Zielbereich';
  }

  @override
  String homeLatestAverageSummary(String pitch, String target) {
    return '$pitch Durchschnitt · $target';
  }

  @override
  String get homeViewDetails => 'Details ansehen';

  @override
  String get onboardingTitle => 'Willkommen bei Voxa';

  @override
  String get onboardingBody =>
      'Lege eine Starttonhöhe fest und erlaube Mikrofonzugriff, wenn du bereit bist. Du kannst alles später anpassen.';

  @override
  String get onboardingWelcomeCardTitle => 'Einfach starten';

  @override
  String get onboardingWelcomeCardBody =>
      'Voxa nutzt automatisch die Sprache deines Geräts. Sprache und Darstellung kannst du später in den Einstellungen ändern.';

  @override
  String get onboardingContinue => 'Weiter';

  @override
  String get onboardingTargetTitle => 'Wähle dein Ziel';

  @override
  String get onboardingTargetSubtitle =>
      'Starte mit einer Vorgabe und verfeinere sie später. Voxa hält das bewusst flexibel.';

  @override
  String get onboardingMoreOptionsBody =>
      'Nutze ein eigenes Ziel, wenn du deinen Bereich bereits kennst.';

  @override
  String get onboardingSkipForNow => 'Vorerst überspringen';

  @override
  String get goalTitle => 'Zielsetzung';

  @override
  String get goalSubtitle =>
      'Wähle eine Zieltonhöhe, die Erkundung unterstützt statt Druck zu erzeugen.';

  @override
  String get goalHelper =>
      'Pitch ist nur ein Teil der Stimmwahrnehmung. Diese Vorschläge sind Richtwerte, keine Regeln.';

  @override
  String get goalEyebrow => 'ZIEL';

  @override
  String get goalPageTitle => 'Ziel-Setup';

  @override
  String get goalPageSubtitle =>
      'Halte die Hauptentscheidung erst einfach. Feintuning kannst du später machen, wenn du es brauchst.';

  @override
  String get goalChoosePresetTitle => 'Wähle eine Vorgabe';

  @override
  String get goalMeasureTitle => 'Aus deiner Stimme messen';

  @override
  String get goalMeasureBody =>
      'Sprich einige Sekunden natürlich und lass Voxa eine Starttonhöhe vorschlagen.';

  @override
  String get goalMeasureAction => 'Jetzt messen';

  @override
  String get goalMoreOptionsTitle => 'Weitere Optionen';

  @override
  String get goalMoreOptionsBody =>
      'Nutze eine eigene Tonhöhe, kalibriere die Lautstärke oder analysiere eine Audiodatei.';

  @override
  String get goalPresetFeminine => 'Feminin';

  @override
  String get goalPresetAndrogynous => 'Androgyn';

  @override
  String get goalPresetMasculine => 'Maskulin';

  @override
  String get goalPresetCustom => 'Individuell';

  @override
  String get goalMinLabel => 'Minimum Hz';

  @override
  String get goalMaxLabel => 'Maximum Hz';

  @override
  String get goalTargetLabel => 'Zieltonhöhe';

  @override
  String get goalSave => 'Ziel speichern';

  @override
  String get goalSaved => 'Ziel aktualisiert';

  @override
  String get goalImportFileAction => 'Audiodatei verwenden';

  @override
  String get goalImportFileHelp =>
      'Importiere eine Aufnahme wie WAV, M4A, AAC, MP3, FLAC, OGG, OPUS, MP4 oder CAF und lass Voxa aus dem stimmhaften Median eine Zieltonhöhe vorschlagen.';

  @override
  String get goalImportFileUnsupported =>
      'Dieses Aufnahmeformat wird noch nicht unterstützt. Versuche WAV, M4A, AAC, MP3, FLAC, OGG, OPUS, MP4 oder CAF.';

  @override
  String get goalImportFileError =>
      'Die ausgewählte Audiodatei konnte nicht analysiert werden.';

  @override
  String goalImportFileSuccess(int value) {
    return 'Vorgeschlagenes Ziel: $value Hz';
  }

  @override
  String get goalVolumeTitle => 'Ziel-Lautstärke';

  @override
  String get goalVolumeNotSet => 'Noch nicht kalibriert';

  @override
  String get goalVolumeCalibrateAction => 'Mit Mikrofon kalibrieren';

  @override
  String get goalVolumeHelp =>
      'Sprich laut und klar in deinem üblichen Abstand zum Handy. Das Lautstärke-Feedback funktioniert am besten, wenn der Abstand später ähnlich bleibt.';

  @override
  String get goalVolumeCalibratingHint =>
      'Sprich einige Sekunden laut und klar in deinem üblichen Abstand zum Handy.';

  @override
  String get goalVolumeCalibrateError =>
      'Die Ziel-Lautstärke konnte nicht erfasst werden.';

  @override
  String goalVolumeCalibrated(int value) {
    return 'Ziel-Lautstärke auf $value dBFS gesetzt';
  }

  @override
  String get goalValidationMin => 'Bitte ein gültiges Minimum eingeben.';

  @override
  String get goalValidationMax => 'Bitte ein gültiges Maximum eingeben.';

  @override
  String get goalValidationOrder =>
      'Das Maximum muss höher als das Minimum sein.';

  @override
  String get goalValidationTarget => 'Bitte eine gültige Zieltonhöhe eingeben.';

  @override
  String get goalValidationBounds => 'Wähle ein Ziel zwischen 70 und 350 Hz.';

  @override
  String get practiceTitle => 'Training';

  @override
  String get practiceSubtitle =>
      'Ein klares Signal zur Zeit: deine aktuelle Tonhöhe im Verhältnis zu deiner Zieltonhöhe.';

  @override
  String get practicePermissionTitle => 'Mikrofonzugriff erforderlich';

  @override
  String get practicePermissionBody =>
      'Erlaube den Mikrofonzugriff, um Live-Pitch-Feedback zu nutzen.';

  @override
  String get practiceSetTargetFirst => 'Lege zuerst dein Ziel fest';

  @override
  String get practiceOpenTargetSetup => 'Ziel-Setup öffnen';

  @override
  String get practiceGrantPermission => 'Zugriff erlauben';

  @override
  String get practiceOpenSettings => 'Einstellungen öffnen';

  @override
  String get practiceStart => 'Start';

  @override
  String get practicePause => 'Pause';

  @override
  String get practiceResume => 'Fortsetzen';

  @override
  String get practiceStop => 'Stop';

  @override
  String get practiceFinish => 'Beenden';

  @override
  String get practiceSwitchToRecord => 'Zur Aufnahme wechseln';

  @override
  String get practiceEyebrow => 'TRAINING';

  @override
  String get practiceLiveFeedbackTitle => 'Live-Feedback';

  @override
  String get practiceSessionSetupButton => 'Session-Setup';

  @override
  String get practiceSessionSetupTitle => 'Session-Setup';

  @override
  String get practiceSessionTypeLive => 'Live';

  @override
  String get practiceSessionTypeRecord => 'Probe aufnehmen';

  @override
  String get practiceExerciseFocus => 'Trainingsfokus';

  @override
  String get practiceSessionLength => 'Session-Länge';

  @override
  String get practiceVolumeLabel => 'Lautstärke';

  @override
  String get practiceVolumeAtTarget => 'Passt';

  @override
  String get practiceVolumeQuiet => 'Zu leise';

  @override
  String get practiceVolumeLoud => 'Zu laut';

  @override
  String get practiceVolumeUnclear => 'Unklar';

  @override
  String get practiceVolumeNotSet => 'Ziel setzen';

  @override
  String get practiceVolumeDistanceHint =>
      'Halte das Handy in einem ähnlichen Abstand, damit das Lautstärke-Ziel sinnvoll bleibt.';

  @override
  String get practiceVolumeSetupHint =>
      'Lege unter Ziel eine Ziel-Lautstärke fest, damit Voxa deine übliche laute und klare Stimme vergleichen kann.';

  @override
  String get practicePitchLabel => 'Aktuelle Tonhöhe';

  @override
  String get practiceTimeInRange => 'Im Zielbereich';

  @override
  String get practiceVoicedTime => 'Stimmhafte Zeit';

  @override
  String get practiceTimeAtTarget => 'Am Ziel';

  @override
  String get practiceTrackedTime => 'Ausgewertete Zeit';

  @override
  String get practiceStatusLow => 'Versuche es etwas höher';

  @override
  String get practiceStatusInRange => 'Du bist im Zielbereich';

  @override
  String get practiceStatusAtTarget => 'Du bist am Ziel';

  @override
  String get practiceStatusHigh => 'Versuche es etwas tiefer';

  @override
  String get practiceStatusUnvoiced => 'Sprich ruhig und natürlich weiter';

  @override
  String get practiceQualityStrong => 'Stabil';

  @override
  String get practiceQualityWeak => 'Schwaches Signal';

  @override
  String get practiceQualityUnstable => 'Unstabil';

  @override
  String get practiceQualitySilent => 'Still';

  @override
  String get practiceStatInRange => 'Im Zielbereich';

  @override
  String get practiceStatTimeLeft => 'Zeit übrig';

  @override
  String get resonanceTitle => 'Resonanz';

  @override
  String get resonanceStateInsufficient => 'Signal unklar';

  @override
  String get resonanceStateDark => 'Zu dunkel';

  @override
  String get resonanceStateBalanced => 'Ausgewogen';

  @override
  String get resonanceStateBright => 'Zu hell';

  @override
  String get resonanceStateUnstable => 'Unstabil';

  @override
  String get resonanceHelperInsufficient =>
      'Nutze erst einen klaren stimmhaften Klang, bevor du Resonanz anpasst.';

  @override
  String get resonanceHelperDarkSound =>
      'Lass den Klang etwas weiter nach vorne kommen.';

  @override
  String get resonanceHelperBalancedSound =>
      'Die Resonanz wirkt ausgewogen. Bleib bei diesem Klangraum.';

  @override
  String get resonanceHelperBrightSound =>
      'Nimm die scharfe Kante etwas heraus und halte den Klang leicht.';

  @override
  String get resonanceHelperDarkSpeech =>
      'Lass die Sprache etwas weiter vorne resonieren.';

  @override
  String get resonanceHelperBalancedSpeech =>
      'Diese Resonanz wirkt für Sprache stabil und ausgeglichen.';

  @override
  String get resonanceHelperBrightSpeech =>
      'Die Sprache klingt etwas hell. Nimm die Kante leicht heraus.';

  @override
  String get resonanceHelperUnstable =>
      'Halte den Klang erst ruhig, bevor du etwas veränderst.';

  @override
  String get sessionDetailResonance => 'Resonanz-Zusammenfassung';

  @override
  String get sessionDetailResonanceBalanced => 'Ausgewogene Zeit';

  @override
  String get practiceTargetLabel => 'Ziel';

  @override
  String get practiceModeLabel => 'Tracking-Modus';

  @override
  String get practiceModeSound => 'Klang';

  @override
  String get practiceModeSpeech => 'Sprache';

  @override
  String get practiceSoundIdle =>
      'Nutze diesen Modus für gehaltene Klänge wie Summen oder lange Vokale.';

  @override
  String get practiceSpeechIdle =>
      'Nutze diesen Modus für gesprochene Sätze. Das Feedback folgt der Sprechbasis statt jeder kleinen Melodiebewegung.';

  @override
  String get practiceSoundRunning => 'Die Klanganalyse ist aktiv.';

  @override
  String get practiceSpeechRunning => 'Die Sprach-Basisanalyse ist aktiv.';

  @override
  String get practicePaused => 'Die Analyse ist pausiert.';

  @override
  String get practiceError => 'Die Live-Analyse ist derzeit nicht verfügbar.';

  @override
  String get practiceReviewReady => 'Prüfe deine Session';

  @override
  String get practiceReviewTitle => 'Session-Rückblick';

  @override
  String get practiceChartNow => 'jetzt';

  @override
  String get practiceChartDrag => 'ziehen';

  @override
  String get practiceSessionStopped => 'Trainingssession beendet';

  @override
  String get practiceExerciseGeneralLabel => 'Freies Training';

  @override
  String get practiceExerciseWarmupResetLabel => 'Warm-up Reset';

  @override
  String get practiceExerciseLaxVoxLabel => 'LaxVox';

  @override
  String get practiceExerciseStrawBubblesLabel => 'Strohhalmblasen';

  @override
  String get practiceExerciseLipTrillsLabel => 'Lippentriller';

  @override
  String get practiceExerciseResonanceHumLabel => 'Resonanz-Summen';

  @override
  String get practiceExercisePitchGlidesLabel => 'Pitch-Glides';

  @override
  String get practiceExerciseTargetSpeechLabel => 'Zielsprache';

  @override
  String get practiceExerciseReadingTransferLabel => 'Lese-Transfer';

  @override
  String get practiceExerciseChestResonanceLabel => 'Brustresonanz';

  @override
  String get practiceExerciseArticulationLabel => 'Artikulation';

  @override
  String get practiceExerciseGeneralSummary =>
      'Freies Training mit Timer und Live-Feedback.';

  @override
  String get practiceExerciseWarmupResetSummary =>
      'Sanfte Lockerung vor gezielterem Stimmtraining.';

  @override
  String get practiceExerciseLaxVoxSummary =>
      'SOVT mit Wasserwiderstand für einen leichten, effizienten Stimmeinsatz.';

  @override
  String get practiceExerciseStrawBubblesSummary =>
      'Blubbern mit dem Strohhalm für kurze, häufige Resets.';

  @override
  String get practiceExerciseLipTrillsSummary =>
      'Lockere Lippentriller mit Luftfluss und leichter Tonbewegung.';

  @override
  String get practiceExerciseResonanceHumSummary =>
      'Summen im Vordergesicht für eine leichtere Resonanzplatzierung.';

  @override
  String get practiceExercisePitchGlidesSummary =>
      'Langsame Sirenen und Glides, um angenehme Tonhöhe zu finden und zu stabilisieren.';

  @override
  String get practiceExerciseTargetSpeechSummary =>
      'Kurze Sätze in deiner Zielstimme.';

  @override
  String get practiceExerciseReadingTransferSummary =>
      'Übertrage dein Ziel in verbundene Sprache.';

  @override
  String get practiceExerciseChestResonanceSummary =>
      'Verankerung im Körper und Erkundung der Brustresonanz.';

  @override
  String get practiceExerciseArticulationSummary =>
      'Klare Konsonanten und Projektion ohne Halsdruck.';

  @override
  String get recordTitle => 'Aufnehmen und analysieren';

  @override
  String get recordSubtitle =>
      'Nimm eine Trainingsprobe auf und speichere eine ruhige, kompakte Zusammenfassung für später.';

  @override
  String get recordEyebrow => 'AUFNAHME';

  @override
  String get recordPageTitle => 'Probe aufnehmen';

  @override
  String get recordPageSubtitle =>
      'Einrichten, aufnehmen und erst danach speichern.';

  @override
  String get recordSelectText => 'Übungstext';

  @override
  String get recordPracticeTextTitle => 'Übungstext';

  @override
  String get recordNoText => 'Freies Sprechen';

  @override
  String get recordLiveFeedback =>
      'Live-Feedback während der Aufnahme anzeigen';

  @override
  String get recordStart => 'Aufnahme starten';

  @override
  String get recordStop => 'Aufnahme stoppen';

  @override
  String get recordRecordingInProgress => 'Aufnahme läuft';

  @override
  String get recordSaveFailed =>
      'Die Aufnahme konnte nicht gespeichert werden.';

  @override
  String get recordPitchLabel => 'Tonhöhe';

  @override
  String get recordStatusLabel => 'Status';

  @override
  String get recordReviewTitle => 'Rückblick';

  @override
  String get recordPlayRecording => 'Aufnahme abspielen';

  @override
  String get recordStopPlayback => 'Wiedergabe stoppen';

  @override
  String get recordAvgLabel => 'Durchschnitt';

  @override
  String get recordRangeLabel => 'Bereich';

  @override
  String get recordInRangeLabel => 'Im Ziel';

  @override
  String get recordAtTargetLabel => 'Am Ziel';

  @override
  String get recordSoundModeHint =>
      'Im Klangmodus übst du gehaltene Klänge wie Summen, lange Vokale oder resonantes \"mmm\".';

  @override
  String get recordSaved => 'Session gespeichert';

  @override
  String get historyTitle => 'Verlauf';

  @override
  String get historySubtitle =>
      'Vergangene Sessions sollen informativ und bestärkend wirken, nie korrigierend.';

  @override
  String get historyEmptyTitle => 'Noch keine Sessions';

  @override
  String get historyEmptyBody =>
      'Nimm eine Session auf, um deinen Fortschritt lokal auf diesem Gerät zu verfolgen.';

  @override
  String get historyDelete => 'Löschen';

  @override
  String get historyDeleteConfirmTitle => 'Session löschen?';

  @override
  String get historyDeleteConfirmBody =>
      'Dadurch werden die Session-Daten und die lokale Aufnahme entfernt.';

  @override
  String get historyDeleteConfirmAction => 'Session löschen';

  @override
  String get historyDeleteCancel => 'Abbrechen';

  @override
  String get sessionDetailTitle => 'Session-Details';

  @override
  String get sessionDetailNotFound => 'Session nicht gefunden.';

  @override
  String get sessionDetailPlayback => 'Wiedergabe';

  @override
  String get sessionDetailPlaybackStop => 'Wiedergabe stoppen';

  @override
  String get sessionDetailTarget => 'Gespeicherter Zielbereich';

  @override
  String get sessionDetailPitchContour => 'Pitch-Verlauf';

  @override
  String sessionDetailAtTargetPercent(int value) {
    return '$value% am Ziel';
  }

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsSubtitle =>
      'Halte Sprache, Darstellung und Datenumgang einfach und transparent.';

  @override
  String get settingsEyebrow => 'EINSTELLUNGEN';

  @override
  String get settingsOverviewSubtitle =>
      'Halte die Übersicht kurz. Öffne Details nur dann, wenn du sie brauchst.';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsAppearance => 'Darstellung';

  @override
  String get settingsLanguageSubtitle =>
      'Wähle, wie Voxa spricht und aussieht.';

  @override
  String get settingsLocaleSystem => 'Gerätesprache';

  @override
  String settingsLanguageDeviceHint(String value) {
    return 'Aktuelle App-Sprache: $value';
  }

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Hell';

  @override
  String get settingsThemeDark => 'Dunkel';

  @override
  String get settingsAnalysis => 'Analyseoptionen';

  @override
  String get settingsAnalysisSubtitle =>
      'Bestimme, wie nachsichtig sich Live- und Aufnahme-Feedback anfühlen sollen.';

  @override
  String get settingsSmoothing => 'Pitch-Glättung';

  @override
  String get settingsTolerance => 'Zieltoleranz';

  @override
  String get settingsToleranceHelp =>
      'Eine kleine Toleranz sorgt dafür, dass Abweichungen um wenige Hertz noch als passend zählen.';

  @override
  String get settingsVolumeTolerance => 'Lautstärke-Toleranz';

  @override
  String get settingsVolumeToleranceHelp =>
      'Ein breiterer Korridor lässt mehr natürliche Lautstärke-Schwankung zu und hält die Stimme trotzdem klar.';

  @override
  String get settingsLiveFeedback => 'Live-Feedback während der Aufnahme';

  @override
  String get settingsTrainingPlanTitle => 'Trainingsplan';

  @override
  String get settingsTrainingPlanSubtitle =>
      'Halte Erinnerungen unterstützend und vorhersehbar.';

  @override
  String get settingsTrainingPlanSameDaily => 'Jeden Tag gleich';

  @override
  String get settingsTrainingPlanByWeekday => 'Nach Wochentag';

  @override
  String get settingsTrainingPlanEveryDay => 'Jeden Tag';

  @override
  String get settingsSyncTitle => 'Google-Sync';

  @override
  String get settingsSyncSubtitle =>
      'Halte Zusammenfassungen synchron, ohne Audiodateien vom Gerät zu verschieben.';

  @override
  String get settingsSyncBody =>
      'Einstellungen, Ziel und gespeicherte Session-Zusammenfassungen können über den versteckten App-Speicher deines Google-Kontos synchronisiert werden.';

  @override
  String get settingsSyncAudioNote =>
      'Audioaufnahmen bleiben lokal auf dem jeweiligen Gerät und werden nicht mit der Cloud synchronisiert.';

  @override
  String get settingsSyncUnavailable =>
      'Google-Sync ist auf Android und iOS verfügbar, sobald Google OAuth für diese App eingerichtet ist.';

  @override
  String get settingsSyncConnected => 'Verbunden';

  @override
  String get settingsSyncNotConnected => 'Nicht verbunden';

  @override
  String get settingsSyncUnavailableDevice =>
      'Auf diesem Gerät nicht verfügbar';

  @override
  String get settingsSyncConnectedAs => 'Verbunden als';

  @override
  String get settingsSyncLastSynced => 'Zuletzt synchronisiert';

  @override
  String get settingsSyncConnect => 'Google-Konto verbinden';

  @override
  String get settingsSyncDisconnect => 'Verbindung trennen';

  @override
  String get settingsSyncNow => 'Jetzt synchronisieren';

  @override
  String get settingsPrivacy => 'Privatsphäre';

  @override
  String get settingsPrivacyBody =>
      'Voxa speichert Ziele, Sessions und Aufnahmen im MVP lokal auf diesem Gerät.';

  @override
  String get settingsPrivacySubtitle =>
      'Erkläre den Umgang mit Daten klar und halte das Risiko klein.';

  @override
  String get settingsResetTitle => 'Lokale Daten zurücksetzen';

  @override
  String get settingsResetBody =>
      'Lösche alle gespeicherten Ziele, Sessions und Aufnahmen von diesem Gerät.';

  @override
  String get settingsDataSubtitle =>
      'Halte destruktive Aktionen getrennt von alltäglichen Einstellungen.';

  @override
  String get settingsResetAction => 'Daten zurücksetzen';

  @override
  String get settingsResetConfirmTitle => 'Alle lokalen Daten löschen?';

  @override
  String get settingsResetConfirmBody =>
      'Das kann nicht rückgängig gemacht werden.';

  @override
  String get settingsResetConfirmAction => 'Alles löschen';

  @override
  String get settingsResetDone => 'Lokale Daten gelöscht';

  @override
  String get settingsLocaleEnglish => 'Englisch';

  @override
  String get settingsLocaleGerman => 'Deutsch';

  @override
  String get settingsAddReminder => 'Erinnerung hinzufügen';

  @override
  String get languageLabel => 'Sprache';

  @override
  String get commonSave => 'Speichern';

  @override
  String get commonDone => 'Fertig';

  @override
  String get commonBack => 'Zurück';

  @override
  String get commonClose => 'Schließen';

  @override
  String get commonDiscard => 'Verwerfen';

  @override
  String get commonRepeat => 'Wiederholen';

  @override
  String get commonMin => 'Min';

  @override
  String get commonMax => 'Max';

  @override
  String get commonUnitHz => 'Hz';

  @override
  String get commonUnitDb => 'dB';

  @override
  String get commonUnitDbfs => 'dBFS';

  @override
  String get commonLoading => 'Wird geladen...';

  @override
  String commonHz(String value) {
    return '$value Hz';
  }

  @override
  String commonRangeHz(String min, String max) {
    return '$min-$max Hz';
  }

  @override
  String commonPercent(String value) {
    return '$value%';
  }

  @override
  String commonSeconds(String value) {
    return '${value}s';
  }

  @override
  String commonToleranceHz(String value) {
    return '±$value Hz';
  }

  @override
  String commonToleranceDb(String value) {
    return '±$value dB';
  }

  @override
  String commonDbfsTolerance(String value, String tolerance) {
    return '$value dBFS ± $tolerance dB';
  }

  @override
  String commonMillisecondsShort(int value) {
    return '$value ms';
  }

  @override
  String commonMinutesShort(int value) {
    return '$value Min';
  }

  @override
  String get weekdayMonday => 'Montag';

  @override
  String get weekdayTuesday => 'Dienstag';

  @override
  String get weekdayWednesday => 'Mittwoch';

  @override
  String get weekdayThursday => 'Donnerstag';

  @override
  String get weekdayFriday => 'Freitag';

  @override
  String get weekdaySaturday => 'Samstag';

  @override
  String get weekdaySunday => 'Sonntag';

  @override
  String get practiceTextWarmupTitle => 'Warm-up-Absatz';

  @override
  String get practiceTextWarmupBody =>
      'Ich atme ruhig ein und spreche heute mit einer stabilen, angenehmen Stimme.';

  @override
  String get practiceTextDailyTitle => 'Alltags-Check-in';

  @override
  String get practiceTextDailyBody =>
      'Meine Stimme darf sich verändern, und ich kann auf eine Weise üben, die sich unterstützend und nachhaltig anfühlt.';
}
