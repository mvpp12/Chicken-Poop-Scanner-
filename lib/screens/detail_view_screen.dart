import 'dart:io';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/common_widgets.dart';

class DetailViewScreen extends StatefulWidget {
  final Map<String, dynamic>? item;
  final int? index;

  const DetailViewScreen({Key? key, this.item, this.index}) : super(key: key);

  @override
  State<DetailViewScreen> createState() => _DetailViewScreenState();
}

class _DetailViewScreenState extends State<DetailViewScreen> {
  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Details'),
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
              // Photo
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.gray.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child:
                    (item?['imagePath'] != null &&
                        (item?['imagePath'] as String).isNotEmpty)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(item?['imagePath']),
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.image, size: 80, color: AppColors.gray),
              ),
              const SizedBox(height: 24),

              // Result Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.gray.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Diagnosis',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item?['disease'] ?? 'Unknown',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                        StatusTag(
                          label: (item?['status'] ?? 'unknown').toUpperCase(),
                          status: item?['status'] ?? 'unknown',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _DetailItem(
                            label: 'Confidence',
                            value: item?['confidence'] ?? 'N/A',
                          ),
                        ),
                        Expanded(
                          child: _DetailItem(
                            label: 'Date',
                            value: item?['date'] ?? 'N/A',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Analysis Breakdown
              Text(
                'Analysis Breakdown',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              ResultCard(
                title: 'Primary Finding',
                value: item?['disease'] ?? 'Unknown',
                status: item?['status'] ?? 'unknown',
              ),
              ResultCard(
                title: 'Confidence Level',
                value: item?['confidence'] ?? 'N/A',
                status: item?['status'] ?? 'unknown',
              ),
              const SizedBox(height: 24),

              // Actions
              ActionCard(
                icon: '📋',
                title: 'View Full Report',
                description: 'See detailed analysis and metrics',
                onTap: () {},
              ),
              ActionCard(
                icon: '🔄',
                title: 'Re-analyze',
                description: 'Run analysis again with same photo',
                onTap: () {},
              ),
              ActionCard(
                icon: '📤',
                title: 'Export Results',
                description: 'Download as PDF or image',
                onTap: () {},
              ),
              const SizedBox(height: 24),

              // Buttons
              PrimaryButton(
                label: 'Share',
                onPressed: () {
                  showCustomSnackBar(context, 'Share feature coming soon!');
                },
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                label: 'Back to History',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _DetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.gray,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.charcoal,
          ),
        ),
      ],
    );
  }
}
