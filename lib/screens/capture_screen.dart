import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../constants/app_colors.dart';
import '../widgets/common_widgets.dart';
import '../services/ml_service.dart';
import '../l10n/app_localizations.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({Key? key}) : super(key: key);

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  final MLService mlService = MLService();
  final ImagePicker _picker = ImagePicker();

  String? selectedImagePath;
  Uint8List? selectedImageBytes;
  String prediction = 'Ready to classify';
  String confidence = '';
  bool isProcessing = false;
  bool isModelLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      await mlService.loadModel();
      setState(() {
        isModelLoaded = true;
        prediction = 'Model Ready - Take a photo';
      });
    } catch (e) {
      setState(() {
        prediction = 'Error loading model: $e';
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Model loading failed: $e')));
      }
    }
  }

  Future<void> _classifyImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return;
    await _processImage(image);
  }

  Future<void> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    await _processImage(image);
  }

  Future<void> _processImage(XFile image) async {
    final bytes = await image.readAsBytes();

    setState(() {
      isProcessing = true;
      selectedImagePath = image.path;
      selectedImageBytes = bytes;
      prediction = 'Processing image...';
      confidence = '';
    });

    try {
      print('🔵 Starting classification...');
      print('Image size: ${bytes.length} bytes');
      print('Model loaded: $isModelLoaded');

      final result = await mlService.classifyImageBytes(bytes);

      print('✅ Classification complete: ${result['class']}');

      setState(() {
        prediction = result['class'] ?? 'Unknown';
        confidence = result['accuracy'] ?? 'N/A';
        isProcessing = false;
      });
    } catch (e) {
      print('❌ Classification error: $e');
      setState(() {
        prediction = 'Error: ${e.toString()}';
        confidence = '';
        isProcessing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Classification failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.diseaseDetection),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                          child: selectedImageBytes == null
                              ? const Icon(
                                  Icons.image,
                                  size: 100,
                                  color: AppColors.gray,
                                )
                              : Image.memory(
                                  selectedImageBytes!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        // Corner Markers
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
                                  'Align chicken sample inside frame',
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
                  // Camera & Gallery Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Camera Button
                      GestureDetector(
                        onTap: isProcessing || !isModelLoaded
                            ? null
                            : _classifyImage,
                        child: Column(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (isProcessing || !isModelLoaded)
                                    ? AppColors.gray
                                    : AppColors.primary,
                                boxShadow: [
                                  BoxShadow(
                                    color: (isProcessing || !isModelLoaded)
                                        ? AppColors.gray.withOpacity(0.3)
                                        : AppColors.primary.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: isProcessing
                                  ? const SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              AppColors.white,
                                            ),
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.camera_alt,
                                      color: AppColors.white,
                                      size: 32,
                                    ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Camera',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 30),
                      // Gallery Button
                      GestureDetector(
                        onTap: isProcessing || !isModelLoaded
                            ? null
                            : _pickFromGallery,
                        child: Column(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (isProcessing || !isModelLoaded)
                                    ? AppColors.gray
                                    : AppColors.primary,
                                boxShadow: [
                                  BoxShadow(
                                    color: (isProcessing || !isModelLoaded)
                                        ? AppColors.gray.withOpacity(0.3)
                                        : AppColors.primary.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.photo_library,
                                color: AppColors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Gallery',
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
                  const SizedBox(height: 24),
                  // Prediction Results
                  if (selectedImagePath != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: Column(
                        children: [
                          Text(
                            localization.detectionResult,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            prediction,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (confidence.isNotEmpty)
                            Text(
                              '${localization.confidence}: $confidence',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.gray,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
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
                    description: 'Make sure the chicken sample is in focus',
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
                      label: 'Confirm & Save',
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
          // Loading Overlay
          if (isProcessing)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                      strokeWidth: 4,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Analyzing image...',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: AppColors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    mlService.dispose();
    super.dispose();
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
