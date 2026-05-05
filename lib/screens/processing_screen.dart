import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({Key? key}) : super(key: key);

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    // Simulate processing
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/result');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Chicken Icon
            ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.elasticIn,
                ),
              ),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondary,
                  border: Border.all(color: AppColors.primary, width: 3),
                ),
                child: const Center(
                  child: Text('🐔', style: TextStyle(fontSize: 50)),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Loading Spinner
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 4,
              ),
            ),
            const SizedBox(height: 32),

            // Status Text
            Text(
              'Analyzing...',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: AppColors.charcoal),
            ),
            const SizedBox(height: 12),
            Text(
              'This may take 3-5 seconds',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            // Progress Indicators
            const SizedBox(height: 48),
            _ProgressStep(
              icon: Icons.check_circle,
              title: 'Photo Received',
              isCompleted: true,
            ),
            const SizedBox(height: 16),
            _ProgressStep(
              icon: Icons.hourglass_bottom,
              title: 'Processing Image',
              isCompleted: false,
            ),
            const SizedBox(height: 16),
            _ProgressStep(
              icon: Icons.analytics,
              title: 'Running Analysis',
              isCompleted: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isCompleted;

  const _ProgressStep({
    required this.icon,
    required this.title,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? AppColors.primary : AppColors.lightGray,
          ),
          child: Icon(
            icon,
            color: isCompleted ? AppColors.white : AppColors.gray,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isCompleted ? AppColors.primary : AppColors.gray,
          ),
        ),
      ],
    );
  }
}
