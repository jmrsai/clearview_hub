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
import 'package:flutter/services.dart';
import '../../core/services/telemedicine_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import 'doctor_profile_screen.dart';

class TelemedicineHub extends StatefulWidget {
  const TelemedicineHub({super.key});
  @override
  State<TelemedicineHub> createState() => _TelemedicineHubState();
}

class _TelemedicineHubState extends State<TelemedicineHub> with SingleTickerProviderStateMixin {
  late TabController _tab;
  bool _seeding = false;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _seedDoctors();
  }

  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  Future<void> _seedDoctors() async {
    setState(() => _seeding = true);
    await TelemedicineService.instance.seedDemoDoctors();
    if (mounted) setState(() => _seeding = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E1A),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Telemedicine', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
          Text('Consult certified ophthalmologists', style: TextStyle(color: AppColors.cyan, fontSize: 11)),
        ]),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: AppColors.cyan,
          labelColor: AppColors.cyan,
          unselectedLabelColor: AppColors.textHint,
          tabs: const [Tab(text: 'Find Doctors'), Tab(text: 'My Consultations')],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _DoctorsTab(seeding: _seeding),
          const _ConsultationsTab(),
        ],
      ),
    );
  }
}

class _DoctorsTab extends StatefulWidget {
  final bool seeding;
  const _DoctorsTab({required this.seeding});
  @override
  State<_DoctorsTab> createState() => _DoctorsTabState();
}

class _DoctorsTabState extends State<_DoctorsTab> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          style: const TextStyle(color: Colors.white),
          onChanged: (v) => setState(() => _search = v.toLowerCase()),
          decoration: InputDecoration(
            hintText: 'Search by name or specialty...',
            hintStyle: TextStyle(color: AppColors.textHint),
            prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
            filled: true, fillColor: const Color(0xFF1E2235),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          ),
        ),
      ),
      if (widget.seeding)
        const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator(color: AppColors.cyan)),
      Expanded(
        child: StreamBuilder<List<TeleDoctorProfile>>(
          stream: TelemedicineService.instance.getDoctors(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting && !widget.seeding) {
              return const Center(child: CircularProgressIndicator(color: AppColors.cyan));
            }
            final all = snap.data ?? [];
            final filtered = _search.isEmpty ? all : all.where((d) =>
              d.name.toLowerCase().contains(_search) ||
              d.specialization.toLowerCase().contains(_search)).toList();
            if (filtered.isEmpty) {
              return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.medical_services_outlined, size: 56, color: AppColors.textHint),
                const SizedBox(height: 16),
                Text('No doctors found', style: TextStyle(color: AppColors.textSecondary)),
              ]));
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: filtered.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _DoctorCard(doctor: filtered[i]),
            );
          },
        ),
      ),
    ]);
  }
}

class _DoctorCard extends StatelessWidget {
  final TeleDoctorProfile doctor;
  const _DoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorProfileScreen(doctor: doctor)));
      },
      child: AdaptiveCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(child: Text(doctor.avatarEmoji, style: const TextStyle(fontSize: 28))),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(doctor.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
              Text(doctor.specialization, style: TextStyle(color: AppColors.cyan, fontSize: 12, fontWeight: FontWeight.w600)),
              Text(doctor.clinicName, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.star, color: Color(0xFFF59E0B), size: 14),
                const SizedBox(width: 3),
                Text(doctor.rating.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
              ]),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: doctor.isAvailable ? const Color(0xFF10B981).withAlpha(30) : const Color(0xFF94A3B8).withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(doctor.isAvailable ? 'Available' : 'Busy',
                    style: TextStyle(color: doctor.isAvailable ? const Color(0xFF10B981) : AppColors.textHint, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ]),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            _InfoChip(Icons.people, '${(doctor.totalConsultations / 1000).toStringAsFixed(1)}k consults'),
            const SizedBox(width: 8),
            _InfoChip(Icons.language, doctor.languages.first),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('₹${doctor.fee}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
            ),
          ]),
        ]),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip(this.icon, this.label);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: const Color(0xFF1E2235), borderRadius: BorderRadius.circular(8)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 12, color: AppColors.textSecondary),
      const SizedBox(width: 4),
      Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
    ]),
  );
}

class _ConsultationsTab extends StatelessWidget {
  const _ConsultationsTab();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Consultation>>(
      stream: TelemedicineService.instance.getMyConsultations(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.cyan));
        }
        final items = snap.data ?? [];
        if (items.isEmpty) {
          return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.video_call_outlined, size: 64, color: AppColors.textHint),
            const SizedBox(height: 16),
            const Text('No consultations yet', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Book your first doctor consultation above.', style: TextStyle(color: AppColors.textSecondary)),
          ]));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (_, i) => _ConsultationCard(consultation: items[i]),
        );
      },
    );
  }
}

class _ConsultationCard extends StatelessWidget {
  final Consultation consultation;
  const _ConsultationCard({required this.consultation});

  @override
  Widget build(BuildContext context) {
    final statusColor = consultation.status == 'confirmed' ? AppColors.success
        : consultation.status == 'pending' ? AppColors.warning : AppColors.textHint;
    return AdaptiveCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(consultation.doctorName,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: statusColor.withAlpha(30), borderRadius: BorderRadius.circular(12)),
            child: Text(consultation.status.toUpperCase(),
                style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 8),
        Text(consultation.chiefComplaint, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 8),
        Text('📅 ${consultation.appointmentTime.day}/${consultation.appointmentTime.month}/${consultation.appointmentTime.year} at ${consultation.appointmentTime.hour}:${consultation.appointmentTime.minute.toString().padLeft(2, '0')}',
            style: TextStyle(color: AppColors.textHint, fontSize: 12)),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => TelemedicineService.instance.joinVideoCall(consultation.meetLink),
          icon: const Icon(Icons.video_call, size: 16),
          label: const Text('Join Video Call'),
          style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
        ),
      ]),
    );
  }
}
