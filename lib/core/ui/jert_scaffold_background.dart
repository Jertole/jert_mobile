import 'package:flutter/material.dart';
import 'jert_colors.dart';

class JertScaffoldBackground extends StatelessWidget {
  final Widget child;
  final String imageAsset;

  const JertScaffoldBackground({
    super.key,
    required this.child,
    this.imageAsset = 'assets/images/jert_bg_city.webp',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            imageAsset,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: JertColors.bgDeep,
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: JertColors.screenOverlay,
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: JertColors.neonAura,
              ),
            ),
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}
