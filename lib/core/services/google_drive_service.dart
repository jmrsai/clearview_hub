import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

class GoogleDriveService {
  static final GoogleDriveService _instance = GoogleDriveService._internal();
  factory GoogleDriveService() => _instance;
  GoogleDriveService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  GoogleSignInAccount? _account;

  /// Sign in with Google to gain Drive access
  Future<bool> signIn() async {
    try {
      // Version 7.2.0 uses initialize (without scopes) and then authenticate
      await _googleSignIn.initialize();
      _account = await _googleSignIn.authenticate(
        scopeHint: [drive.DriveApi.driveFileScope],
      );
      return _account != null;
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      return false;
    }
  }

  /// Get Drive API client
  Future<drive.DriveApi?> _getDriveApi() async {
    if (_account == null) {
      bool success = await signIn();
      if (!success) return null;
    }

    // In 7.2.0, use authorizationClient to get headers for specific scopes
    final authHeaders = await _account!.authorizationClient.authorizationHeaders(
      [drive.DriveApi.driveFileScope],
      promptIfNecessary: true,
    );
    
    if (authHeaders == null) return null;
    
    final authenticateClient = _GoogleAuthClient(authHeaders);
    return drive.DriveApi(authenticateClient);
  }

  /// Backup a file to Google Drive
  Future<String?> backupFile(File file, {String? folderId}) async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) return null;

    final driveFile = drive.File();
    driveFile.name = p.basename(file.path);
    if (folderId != null) {
      driveFile.parents = [folderId];
    }

    final response = await driveApi.files.create(
      driveFile,
      uploadMedia: drive.Media(file.openRead(), file.lengthSync()),
    );

    return response.id;
  }

  /// Retrieve a file from Google Drive
  Future<File?> retrieveFile(String fileId, String localPath) async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) return null;

    final drive.Media media = await driveApi.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.metadata,
    ) as drive.Media;

    final List<int> dataStore = [];
    await for (final data in media.stream) {
      dataStore.addAll(data);
    }

    final file = File(localPath);
    await file.writeAsBytes(dataStore);
    return file;
  }
}

/// Helper client to inject auth headers into HTTP requests
class _GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  _GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}
