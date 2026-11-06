import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/hydration_controller.dart';
import 'insights_page.dart';
import 'reminders_page.dart';
import 'settings_page.dart';
import 'today_page.dart';

class HydrationHome extends ConsumerStatefulWidget {
  const HydrationHome({super.key});

  @override
  ConsumerState<HydrationHome> createState() => _HydrationHomeState();
}

class _HydrationHomeState extends ConsumerState<HydrationHome>
    with WidgetsBindingObserver {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(hydrationControllerProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(hydrationControllerProvider, (previous, next) {
      final notice = next.value?.notice;
      if (notice == null || notice == previous?.value?.notice) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(notice),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        );
      ref.read(hydrationControllerProvider.notifier).clearNotice();
    });

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          const _Atmosphere(),
          IndexedStack(
            index: _currentIndex,
            children: const [
              TodayPage(),
              InsightsPage(),
              RemindersPage(),
              SettingsPage(),
            ],
          ),
        ],
      ),
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) =>
                setState(() => _currentIndex = index),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.water_drop_outlined),
                selectedIcon: Icon(Icons.water_drop_rounded),
                label: 'Today',
              ),
              NavigationDestination(
                icon: Icon(Icons.bar_chart_rounded),
                selectedIcon: Icon(Icons.stacked_bar_chart_rounded),
                label: 'Insights',
              ),
              NavigationDestination(
                icon: Icon(Icons.notifications_none_rounded),
                selectedIcon: Icon(Icons.notifications_rounded),
                label: 'Reminders',
              ),
              NavigationDestination(
                icon: Icon(Icons.tune_rounded),
                selectedIcon: Icon(Icons.tune_rounded),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Atmosphere extends StatelessWidget {
  const _Atmosphere();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Positioned.fill(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.85, -1.1),
              radius: 1.3,
              colors: [
                const Color(0xFF60D9F7).withValues(alpha: isDark ? 0.13 : 0.28),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
