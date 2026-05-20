import 'package:flutter_riverpod/flutter_riverpod.dart';

class WellnessGroup {
  final String id;
  final String name;
  final String description;
  final GroupType type;
  final int memberCount;
  final bool isPrivate;

  WellnessGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.memberCount,
    required this.isPrivate,
  });
}

enum GroupType { familyCircle, studyCommunity, seniorSupport, detoxChallenge }

/// Facebook-style Groups and Communities
class WellnessGroupService {
  List<WellnessGroup> getRecommendedGroups() {
    return [
      WellnessGroup(
        id: 'g_1',
        name: 'Students Focus Masters',
        description: 'Pomodoro sessions and digital detox tips for students.',
        type: GroupType.studyCommunity,
        memberCount: 5400,
        isPrivate: false,
      ),
      WellnessGroup(
        id: 'g_2',
        name: 'Family Screen Time Support',
        description: 'Parents managing healthy screen habits for kids.',
        type: GroupType.familyCircle,
        memberCount: 1200,
        isPrivate: true,
      ),
      WellnessGroup(
        id: 'g_3',
        name: 'Senior Eye Care',
        description: 'Support for glaucoma and cataracts management.',
        type: GroupType.seniorSupport,
        memberCount: 850,
        isPrivate: false,
      ),
    ];
  }

  void joinGroup(String groupId) {
    // API Call to join
  }
}

final wellnessGroupProvider = Provider((ref) => WellnessGroupService());
