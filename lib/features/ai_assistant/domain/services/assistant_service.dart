class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();
}

class AssistantService {
  final List<ChatMessage> _history = [];
  List<ChatMessage> get history => _history;

  Future<String> getResponse(String input) async {
    _history.add(ChatMessage(text: input, isUser: true));

    // Simulate AI thinking delay
    await Future.delayed(const Duration(milliseconds: 600));

    String response = '';
    final lowerInput = input.toLowerCase();

    if (lowerInput.contains('exercise')) {
      response =
          'I recommend the 20-20-20 rule: every 20 minutes, look at something 20 feet away for 20 seconds. Want to start a timer?';
    } else if (lowerInput.contains('fatigue') || lowerInput.contains('tired')) {
      response =
          "It sounds like you're experiencing digital fatigue. Let's enable 'Comfort Mode' and take a 5-minute hydration break.";
    } else if (lowerInput.contains('travel') || lowerInput.contains('motion')) {
      response =
          "Traveling can be tough on the eyes. I've enabled Travel Mode for you to reduce eye strain from vehicle vibrations.";
    } else if (lowerInput.contains('posture')) {
      response =
          "Good posture is key! Try keeping your screen at eye level and about an arm's length away.";
    } else {
      response =
          "I'm your EyeVerse AI. I can help with eye exercises, travel wellness, and screen habit tracking. How can I assist you today?";
    }

    _history.add(ChatMessage(text: response, isUser: false));
    return response;
  }
}
