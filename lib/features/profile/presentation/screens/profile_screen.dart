import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/glass_card.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/profile/settings'),
          ),
        ],
      ),
      body: userState.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Not logged in'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildProfileHeader(user.name ?? 'User', user.email),
                const SizedBox(height: 24),
                _buildMenuSection(
                  title: 'Preferences',
                  items: [
                    _MenuItem(
                      icon: Icons.accessibility_new,
                      title: 'Accessibility & Vision',
                      subtitle: 'Dyslexia mode, text size, contrast',
                      onTap: () => context.go('/profile/accessibility'),
                    ),
                    _MenuItem(
                      icon: Icons.notifications_active,
                      title: 'Notifications',
                      subtitle: 'Medication reminders, screen limits',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildMenuSection(
                  title: 'Medical Hub',
                  items: [
                    _MenuItem(
                      icon: Icons.history,
                      title: 'Medical History',
                      subtitle: 'Eye tests and prescriptions',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.local_hospital,
                      title: 'My Consultations',
                      subtitle: 'Upcoming and past appointments',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(authRepositoryProvider).signOut();
                    context.go('/login');
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign Out'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.withOpacity(0.2),
                    foregroundColor: Colors.redAccent,
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildProfileHeader(String name, String email) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.secondary,
            child: Icon(Icons.person, size: 40, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('Premium Member', style: TextStyle(color: Colors.green, fontSize: 10)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection({required String title, required List<_MenuItem> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
          ),
        ),
        GlassCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: items.map((item) {
              final isLast = items.last == item;
              return Column(
                children: [
                  ListTile(
                    leading: Icon(item.icon, color: AppColors.secondary),
                    title: Text(item.title, style: const TextStyle(color: Colors.white)),
                    subtitle: Text(item.subtitle, style: const TextStyle(color: AppColors.textDisabled, fontSize: 12)),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.textDisabled),
                    onTap: item.onTap,
                  ),
                  if (!isLast) const Divider(height: 1, color: Colors.white10, indent: 56),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
