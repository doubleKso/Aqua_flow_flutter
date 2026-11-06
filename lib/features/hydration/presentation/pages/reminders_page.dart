import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/notifications/notification_service.dart';
import '../../../../core/widgets/liquid_card.dart';
import '../controllers/hydration_controller.dart';

class RemindersPage extends ConsumerWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hydration = ref.watch(hydrationControllerProvider);
    return SafeArea(
      bottom: false,
      child: hydration.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text('Could not load reminders')),
        data: (state) => _RemindersContent(state: state),
      ),
    );
  }
}

class _RemindersContent extends ConsumerWidget {
  const _RemindersContent({required this.state});

  final HydrationViewState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(hydrationControllerProvider.notifier);
    final settings = state.snapshot.settings;
    final enabled = settings.remindersEnabled;
    final granted =
        state.permissionStatus == NotificationPermissionStatus.granted;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
      children: [
        Text(
          'Reminders',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Scheduled on your phone—even when Aqua Flow is closed.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 22),
        LiquidCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: enabled
                            ? const [Color(0xFF59D9F6), Color(0xFF087EA7)]
                            : [
                                Theme.of(context).colorScheme.outlineVariant,
                                Theme.of(context).colorScheme.outline,
                              ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: enabled
                          ? [
                              BoxShadow(
                                color: const Color(
                                  0xFF16B8E8,
                                ).withValues(alpha: 0.28),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      enabled
                          ? Icons.notifications_active_rounded
                          : Icons.notifications_off_outlined,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          enabled
                              ? 'Reminders are active'
                              : 'Reminders are off',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          enabled
                              ? '${state.pendingReminderCount} reminders safely queued'
                              : 'Turn them on when you’re ready',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: enabled,
                    onChanged: state.isSaving
                        ? null
                        : controller.setRemindersEnabled,
                  ),
                ],
              ),
              if (enabled) ...[
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.schedule_rounded, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        state.nextReminder == null
                            ? 'No more reminders today'
                            : 'Next at ${DateFormat('h:mm a').format(state.nextReminder!)}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
        _SectionTitle(
          title: 'Rhythm',
          caption: 'Drinking resets the countdown',
        ),
        const SizedBox(height: 10),
        LiquidCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Remind me every',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [30, 45, 60, 90, 120].map((minutes) {
                  final selected = settings.reminderIntervalMinutes == minutes;
                  return ChoiceChip(
                    selected: selected,
                    onSelected: state.isSaving
                        ? null
                        : (_) => controller.saveSettings(
                            settings.copyWith(reminderIntervalMinutes: minutes),
                          ),
                    label: Text(
                      minutes < 60
                          ? '$minutes min'
                          : '${minutes ~/ 60}${minutes % 60 == 0 ? ' hr' : '.5 hr'}',
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Divider(height: 1),
              _SettingsRow(
                icon: Icons.wb_sunny_outlined,
                title: 'Start time',
                value: _formatMinute(context, settings.startMinute),
                onTap: () => _pickTime(
                  context,
                  initialMinute: settings.startMinute,
                  onSelected: (minute) {
                    if (minute < settings.endMinute) {
                      controller.saveSettings(
                        settings.copyWith(startMinute: minute),
                      );
                    }
                  },
                ),
              ),
              const Divider(height: 1),
              _SettingsRow(
                icon: Icons.bedtime_outlined,
                title: 'End time',
                value: _formatMinute(context, settings.endMinute),
                onTap: () => _pickTime(
                  context,
                  initialMinute: settings.endMinute,
                  onSelected: (minute) {
                    if (minute > settings.startMinute) {
                      controller.saveSettings(
                        settings.copyWith(endMinute: minute),
                      );
                    }
                  },
                ),
              ),
              const Divider(height: 1),
              _ToggleRow(
                icon: Icons.weekend_outlined,
                title: 'Pause on weekends',
                subtitle: 'Skip Saturday and Sunday',
                value: settings.skipWeekends,
                onChanged: state.isSaving
                    ? null
                    : (value) => controller.saveSettings(
                        settings.copyWith(skipWeekends: value),
                      ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _SectionTitle(
          title: 'Diagnostics',
          caption: 'Useful when testing on a real phone',
        ),
        const SizedBox(height: 10),
        LiquidCard(
          child: Column(
            children: [
              _DiagnosticRow(
                label: 'Permission',
                value: granted ? 'Allowed' : 'Needs attention',
                good: granted,
              ),
              const Divider(height: 24),
              _DiagnosticRow(
                label: 'Scheduled',
                value: '${state.pendingReminderCount} / 48',
                good: enabled && state.pendingReminderCount > 0,
              ),
              const Divider(height: 24),
              _DiagnosticRow(
                label: 'Timezone',
                value: settings.timezone,
                good: true,
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: state.isSaving
                      ? null
                      : controller.sendTestNotification,
                  icon: const Icon(Icons.notifications_active_outlined),
                  label: const Text('Send test notification'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            'Aqua Flow keeps 48 upcoming reminders—below iOS’s 64 pending notification limit. Logging a drink replaces the queue so the next reminder starts from that sip.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }

  String _formatMinute(BuildContext context, int minute) {
    return TimeOfDay(hour: minute ~/ 60, minute: minute % 60).format(context);
  }

  Future<void> _pickTime(
    BuildContext context, {
    required int initialMinute,
    required ValueChanged<int> onSelected,
  }) async {
    final result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: initialMinute ~/ 60,
        minute: initialMinute % 60,
      ),
    );
    if (result != null) onSelected(result.hour * 60 + result.minute);
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.caption});

  final String title;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const Spacer(),
        Text(
          caption,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 13),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 5),
            const Icon(Icons.chevron_right_rounded, size: 20),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _DiagnosticRow extends StatelessWidget {
  const _DiagnosticRow({
    required this.label,
    required this.value,
    required this.good,
  });

  final String label;
  final String value;
  final bool good;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: good ? const Color(0xFF44CDA9) : const Color(0xFFFFA24C),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 7),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
