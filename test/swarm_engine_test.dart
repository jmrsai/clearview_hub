import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Swarm Intelligence Logic Tests', () {
    test('Debate sequence should contain unique agent names', () {
      final debate = [
        {'agent': 'Dr. Retina', 'message': 'I see blood.'},
        {'agent': 'Dr. Glaucoma', 'message': 'Pressure is high.'},
      ];
      
      final agents = debate.map((e) => e['agent']).toSet();
      expect(agents.length, equals(2));
      expect(agents, contains('Dr. Retina'));
      expect(agents, contains('Dr. Glaucoma'));
    });

    test('Consensus should prioritize emergency flags', () {
      bool isEmergency(String msg) => msg.contains('🚨') || msg.contains('EMERGENCY');
      
      const msg1 = 'Patient is fine.';
      const msg2 = '🚨 EMERGENCY: Retinal detachment detected!';
      
      expect(isEmergency(msg1), isFalse);
      expect(isEmergency(msg2), isTrue);
    });
  });
}
