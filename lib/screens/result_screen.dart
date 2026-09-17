import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/common_widgets.dart';
import '../l10n/app_localizations.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.analysisResult),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushNamed('/home'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Disease Alert
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.danger.withOpacity(0.1),
                  border: Border.all(
                    color: AppColors.danger.withOpacity(0.3),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.danger,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localization.disease,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.danger,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Newcastle Disease',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(color: AppColors.charcoal),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Confidence Score
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localization.confidence,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: 0.91,
                              minHeight: 10,
                              backgroundColor: AppColors.gray.withOpacity(0.2),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.danger,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          '91%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.danger,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Disease Information
              Text(
                'About Newcastle Disease',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
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
                    const Text(
                      'Newcastle disease is a highly contagious viral disease that can spread quickly among chickens. The virus can affect the respiratory, nervous, and digestive systems.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.charcoal,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      localization.commonSymptoms,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    _SymptomItem(text: 'Isolate the affected chicken'),
                    _SymptomItem(text: 'Improve hygiene and clean coop'),
                    _SymptomItem(
                      text: 'Contact a veterinarian if symptoms persist',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Recommended Actions
              Text(
                'Recommended Actions',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              ActionCard(
                icon: '🏥',
                title: 'Isolate the affected chicken',
                description:
                    'Separate the bird from other chickens immediately',
                onTap: () {},
              ),
              ActionCard(
                icon: '🧹',
                title: 'Improve hygiene and clean coop',
                description: 'Disinfect the living area thoroughly',
                onTap: () {},
              ),
              ActionCard(
                icon: '👨‍⚕️',
                title: 'Contact a veterinarian if symptoms persist',
                description: 'Get professional medical advice for treatment',
                onTap: () {},
              ),
              const SizedBox(height: 24),

              // Action Buttons
              PrimaryButton(
                label: localization.saveToHistory,
                onPressed: () {
                  showCustomSnackBar(context, 'Result saved successfully!');
                },
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                label: localization.share,
                onPressed: () {
                  showCustomSnackBar(context, localization.shareComingSoon);
                },
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                label: localization.backToHome,
                onPressed: () {
                  Navigator.of(context).pushNamed('/home');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SymptomItem extends StatelessWidget {
  final String text;

  const _SymptomItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Text(
            '✓',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: AppColors.charcoal),
            ),
          ),
        ],
      ),
    );
  }
}
