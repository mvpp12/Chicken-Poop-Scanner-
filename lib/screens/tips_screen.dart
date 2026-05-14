import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({Key? key}) : super(key: key);

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  final List<Map<String, String>> tips = [
    {
      'title': 'How to take clear photos',
      'description':
          'Learn the best way to capture sharp, clear images for accurate diagnosis. Use natural light and avoid shadows.',
      'icon': '📸',
    },
    {
      'title': 'Lighting Guide',
      'description':
          'Natural light works best. Avoid direct sunlight that creates harsh shadows. Overcast days are ideal.',
      'icon': '💡',
    },
    {
      'title': 'Camera Mistakes',
      'description':
          'Blurry images reduce diagnosis accuracy. Keep your hand steady and ensure the sample is in focus.',
      'icon': '🚫',
    },
    {
      'title': 'What to photograph',
      'description':
          'Always photograph chicken poop samples. Get close-up shots showing texture and color clearly.',
      'icon': '🐔',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo Tips & Guide')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          final tip = tips[index];
          return _TipCard(
            icon: tip['icon'] ?? '📋',
            title: tip['title'] ?? '',
            description: tip['description'] ?? '',
          );
        },
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;

  const _TipCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.charcoal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.gray,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
