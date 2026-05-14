import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';

class MLService {
  late Interpreter interpreter;
  late List<String> labels;
  final int inputSize = 224;

  // Load model and labels
  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset('assets/models/model.tflite');

      // Load labels from asset
      final labelData = await rootBundle.loadString('assets/models/labels.txt');
      labels = labelData
          .split('\n')
          .where((label) => label.trim().isNotEmpty)
          .toList();

      print('✓ ML Model loaded: ${labels.length} classes');
      print('  Classes: $labels');
    } catch (e) {
      print('✗ Error loading model: $e');
      rethrow;
    }
  }

  // Classify image from bytes
  Future<Map<String, dynamic>> classifyImageBytes(Uint8List imageBytes) async {
    try {
      // Decode image
      final image = img.decodeImage(imageBytes);
      if (image == null) throw Exception('Could not decode image');

      // Resize to 224x224
      final resized = img.copyResize(
        image,
        width: inputSize,
        height: inputSize,
      );

      // Convert to input tensor (normalized float32)
      final input = _imageToByteList(resized);

      // Run inference
      final outputShape = interpreter.getOutputTensor(0).shape;
      final output = List<List<double>>.generate(
        outputShape[0],
        (_) => List<double>.filled(labels.length, 0.0),
      );
      interpreter.run(input, output);

      // Get predictions
      final predictions = output[0];

      // Find max prediction
      double maxConfidence = predictions[0];
      int maxIdx = 0;
      for (int i = 1; i < predictions.length; i++) {
        if (predictions[i] > maxConfidence) {
          maxConfidence = predictions[i];
          maxIdx = i;
        }
      }

      // Build all predictions map
      final allPredictions = <String, double>{};
      for (int i = 0; i < labels.length; i++) {
        allPredictions[labels[i]] = predictions[i];
      }

      return {
        'class': labels[maxIdx],
        'confidence': maxConfidence,
        'accuracy': '${(maxConfidence * 100).toStringAsFixed(2)}%',
        'allPredictions': allPredictions,
      };
    } catch (e) {
      print('✗ Classification error: $e');
      rethrow;
    }
  }

  // Convert image to normalized tensor
  List<List<List<List<double>>>> _imageToByteList(img.Image image) {
    var convertedBytes = List<List<List<List<double>>>>.generate(
      1,
      (i) => List<List<List<double>>>.generate(
        inputSize,
        (j) => List<List<double>>.generate(
          inputSize,
          (k) => List<double>.filled(3, 0.0),
        ),
      ),
    );

    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        var pixel = image.getPixelSafe(x, y);
        // Normalize to 0-1 range
        convertedBytes[0][y][x][0] = pixel.r.toDouble() / 255.0;
        convertedBytes[0][y][x][1] = pixel.g.toDouble() / 255.0;
        convertedBytes[0][y][x][2] = pixel.b.toDouble() / 255.0;
      }
    }
    return convertedBytes;
  }

  void dispose() {
    try {
      interpreter.close();
    } catch (e) {
      print('Error closing interpreter: $e');
    }
  }
}
