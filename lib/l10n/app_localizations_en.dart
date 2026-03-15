// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Voxa';

  @override
  String get navHome => 'Home';

  @override
  String get navGoal => 'Goal';

  @override
  String get navPractice => 'Practice';

  @override
  String get navRecord => 'Record';

  @override
  String get navHistory => 'History';

  @override
  String get navSettings => 'Settings';

  @override
  String get homeEyebrow => 'Gender-affirming voice practice';

  @override
  String get homeTitle =>
      'Calm training. Clear feedback. Your voice, your goal.';

  @override
  String get homeSubtitle =>
      'Track practice locally, shape your target pitch, and work with gentle real-time feedback.';

  @override
  String get homeReadyTitle => 'Ready for your next session?';

  @override
  String get homeReadySubtitle =>
      'Your target, today’s plan, and one clear next step.';

  @override
  String get homePrimaryCta => 'Start practice';

  @override
  String get homeSecondaryCta => 'Set your target';

  @override
  String get homeCurrentTarget => 'Current target';

  @override
  String get homeNoTarget => 'No target saved yet';

  @override
  String get homeTargetHintMissing =>
      'Choose a starting target before you begin.';

  @override
  String get homeTargetHintSaved =>
      'You can refine this anytime without losing past sessions.';

  @override
  String get homeEditTarget => 'Edit target';

  @override
  String get homeTodayPlan => 'Today\'s plan';

  @override
  String get homePlannedSessionCta => 'Start today\'s session';

  @override
  String get homeCustomSessionTitle => 'Custom session';

  @override
  String get homeCustomSessionBody =>
      'Use the live setup screen to change mode, focus, and duration before you begin.';

  @override
  String get homeCustomSessionCta => 'Set up custom session';

  @override
  String homePlanDuration(int value) {
    return '$value min session';
  }

  @override
  String get homeNoReminderHint =>
      'No reminder yet. Add one in Settings when you want a gentle nudge.';

  @override
  String homeNextReminder(String value) {
    return 'Next reminder $value';
  }

  @override
  String get homeStartNow => 'Start now';

  @override
  String get homeRecordSample => 'Record sample';

  @override
  String get homeLastSession => 'Last session';

  @override
  String get homeNoSessions => 'No sessions yet';

  @override
  String get homeLatestResult => 'Latest result';

  @override
  String homeLatestInRange(int value) {
    return '$value% in range';
  }

  @override
  String homeLatestAverageSummary(String pitch, String target) {
    return '$pitch average · $target';
  }

  @override
  String get homeViewDetails => 'View details';

  @override
  String get onboardingTitle => 'Welcome to Voxa';

  @override
  String get onboardingBody =>
      'Set a starting target pitch and give microphone access when you are ready. You can refine everything later.';

  @override
  String get onboardingWelcomeCardTitle => 'Start simple';

  @override
  String get onboardingWelcomeCardBody =>
      'Voxa uses your device language automatically. You can change language and appearance later in Settings.';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingTargetTitle => 'Choose your target';

  @override
  String get onboardingTargetSubtitle =>
      'Start with a preset, then fine-tune later. Voxa keeps this flexible.';

  @override
  String get onboardingMoreOptionsBody =>
      'Use a custom target if you already know your range.';

  @override
  String get onboardingSkipForNow => 'Skip for now';

  @override
  String get goalTitle => 'Goal setting';

  @override
  String get goalSubtitle =>
      'Choose a target pitch that supports exploration, not pressure.';

  @override
  String get goalHelper =>
      'Pitch is one part of voice perception. These suggestions are guidance, not rules.';

  @override
  String get goalEyebrow => 'TARGET';

  @override
  String get goalPageTitle => 'Target setup';

  @override
  String get goalPageSubtitle =>
      'Keep the main choice simple now. Fine-tune only when you need to.';

  @override
  String get goalChoosePresetTitle => 'Choose a preset';

  @override
  String get goalMeasureTitle => 'Measure from your voice';

  @override
  String get goalMeasureBody =>
      'Speak naturally for a few seconds and let Voxa suggest a starting pitch.';

  @override
  String get goalMeasureAction => 'Measure now';

  @override
  String get goalMoreOptionsTitle => 'More options';

  @override
  String get goalMoreOptionsBody =>
      'Use a custom pitch, calibrate loudness, or analyse an audio file.';

  @override
  String get goalPresetFeminine => 'Feminine';

  @override
  String get goalPresetAndrogynous => 'Androgynous';

  @override
  String get goalPresetMasculine => 'Masculine';

  @override
  String get goalPresetCustom => 'Custom';

  @override
  String get goalMinLabel => 'Minimum Hz';

  @override
  String get goalMaxLabel => 'Maximum Hz';

  @override
  String get goalTargetLabel => 'Target pitch';

  @override
  String get goalSave => 'Save target';

  @override
  String get goalSaved => 'Target updated';

  @override
  String get goalImportFileAction => 'Use audio file';

  @override
  String get goalImportFileHelp =>
      'Import a recording like WAV, M4A, AAC, MP3, FLAC, OGG, OPUS, MP4, or CAF and let Voxa suggest a target pitch from the voiced median.';

  @override
  String get goalImportFileUnsupported =>
      'This recording format is not supported yet. Try WAV, M4A, AAC, MP3, FLAC, OGG, OPUS, MP4, or CAF.';

  @override
  String get goalImportFileError =>
      'The selected audio file could not be analysed.';

  @override
  String goalImportFileSuccess(int value) {
    return 'Suggested target: $value Hz';
  }

  @override
  String get goalVolumeTitle => 'Target volume';

  @override
  String get goalVolumeNotSet => 'Not calibrated yet';

  @override
  String get goalVolumeCalibrateAction => 'Calibrate with microphone';

  @override
  String get goalVolumeHelp =>
      'Speak loud and clear at your usual phone distance. Volume feedback works best when the phone stays at a similar distance later.';

  @override
  String get goalVolumeCalibratingHint =>
      'Speak loud and clear for a few seconds at your usual phone distance.';

  @override
  String get goalVolumeCalibrateError =>
      'The target volume could not be captured.';

  @override
  String goalVolumeCalibrated(int value) {
    return 'Target volume set to $value dBFS';
  }

  @override
  String get goalValidationMin => 'Enter a valid minimum pitch.';

  @override
  String get goalValidationMax => 'Enter a valid maximum pitch.';

  @override
  String get goalValidationOrder =>
      'Maximum pitch must be higher than minimum pitch.';

  @override
  String get goalValidationTarget => 'Enter a valid target pitch.';

  @override
  String get goalValidationBounds => 'Choose a target between 70 and 350 Hz.';

  @override
  String get practiceTitle => 'Practice';

  @override
  String get practiceSubtitle =>
      'One clear signal at a time: your current pitch against your target pitch.';

  @override
  String get practicePermissionTitle => 'Microphone access is required';

  @override
  String get practicePermissionBody =>
      'Allow microphone access to use live pitch feedback.';

  @override
  String get practiceSetTargetFirst => 'Set your target first';

  @override
  String get practiceOpenTargetSetup => 'Open target setup';

  @override
  String get practiceGrantPermission => 'Grant access';

  @override
  String get practiceOpenSettings => 'Open settings';

  @override
  String get practiceStart => 'Start';

  @override
  String get practicePause => 'Pause';

  @override
  String get practiceResume => 'Resume';

  @override
  String get practiceStop => 'Stop';

  @override
  String get practiceFinish => 'Finish';

  @override
  String get practiceSwitchToRecord => 'Switch to record';

  @override
  String get practiceEyebrow => 'PRACTICE';

  @override
  String get practiceLiveFeedbackTitle => 'Live feedback';

  @override
  String get practiceSessionSetupButton => 'Session setup';

  @override
  String get practiceSessionSetupTitle => 'Session setup';

  @override
  String get practiceSessionTypeLive => 'Live';

  @override
  String get practiceSessionTypeRecord => 'Record sample';

  @override
  String get practiceExerciseFocus => 'Exercise focus';

  @override
  String get practiceSessionLength => 'Session length';

  @override
  String get practiceVolumeLabel => 'Volume';

  @override
  String get practiceVolumeAtTarget => 'On target';

  @override
  String get practiceVolumeQuiet => 'Too quiet';

  @override
  String get practiceVolumeLoud => 'Too loud';

  @override
  String get practiceVolumeUnclear => 'Unclear';

  @override
  String get practiceVolumeNotSet => 'Set target';

  @override
  String get practiceVolumeDistanceHint =>
      'Keep the phone at a similar distance so the loudness target stays meaningful.';

  @override
  String get practiceVolumeSetupHint =>
      'Set a target volume in Goal so loudness feedback can compare against your usual loud and clear voice.';

  @override
  String get practicePitchLabel => 'Current pitch';

  @override
  String get practiceTimeInRange => 'Time in range';

  @override
  String get practiceVoicedTime => 'Voiced time';

  @override
  String get practiceTimeAtTarget => 'At target';

  @override
  String get practiceTrackedTime => 'Tracked time';

  @override
  String get practiceStatusLow => 'Try a little higher';

  @override
  String get practiceStatusInRange => 'You are in your target zone';

  @override
  String get practiceStatusAtTarget => 'You are on target';

  @override
  String get practiceStatusHigh => 'Try a little lower';

  @override
  String get practiceStatusUnvoiced => 'Keep speaking naturally';

  @override
  String get practiceQualityStrong => 'Stable';

  @override
  String get practiceQualityWeak => 'Weak signal';

  @override
  String get practiceQualityUnstable => 'Unstable';

  @override
  String get practiceQualitySilent => 'Silent';

  @override
  String get practiceStatInRange => 'In range';

  @override
  String get practiceStatTimeLeft => 'Time left';

  @override
  String get resonanceTitle => 'Resonance';

  @override
  String get resonanceStateInsufficient => 'Signal unclear';

  @override
  String get resonanceStateDark => 'Too dark';

  @override
  String get resonanceStateBalanced => 'Balanced';

  @override
  String get resonanceStateBright => 'Too bright';

  @override
  String get resonanceStateUnstable => 'Unstable';

  @override
  String get resonanceHelperInsufficient =>
      'Use a clear voiced sound before adjusting resonance.';

  @override
  String get resonanceHelperDarkSound =>
      'Let the sound travel forward a little more.';

  @override
  String get resonanceHelperBalancedSound =>
      'The resonance sounds balanced. Stay with that shape.';

  @override
  String get resonanceHelperBrightSound =>
      'Soften the sharp edge and keep the sound easy.';

  @override
  String get resonanceHelperDarkSpeech =>
      'Let the speech resonate a bit more forward.';

  @override
  String get resonanceHelperBalancedSpeech =>
      'This resonance balance looks steady for speech.';

  @override
  String get resonanceHelperBrightSpeech =>
      'The speech sounds a bit bright. Ease the edge slightly.';

  @override
  String get resonanceHelperUnstable =>
      'Keep the sound steady before changing anything else.';

  @override
  String get sessionDetailResonance => 'Resonance summary';

  @override
  String get sessionDetailResonanceBalanced => 'Balanced time';

  @override
  String get practiceTargetLabel => 'Target';

  @override
  String get practiceModeLabel => 'Tracking mode';

  @override
  String get practiceModeSound => 'Sound';

  @override
  String get practiceModeSpeech => 'Speech';

  @override
  String get practiceSoundIdle =>
      'Use this mode for sustained sounds like humming or held vowels.';

  @override
  String get practiceSpeechIdle =>
      'Use this mode for spoken phrases. Feedback follows your speech baseline, not each melody change.';

  @override
  String get practiceSoundRunning => 'Sustained-sound tracking is active.';

  @override
  String get practiceSpeechRunning => 'Speech-baseline tracking is active.';

  @override
  String get practicePaused => 'Tracking is paused.';

  @override
  String get practiceError => 'Live analysis is unavailable.';

  @override
  String get practiceReviewReady => 'Review your session';

  @override
  String get practiceReviewTitle => 'Session review';

  @override
  String get practiceChartNow => 'now';

  @override
  String get practiceChartDrag => 'drag';

  @override
  String get practiceSessionStopped => 'Practice session stopped';

  @override
  String get practiceExerciseGeneralLabel => 'General training';

  @override
  String get practiceExerciseWarmupResetLabel => 'Warm-up reset';

  @override
  String get practiceExerciseLaxVoxLabel => 'LaxVox';

  @override
  String get practiceExerciseStrawBubblesLabel => 'Straw bubbles';

  @override
  String get practiceExerciseLipTrillsLabel => 'Lip trills';

  @override
  String get practiceExerciseResonanceHumLabel => 'Resonance hum';

  @override
  String get practiceExercisePitchGlidesLabel => 'Pitch glides';

  @override
  String get practiceExerciseTargetSpeechLabel => 'Target speech';

  @override
  String get practiceExerciseReadingTransferLabel => 'Reading transfer';

  @override
  String get practiceExerciseChestResonanceLabel => 'Chest resonance';

  @override
  String get practiceExerciseArticulationLabel => 'Articulation';

  @override
  String get practiceExerciseGeneralSummary =>
      'Free practice with timer and live feedback.';

  @override
  String get practiceExerciseWarmupResetSummary =>
      'Gentle release work before more focused voice practice.';

  @override
  String get practiceExerciseLaxVoxSummary =>
      'Water-resistance SOVT for easy, efficient voice onset.';

  @override
  String get practiceExerciseStrawBubblesSummary =>
      'Cup-bubble straw phonation for short, frequent resets.';

  @override
  String get practiceExerciseLipTrillsSummary =>
      'Loose lip trills with airflow and light pitch movement.';

  @override
  String get practiceExerciseResonanceHumSummary =>
      'Front-of-face humming for lighter resonance placement.';

  @override
  String get practiceExercisePitchGlidesSummary =>
      'Slow sirens and glides to find and stabilize comfortable pitch.';

  @override
  String get practiceExerciseTargetSpeechSummary =>
      'Short phrases around your target voice.';

  @override
  String get practiceExerciseReadingTransferSummary =>
      'Carry the target into connected speech.';

  @override
  String get practiceExerciseChestResonanceSummary =>
      'Lower-body anchoring and chest resonance exploration.';

  @override
  String get practiceExerciseArticulationSummary =>
      'Clear consonants and projection without throat pressure.';

  @override
  String get recordTitle => 'Record and analyse';

  @override
  String get recordSubtitle =>
      'Record a practice sample and save a calm, compact summary for later review.';

  @override
  String get recordEyebrow => 'RECORD';

  @override
  String get recordPageTitle => 'Record sample';

  @override
  String get recordPageSubtitle => 'Set up, record, then review before saving.';

  @override
  String get recordSelectText => 'Practice text';

  @override
  String get recordPracticeTextTitle => 'Practice text';

  @override
  String get recordNoText => 'Free speaking';

  @override
  String get recordLiveFeedback => 'Show live feedback while recording';

  @override
  String get recordStart => 'Start recording';

  @override
  String get recordStop => 'Stop recording';

  @override
  String get recordRecordingInProgress => 'Recording in progress';

  @override
  String get recordSaveFailed => 'Recording could not be saved.';

  @override
  String get recordPitchLabel => 'Pitch';

  @override
  String get recordStatusLabel => 'Status';

  @override
  String get recordReviewTitle => 'Review';

  @override
  String get recordPlayRecording => 'Play recording';

  @override
  String get recordStopPlayback => 'Stop playback';

  @override
  String get recordAvgLabel => 'Average';

  @override
  String get recordRangeLabel => 'Range';

  @override
  String get recordInRangeLabel => 'In range';

  @override
  String get recordAtTargetLabel => 'At target';

  @override
  String get recordSoundModeHint =>
      'Sound mode focuses on sustained sounds like humming, held vowels, or resonant \"mmm\" practice.';

  @override
  String get recordSaved => 'Session saved';

  @override
  String get historyTitle => 'History';

  @override
  String get historySubtitle =>
      'Past sessions should feel informative and encouraging, never corrective.';

  @override
  String get historyEmptyTitle => 'No sessions yet';

  @override
  String get historyEmptyBody =>
      'Record a session to start tracking your progress locally on this device.';

  @override
  String get historyDelete => 'Delete';

  @override
  String get historyDeleteConfirmTitle => 'Delete session?';

  @override
  String get historyDeleteConfirmBody =>
      'This removes the session summary and the local recording file.';

  @override
  String get historyDeleteConfirmAction => 'Delete session';

  @override
  String get historyDeleteCancel => 'Cancel';

  @override
  String get sessionDetailTitle => 'Session details';

  @override
  String get sessionDetailNotFound => 'Session not found.';

  @override
  String get sessionDetailPlayback => 'Playback';

  @override
  String get sessionDetailPlaybackStop => 'Stop playback';

  @override
  String get sessionDetailTarget => 'Target snapshot';

  @override
  String get sessionDetailPitchContour => 'Pitch contour';

  @override
  String sessionDetailAtTargetPercent(int value) {
    return '$value% on target';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSubtitle =>
      'Keep language, display, and data handling simple and transparent.';

  @override
  String get settingsEyebrow => 'SETTINGS';

  @override
  String get settingsOverviewSubtitle =>
      'Keep the overview short. Open details only when you need them.';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsLanguageSubtitle => 'Choose how Voxa reads and looks.';

  @override
  String get settingsLocaleSystem => 'Device default';

  @override
  String settingsLanguageDeviceHint(String value) {
    return 'Current app language: $value';
  }

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsAnalysis => 'Analysis preferences';

  @override
  String get settingsAnalysisSubtitle =>
      'Tune how forgiving live and recorded feedback should feel.';

  @override
  String get settingsSmoothing => 'Pitch smoothing';

  @override
  String get settingsTolerance => 'Target tolerance';

  @override
  String get settingsToleranceHelp =>
      'A small tolerance helps near-misses count as on target instead of producing harsh feedback.';

  @override
  String get settingsVolumeTolerance => 'Volume tolerance';

  @override
  String get settingsVolumeToleranceHelp =>
      'A wider corridor gives more room for natural loudness variation while keeping speech clear.';

  @override
  String get settingsLiveFeedback => 'Live feedback during recording';

  @override
  String get settingsTrainingPlanTitle => 'Training plan';

  @override
  String get settingsTrainingPlanSubtitle =>
      'Keep reminders supportive and predictable.';

  @override
  String get settingsTrainingPlanSameDaily => 'Same daily';

  @override
  String get settingsTrainingPlanByWeekday => 'By weekday';

  @override
  String get settingsTrainingPlanEveryDay => 'Every day';

  @override
  String get settingsSyncTitle => 'Google Sync';

  @override
  String get settingsSyncSubtitle =>
      'Keep summaries in sync without moving audio files off device.';

  @override
  String get settingsSyncBody =>
      'Your settings, target, and saved session summaries can sync through your Google account\'s hidden app storage.';

  @override
  String get settingsSyncAudioNote =>
      'Audio recordings stay local on each device and are not included in cloud sync.';

  @override
  String get settingsSyncUnavailable =>
      'Google sync is available on Android and iOS once Google OAuth is configured for this app.';

  @override
  String get settingsSyncConnected => 'Connected';

  @override
  String get settingsSyncNotConnected => 'Not connected';

  @override
  String get settingsSyncUnavailableDevice => 'Unavailable on this device';

  @override
  String get settingsSyncConnectedAs => 'Connected as';

  @override
  String get settingsSyncLastSynced => 'Last synced';

  @override
  String get settingsSyncConnect => 'Connect Google account';

  @override
  String get settingsSyncDisconnect => 'Disconnect';

  @override
  String get settingsSyncNow => 'Sync now';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsPrivacyBody =>
      'Voxa stores targets, sessions, and recordings locally on this device for the MVP.';

  @override
  String get settingsPrivacySubtitle =>
      'Explain data handling clearly and keep risk low.';

  @override
  String get settingsResetTitle => 'Reset local data';

  @override
  String get settingsResetBody =>
      'Delete all saved targets, sessions, and recordings from this device.';

  @override
  String get settingsDataSubtitle =>
      'Keep destructive actions isolated from everyday settings.';

  @override
  String get settingsResetAction => 'Reset data';

  @override
  String get settingsResetConfirmTitle => 'Reset all local data?';

  @override
  String get settingsResetConfirmBody => 'This cannot be undone.';

  @override
  String get settingsResetConfirmAction => 'Delete everything';

  @override
  String get settingsResetDone => 'Local data cleared';

  @override
  String get settingsLocaleEnglish => 'English';

  @override
  String get settingsLocaleGerman => 'German';

  @override
  String get settingsAddReminder => 'Add reminder';

  @override
  String get languageLabel => 'Language';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDone => 'Done';

  @override
  String get commonBack => 'Back';

  @override
  String get commonClose => 'Close';

  @override
  String get commonDiscard => 'Discard';

  @override
  String get commonRepeat => 'Repeat';

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
  String get commonLoading => 'Loading...';

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
    return '$value min';
  }

  @override
  String get weekdayMonday => 'Monday';

  @override
  String get weekdayTuesday => 'Tuesday';

  @override
  String get weekdayWednesday => 'Wednesday';

  @override
  String get weekdayThursday => 'Thursday';

  @override
  String get weekdayFriday => 'Friday';

  @override
  String get weekdaySaturday => 'Saturday';

  @override
  String get weekdaySunday => 'Sunday';

  @override
  String get practiceTextWarmupTitle => 'Warm-up paragraph';

  @override
  String get practiceTextWarmupBody =>
      'I am taking a calm breath and speaking with a steady, comfortable voice today.';

  @override
  String get practiceTextDailyTitle => 'Daily check-in';

  @override
  String get practiceTextDailyBody =>
      'My voice can change over time, and I can practice in a way that feels supportive and sustainable.';
}
