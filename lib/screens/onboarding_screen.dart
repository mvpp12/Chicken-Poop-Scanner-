import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import '../widgets/app_widgets.dart';
import '../l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingData(
      tag: 'Smart Scanning',
      title: 'AI-Powered\nDisease Detection',
      subtitle:
          'Instantly detect chicken diseases from poop samples using advanced AI technology trained on thousands of samples.',
      illustrationAsset: 'assets/onboarding/detection.png',
    ),
    _OnboardingData(
      tag: 'Fast & Accurate',
      title: 'Get Results\nin Seconds',
      subtitle:
          'Point your camera, capture a clear photo, and receive a detailed health diagnosis in 3-5 seconds.',
      illustrationAsset: 'assets/onboarding/results.png',
    ),
    _OnboardingData(
      tag: 'Farm Management',
      title: 'Keep Your\nFlock Healthy',
      subtitle:
          'Track scan history, monitor farm health trends, and get actionable recommendations to protect your flock.',
      illustrationAsset: 'assets/onboarding/flock_health.png',
    ),
  ];

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeInOutCubic,
      );
    } else {
      Navigator.of(context).pushReplacementNamed('/main');
    }
  }

  void _skip() => Navigator.of(context).pushReplacementNamed('/main');

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final pages = [
      _OnboardingData(
        tag: localization.smartScanning,
        title: localization.aiDiseaseDetection,
        subtitle:
            'Instantly detect chicken diseases from poop samples using advanced AI technology trained on thousands of samples.',
        illustrationAsset: 'assets/onboarding/detection.png',
      ),
      _OnboardingData(
        tag: localization.fastAccurate,
        title: localization.getResultsSeconds,
        subtitle:
            'Point your camera, capture a clear photo, and receive a detailed health diagnosis in 3-5 seconds.',
        illustrationAsset: 'assets/onboarding/results.png',
      ),
      _OnboardingData(
        tag: localization.farmManagement,
        title: localization.keepFlockHealthy,
        subtitle:
            'Track scan history, monitor farm health trends, and get actionable recommendations to protect your flock.',
        illustrationAsset: 'assets/onboarding/flock_health.png',
      ),
    ];
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: 12,
                ),
                child: GestureDetector(
                  onTap: _skip,
                  child: Text(
                    localization.skip,
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: pages.length,
                itemBuilder: (_, i) =>
                    _OnboardingPage(data: pages[i], isFirst: i == 0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                0,
                AppSpacing.screenPadding,
                AppSpacing.lg,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == i
                              ? AppColors.primary
                              : AppColors.primaryBorder,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusFull,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppPrimaryButton(
                    label: _currentPage == _pages.length - 1
                        ? localization.getStarted
                        : localization.next,
                    onTap: _next,
                    icon: _currentPage < _pages.length - 1
                        ? const Icon(Icons.arrow_forward_rounded, size: 18)
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;
  final bool isFirst;

  const _OnboardingPage({required this.data, required this.isFirst});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: isFirst
                  ? BorderRadius.circular(AppSpacing.radiusXl)
                  : BorderRadius.zero,
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F1D5),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox.expand(
                          child: Image.asset(
                            data.illustrationAsset,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusFull,
                          ),
                        ),
                        child: Text(
                          data.tag,
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    data.title,
                    style: AppTypography.displayMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data.subtitle,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingData {
  final String tag;
  final String title;
  final String subtitle;
  final String illustrationAsset;

  const _OnboardingData({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.illustrationAsset,
  });
}
