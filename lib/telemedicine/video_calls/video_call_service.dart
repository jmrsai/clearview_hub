import 'package:flutter/foundation.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';

class VideoCallService {
  /// Start a secure telemedicine consultation
  Future<void> joinConsultation({
    required String roomName,
    required String subject,
    required String userDisplayName,
    required String userEmail,
    String? userAvatarUrl,
    bool isAudioMuted = true,
    bool isVideoMuted = true,
  }) async {
    try {
      var options = JitsiMeetingOptions(
        roomNameOrUrl: roomName,
        serverUrl:
            'https://meet.jit.si', // In production, this would be a secure, HIPAA-compliant self-hosted Jitsi instance
        subject: subject,
        isAudioMuted: isAudioMuted,
        isVideoMuted: isVideoMuted,
        userDisplayName: userDisplayName,
        userEmail: userEmail,
        userAvatarUrl: userAvatarUrl,
        featureFlags: {
          'welcomepage.enabled': false,
          'prejoinpage.enabled': true,
          'recording.enabled': false, // Privacy compliance
          'live-streaming.enabled': false,
        },
      );

      await JitsiMeetWrapper.joinMeeting(
        options: options,
        listener: JitsiMeetingListener(
          onOpened: () => debugPrint('Jitsi meeting opened'),
          onClosed: () => debugPrint('Jitsi meeting closed'),
          onParticipantJoined: (email, name, role, participantId) {
            debugPrint('Participant joined: $email');
          },
          onParticipantLeft: (participantId) {
            debugPrint('Participant left: $participantId');
          },
        ),
      );
    } catch (e) {
      debugPrint('Error joining consultation: $e');
      rethrow;
    }
  }
}
