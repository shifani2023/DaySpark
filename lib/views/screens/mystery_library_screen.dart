import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class MysteryLibraryScreen extends StatefulWidget {
  const MysteryLibraryScreen({super.key});

  @override
  State<MysteryLibraryScreen> createState() => _MysteryLibraryScreenState();
}

class _MysteryLibraryScreenState extends State<MysteryLibraryScreen> {
  final TextEditingController searchController = TextEditingController();

  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Easy',
    'Medium',
    'Hard',
  ];

  final List<MysteryItem> mysteries = [
    MysteryItem(
      title: 'The Missing Necklace',
      description:
          'A valuable necklace disappeared during a family dinner. '
          'Investigate the guests and discover who took it.',
      difficulty: 'Easy',
      duration: '10 min',
      icon: Icons.diamond_rounded,
      color: const Color(0xFFFFE7B8),
      iconColor: const Color(0xFFB87913),
      clues: 5,
      isLocked: false,
    ),

    MysteryItem(
      title: 'The Locked Room',
      description:
          'A mysterious incident happened inside a locked room. '
          'Nothing is as simple as it seems.',
      difficulty: 'Medium',
      duration: '15 min',
      icon: Icons.lock_outline_rounded,
      color: const Color(0xFFE5E0FF),
      iconColor: AppTheme.primary,
      clues: 7,
      isLocked: false,
    ),

    MysteryItem(
      title: 'The Secret of Room 13',
      description:
          'A strange hotel room holds a secret. Follow the clues '
          'carefully to uncover the truth.',
      difficulty: 'Hard',
      duration: '20 min',
      icon: Icons.hotel_rounded,
      color: const Color(0xFFDDF5EC),
      iconColor: AppTheme.teal,
      clues: 8,
      isLocked: false,
    ),

    MysteryItem(
      title: 'The Vanishing Painting',
      description:
          'A famous painting disappeared from an art gallery. '
          'Can you identify the thief?',
      difficulty: 'Medium',
      duration: '15 min',
      icon: Icons.image_search_rounded,
      color: const Color(0xFFFFE2E8),
      iconColor: const Color(0xFFE45A80),
      clues: 6,
      isLocked: true,
    ),
  ];

  List<MysteryItem> get filteredMysteries {
    return mysteries.where((mystery) {
      final matchesSearch = mystery.title
              .toLowerCase()
              .contains(searchController.text.toLowerCase()) ||
          mystery.description
              .toLowerCase()
              .contains(searchController.text.toLowerCase());

      final matchesCategory = selectedCategory == 'All' ||
          mystery.difficulty == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // HEADER
              const Text(
                'Discover Mysteries 🔍',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkText,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Choose a case and put your detective skills to the test.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.secondaryText,
                ),
              ),

              const SizedBox(height: 25),

              // SEARCH BAR
              TextField(
                controller: searchController,

                onChanged: (value) {
                  setState(() {});
                },

                decoration: InputDecoration(
                  hintText: 'Search mysteries...',
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppTheme.primary,
                  ),

                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: Color(0xFFEDE9FF),
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: AppTheme.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // FILTERS
              SizedBox(
                height: 42,

                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,

                  itemBuilder: (context, index) {
                    final category = categories[index];

                    final isSelected =
                        selectedCategory == category;

                    return Padding(
                      padding: const EdgeInsets.only(right: 10),

                      child: ChoiceChip(
                        label: Text(category),

                        selected: isSelected,

                        onSelected: (selected) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },

                        selectedColor: AppTheme.primary,

                        backgroundColor: Colors.white,

                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppTheme.secondaryText,

                          fontWeight: FontWeight.w600,
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),

                        side: BorderSide(
                          color: isSelected
                              ? AppTheme.primary
                              : const Color(0xFFEDE9FF),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 25),

              // LIBRARY HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  const Text(
                    'Mystery Library',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkText,
                    ),
                  ),

                  Text(
                    '${filteredMysteries.length} cases',
                    style: const TextStyle(
                      color: AppTheme.secondaryText,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // MYSTERY LIST
              if (filteredMysteries.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),

                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 55,
                          color: AppTheme.secondaryText,
                        ),

                        SizedBox(height: 12),

                        Text(
                          'No mysteries found',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkText,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          'Try another search or category.',
                          style: TextStyle(
                            color: AppTheme.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ...filteredMysteries.map(
                (mystery) => MysteryLibraryCard(
                  mystery: mystery,
                  onTap: () {
                    showMysteryDetails(context, mystery);
                  },
                ),
              ),

              const SizedBox(height: 25),

              // FOOTER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: const Color(0xFFE9E4FF),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: const Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      color: AppTheme.primary,
                      size: 28,
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        'Tip: Pay attention to every detail. '
                        'Some clues may be hidden in ordinary things!',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.darkText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// MYSTERY DATA MODEL
// ============================================================

class MysteryItem {
  final String title;
  final String description;
  final String difficulty;
  final String duration;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final int clues;
  final bool isLocked;

  MysteryItem({
    required this.title,
    required this.description,
    required this.difficulty,
    required this.duration,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.clues,
    required this.isLocked,
  });
}

// ============================================================
// MYSTERY CARD
// ============================================================

class MysteryLibraryCard extends StatelessWidget {
  final MysteryItem mystery;
  final VoidCallback onTap;

  const MysteryLibraryCard({
    super.key,
    required this.mystery,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(22),

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Row(
            children: [

              // MYSTERY ICON
              Container(
                width: 70,
                height: 85,

                decoration: BoxDecoration(
                  color: mystery.color,
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Icon(
                  mystery.isLocked
                      ? Icons.lock_rounded
                      : mystery.icon,

                  color: mystery.iconColor,
                  size: 35,
                ),
              ),

              const SizedBox(width: 15),

              // DETAILS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Text(
                      mystery.title,

                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkText,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      mystery.description,

                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.secondaryText,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 12,

                      children: [
                        MysteryInfo(
                          icon: Icons.timer_outlined,
                          text: mystery.duration,
                        ),

                        MysteryInfo(
                          icon: Icons.search_rounded,
                          text: '${mystery.clues} clues',
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    DifficultyBadge(
                      difficulty: mystery.difficulty,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 5),

              Icon(
                mystery.isLocked
                    ? Icons.lock_outline_rounded
                    : Icons.arrow_forward_ios_rounded,

                size: 17,
                color: AppTheme.secondaryText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// MYSTERY INFORMATION
// ============================================================

class MysteryInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const MysteryInfo({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,

      children: [
        Icon(
          icon,
          size: 14,
          color: AppTheme.secondaryText,
        ),

        const SizedBox(width: 4),

        Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.secondaryText,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// DIFFICULTY BADGE
// ============================================================

class DifficultyBadge extends StatelessWidget {
  final String difficulty;

  const DifficultyBadge({
    super.key,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (difficulty) {
      case 'Easy':
        backgroundColor = const Color(0xFFDDF5EC);
        textColor = const Color(0xFF18876B);
        break;

      case 'Medium':
        backgroundColor = const Color(0xFFFFE9D2);
        textColor = const Color(0xFFB76A00);
        break;

      case 'Hard':
        backgroundColor = const Color(0xFFFFE1E7);
        textColor = const Color(0xFFD34770);
        break;

      default:
        backgroundColor = Colors.grey.shade200;
        textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 4,
      ),

      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        difficulty,

        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ============================================================
// MYSTERY DETAILS DIALOG
// ============================================================

void showMysteryDetails(
  BuildContext context,
  MysteryItem mystery,
) {
  showDialog(
    context: context,

    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),

        title: Text(mystery.title),

        content: Column(
          mainAxisSize: MainAxisSize.min,

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(mystery.description),

            const SizedBox(height: 20),

            Row(
              children: [
                const Icon(
                  Icons.timer_outlined,
                  color: AppTheme.primary,
                ),

                const SizedBox(width: 8),

                Text(mystery.duration),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  color: AppTheme.primary,
                ),

                const SizedBox(width: 8),

                Text('${mystery.clues} clues'),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(
                  Icons.signal_cellular_alt,
                  color: AppTheme.primary,
                ),

                const SizedBox(width: 8),

                Text('${mystery.difficulty} difficulty'),
              ],
            ),
          ],
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },

            child: const Text('Close'),
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    mystery.isLocked
                        ? 'This mystery is currently locked.'
                        : 'Investigation screen will be added next!',
                  ),
                ),
              );
            },

            child: Text(
              mystery.isLocked
                  ? 'Locked'
                  : 'Start Mystery',
            ),
          ),
        ],
      );
    },
  );
}