/*
 * Copyright 2026 ClearView Hub Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

class MediWikiScreen extends StatefulWidget {
  const MediWikiScreen({super.key});

  @override
  State<MediWikiScreen> createState() => _MediWikiScreenState();
}

class _MediWikiScreenState extends State<MediWikiScreen> {
  final List<Map<String, String>> _articles = [
    {
      'title': 'Glaucoma',
      'category': 'Diseases',
      'summary': 'A group of eye conditions that damage the optic nerve, the health of which is vital for good vision.',
      'content': 'Glaucoma is often caused by an abnormally high pressure in your eye. It is one of the leading causes of blindness for people over the age of 60. It can occur at any age but is more common in older adults. Many forms of glaucoma have no warning signs. The effect is so gradual that you may not notice a change in vision until the condition is at an advanced stage.',
    },
    {
      'title': 'Cataracts',
      'category': 'Diseases',
      'summary': 'A clouding of the normally clear lens of the eye.',
      'content': 'For people who have cataracts, seeing through cloudy lenses is a bit like looking through a frosty or fogged-up window. Clouded vision caused by cataracts can make it more difficult to read, drive a car (especially at night) or see the expression on a friend\'s face. Most cataracts develop slowly and don\'t disturb your eyesight early on.',
    },
    {
      'title': 'Macular Degeneration',
      'category': 'Diseases',
      'summary': 'A common eye disorder among people over age 50 that causes blurred or reduced central vision.',
      'content': 'Age-related macular degeneration (AMD) is a major cause of vision loss in people over age 50. It happens when the macula — the part of the retina that controls sharp, straight-ahead vision — is damaged over time. It does not cause complete blindness, but it can make it harder to see faces, read, drive, or do close-up work like sewing or fixing things.',
    },
    {
      'title': 'Diabetic Retinopathy',
      'category': 'Complications',
      'summary': 'A diabetes complication that affects eyes, caused by damage to the blood vessels of the light-sensitive tissue at the back of the eye.',
      'content': 'At first, diabetic retinopathy might cause no symptoms or only mild vision problems. But it can eventually cause blindness. The condition can develop in anyone who has type 1 or type 2 diabetes. The longer you have diabetes and the less controlled your blood sugar is, the more likely you are to develop this eye complication.',
    },
    {
      'title': 'Refractive Errors',
      'category': 'Vision',
      'summary': 'Common eye problems that happen when the shape of your eye keeps light from focusing correctly on your retina.',
      'content': 'The most common types of refractive errors are: \n\n• Myopia (nearsightedness): clear vision up close but blurry in the distance.\n• Hyperopia (farsightedness): clear vision in the distance but blurry up close.\n• Presbyopia: inability to focus up close as a result of aging.\n• Astigmatism: focus problems caused by an unevenly curved cornea.',
    },
    {
      'title': '20-20-20 Rule',
      'category': 'Wellness',
      'summary': 'A simple technique to reduce digital eye strain.',
      'content': 'To help prevent digital eye strain, follow the 20-20-20 rule: Every 20 minutes, look at something 20 feet away for at least 20 seconds. This gives your eye muscles a much-needed break and helps maintain a healthy blink rate, which keeps your eyes lubricated.',
    },
    {
      'title': 'Eye Chambers & Aqueous Humor',
      'category': 'Anatomy',
      'summary': 'Detailed look at the anterior and posterior chambers and the flow of aqueous humor.',
      'content': 'The eye is divided into segments and chambers. The anterior segment includes the anterior and posterior chambers. \n\n• Anterior Chamber: The space between the cornea and the iris. \n• Posterior Chamber: The narrow space behind the iris and in front of the lens. \n\nBoth chambers are filled with aqueous humor, a clear fluid produced by the ciliary body. This fluid flows from the posterior chamber through the pupil into the anterior chamber, where it drains through the trabecular meshwork into the Canal of Schlemm. Proper flow is essential for maintaining Intraocular Pressure (IOP).',
    },
  ];

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _articles.where((a) => 
      a['title']!.toLowerCase().contains(_searchQuery.toLowerCase()) || 
      a['category']!.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return AdaptiveScaffold(
      appBar: AppBar(title: const Text('Medi Wiki')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: AdaptiveCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: const InputDecoration(
                    hintText: 'Search conditions, symptoms...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: AppColors.cyan),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filtered.length,
                itemBuilder: (ctx, index) {
                  final a = filtered[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AdaptiveCard(
                      child: ExpansionTile(
                        title: Text(a['title']!, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.cyan)),
                        subtitle: Text(a['category']!, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(a['summary']!, style: const TextStyle(fontWeight: FontWeight.w600, fontStyle: FontStyle.italic)),
                                const SizedBox(height: 12),
                                Text(a['content']!, style: const TextStyle(height: 1.6)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
