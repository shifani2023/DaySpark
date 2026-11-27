import 'package:flutter/material.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const DaySparkApp());
}

class DaySparkApp extends StatelessWidget {
  const DaySparkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DaySpark',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const DaySparkHomePage(),
    );
  }
}

class DaySparkHomePage extends StatefulWidget {
  const DaySparkHomePage({super.key});

  @override
  State<DaySparkHomePage> createState() => _DaySparkHomePageState();
}

class _DaySparkHomePageState extends State<DaySparkHomePage> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomeDashboard(),
    DiscoverPage(),
    ActivitiesPage(),
    JournalPage(),
  ];

  final List<String> pageTitles = [
    'Home',
    'Discover',
    'Activities',
    'Journal',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded),
            label: 'Discover',
          ),
          NavigationDestination(
            icon: Icon(Icons.extension_outlined),
            selectedIcon: Icon(Icons.extension_rounded),
            label: 'Activities',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book_rounded),
            label: 'Journal',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HOME DASHBOARD
// ============================================================

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // TOP HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hello, Explorer 👋',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkText,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Ready to make today exciting?',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFEDE9FF),
                    ),
                  ),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: AppTheme.primary,
                    size: 25,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // XP CARD
            const XPCard(),

            const SizedBox(height: 25),

            // DAILY CHALLENGE TITLE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SectionTitle(
                  title: 'Daily Spark',
                  subtitle: 'A little challenge for today',
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0D8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '✨ Daily',
                    style: TextStyle(
                      color: Color(0xFFB76A00),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            const DailyChallengeCard(),

            const SizedBox(height: 25),

            // MYSTERY SECTION
            const SectionTitle(
              title: 'Mystery of the Day',
              subtitle: 'Can you solve the case?',
            ),

            const SizedBox(height: 14),

            const MysteryCard(),

            const SizedBox(height: 25),

            // QUICK ACTIVITIES
            const SectionTitle(
              title: 'Explore Your Day',
              subtitle: 'Choose something fun to do',
            ),

            const SizedBox(height: 14),

            const QuickActivitiesGrid(),

            const SizedBox(height: 25),

            // SURPRISE ME BUTTON
            SurpriseMeCard(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// SECTION TITLE
// ============================================================

class SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionTitle({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkText,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 13,
            color: AppTheme.secondaryText,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// XP CARD
// ============================================================

class XPCard extends StatelessWidget {
  const XPCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppTheme.primary,
            Color(0xFF9B88FF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Adventure Progress',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '⭐ Level 1',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '120',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Padding(
                padding: EdgeInsets.only(bottom: 7),
                child: Text(
                  'XP earned',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: 0.40,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppTheme.secondary,
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            '180 XP more to reach Level 2!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DAILY CHALLENGE CARD
// ============================================================

class DailyChallengeCard extends StatelessWidget {
  const DailyChallengeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0D8),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [

          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD58B),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.palette_rounded,
              color: Color(0xFFB76A00),
              size: 30,
            ),
          ),

          const SizedBox(width: 15),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Creative Moment',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.darkText,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Draw something around you in 5 minutes!',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.secondaryText,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  '+20 XP',
                  style: TextStyle(
                    color: Color(0xFFB76A00),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: Color(0xFFB76A00),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// MYSTERY CARD
// ============================================================

class MysteryCard extends StatelessWidget {
  const MysteryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF292345),
            Color(0xFF51418C),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [

          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.search_rounded,
              size: 150,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '🔍 FEATURED MYSTERY',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF493000),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  'The Missing Necklace',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'A valuable necklace disappeared during a family dinner. Can you discover who took it?',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),

                const Spacer(),

                Row(
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      color: Colors.white70,
                      size: 16,
                    ),

                    const SizedBox(width: 5),

                    const Text(
                      '10 minutes',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(width: 15),

                    const Icon(
                      Icons.signal_cellular_alt,
                      color: Colors.white70,
                      size: 16,
                    ),

                    const SizedBox(width: 5),

                    const Text(
                      'Easy',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),

                    const Spacer(),

                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppTheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
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
  }
}

// ============================================================
// QUICK ACTIVITIES GRID
// ============================================================

class QuickActivitiesGrid extends StatelessWidget {
  const QuickActivitiesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      ActivityItem(
        title: 'Puzzles',
        subtitle: 'Train your brain',
        icon: Icons.extension_rounded,
        color: const Color(0xFFE8E3FF),
        iconColor: AppTheme.primary,
      ),

      ActivityItem(
        title: 'Creative',
        subtitle: 'Make something',
        icon: Icons.palette_rounded,
        color: const Color(0xFFFFE9D2),
        iconColor: const Color(0xFFE38A21),
      ),

      ActivityItem(
        title: 'Mindful',
        subtitle: 'Relax and reset',
        icon: Icons.spa_rounded,
        color: const Color(0xFFDDF7EE),
        iconColor: AppTheme.teal,
      ),

      ActivityItem(
        title: 'Explore',
        subtitle: 'Try something new',
        icon: Icons.explore_rounded,
        color: const Color(0xFFFFE1E7),
        iconColor: const Color(0xFFE45A80),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.45,
      ),
      itemBuilder: (context, index) {
        return activities[index];
      },
    );
  }
}

class ActivityItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color iconColor;

  const ActivityItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 21,
            ),
          ),

          const Spacer(),

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppTheme.darkText,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SURPRISE ME CARD
// ============================================================

class SurpriseMeCard extends StatelessWidget {
  SurpriseMeCard({super.key});

  final List<String> surpriseActivities = [
    'Try drawing with your non-dominant hand!',
    'Find 5 things around you that are blue.',
    'Write a short story using 3 random words.',
    'Do a 5-minute stretching session.',
    'Solve a riddle!',
    'Listen to a song you have never heard before.',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE4F7F1),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [

          const Icon(
            Icons.casino_rounded,
            color: AppTheme.teal,
            size: 35,
          ),

          const SizedBox(width: 15),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Feeling bored?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.darkText,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  'Let DaySpark surprise you!',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.secondaryText,
                  ),
                ),
              ],
            ),
          ),

          ElevatedButton(
            onPressed: () {
              final randomIndex =
                  DateTime.now().millisecond % surpriseActivities.length;

              final activity = surpriseActivities[randomIndex];

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('✨ Your Surprise!'),
                    content: Text(activity),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Awesome!'),
                      ),
                    ],
                  );
                },
              );
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.teal,
              foregroundColor: Colors.white,
            ),

            child: const Text('Try'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// TEMPORARY NAVIGATION PAGES
// We will replace these with real screens later.
// ============================================================

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      icon: Icons.explore_rounded,
      title: 'Discover',
      description: 'Discover mysteries, stories and new experiences.',
    );
  }
}

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      icon: Icons.extension_rounded,
      title: 'Activities',
      description: 'Puzzles, games and fun lifestyle challenges.',
    );
  }
}

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      icon: Icons.book_rounded,
      title: 'My Journal',
      description: 'Your personal space for thoughts and memories.',
    );
  }
}

class SimplePage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const SimplePage({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9E4FF),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  icon,
                  size: 60,
                  color: AppTheme.primary,
                ),
              ),

              const SizedBox(height: 25),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkText,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppTheme.secondaryText,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                '🚧 We will build this screen next!',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}