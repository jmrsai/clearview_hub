enum AvatarMood { happy, tired, warning, focused }

class DynamicAvatarService {
  /// Generates a DiceBear avatar URL based on seed and mood
  /// We use the 'avataaars' style for a modern medical app look
  String getAvatarUrl({
    required String seed,
    AvatarMood mood = AvatarMood.happy,
  }) {
    String moodParams = '';

    switch (mood) {
      case AvatarMood.happy:
        moodParams = '&eyes=happy&mouth=smile';
        break;
      case AvatarMood.tired:
        moodParams = '&eyes=squint&mouth=serious';
        break;
      case AvatarMood.warning:
        moodParams = '&eyes=surprised&mouth=concerned';
        break;
      case AvatarMood.focused:
        moodParams = '&eyes=eyeRoll&mouth=serious';
        break;
    }

    return 'https://api.dicebear.com/7.x/avataaars/svg?seed=$seed$moodParams';
  }

  /// AI Assistant (Health Coach) specialized avatar
  String getAssistantAvatar(AvatarMood mood) {
    return getAvatarUrl(seed: 'EyeVerseAI', mood: mood);
  }
}
