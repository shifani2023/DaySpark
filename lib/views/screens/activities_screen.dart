import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_progress_provider.dart';
import '../../utils/app_theme.dart';

typedef PuzzleMap = Map<String, dynamic>;

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  static const List<PuzzleMap> puzzles = [
    {
      'id': 'puzzle_riddle_1',
      'title': 'Detective Riddle',
      'category': 'Logic',
      'xp': 25,
      'question':
          'I speak without a mouth and hear without ears. I have no body, but I come alive with wind. What am I?',
      'options': ['Shadow', 'Echo', 'Whisper', 'Clock'],
      'answer': 'Echo',
    },
    {
      'id': 'puzzle_pattern_2',
      'title': 'Safe Combination Code',
      'category': 'Math Logic',
      'xp': 30,
      'question': 'Unlock the mansion vault! Find the next number: 2, 6, 12, 20, 30, ?',
      'options': ['36', '40', '42', '44'],
      'answer': '42',
    },
    {
      'id': 'puzzle_word_3',
      'title': 'Evidence Anagram',
      'category': 'Word Puzzle',
      'xp': 20,
      'question': 'Unscramble the letters "E C L U" to find what every detective searches for:',
      'options': ['CLUE', 'LUCE', 'CULE', 'ELUC'],
      'answer': 'CLUE',
    },
    {
      'id': 'puzzle_alibi_4',
      'title': 'Alibi Check',
      'category': 'Deduction',
      'xp': 35,
      'question':
          'A theft happened at 9:00 PM. Who has NO valid alibi?\n• Butler: Serving tea at 9:00 PM\n• Gardener: Locking greenhouse at 9:00 PM\n• Guest: Seen leaving dining room at 8:55 PM',
      'options': ['Butler', 'Gardener', 'Guest'],
      'answer': 'Guest',
    },
  ];

  void _openPuzzleDialog(BuildContext context, PuzzleMap puzzle) {
    String? chosen;
    final options = List<String>.from(puzzle['options'] as List);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text('${puzzle['title']} (+${puzzle['xp']} XP)'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(puzzle['question'] as String),
              const SizedBox(height: 14),
              ...options.map((opt) {
                final isSelected = chosen == opt;
                return InkWell(
                  onTap: () => setDialogState(() => chosen = opt),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: isSelected ? AppTheme.primary : Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Text(opt),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: chosen == null
                  ? null
                  : () {
                      Navigator.pop(ctx);
                      if (chosen == puzzle['answer']) {
                        context.read<UserProgressProvider>().awardXp(
                              puzzle['xp'] as int,
                              puzzleId: puzzle['id'] as String,
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('🎉 Correct! +${puzzle['xp']} XP earned!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('❌ Incorrect! Try again.'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final solved = context.watch<UserProgressProvider>().solvedPuzzles;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Daily Puzzles & Challenges 🧩',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.darkText),
          ),
          const SizedBox(height: 6),
          const Text(
            'Solve brain teasers to earn XP and level up your profile!',
            style: TextStyle(color: AppTheme.secondaryText),
          ),
          const SizedBox(height: 20),
          ...puzzles.map((puzzle) {
            final isSolved = solved.contains(puzzle['id']);
            return Card(
              margin: const EdgeInsets.only(bottom: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: isSolved
                      ? Colors.green.withValues(alpha: 0.15)
                      : const Color(0xFFE8E3FF),
                  child: Icon(
                    isSolved ? Icons.check_circle : Icons.extension_rounded,
                    color: isSolved ? Colors.green : AppTheme.primary,
                  ),
                ),
                title: Text(
                  puzzle['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${puzzle['category']} • Reward: +${puzzle['xp']} XP'),
                trailing: ElevatedButton(
                  onPressed: () => _openPuzzleDialog(context, puzzle),
                  child: Text(isSolved ? 'Replay' : 'Solve'),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}