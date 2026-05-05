import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/common_widgets.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({Key? key}) : super(key: key);

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  String? selectedImagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture Photo'),
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
              // Camera Preview Area with Frame
              Container(
                height: 350,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    // Background/Preview
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.brown[300]?.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: selectedImagePath == null
                          ? const Icon(
                              Icons.image,
                              size: 100,
                              color: AppColors.gray,
                            )
                          : const SizedBox(),
                    ),
                    // Corner Markers for Frame
                    Positioned(top: 20, left: 20, child: _CornerMarker()),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: _CornerMarker(isRight: true),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: _CornerMarker(isBottom: true),
                    ),
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: _CornerMarker(isRight: true, isBottom: true),
                    ),
                    // Center Text
                    if (selectedImagePath == null)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Align sample inside frame',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(color: AppColors.charcoal),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Pinch to zoom',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Camera Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Simulate photo capture
                      setState(() {
                        selectedImagePath = 'assets/sample_chicken.jpg';
                      });
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera,
                        color: AppColors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Tips Section
              Text(
                'Photo Guidelines',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              _GuidelineItem(
                number: 1,
                title: 'Good Lighting',
                description:
                    'Ensure natural light without shadows on the sample',
              ),
              _GuidelineItem(
                number: 2,
                title: 'Clear Focus',
                description: 'Make sure the chicken poop sample is in focus',
              ),
              _GuidelineItem(
                number: 3,
                title: 'Fit Frame',
                description: 'Keep the entire sample within the frame',
              ),
              _GuidelineItem(
                number: 4,
                title: 'Avoid Blur',
                description: 'Keep your hand steady while taking photo',
              ),
              const SizedBox(height: 24),

              // Action Buttons
              if (selectedImagePath != null) ...[
                PrimaryButton(
                  label: 'Confirm Photo',
                  onPressed: () {
                    Navigator.of(context).pushNamed('/confirm');
                  },
                ),
                const SizedBox(height: 12),
              ],
              SecondaryButton(
                label: 'Back',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CornerMarker extends StatelessWidget {
  final bool isRight;
  final bool isBottom;

  const _CornerMarker({this.isRight = false, this.isBottom = false});

  @override
  Widget build(BuildContext context) {
    const size = 20.0;
    const thickness = 3.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border(
          top: isBottom
              ? BorderSide.none
              : const BorderSide(color: AppColors.primary, width: thickness),
          left: isRight
              ? BorderSide.none
              : const BorderSide(color: AppColors.primary, width: thickness),
          right: isRight
              ? const BorderSide(color: AppColors.primary, width: thickness)
              : BorderSide.none,
          bottom: isBottom
              ? const BorderSide(color: AppColors.primary, width: thickness)
              : BorderSide.none,
        ),
      ),
    );
  }
}

class _GuidelineItem extends StatelessWidget {
  final int number;
  final String title;
  final String description;

  const _GuidelineItem({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: AppColors.gray),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
