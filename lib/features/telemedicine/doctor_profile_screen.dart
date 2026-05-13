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
import '../../core/services/telemedicine_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

class DoctorProfileScreen extends StatefulWidget {
  final TeleDoctorProfile doctor;
  const DoctorProfileScreen({super.key, required this.doctor});
  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  final _complaintCtrl = TextEditingController();
  DateTime _selectedTime = DateTime.now().add(const Duration(hours: 2));
  bool _booking = false;

  Future<void> _book() async {
    if (_complaintCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe your concern.')),
      );
      return;
    }
    setState(() => _booking = true);
    try {
      await TelemedicineService.instance.bookConsultation(
        doctorId: widget.doctor.uid,
        doctorName: widget.doctor.name,
        appointmentTime: _selectedTime,
        chiefComplaint: _complaintCtrl.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Consultation booked successfully!'), backgroundColor: AppColors.success),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
    if (mounted) setState(() => _booking = false);
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.doctor;
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            backgroundColor: const Color(0xFF0A0E1A),
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF0EA5E9)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const SizedBox(height: 60),
                  Text(d.avatarEmoji, style: const TextStyle(fontSize: 72)),
                  Text(d.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                  Text(d.specialization, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                ]),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats row
                Row(children: [
                  _StatItem('⭐ ${d.rating}', 'Rating'),
                  _StatItem('${(d.totalConsultations / 1000).toStringAsFixed(1)}k', 'Consultations'),
                  _StatItem('₹${d.fee}', 'Per Session'),
                ]),
                const SizedBox(height: 20),
                // Languages
                AdaptiveCard(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Languages', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Wrap(spacing: 8, children: d.languages.map((l) => Chip(
                      label: Text(l, style: TextStyle(color: AppColors.cyan, fontSize: 12)),
                      backgroundColor: AppColors.cyanDim,
                    )).toList()),
                  ]),
                ),
                const SizedBox(height: 14),
                AdaptiveCard(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('About', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text(d.bio, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5)),
                  ]),
                ),
                const SizedBox(height: 24),
                const Text('Book Consultation', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
                const SizedBox(height: 14),
                TextField(
                  controller: _complaintCtrl,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Chief complaint / reason for visit',
                    hintText: 'e.g. Blurry vision for 2 weeks, eye pain, follow-up...',
                  ),
                ),
                const SizedBox(height: 14),
                ListTile(
                  tileColor: const Color(0xFF1E2235),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  leading: const Icon(Icons.calendar_today, color: AppColors.cyan),
                  title: Text(
                    '${_selectedTime.day}/${_selectedTime.month}/${_selectedTime.year} at ${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('Tap to change', style: TextStyle(color: AppColors.textHint, fontSize: 12)),
                  onTap: () async {
                    final picked = await showDateTimePicker(context, _selectedTime);
                    if (picked != null && mounted) setState(() => _selectedTime = picked);
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _booking ? null : _book,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.violet,
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  icon: _booking
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.video_call, color: Colors.white),
                  label: Text(_booking ? 'Booking...' : 'Confirm Consultation',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                ),
                const SizedBox(height: 8),
                const Text(
                  '* A Google Meet link will be shared after confirmation.\n* Consultation fee paid at the clinic/platform.',
                  style: TextStyle(color: AppColors.textHint, fontSize: 11),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

Future<DateTime?> showDateTimePicker(BuildContext context, DateTime initial) async {
  final date = await showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 30)),
  );
  if (date == null) return null;
  if (!context.mounted) return null;
  final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(initial));
  if (time == null) return null;
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem(this.value, this.label);
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFF1E2235), borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
        Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
      ]),
    ),
  );
}
