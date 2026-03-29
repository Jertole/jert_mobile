import 'package:flutter/material.dart';
import 'jert_colors.dart';

class JertPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double height;
  final double radius;
  final EdgeInsetsGeometry? padding;

  const JertPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 52,
    this.radius = 16,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: JertColors.primaryGlossGradient,
            boxShadow: JertColors.primaryGlow,
          ),
          child: Stack(
            children: [
              Positioned(
                left: 10,
                right: 10,
                top: 6,
                child: Container(
                  height: 14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.55),
                        Colors.white.withValues(alpha: 0.10),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(radius),
                    onTap: onPressed,
                    child: Padding(
                      padding: padding ?? EdgeInsets.zero,
                      child: Center(
                        child: Text(
                          text,
                          style: const TextStyle(
                            color: JertColors.textDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
