import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/liquid_card.dart';
import '../../domain/entities/hydration_snapshot.dart';
import '../controllers/hydration_controller.dart';

class InsightsPage extends ConsumerWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hydration = ref.watch(hydrationControllerProvider);
    return SafeArea(
      bottom: false,
      child: hydration.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text('Could not load insights')),
        data: (state) => _InsightsContent(snapshot: state.snapshot),
      ),
    );
  }
}

class _InsightsContent extends StatelessWidget {
  const _InsightsContent({required this.snapshot});

  final HydrationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final week = snapshot.dailyTotals
        .skip(snapshot.dailyTotals.length - 7)
        .toList();
    final total = week.fold<int>(0, (sum, day) => sum + day.totalMl);
    final average = total ~/ 7;
    final completedDays = snapshot.dailyTotals
        .where((day) => day.totalMl >= snapshot.settings.dailyGoalMl)
        .length;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
      children: [
        Text(
          'Insights',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Small sips add up to a steady rhythm.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 22),
        LiquidCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WEEKLY FLOW',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${(total / 1000).toStringAsFixed(1)} L',
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1,
                            ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    'Goal ${(snapshot.settings.dailyGoalMl / 1000).toStringAsFixed(1)} L/day',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              SizedBox(
                height: 180,
                child: _WeeklyBarChart(
                  days: week,
                  goalMl: snapshot.settings.dailyGoalMl,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _InsightMetric(
                icon: Icons.water_drop_outlined,
                label: 'Daily average',
                value: '$average ml',
                color: const Color(0xFF27BFE8),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InsightMetric(
                icon: Icons.workspace_premium_outlined,
                label: '28-day goals',
                value: '$completedDays days',
                color: const Color(0xFF48CFAE),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Last 28 days',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        LiquidCard(
          child: _HydrationCalendar(
            days: snapshot.dailyTotals,
            goalMl: snapshot.settings.dailyGoalMl,
          ),
        ),
        const SizedBox(height: 14),
        LiquidCard(
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFB766), Color(0xFFFF7B54)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.local_fire_department_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${snapshot.streak}-day goal streak',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      snapshot.streak == 0
                          ? 'Complete today to start a new streak.'
                          : 'Consistency looks good on you.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeeklyBarChart extends StatelessWidget {
  const _WeeklyBarChart({required this.days, required this.goalMl});

  final List<DailyHydrationTotal> days;
  final int goalMl;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: days.map((day) {
        final ratio = (day.totalMl / goalMl).clamp(0.0, 1.0);
        final isToday = DateUtils.isSameDay(day.date, DateTime.now());
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                day.totalMl == 0 ? '' : (day.totalMl / 1000).toStringAsFixed(1),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    heightFactor: ratio == 0 ? 0.04 : ratio,
                    widthFactor: 0.52,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: day.totalMl >= goalMl
                              ? const [Color(0xFF52DFBE), Color(0xFF20A988)]
                              : const [Color(0xFF5ADAF7), Color(0xFF0B8FB9)],
                        ),
                        borderRadius: BorderRadius.circular(99),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF17ACD2,
                            ).withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 28,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isToday
                      ? Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.13)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  DateFormat('E').format(day.date).substring(0, 1),
                  style: TextStyle(
                    color: isToday
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _HydrationCalendar extends StatelessWidget {
  const _HydrationCalendar({required this.days, required this.goalMl});

  final List<DailyHydrationTotal> days;
  final int goalMl;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('MMMM yyyy').format(days.last.date),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: days.length,
          itemBuilder: (context, index) {
            final day = days[index];
            final ratio = (day.totalMl / goalMl).clamp(0.0, 1.0);
            return Tooltip(
              message:
                  '${DateFormat('MMM d').format(day.date)} • ${day.totalMl} ml',
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: ratio == 0
                      ? Theme.of(context).colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.5)
                      : color.withValues(alpha: 0.16 + ratio * 0.72),
                  borderRadius: BorderRadius.circular(10),
                  border: DateUtils.isSameDay(day.date, DateTime.now())
                      ? Border.all(color: color, width: 1.5)
                      : null,
                ),
                child: Center(
                  child: Text(
                    '${day.date.day}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: ratio > 0.55 ? Colors.white : null,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _InsightMetric extends StatelessWidget {
  const _InsightMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LiquidCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 3),
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
