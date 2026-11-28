import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import 'mystery_library_screen.dart';

typedef StringMap = Map<String, String>;

class MysteryStoryScreen extends StatelessWidget {
  const MysteryStoryScreen({super.key});

  static const List<StringMap> suspects = [
    {
      'name': 'Emma Blackwood — The Daughter',
      'image': 'assets/images/emma_dossier.png',
      'role': 'Wore a royal blue silk dress • Financial motive',
      'statement':
          '"I stayed in the dining room the entire evening! Why would I steal my own mother\'s sapphire necklace?"',
      'detail':
          'Argued with Mrs. Blackwood before dinner about unpaid debts. Guest Sophia saw her step toward the drawing room at 8:55 PM.',
    },
    {
      'name': 'Daniel Reed — The Butler',
      'image': 'assets/images/daniel_butler.png',
      'role': 'Served dinner & cleared glasses • Knows key locations',
      'statement':
          '"I was serving dessert in the dining room at 9:00 PM. Only Mrs. Blackwood and I know the spare cabinet key is kept in the study drawer."',
      'detail':
          'Confirms the cabinet lock had no scratch marks—meaning whoever opened it used the spare key from the study.',
    },
    {
      'name': 'Sophia Carter — The Guest',
      'image': 'assets/images/sophia_guest.png',
      'role': 'Sat near the dining room exit • Eyewitness',
      'statement':
          '"I admired the necklace earlier, yes, but I never left my seat—and I clearly saw Emma slip out of the dining room at 8:55 PM!"',
      'detail':
          'Her eyewitness timeline directly contradicts Emma\'s claim that she never left the dining room.',
    },
    {
      'name': 'Mr. William Blackwood — The Uncle',
      'image': 'assets/images/william_uncle.png',
      'role': 'Has business debts • Argued over family heirlooms',
      'statement':
          '"I was smoking a cigar on the front veranda with two guests from 8:45 PM until Mrs. Blackwood screamed."',
      'detail':
          'Although he wanted the heirloom, two witnesses confirm he never entered the drawing room.',
    },
    {
      'name': 'Leo Martin — The Gardener',
      'image': 'assets/images/leo_gardener.png',
      'role': 'Worked outside near the drawing-room window',
      'statement':
          '"It rained at 8:30 PM, turning the flowerbed beneath that window into soft mud. Nobody climbed in or out—there isn\'t a single footprint!"',
      'detail':
          'Proves the open drawing-room window was staged from the inside to fake a burglary.',
    },
    {
      'name': 'Mrs. Rose — The Housekeeper',
      'image': 'assets/images/rose_housekeeper.png',
      'role': 'Dusted the drawing room at 7:30 PM',
      'statement':
          '"When I dusted the jewellery cabinet at 7:30 PM, the brass handle was spotless and all crystal glasses were safely on the sideboard."',
      'detail':
          'Proves the blue silk thread on the handle and the broken glass on the floor happened after 7:30 PM.',
    },
  ];

  void _showSuspectsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.82,
        builder: (_, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Suspect Dossiers & Alibis (6)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Inspect each suspect\'s portrait, alibi, and motive.',
              style: TextStyle(fontSize: 13, color: AppTheme.secondaryText),
            ),
            const SizedBox(height: 14),
            ...suspects.map(
              (s) => Card(
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              s['image']!,
                              width: 72,
                              height: 92,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(s['name']!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 15)),
                                const SizedBox(height: 4),
                                Text(s['role']!,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.primary)),
                                const SizedBox(height: 6),
                                Text(
                                  s['statement']!,
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12.5,
                                      color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(s['detail']!,
                          style: const TextStyle(
                              fontSize: 13, color: AppTheme.secondaryText)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Case #1 Briefing')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                'assets/images/mansion_exterior.png',
                height: 185,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF292345), Color(0xFF51418C)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'THE MISSING NECKLACE',
                    style: TextStyle(
                      color: AppTheme.secondary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'At 9:00 PM during the annual Blackwood family dinner, Mrs. Blackwood entered the drawing room to show her guests her prized sapphire necklace—only to find the jewellery cabinet empty.\n\n'
                    '• Housekeeper Mrs. Rose confirmed the cabinet was spotless at 7:30 PM.\n'
                    '• Butler Daniel Reed noted the cabinet was unlocked with the spare study key.\n'
                    '• Gardener Leo Martin found zero footprints in the wet mud outside the open window.\n'
                    '• Uncle William was on the veranda, while Guest Sophia Carter saw Daughter Emma leave the dining room at 8:55 PM.\n\n'
                    'Complete the evidence mini-games and unlock Clues 4, 5 & 6 with your earned XP!',
                    style: TextStyle(color: Colors.white, fontSize: 14.5, height: 1.55),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InvestigationScreen()),
                ),
                icon: const Icon(Icons.search_rounded),
                label: const Text('Start Investigation'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showSuspectsSheet(context),
                icon: const Icon(Icons.people_alt_outlined),
                label: const Text('View Suspect Dossiers (6)'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}