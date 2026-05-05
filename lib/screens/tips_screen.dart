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

  final List<Map<String, String>> diseases = [
    {
      'name': 'Newcastle Disease',
      'symptoms': 'Nerve disorders, twisted head, loss of appetite',
      'icon': '⚠️',
    },
    {
      'name': 'Coccidiosis',
      'symptoms': 'Bloody diarrhea, weight loss, pale appearance',
      'icon': '⚠️',
    },
    {
      'name': 'Marek\'s Disease',
      'symptoms': 'Paralysis, tumors, eye color changes',
      'icon': '⚠️',
    },
    {
      'name': 'Avian Influenza',
      'symptoms': 'Sudden death, soft-shelled eggs, facial swelling',
      'icon': '⚠️',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tips & Help'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Photo Guide'),
              Tab(text: 'Diseases'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Photo Guide Tab
            ListView.builder(
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

            // Diseases Tab
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: diseases.length,
              itemBuilder: (context, index) {
                final disease = diseases[index];
                return _DiseaseCard(
                  icon: disease['icon'] ?? '⚠️',
                  name: disease['name'] ?? '',
                  symptoms: disease['symptoms'] ?? '',
                );
              },
            ),
          ],
        ),
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

class _DiseaseCard extends StatefulWidget {
  final String icon;
  final String name;
  final String symptoms;

  const _DiseaseCard({
    required this.icon,
    required this.name,
    required this.symptoms,
  });

  @override
  State<_DiseaseCard> createState() => _DiseaseCardState();
}

class _DiseaseCardState extends State<_DiseaseCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => isExpanded = !isExpanded);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gray.withOpacity(0.2), width: 1),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(widget.icon, style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.charcoal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.gray,
                  ),
                ],
              ),
            ),
            if (isExpanded) ...[
              Container(
                color: AppColors.lightGray,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Common Symptoms:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.charcoal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.symptoms,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.gray,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.info,
                              color: AppColors.warning,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Contact a veterinarian for treatment recommendations',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.charcoal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
