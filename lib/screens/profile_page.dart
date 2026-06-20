import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  String get uid => 'victor';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.greenAccent),
        ),
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data =
              snapshot.data!.data() as Map<String, dynamic>? ?? {};

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                // PROFILE PHOTO
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.greenAccent,
                  backgroundImage: data["photoUrl"] != null
                      ? NetworkImage(data["photoUrl"])
                      : null,
                  child: data["photoUrl"] == null
                      ? const Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 55,
                        )
                      : null,
                ),

                const SizedBox(height: 15),

                Text(
                  data["username"] ?? "Eco Volunteer",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  data["rank"] ?? "Eco Guardian",
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 25),

                Row(
                  children: [

                    Expanded(
                      child: statCard(
                        "Points",
                        "${data["soloPoints"] ?? 0}",
                        Icons.stars,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: statCard(
                        "Completed",
                        "${data["questsCompleted"] ?? 0}",
                        Icons.check_circle,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [

                    Expanded(
                      child: statCard(
                        "Global Rank",
                        "#${data["globalRank"] ?? 18}",
                        Icons.public,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: statCard(
                        "School Rank",
                        "#${data["schoolRank"] ?? 2}",
                        Icons.school,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Achievements",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: const [

                    Chip(
                      avatar: Icon(Icons.eco),
                      label: Text("First Cleanup"),
                    ),

                    Chip(
                      avatar: Icon(Icons.groups),
                      label: Text("Team Player"),
                    ),

                    Chip(
                      avatar: Icon(Icons.emoji_events),
                      label: Text("Top 10"),
                    ),

                    Chip(
                      avatar: Icon(Icons.local_fire_department),
                      label: Text("7 Day Streak"),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Card(
                  color: const Color(0xFF1A1A1A),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: const [

                        Text(
                          "Community Impact",
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 12),

                        ListTile(
                          leading: Icon(
                            Icons.delete,
                            color: Colors.greenAccent,
                          ),
                          title: Text(
                            "83 kg Waste Removed",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),

                        ListTile(
                          leading: Icon(
                            Icons.location_on,
                            color: Colors.greenAccent,
                          ),
                          title: Text(
                            "18 Local Missions Completed",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),

                        ListTile(
                          leading: Icon(
                            Icons.groups,
                            color: Colors.greenAccent,
                          ),
                          title: Text(
                            "62 Volunteers Inspired",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget statCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Card(
      color: const Color(0xFF1A1A1A),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 10,
        ),
        child: Column(
          children: [

            Icon(
              icon,
              color: Colors.greenAccent,
            ),

            const SizedBox(height: 10),

            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}