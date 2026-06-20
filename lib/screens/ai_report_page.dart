import 'dart:async';

import 'package:flutter/material.dart';

class AIReportPage extends StatefulWidget {
  const AIReportPage({super.key});

  @override
  State<AIReportPage> createState() => _AIReportPageState();
}

class _AIReportPageState extends State<AIReportPage> {
  final String report = """

EcoQuest AI Environmental Intelligence Report

School: Greensfield High School

Environmental Health Score: 86/100

Analyzing school environmental activity...

✓ 17 quests were created this week.

✓ 15 quests were successfully completed.

✓ Student participation increased by 31%.

✓ Approximately 182 kg of waste was removed from the school environment.

The highest concentration of environmental issues was detected around the cafeteria and school field.

Analysis suggests these incidents occur mostly after lunch breaks and sporting activities.

Based on previous cleanup patterns, EcoQuest predicts these locations are likely to continue generating waste unless preventive measures are introduced.

Recommended Actions

• Install two additional recycling bins near the cafeteria.

• Introduce color-coded waste separation bins.

• Schedule Eco Club patrols immediately after lunch.

• Launch a one-week environmental awareness campaign.

Predicted Outcome

If these recommendations are implemented, EcoQuest AI estimates a 38% reduction in litter within the next month.

Overall Assessment

Greensfield High is making excellent progress.

Students are actively participating, cleanup completion rates remain high, and environmental awareness is steadily improving.

EcoQuest recommends continuing weekly quests while focusing future efforts on preventing recurring waste rather than only cleaning it.

Mission Status

School Environment:
IMPROVING
""";

  String displayed = "";

  int index = 0;

  Timer? timer;

  bool finished = false;

  @override
  void initState() {
    super.initState();
    streamText();
  }

  void streamText() {
    final words = report.split(" ");

    timer = Timer.periodic(
      const Duration(milliseconds: 35),
      (t) {
        if (index >= words.length) {
          t.cancel();

          setState(() {
            finished = true;
          });

          return;
        }

        setState(() {
          displayed += "${words[index]} ";
          index++;
        });
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget statCard(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Expanded(
      child: Card(
        color: const Color(0xff1B1B1B),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 12,
          ),
          child: Column(
            children: [
              Icon(icon, color: color),

              const SizedBox(height: 8),

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
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "AI Environmental Report",
          style: TextStyle(
            color: Colors.greenAccent,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [

            Row(
              children: [

                statCard(
                  "Health",
                  "86",
                  Icons.eco,
                  Colors.greenAccent,
                ),

                statCard(
                  "Quests",
                  "17",
                  Icons.flag,
                  Colors.orange,
                ),
              ],
            ),

            Row(
              children: [

                statCard(
                  "Waste",
                  "182kg",
                  Icons.delete,
                  Colors.greenAccent,
                ),

                statCard(
                  "Volunteers",
                  "42",
                  Icons.groups,
                  Colors.lightBlueAccent,
                ),

              ],
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xff111111),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.greenAccent,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: const [

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
                          fontSize: 18,
                        ),
                      ),

                    ],
                  ),

                  const SizedBox(height: 20),

                  Text(
                    displayed,
                    style: const TextStyle(
                      color: Colors.white,
                      height: 1.6,
                      fontSize: 15,
                    ),
                  ),

                  if (!finished) ...[
                    const SizedBox(height: 15),

                    const LinearProgressIndicator(
                      color: Colors.greenAccent,
                      backgroundColor: Colors.white10,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Generating environmental intelligence...",
                      style: TextStyle(
                        color: Colors.white54,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],

                  if (finished) ...[
                    const SizedBox(height: 20),

                    Row(
                      children: const [

                        Icon(
                          Icons.check_circle,
                          color: Colors.greenAccent,
                        ),

                        SizedBox(width: 10),

                        Text(
                          "Report Generated Successfully",
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        )

                      ],
                    )
                  ]

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}