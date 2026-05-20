import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class ReportExportService {
  static Future<void> generateAndShareClinicalReport({
    required double eyeStrainScore,
    required double mentalFatigueScore,
    required double postureHealth,
    required String recommendation,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                text: 'ClearView Hub - Clinical Eye Health Report',
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Date: ${DateTime.now().toLocal().toString().split(' ')[0]}',
                style: const pw.TextStyle(fontSize: 14),
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Biometric Summary (7-Day Average)', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                    pw.Text('Eye Strain Level: ${eyeStrainScore.toStringAsFixed(1)}%'),
                    pw.SizedBox(height: 5),
                    pw.Text('Mental Fatigue Index: ${mentalFatigueScore.toStringAsFixed(1)}%'),
                    pw.SizedBox(height: 5),
                    pw.Text('Posture Health (Neck Angle): ${postureHealth.toStringAsFixed(1)}%'),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('AI Assessment & Recommendation:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text(recommendation),
              pw.Spacer(),
              pw.Divider(),
              pw.Text(
                'Disclaimer: This report is generated automatically by ClearView Hub based on local sensor data. It does not constitute a formal medical diagnosis.',
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
              ),
            ],
          );
        },
      ),
    );

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/clinical_eye_report.pdf');
      await file.writeAsBytes(await pdf.save());

      // Share the file
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'My ClearView Hub Clinical Report',
      );
    } catch (e) {
      print("Error generating PDF: $e");
    }
  }
}
