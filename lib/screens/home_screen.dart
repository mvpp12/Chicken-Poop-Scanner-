import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import '../services/ml_service.dart';
import '../services/history_store.dart';
import '../widgets/app_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final MLService _mlService = MLService();
  final ImagePicker _picker = ImagePicker();

  CameraController? _cameraController;
  bool _cameraReady = false;
  bool _flashOn = false;
  bool _isModelLoaded = false;
  bool _isProcessing = false;
  String? _cameraError;
  String? _modelError;

  File? _capturedImage;
  String? _lastPrediction;
  String? _lastConfidence;

  late final AnimationController _cornerPulse;
  late final AnimationController _scanLineCtrl;
  late final Animation<double> _cornerAnim;
  late final Animation<double> _scanLineAnim;

  @override
  void initState() {
    super.initState();
    _cornerPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _scanLineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _cornerAnim = Tween<double>(
      begin: 0.55,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _cornerPulse, curve: Curves.easeInOut));

    _scanLineAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _scanLineCtrl, curve: Curves.easeInOut));

    _initCamera();
    _loadModel();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() => _cameraReady = true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _cameraError = e.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Camera error: $e')));
    }
  }

  Future<void> _loadModel() async {
    try {
      await _mlService.loadModel();
      if (!mounted) return;
      setState(() => _isModelLoaded = true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _modelError = e.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Model load failed: $e')));
    }
  }

  Future<void> _retryCamera() async {
    setState(() {
      _cameraError = null;
      _cameraReady = false;
    });
    await _initCamera();
  }

  Future<void> _retryModel() async {
    setState(() {
      _modelError = null;
      _isModelLoaded = false;
    });
    await _loadModel();
  }

  @override
  void dispose() {
    _cornerPulse.dispose();
    _scanLineCtrl.dispose();
    _cameraController?.dispose();
    _mlService.dispose();
    super.dispose();
  }

  Future<void> _pickFromGallery() async {
    final xFile = await _picker.pickImage(source: ImageSource.gallery);
    if (xFile == null || !mounted) return;
    setState(() => _capturedImage = File(xFile.path));
    await _runInference(await xFile.readAsBytes());
  }

  Future<void> _takeScan() async {
    if (_isProcessing || !_cameraReady || !_isModelLoaded) return;
    setState(() => _isProcessing = true);
    _scanLineCtrl.repeat();

    try {
      final file = await _cameraController!.takePicture();
      if (!mounted) return;
      setState(() => _capturedImage = File(file.path));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Scan captured. Analyzing...')),
      );
      await _runInference(await file.readAsBytes());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Capture failed: $e')));
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
        _scanLineCtrl.stop();
      }
    }
  }

  Future<void> _runInference(Uint8List bytes) async {
    if (!_isModelLoaded) return;
    try {
      final result = await _mlService.classifyImageBytes(bytes);
      if (!mounted) return;
      final entry = _buildScanEntry(
        prediction: result['class']?.toString(),
        confidence: result['accuracy']?.toString(),
      );
      setState(() {
        _lastPrediction = entry['disease']?.toString();
        _lastConfidence = entry['confidence']?.toString();
      });
      await _showResultSheet(entry);
      await _resetPreview();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Classification failed: $e')));
    }
  }

  Future<void> _resetPreview() async {
    if (!mounted) return;
    try {
      await _cameraController?.resumePreview();
    } catch (_) {
      // Ignore resume errors; preview will reattach on next frame.
    }
    if (!mounted) return;
    setState(() => _capturedImage = null);
  }

  Future<void> _toggleFlash() async {
    if (!_cameraReady || _cameraController == null) return;
    try {
      final next = _flashOn ? FlashMode.off : FlashMode.torch;
      await _cameraController!.setFlashMode(next);
      if (!mounted) return;
      setState(() => _flashOn = !_flashOn);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Flash error: $e')));
    }
  }

  Future<void> _showResultSheet(Map<String, dynamic> entry) async {
    if (_lastPrediction == null) return;
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ResultBottomSheet(
        prediction: _lastPrediction ?? 'Unknown',
        confidence: _lastConfidence ?? 'N/A',
        onSave: () {
          HistoryStore.instance.addScan(entry);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Saved to history')));
        },
        onViewDetails: () {
          HistoryStore.instance.addScan(entry);
          Navigator.of(context).pop();
          Navigator.of(
            context,
          ).pushNamed('/detail', arguments: {'item': entry});
        },
      ),
    );
  }

  Map<String, dynamic> _buildScanEntry({
    required String? prediction,
    required String? confidence,
  }) {
    final normalizedPrediction = (prediction == null || prediction.isEmpty)
        ? 'Unknown'
        : prediction;
    return {
      'id': DateTime.now().millisecondsSinceEpoch,
      'disease': normalizedPrediction,
      'confidence': _formatConfidence(confidence),
      'date': _formatDate(DateTime.now()),
      'imagePath': _capturedImage?.path ?? '',
      'status': _mapStatus(normalizedPrediction),
    };
  }

  String _formatConfidence(String? raw) {
    if (raw == null || raw.isEmpty || raw == 'N/A') return 'N/A';
    final parsed = double.tryParse(raw);
    if (parsed == null) return raw;
    final pct = parsed <= 1 ? (parsed * 100).round() : parsed.round();
    return '$pct%';
  }

  String _mapStatus(String prediction) {
    final lower = prediction.toLowerCase();
    if (lower.contains('healthy')) return 'healthy';
    if (lower.contains('warning') || lower.contains('suspect'))
      return 'warning';
    return 'disease';
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final suffix = dt.hour >= 12 ? 'PM' : 'AM';
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} - $hour:$minute $suffix';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _CameraPreview(
                  controller: _cameraController,
                  cameraReady: _cameraReady,
                  image: _capturedImage,
                ),
                _CameraStatusOverlay(
                  cameraReady: _cameraReady,
                  modelReady: _isModelLoaded,
                  cameraError: _cameraError,
                  modelError: _modelError,
                  onRetryCamera: _retryCamera,
                  onRetryModel: _retryModel,
                ),
                _ScanOverlay(
                  cornerAnim: _cornerAnim,
                  scanLineAnim: _isProcessing ? _scanLineAnim : null,
                ),
                _CameraAppBar(flashOn: _flashOn, onFlashToggle: _toggleFlash),
                const Positioned(
                  bottom: 24,
                  left: 0,
                  right: 0,
                  child: _AlignHint(),
                ),
              ],
            ),
          ),
          Container(
            color: AppColors.background,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              16,
              AppSpacing.screenPadding,
              8,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoChip(icon: Icons.wb_sunny_outlined, label: 'Good lighting'),
                InfoChip(icon: Icons.fullscreen_rounded, label: 'Fill frame'),
                InfoChip(
                  icon: Icons.motion_photos_off_outlined,
                  label: 'Avoid blur',
                ),
              ],
            ),
          ),
          Container(
            color: AppColors.background,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
              vertical: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ControlButton(
                  icon: Icons.image_outlined,
                  label: 'Upload',
                  onTap: _pickFromGallery,
                ),
                _ScanControl(
                  onTap: _takeScan,
                  disabled: !_cameraReady || !_isModelLoaded || _isProcessing,
                  loading: _isProcessing,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraPreview extends StatelessWidget {
  final CameraController? controller;
  final bool cameraReady;
  final File? image;

  const _CameraPreview({
    required this.controller,
    required this.cameraReady,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return Image.file(image!, fit: BoxFit.cover);
    }
    if (cameraReady && controller != null) {
      return CameraPreview(controller!);
    }
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6B5A3E), Color(0xFF8B7355), Color(0xFF7A6545)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: CustomPaint(painter: _SoilTexturePainter()),
    );
  }
}

class _SoilTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0x18000000);
    for (int i = 0; i < 350; i++) {
      final x = (i * 137.508) % size.width;
      final y = (i * 91.3) % size.height;
      canvas.drawCircle(Offset(x, y), 1.5 + (x % 2.5), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _CameraStatusOverlay extends StatelessWidget {
  final bool cameraReady;
  final bool modelReady;
  final String? cameraError;
  final String? modelError;
  final VoidCallback onRetryCamera;
  final VoidCallback onRetryModel;

  const _CameraStatusOverlay({
    required this.cameraReady,
    required this.modelReady,
    required this.cameraError,
    required this.modelError,
    required this.onRetryCamera,
    required this.onRetryModel,
  });

  @override
  Widget build(BuildContext context) {
    if (cameraReady && modelReady) return const SizedBox.shrink();

    final waiting =
        (cameraError == null && !cameraReady) ||
        (modelError == null && !modelReady);

    final title = waiting ? 'Preparing scanner...' : 'Scanner needs attention';

    final messages = <String>[];
    if (!cameraReady) {
      messages.add(
        cameraError == null ? 'Starting camera...' : 'Camera unavailable.',
      );
    }
    if (!modelReady) {
      messages.add(
        modelError == null ? 'Loading AI model...' : 'Model failed to load.',
      );
    }

    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.35),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ...messages.map(
                  (m) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      m,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                if (cameraError != null || modelError != null) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      if (cameraError != null)
                        _RetryButton(
                          label: 'Retry Camera',
                          onTap: onRetryCamera,
                        ),
                      if (modelError != null)
                        _RetryButton(label: 'Retry Model', onTap: onRetryModel),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RetryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _RetryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTypography.labelMedium.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class _ScanOverlay extends StatelessWidget {
  final Animation<double> cornerAnim;
  final Animation<double>? scanLineAnim;

  const _ScanOverlay({required this.cornerAnim, this.scanLineAnim});

  @override
  Widget build(BuildContext context) {
    final listenable = scanLineAnim == null
        ? cornerAnim
        : Listenable.merge([cornerAnim, scanLineAnim!]);
    return AnimatedBuilder(
      animation: listenable,
      builder: (_, __) => CustomPaint(
        painter: _ScanFramePainter(
          cornerOpacity: cornerAnim.value,
          scanLineProgress: scanLineAnim?.value,
        ),
      ),
    );
  }
}

class _ScanFramePainter extends CustomPainter {
  final double cornerOpacity;
  final double? scanLineProgress;

  const _ScanFramePainter({required this.cornerOpacity, this.scanLineProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final frameW = size.width * 0.72;
    final frameH = size.height * 0.52;
    final left = (size.width - frameW) / 2;
    final top = (size.height - frameH) / 2;
    final right = left + frameW;
    final bottom = top + frameH;

    final overlayPaint = Paint()..color = const Color(0x66000000);
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTRB(left, top, right, bottom),
            const Radius.circular(16),
          ),
        ),
      ),
      overlayPaint,
    );

    const cornerLen = 30.0;
    const strokeW = 3.0;
    final cornerPaint = Paint()
      ..color = Colors.white.withOpacity(cornerOpacity)
      ..strokeWidth = strokeW
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    void drawCorner(Offset a, Offset corner, Offset b) {
      canvas.drawPath(
        Path()
          ..moveTo(a.dx, a.dy)
          ..lineTo(corner.dx, corner.dy)
          ..lineTo(b.dx, b.dy),
        cornerPaint,
      );
    }

    drawCorner(
      Offset(left, top + cornerLen),
      Offset(left, top),
      Offset(left + cornerLen, top),
    );
    drawCorner(
      Offset(right - cornerLen, top),
      Offset(right, top),
      Offset(right, top + cornerLen),
    );
    drawCorner(
      Offset(left, bottom - cornerLen),
      Offset(left, bottom),
      Offset(left + cornerLen, bottom),
    );
    drawCorner(
      Offset(right - cornerLen, bottom),
      Offset(right, bottom),
      Offset(right, bottom - cornerLen),
    );

    if (scanLineProgress != null) {
      final scanY = top + (bottom - top) * scanLineProgress!;
      if (scanLineProgress! > 0.02 && scanLineProgress! < 0.98) {
        final linePaint = Paint()
          ..shader = LinearGradient(
            colors: [
              Colors.transparent,
              AppColors.scanLine.withOpacity(0.85),
              Colors.transparent,
            ],
          ).createShader(Rect.fromLTWH(left, scanY, frameW, 2))
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke;
        canvas.drawLine(Offset(left, scanY), Offset(right, scanY), linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(_ScanFramePainter old) =>
      old.cornerOpacity != cornerOpacity ||
      old.scanLineProgress != scanLineProgress;
}

class _CameraAppBar extends StatelessWidget {
  final bool flashOn;
  final VoidCallback onFlashToggle;

  const _CameraAppBar({required this.flashOn, required this.onFlashToggle});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 40, height: 40),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  'Chicken Health Scan',
                  style: AppTypography.labelLarge.copyWith(color: Colors.white),
                ),
              ),
              _CamIconButton(
                icon: flashOn
                    ? Icons.flash_on_rounded
                    : Icons.flash_off_rounded,
                onTap: onFlashToggle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CamIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CamIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _AlignHint extends StatelessWidget {
  const _AlignHint();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.85),
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Text(
          'Align sample inside the frame',
          style: AppTypography.labelMedium.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool disabled;
  final bool loading;

  const _ScanButton({
    required this.onTap,
    this.disabled = false,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          gradient: disabled ? null : AppColors.primaryGradient,
          color: disabled ? AppColors.primaryBorder : null,
          shape: BoxShape.circle,
          boxShadow: disabled
              ? []
              : [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: loading
            ? const Padding(
                padding: EdgeInsets.all(18),
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: 30,
              ),
      ),
    );
  }
}

class _ScanControl extends StatelessWidget {
  final VoidCallback onTap;
  final bool disabled;
  final bool loading;

  const _ScanControl({
    required this.onTap,
    required this.disabled,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ScanButton(onTap: onTap, disabled: disabled, loading: loading),
        const SizedBox(height: 6),
        Text(
          'Scan',
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _ResultBottomSheet extends StatelessWidget {
  final String prediction;
  final String confidence;
  final VoidCallback onSave;
  final VoidCallback onViewDetails;

  const _ResultBottomSheet({
    required this.prediction,
    required this.confidence,
    required this.onSave,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Detection Result',
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            prediction,
            style: AppTypography.displayMedium.copyWith(
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'Confidence: $confidence',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppPrimaryButton(label: 'Save to History', onTap: onSave),
          const SizedBox(height: 10),
          AppOutlinedButton(label: 'View Details', onTap: onViewDetails),
        ],
      ),
    );
  }
}
