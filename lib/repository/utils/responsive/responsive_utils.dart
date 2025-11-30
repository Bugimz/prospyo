import 'package:flutter/widgets.dart';

/// Helper methods for sizing and padding that respond gracefully to different
/// screen sizes.
class ResponsiveUtils {
  /// Returns a size based on a fraction of the shortest screen side and clamps
  /// it between [min] and [max] to avoid extremes on very large or small
  /// devices.
  static double size(
    BuildContext context,
    double fraction, {
    double min = 8,
    double max = 64,
  }) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return (shortestSide * fraction).clamp(min, max);
  }

  /// Spacing helper around the app's primary layout areas.
  static EdgeInsets pagePadding(
    BuildContext context, {
    double horizontalFraction = 0.07,
    double verticalFraction = 0.05,
    double minHorizontal = 16,
    double maxHorizontal = 40,
    double minVertical = 16,
    double maxVertical = 48,
  }) {
    return EdgeInsets.symmetric(
      horizontal: size(
        context,
        horizontalFraction,
        min: minHorizontal,
        max: maxHorizontal,
      ),
      vertical: size(
        context,
        verticalFraction,
        min: minVertical,
        max: maxVertical,
      ),
    );
  }

  /// Provides vertical or horizontal gaps that scale with screen size while
  /// respecting reasonable bounds.
  static double gap(
    BuildContext context,
    double fraction, {
    double min = 12,
    double max = 48,
  }) {
    return size(context, fraction, min: min, max: max);
  }
}
