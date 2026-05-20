import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'glass_card.dart';

class AiAssistantWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onTap;
  final bool isListening;

  const AiAssistantWidget({
    super.key,
    required this.message,
    this.onTap,
    this.isListening = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        borderRadius: BorderRadius.circular(40),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (isListening)
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: Lottie.asset(
                      'assets/lottie/ai_waves.json', // Placeholder for listening animation
                      errorBuilder: (context, error, stackTrace) =>
                          CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.cyan.shade300,
                          ),
                    ),
                  ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.cyan.shade700,
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
