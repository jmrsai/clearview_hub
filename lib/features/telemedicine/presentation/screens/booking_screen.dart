import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/telemedicine_provider.dart';
import '../../domain/entities/doctor.dart';
import '../../../../widgets/glass_card.dart';
import '../../../../core/theme/app_colors.dart';

class BookingScreen extends StatefulWidget {
  final Doctor doctor;

  const BookingScreen({super.key, required this.doctor});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule Consultation')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDoctorSummary(),
            const SizedBox(height: 32),
            const Text('Select Date & Time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            _buildDatePicker(),
            const SizedBox(height: 32),
            const Text('Reason for Visit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'e.g., Eye fatigue for 3 days, blurry vision in the morning...',
              ),
            ),
            const SizedBox(height: 40),
            Consumer(
              builder: (context, ref, child) {
                final status = ref.watch(telemedicineControllerProvider);
                return ElevatedButton(
                  onPressed: status.isLoading ? null : () => _confirmBooking(ref),
                  child: status.isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Confirm Booking'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorSummary() {
    return GlassCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: widget.doctor.avatarUrl != null ? NetworkImage(widget.doctor.avatarUrl!) : null,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.doctor.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              Text(widget.doctor.specialization, style: const TextStyle(color: AppColors.secondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 30)),
        );
        if (date != null) setState(() => _selectedDate = date);
      },
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: AppColors.secondary),
            const SizedBox(width: 16),
            Text(
              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const Spacer(),
            const Text('Change', style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _confirmBooking(WidgetRef ref) async {
    await ref.read(telemedicineControllerProvider.notifier).bookAppointment(
      doctorId: widget.doctor.id,
      date: _selectedDate,
      notes: _notesController.text,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment booked successfully!')),
      );
      context.go('/');
    }
  }
}
