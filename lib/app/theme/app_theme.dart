import 'package:flutter/material.dart';

abstract final class AquaColors {
  static const aqua = Color(0xFF16B8E8);
  static const deepAqua = Color(0xFF087EA7);
  static const navy = Color(0xFF092638);
  static const mist = Color(0xFFF1FAFD);
  static const night = Color(0xFF06151F);
  static const nightSurface = Color(0xFF0D2532);
  static const mint = Color(0xFF43D6B5);
}

abstract final class AppTheme {
  static ThemeData get light => _build(
    brightness: Brightness.light,
    background: AquaColors.mist,
    surface: Colors.white,
    foreground: AquaColors.navy,
  );

  static ThemeData get dark => _build(
    brightness: Brightness.dark,
    background: AquaColors.night,
    surface: AquaColors.nightSurface,
    foreground: const Color(0xFFE8F7FC),
  );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color foreground,
  }) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: AquaColors.aqua,
          brightness: brightness,
          surface: surface,
        ).copyWith(
          primary: brightness == Brightness.light
              ? AquaColors.deepAqua
              : const Color(0xFF52D4F6),
          secondary: AquaColors.mint,
          onSurface: foreground,
          surfaceContainer: surface,
          surfaceContainerHighest: brightness == Brightness.light
              ? const Color(0xFFE3F4F9)
              : const Color(0xFF173543),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      splashFactory: InkSparkle.splashFactory,
      textTheme: Typography.material2021(
        platform: TargetPlatform.iOS,
        colorScheme: scheme,
      ).black.apply(bodyColor: foreground, displayColor: foreground),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: foreground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surface.withValues(
          alpha: brightness == Brightness.light ? 0.9 : 0.82,
        ),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface.withValues(alpha: 0.9),
        indicatorColor: scheme.primary.withValues(alpha: 0.14),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return TextStyle(
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? scheme.primary
                : scheme.onSurfaceVariant,
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.45),
        thickness: 0.7,
      ),
    );
  }
}
