import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_progress_provider.dart';
import '../../utils/app_theme.dart';
import 'mystery_story_screen.dart';

typedef DynamicMap = Map<String, dynamic>;
typedef StringMap = Map<String, String>;

// ============================================================
// MYSTERY LIBRARY SCREEN
// ============================================================

class MysteryLibraryScreen extends StatefulWidget {
  const MysteryLibraryScreen({super.key});

  @override
  State<MysteryLibraryScreen> createState() => _MysteryLibraryScreenState();
}

class _MysteryLibraryScreenState extends State<MysteryLibraryScreen> {
  String _searchQuery = '';
  static const int _nextCaseUnlockXp = 150;

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<UserProgressProvider>();
    final completed = progress.completedMysteries;
    final currentXp = progress.xp;
    final nextCaseUnlocked = currentXp >= _nextCaseUnlockXp;

    final List<DynamicMap> mysteries = [
      {
        'id': 'missing_necklace',
        'title': 'Case #1: The Missing Necklace',
        'description':
            'A prized sapphire necklace vanished during dinner at Blackwood Mansion. Solve 6 interactive evidence games & suspect interrogations.',
        'difficulty': 'Easy • 6 Clues',
        'image': 'assets/images/mansion_exterior.png',
        'locked': false,
      },
      {
        'id': 'locked_room',
        'title': 'Case #2: The Locked Room (Sneak Peek)',
        'description': nextCaseUnlocked
            ? 'UNLOCKED SNEAK PEEK! At midnight in Blackwood Study, a rare cipher diary vanished from a room bolted from the inside. 4 new suspects await!'
            : 'Reach $_nextCaseUnlockXp XP (you have $currentXp XP) to unlock an exclusive sneak peek of Case #2!',
        'difficulty': nextCaseUnlocked
            ? 'Sneak Peek Ready'
            : 'Requires $_nextCaseUnlockXp XP',
        'image': 'assets/images/locked_room_door.png',
        'locked': !nextCaseUnlocked,
      },
    ];

    final filtered = mysteries.where((m) {
      final q = _searchQuery.toLowerCase();

      return (m['title'] as String).toLowerCase().contains(q) ||
          (m['difficulty'] as String).toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Mystery Cases')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Detective Case Files',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Solve clues to earn XP and unlock upcoming mystery previews.',
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search cases...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...filtered.map((m) {
            final isSolved = completed.contains(m['id']);
            final isLocked = m['locked'] as bool;
            final isCase2 = m['id'] == 'locked_room';

            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        Image.asset(
                          m['image'] as String,
                          height: 145,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        if (isLocked)
                          Container(
                            height: 145,
                            width: double.infinity,
                            color: Colors.black54,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.lock_rounded,
                                  color: Colors.white,
                                  size: 34,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Unlocks at $_nextCaseUnlockXp XP',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                m['title'] as String,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (isSolved)
                              const Icon(Icons.verified, color: Colors.green),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(m['description'] as String),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Chip(
                              label: Text(m['difficulty'] as String),
                            ),
                            const Spacer(),
                            if (!isCase2)
                              ElevatedButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const MysteryStoryScreen(),
                                  ),
                                ),
                                child: Text(
                                  isSolved ? 'Play Again' : 'Investigate',
                                ),
                              )
                            else if (!isLocked)
                              ElevatedButton.icon(
                                onPressed: () =>
                                    _showSneakPeekDialog(context),
                                icon: const Icon(Icons.visibility),
                                label: const Text('View Sneak Peek'),
                              )
                            else
                              Text(
                                '${_nextCaseUnlockXp - currentXp} XP needed',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primary,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showSneakPeekDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        title: const Text('🔮 Case #2 Sneak Peek: The Locked Room'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                'assets/images/locked_room_door.png',
                height: 130,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Coming Soon in Season 2!\n\n'
              '• Location: The East Wing Study\n'
              '• Mystery: A secret ledger disappeared while the oak door was bolted from the inside.\n'
              '• Reward Preview: Up to +250 XP & Master Detective Badge.',
              style: TextStyle(height: 1.5),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Awesome!'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// INVESTIGATION SCREEN
// ============================================================

class InvestigationScreen extends StatefulWidget {
  const InvestigationScreen({super.key});

  @override
  State<InvestigationScreen> createState() => _InvestigationScreenState();
}

class _InvestigationScreenState extends State<InvestigationScreen> {
  bool accusationMade = false;
  String? selectedSuspect;
  String? resultMessage;

  final List<String> suspects = [
    'Emma Blackwood — The Daughter',
    'Daniel Reed — The Butler',
    'Sophia Carter — The Guest',
    'Mr. William Blackwood — The Uncle',
    'Leo Martin — The Gardener',
    'Mrs. Rose — The Housekeeper',
  ];

  static const List<DynamicMap> clues = [
    {
      'id': 'mn_clue_1',
      'title': 'Clue 1 — The Broken Glass',
      'gameType': 'jigsaw',
      'subtitle':
          'Mini-Game: Reassemble the 8 shattered glass pieces (+20 XP)',
      'requiredXp': 0,
      'xpReward': 20,
      'image': 'assets/images/broken_glass.png',
      'description':
          'Jigsaw Complete! The crystal glass shards scatter outward from inside the room—proving someone dropped it internally as a distraction.',
    },
    {
      'id': 'mn_clue_2',
      'title': 'Clue 2 — The Open Window',
      'gameType': 'window_sort',
      'subtitle':
          'Mini-Game: Sort the 4 window & garden clues (+20 XP)',
      'requiredXp': 0,
      'xpReward': 20,
      'image': 'assets/images/mansion_exterior.png',
      'description':
          'Sorting Complete! Gardener Leo Martin confirmed zero footprints in the wet soil outside. The open window was staged from inside.',
    },
    {
      'id': 'mn_clue_3',
      'title': 'Clue 3 — The Blue Thread',
      'gameType': 'cabinet_sort',
      'subtitle':
          'Mini-Game: Cabinet & suspect fabric matching (+20 XP)',
      'requiredXp': 0,
      'xpReward': 20,
      'image': 'assets/images/evidence_closeup.png',
      'description':
          "Cabinet Match Complete! Housekeeper Mrs. Rose cleaned the handle at 7:30 PM. The royal blue silk thread matches Emma's evening dress.",
    },
    {
      'id': 'mn_clue_4',
      'title': 'Clue 4 — The Study Key Drawer',
      'gameType': 'study_lock',
      'subtitle':
          'Mini-Game: Crack the 3-digit study drawer lock (Unlocks at 40 XP • +25 XP)',
      'requiredXp': 40,
      'xpReward': 25,
      'image': 'assets/images/study_key_drawer.png',
      'description':
          'Drawer Unlocked! Butler Daniel Reed confirmed the spare key was taken from this study drawer—no crowbar was used on the jewellery cabinet.',
    },
    {
      'id': 'mn_clue_5',
      'title': 'Clue 5 — 8:55 PM Hallway Timeline',
      'gameType': 'timeline_order',
      'subtitle':
          'Mini-Game: Reconstruct the 4 dinner-night events in order (Unlocks at 60 XP • +25 XP)',
      'requiredXp': 60,
      'xpReward': 25,
      'image': 'assets/images/hallway_clock_855.png',
      'description':
          "Timeline Proven! Emma claimed she never left the dining room, yet Guest Sophia saw her slip past the hallway clock at 8:55 PM.",
    },
    {
      'id': 'mn_clue_6',
      'title': 'Clue 6 — The Handbag Cipher',
      'gameType': 'gem_cipher',
      'subtitle':
          'Mini-Game: Tap letter tiles to decode the hidden gem (Unlocks at 85 XP • +25 XP)',
      'requiredXp': 85,
      'xpReward': 25,
      'image': 'assets/images/handbag_sapphire.png',
      'description':
          "Cipher Solved! A loose royal blue SAPPHIRE from Mrs. Blackwood's necklace was discovered inside Emma's velvet handbag.",
    },
  ];

  Future<void> _launchClueGame(
    DynamicMap clue,
    bool unlocked,
    int userXp,
  ) async {
    final reqXp = clue['requiredXp'] as int;

    if (!unlocked && userXp < reqXp) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '🔒 You need $reqXp XP to unlock this clue (Current: $userXp XP). Solve earlier clues or Daily Puzzles first!',
          ),
          backgroundColor: Colors.deepOrange,
        ),
      );
      return;
    }

    if (unlocked) {
      _showClueResultSheet(clue);
      return;
    }

    bool solved = false;
    final gameType = clue['gameType'] as String;

    if (gameType == 'jigsaw') {
      solved = await showDialog<bool>(
            context: context,
            builder: (_) => const _GlassJigsawDialog(),
          ) ??
          false;
    } else if (gameType == 'window_sort') {
      solved = await showDialog<bool>(
            context: context,
            builder: (_) => const _SortingChallengeDialog(
              title: 'Window & Garden Sorting Game',
              instruction:
                  'Tap each observation to sort it into Staged Inside vs. Real Intruder:',
              items: [
                {
                  'text': 'Zero footprints in wet garden mud',
                  'target': 'Staged Inside'
                },
                {
                  'text': 'Window latch unlatched from interior',
                  'target': 'Staged Inside'
                },
                {
                  'text': 'Muddy boot prints on windowsill',
                  'target': 'Real Intruder'
                },
                {
                  'text': 'Broken glass pushed from outside in',
                  'target': 'Real Intruder'
                },
              ],
              categories: ['Staged Inside', 'Real Intruder'],
            ),
          ) ??
          false;
    } else if (gameType == 'cabinet_sort') {
      solved = await showDialog<bool>(
            context: context,
            builder: (_) => const _SortingChallengeDialog(
              title: 'Cabinet & Suspect Outfit Sorting',
              instruction:
                  'Sort each suspect by what they wore at the dinner:',
              items: [
                {
                  'text': 'Emma Blackwood (Royal Blue Silk)',
                  'target': 'Matches Blue Thread'
                },
                {
                  'text': 'Daniel Reed (Black Butler Suit)',
                  'target': 'No Blue Fabric'
                },
                {
                  'text': 'Leo Martin (Brown Garden Coat)',
                  'target': 'No Blue Fabric'
                },
                {
                  'text': 'Mrs. Rose (Grey Apron)',
                  'target': 'No Blue Fabric'
                },
              ],
              categories: ['Matches Blue Thread', 'No Blue Fabric'],
            ),
          ) ??
          false;
    } else if (gameType == 'study_lock') {
      solved = await showDialog<bool>(
            context: context,
            builder: (_) => const _StudyDrawerLockDialog(),
          ) ??
          false;
    } else if (gameType == 'timeline_order') {
      solved = await showDialog<bool>(
            context: context,
            builder: (_) => const _HallwayTimelineDialog(),
          ) ??
          false;
    } else if (gameType == 'gem_cipher') {
      solved = await showDialog<bool>(
            context: context,
            builder: (_) => const _SapphireCipherDialog(),
          ) ??
          false;
    }

    if (solved && mounted) {
      final xpAwarded = clue['xpReward'] as int;

      await context.read<UserProgressProvider>().awardXp(
            xpAwarded,
            clueId: clue['id'] as String,
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '🎉 Clue Unlocked! +$xpAwarded XP added to your XP Bar!',
          ),
          backgroundColor: Colors.green,
        ),
      );

      _showClueResultSheet(clue);
    }
  }

  void _showClueResultSheet(DynamicMap clue) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                clue['image'] as String,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              clue['title'] as String,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              clue['description'] as String,
              style: const TextStyle(height: 1.5),
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
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

      if (selectedSuspect == 'Emma Blackwood — The Daughter') {
        context.read<UserProgressProvider>().awardXp(
          50,
          mysteryId: 'missing_necklace',
        );

        resultMessage =
            'Case Solved! (+50 XP Bonus)\n\n'
            'Emma Blackwood stole the sapphire necklace to pay her debts. '
            'She used the spare key, broke a crystal glass as a distraction, '
            'staged the open window, and hid a loose sapphire in her handbag!';
      } else {
        resultMessage =
            'Incorrect! That suspect has a verified alibi. Review the 6 clues and try again.';
      }
    });
  }

  void resetInvestigation() {
    context.read<UserProgressProvider>().resetCaseClues('mn_clue_');

    setState(() {
      accusationMade = false;
      selectedSuspect = null;
      resultMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = context.watch<UserProgressProvider>();
    final unlockedList = progress.unlockedClues;
    final userXp = progress.xp;

    final cluesFound =
        clues.where((c) => unlockedList.contains(c['id'])).length;

    final isCorrect =
        selectedSuspect == 'Emma Blackwood — The Daughter';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crime Scene Investigation'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Chip(
                backgroundColor: const Color(0xFFE8E3FF),
                label: Text(
                  '$userXp XP',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/drawing_room_scene.png',
              height: 195,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Evidence Progress: $cluesFound / ${clues.length} Clues',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                'Your XP: $userXp XP',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: cluesFound / clues.length,
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 16),
          ...clues.map((clue) {
            final discovered = unlockedList.contains(clue['id']);
            final reqXp = clue['requiredXp'] as int;
            final hasEnoughXp = discovered || userXp >= reqXp;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              color: discovered
                  ? Colors.white
                  : hasEnoughXp
                      ? const Color(0xFFF2EEFF)
                      : Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                onTap: () =>
                    _launchClueGame(clue, discovered, userXp),
                leading: CircleAvatar(
                  backgroundColor: discovered
                      ? Colors.green.withValues(alpha: 0.15)
                      : hasEnoughXp
                          ? AppTheme.primary.withValues(alpha: 0.15)
                          : Colors.grey.withValues(alpha: 0.2),
                  child: Icon(
                    discovered
                        ? Icons.check_circle
                        : hasEnoughXp
                            ? Icons.extension_rounded
                            : Icons.lock_outline,
                    color: discovered
                        ? Colors.green
                        : hasEnoughXp
                            ? AppTheme.primary
                            : Colors.grey,
                  ),
                ),
                title: Text(
                  clue['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  discovered
                      ? clue['description'] as String
                      : clue['subtitle'] as String,
                ),
                trailing: Icon(
                  discovered
                      ? Icons.visibility
                      : hasEnoughXp
                          ? Icons.play_arrow_rounded
                          : Icons.lock,
                  color: hasEnoughXp
                      ? AppTheme.primary
                      : Colors.grey,
                ),
              ),
            );
          }),
          const SizedBox(height: 18),
          Text(
            'Choose Your Suspect',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...suspects.map((suspect) {
            final isSelected = selectedSuspect == suspect;

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              color: isSelected
                  ? AppTheme.primary.withValues(alpha: 0.10)
                  : null,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: accusationMade
                    ? null
                    : () => setState(
                          () => selectedSuspect = suspect,
                        ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: isSelected
                            ? AppTheme.primary
                            : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          suspect,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: accusationMade ? null : makeAccusation,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Make My Accusation (+50 XP)'),
            ),
          ),
          if (resultMessage != null) ...[
            const SizedBox(height: 18),
            Card(
              color: isCorrect
                  ? Colors.green.withValues(alpha: 0.15)
                  : Colors.red.withValues(alpha: 0.15),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isCorrect
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: isCorrect
                          ? Colors.green
                          : Colors.red,
                      size: 32,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      resultMessage!,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: resetInvestigation,
                icon: const Icon(Icons.refresh),
                label: const Text('Replay Clues'),
              ),
            ),
          ],
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// ============================================================
// MINI-GAME 1: 8-PIECE (4x2) JIGSAW PUZZLE
// ============================================================

class _GlassJigsawDialog extends StatefulWidget {
  const _GlassJigsawDialog();

  @override
  State<_GlassJigsawDialog> createState() =>
      _GlassJigsawDialogState();
}

class _GlassJigsawDialogState extends State<_GlassJigsawDialog> {
  List<int> tiles = [5, 2, 7, 0, 6, 1, 4, 3];
  int? selectedIndex;

  void _tapTile(int index) {
    setState(() {
      if (selectedIndex == null) {
        selectedIndex = index;
      } else {
        final temp = tiles[selectedIndex!];
        tiles[selectedIndex!] = tiles[index];
        tiles[index] = temp;
        selectedIndex = null;
      }
    });
  }

  bool get _isSolved {
    for (int i = 0; i < 8; i++) {
      if (tiles[i] != i) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    const double boardWidth = 280.0;
    const double boardHeight = 158.0;
    const int cols = 4;
    const int rows = 2;
    const double tileW = boardWidth / cols;
    const double tileH = boardHeight / rows;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text('🧩 Broken Glass Jigsaw (8 Pieces)'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Tap two pieces to swap them and restore the single shattered glass photo:',
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: boardWidth,
            height: boardHeight,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                childAspectRatio: tileW / tileH,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              itemCount: 8,
              itemBuilder: (_, idx) {
                final piece = tiles[idx];
                final pieceCol = piece % cols;
                final pieceRow = piece ~/ cols;
                final isSelected = selectedIndex == idx;

                return GestureDetector(
                  onTap: () => _tapTile(idx),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.secondary
                            : Colors.black38,
                        width: isSelected ? 2.5 : 0.8,
                      ),
                    ),
                    child: ClipRect(
                      child: OverflowBox(
                        alignment: Alignment.topLeft,
                        minWidth: boardWidth,
                        maxWidth: boardWidth,
                        minHeight: boardHeight,
                        maxHeight: boardHeight,
                        child: Transform.translate(
                          offset: Offset(
                            -pieceCol * tileW,
                            -pieceRow * tileH,
                          ),
                          child: Image.asset(
                            'assets/images/broken_glass.png',
                            width: boardWidth,
                            height: boardHeight,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isSolved) ...[
            const SizedBox(height: 12),
            const Text(
              '✅ All 8 Pieces Matched! Evidence Restored!',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSolved
              ? () => Navigator.pop(context, true)
              : null,
          child: const Text('Claim +20 XP'),
        ),
      ],
    );
  }
}

// ============================================================
// MINI-GAME 2 & 3: FORENSIC SORTING GAME
// ============================================================

class _SortingChallengeDialog extends StatefulWidget {
  final String title;
  final String instruction;
  final List<StringMap> items;
  final List<String> categories;

  const _SortingChallengeDialog({
    required this.title,
    required this.instruction,
    required this.items,
    required this.categories,
  });

  @override
  State<_SortingChallengeDialog> createState() =>
      _SortingChallengeDialogState();
}

class _SortingChallengeDialogState
    extends State<_SortingChallengeDialog> {
  final Map<int, String> _choices = {};

  bool get _allCorrect {
    if (_choices.length < widget.items.length) return false;

    for (int i = 0; i < widget.items.length; i++) {
      if (_choices[i] != widget.items[i]['target']) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        widget.title,
        style: const TextStyle(fontSize: 17),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.instruction,
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            ...List.generate(widget.items.length, (idx) {
              final item = widget.items[idx];

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F4FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['text']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      children: widget.categories.map((cat) {
                        final selected = _choices[idx] == cat;

                        return ChoiceChip(
                          label: Text(
                            cat,
                            style: const TextStyle(fontSize: 11),
                          ),
                          selected: selected,
                          onSelected: (_) =>
                              setState(() => _choices[idx] = cat),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _allCorrect
              ? () => Navigator.pop(context, true)
              : null,
          child: const Text('Verify & Claim +20 XP'),
        ),
      ],
    );
  }
}

// ============================================================
// MINI-GAME 4: 3-DIGIT STUDY DRAWER LOCK DIAL
// ============================================================

class _StudyDrawerLockDialog extends StatefulWidget {
  const _StudyDrawerLockDialog();

  @override
  State<_StudyDrawerLockDialog> createState() => _StudyDrawerLockDialogState();
}

class _StudyDrawerLockDialogState extends State<_StudyDrawerLockDialog> {
  final List<int> _digits = [0, 0, 0];
  final List<int> _solution = [7, 3, 0];
  bool _checked = false;

  bool get _isCorrect =>
      _digits[0] == _solution[0] &&
      _digits[1] == _solution[1] &&
      _digits[2] == _solution[2];

  void _changeDigit(int index, int delta) {
    setState(() {
      _digits[index] = (_digits[index] + delta + 10) % 10;
      _checked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('🔐 Study Drawer Lock'),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Image.asset('assets/images/study_key_drawer.png', height: 130,
              width: double.infinity, fit: BoxFit.cover),
          const SizedBox(height: 10),
          const Text(
              'Mrs. Rose\'s inspection note: “Study checked at 7:30 PM.”\n\nSet the 3-digit dial to unlock the spare-key drawer.',
              textAlign: TextAlign.center),
          const SizedBox(height: 14),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) =>
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: const Color(0xFFEDE7F6),
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(children: [
                    IconButton(
                        onPressed: () => _changeDigit(i, 1),
                        icon: const Icon(Icons.keyboard_arrow_up),
                        iconSize: 30),
                    Text('${_digits[i]}',
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    IconButton(
                        onPressed: () => _changeDigit(i, -1),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        iconSize: 30),
                  ]),
                ),
              )),
          if (_checked) ...[
            const SizedBox(height: 10),
            Text(
                _isCorrect
                    ? '✅ Drawer unlocked! The code is 7–3–0.'
                    : '❌ The lock did not open. Recheck the inspection note.',
                style: TextStyle(
                    color: _isCorrect ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
          ],
        ]),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel')),
        if (!_isCorrect || !_checked)
          ElevatedButton(
              onPressed: () => setState(() => _checked = true),
              child: const Text('Test Lock'))
        else
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Claim +25 XP')),
      ],
    );
  }
}

// ============================================================
// MINI-GAME 5: FOUR-STEP CHRONOLOGICAL TIMELINE
// ============================================================

class _HallwayTimelineDialog extends StatefulWidget {
  const _HallwayTimelineDialog();

  @override
  State<_HallwayTimelineDialog> createState() => _HallwayTimelineDialogState();
}

class _HallwayTimelineDialogState extends State<_HallwayTimelineDialog> {
  final List<String> _events = [
    '7:30 PM — Mrs. Rose inspected and cleaned the cabinet handle.',
    '8:00 PM — Dinner was underway; Emma was seen at the dining table.',
    '8:55 PM — Sophia saw Emma slip past the hallway clock.',
    '9:00 PM — The missing necklace was discovered.',
  ];
  final List<String> _correctOrder = [
    '7:30 PM — Mrs. Rose inspected and cleaned the cabinet handle.',
    '8:00 PM — Dinner was underway; Emma was seen at the dining table.',
    '8:55 PM — Sophia saw Emma slip past the hallway clock.',
    '9:00 PM — The missing necklace was discovered.',
  ];
  final List<String> _remaining = [];
  final List<String> _selected = [];
  bool _wrong = false;

  @override
  void initState() {
    super.initState();
    _remaining.addAll(_events);
    _remaining.shuffle();
  }

  bool get _complete => _selected.length == 4;
  bool get _correct =>
      _complete &&
      List.generate(4, (i) => _selected[i] == _correctOrder[i])
          .every((v) => v);

  void _tapEvent(String event) {
    if (_selected.length >= 4) return;
    setState(() {
      _selected.add(event);
      _remaining.remove(event);
      _wrong = false;
    });
  }

  void _undo() {
    if (_selected.isEmpty) return;
    setState(() {
      _remaining.add(_selected.removeLast());
      _wrong = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('🕰️ Rebuild the Hallway Timeline'),
      content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Image.asset('assets/images/hallway_clock_855.png',
            height: 125, width: double.infinity, fit: BoxFit.cover),
        const SizedBox(height: 8),
        const Text(
            'Tap the events in chronological order, from 7:30 PM to 9:00 PM.',
            textAlign: TextAlign.center),
        const SizedBox(height: 12),
        Align(
            alignment: Alignment.centerLeft,
            child: Text('Your timeline (${_selected.length}/4)',
                style: const TextStyle(fontWeight: FontWeight.bold))),
        const SizedBox(height: 6),
        ...List.generate(
            _selected.length,
            (i) => Card(
                color: const Color(0xFFEDE7F6),
                child: ListTile(
                    dense: true,
                    leading: CircleAvatar(child: Text('${i + 1}')),
                    title: Text(_selected[i],
                        style: const TextStyle(fontSize: 12))))),
        const SizedBox(height: 8),
        Align(
            alignment: Alignment.centerLeft,
            child: Text('Events to place',
                style: const TextStyle(fontWeight: FontWeight.bold))),
        ..._remaining.map((event) => Card(
            child: ListTile(
                dense: true,
                leading: const Icon(Icons.touch_app),
                title: Text(event, style: const TextStyle(fontSize: 12)),
                onTap: () => _tapEvent(event)))),
        if (_wrong)
          const Text(
              'That order is not correct. Review the times and try again.',
              style: TextStyle(color: Colors.red)),
        if (_correct)
          const Text('✅ Timeline reconstructed correctly!',
              style: TextStyle(
                  color: Colors.green, fontWeight: FontWeight.bold)),
      ])),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel')),
        TextButton(
            onPressed: _selected.isEmpty ? null : _undo,
            child: const Text('Undo')),
        ElevatedButton(
            onPressed: !_complete
                ? null
                : () {
                    if (_correct) {
                      Navigator.pop(context, true);
                    } else {
                      setState(() => _wrong = true);
                    }
                  },
            child: const Text('Verify & Claim +25 XP')),
      ],
    );
  }
}

// ============================================================
// MINI-GAME 6: SAPPHIRE LETTER-TILE CIPHER
// ============================================================

class _SapphireCipherDialog extends StatefulWidget {
  const _SapphireCipherDialog();

  @override
  State<_SapphireCipherDialog> createState() => _SapphireCipherDialogState();
}

class _SapphireCipherDialogState extends State<_SapphireCipherDialog> {
  final List<String> _tiles = ['P', 'A', 'H', 'S', 'R', 'P', 'I', 'E'];
  final String _answer = 'SAPPHIRE';
  final List<String> _chosen = [];
  bool _checked = false;

  bool get _correct => _chosen.join() == _answer;

  void _tapTile(int index) {
    if (_chosen.length == 8) return;
    setState(() {
      _chosen.add(_tiles[index]);
      _tiles.removeAt(index);
      _checked = false;
    });
  }

  void _removeLast() {
    if (_chosen.isEmpty) return;
    setState(() {
      _tiles.add(_chosen.removeLast());
      _checked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('💎 Handbag Letter Cipher'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/vault_padlock_cipher.png',
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Image.asset(
              'assets/images/handbag_sapphire.png',
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            const Text(
              'Arrange the letter tiles to reveal the gemstone hidden in Emma\'s handbag.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE7F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _chosen.isEmpty ? 'Tap letters to build the word' : _chosen.join('  '),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: List.generate(
                _tiles.length,
                (i) => ElevatedButton(
                  onPressed: () => _tapTile(i),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(42, 44),
                    padding: const EdgeInsets.all(8),
                  ),
                  child: Text(
                    _tiles[i],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            if (_checked)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _correct ? '✅ Cipher solved: SAPPHIRE!' : '❌ Not quite. Rearrange the tiles and try again.',
                  style: TextStyle(
                    color: _correct ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _chosen.isEmpty ? null : _removeLast,
          child: const Text('Undo'),
        ),
        ElevatedButton(
          onPressed: _chosen.length != 8 ? null : () => setState(() => _checked = true),
          child: const Text('Check Cipher'),
        ),
        if (_checked && _correct)
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Claim +25 XP'),
          ),
      ],
    );
  }
}