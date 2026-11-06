import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

class HydrationOrb extends StatelessWidget {
  const HydrationOrb({
    required this.progress,
    required this.totalMl,
    required this.goalMl,
    super.key,
  });

  final double progress;
  final int totalMl;
  final int goalMl;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return TweenAnimationBuilder<double>(
      tween: Tween(end: progress.clamp(0, 1)),
      duration: const Duration(milliseconds: 850),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return SizedBox.square(
          dimension: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _LiquidOrbPainter(
                    progress: value,
                    backgroundColor: colors.surfaceContainerHighest.withValues(
                      alpha: 0.55,
                    ),
                    borderColor: colors.primary.withValues(alpha: 0.34),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$totalMl',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.5,
                    ),
                  ),
                  Text(
                    'of $goalMl ml',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.surface.withValues(alpha: 0.72),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      child: Text(
                        '${(value * 100).round()}%',
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LiquidOrbPainter extends CustomPainter {
  const _LiquidOrbPainter({
    required this.progress,
    required this.backgroundColor,
    required this.borderColor,
  });

  final double progress;
  final Color backgroundColor;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final circle = Path()..addOval(rect.deflate(5));
    canvas.drawPath(circle, Paint()..color = backgroundColor);
    canvas.save();
    canvas.clipPath(circle);

    final level = size.height - (size.height * progress);
    final wave = Path()..moveTo(-20, level);
    const amplitude = 7.0;
    for (double x = -20; x <= size.width + 20; x += 4) {
      final y = level + math.sin(x / 20) * amplitude;
      wave.lineTo(x, y);
    }
    wave
      ..lineTo(size.width + 20, size.height + 20)
      ..lineTo(-20, size.height + 20)
      ..close();

    canvas.drawPath(
      wave,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF55D7F6), AquaColors.deepAqua],
        ).createShader(rect),
    );
    canvas.restore();
    canvas.drawPath(
      circle,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );
    canvas.drawArc(
      rect.deflate(14),
      -2.5,
      1.15,
      false,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.45)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 5,
    );
  }

  @override
  bool shouldRepaint(_LiquidOrbPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.borderColor != borderColor;
  }
}
