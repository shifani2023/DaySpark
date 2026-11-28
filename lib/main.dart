import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/user_progress_provider.dart';
import 'utils/app_theme.dart';
import 'views/screens/activities_screen.dart';
import 'views/screens/auth_screen.dart';
import 'views/screens/journal_screen.dart';
import 'views/screens/mystery_library_screen.dart';
import 'views/screens/mystery_story_screen.dart';
import 'widgets/xp_progress_banner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProgressProvider(),
      child: const DaySparkApp(),
    ),
  );
}

class DaySparkApp extends StatelessWidget {
  const DaySparkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DaySpark',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // Listen for Firebase authentication changes.
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Show loading screen while Firebase checks authentication.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // If a user is signed in, reload their progress.
          if (snapshot.hasData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<UserProgressProvider>().loadProgress();
            });

            return const DaySparkHomePage();
          }

          // If nobody is signed in, show the authentication screen.
          return const AuthScreen();
        },
      ),
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

  void _switchTab(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeDashboard(onNavigateTab: _switchTab),
      const MysteryLibraryScreen(),
      const ActivitiesScreen(),
      const JournalScreen(),
    ];

    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: _switchTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded),
            label: 'Mysteries',
          ),
          NavigationDestination(
            icon: Icon(Icons.extension_outlined),
            selectedIcon: Icon(Icons.extension_rounded),
            label: 'Puzzles',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book_rounded),
            label: 'Casebook',
          ),
        ],
      ),
    );
  }
}

class HomeDashboard extends StatelessWidget {
  final ValueChanged<int> onNavigateTab;

  const HomeDashboard({
    super.key,
    required this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<UserProgressProvider>();
    final displayName = progress.userName;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, $displayName 👋',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Solve clues & puzzles to level up!',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),

                // Sign out button
                IconButton(
                  tooltip: 'Sign out',
                  onPressed: () async {
                    // Clear the currently loaded user's progress.
                    context.read<UserProgressProvider>().clearInMemory();

                    // Sign out from Firebase.
                    await FirebaseAuth.instance.signOut();
                  },
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            XpProgressBanner(
              xp: progress.xp,
              userName: displayName,
            ),

            const SizedBox(height: 24),

            const Text(
              'Mystery of the Day',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText,
              ),
            ),

            const SizedBox(height: 12),

            InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MysteryStoryScreen(),
                ),
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF292345),
                      Color(0xFF51418C),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      child: Image.asset(
                        'assets/images/mansion_exterior.png',
                        height: 130,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🔍 FEATURED MYSTERY • EARN UP TO 190 XP',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.secondary,
                            ),
                          ),

                          SizedBox(height: 8),

                          Text(
                            'The Missing Necklace',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          SizedBox(height: 6),

                          Text(
                            'Inspect the drawing room scene, unlock 6 evidence clues, and unmask the thief.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Explore Your Day',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _QuickNavCard(
                    title: 'Daily Puzzles',
                    subtitle: 'Earn +20 to +35 XP',
                    icon: Icons.extension_rounded,
                    color: const Color(0xFFE8E3FF),
                    iconColor: AppTheme.primary,
                    onTap: () => onNavigateTab(2),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _QuickNavCard(
                    title: 'Casebook Notes',
                    subtitle: 'Offline + Cloud Sync',
                    icon: Icons.book_rounded,
                    color: const Color(0xFFDDF7EE),
                    iconColor: AppTheme.teal,
                    onTap: () => onNavigateTab(3),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickNavCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const _QuickNavCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}