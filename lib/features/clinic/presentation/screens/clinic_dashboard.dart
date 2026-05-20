import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../../widgets/glass_card.dart';

class ClinicDashboard extends StatelessWidget {
  const ClinicDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Portable Eye Clinic')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildActionCard(
              context,
              'Register New Patient',
              'Generate unique QR IDs for rural outreach.',
              Icons.person_add,
              Colors.cyan,
              '/clinic/registration',
            ),
            const SizedBox(height: 16),
            _buildActionCard(
              context,
              'Retina Screening',
              'Capture high-res retina images for AI triage.',
              Icons.remove_red_eye,
              Colors.blueAccent,
              '/clinic/retina_capture',
            ),
            const SizedBox(height: 16),
            _buildActionCard(
              context,
              'Camp Management',
              'Manage outreach programs and community data.',
              Icons.campaign,
              Colors.orangeAccent,
              null,
            ),
            const SizedBox(height: 32),
            const Text(
              'Recent Reports',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildRecentReportItem('John Doe', '2026-05-16', 'Normal'),
            _buildRecentReportItem('Jane Smith', '2026-05-15', 'Cataract Risk'),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String desc,
    IconData icon,
    Color color,
    String? route,
  ) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: InkWell(
        onTap: () => route != null ? context.push(route) : null,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    desc,
                    style: const TextStyle(fontSize: 12, color: Colors.white60),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentReportItem(String name, String date, String status) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white12,
              child: Icon(Icons.description, color: Colors.white70),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Date: $date • Status: $status',
                    style: const TextStyle(fontSize: 11, color: Colors.white60),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.print, color: Colors.cyan),
              onPressed: () => _generatePdfReport(name, date, status),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generatePdfReport(
    String name,
    String date,
    String status,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Column(
            children: [
              pw.Text(
                'EyeVerse AI - Diagnostic Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Patient Name: $name'),
              pw.Text('Date: $date'),
              pw.Text('Status: $status'),
              pw.SizedBox(height: 40),
              pw.Text(
                'Disclaimer: AI results are for wellness awareness only and are not a medical diagnosis.',
              ),
            ],
          ),
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
