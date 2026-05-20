import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/wellness_group_service.dart';

class WellnessGroupDiscoveryScreen extends ConsumerWidget {
  const WellnessGroupDiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupService = ref.watch(wellnessGroupProvider);
    final groups = groupService.getRecommendedGroups();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wellness Groups'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.group_add_outlined),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Communities',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF16213E),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.blueAccent,
                          child: Icon(Icons.group, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Group $index',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Recommended for You',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return _buildGroupCard(group);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupCard(WellnessGroup group) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFF16213E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blueAccent.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            child: const Icon(
              Icons.groups_3,
              size: 50,
              color: Colors.blueAccent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      group.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (group.isPrivate)
                      const Icon(
                        Icons.lock_outline,
                        size: 16,
                        color: Colors.white54,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${group.memberCount} members • ${_getGroupTypeLabel(group.type)}',
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  group.description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Join Group'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getGroupTypeLabel(GroupType type) {
    switch (type) {
      case GroupType.familyCircle:
        return 'Family';
      case GroupType.studyCommunity:
        return 'Study';
      case GroupType.seniorSupport:
        return 'Senior';
      case GroupType.detoxChallenge:
        return 'Detox';
    }
    return 'Community';
  }
}
