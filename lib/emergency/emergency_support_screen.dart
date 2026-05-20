import 'package:flutter/material.dart';
import '../../widgets/glass_card.dart';

class EmergencySupportScreen extends StatelessWidget {
  const EmergencySupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SOS & Emergency Support')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSOSButton(),
            const SizedBox(height: 30),
            _buildNearbyHospitals(),
            const SizedBox(height: 20),
            _buildFirstAidInstructions(),
          ],
        ),
      ),
    );
  }

  Widget _buildSOSButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.redAccent.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          const Icon(Icons.emergency, color: Colors.redAccent, size: 64),
          const SizedBox(height: 16),
          const Text(
            'SOS EMERGENCY CALL',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Connect immediately to local emergency services.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'CALL 911 NOW',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyHospitals() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.local_hospital, color: Colors.cyan),
              SizedBox(width: 8),
              Text(
                'Nearby Eye Clinics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.white12,
              child: Icon(Icons.location_on, color: Colors.cyan),
            ),
            title: const Text('City Eye Hospital'),
            subtitle: const Text('2.5 km away • Open 24/7'),
            trailing: IconButton(
              icon: const Icon(Icons.directions),
              onPressed: () {},
            ),
          ),
          const Divider(color: Colors.white10),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.white12,
              child: Icon(Icons.location_on, color: Colors.cyan),
            ),
            title: const Text('Vision Plus Clinic'),
            subtitle: const Text('4.1 km away • Closes at 8 PM'),
            trailing: IconButton(
              icon: const Icon(Icons.directions),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFirstAidInstructions() {
    return const GlassCard(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'First Aid: Chemical in Eye',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            '1. Immediately flush the eye with clean water for at least 15 minutes.\n2. Do not rub the eye.\n3. Seek medical help immediately.',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
