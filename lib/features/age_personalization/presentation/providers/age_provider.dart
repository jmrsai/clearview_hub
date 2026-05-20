import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clearview_hub/features/age_personalization/domain/models/age_profile.dart';

class AgeProfileNotifier extends StateNotifier<AgeProfile> {
  AgeProfileNotifier() : super(AgeProfile.forGroup(AgeGroup.adult));

  void setAgeGroup(AgeGroup group) {
    state = AgeProfile.forGroup(group);
  }
}

final ageProfileProvider =
    StateNotifierProvider<AgeProfileNotifier, AgeProfile>((ref) {
      return AgeProfileNotifier();
    });
