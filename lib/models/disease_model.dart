class DiseaseDetectionResult {
  final String diseaseName;
  final int confidence;
  final DateTime detectionDate;
  final String imagePath;
  final String description;
  final List<String> recommendedActions;

  DiseaseDetectionResult({
    required this.diseaseName,
    required this.confidence,
    required this.detectionDate,
    required this.imagePath,
    required this.description,
    required this.recommendedActions,
  });
}

class ScanHistory {
  final String id;
  final String diseaseName;
  final int confidence;
  final DateTime scanDate;
  final String imagePath;
  final String status; // 'healthy', 'warning', 'disease'

  ScanHistory({
    required this.id,
    required this.diseaseName,
    required this.confidence,
    required this.scanDate,
    required this.imagePath,
    required this.status,
  });
}

class PhotoGuide {
  final String title;
  final String description;
  final String icon;

  PhotoGuide({
    required this.title,
    required this.description,
    required this.icon,
  });
}

enum HealthStatus { healthy, warning, disease, unknown }
