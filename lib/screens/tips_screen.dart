import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../l10n/app_localizations.dart';
import 'tip_detail_screen.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({Key? key}) : super(key: key);

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final tips = [
      TipData(
        title: localization.tipClearPhotosTitle,
        description: localization.tipClearPhotosDescription,
        assetPath: 'assets/tips/clear_photos.png',
      ),
      TipData(
        title: localization.tipLightingTitle,
        description: localization.tipLightingDescription,
        assetPath: 'assets/tips/lighting.png',
      ),
      TipData(
        title: localization.tipCameraMistakesTitle,
        description: localization.tipCameraMistakesDescription,
        assetPath: 'assets/tips/camera_mistakes.png',
      ),
      TipData(
        title: localization.tipWhatToPhotographTitle,
        description: localization.tipWhatToPhotographDescription,
        assetPath: 'assets/tips/what_to_photograph.png',
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(localization.photoTipsGuide)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          final tip = tips[index];
          return _TipCard(
            tip: tip,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => TipDetailScreen(tip: tip)),
              );
            },
          );
        },
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final TipData tip;
  final VoidCallback onTap;

  const _TipCard({required this.tip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.gray.withOpacity(0.2), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: Image.asset(tip.assetPath, fit: BoxFit.contain),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tip.title,
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
                tip.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.gray,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
