import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../l10n/app_localizations.dart';

class DiseasesGuideScreen extends StatefulWidget {
  const DiseasesGuideScreen({Key? key}) : super(key: key);

  @override
  State<DiseasesGuideScreen> createState() => _DiseasesGuideScreenState();
}

class _DiseasesGuideScreenState extends State<DiseasesGuideScreen> {
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
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.diseaseGuide),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
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
    final localization = AppLocalizations.of(context)!;
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
                      Text(
                        localization.commonSymptoms,
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
                        child: Row(
                          children: [
                            Icon(
                              Icons.info,
                              color: AppColors.warning,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                localization.contactVeterinarian,
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
