import 'package:ecoquest/screens/ai_report_page.dart';
import 'package:flutter/material.dart';

class AICommandCenterPage extends StatelessWidget {
  const AICommandCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "AI Command Center",
          style: TextStyle(
            color: Colors.greenAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.auto_awesome),
        label: const Text("AI Weekly Report"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AIReportPage(),
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
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xff181818),
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
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 20),

                  Text(
                    "90-Day School Analysis",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  SizedBox(height: 15),

                  Text(
                    "Greensfield High School has improved its sustainability score by 14% over the last 90 days.",
                    style: TextStyle(color: Colors.white70),
                  ),

                  SizedBox(height: 15),

                  Text(
                    "However, the Cafeteria remains the largest recurring waste hotspot.",
                    style: TextStyle(color: Colors.orange),
                  ),

                  SizedBox(height: 15),

                  Text(
                    "76% of cleanup missions occur within a 20 metre radius of the Cafeteria.",
                    style: TextStyle(color: Colors.white70),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 25),
                        const Text(
              "Root Cause Analysis",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            causeTile(
              "Overflowing Bins",
              "42%",
              Colors.red,
            ),

            causeTile(
              "Food Waste",
              "31%",
              Colors.orange,
            ),

            causeTile(
              "Poor Recycling Awareness",
              "17%",
              Colors.green,
            ),

            causeTile(
              "Other",
              "10%",
              Colors.blue,
            ),

            const SizedBox(height: 30),
                        const Text(
              "AI Predictions",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            predictionCard(
              "Expected Waste Next Month",
              "▲ 11%",
              "Confidence: 93%",
              "Sports Festival expected to increase litter generation.",
            ),

            predictionCard(
              "Plastic Waste",
              "▼ 18%",
              "Confidence: 85%",
              "If current cleanup efforts continue.",
            ),

            const SizedBox(height: 30),
                        const Text(
              "Long-Term Recommendations",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),

            const SizedBox(height: 15),

            recommendation(
              "Install two additional recycling stations behind the Cafeteria.",
              "+8 CSS",
              "Low Cost",
            ),

            recommendation(
              "Move lunch bins closer to student exits.",
              "14% Waste Reduction",
              "Medium Cost",
            ),

            recommendation(
              "Launch Eco Friday where students earn rewards for recycling.",
              "74% Participation",
              "Very Low Cost",
            ),

            const SizedBox(height: 30),
                        const Text(
              "Impact Simulator",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xff1A1A1A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [

                  Text(
                    "If Greensfield High installs 2 additional recycling stations...",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),

                  SizedBox(height: 25),

                  Text(
                    "Community Sustainability Score",
                    style: TextStyle(color: Colors.white70),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "84 ➜ 92",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 34,
                    ),
                  ),

                  SizedBox(height: 25),

                  Divider(),

                  SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text(
                        "Waste Reduction",
                        style: TextStyle(color: Colors.white70),
                      ),

                      Text(
                        "26%",
                        style: TextStyle(color: Colors.greenAccent),
                      ),

                    ],
                  ),

                  SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text(
                        "Volunteer Need",
                        style: TextStyle(color: Colors.white70),
                      ),

                      Text(
                        "-18%",
                        style: TextStyle(color: Colors.greenAccent),
                      ),

                    ],
                  ),

                  SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text(
                        "Estimated CO₂ Saved",
                        style: TextStyle(color: Colors.white70),
                      ),

                      Text(
                        "58 kg/month",
                        style: TextStyle(color: Colors.greenAccent),
                      ),

                    ],
                  ),

                ],
              ),
            ),

            const SizedBox(height: 100),

          ],
        ),
      ),
    );
  }
  Widget causeTile(String title, String value, Color color) {
  return Card(
    color: const Color(0xff1A1A1A),
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: Text(
        value,
        style: const TextStyle(
          color: Colors.greenAccent,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    ),
  );
}

Widget predictionCard(
  String title,
  String prediction,
  String confidence,
  String description,
) {
  return Card(
    color: const Color(0xff1A1A1A),
    margin: const EdgeInsets.only(bottom: 12),
    child: ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        "$confidence\n$description",
        style: const TextStyle(color: Colors.white70),
      ),
      trailing: Text(
        prediction,
        style: const TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

Widget recommendation(
  String text,
  String impact,
  String cost,
) {
  return Card(
    color: const Color(0xff1A1A1A),
    margin: const EdgeInsets.only(bottom: 12),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [

              Chip(
                backgroundColor: Colors.green,
                label: Text(impact),
              ),

              const SizedBox(width: 10),

              Chip(
                backgroundColor: Colors.blue,
                label: Text(cost),
              ),

            ],
          )

        ],
      ),
    ),
  );
}}