
import 'package:flutter/material.dart';

class MysteryLibraryScreen extends StatelessWidget {
  const MysteryLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mystery Library'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Choose a mystery to solve',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Investigate clues, solve the mystery, and discover the truth.',
          ),
          const SizedBox(height: 20),

          _MysteryCard(
            title: 'The Missing Necklace',
            description:
                'A valuable necklace disappeared during a family dinner.',
            difficulty: 'Easy',
            icon: Icons.search,
            color: const Color(0xFF6C55D8),
          ),

          const SizedBox(height: 12),

          _MysteryCard(
            title: 'The Locked Room',
            description:
                'A mysterious incident occurred in a locked room.',
            difficulty: 'Medium',
            icon: Icons.lock_outline,
            color: const Color(0xFF287F9E),
            comingSoon: true,
          ),

          const SizedBox(height: 12),

          _MysteryCard(
            title: 'The Secret of Room 13',
            description:
                'Discover the secrets hidden behind Room 13.',
            difficulty: 'Hard',
            icon: Icons.key,
            color: const Color(0xFF9B4D85),
            comingSoon: true,
          ),
        ],
      ),
    );
  }
}

class _MysteryCard extends StatelessWidget {
  final String title;
  final String description;
  final String difficulty;
  final IconData icon;
  final Color color;
  final bool comingSoon;

  const _MysteryCard({
    required this.title,
    required this.description,
    required this.difficulty,
    required this.icon,
    required this.color,
    this.comingSoon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.15),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(description),
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(label: Text(difficulty)),
                const Spacer(),
                if (comingSoon)
                  const Text(
                    'Coming soon',
                    style: TextStyle(color: Colors.grey),
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const InvestigationScreen(),
                        ),
                      );
                    },
                    child: const Text('Play'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InvestigationScreen extends StatefulWidget {
  const InvestigationScreen({super.key});

  @override
  State<InvestigationScreen> createState() =>
      _InvestigationScreenState();
}

class _InvestigationScreenState extends State<InvestigationScreen> {
  int cluesFound = 0;
  bool hintShown = false;
  bool accusationMade = false;
  String? selectedSuspect;
  String? resultMessage;

  final List<String> suspects = [
    'Emma - The Daughter',
    'Daniel - The Butler',
    'Sophia - The Guest',
  ];

  final List<Map<String, String>> clues = [
    {
      'title': 'Clue 1: The Broken Glass',
      'description': 'A glass was broken near the jewellery cabinet.',
    },
    {
      'title': 'Clue 2: The Open Window',
      'description':
          'The window was open, but there were no footprints outside.',
    },
    {
      'title': 'Clue 3: The Blue Thread',
      'description': 'Blue fabric was found near the cabinet.',
    },
  ];

  void revealClue() {
    if (cluesFound < clues.length) {
      setState(() {
        cluesFound++;
      });
    }
  }

  void showHint() {
    setState(() {
      hintShown = true;
    });
  }

  void makeAccusation() {
    if (selectedSuspect == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a suspect first.'),
        ),
      );
      return;
    }

    setState(() {
      accusationMade = true;

      if (selectedSuspect == 'Emma - The Daughter') {
        resultMessage =
            'Correct! Emma took the necklace. '
            'The blue fabric matched her dress, and she used '
            'the broken glass to create a distraction.';
      } else {
        resultMessage =
            'Incorrect! That suspect was innocent. '
            'Review the clues and try the investigation again.';
      }
    });
  }

  void resetInvestigation() {
    setState(() {
      cluesFound = 0;
      hintShown = false;
      accusationMade = false;
      selectedSuspect = null;
      resultMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Investigation'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // STORY
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF6C55D8),
                  Color(0xFF44317E),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 40,
                ),
                SizedBox(height: 12),
                Text(
                  'The Missing Necklace',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'A valuable necklace disappeared during a family '
                  'dinner. Three people were inside the house. '
                  'Can you discover who took it?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // PROGRESS
          Text(
            'Investigation Progress',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          LinearProgressIndicator(
            value: cluesFound / clues.length,
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
          ),

          const SizedBox(height: 8),

          Text('$cluesFound of ${clues.length} clues discovered'),

          const SizedBox(height: 24),

          // CLUES
          Text(
            'Discover the Clues',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          ...List.generate(clues.length, (index) {
            final clue = clues[index];
            final discovered = index < cluesFound;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(
                  discovered
                      ? Icons.check_circle
                      : Icons.lock_outline,
                  color: discovered ? Colors.green : Colors.grey,
                ),
                title: Text(
                  clue['title']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  discovered
                      ? clue['description']!
                      : 'Clue not discovered yet',
                ),
              ),
            );
          }),

          const SizedBox(height: 10),

          // DISCOVER CLUE
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed:
                  cluesFound < clues.length ? revealClue : null,
              icon: const Icon(Icons.search),
              label: Text(
                cluesFound < clues.length
                    ? 'Discover Next Clue'
                    : 'All Clues Discovered',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // HINT
          Card(
            color: Colors.amber.withValues(alpha: 0.15),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Need a Hint?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (hintShown)
                    const Text(
                      'Look for the person whose clothing matches '
                      'the blue fabric found near the jewellery cabinet.',
                    ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: showHint,
                    child: Text(
                      hintShown ? 'Hint Revealed' : 'Reveal Hint',
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // SUSPECTS
          Text(
            'Choose Your Suspect',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          ...suspects.map((suspect) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: RadioListTile<String>(
                value: suspect,
                groupValue: selectedSuspect,
                title: Text(suspect),
                onChanged: accusationMade
                    ? null
                    : (value) {
                        setState(() {
                          selectedSuspect = value;
                        });
                      },
              ),
            );
          }),

          const SizedBox(height: 12),

          // ACCUSATION
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  accusationMade ? null : makeAccusation,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C55D8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Make My Accusation'),
            ),
          ),

          // RESULT
          if (resultMessage != null) ...[
            const SizedBox(height: 20),
            Card(
              color: selectedSuspect == 'Emma - The Daughter'
                  ? Colors.green.withValues(alpha: 0.15)
                  : Colors.red.withValues(alpha: 0.15),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  resultMessage!,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: resetInvestigation,
                icon: const Icon(Icons.refresh),
                label: const Text('Play Investigation Again'),
              ),
            ),
          ],

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
