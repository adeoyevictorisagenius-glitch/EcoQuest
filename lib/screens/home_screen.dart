import 'dart:ui';

import 'package:ecoquest/screens/ai_command_centre.dart';
import 'package:flutter/material.dart';

// import 'ai_command_center_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
          title: SizedBox(
            height: 85,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/logo_transparent.png',
                    height: 100, width: 150),
                
                
              ],
            ),
          ),
          backgroundColor: const Color(0xff181818),
        ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.auto_awesome),
        label: const Text("AI Recommendations"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AICommandCenterPage(),
            ),
          );
        },
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                        Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xff181818),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: const [
                  Text(
                    "Greensfield High",                 
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                    ),
                  ),

                  Text(
                    "Community Sustainability Score",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  SizedBox(height: 15),

                  Text(
                    "84",
                    style: TextStyle(
                      fontSize: 70,
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    "/100",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  SizedBox(height: 15),

                  Chip(
                    backgroundColor: Colors.green,
                    label: Text("Excellent", style: TextStyle(color: Colors.white),),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "+9 this week",
                    style: TextStyle(
                      color: Colors.greenAccent,
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 25),
                        const Text(
              "AI Insight",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xff1b1b1b),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: Colors.greenAccent,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "EcoQuest AI",
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  Text(
                    "School Analysis Complete",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 15),

                  Text("✓ Waste trends analyzed",
                      style: TextStyle(color: Colors.white70)),

                  Text("✓ Volunteer activity analyzed",
                      style: TextStyle(color: Colors.white70)),

                  Text("✓ Hotspots identified",
                      style: TextStyle(color: Colors.white70)),

                  Text("✓ Previous missions analyzed",
                      style: TextStyle(color: Colors.white70)),

                  Text("✓ Weather forecast considered",
                      style: TextStyle(color: Colors.white70)),

                  Text("✓ Recycling behaviour evaluated",
                      style: TextStyle(color: Colors.white70)),

                  Divider(height: 35),

                  Text(
                    "Today's Recommendations",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 15),

                  Text(
                    "1. Deploy 5 volunteers to the cafeteria",
                    style: TextStyle(color: Colors.white),
                  ),

                  Text(
                    "Confidence: 96%",
                    style: TextStyle(color: Colors.greenAccent),
                  ),

                  SizedBox(height: 15),

                  Text(
                    "2. Empty recycling bins before lunch",
                    style: TextStyle(color: Colors.white),
                  ),

                  Text(
                    "Confidence: 91%",
                    style: TextStyle(color: Colors.greenAccent),
                  ),

                  SizedBox(height: 15),

                  Text(
                    "3. Place recycling signs near the football field",
                    style: TextStyle(color: Colors.white),
                  ),

                  Text(
                    "Confidence: 88%",
                    style: TextStyle(color: Colors.greenAccent),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 25),
                        const Text(
              "Community Impact",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: const [

                _ImpactCard(
                  title: "Waste Removed",
                  value: "3452 kg",
                  icon: Icons.delete,
                ),

                _ImpactCard(
                  title: "Completed Missions",
                  value: "294",
                  icon: Icons.task_alt,
                ),

                _ImpactCard(
                  title: "Student Volunteers",
                  value: "312",
                  icon: Icons.groups,
                ),

                _ImpactCard(
                  title: "Hotspots Eliminated",
                  value: "19",
                  icon: Icons.location_on,
                ),

              ],
            ),

            const SizedBox(height: 30),
                        const Text(
              "Environmental Hotspots",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            hotspot("🔥 Cafeteria", "HIGH", "12 Reports"),
            hotspot("🟠 Football Field", "MEDIUM", "6 Reports"),
            hotspot("🟢 Main Gate", "LOW", "2 Reports"),

            const SizedBox(height: 100),

          ],
        ),
      ),
    );
  }
}
Widget hotspot(String title, String level, String reports) {
  return Card(
    color: const Color(0xff1a1a1a),
    margin: const EdgeInsets.only(bottom: 12),
    child: ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        reports,
        style: const TextStyle(color: Colors.white70),
      ),
      trailing: Chip(
        label: Text(level),
      ),
    ),
  );
}

class _ImpactCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _ImpactCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xff1a1a1a),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              icon,
              color: Colors.greenAccent,
              size: 36,
            ),

            const SizedBox(height: 10),

            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              title,
              textAlign: TextAlign.center,
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