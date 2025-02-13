import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mobile/constants/api_constants.dart';
import 'dart:io';

import 'package:mobile/extensions/log_extension.dart';

class GeminiService {
  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: geminiApiKey,
  );

  Future<String> identifyFood(File imageFile) async {
    try {
      const prompt =
          "Analyze this image and identify the food, Estimate its calories, protein, carbs, and fat";

      final image = await imageFile.readAsBytes();

      final response = await model.generateContent([
        Content.text(prompt),
        Content.data('image/jpeg', image),
      ]);

      "Response: ${response.text}".log();

      return response.text ?? '';
    } on Exception catch (e) {
      "Error: $e".log();
      return '';
    }
  }
}
