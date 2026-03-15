import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/goal_setting/presentation/goal_setting_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/history/presentation/session_detail_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/practice/presentation/practice_screen.dart';
import '../../features/record/presentation/record_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/shell/presentation/app_shell.dart';
import '../bootstrap/app_bootstrap.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: ref.watch(initialLocationProvider),
    routes: [
      GoRoute(
        path: OnboardingWelcomeRoute.path,
        builder: (context, state) => const OnboardingWelcomeScreen(),
      ),
      GoRoute(
        path: OnboardingTargetRoute.path,
        builder: (context, state) => const OnboardingTargetScreen(),
      ),
      GoRoute(
        path: OnboardingPermissionsRoute.path,
        builder: (context, state) => const OnboardingPermissionsScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return VoxaShellScaffold(location: state.uri.path, child: child);
        },
        routes: [
          GoRoute(
            path: HomeRoute.path,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: TargetRoute.path,
            builder: (context, state) => const GoalSettingScreen(),
          ),
          GoRoute(
            path: PracticeRoute.path,
            builder: (context, state) => const PracticeScreen(),
            routes: [
              GoRoute(
                path: 'record',
                builder: (context, state) => const RecordScreen(),
              ),
            ],
          ),
          GoRoute(
            path: HistoryRoute.path,
            builder: (context, state) => const HistoryScreen(),
            routes: [
              GoRoute(
                parentNavigatorKey: _rootNavigatorKey,
                path: 'session/:sessionId',
                builder: (context, state) => SessionDetailScreen(
                  sessionId: state.pathParameters['sessionId']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: SettingsRoute.path,
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: SettingsLanguageRoute.path,
            builder: (context, state) => const SettingsLanguageScreen(),
          ),
          GoRoute(
            path: SettingsAnalysisRoute.path,
            builder: (context, state) => const SettingsAnalysisScreen(),
          ),
          GoRoute(
            path: SettingsTrainingPlanRoute.path,
            builder: (context, state) => const SettingsTrainingPlanScreen(),
          ),
          GoRoute(
            path: SettingsSyncRoute.path,
            builder: (context, state) => const SettingsSyncScreen(),
          ),
          GoRoute(
            path: SettingsPrivacyRoute.path,
            builder: (context, state) => const SettingsPrivacyScreen(),
          ),
          GoRoute(
            path: SettingsDataRoute.path,
            builder: (context, state) => const SettingsDataScreen(),
          ),
        ],
      ),
    ],
  );
});

final _rootNavigatorKey = GlobalKey<NavigatorState>();
