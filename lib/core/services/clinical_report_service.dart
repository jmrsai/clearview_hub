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

import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../models/patient.dart';
import '../../core/database/database_helper.dart';
import 'audit_service.dart';

class ClinicalReportService {
  ClinicalReportService._();
  static final ClinicalReportService instance = ClinicalReportService._();

  /// Generates a professional PDF clinical summary for a patient.
  Future<Uint8List> generatePdfReport(Patient patient) async {
    final tests = await DatabaseHelper.instance.getVisionTestsForPatient(patient.id);
    final exams = await DatabaseHelper.instance.getExamsForPatient(patient.id);
    
    await AuditService.instance.logAction(
      action: 'GENERATE_REPORT',
      resource: 'PATIENT_${patient.id}',
      details: 'PDF clinical summary generated',
    );

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('CLEARVIEW MEDICAL HUB', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18, color: PdfColors.blue800)),
                  pw.Text('CLINICAL SUMMARY', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('PATIENT INFORMATION', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Divider(thickness: 1),
                      pw.Text('Name: ${patient.name}'),
                      pw.Text('Age: ${patient.age}'),
                      pw.Text('Gender: ${patient.gender}'),
                      pw.Text('Patient ID: ${patient.id}'),
                    ],
                  ),
                ),
                pw.SizedBox(width: 40),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('CLINICAL DETAILS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Divider(thickness: 1),
                      pw.Text('Diagnosis: ${patient.diagnosis ?? 'N/A'}'),
                      pw.Text('Report Date: ${DateTime.now().toLocal().toString().split('.')[0]}'),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 30),
            pw.Text('DIAGNOSTIC HISTORY', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
            pw.Divider(thickness: 1.5),
            pw.SizedBox(height: 10),
            if (tests.isEmpty)
              pw.Text('No diagnostic tests performed.')
            else
              pw.TableHelper.fromTextArray(
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                context: context,
                data: <List<String>>[
                  <String>['Date', 'Test Type', 'Result / Acuity'],
                  ...tests.reversed.map((t) => [
                    t.performedAt.toLocal().toString().split(' ')[0],
                    t.testType.toUpperCase(),
                    t.testType == 'snellen' ? 'L: ${t.acuityLeft} | R: ${t.acuityRight}' : 'Completed',
                  ]),
                ],
              ),
            pw.SizedBox(height: 30),
            pw.Text('EXAMINATION RECORDS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
            pw.Divider(thickness: 1.5),
            pw.SizedBox(height: 10),
            if (exams.isEmpty)
              pw.Text('No clinical examinations recorded.')
            else
              pw.TableHelper.fromTextArray(
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                context: context,
                data: <List<String>>[
                  <String>['Date', 'VA (OS/OD)', 'IOP (L/R)', 'Notes'],
                  ...exams.reversed.map((e) => [
                    e.date.toLocal().toString().split(' ')[0],
                    '${e.visualAcuityLeft} / ${e.visualAcuityRight}',
                    '${e.intraocularPressureLeft} / ${e.intraocularPressureRight} mmHg',
                    e.notes.length > 20 ? '${e.notes.substring(0, 17)}...' : e.notes,
                  ]),
                ],
              ),
            pw.Spacer(),
            pw.Divider(thickness: 0.5),
            pw.Text(
              'DISCLAIMER: This report is generated by ClearView Medical Hub AI-assisted screening tools. It is intended for clinical review by qualified medical practitioners and is NOT a definitive diagnosis.',
              style: pw.TextStyle(fontSize: 8, fontStyle: pw.FontStyle.italic),
              textAlign: pw.TextAlign.center,
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  /// Prints the report or opens share dialog.
  Future<void> printReport(Patient patient, Uint8List pdfBytes) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: 'Report_${patient.name.replaceAll(' ', '_')}',
    );
  }

  /// Generates a comprehensive clinical summary text (kept for legacy support).
  Future<String> generateSummary(Patient patient) async {
    final tests = await DatabaseHelper.instance.getVisionTestsForPatient(patient.id);
    
    final sb = StringBuffer();
    sb.writeln('========================================');
    sb.writeln('     CLEARVIEW HUB - CLINICAL REPORT    ');
    sb.writeln('========================================');
    sb.writeln('Generated: ${DateTime.now().toLocal()}');
    sb.writeln('');
    sb.writeln('PATIENT INFORMATION');
    sb.writeln('Name: ${patient.name}');
    sb.writeln('Age: ${patient.age}');
    sb.writeln('Gender: ${patient.gender}');
    sb.writeln('MRN: ${patient.id}');
    sb.writeln('Diagnosis: ${patient.diagnosis ?? 'None recorded'}');
    sb.writeln('');
    sb.writeln('DIAGNOSTIC HISTORY');
    sb.writeln('----------------------------------------');
    
    if (tests.isEmpty) {
      sb.writeln('No diagnostic tests performed.');
    } else {
      for (var t in tests.reversed) {
        sb.writeln('[${t.performedAt.toLocal().toString().split(' ')[0]}] ${t.testType.toUpperCase()}');
        if (t.testType == 'snellen') {
          sb.writeln('  Acuity: L: ${t.acuityLeft} | R: ${t.acuityRight}');
          sb.writeln('  Score: ${t.correctAnswers}/${t.totalQuestions}');
        } else if (t.testType == 'amsler') {
          sb.writeln('  Grid Result: Distortion Map recorded');
        } else if (t.testType == 'color') {
          sb.writeln('  Color Vision: Score ${t.correctAnswers}/${t.totalQuestions}');
        }
        sb.writeln('');
      }
    }
    
    sb.writeln('----------------------------------------');
    sb.writeln('DISCLAIMER: This report is generated by an AI-assisted screening tool.');
    sb.writeln('It is NOT a definitive diagnosis. Please consult a qualified ophthalmologist.');
    sb.writeln('========================================');
    
    return sb.toString();
  }

  /// Saves content to a local file.
  Future<String> saveReportToFile(Patient patient, String content) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/report_${patient.id}_${DateTime.now().millisecondsSinceEpoch}.txt');
    await file.writeAsString(content);
    return file.path;
  }
}
