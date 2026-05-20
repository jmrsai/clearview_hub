import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title Screen Coming Soon!')),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Splash');
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Onboarding');
}

class VisionTestsScreen extends StatelessWidget {
  const VisionTestsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Vision Tests');
}

class SymptomCheckerScreen extends StatelessWidget {
  const SymptomCheckerScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Symptom Checker');
}

class MedicationRemindersScreen extends StatelessWidget {
  const MedicationRemindersScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Medication Reminders');
}

class TherapyScreen extends StatelessWidget {
  const TherapyScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Therapy & Rehab');
}

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Eye Health Games');
}

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Education Hub');
}

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Community Platform');
}

class TelemedicineScreen extends StatelessWidget {
  const TelemedicineScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Tele-Optometry');
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Profile & Eye Twin');
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Settings');
}

class AccessibilitySettingsScreen extends StatelessWidget {
  const AccessibilitySettingsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Accessibility Settings');
}

class EmergencySupportScreen extends StatelessWidget {
  const EmergencySupportScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Emergency Support');
}

// Shell Scaffolds
class MainScaffold extends StatelessWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location == '/') return 0;
    if (location.startsWith('/vision_lab')) return 1;
    if (location.startsWith('/community')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/vision_lab');
        break;
      case 2:
        context.go('/community');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        backgroundColor: const Color(0xFF0A0E1A),
        indicatorColor: Colors.cyan.withValues(alpha: 0.2),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Colors.white54),
            selectedIcon: Icon(Icons.home, color: Colors.cyan),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.remove_red_eye_outlined, color: Colors.white54),
            selectedIcon: Icon(Icons.remove_red_eye, color: Colors.cyan),
            label: 'Labs',
          ),
          NavigationDestination(
            icon: Icon(Icons.group_outlined, color: Colors.white54),
            selectedIcon: Icon(Icons.group, color: Colors.cyan),
            label: 'Social',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: Colors.white54),
            selectedIcon: Icon(Icons.person, color: Colors.cyan),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
