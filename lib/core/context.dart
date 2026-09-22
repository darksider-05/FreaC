import 'package:flutter/material.dart';

extension ResponsiveContext on BuildContext {
  ViewportMetrics get ui => ViewportMetrics(this);
}

/// Provides viewport dimensions and percentage-based sizing.
///
/// Access through:
///
/// ```dart
/// final ui = context.ui;
/// ```
///
/// The viewport axes remain consistent regardless of device orientation.
///
/// - [width] and [height] return the full logical viewport dimensions.
/// - [vw] and [vh] return a percentage of those dimensions.
class ViewportMetrics {
  final double _sh;
  final double _lg;
  final bool _isver;

  ViewportMetrics(BuildContext context)
    : _sh = MediaQuery.sizeOf(context).shortestSide,
      _lg = MediaQuery.sizeOf(context).longestSide,
      _isver = (MediaQuery.of(context).orientation == Orientation.portrait);

  /// Returns the logical horizontal viewport length.
  double get width => _isver ? _sh : _lg;

  /// Returns `percent` percent of the logical horizontal viewport.
  double vw(double percent) => width * percent / 100;

  /// Returns the logical vertical viewport length.
  double get height => _isver ? _lg : _sh;

  /// Returns `percent` percent of the logical vertical viewport.
  double vh(double percent) => height * percent / 100;
}
