import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuestCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const QuestCard({super.key, required this.data});

  Future<void> joinQuest(BuildContext context) async {
    final uid = 'victor';

    final participants = (data['participants'] ?? []) as List;

    if (participants.contains(uid)) return;

    await FirebaseFirestore.instance
        .collection('quests')
        .doc(data['questId'])
        .update({
      'participants': FieldValue.arrayUnion([uid]),
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({
      'soloPoints': FieldValue.increment(10),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("You joined the mission!")),
    );
  }

  Color getColor(String severity) {
    switch (severity) {
      case "High":
        return Colors.red;
      case "Medium":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final participants = (data['participants'] ?? []) as List;

    return Card(
      color: const Color(0xFF1A1A1A),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['title'] ?? 'Untitled Quest',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              data['description'] ?? '',
              style: const TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: getColor(data['severity'] ?? 'Low'),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    data['severity'] ?? 'Low',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(width: 10),

                Text(
                  "${participants.length} joined",
                  style: const TextStyle(color: Colors.white70),
                ),

                const Spacer(),

                Text(
                  " ${data['reward'] ?? 10}",
                  style: const TextStyle(color: Colors.greenAccent),
                ),
              ],
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
                ),
                onPressed: () => joinQuest(context),
                child: const Text("ACCEPT QUEST"),
              ),
            )
          ],
        ),
      ),
    );
  }
}