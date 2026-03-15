import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Voxa'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get navGoal;

  /// No description provided for @navPractice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get navPractice;

  /// No description provided for @navRecord.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get navRecord;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @homeEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Gender-affirming voice practice'**
  String get homeEyebrow;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Calm training. Clear feedback. Your voice, your goal.'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track practice locally, shape your target pitch, and work with gentle real-time feedback.'**
  String get homeSubtitle;

  /// No description provided for @homeReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready for your next session?'**
  String get homeReadyTitle;

  /// No description provided for @homeReadySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your target, today’s plan, and one clear next step.'**
  String get homeReadySubtitle;

  /// No description provided for @homePrimaryCta.
  ///
  /// In en, this message translates to:
  /// **'Start practice'**
  String get homePrimaryCta;

  /// No description provided for @homeSecondaryCta.
  ///
  /// In en, this message translates to:
  /// **'Set your target'**
  String get homeSecondaryCta;

  /// No description provided for @homeCurrentTarget.
  ///
  /// In en, this message translates to:
  /// **'Current target'**
  String get homeCurrentTarget;

  /// No description provided for @homeNoTarget.
  ///
  /// In en, this message translates to:
  /// **'No target saved yet'**
  String get homeNoTarget;

  /// No description provided for @homeTargetHintMissing.
  ///
  /// In en, this message translates to:
  /// **'Choose a starting target before you begin.'**
  String get homeTargetHintMissing;

  /// No description provided for @homeTargetHintSaved.
  ///
  /// In en, this message translates to:
  /// **'You can refine this anytime without losing past sessions.'**
  String get homeTargetHintSaved;

  /// No description provided for @homeEditTarget.
  ///
  /// In en, this message translates to:
  /// **'Edit target'**
  String get homeEditTarget;

  /// No description provided for @homeTodayPlan.
  ///
  /// In en, this message translates to:
  /// **'Today\'s plan'**
  String get homeTodayPlan;

  /// No description provided for @homePlannedSessionCta.
  ///
  /// In en, this message translates to:
  /// **'Start today\'s session'**
  String get homePlannedSessionCta;

  /// No description provided for @homeCustomSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom session'**
  String get homeCustomSessionTitle;

  /// No description provided for @homeCustomSessionBody.
  ///
  /// In en, this message translates to:
  /// **'Use the live setup screen to change mode, focus, and duration before you begin.'**
  String get homeCustomSessionBody;

  /// No description provided for @homeCustomSessionCta.
  ///
  /// In en, this message translates to:
  /// **'Set up custom session'**
  String get homeCustomSessionCta;

  /// No description provided for @homePlanDuration.
  ///
  /// In en, this message translates to:
  /// **'{value} min session'**
  String homePlanDuration(int value);

  /// No description provided for @homeNoReminderHint.
  ///
  /// In en, this message translates to:
  /// **'No reminder yet. Add one in Settings when you want a gentle nudge.'**
  String get homeNoReminderHint;

  /// No description provided for @homeNextReminder.
  ///
  /// In en, this message translates to:
  /// **'Next reminder {value}'**
  String homeNextReminder(String value);

  /// No description provided for @homeStartNow.
  ///
  /// In en, this message translates to:
  /// **'Start now'**
  String get homeStartNow;

  /// No description provided for @homeRecordSample.
  ///
  /// In en, this message translates to:
  /// **'Record sample'**
  String get homeRecordSample;

  /// No description provided for @homeLastSession.
  ///
  /// In en, this message translates to:
  /// **'Last session'**
  String get homeLastSession;

  /// No description provided for @homeNoSessions.
  ///
  /// In en, this message translates to:
  /// **'No sessions yet'**
  String get homeNoSessions;

  /// No description provided for @homeLatestResult.
  ///
  /// In en, this message translates to:
  /// **'Latest result'**
  String get homeLatestResult;

  /// No description provided for @homeLatestInRange.
  ///
  /// In en, this message translates to:
  /// **'{value}% in range'**
  String homeLatestInRange(int value);

  /// No description provided for @homeLatestAverageSummary.
  ///
  /// In en, this message translates to:
  /// **'{pitch} average · {target}'**
  String homeLatestAverageSummary(String pitch, String target);

  /// No description provided for @homeViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get homeViewDetails;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Voxa'**
  String get onboardingTitle;

  /// No description provided for @onboardingBody.
  ///
  /// In en, this message translates to:
  /// **'Set a starting target pitch and give microphone access when you are ready. You can refine everything later.'**
  String get onboardingBody;

  /// No description provided for @onboardingWelcomeCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Start simple'**
  String get onboardingWelcomeCardTitle;

  /// No description provided for @onboardingWelcomeCardBody.
  ///
  /// In en, this message translates to:
  /// **'Voxa uses your device language automatically. You can change language and appearance later in Settings.'**
  String get onboardingWelcomeCardBody;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;

  /// No description provided for @onboardingTargetTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your target'**
  String get onboardingTargetTitle;

  /// No description provided for @onboardingTargetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start with a preset, then fine-tune later. Voxa keeps this flexible.'**
  String get onboardingTargetSubtitle;

  /// No description provided for @onboardingMoreOptionsBody.
  ///
  /// In en, this message translates to:
  /// **'Use a custom target if you already know your range.'**
  String get onboardingMoreOptionsBody;

  /// No description provided for @onboardingSkipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get onboardingSkipForNow;

  /// No description provided for @goalTitle.
  ///
  /// In en, this message translates to:
  /// **'Goal setting'**
  String get goalTitle;

  /// No description provided for @goalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a target pitch that supports exploration, not pressure.'**
  String get goalSubtitle;

  /// No description provided for @goalHelper.
  ///
  /// In en, this message translates to:
  /// **'Pitch is one part of voice perception. These suggestions are guidance, not rules.'**
  String get goalHelper;

  /// No description provided for @goalEyebrow.
  ///
  /// In en, this message translates to:
  /// **'TARGET'**
  String get goalEyebrow;

  /// No description provided for @goalPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Target setup'**
  String get goalPageTitle;

  /// No description provided for @goalPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep the main choice simple now. Fine-tune only when you need to.'**
  String get goalPageSubtitle;

  /// No description provided for @goalChoosePresetTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a preset'**
  String get goalChoosePresetTitle;

  /// No description provided for @goalMeasureTitle.
  ///
  /// In en, this message translates to:
  /// **'Measure from your voice'**
  String get goalMeasureTitle;

  /// No description provided for @goalMeasureBody.
  ///
  /// In en, this message translates to:
  /// **'Speak naturally for a few seconds and let Voxa suggest a starting pitch.'**
  String get goalMeasureBody;

  /// No description provided for @goalMeasureAction.
  ///
  /// In en, this message translates to:
  /// **'Measure now'**
  String get goalMeasureAction;

  /// No description provided for @goalMoreOptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get goalMoreOptionsTitle;

  /// No description provided for @goalMoreOptionsBody.
  ///
  /// In en, this message translates to:
  /// **'Use a custom pitch, calibrate loudness, or analyse an audio file.'**
  String get goalMoreOptionsBody;

  /// No description provided for @goalPresetFeminine.
  ///
  /// In en, this message translates to:
  /// **'Feminine'**
  String get goalPresetFeminine;

  /// No description provided for @goalPresetAndrogynous.
  ///
  /// In en, this message translates to:
  /// **'Androgynous'**
  String get goalPresetAndrogynous;

  /// No description provided for @goalPresetMasculine.
  ///
  /// In en, this message translates to:
  /// **'Masculine'**
  String get goalPresetMasculine;

  /// No description provided for @goalPresetCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get goalPresetCustom;

  /// No description provided for @goalMinLabel.
  ///
  /// In en, this message translates to:
  /// **'Minimum Hz'**
  String get goalMinLabel;

  /// No description provided for @goalMaxLabel.
  ///
  /// In en, this message translates to:
  /// **'Maximum Hz'**
  String get goalMaxLabel;

  /// No description provided for @goalTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'Target pitch'**
  String get goalTargetLabel;

  /// No description provided for @goalSave.
  ///
  /// In en, this message translates to:
  /// **'Save target'**
  String get goalSave;

  /// No description provided for @goalSaved.
  ///
  /// In en, this message translates to:
  /// **'Target updated'**
  String get goalSaved;

  /// No description provided for @goalImportFileAction.
  ///
  /// In en, this message translates to:
  /// **'Use audio file'**
  String get goalImportFileAction;

  /// No description provided for @goalImportFileHelp.
  ///
  /// In en, this message translates to:
  /// **'Import a recording like WAV, M4A, AAC, MP3, FLAC, OGG, OPUS, MP4, or CAF and let Voxa suggest a target pitch from the voiced median.'**
  String get goalImportFileHelp;

  /// No description provided for @goalImportFileUnsupported.
  ///
  /// In en, this message translates to:
  /// **'This recording format is not supported yet. Try WAV, M4A, AAC, MP3, FLAC, OGG, OPUS, MP4, or CAF.'**
  String get goalImportFileUnsupported;

  /// No description provided for @goalImportFileError.
  ///
  /// In en, this message translates to:
  /// **'The selected audio file could not be analysed.'**
  String get goalImportFileError;

  /// No description provided for @goalImportFileSuccess.
  ///
  /// In en, this message translates to:
  /// **'Suggested target: {value} Hz'**
  String goalImportFileSuccess(int value);

  /// No description provided for @goalVolumeTitle.
  ///
  /// In en, this message translates to:
  /// **'Target volume'**
  String get goalVolumeTitle;

  /// No description provided for @goalVolumeNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not calibrated yet'**
  String get goalVolumeNotSet;

  /// No description provided for @goalVolumeCalibrateAction.
  ///
  /// In en, this message translates to:
  /// **'Calibrate with microphone'**
  String get goalVolumeCalibrateAction;

  /// No description provided for @goalVolumeHelp.
  ///
  /// In en, this message translates to:
  /// **'Speak loud and clear at your usual phone distance. Volume feedback works best when the phone stays at a similar distance later.'**
  String get goalVolumeHelp;

  /// No description provided for @goalVolumeCalibratingHint.
  ///
  /// In en, this message translates to:
  /// **'Speak loud and clear for a few seconds at your usual phone distance.'**
  String get goalVolumeCalibratingHint;

  /// No description provided for @goalVolumeCalibrateError.
  ///
  /// In en, this message translates to:
  /// **'The target volume could not be captured.'**
  String get goalVolumeCalibrateError;

  /// No description provided for @goalVolumeCalibrated.
  ///
  /// In en, this message translates to:
  /// **'Target volume set to {value} dBFS'**
  String goalVolumeCalibrated(int value);

  /// No description provided for @goalValidationMin.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid minimum pitch.'**
  String get goalValidationMin;

  /// No description provided for @goalValidationMax.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid maximum pitch.'**
  String get goalValidationMax;

  /// No description provided for @goalValidationOrder.
  ///
  /// In en, this message translates to:
  /// **'Maximum pitch must be higher than minimum pitch.'**
  String get goalValidationOrder;

  /// No description provided for @goalValidationTarget.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid target pitch.'**
  String get goalValidationTarget;

  /// No description provided for @goalValidationBounds.
  ///
  /// In en, this message translates to:
  /// **'Choose a target between 70 and 350 Hz.'**
  String get goalValidationBounds;

  /// No description provided for @practiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get practiceTitle;

  /// No description provided for @practiceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'One clear signal at a time: your current pitch against your target pitch.'**
  String get practiceSubtitle;

  /// No description provided for @practicePermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Microphone access is required'**
  String get practicePermissionTitle;

  /// No description provided for @practicePermissionBody.
  ///
  /// In en, this message translates to:
  /// **'Allow microphone access to use live pitch feedback.'**
  String get practicePermissionBody;

  /// No description provided for @practiceSetTargetFirst.
  ///
  /// In en, this message translates to:
  /// **'Set your target first'**
  String get practiceSetTargetFirst;

  /// No description provided for @practiceOpenTargetSetup.
  ///
  /// In en, this message translates to:
  /// **'Open target setup'**
  String get practiceOpenTargetSetup;

  /// No description provided for @practiceGrantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant access'**
  String get practiceGrantPermission;

  /// No description provided for @practiceOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get practiceOpenSettings;

  /// No description provided for @practiceStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get practiceStart;

  /// No description provided for @practicePause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get practicePause;

  /// No description provided for @practiceResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get practiceResume;

  /// No description provided for @practiceStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get practiceStop;

  /// No description provided for @practiceFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get practiceFinish;

  /// No description provided for @practiceSwitchToRecord.
  ///
  /// In en, this message translates to:
  /// **'Switch to record'**
  String get practiceSwitchToRecord;

  /// No description provided for @practiceEyebrow.
  ///
  /// In en, this message translates to:
  /// **'PRACTICE'**
  String get practiceEyebrow;

  /// No description provided for @practiceLiveFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Live feedback'**
  String get practiceLiveFeedbackTitle;

  /// No description provided for @practiceSessionSetupButton.
  ///
  /// In en, this message translates to:
  /// **'Session setup'**
  String get practiceSessionSetupButton;

  /// No description provided for @practiceSessionSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Session setup'**
  String get practiceSessionSetupTitle;

  /// No description provided for @practiceSessionTypeLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get practiceSessionTypeLive;

  /// No description provided for @practiceSessionTypeRecord.
  ///
  /// In en, this message translates to:
  /// **'Record sample'**
  String get practiceSessionTypeRecord;

  /// No description provided for @practiceExerciseFocus.
  ///
  /// In en, this message translates to:
  /// **'Exercise focus'**
  String get practiceExerciseFocus;

  /// No description provided for @practiceSessionLength.
  ///
  /// In en, this message translates to:
  /// **'Session length'**
  String get practiceSessionLength;

  /// No description provided for @practiceVolumeLabel.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get practiceVolumeLabel;

  /// No description provided for @practiceVolumeAtTarget.
  ///
  /// In en, this message translates to:
  /// **'On target'**
  String get practiceVolumeAtTarget;

  /// No description provided for @practiceVolumeQuiet.
  ///
  /// In en, this message translates to:
  /// **'Too quiet'**
  String get practiceVolumeQuiet;

  /// No description provided for @practiceVolumeLoud.
  ///
  /// In en, this message translates to:
  /// **'Too loud'**
  String get practiceVolumeLoud;

  /// No description provided for @practiceVolumeUnclear.
  ///
  /// In en, this message translates to:
  /// **'Unclear'**
  String get practiceVolumeUnclear;

  /// No description provided for @practiceVolumeNotSet.
  ///
  /// In en, this message translates to:
  /// **'Set target'**
  String get practiceVolumeNotSet;

  /// No description provided for @practiceVolumeDistanceHint.
  ///
  /// In en, this message translates to:
  /// **'Keep the phone at a similar distance so the loudness target stays meaningful.'**
  String get practiceVolumeDistanceHint;

  /// No description provided for @practiceVolumeSetupHint.
  ///
  /// In en, this message translates to:
  /// **'Set a target volume in Goal so loudness feedback can compare against your usual loud and clear voice.'**
  String get practiceVolumeSetupHint;

  /// No description provided for @practicePitchLabel.
  ///
  /// In en, this message translates to:
  /// **'Current pitch'**
  String get practicePitchLabel;

  /// No description provided for @practiceTimeInRange.
  ///
  /// In en, this message translates to:
  /// **'Time in range'**
  String get practiceTimeInRange;

  /// No description provided for @practiceVoicedTime.
  ///
  /// In en, this message translates to:
  /// **'Voiced time'**
  String get practiceVoicedTime;

  /// No description provided for @practiceTimeAtTarget.
  ///
  /// In en, this message translates to:
  /// **'At target'**
  String get practiceTimeAtTarget;

  /// No description provided for @practiceTrackedTime.
  ///
  /// In en, this message translates to:
  /// **'Tracked time'**
  String get practiceTrackedTime;

  /// No description provided for @practiceStatusLow.
  ///
  /// In en, this message translates to:
  /// **'Try a little higher'**
  String get practiceStatusLow;

  /// No description provided for @practiceStatusInRange.
  ///
  /// In en, this message translates to:
  /// **'You are in your target zone'**
  String get practiceStatusInRange;

  /// No description provided for @practiceStatusAtTarget.
  ///
  /// In en, this message translates to:
  /// **'You are on target'**
  String get practiceStatusAtTarget;

  /// No description provided for @practiceStatusHigh.
  ///
  /// In en, this message translates to:
  /// **'Try a little lower'**
  String get practiceStatusHigh;

  /// No description provided for @practiceStatusUnvoiced.
  ///
  /// In en, this message translates to:
  /// **'Keep speaking naturally'**
  String get practiceStatusUnvoiced;

  /// No description provided for @practiceQualityStrong.
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get practiceQualityStrong;

  /// No description provided for @practiceQualityWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak signal'**
  String get practiceQualityWeak;

  /// No description provided for @practiceQualityUnstable.
  ///
  /// In en, this message translates to:
  /// **'Unstable'**
  String get practiceQualityUnstable;

  /// No description provided for @practiceQualitySilent.
  ///
  /// In en, this message translates to:
  /// **'Silent'**
  String get practiceQualitySilent;

  /// No description provided for @practiceStatInRange.
  ///
  /// In en, this message translates to:
  /// **'In range'**
  String get practiceStatInRange;

  /// No description provided for @practiceStatTimeLeft.
  ///
  /// In en, this message translates to:
  /// **'Time left'**
  String get practiceStatTimeLeft;

  /// No description provided for @resonanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Resonance'**
  String get resonanceTitle;

  /// No description provided for @resonanceStateInsufficient.
  ///
  /// In en, this message translates to:
  /// **'Signal unclear'**
  String get resonanceStateInsufficient;

  /// No description provided for @resonanceStateDark.
  ///
  /// In en, this message translates to:
  /// **'Too dark'**
  String get resonanceStateDark;

  /// No description provided for @resonanceStateBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get resonanceStateBalanced;

  /// No description provided for @resonanceStateBright.
  ///
  /// In en, this message translates to:
  /// **'Too bright'**
  String get resonanceStateBright;

  /// No description provided for @resonanceStateUnstable.
  ///
  /// In en, this message translates to:
  /// **'Unstable'**
  String get resonanceStateUnstable;

  /// No description provided for @resonanceHelperInsufficient.
  ///
  /// In en, this message translates to:
  /// **'Use a clear voiced sound before adjusting resonance.'**
  String get resonanceHelperInsufficient;

  /// No description provided for @resonanceHelperDarkSound.
  ///
  /// In en, this message translates to:
  /// **'Let the sound travel forward a little more.'**
  String get resonanceHelperDarkSound;

  /// No description provided for @resonanceHelperBalancedSound.
  ///
  /// In en, this message translates to:
  /// **'The resonance sounds balanced. Stay with that shape.'**
  String get resonanceHelperBalancedSound;

  /// No description provided for @resonanceHelperBrightSound.
  ///
  /// In en, this message translates to:
  /// **'Soften the sharp edge and keep the sound easy.'**
  String get resonanceHelperBrightSound;

  /// No description provided for @resonanceHelperDarkSpeech.
  ///
  /// In en, this message translates to:
  /// **'Let the speech resonate a bit more forward.'**
  String get resonanceHelperDarkSpeech;

  /// No description provided for @resonanceHelperBalancedSpeech.
  ///
  /// In en, this message translates to:
  /// **'This resonance balance looks steady for speech.'**
  String get resonanceHelperBalancedSpeech;

  /// No description provided for @resonanceHelperBrightSpeech.
  ///
  /// In en, this message translates to:
  /// **'The speech sounds a bit bright. Ease the edge slightly.'**
  String get resonanceHelperBrightSpeech;

  /// No description provided for @resonanceHelperUnstable.
  ///
  /// In en, this message translates to:
  /// **'Keep the sound steady before changing anything else.'**
  String get resonanceHelperUnstable;

  /// No description provided for @sessionDetailResonance.
  ///
  /// In en, this message translates to:
  /// **'Resonance summary'**
  String get sessionDetailResonance;

  /// No description provided for @sessionDetailResonanceBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced time'**
  String get sessionDetailResonanceBalanced;

  /// No description provided for @practiceTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get practiceTargetLabel;

  /// No description provided for @practiceModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Tracking mode'**
  String get practiceModeLabel;

  /// No description provided for @practiceModeSound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get practiceModeSound;

  /// No description provided for @practiceModeSpeech.
  ///
  /// In en, this message translates to:
  /// **'Speech'**
  String get practiceModeSpeech;

  /// No description provided for @practiceSoundIdle.
  ///
  /// In en, this message translates to:
  /// **'Use this mode for sustained sounds like humming or held vowels.'**
  String get practiceSoundIdle;

  /// No description provided for @practiceSpeechIdle.
  ///
  /// In en, this message translates to:
  /// **'Use this mode for spoken phrases. Feedback follows your speech baseline, not each melody change.'**
  String get practiceSpeechIdle;

  /// No description provided for @practiceSoundRunning.
  ///
  /// In en, this message translates to:
  /// **'Sustained-sound tracking is active.'**
  String get practiceSoundRunning;

  /// No description provided for @practiceSpeechRunning.
  ///
  /// In en, this message translates to:
  /// **'Speech-baseline tracking is active.'**
  String get practiceSpeechRunning;

  /// No description provided for @practicePaused.
  ///
  /// In en, this message translates to:
  /// **'Tracking is paused.'**
  String get practicePaused;

  /// No description provided for @practiceError.
  ///
  /// In en, this message translates to:
  /// **'Live analysis is unavailable.'**
  String get practiceError;

  /// No description provided for @practiceReviewReady.
  ///
  /// In en, this message translates to:
  /// **'Review your session'**
  String get practiceReviewReady;

  /// No description provided for @practiceReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Session review'**
  String get practiceReviewTitle;

  /// No description provided for @practiceChartNow.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get practiceChartNow;

  /// No description provided for @practiceChartDrag.
  ///
  /// In en, this message translates to:
  /// **'drag'**
  String get practiceChartDrag;

  /// No description provided for @practiceSessionStopped.
  ///
  /// In en, this message translates to:
  /// **'Practice session stopped'**
  String get practiceSessionStopped;

  /// No description provided for @practiceExerciseGeneralLabel.
  ///
  /// In en, this message translates to:
  /// **'General training'**
  String get practiceExerciseGeneralLabel;

  /// No description provided for @practiceExerciseWarmupResetLabel.
  ///
  /// In en, this message translates to:
  /// **'Warm-up reset'**
  String get practiceExerciseWarmupResetLabel;

  /// No description provided for @practiceExerciseLaxVoxLabel.
  ///
  /// In en, this message translates to:
  /// **'LaxVox'**
  String get practiceExerciseLaxVoxLabel;

  /// No description provided for @practiceExerciseStrawBubblesLabel.
  ///
  /// In en, this message translates to:
  /// **'Straw bubbles'**
  String get practiceExerciseStrawBubblesLabel;

  /// No description provided for @practiceExerciseLipTrillsLabel.
  ///
  /// In en, this message translates to:
  /// **'Lip trills'**
  String get practiceExerciseLipTrillsLabel;

  /// No description provided for @practiceExerciseResonanceHumLabel.
  ///
  /// In en, this message translates to:
  /// **'Resonance hum'**
  String get practiceExerciseResonanceHumLabel;

  /// No description provided for @practiceExercisePitchGlidesLabel.
  ///
  /// In en, this message translates to:
  /// **'Pitch glides'**
  String get practiceExercisePitchGlidesLabel;

  /// No description provided for @practiceExerciseTargetSpeechLabel.
  ///
  /// In en, this message translates to:
  /// **'Target speech'**
  String get practiceExerciseTargetSpeechLabel;

  /// No description provided for @practiceExerciseReadingTransferLabel.
  ///
  /// In en, this message translates to:
  /// **'Reading transfer'**
  String get practiceExerciseReadingTransferLabel;

  /// No description provided for @practiceExerciseChestResonanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Chest resonance'**
  String get practiceExerciseChestResonanceLabel;

  /// No description provided for @practiceExerciseArticulationLabel.
  ///
  /// In en, this message translates to:
  /// **'Articulation'**
  String get practiceExerciseArticulationLabel;

  /// No description provided for @practiceExerciseGeneralSummary.
  ///
  /// In en, this message translates to:
  /// **'Free practice with timer and live feedback.'**
  String get practiceExerciseGeneralSummary;

  /// No description provided for @practiceExerciseWarmupResetSummary.
  ///
  /// In en, this message translates to:
  /// **'Gentle release work before more focused voice practice.'**
  String get practiceExerciseWarmupResetSummary;

  /// No description provided for @practiceExerciseLaxVoxSummary.
  ///
  /// In en, this message translates to:
  /// **'Water-resistance SOVT for easy, efficient voice onset.'**
  String get practiceExerciseLaxVoxSummary;

  /// No description provided for @practiceExerciseStrawBubblesSummary.
  ///
  /// In en, this message translates to:
  /// **'Cup-bubble straw phonation for short, frequent resets.'**
  String get practiceExerciseStrawBubblesSummary;

  /// No description provided for @practiceExerciseLipTrillsSummary.
  ///
  /// In en, this message translates to:
  /// **'Loose lip trills with airflow and light pitch movement.'**
  String get practiceExerciseLipTrillsSummary;

  /// No description provided for @practiceExerciseResonanceHumSummary.
  ///
  /// In en, this message translates to:
  /// **'Front-of-face humming for lighter resonance placement.'**
  String get practiceExerciseResonanceHumSummary;

  /// No description provided for @practiceExercisePitchGlidesSummary.
  ///
  /// In en, this message translates to:
  /// **'Slow sirens and glides to find and stabilize comfortable pitch.'**
  String get practiceExercisePitchGlidesSummary;

  /// No description provided for @practiceExerciseTargetSpeechSummary.
  ///
  /// In en, this message translates to:
  /// **'Short phrases around your target voice.'**
  String get practiceExerciseTargetSpeechSummary;

  /// No description provided for @practiceExerciseReadingTransferSummary.
  ///
  /// In en, this message translates to:
  /// **'Carry the target into connected speech.'**
  String get practiceExerciseReadingTransferSummary;

  /// No description provided for @practiceExerciseChestResonanceSummary.
  ///
  /// In en, this message translates to:
  /// **'Lower-body anchoring and chest resonance exploration.'**
  String get practiceExerciseChestResonanceSummary;

  /// No description provided for @practiceExerciseArticulationSummary.
  ///
  /// In en, this message translates to:
  /// **'Clear consonants and projection without throat pressure.'**
  String get practiceExerciseArticulationSummary;

  /// No description provided for @recordTitle.
  ///
  /// In en, this message translates to:
  /// **'Record and analyse'**
  String get recordTitle;

  /// No description provided for @recordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Record a practice sample and save a calm, compact summary for later review.'**
  String get recordSubtitle;

  /// No description provided for @recordEyebrow.
  ///
  /// In en, this message translates to:
  /// **'RECORD'**
  String get recordEyebrow;

  /// No description provided for @recordPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Record sample'**
  String get recordPageTitle;

  /// No description provided for @recordPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set up, record, then review before saving.'**
  String get recordPageSubtitle;

  /// No description provided for @recordSelectText.
  ///
  /// In en, this message translates to:
  /// **'Practice text'**
  String get recordSelectText;

  /// No description provided for @recordPracticeTextTitle.
  ///
  /// In en, this message translates to:
  /// **'Practice text'**
  String get recordPracticeTextTitle;

  /// No description provided for @recordNoText.
  ///
  /// In en, this message translates to:
  /// **'Free speaking'**
  String get recordNoText;

  /// No description provided for @recordLiveFeedback.
  ///
  /// In en, this message translates to:
  /// **'Show live feedback while recording'**
  String get recordLiveFeedback;

  /// No description provided for @recordStart.
  ///
  /// In en, this message translates to:
  /// **'Start recording'**
  String get recordStart;

  /// No description provided for @recordStop.
  ///
  /// In en, this message translates to:
  /// **'Stop recording'**
  String get recordStop;

  /// No description provided for @recordRecordingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Recording in progress'**
  String get recordRecordingInProgress;

  /// No description provided for @recordSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Recording could not be saved.'**
  String get recordSaveFailed;

  /// No description provided for @recordPitchLabel.
  ///
  /// In en, this message translates to:
  /// **'Pitch'**
  String get recordPitchLabel;

  /// No description provided for @recordStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get recordStatusLabel;

  /// No description provided for @recordReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get recordReviewTitle;

  /// No description provided for @recordPlayRecording.
  ///
  /// In en, this message translates to:
  /// **'Play recording'**
  String get recordPlayRecording;

  /// No description provided for @recordStopPlayback.
  ///
  /// In en, this message translates to:
  /// **'Stop playback'**
  String get recordStopPlayback;

  /// No description provided for @recordAvgLabel.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get recordAvgLabel;

  /// No description provided for @recordRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Range'**
  String get recordRangeLabel;

  /// No description provided for @recordInRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'In range'**
  String get recordInRangeLabel;

  /// No description provided for @recordAtTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'At target'**
  String get recordAtTargetLabel;

  /// No description provided for @recordSoundModeHint.
  ///
  /// In en, this message translates to:
  /// **'Sound mode focuses on sustained sounds like humming, held vowels, or resonant \"mmm\" practice.'**
  String get recordSoundModeHint;

  /// No description provided for @recordSaved.
  ///
  /// In en, this message translates to:
  /// **'Session saved'**
  String get recordSaved;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @historySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Past sessions should feel informative and encouraging, never corrective.'**
  String get historySubtitle;

  /// No description provided for @historyEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No sessions yet'**
  String get historyEmptyTitle;

  /// No description provided for @historyEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Record a session to start tracking your progress locally on this device.'**
  String get historyEmptyBody;

  /// No description provided for @historyDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get historyDelete;

  /// No description provided for @historyDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete session?'**
  String get historyDeleteConfirmTitle;

  /// No description provided for @historyDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This removes the session summary and the local recording file.'**
  String get historyDeleteConfirmBody;

  /// No description provided for @historyDeleteConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Delete session'**
  String get historyDeleteConfirmAction;

  /// No description provided for @historyDeleteCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get historyDeleteCancel;

  /// No description provided for @sessionDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Session details'**
  String get sessionDetailTitle;

  /// No description provided for @sessionDetailNotFound.
  ///
  /// In en, this message translates to:
  /// **'Session not found.'**
  String get sessionDetailNotFound;

  /// No description provided for @sessionDetailPlayback.
  ///
  /// In en, this message translates to:
  /// **'Playback'**
  String get sessionDetailPlayback;

  /// No description provided for @sessionDetailPlaybackStop.
  ///
  /// In en, this message translates to:
  /// **'Stop playback'**
  String get sessionDetailPlaybackStop;

  /// No description provided for @sessionDetailTarget.
  ///
  /// In en, this message translates to:
  /// **'Target snapshot'**
  String get sessionDetailTarget;

  /// No description provided for @sessionDetailPitchContour.
  ///
  /// In en, this message translates to:
  /// **'Pitch contour'**
  String get sessionDetailPitchContour;

  /// No description provided for @sessionDetailAtTargetPercent.
  ///
  /// In en, this message translates to:
  /// **'{value}% on target'**
  String sessionDetailAtTargetPercent(int value);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep language, display, and data handling simple and transparent.'**
  String get settingsSubtitle;

  /// No description provided for @settingsEyebrow.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settingsEyebrow;

  /// No description provided for @settingsOverviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep the overview short. Open details only when you need them.'**
  String get settingsOverviewSubtitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how Voxa reads and looks.'**
  String get settingsLanguageSubtitle;

  /// No description provided for @settingsLocaleSystem.
  ///
  /// In en, this message translates to:
  /// **'Device default'**
  String get settingsLocaleSystem;

  /// No description provided for @settingsLanguageDeviceHint.
  ///
  /// In en, this message translates to:
  /// **'Current app language: {value}'**
  String settingsLanguageDeviceHint(String value);

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Analysis preferences'**
  String get settingsAnalysis;

  /// No description provided for @settingsAnalysisSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tune how forgiving live and recorded feedback should feel.'**
  String get settingsAnalysisSubtitle;

  /// No description provided for @settingsSmoothing.
  ///
  /// In en, this message translates to:
  /// **'Pitch smoothing'**
  String get settingsSmoothing;

  /// No description provided for @settingsTolerance.
  ///
  /// In en, this message translates to:
  /// **'Target tolerance'**
  String get settingsTolerance;

  /// No description provided for @settingsToleranceHelp.
  ///
  /// In en, this message translates to:
  /// **'A small tolerance helps near-misses count as on target instead of producing harsh feedback.'**
  String get settingsToleranceHelp;

  /// No description provided for @settingsVolumeTolerance.
  ///
  /// In en, this message translates to:
  /// **'Volume tolerance'**
  String get settingsVolumeTolerance;

  /// No description provided for @settingsVolumeToleranceHelp.
  ///
  /// In en, this message translates to:
  /// **'A wider corridor gives more room for natural loudness variation while keeping speech clear.'**
  String get settingsVolumeToleranceHelp;

  /// No description provided for @settingsLiveFeedback.
  ///
  /// In en, this message translates to:
  /// **'Live feedback during recording'**
  String get settingsLiveFeedback;

  /// No description provided for @settingsTrainingPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Training plan'**
  String get settingsTrainingPlanTitle;

  /// No description provided for @settingsTrainingPlanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep reminders supportive and predictable.'**
  String get settingsTrainingPlanSubtitle;

  /// No description provided for @settingsTrainingPlanSameDaily.
  ///
  /// In en, this message translates to:
  /// **'Same daily'**
  String get settingsTrainingPlanSameDaily;

  /// No description provided for @settingsTrainingPlanByWeekday.
  ///
  /// In en, this message translates to:
  /// **'By weekday'**
  String get settingsTrainingPlanByWeekday;

  /// No description provided for @settingsTrainingPlanEveryDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get settingsTrainingPlanEveryDay;

  /// No description provided for @settingsSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'Google Sync'**
  String get settingsSyncTitle;

  /// No description provided for @settingsSyncSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep summaries in sync without moving audio files off device.'**
  String get settingsSyncSubtitle;

  /// No description provided for @settingsSyncBody.
  ///
  /// In en, this message translates to:
  /// **'Your settings, target, and saved session summaries can sync through your Google account\'s hidden app storage.'**
  String get settingsSyncBody;

  /// No description provided for @settingsSyncAudioNote.
  ///
  /// In en, this message translates to:
  /// **'Audio recordings stay local on each device and are not included in cloud sync.'**
  String get settingsSyncAudioNote;

  /// No description provided for @settingsSyncUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Google sync is available on Android and iOS once Google OAuth is configured for this app.'**
  String get settingsSyncUnavailable;

  /// No description provided for @settingsSyncConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get settingsSyncConnected;

  /// No description provided for @settingsSyncNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get settingsSyncNotConnected;

  /// No description provided for @settingsSyncUnavailableDevice.
  ///
  /// In en, this message translates to:
  /// **'Unavailable on this device'**
  String get settingsSyncUnavailableDevice;

  /// No description provided for @settingsSyncConnectedAs.
  ///
  /// In en, this message translates to:
  /// **'Connected as'**
  String get settingsSyncConnectedAs;

  /// No description provided for @settingsSyncLastSynced.
  ///
  /// In en, this message translates to:
  /// **'Last synced'**
  String get settingsSyncLastSynced;

  /// No description provided for @settingsSyncConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect Google account'**
  String get settingsSyncConnect;

  /// No description provided for @settingsSyncDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get settingsSyncDisconnect;

  /// No description provided for @settingsSyncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get settingsSyncNow;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacy;

  /// No description provided for @settingsPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'Voxa stores targets, sessions, and recordings locally on this device for the MVP.'**
  String get settingsPrivacyBody;

  /// No description provided for @settingsPrivacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explain data handling clearly and keep risk low.'**
  String get settingsPrivacySubtitle;

  /// No description provided for @settingsResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset local data'**
  String get settingsResetTitle;

  /// No description provided for @settingsResetBody.
  ///
  /// In en, this message translates to:
  /// **'Delete all saved targets, sessions, and recordings from this device.'**
  String get settingsResetBody;

  /// No description provided for @settingsDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep destructive actions isolated from everyday settings.'**
  String get settingsDataSubtitle;

  /// No description provided for @settingsResetAction.
  ///
  /// In en, this message translates to:
  /// **'Reset data'**
  String get settingsResetAction;

  /// No description provided for @settingsResetConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset all local data?'**
  String get settingsResetConfirmTitle;

  /// No description provided for @settingsResetConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get settingsResetConfirmBody;

  /// No description provided for @settingsResetConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Delete everything'**
  String get settingsResetConfirmAction;

  /// No description provided for @settingsResetDone.
  ///
  /// In en, this message translates to:
  /// **'Local data cleared'**
  String get settingsResetDone;

  /// No description provided for @settingsLocaleEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLocaleEnglish;

  /// No description provided for @settingsLocaleGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get settingsLocaleGerman;

  /// No description provided for @settingsAddReminder.
  ///
  /// In en, this message translates to:
  /// **'Add reminder'**
  String get settingsAddReminder;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get commonDiscard;

  /// No description provided for @commonRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get commonRepeat;

  /// No description provided for @commonMin.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get commonMin;

  /// No description provided for @commonMax.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get commonMax;

  /// No description provided for @commonUnitHz.
  ///
  /// In en, this message translates to:
  /// **'Hz'**
  String get commonUnitHz;

  /// No description provided for @commonUnitDb.
  ///
  /// In en, this message translates to:
  /// **'dB'**
  String get commonUnitDb;

  /// No description provided for @commonUnitDbfs.
  ///
  /// In en, this message translates to:
  /// **'dBFS'**
  String get commonUnitDbfs;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

  /// No description provided for @commonHz.
  ///
  /// In en, this message translates to:
  /// **'{value} Hz'**
  String commonHz(String value);

  /// No description provided for @commonRangeHz.
  ///
  /// In en, this message translates to:
  /// **'{min}-{max} Hz'**
  String commonRangeHz(String min, String max);

  /// No description provided for @commonPercent.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String commonPercent(String value);

  /// No description provided for @commonSeconds.
  ///
  /// In en, this message translates to:
  /// **'{value}s'**
  String commonSeconds(String value);

  /// No description provided for @commonToleranceHz.
  ///
  /// In en, this message translates to:
  /// **'±{value} Hz'**
  String commonToleranceHz(String value);

  /// No description provided for @commonToleranceDb.
  ///
  /// In en, this message translates to:
  /// **'±{value} dB'**
  String commonToleranceDb(String value);

  /// No description provided for @commonDbfsTolerance.
  ///
  /// In en, this message translates to:
  /// **'{value} dBFS ± {tolerance} dB'**
  String commonDbfsTolerance(String value, String tolerance);

  /// No description provided for @commonMillisecondsShort.
  ///
  /// In en, this message translates to:
  /// **'{value} ms'**
  String commonMillisecondsShort(int value);

  /// No description provided for @commonMinutesShort.
  ///
  /// In en, this message translates to:
  /// **'{value} min'**
  String commonMinutesShort(int value);

  /// No description provided for @weekdayMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekdayMonday;

  /// No description provided for @weekdayTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get weekdayTuesday;

  /// No description provided for @weekdayWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get weekdayWednesday;

  /// No description provided for @weekdayThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get weekdayThursday;

  /// No description provided for @weekdayFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get weekdayFriday;

  /// No description provided for @weekdaySaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekdaySaturday;

  /// No description provided for @weekdaySunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekdaySunday;

  /// No description provided for @practiceTextWarmupTitle.
  ///
  /// In en, this message translates to:
  /// **'Warm-up paragraph'**
  String get practiceTextWarmupTitle;

  /// No description provided for @practiceTextWarmupBody.
  ///
  /// In en, this message translates to:
  /// **'I am taking a calm breath and speaking with a steady, comfortable voice today.'**
  String get practiceTextWarmupBody;

  /// No description provided for @practiceTextDailyTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily check-in'**
  String get practiceTextDailyTitle;

  /// No description provided for @practiceTextDailyBody.
  ///
  /// In en, this message translates to:
  /// **'My voice can change over time, and I can practice in a way that feels supportive and sustainable.'**
  String get practiceTextDailyBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
