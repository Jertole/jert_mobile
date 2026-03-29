import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/state/app_controller.dart';
import '../../core/ui/jert_colors.dart';
import '../../core/ui/jert_scaffold_background.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  final AppController controller;

  const SplashScreen({
    super.key,
    required this.controller,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _pulseController;
  late final AnimationController _lineController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _titleFade;
  late final Animation<double> _subtitleFade;
  late final Animation<double> _lineProgress;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _lineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _logoScale = Tween<double>(
      begin: 0.88,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeOutCubic,
      ),
    );

    _logoFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _titleFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.25, 0.9, curve: Curves.easeOut),
      ),
    );

    _subtitleFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
      ),
    );

    _lineProgress = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _lineController,
        curve: Curves.easeInOut,
      ),
    );

    _logoController.forward();
    _lineController.forward();

    Timer(const Duration(milliseconds: 2600), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (_, __, ___) =>
              WelcomeScreen(controller: widget.controller),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _pulseController.dispose();
    _lineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JertScaffoldBackground(
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _logoController,
            _pulseController,
            _lineController,
          ]),
          builder: (context, _) {
            final pulse = 1 + (_pulseController.value * 0.05);

            return Stack(
              children: [
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: _GridGlowPainter(
                        glowStrength: _pulseController.value,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.scale(
                        scale: _logoScale.value * pulse,
                        child: Opacity(
                          opacity: _logoFade.value,
                          child: _SplashLogo(
                            glowAlpha: 0.22 + (_pulseController.value * 0.16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Opacity(
                        opacity: _titleFade.value,
                        child: const _SplashTitle(),
                      ),
                      const SizedBox(height: 10),
                      Opacity(
                        opacity: _subtitleFade.value,
                        child: const Text(
                          'Authorized Infrastructure Access',
                          style: TextStyle(
                            color: JertColors.textSecondary,
                            fontSize: 15,
                            letterSpacing: 0.3,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 26),
                      SizedBox(
                        width: 180,
                        child: _ProgressLine(progress: _lineProgress.value),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 34,
                  child: Opacity(
                    opacity: _subtitleFade.value,
                    child: const Center(
                      child: Text(
                        'Cold • LCNG • DC • Treasury',
                        style: TextStyle(
                          color: JertColors.textMuted,
                          fontSize: 12,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SplashLogo extends StatelessWidget {
  final double glowAlpha;

  const _SplashLogo({
    required this.glowAlpha,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 106,
      height: 106,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: JertColors.neonCyan.withValues(alpha: glowAlpha),
            blurRadius: 34,
            spreadRadius: 4,
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.08),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipOval(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/icons/jert_logo_neon.webp',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF123246),
                      Color(0xFF0B1622),
                    ],
                  ),
                  border: Border.all(
                    color: JertColors.borderCyan,
                    width: 1.2,
                  ),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'J',
                  style: TextStyle(
                    color: JertColors.neonCyan,
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              top: 8,
              child: Container(
                height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.42),
                      Colors.white.withValues(alpha: 0.02),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SplashTitle extends StatelessWidget {
  const _SplashTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'JERT',
      style: TextStyle(
        fontSize: 38,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.8,
        color: JertColors.neonCyan,
        shadows: [
          Shadow(
            color: Color(0xAA2CF6FF),
            blurRadius: 20,
          ),
          Shadow(
            color: Color(0x552CF6FF),
            blurRadius: 34,
          ),
        ],
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  final double progress;

  const _ProgressLine({
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: 0.08),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: progress.clamp(0.0, 1.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              gradient: const LinearGradient(
                colors: [
                  JertColors.glossBlueTop,
                  JertColors.glossBlueBottom,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: JertColors.glossBlueGlow.withValues(alpha: 0.38),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GridGlowPainter extends CustomPainter {
  final double glowStrength;

  _GridGlowPainter({
    required this.glowStrength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..strokeWidth = 1;

    const step = 38.0;

    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }

    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          JertColors.neonCyan.withValues(alpha: 0.06 + glowStrength * 0.05),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height * 0.34),
          radius: math.max(size.width, size.height) * 0.36,
        ),
      );

    canvas.drawRect(
      Offset.zero & size,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GridGlowPainter oldDelegate) {
    return oldDelegate.glowStrength != glowStrength;
  }
}
