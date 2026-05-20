import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class GoogleDriveBackupService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [drive.DriveApi.driveFileScope],
  );

  /// Authenticate and return Drive API client.
  Future<drive.DriveApi?> _getDriveApi() async {
    final account = await _googleSignIn.signIn();
    if (account == null) return null;

    final authHeaders = await account.authHeaders;
    final authenticateClient = _GoogleAuthClient(authHeaders);
    return drive.DriveApi(authenticateClient);
  }

  /// Exports local data to user's Google Drive.
  Future<void> backupLocalData() async {
    final api = await _getDriveApi();
    if (api == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final hiveFile = File('${directory.path}/eye_health_logs.hive');

    if (await hiveFile.exists()) {
      var driveFile = drive.File();
      driveFile.name =
          'EyeVerseAI_Backup_${DateTime.now().toIso8601String()}.hive';

      final media = drive.Media(hiveFile.openRead(), await hiveFile.length());
      await api.files.create(driveFile, uploadMedia: media);
    }
  }
}

class _GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  _GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}
