import 'package:flutter/material.dart';

import '../helper/color.dart';

class AdaptiveList<T> extends StatelessWidget {
  const AdaptiveList({
    super.key,
    required this.crossAxisCount,
    required this.items,
    this.breakpointAxisPairings,
    required this.renderFunction,
    this.spacing = EdgeInsets.zero,
  }) : assert(crossAxisCount > 0);

  final List<T> items;
  final Widget Function(T) renderFunction;
  final EdgeInsets spacing;
  final int crossAxisCount;
  final List<BreakpointAxisPairing>? breakpointAxisPairings;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      int currAxisCount = crossAxisCount;

      if (breakpointAxisPairings != null) {
        double latestDistance = double.maxFinite; // max int
        double currentScreenWidth = constraints.maxWidth;

        for (var bap in breakpointAxisPairings!) {
          double currentDifference = (currentScreenWidth - bap.breakpoint);

          if (currentDifference < latestDistance && currentDifference > 0) {
            latestDistance = currentDifference;
            currAxisCount = bap.crossAxisCount;
          }
        }
      }
      return Wrap(children: [
        for (var item in items)
          Container(
            width: (constraints.maxWidth / currAxisCount),
            padding: spacing,
            child: renderFunction(item),
          )
      ]);
    });
  }
}

class BreakpointAxisPairing {
  const BreakpointAxisPairing(
      {required this.breakpoint, required this.crossAxisCount})
      : assert(breakpoint > 0),
        assert(crossAxisCount > 0);

  // if current screen is higher than breakpoint,
  // apply crossAxisCount to it
  final int breakpoint;
  final int crossAxisCount;
}
