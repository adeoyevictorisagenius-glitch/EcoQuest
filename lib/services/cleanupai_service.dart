import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class CleanupAIService {
  static const String apiKey =
      "API_KEY";

  static Future<String> verify({
    required Uint8List beforeBytes,
    required Uint8List afterBytes,
  }) async {
    try {
      final beforeBase64 = base64Encode(beforeBytes);
      final afterBase64 = base64Encode(afterBytes);

      final response = await http.post(
        Uri.parse(
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey",
        ),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": """
Compare these two images.

Image 1 = BEFORE cleanup.
Image 2 = AFTER cleanup.

Determine whether the environmental issue was resolved.

You are EcoQuest AI, the AI behind my project EcoQuest for the USAII AI Hackathon 2026.

Return ONLY ONE of:

CLEANED
PARTIALLY_CLEANED
NOT_CLEANED

Do not explain your answer.
Do not use markdown.
Return only one word.
"""
                },
                {
                  "inline_data": {
                    "mime_type": "image/jpeg",
                    "data": beforeBase64,
                  }
                },
                {
                  "inline_data": {
                    "mime_type": "image/jpeg",
                    "data": afterBase64,
                  }
                }
              ]
            }
          ]
        }),
      );

      print("Cleanup AI Status: ${response.statusCode}");
      print("Cleanup AI Response: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception(response.body);
      }

      final responseJson = jsonDecode(response.body);

      String text = responseJson["candidates"][0]["content"]["parts"][0]["text"]
          .toString()
          .toUpperCase()
          .trim();

      text = text
          .replaceAll("```", "")
          .replaceAll("JSON", "")
          .trim();

      if (text == "CLEANED") {
        return "CLEANED";
      }

      if (text == "PARTIALLY_CLEANED") {
        return "PARTIALLY_CLEANED";
      }

      return "NOT_CLEANED";
    } catch (e) {
      print("Cleanup AI Error: $e");
      return "NOT_CLEANED";
    }
  }
}
