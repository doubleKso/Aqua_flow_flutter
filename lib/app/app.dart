import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/hydration/domain/entities/hydration_settings.dart';
import '../features/hydration/presentation/controllers/hydration_controller.dart';
import '../features/hydration/presentation/pages/hydration_home.dart';
import 'theme/app_theme.dart';

class AquaFlowApp extends ConsumerWidget {
  const AquaFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hydration = ref.watch(hydrationControllerProvider);
    final preference =
        hydration.value?.snapshot.settings.themePreference ??
        AppThemePreference.system;

    return MaterialApp(
      title: 'Aqua Flow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: switch (preference) {
        AppThemePreference.light => ThemeMode.light,
        AppThemePreference.dark => ThemeMode.dark,
        AppThemePreference.system => ThemeMode.system,
      },
      home: const HydrationHome(),
    );
  }
}
