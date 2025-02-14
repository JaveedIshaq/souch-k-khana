import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mobile/constants/constants.dart';

class GeminiService {
  final model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: apiKey,
  );

  Future<String> identifyFood(File imageFile) async {
    try {
      final image = await imageFile.readAsBytes();

      const prompt =
          "Analyze this image and identify the food, Estimate its calories, protein, carbs, and fat";

      final response = await model.generateContent(
          [Content.text(prompt), Content.data('image/jpeg', image)]);

      print("The Response is: ${response.text}");

      return response.text ?? "";
    } on Exception catch (e) {
      print("Error fetching results: $e");

      return "";
    }
  }
}
