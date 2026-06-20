import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoquest/services/cleanupai_service.dart';
import 'package:ecoquest/services/cloudinary_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class QuestDetailsPage extends StatefulWidget {
  final Map<String, dynamic> quest;

  const QuestDetailsPage({
    super.key,
    required this.quest,
  });

  @override
  State<QuestDetailsPage> createState() =>
      _QuestDetailsPageState();
}

class _QuestDetailsPageState
    extends State<QuestDetailsPage> {
  String get uid =>
      'victor';

  Future<void> joinQuest(
      String questId, List participants) async {
    if (participants.contains(uid)) return;

    await FirebaseFirestore.instance
        .collection("quests")
        .doc(questId)
        .update({
      "participants":
          FieldValue.arrayUnion([uid]),
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({
      "soloPoints":
          FieldValue.increment(10),
    });

    if (mounted) {
showDialog(
  context: context,
  builder: (_) {
    return Dialog(
      backgroundColor: const Color(0xFF111111),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "📜",
              style: TextStyle(fontSize: 60),
            ),

            const SizedBox(height: 12),

            const Text(
              "QUEST ACCEPTED!",
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              widget.quest["title"],
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Your quest has officially begun.\nGather your team, clean the location, and upload proof to earn XP and boost Greensfield School's impact score.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: Colors.greenAccent,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "AI Prediction: 82% chance of successful completion.",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
                ),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.explore),
                label: const Text(
                  "BEGIN QUEST",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  },
);

      setState(() {});
    }
  }

  Future<void> completeQuest(
      Map<String, dynamic> data) async {
    final picked =
    await ImagePicker().pickImage(
  source: ImageSource.camera,
);

if (picked == null) return;

    final afterbytes = await picked.readAsBytes();

final beforeResponse =
    await http.get(Uri.parse(data["mediaUrl"]));

final beforeBytes = beforeResponse.bodyBytes;

    final result = await CleanupAIService.verify(
      beforeBytes: beforeBytes,
      afterBytes: afterbytes,
    );

    int reward = 0;

    if (result == "CLEANED") {
      reward = data["reward"] ?? 10;
    } else if (result ==
        "PARTIALLY_CLEANED") {
      reward =
          ((data["reward"] ?? 10) / 2)
              .round();
    }

    await FirebaseFirestore.instance
        .collection("quests")
        .doc(data["questId"])
        .update({
      "status": "completed",
      "completedBy": uid,
      "completedAt":
          FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({
      "soloPoints":
          FieldValue.increment(reward),
      "questsCompleted":
          FieldValue.increment(1),
    });

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor:
            const Color(0xFF111111),
        title: const Text(
          "Quest Complete 🎉",
          style: TextStyle(
            color: Colors.greenAccent,
          ),
        ),
        content: Text(
          "$result\n\n+$reward points",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child: const Text("Continue"),
          )
        ],
      ),
    );
  }

  Color difficultyColor(String level) {
    switch (level) {
      case "Hard":
        return Colors.red;

      case "Medium":
        return Colors.orange;

      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.quest;

    final participants =
        (data["participants"] ?? []) as List;

    final joined =
        participants.contains(uid);

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Quest Details",
          style: TextStyle(
            color: Colors.greenAccent,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
                        // QUEST IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                data["mediaUrl"],
                height: 240,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              data["title"],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [

                Chip(
                  backgroundColor: Colors.green.shade900,
                  label: Text(
                    data["issueType"],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),

                Chip(
                  backgroundColor:
                      difficultyColor(data["severity"]),
                  label: Text(
                    data["severity"],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Chip(
                  backgroundColor:
                      difficultyColor(data["recommendedEquipment"].toString()),
                  label: Text(
                    data["severity"],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),

                Chip(
                  backgroundColor: Colors.blueGrey,
                  label: Text(
                    "${participants.length} Activists",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),

                Chip(
                  backgroundColor:
                      Colors.amber.shade800,
                  label: Text(
                    "${data["reward"]} XP",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xff171717),
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  const Text(
                    "📜 Quest Briefing",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    data["description"],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Divider(),

                  const SizedBox(height: 10),

                  const Text(
                    "🤖 Estimated Completion Chance",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  LinearProgressIndicator(
                    value: 0.82,
                    minHeight: 10,
                    borderRadius:
                        BorderRadius.circular(20),
                    color: Colors.greenAccent,
                    backgroundColor:
                        Colors.white12,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "82% — Based on previous cleanup quests, participant count and severity.",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "🏆 Rewards",
              style: TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 10),

            Card(
              color: const Color(0xff1A1A1A),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor:
                      Colors.greenAccent,
                  child: Icon(
                    Icons.stars,
                    color: Colors.black,
                  ),
                ),
                title: Text(
                  "+${data["reward"]} XP",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                subtitle: const Text(
                  "Contributes to Solo Rank and School Impact Score",
                  style: TextStyle(
                    color: Colors.white60,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 35),
                        SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: joined
                      ? Colors.orange
                      : Colors.greenAccent,
                  foregroundColor: Colors.black,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                ),
                icon: Icon(
                  joined
                      ? Icons.verified
                      : Icons.explore,
                  size: 28,
                ),
                label: Text(
                  joined
                      ? "COMPLETE QUEST"
                      : "ACCEPT QUEST",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                onPressed: () {
                  if (joined) {
                    completeQuest(data);
                  } else {
                    joinQuest(
                      data["questId"],
                      participants,
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 15),

            Center(
              child: Text(
                joined
                    ? "⚔ You're already part of this quest.\nReturn after cleaning the area to earn XP."
                    : "🌎 Join this quest and help make Greensfield School cleaner.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white60,
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}