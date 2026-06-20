import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  Color medalColor(int index) {
    switch (index) {
      case 0:
        return Colors.amber;
      case 1:
        return Colors.grey;
      case 2:
        return Colors.orange;
      default:
        return Colors.greenAccent;
    }
  }

  IconData medalIcon(int index) {
    switch (index) {
      case 0:
        return Icons.workspace_premium;
      case 1:
        return Icons.military_tech;
      case 2:
        return Icons.emoji_events;
      default:
        return Icons.person;
    }
  }

  Widget userTile(DocumentSnapshot user, int index) {
    final data = user.data() as Map<String, dynamic>;

    return Card(
      color: const Color(0xFF1A1A1A),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: medalColor(index),
          child: Icon(
            medalIcon(index),
            color: Colors.black,
          ),
        ),
        title: Text(
          data["username"] ?? "Anonymous",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          data["rank"] ?? "Eco Volunteer",
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${data["soloPoints"] ?? 0}",
              style: const TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Text(
              "points",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget fakeList(String type) {
    final fake = [
      {
        "name": "Green Falcons",
        "points": 6480,
      },
      {
        "name": "Eco Ninjas",
        "points": 5900,
      },
      {
        "name": "Tree Squad",
        "points": 5520,
      },
      {
        "name": "Eco-warriors",
        "points": 5470,
      },
      {
        "name": "Earth Avengers",
        "points": 4578,
      },
      {
        "name": "Canopy Crew",
        "points": 4301,
      },
    ];

    return ListView.builder(
      itemCount: fake.length,
      itemBuilder: (_, i) {
        return Card(
          color: const Color(0xFF1A1A1A),
          margin: const EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: medalColor(i),
              child: Text(
                "${i + 1}",
                style: const TextStyle(color: Colors.black),
              ),
            ),
            title: Text(
              fake[i]["name"].toString(),
              style: const TextStyle(color: Colors.white),
            ),
            trailing: Text(
              "${fake[i]["points"]}",
              style: const TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
  Widget fakeSchoolList(String type) {
    final fake = [
      {
        "name": "Megadegs High",
        "points": 5700,
      },
      {
        "name": "Greensfield High",
        "points": 5520,
      },
      {
        "name": "Brad Academy",
        "points": 4598,
      },
         {
        "name": "Brainfield High",
        "points": 4450,
      },
      {
        "name": "Oakridge Institute",
        "points": 3470,
      },
      {
        "name": "Greenwood Academy",
        "points": 3450,
      },
    ];

    return ListView.builder(
      itemCount: fake.length,
      itemBuilder: (_, i) {
        return Card(
          color: const Color(0xFF1A1A1A),
          margin: const EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: medalColor(i),
              child: Text(
                "${i + 1}",
                style: const TextStyle(color: Colors.black),
              ),
            ),
            title: Text(
              fake[i]["name"].toString(),
              style: const TextStyle(color: Colors.white),
            ),
            trailing: Text(
              "${fake[i]["points"]}",
              style: const TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget soloLeaderboard() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .orderBy("soloPoints", descending: true)
          .snapshots(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final users = snapshot.data!.docs;

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (_, index) {
            return userTile(users[index], index);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Community Leaders",
          style: TextStyle(
            color: Colors.greenAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: controller,
          labelColor: Colors.greenAccent,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.greenAccent,
          tabs: const [
            Tab(text: "Solo"),
            Tab(text: "Teams"),
            Tab(text: "Schools"),
          ],
        ),
      ),

      body: TabBarView(
        controller: controller,
        children: [
          soloLeaderboard(),
          fakeList("Teams"),
          fakeSchoolList("Schools"),
        ],
      ),
    );
  }
}