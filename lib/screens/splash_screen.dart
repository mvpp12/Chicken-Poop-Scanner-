import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import '../l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _progressValue;

  String _statusText = 'Initializing camera...';

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.3, 0.6, curve: Curves.easeIn),
      ),
    );

    _progressValue = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );

    _ctrl.forward();

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _statusText = 'Loading AI model...');
    });
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _statusText = 'Almost ready...');
    });

    Future.delayed(const Duration(milliseconds: 3200), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: size.height * 0.22,
                child: CustomPaint(painter: _FarmPainter()),
              ),
            ),
            SafeArea(
              child: AnimatedBuilder(
                animation: _ctrl,
                builder: (_, __) {
                  return Column(
                    children: [
                      SizedBox(height: size.height * 0.18),
                      Opacity(
                        opacity: _logoOpacity.value,
                        child: Transform.scale(
                          scale: _logoScale.value,
                          child: SvgPicture.asset(
                            'assets/images/chickenlogo.svg',
                            width: 110,
                            height: 110,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Opacity(
                        opacity: _textOpacity.value,
                        child: Column(
                          children: [
                            Text(
                              'Chicken',
                              style: AppTypography.displayLarge.copyWith(
                                color: AppColors.primary,
                                height: 1.1,
                              ),
                            ),
                            Text(
                              'Health Scan',
                              style: AppTypography.displayLarge.copyWith(
                                color: AppColors.primary,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenPadding,
                        ),
                        child: Opacity(
                          opacity: _textOpacity.value,
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusFull,
                                ),
                                child: LinearProgressIndicator(
                                  value: _progressValue.value,
                                  minHeight: 5,
                                  backgroundColor: AppColors.primaryBorder
                                      .withOpacity(0.3),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        AppColors.primary,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                _statusText == 'Almost ready...'
                                    ? localization.almostReady
                                    : _statusText,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.30 + AppSpacing.md),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FarmPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primarySurface
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.2,
      size.width * 0.5,
      size.height * 0.45,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.65,
      size.width,
      size.height * 0.35,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);

    final barnPaint = Paint()..color = AppColors.primaryBorder;
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.6,
        size.height * 0.25,
        size.width * 0.15,
        size.height * 0.3,
      ),
      barnPaint,
    );
    final roofPath = Path()
      ..moveTo(size.width * 0.58, size.height * 0.26)
      ..lineTo(size.width * 0.675, size.height * 0.12)
      ..lineTo(size.width * 0.77, size.height * 0.26)
      ..close();
    canvas.drawPath(roofPath, barnPaint);
  }

  @override
  bool shouldRepaint(_) => false;
}
