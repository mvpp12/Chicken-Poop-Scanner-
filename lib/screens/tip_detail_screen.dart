import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../l10n/app_localizations.dart';

class TipData {
  final String title;
  final String description;
  final String assetPath;

  const TipData({
    required this.title,
    required this.description,
    required this.assetPath,
  });
}

class TipDetailScreen extends StatelessWidget {
  final TipData tip;

  const TipDetailScreen({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(tip.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 260),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Image.asset(tip.assetPath, fit: BoxFit.contain),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(tip.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(
              tip.description,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.gray,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              localization.tipExamples,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                localization.tipExamplesPlaceholder,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.gray),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
