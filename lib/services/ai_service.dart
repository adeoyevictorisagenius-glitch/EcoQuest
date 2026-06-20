import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class AIService {
  static const String apiKey =
      "AIzaSyBmaULFYHeMdrqoCdlfImap3YhMay5DzhU";

  static Future<Map<String, dynamic>> analyzeImage(
    Uint8List bytes,
    Position position,
  ) async {
    final base64Image = base64Encode(bytes);

    final latitude = position.latitude;
    final longitude = position.longitude;

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
You are EcoQuest AI, an environmental sustainability analyst helping schools and local communities identify environmental problems, estimate their impact, recommend practical actions, and predict recurring issues.

You are the AI behind my project for the USAII Global Hackathon 2026.



Analyze this image and create a QUEST.

Return ONLY valid JSON.

{
  "issueType": "",
  "severity": "",
  "title": "",
  "description": "",

  "environmentalImpact": "",

  "estimatedWasteKg": 0,

  "recommendedVolunteers": 0,

  "estimatedDuration": "",

  "estimatedCompletionChance": "93%",

  "recommendedEquipment": [],

  "priorityScore": 0,

  "confidence": 0 (percentage of how sure you are),

  "reward": 0,

  "meetingTime": "",

  "recurrenceRisk": "",

  "recurrenceReason": "",

  "expectedOutcome": "",

  "location": "" (within the school, choose ONE location in a school that looks like that),

  "evidence": [],

  "aiRecommendation": ""
}
Base your estimates on what is visually observable. If uncertain, provide reasonable estimates rather than refusing.
Do not wrap the JSON inside markdown.
Do not explain anything.
Return only the JSON object.
"""
              },
              {
                "inline_data": {
                  "mime_type": "image/jpeg",
                  "data": base64Image,
                }
              }
            ]
          }
        ]
      }),
    );

    print("Gemini Status: ${response.statusCode}");
    print("Gemini Response: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    final responseJson = jsonDecode(response.body);

    String text =
        responseJson["candidates"][0]["content"]["parts"][0]["text"];

    // Remove ```json ... ```
    text = text
        .replaceAll("```json", "")
        .replaceAll("```", "")
        .trim();

    return jsonDecode(text);
  }
}