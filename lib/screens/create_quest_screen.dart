import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoquest/services/ai_service.dart';
import 'package:ecoquest/services/cloudinary_service.dart';
import 'package:ecoquest/services/location_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class CreateQuestScreen extends StatefulWidget {
  const CreateQuestScreen({super.key});

  @override
  State<CreateQuestScreen> createState() => _CreateQuestScreenState();
}

class _CreateQuestScreenState extends State<CreateQuestScreen> {
  Uint8List? bytes;

  bool loading = false;
  bool aiDone = false;

  Map<String, dynamic>? aiData;

  String uid = 'victor';
  String imUrl='';
  Future<void> takePhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (picked == null) return;
    Uint8List pickedBytes= await picked.readAsBytes();
    setState(() {
      bytes = pickedBytes;
      aiDone = false;
      aiData = null;
    });

    await runAI();
  }

  Future<void> runAI() async {
    if (bytes == null) return;

    setState(() {
      loading = true;
    });

    final position = await LocationService.getCurrentLocation();

    try {
      final result = await AIService.analyzeImage(bytes!, position);

      setState(() {
        aiData = result;
        aiDone = true;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("AI failed: $e")),
        );
      }
    }
  }

  Future<void> createQuest() async {
    if (aiData == null || bytes == null) return;

    setState(() {
      loading = true;
    });

    final position = await LocationService.getCurrentLocation();

    final imageUrl = await CloudinaryService.uploadImage(bytes!);
    imUrl = imageUrl;
    final questId = const Uuid().v4();

    await FirebaseFirestore.instance.collection('quests').doc(questId).set({
      'questId': questId,

      // AI FIELDS
      'title': aiData!['title'],
      'description': aiData!['description'],
      'issueType': aiData!['issueType'],
      'severity': aiData!['severity'],
      'reward': aiData!['reward'],
      'meetingTime': aiData!['meetingTime'],
      'environmentalImpact': aiData!['environmentalImpact'],
      'estimatedWasteKg': aiData!['estimatedWasteKg'],
      'recommendedVolunteers': aiData!['recommendedVolunteers'],
      'recommendedEquipment': aiData!['recommendedEquipment'],
      'estimatedDuration': aiData!['estimatedDuration'],
      'priorityScore': aiData!['priorityScore'],
      'confidence': aiData!['confidence'],
      'recurrenceRisk': aiData!['recurrenceRisk'],
      'aiRecommendation': aiData!['aiRecommendation'],
      'estimatedCompletionChance': aiData!['estimatedCompletionChance'],
      // MEDIA
      'mediaUrl': imageUrl,

      // LOCATION
      'location': aiData!['location'],

      // SYSTEM
      'participants': [uid],
      'status': 'Active',
      'createdAt': DateTime.now(),
      'createdBy': uid,
    });

    setState(() {
      loading = false;
    });

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Create Quest",
          style: TextStyle(color: Colors.greenAccent),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // CAMERA CARD
            GestureDetector(
              onTap: takePhoto,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.greenAccent),
                ),
                child: bytes == null
                    ? const Center(
                        child: Text(
                          "📸 Tap to Capture Environmental Issue",
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.memory(
                        bytes!,
                        fit: BoxFit.contain,
                      ),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // LOADING STATE
            if (loading)
              Column(
                children: const [
                  CircularProgressIndicator(color: Colors.greenAccent),
                  SizedBox(height: 12),
                  Text(
                    "🤖 EcoQuest AI analyzing...\nDetecting issue, estimating impact, generating quest...",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),

            // AI REPORT
            if (aiDone && aiData != null)
              Expanded(
                child: ListView(
                  children: [
                    _aiCard(),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.all(14),
                      ),
                      onPressed: createQuest,
                      child: const Text("CREATE QUEST"),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _aiCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.greenAccent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "🤖 AI Environmental Report",
            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          Text("Issue: ${aiData!['issueType']}",
              style: const TextStyle(color: Colors.white)),
          Text("Confidence: ${aiData!['confidence']}%",
              style: const TextStyle(color: Colors.white70)),
          Text("Evidence: ${aiData!['evidence'].toString()}",
              style: const TextStyle(color: Colors.white70)),         

          Text("Severity: ${aiData!['severity']}",
              style: const TextStyle(color: Colors.white70)),
          Text("Impact: ${aiData!['environmentalImpact']}",
              style: const TextStyle(color: Colors.white70)),
          Text("Estimated Waste: ${aiData!['estimatedWasteKg']} kg",
              style: const TextStyle(color: Colors.white70)),
          Text("Minimum Volunteers recommended: ${aiData!['recommendedVolunteers']}",
              style: const TextStyle(color: Colors.white70)),
          Text("Equipments: ${aiData!['recommendedEquipment']}",
              style: const TextStyle(color: Colors.white70)),
          Text("Duration: ${aiData!['estimatedDuration']}",
              style: const TextStyle(color: Colors.white70)),
          Text("Location and Time: ${aiData!['location']} on ${aiData!['meetingTime']}",
              style: const TextStyle(color: Colors.white70)),      

          const SizedBox(height: 10), 

          Text(
            "💡 ${aiData!['aiRecommendation']}",
            style: const TextStyle(color: Colors.greenAccent),
          ),
        ],
      ),
    );
  }
}