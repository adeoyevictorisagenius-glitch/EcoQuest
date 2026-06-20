import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoquest/screens/create_quest_screen.dart';
import 'package:ecoquest/screens/quest_details_page.dart';
import 'package:ecoquest/services/cleanupai_service.dart';
import 'package:ecoquest/services/cloudinary_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class QuestPage extends StatefulWidget {
  const QuestPage({super.key});

  @override
  State<QuestPage> createState() => _QuestPageState();
}

class _QuestPageState extends State<QuestPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  String get uid => 'victor';

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  // =========================
  // JOIN QUEST
  // =========================
  Future<void> joinQuest(String questId, List participants, String title) async {
    if (participants.contains(uid)) return;

    await FirebaseFirestore.instance.collection('quests').doc(questId).update({
      'participants': FieldValue.arrayUnion([uid]),
    });

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'soloPoints': FieldValue.increment(10),
    });

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
              title,
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
  }

  // =========================
  // COMPLETE QUEST
  // =========================
  Future<void> completeQuest(Map<String, dynamic> data) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
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
      reward = data['reward'] ?? 10;
    } else if (result == "PARTIALLY_CLEANED") {
      reward = ((data['reward'] ?? 10) / 2).round();
    }

    await FirebaseFirestore.instance.collection('quests').doc(data['questId']).update({
      'status': 'completed',
      'completedBy': uid,
      'completedAt': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'soloPoints': FieldValue.increment(reward),
      'questsCompleted': FieldValue.increment(1),
    });

    if (mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xFF111111),
          title: const Text(
            "Mission Complete 🎉",
            style: TextStyle(color: Colors.greenAccent),
          ),
          content: Text(
            "$result\n\n+$reward points earned",
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }

  // =========================
  // QUEST CARD
  // =========================
  Widget questCard(Map<String, dynamic> data) {
  final participants = (data['participants'] ?? []) as List;

  return Card(
    color: const Color(0xFF1A1A1A),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // QUEST IMAGE
        if (data["mediaUrl"] != null)
          Image.network(
            data["mediaUrl"],
            height: 180,
            width: double.infinity,
            fit: BoxFit.contain,
          ),

        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          QuestDetailsPage(quest: data),
                    ),
                  );
                },
                child: Text(
                  data["title"] ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                data["description"] ?? "",
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 15),

              Row(
                children: [

                  const Icon(
                    Icons.location_on,
                    color: Colors.greenAccent,
                    size: 18,
                  ),

                  const SizedBox(width: 4),

                  Expanded(
                    child: Text(
                      data["location"] ??
                          "Greensfield School",
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [

                  const Icon(
                    Icons.schedule,
                    color: Colors.orange,
                    size: 18,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    data["meetingTime"] ??
                        "Today • 4:00 PM",
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [

                  Chip(
                    backgroundColor: Colors.red.shade800,
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
                      "👥 ${participants.length}",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),

                  Chip(
                    backgroundColor: Colors.green.shade700,
                    label: Text(
                      "🪙 ${data["reward"]}",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () => joinQuest(
                    data["questId"],
                    participants,
                    data["title"],
                  ),
                  icon: const Icon(Icons.explore),
                  label: const Text(
                    "ACCEPT QUEST",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  // =========================
  // MY QUEST CARD
  // =========================
Widget myQuestCard(Map<String, dynamic> data) {
  final participants = (data['participants'] ?? []) as List;

  return Card(
    color: const Color(0xFF1A1A1A),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // QUEST IMAGE
        if (data["mediaUrl"] != null)
          Image.network(
            data["mediaUrl"],
            height: 180,
            width: double.infinity,
            fit: BoxFit.contain,
          ),

        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuestDetailsPage(
                        quest: data,
                      ),
                    ),
                  );
                },
                child: Text(
                  data["title"] ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                data["description"] ?? "",
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 15),

              Row(
                children: [

                  const Icon(
                    Icons.location_on,
                    color: Colors.greenAccent,
                    size: 18,
                  ),

                  const SizedBox(width: 5),

                  Expanded(
                    child: Text(
                      data["location"] ??
                          "Greensfield School",
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [

                  const Icon(
                    Icons.schedule,
                    color: Colors.orange,
                    size: 18,
                  ),

                  const SizedBox(width: 5),

                  Text(
                    data["meetingTime"] ??
                        "Today • 4:00 PM",
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [

                  Chip(
                    backgroundColor: Colors.red.shade800,
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
                      "👥 ${participants.length}",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),

                  Chip(
                    backgroundColor: Colors.green.shade700,
                    label: Text(
                      "🪙 ${data["reward"]}",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [

                    const Icon(
                      Icons.flag,
                      color: Colors.orange,
                      size: 18,
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        "Status: ${data["status"] ?? "Active"}",
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () => completeQuest(data),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text(
                    "COMPLETE QUEST",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  // =========================
  // MAP
  // =========================
  Widget buildMap(List<QueryDocumentSnapshot> docs) {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(6.5244, 3.3792),
        zoom: 12,
      ),
      markers: docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return Marker(
          markerId: MarkerId(data['questId']),
          position: LatLng(data['latitude'], data['longitude']),
        );
      }).toSet(),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
    );
  }

  // =========================
  // BUILD
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Quests",
          style: TextStyle(color: Colors.greenAccent),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
  backgroundColor: Colors.greenAccent,
  foregroundColor: Colors.black,
  icon: const Icon(Icons.add_a_photo),
  label: const Text(
    "Report Issue",
    style: TextStyle(fontWeight: FontWeight.bold),
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateQuestScreen(),
      ),
    );
  },
),

      body: Column(
        children: [
          TabBar(
            controller: tabController,
            labelColor: Colors.greenAccent,
            unselectedLabelColor: Colors.white,
            tabs: const [
              // Tab(text: "Map"),
              Tab(text: "Available Quests"),
              Tab(text: "Active Quests"),
            ],
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('quests').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                final feed = docs.where((d) {
                  final data = d.data() as Map<String, dynamic>;
                  final participants = (data['participants'] ?? []) as List;
                  return !participants.contains(uid) &&
                      data['status'] != 'completed';
                }).toList();

                final mine = docs.where((d) {
                  final data = d.data() as Map<String, dynamic>;
                  final participants = (data['participants'] ?? []) as List;
                  return participants.contains(uid);
                }).toList();

                return TabBarView(
                  controller: tabController,
                  children: [
                    // buildMap(feed),
                    ListView(children: feed.map((d) => questCard(d.data() as Map<String, dynamic>)).toList()),
                    ListView(children: mine.map((d) => myQuestCard(d.data() as Map<String, dynamic>)).toList()),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}