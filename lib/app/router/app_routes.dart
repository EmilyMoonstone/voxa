import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

sealed class VoxaRoute {
  const VoxaRoute();

  String get location;

  void go(BuildContext context) => context.go(location);
}

final class OnboardingWelcomeRoute extends VoxaRoute {
  const OnboardingWelcomeRoute();

  static const path = '/onboarding/welcome';

  @override
  String get location => path;
}

final class OnboardingTargetRoute extends VoxaRoute {
  const OnboardingTargetRoute();

  static const path = '/onboarding/target';

  @override
  String get location => path;
}

final class OnboardingPermissionsRoute extends VoxaRoute {
  const OnboardingPermissionsRoute();

  static const path = '/onboarding/permissions';

  @override
  String get location => path;
}

final class HomeRoute extends VoxaRoute {
  const HomeRoute();

  static const path = '/';

  @override
  String get location => path;
}

final class TargetRoute extends VoxaRoute {
  const TargetRoute();

  static const path = '/target';

  @override
  String get location => path;
}

final class PracticeRoute extends VoxaRoute {
  const PracticeRoute();

  static const path = '/practice';

  @override
  String get location => path;
}

final class PracticeRecordRoute extends VoxaRoute {
  const PracticeRecordRoute();

  static const path = '/practice/record';

  @override
  String get location => path;
}

final class RecordRoute extends PracticeRecordRoute {
  const RecordRoute();
}

final class HistoryRoute extends VoxaRoute {
  const HistoryRoute();

  static const path = '/history';

  @override
  String get location => path;
}

final class SessionDetailRoute extends VoxaRoute {
  const SessionDetailRoute(this.sessionId);

  static const pathPattern = '/history/session/:sessionId';

  final String sessionId;

  @override
  String get location => '${HistoryRoute.path}/session/$sessionId';
}

final class SettingsRoute extends VoxaRoute {
  const SettingsRoute();

  static const path = '/settings';

  @override
  String get location => path;
}

final class SettingsLanguageRoute extends VoxaRoute {
  const SettingsLanguageRoute();

  static const path = '/settings/language';

  @override
  String get location => path;
}

final class SettingsAnalysisRoute extends VoxaRoute {
  const SettingsAnalysisRoute();

  static const path = '/settings/analysis';

  @override
  String get location => path;
}

final class SettingsTrainingPlanRoute extends VoxaRoute {
  const SettingsTrainingPlanRoute();

  static const path = '/settings/training-plan';

  @override
  String get location => path;
}

final class SettingsSyncRoute extends VoxaRoute {
  const SettingsSyncRoute();

  static const path = '/settings/sync';

  @override
  String get location => path;
}

final class SettingsPrivacyRoute extends VoxaRoute {
  const SettingsPrivacyRoute();

  static const path = '/settings/privacy';

  @override
  String get location => path;
}

final class SettingsDataRoute extends VoxaRoute {
  const SettingsDataRoute();

  static const path = '/settings/data';

  @override
  String get location => path;
}
