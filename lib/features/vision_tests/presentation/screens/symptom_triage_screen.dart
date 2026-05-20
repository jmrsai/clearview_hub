import 'package:flutter/material.dart';
import 'package:clearview_hub/core/theme/app_colors.dart';

class SymptomTriageScreen extends StatefulWidget {
  const SymptomTriageScreen({super.key});

  @override
  State<SymptomTriageScreen> createState() => _SymptomTriageScreenState();
}

class _SymptomTriageScreenState extends State<SymptomTriageScreen> {
  String? _selectedSymptom;

  final Map<String, Map<String, dynamic>> _triageData = {
    'Redness': {
      'icon': Icons.visibility,
      'severity': 'Mild/Moderate',
      'color': Colors.orange,
      'advice': 'Redness can be caused by allergies, dryness, or infection. Try a cold compress or artificial tears. If accompanied by severe pain or vision loss, seek medical help immediately.',
    },
    'Severe Pain': {
      'icon': Icons.flash_on,
      'severity': 'Emergency',
      'color': Colors.red,
      'advice': 'Severe eye pain is a medical emergency. Do not wait. Go to the nearest emergency room or consult an ophthalmologist immediately.',
    },
    'Flashes or Floaters': {
      'icon': Icons.flare,
      'severity': 'Urgent',
      'color': Colors.deepOrange,
      'advice': 'A sudden onset of new floaters or flashes of light could indicate a retinal tear or detachment. See an eye care professional within 24 hours.',
    },
    'Grittiness/Dryness': {
      'icon': Icons.grain,
      'severity': 'Mild',
      'color': Colors.yellow,
      'advice': 'This is common with digital eye strain. Use the 20-20-20 rule, blink frequently, and consider preservative-free lubricating eye drops.',
    },
    'Sudden Vision Loss': {
      'icon': Icons.visibility_off,
      'severity': 'Emergency',
      'color': Colors.red,
      'advice': 'Sudden loss of vision, even if it returns, is a medical emergency. Seek immediate medical attention.',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Quick Symptom Triage'),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.error.withValues(alpha: 0.1),
            child: const Row(
              children: [
                Icon(Icons.warning, color: AppColors.error),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'DISCLAIMER: This tool does not provide medical diagnoses. If you have a severe injury or sudden vision change, seek emergency care.',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'What are you experiencing right now?',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _triageData.keys.map((symptom) => _buildSymptomCard(symptom)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomCard(String symptom) {
    final isSelected = _selectedSymptom == symptom;
    final data = _triageData[symptom]!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? data['color'] : Colors.white10,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: data['color'].withValues(alpha: 0.2),
              child: Icon(data['icon'], color: data['color']),
            ),
            title: Text(symptom, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            trailing: Icon(
              isSelected ? Icons.expand_less : Icons.expand_more,
              color: Colors.white54,
            ),
            onTap: () {
              setState(() {
                _selectedSymptom = isSelected ? null : symptom;
              });
            },
          ),
          if (isSelected)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Divider(color: Colors.white10),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: data['color'],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          data['severity'],
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data['advice'],
                    style: const TextStyle(color: Colors.white, height: 1.5),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
