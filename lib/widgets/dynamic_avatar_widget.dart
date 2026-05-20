import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/assets/dynamic_avatar_service.dart';

class DynamicAvatarWidget extends StatelessWidget {
  final String seed;
  final AvatarMood mood;
  final double size;

  const DynamicAvatarWidget({
    super.key,
    required this.seed,
    this.mood = AvatarMood.happy,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    final avatarUrl = DynamicAvatarService().getAvatarUrl(
      seed: seed,
      mood: mood,
    );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white24, width: 2),
      ),
      child: ClipOval(
        child: SvgPicture.network(
          avatarUrl,
          width: size,
          height: size,
          placeholderBuilder: (context) => Container(
            color: Colors.white10,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      ),
    );
  }
}
