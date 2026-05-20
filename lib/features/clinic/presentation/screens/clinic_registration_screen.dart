import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../widgets/glass_card.dart';
import '../../../../models/patient.dart';

class ClinicRegistrationScreen extends ConsumerStatefulWidget {
  const ClinicRegistrationScreen({super.key});

  @override
  ConsumerState<ClinicRegistrationScreen> createState() =>
      _ClinicRegistrationScreenState();
}

class _ClinicRegistrationScreenState
    extends ConsumerState<ClinicRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _gender = 'Male';
  String? _generatedId;

  void _registerPatient() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _generatedId = const Uuid().v4();
      });

      // TODO: Save patient to local Hive/SQLite database
      final newPatient = Patient(
        id: _generatedId!,
        name: _nameController.text,
        dateOfBirth: DateTime.now().subtract(
          Duration(days: int.parse(_ageController.text) * 365),
        ),
        gender: _gender,
      );

      _showRegistrationSuccess(newPatient);
    }
  }

  void _showRegistrationSuccess(Patient patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        title: const Text(
          'Patient Registered',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Unique Patient ID generated:',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            QrImageView(
              data: patient.id,
              version: QrVersions.auto,
              size: 200.0,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              patient.id,
              style: const TextStyle(fontSize: 10, color: Colors.cyan),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('DONE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clinic Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Icon(Icons.person_add_alt_1, size: 64, color: Colors.cyan),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _gender,
                dropdownColor: const Color(0xFF16213E),
                style: const TextStyle(color: Colors.white),
                items: ['Male', 'Female', 'Other']
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (v) => setState(() => _gender = v!),
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _registerPatient,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('REGISTER & GENERATE ID'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
