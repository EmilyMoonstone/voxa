import 'package:flutter/material.dart';
import 'package:voxa/l10n/app_localizations.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/theme/voxa_tokens.dart';

class VoxaShellScaffold extends StatelessWidget {
  const VoxaShellScaffold({
    required this.location,
    required this.child,
    super.key,
  });

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canExitShell = location == HomeRoute.path;
    final selectedIndex = _selectedIndex(location);

    return PopScope(
      canPop: canExitShell,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop || canExitShell) {
          return;
        }
        const HomeRoute().go(context);
      },
      child: Scaffold(
        backgroundColor: VoxaColors.backgroundDark,
        extendBody: true,
        body: ColoredBox(
          color: VoxaColors.backgroundDark,
          child: SafeArea(child: child),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            switch (index) {
              case 0:
                const HomeRoute().go(context);
                return;
              case 1:
                const PracticeRoute().go(context);
                return;
              case 2:
                const HistoryRoute().go(context);
                return;
              case 3:
                const SettingsRoute().go(context);
                return;
            }
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home_rounded),
              label: l10n.navHome,
            ),
            NavigationDestination(
              icon: const Icon(Icons.graphic_eq_outlined),
              selectedIcon: const Icon(Icons.graphic_eq_rounded),
              label: l10n.navPractice,
            ),
            NavigationDestination(
              icon: const Icon(Icons.history),
              selectedIcon: const Icon(Icons.history_toggle_off),
              label: l10n.navHistory,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings_rounded),
              label: l10n.navSettings,
            ),
          ],
        ),
      ),
    );
  }

  int _selectedIndex(String value) {
    if (value.startsWith(PracticeRoute.path) ||
        value.startsWith(PracticeRecordRoute.path)) {
      return 1;
    }
    if (value.startsWith(HistoryRoute.path)) {
      return 2;
    }
    if (value.startsWith(SettingsRoute.path)) {
      return 3;
    }
    return 0;
  }
}
