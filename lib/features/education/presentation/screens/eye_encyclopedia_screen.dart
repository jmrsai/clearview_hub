import 'package:flutter/material.dart';
import 'package:clearview_hub/core/theme/app_colors.dart';

class EyeEncyclopediaScreen extends StatefulWidget {
  const EyeEncyclopediaScreen({super.key});

  @override
  State<EyeEncyclopediaScreen> createState() => _EyeEncyclopediaScreenState();
}

class _EyeEncyclopediaScreenState extends State<EyeEncyclopediaScreen> {
  final List<Map<String, String>> _conditions = [
    {
      'title': 'Cataracts',
      'description': 'Clouding of the normally clear lens of the eye.',
      'symptoms': 'Blurry vision, faded colors, glare from lights, poor night vision.',
      'prevention': 'Wear sunglasses (UV protection), quit smoking, manage diabetes.'
    },
    {
      'title': 'Glaucoma',
      'description': 'A group of eye conditions that damage the optic nerve, often due to abnormally high pressure in the eye.',
      'symptoms': 'Often none initially. Later: peripheral vision loss, tunnel vision. Acute cases: severe eye pain, nausea, halos around lights.',
      'prevention': 'Regular comprehensive eye exams are crucial for early detection.'
    },
    {
      'title': 'Age-Related Macular Degeneration (AMD)',
      'description': 'Deterioration of the macula, the small central area of the retina that controls visual acuity.',
      'symptoms': 'Blurry or dark spot in the center of the visual field, straight lines appearing wavy.',
      'prevention': 'Diet rich in leafy greens and fish, avoid smoking, exercise regularly.'
    },
    {
      'title': 'Diabetic Retinopathy',
      'description': 'A diabetes complication that affects eyes. It\'s caused by damage to the blood vessels of the light-sensitive tissue at the back of the eye (retina).',
      'symptoms': 'Spots or dark strings floating in vision (floaters), blurred vision, fluctuating vision.',
      'prevention': 'Strict control of blood sugar and blood pressure, annual dilated eye exams.'
    },
    {
      'title': 'Dry Eye Syndrome',
      'description': 'A condition in which a person doesn\'t have enough quality tears to lubricate and nourish the eye.',
      'symptoms': 'A scratchy feeling, burning, stinging, redness, stringy mucus, sensitivity to light.',
      'prevention': 'Use artificial tears, take screen breaks (20-20-20 rule), use a humidifier.'
    },
  ];

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredConditions = _conditions.where((condition) {
      return condition['title']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             condition['description']!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Eye Encyclopedia'),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search conditions...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: AppColors.surfaceDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredConditions.length,
              itemBuilder: (context, index) {
                final condition = filteredConditions[index];
                return _buildConditionCard(condition);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionCard(Map<String, String> condition) {
    return Card(
      color: AppColors.surfaceDark,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        title: Text(
          condition['title']!,
          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        iconColor: AppColors.primary,
        collapsedIconColor: Colors.white54,
        childrenPadding: const EdgeInsets.all(16),
        children: [
          _buildDetailRow('Description', condition['description']!),
          const SizedBox(height: 12),
          _buildDetailRow('Symptoms', condition['symptoms']!),
          const SizedBox(height: 12),
          _buildDetailRow('Prevention & Care', condition['prevention']!),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
        ),
      ],
    );
  }
}
