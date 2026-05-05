import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/common_widgets.dart';

class ConfirmPhotoScreen extends StatefulWidget {
  const ConfirmPhotoScreen({Key? key}) : super(key: key);

  @override
  State<ConfirmPhotoScreen> createState() => _ConfirmPhotoScreenState();
}

class _ConfirmPhotoScreenState extends State<ConfirmPhotoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Photo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Preview
              Container(
                height: 350,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.image, size: 80, color: AppColors.gray),
                    const SizedBox(height: 16),
                    Text(
                      'Chicken Poop Sample',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Photo Quality Indicators
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Photo Quality Check',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    _QualityCheckItem(
                      icon: Icons.check_circle,
                      title: 'Lighting',
                      status: 'Good',
                    ),
                    const SizedBox(height: 8),
                    _QualityCheckItem(
                      icon: Icons.check_circle,
                      title: 'Focus',
                      status: 'Clear',
                    ),
                    const SizedBox(height: 8),
                    _QualityCheckItem(
                      icon: Icons.check_circle,
                      title: 'Frame',
                      status: 'Proper',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Action Buttons
              PrimaryButton(
                label: 'Use Photo',
                onPressed: () {
                  Navigator.of(context).pushNamed('/processing');
                },
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                label: 'Retake Photo',
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                label: 'Upload Different',
                onPressed: () {
                  Navigator.of(context).pushNamed('/capture');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QualityCheckItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String status;

  const _QualityCheckItem({
    required this.icon,
    required this.title,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.charcoal,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            status,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
