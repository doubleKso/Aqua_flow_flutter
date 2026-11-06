import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/liquid_card.dart';
import '../../domain/entities/hydration_settings.dart';
import '../controllers/hydration_controller.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hydration = ref.watch(hydrationControllerProvider);
    return SafeArea(
      bottom: false,
      child: hydration.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text('Could not load settings')),
        data: (state) => _SettingsContent(state: state),
      ),
    );
  }
}

class _SettingsContent extends ConsumerWidget {
  const _SettingsContent({required this.state});

  final HydrationViewState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = state.snapshot.settings;
    final controller = ref.read(hydrationControllerProvider.notifier);

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
      children: [
        Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Make your hydration rhythm feel natural.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 22),
        _SectionLabel(label: 'DAILY TARGET'),
        const SizedBox(height: 9),
        LiquidCard(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Water goal',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${settings.dailyGoalMl} ml',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '${(settings.dailyGoalMl / settings.defaultDrinkMl).ceil()} glasses',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Slider(
                value: settings.dailyGoalMl.clamp(1200, 4000).toDouble(),
                min: 1200,
                max: 4000,
                divisions: 14,
                label: '${settings.dailyGoalMl} ml',
                onChanged: state.isSaving
                    ? null
                    : (value) => controller.saveSettings(
                        settings.copyWith(
                          dailyGoalMl: (value / 200).round() * 200,
                        ),
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('1.2 L', style: _captionStyle(context)),
                  Text('4.0 L', style: _captionStyle(context)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _SectionLabel(label: 'DEFAULT GLASS'),
        const SizedBox(height: 9),
        LiquidCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Used when Aqua Flow opens',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [150, 250, 350, 500].map((amount) {
                  final selected = settings.defaultDrinkMl == amount;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: amount == 500 ? 0 : 8),
                      child: Material(
                        color: selected
                            ? Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.13)
                            : Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest
                                  .withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          onTap: state.isSaving
                              ? null
                              : () => controller.saveSettings(
                                  settings.copyWith(defaultDrinkMl: amount),
                                ),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            height: 72,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: selected
                                  ? Border.all(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    )
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.local_drink_outlined,
                                  size: 19,
                                  color: selected
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '$amount',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: selected
                                        ? Theme.of(context).colorScheme.primary
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _SectionLabel(label: 'APPEARANCE'),
        const SizedBox(height: 9),
        LiquidCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SegmentedButton<AppThemePreference>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                    value: AppThemePreference.system,
                    icon: Icon(Icons.brightness_auto_outlined),
                    label: Text('Auto'),
                  ),
                  ButtonSegment(
                    value: AppThemePreference.light,
                    icon: Icon(Icons.light_mode_outlined),
                    label: Text('Light'),
                  ),
                  ButtonSegment(
                    value: AppThemePreference.dark,
                    icon: Icon(Icons.dark_mode_outlined),
                    label: Text('Dark'),
                  ),
                ],
                selected: {settings.themePreference},
                onSelectionChanged: state.isSaving
                    ? null
                    : (selection) => controller.saveSettings(
                        settings.copyWith(themePreference: selection.first),
                      ),
              ),
              const SizedBox(height: 18),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    const Icon(Icons.volume_up_outlined),
                    const SizedBox(width: 13),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reminder sound',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'Use the device’s default alert tone',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: settings.soundEnabled,
                      onChanged: state.isSaving
                          ? null
                          : (value) => controller.saveSettings(
                              settings.copyWith(soundEnabled: value),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _SectionLabel(label: 'LOCAL & PRIVATE'),
        const SizedBox(height: 9),
        LiquidCard(
          child: Column(
            children: [
              _InfoRow(
                icon: Icons.language_rounded,
                title: 'Device timezone',
                value: settings.timezone,
              ),
              const Divider(height: 24),
              const _InfoRow(
                icon: Icons.cloud_off_outlined,
                title: 'Offline storage',
                value: 'On this device',
              ),
              const Divider(height: 24),
              const _InfoRow(
                icon: Icons.shield_outlined,
                title: 'Cloud account',
                value: 'Not required',
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Center(
          child: Column(
            children: [
              const Icon(Icons.water_drop_rounded, color: Color(0xFF18B8E6)),
              const SizedBox(height: 7),
              const Text(
                'Aqua Flow',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              Text('Version 1.0.0', style: _captionStyle(context)),
            ],
          ),
        ),
      ],
    );
  }

  TextStyle _captionStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      fontSize: 12,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 13),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
