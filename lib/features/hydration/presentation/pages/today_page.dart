import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/liquid_card.dart';
import '../controllers/hydration_controller.dart';
import '../widgets/hydration_orb.dart';

class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hydration = ref.watch(hydrationControllerProvider);
    return SafeArea(
      bottom: false,
      child: hydration.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorState(error: error),
        data: (viewState) => _TodayContent(viewState: viewState),
      ),
    );
  }
}

class _TodayContent extends ConsumerWidget {
  const _TodayContent({required this.viewState});

  final HydrationViewState viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = viewState.snapshot;
    final controller = ref.read(hydrationControllerProvider.notifier);
    final now = DateTime.now();
    final greeting = now.hour < 12
        ? 'Good morning'
        : now.hour < 18
        ? 'Good afternoon'
        : 'Good evening';
    final cupSizes = <int>{
      150,
      250,
      350,
      500,
      snapshot.settings.defaultDrinkMl,
    }.toList()..sort();

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.7,
                          ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      DateFormat('EEEE, MMMM d').format(now),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.water_drop_rounded, size: 28),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          LiquidCard(
            padding: const EdgeInsets.fromLTRB(18, 22, 18, 20),
            child: Column(
              children: [
                HydrationOrb(
                  progress: snapshot.progress,
                  totalMl: snapshot.todayTotalMl,
                  goalMl: snapshot.settings.dailyGoalMl,
                ),
                const SizedBox(height: 12),
                Text(
                  snapshot.goalReached
                      ? 'You reached today’s goal 🎉'
                      : '${snapshot.remainingMl} ml to feel fully refreshed',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 70,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: cupSizes.length + 1,
                    separatorBuilder: (_, _) => const SizedBox(width: 9),
                    itemBuilder: (context, index) {
                      if (index == cupSizes.length) {
                        return _AmountChip(
                          label: 'Custom',
                          icon: Icons.add_rounded,
                          selected: !cupSizes.contains(
                            viewState.selectedAmountMl,
                          ),
                          onTap: () => _showCustomAmount(context, controller),
                        );
                      }
                      final amount = cupSizes[index];
                      return _AmountChip(
                        label: '$amount ml',
                        icon: Icons.local_drink_outlined,
                        selected: viewState.selectedAmountMl == amount,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          controller.selectAmount(amount);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: viewState.isSaving
                      ? null
                      : () async {
                          HapticFeedback.mediumImpact();
                          await controller.addSelectedDrink();
                        },
                  icon: viewState.isSaving
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add_rounded),
                  label: Text('Add ${viewState.selectedAmountMl} ml'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(60),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                if (snapshot.recentEntries.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: viewState.isSaving
                        ? null
                        : controller.undoMostRecentDrink,
                    icon: const Icon(Icons.undo_rounded, size: 18),
                    label: const Text('Undo last drink'),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MiniMetric(
                  icon: Icons.local_fire_department_rounded,
                  color: const Color(0xFFFFA24C),
                  value: '${snapshot.streak} days',
                  label: 'Goal streak',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MiniMetric(
                  icon: Icons.notifications_active_outlined,
                  color: const Color(0xFF19B8E6),
                  value: viewState.nextReminder == null
                      ? 'Off'
                      : DateFormat('h:mm a').format(viewState.nextReminder!),
                  label: 'Next reminder',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Text(
                'Today’s sips',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const Spacer(),
              Text(
                '${snapshot.todayEntries.length} entries',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (snapshot.todayEntries.isEmpty)
            LiquidCard(
              child: Row(
                children: [
                  Icon(
                    Icons.water_drop_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Your first refreshing sip will appear here.'),
                  ),
                ],
              ),
            )
          else
            LiquidCard(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Column(
                children: [
                  for (
                    var index = 0;
                    index < snapshot.todayEntries.length;
                    index++
                  ) ...[
                    _DrinkRow(
                      amountMl: snapshot.todayEntries[index].amountMl,
                      time: snapshot.todayEntries[index].consumedAt,
                    ),
                    if (index != snapshot.todayEntries.length - 1)
                      const Divider(height: 1),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _showCustomAmount(
    BuildContext context,
    HydrationController controller,
  ) async {
    final textController = TextEditingController();
    final amount = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 26),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    child: Container(
                      width: 42,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Custom amount',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: textController,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      suffixText: 'ml',
                    ),
                    onSubmitted: (value) {
                      final parsed = int.tryParse(value);
                      if (parsed != null && parsed > 0 && parsed <= 5000) {
                        Navigator.pop(context, parsed);
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  FilledButton(
                    onPressed: () {
                      final parsed = int.tryParse(textController.text);
                      if (parsed != null && parsed > 0 && parsed <= 5000) {
                        Navigator.pop(context, parsed);
                      }
                    },
                    child: const Text('Use amount'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    textController.dispose();
    if (amount != null) controller.selectAmount(amount);
  }
}

class _AmountChip extends StatelessWidget {
  const _AmountChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: selected
          ? colors.primary.withValues(alpha: 0.14)
          : colors.surfaceContainerHighest.withValues(alpha: 0.55),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: selected ? colors.primary : Colors.transparent,
          width: 1.3,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          width: 86,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: selected ? colors.primary : colors.onSurfaceVariant,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: selected ? colors.primary : colors.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return LiquidCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _DrinkRow extends StatelessWidget {
  const _DrinkRow({required this.amountMl, required this.time});

  final int amountMl;
  final DateTime time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Padding(
              padding: EdgeInsets.all(9),
              child: Icon(Icons.water_drop_rounded, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$amountMl ml',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          Text(
            DateFormat('h:mm a').format(time),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends ConsumerWidget {
  const _ErrorState({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 44),
            const SizedBox(height: 12),
            const Text('Aqua Flow needs a quick refresh.'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => ref.invalidate(hydrationControllerProvider),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
